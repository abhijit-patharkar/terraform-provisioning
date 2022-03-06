# terraform-scripts
Terraform infrastructure provisioning

# Basic Commonds
terraform init
terraform plan -var-file="../vars/dev/terraform.tfvars"
terraform apply -var-file="../vars/dev/terraform.tfvars" -auto-approve=true
terraform destroy -var-file="../vars/dev/terraform.tfvars" -auto-approve=true

