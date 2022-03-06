ecs_cluster="LF-ecs-cluster"
AWS_REGION        = "us-west-1"
AWS_ACCESS_KEY    = "XXXX"
AWS_SECRET_KEY    = "XXXX"
ECR_REPO_NAME     = "XXX"
DOCKERFILE_FOLDER = "../"
image_name        = "XXX"
LF_docker_image   = "CCC"
image_tag         = "latest"
image_tag_metrics = "metric"
test_vpc = "$TEST_VPC"
test_network_cidr = "$TEST_NETWORK_CIDR"
test_public_01_cidr = "$TEST_PUBLIC_01_CIDR"
test_public_02_cidr = "$TEST_PUBLIC_02_CIDR"
alarms_email = "abhijitpatharkar@gmail.com"
##
# Some of these variables may be removed from this file if the default value exists
# For better understanding, let's specify all variables explicitly here
##
name_prefix = "LF-ecs-cluster"
aws_region = "us-west-1"
count_webapp = 1
desired_capacity_on_demand = 1
ec2_key_name = "key-name"
instance_type = "t2.micro"
minimum_healthy_percent_webapp = 50

##
# This is a sample (public) Docker image from which can be accessed at https://github.com/docker-training/webapp
# This sample image utilizes Flask and it's not RECOMMENDED to run it directly in production (performance degradation)
# This web server binds to port 5000
##
LF_docker_image_name = "XXX"
LF_docker_image_tag = "latest"

##


ecs_key_pair_name="XX"
