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

variable "AWS_REGION" {

}

variable "ecs_cluster" {

}



variable "ecs_key_pair_name"{

}
