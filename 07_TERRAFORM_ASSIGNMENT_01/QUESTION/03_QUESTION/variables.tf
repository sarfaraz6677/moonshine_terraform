variable "aws_region" {
  type = string
}
variable "cidr_block" {
  type = string
}

variable "public_cidr_block" {
  type = list(string)
}

variable "private_cidr_block" {
  type = list(string)
}
variable "availability_zone" {
  type = list(string)
}
