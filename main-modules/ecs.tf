#build cluster
resource "aws_ecs_cluster" "LF-ecs-cluster" {
  depends_on = [null_resource.docker_build_LF]
  name = var.ecs_cluster

}

data "aws_ecs_task_definition" "LF-ecs-cluster-definition" {
  task_definition = "${aws_ecs_task_definition.LF-ecs-cluster-definition.family}"
}

data "template_file" "task_LF" {
    depends_on = [aws_ecs_cluster.LF-ecs-cluster]
    template= "${file("files/container.tpl")}"

    vars = {
        LF_docker_image = "${var.LF_docker_image_name}:${var.LF_docker_image_tag}"
    }

}

resource "aws_ecs_task_definition" "LF-ecs-cluster-definition" {
    depends_on = [aws_ecs_cluster.LF-ecs-cluster]
    family = "${var.ecs_cluster}_task_definition_family"
    cpu = 128
    memory = 256
    container_definitions = "${data.template_file.task_LF.rendered}"
    execution_role_arn = "${module.iam.exec_role_arn}"

}

/* ECS service definition */
resource "aws_ecs_service" "LF_ecs_service" {
    depends_on = [aws_ecs_task_definition.LF-ecs-cluster-definition, aws_alb_listener.alb-listener]
    name = "${var.ecs_cluster}_service"
    iam_role = "${module.iam.role_arn}"
    cluster = "${aws_ecs_cluster.LF-ecs-cluster.id}"
    task_definition = "${aws_ecs_task_definition.LF-ecs-cluster-definition.arn}"
    desired_count = 1
    deployment_minimum_healthy_percent = 0
    load_balancer {
    	target_group_arn  = "${aws_alb_target_group.ecs-target-group.arn}"
    	container_port    = 80
    	container_name    = "license-foundry"
	}


}

resource "aws_instance" "LF_EC2" {
  depends_on = [aws_ecs_cluster.LF-ecs-cluster]
  ami = "ami-9ad4dcfa"
  instance_type = "t2.micro"
  associate_public_ip_address = "true"
  key_name      = var.ecs_key_pair_name
  tags = {
    Name = "LF_EC2"
  }
  provisioner "remote-exec" {
    connection {
      host =""
      type = "ssh"
      user = "ubuntu"
      private_key = "${file("~/Downloads/LF-Key.pem")}"
      timeout = "5m"
      agent = true
    }

    inline = [
      "sudo apt-get update -y && apt-get upgrade -y",
      "sudo apt-get install docker -y",
      "sudo service docker start",
      "sudo usermod -a -G docker ec2-user"
    ]
  }
  user_data=<<EOF
    #!/bin/bash
    sudo docker run -d -p 80:80 ${var.image_name}:${var.image_tag} echo "Image created"
    echo ECS_CLUSTER="LF-ecs-cluster" > /etc/ecs/ecs.config
    start ECS_CLUSTER
EOF
  vpc_security_group_ids = ["${module.network.security_group_id}"]
  subnet_id = "${module.network.subnet_id_2}"
  iam_instance_profile        = "${module.iam.profile_name}"

}


/*
resource "null_resource" "docker_build_LF_metrics" {
  depends_on = [aws_ecs_service.LF_ecs_service]
  provisioner "local-exec" {
    command = "sudo docker build -t ${var.image_name}:${var.image_tag_metrics} ./shell_scripts/. "
  }
  provisioner "local-exec" {
    command = "sudo docker push ${var.image_name}:${var.image_tag_metrics}"
  }
}
*/
