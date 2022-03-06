# IAM Module to create Iam users
module "iam" {
  source         = "../modules/iam"
  AWS_REGION     = var.AWS_REGION
  AWS_ACCESS_KEY = var.AWS_ACCESS_KEY
  AWS_SECRET_KEY = var.AWS_SECRET_KEY
}

# Output VPC IAM user Secrets
output "this_iam_access_keys_id" {
  description = "The VPC Iam user access key ID"
  value       = "${module.iam.this_iam_access_keys_id}"
}

output "this_iam_secret_keys_id" {
  description = "The VPC Iam user secret key"
  value       = "${module.iam.this_iam_secret_keys_id}"
}
