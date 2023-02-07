variable "aws_region" {
  type = string
}

variable "aws_vpc" {
  type = string
}

variable "aws_subnet" {
  type = string
}

variable "security_group_name" {
  type = string
}

variable "security_description" {
  type = string
}
variable "key_name" {
  type = string
}

variable "instance_type" {
  type = string
}

variable "ami_id" {
  type = string
}

variable "ssh_public_key_path" {
  type = string
}