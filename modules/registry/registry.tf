# Create ECR repository
resource "aws_ecr_repository" "lf-ecr-repository" {
  name = var.ECR_REPO_NAME

  #Property to enable scanning on push for new image
  image_scanning_configuration {
    scan_on_push = true
  }
}

#The URL for ECR repository
output "repository_url" {
  value = "${aws_ecr_repository.lf-ecr-repository.repository_url}"
}
