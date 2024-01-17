# terraform-state-deployment

Prerequisites

terraform-user - IAM user for terraform with assume role privileges, with security credentials for cli access
terraform-role - IAM role for terraform-user, role should have admin privileges
Steps: Add terraform-user credentials under Security -> secrets Change the account id and environment in .tfvars file present in configs

