terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.0"
    }
  }
}

# Configure the AWS Provider
provider "aws" {
  region = "ap-south-1"
}

data "aws_ssoadmin_instances" "SSOPolicy" {}

resource "aws_ssoadmin_permission_set" "SSOAWSReadOnlyPolicy" {
  name         = "ViewOnly"
  instance_arn = var.sso_instance_arn
}


resource "aws_ssoadmin_managed_policy_attachment" "ViewOnlyAccess" {
  instance_arn       = var.sso_instance_arn
  managed_policy_arn = var.iam_managed_policy_arn
  permission_set_arn = aws_ssoadmin_permission_set.SSOAWSReadOnlyPolicy.arn
}

resource "aws_ssoadmin_account_assignment" "SSOAccount" {
  instance_arn       = var.sso_instance_arn
  permission_set_arn = aws_ssoadmin_permission_set.SSOAWSReadOnlyPolicy.arn

  principal_id   = var.sso_user_id 
  principal_type = var.sso_user_type

  target_id   = var.aws_account_id
  target_type = "AWS_ACCOUNT"
}