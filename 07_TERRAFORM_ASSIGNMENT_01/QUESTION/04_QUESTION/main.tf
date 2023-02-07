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
resource "aws_vpc" "this_vpc" {
  cidr_block = var.aws_vpc
}

resource "aws_subnet" "this_subnet" {
  vpc_id     = aws_vpc.this_vpc.id
  cidr_block = var.aws_subnet
}

resource "aws_security_group" "this_security_group" {
  name        = var.security_group_name
  description = var.security_description
  vpc_id      = aws_vpc.this_vpc.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_key_pair" "this_ssh_key" {
  key_name   = var.key_name
  public_key = file(var.ssh_public_key_path)
}

resource "aws_instance" "this_ec2_instance" {
  ami           = var.ami_id
  instance_type = var.instance_type
  key_name      = aws_key_pair.this_ssh_key.key_name
  vpc_security_group_ids = [aws_security_group.this_security_group.id]
  subnet_id = aws_subnet.this_subnet.id
}
