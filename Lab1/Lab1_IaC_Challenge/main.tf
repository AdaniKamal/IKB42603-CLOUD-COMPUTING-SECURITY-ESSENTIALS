terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
    }
  }
}

# ----------------------------------------
# Point Terraform to LocalStack
# ----------------------------------------

provider "aws" {
  access_key = "test"
  secret_key = "test"
  region     = "us-east-1"

  # We are using LocalStack (Want to manage AWS-style infrastructure)

  endpoints {
    iam = "http://localhost:4566"
    sts = "http://localhost:4566"
  }

  skip_credentials_validation = true
  skip_metadata_api_check     = true
  skip_requesting_account_id  = true
}

# ----------------------------------------
# 1. Create IAM Group
# ----------------------------------------

resource "aws_iam_group" "admins" {
  name = "Admins-1"
}

# ----------------------------------------
# 2. Attach AdministratorAccess Policy to the GROUP
# ----------------------------------------

resource "aws_iam_group_policy_attachment" "admin_policy" {
  group      = aws_iam_group.admins.name
  policy_arn = "arn:aws:iam::aws:policy/AdministratorAccess"
}

# ----------------------------------------
# 3. Create IAM User
# ----------------------------------------

resource "aws_iam_user" "cloud_admin" {
  name = "CloudAdmin_Ainin"
}

# ----------------------------------------
# 4. Add User to Admins Group
# ----------------------------------------

resource "aws_iam_user_group_membership" "cloud_admin_membership" {
  user = aws_iam_user.cloud_admin.name

  groups = [
    aws_iam_group.admins.name
  ]
}