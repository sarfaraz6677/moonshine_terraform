terraform {
  required_version = ">= 0.13"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "4.46.0"
    }
    random = {
      source  = "hashicorp/random"
      version = "3.0.0"
    }
  }
}

provider "aws" {
  region = "ap-south-1"
}
provider "random" {
  # Configuration options
}
resource "aws_iam_user" "employee" {
  name = var.iam_user_name
}

resource "aws_iam_group" "group" {
  name = var.iam_group_name
}

resource "aws_iam_group_membership" "group_membership" {
  name = var.iam_group_membership
  users = [aws_iam_user.employee.name]
  group = aws_iam_group.group.name
}
