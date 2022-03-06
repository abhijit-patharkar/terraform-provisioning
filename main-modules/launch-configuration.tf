resource "aws_launch_configuration" "ecs-launch-configuration" {
    name                        = "ecs-launch-configuration"
    image_id                    = "ami-9ad4dcfa"
    instance_type               = "t2.micro"
    iam_instance_profile        = "${module.iam.profile_id}"
    security_groups             = ["${module.network.security_group_id}"]
    associate_public_ip_address = "true"


    root_block_device {
      volume_type = "standard"
      volume_size = 100
      delete_on_termination = true
    }
    user_data=<<EOF
      #!/bin/bash
      sudo apt-get update -y
      sudo apt-get install docker -y
      sudo service docker start
      sudo usermod -a -G docker ec2-user
      sudo docker run -d -p 80:80 ${var.image_name}:${var.image_tag} echo "Image created"
        

      echo ECS_CLUSTER="LF-ecs-cluster" > /etc/ecs/ecs.config
EOF


    lifecycle {
      create_before_destroy = true
    }

    key_name                    = var.ecs_key_pair_name

}

output "aws_launch_configuration_name"{
  value = aws_launch_configuration.ecs-launch-configuration.name
}
