resource "aws_iam_instance_profile" "ecs_instance_profile" {
  name = "${var.ecs_cluster}_ecs_instance_profile"
  role =  "${aws_iam_role.ecs-instance-role.name}"
  provisioner "local-exec" {
    command = "sleep 10"
  }
}

# group definition
resource "aws_iam_group" "vpc-access-group" {
  name = "vpc-access-group"
}

# attacment policy
resource "aws_iam_policy_attachment" "vpc-access-group-attach" {
  name       = "vpc-access-group-attach"
  groups     = [aws_iam_group.vpc-access-group.name]
  policy_arn = "arn:aws:iam::aws:policy/AmazonVPCFullAccess"
}

# user
resource "aws_iam_user" "LF-VPC-user" {
  name = "LF-VPC-user"
}

# access key
resource "aws_iam_access_key" "vpc" {
  user = aws_iam_user.LF-VPC-user.name
}

# iam group membership
resource "aws_iam_group_membership" "vpc-access-group-users" {
  name = "vpc-access-group-users"
  users = [
    aws_iam_user.LF-VPC-user.name,
  ]
  group = aws_iam_group.vpc-access-group.name
}

provider "aws" {
  alias      = "vpc"
  region     = var.AWS_REGION
  access_key = aws_iam_access_key.vpc.id
  secret_key = aws_iam_access_key.vpc.secret
}



resource "aws_iam_role" "ecs-instance-role" {
    name = "ecs_instance_role"
    assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    },
    {
      "Sid": "",
      "Effect": "Allow",
      "Principal": {
        "Service": "ecs.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }

  ]
}
EOF
}

resource "aws_iam_role" "ecs-task-execution-role" {
    name = "ecs_task_execution_role"
    assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "ecs-tasks.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
}



resource "aws_iam_role_policy_attachment" "ecs_execution_role_cloudwatch" {
  role       = "${aws_iam_role.ecs-task-execution-role.id}"
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}


resource "aws_iam_role_policy" "ecs_instance_role_policy" {
    name = "ecs_instance_role_policy"
    role = aws_iam_role.ecs-instance-role.id
    policy = <<EOF
{
  "Statement": [{
    "Effect": "Allow",
    "Action": [
      "sns:*"
    ],
    "Resource": "*"
  }]
}
EOF
}

resource "aws_iam_role_policy_attachment" "ecs-instance-role-attachment" {
    role       = "${aws_iam_role.ecs-instance-role.id}"
    policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEC2ContainerServiceforEC2Role"
}

/**
 * IAM Role for ECS Service
 */

resource "aws_iam_role" "ecs_service_role" {
    name = "ecs_service_role"
    assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "ecs.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "ecs-service-role-attachment" {
    role       = "${aws_iam_role.ecs_service_role.name}"
    policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEC2ContainerServiceRole"
}


resource "aws_iam_role_policy" "ecs_service_role_policy" {
    name = "${var.name_prefix}_ecs_service_role"
    role = "${aws_iam_role.ecs_service_role.id}"
    policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "elasticloadbalancing:Describe*",
        "elasticloadbalancing:DeregisterTargets",
        "elasticloadbalancing:RegisterTargets",
        "ec2:Describe*",
        "ec2:AuthorizeSecurityGroupIngress",
        "ec2:DescribeTags",
        "ecs:CreateCluster",
        "ecs:DeregisterContainerInstance",
        "ecs:DiscoverPollEndpoint",
        "ecs:Poll",
        "ecs:RegisterContainerInstance",
        "ecs:StartTelemetrySession",
        "ecs:UpdateContainerInstancesState",
        "ecs:Submit*",
        "ecr:GetAuthorizationToken",
        "ecr:BatchCheckLayerAvailability",
        "ecr:GetDownloadUrlForLayer",
        "ecr:BatchGetImage",
        "ecs:StartTask",
        "logs:CreateLogStream",
        "logs:PutLogEvents"
      ],
      "Resource": [
        "*"
      ]
    }
  ]
}
EOF
}
