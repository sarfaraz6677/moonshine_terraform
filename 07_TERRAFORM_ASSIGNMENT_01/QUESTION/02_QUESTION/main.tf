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
  region = var.aws_region
}
locals {
  instance_type = var.instance_type
}

resource "aws_instance" "this_ec2_instance" {
  ami           = var.ami_id
  instance_type = local.instance_type
}

resource "aws_eip" "this_elastic_ip" {
  vpc = true
}

resource "aws_eip_association" "this_eip_association" {
  instance_id = aws_instance.this_ec2_instance.id
  allocation_id = aws_eip.this_elastic_ip.id
}

output "public_dns_name" {
  value = aws_instance.this_ec2_instance.public_dns
}

output "private_dns_name" {
  value = aws_instance.this_ec2_instance.private_dns
}

output "private_ip" {
  value = aws_instance.this_ec2_instance.private_ip
}

output "public_ip" {
  value = aws_eip.this_elastic_ip.public_ip
}