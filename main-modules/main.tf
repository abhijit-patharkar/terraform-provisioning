

module "network" {
  source     = "../modules/network"
  AWS_REGION = var.AWS_REGION
  ecs_cluster = var.ecs_cluster
  ecs_key_pair_name = var.ecs_key_pair_name
}

module "registry" {
  source    = "../modules/registry"
  ECR_REPO_NAME = var.ECR_REPO_NAME
}

module "iam" {
  source     = "../modules/iam"
  ecs_cluster = var.ecs_cluster
  ecs_key_pair_name = var.ecs_key_pair_name
  alarms_email = "mehul.malik@scriptuit.com"
  image_tag_metrics = "metric"
  image_name = "082814126327.dkr.ecr.us-west-1.amazonaws.com/lf-ecr-repository"
}

#build docker image
resource "null_resource" "docker_build_LF" {
  depends_on = [aws_ecr_repository.lf-ecr-repository]
  provisioner "local-exec" {
    command = "sudo docker build -t ${var.image_name}:${var.image_tag} ../. "
  }
  provisioner "local-exec" {
    command = "sudo docker push ${var.image_name}:${var.image_tag}"
  }
}
