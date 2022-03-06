/* Instance profile which will be used in the ASG launch configuration */

output "ecs_instance_profile" {
        value = "${aws_iam_instance_profile.ecs_instance_profile.arn}"
}

/* IAM Role for ECS services */
output "profile_id"{
  value = aws_iam_instance_profile.ecs_instance_profile.id
}

output "profile_name"{
  value = aws_iam_instance_profile.ecs_instance_profile.name
}

# Output VPC IAM user Secrets
output "this_iam_access_keys_id" {
  description = "The access key ID"
  value       = aws_iam_access_key.vpc.id

  depends_on = [
    aws_iam_access_key.vpc.id
  ]
}

output "this_iam_secret_keys_id" {
  description = "The secret key"
  value       = aws_iam_access_key.vpc.secret

  depends_on = [
    aws_iam_access_key.vpc.secret
  ]
}

output "exec_role_arn"{
  value = aws_iam_role.ecs-task-execution-role.arn
}

output "role_instance_id"{
  value = aws_iam_role.ecs-instance-role.id
}


output "role_arn"{
  value = aws_iam_role.ecs_service_role.arn
}

output "role_name"{
  value = aws_iam_role.ecs-instance-role.name
}

output "service_role_name"{
  value = aws_iam_role.ecs_service_role.name
}
