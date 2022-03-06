/* Terraform constraints */
terraform {
    required_version = ">=0.12"
}

variable "name_prefix" {
    default = "tutorial"
    description = "Name prefix for this environment."
}

variable "aws_region" {
    default = "us-west-1"

}



variable "ecs_cluster" {

}

variable "ecs_key_pair_name"{

}
variable "alarms_email"{

}
variable "image_name" {

}

variable "image_tag_metrics" {

}
