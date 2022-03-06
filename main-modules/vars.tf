#File used to declare variables for this module

variable "AWS_REGION" {

}

variable "AWS_ACCESS_KEY" {

}

variable "AWS_SECRET_KEY" {

}

variable "ECR_REPO_NAME" {

}

variable "DOCKERFILE_FOLDER" {

}

variable "image_name" {

}

variable "image_tag_metrics" {

}


variable "image_tag" {

}



variable "ecs_cluster" {
  description = "ECS cluster name"
  default = "DEFAULT LF CLUSTER"
}

variable "LF_docker_image" {

}
variable "count_webapp" {

}


variable "LF_docker_image_name"{

}
variable "LF_docker_image_tag"{

}


variable "ec2_key_name"{

}
variable "instance_type"{

}
variable "ecs_key_pair_name"{

}
variable "alarms_email"{

}

variable "vpc_cidr" {
  default = "10.0.0.0/16"
}

/*variable "public_subnet_cidr" {
  default = "10.0.1.0/24"
}

variable "private_subnet_cidr" {
  default = "10.0.0.0/19"
}*/

variable "route_cidr_block" {
  default = "0.0.0.0/0"
}

variable "tenancy" {
  default = "default"
}
