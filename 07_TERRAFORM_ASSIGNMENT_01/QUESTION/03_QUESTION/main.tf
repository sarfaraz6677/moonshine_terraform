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
//FOR VPC

resource "aws_vpc" "this_vpc" {
  cidr_block = var.cidr_block
}

//FOR SUBNETS

resource "aws_subnet" "this_public_subnet" {
  vpc_id            = aws_vpc.this_vpc.id
  cidr_block        = element(var.public_cidr_block, count.index)
  availability_zone = element(var.availability_zone, count.index)
  count             = 2
}
resource "aws_subnet" "this_private_subnet" {
  vpc_id            = aws_vpc.this_vpc.id
  cidr_block        = element(var.private_cidr_block, count.index)
  availability_zone = element(var.availability_zone, count.index)
  count             = 2
}

//FOR INTERNET GATEWAY AND ELASTIC IP

resource "aws_internet_gateway" "this_igw" {
  vpc_id = aws_vpc.this_vpc.id
}
resource "aws_eip" "this_eip" {
  vpc = true
}

//FOR NAT GATEWAY
resource "aws_nat_gateway" "this_nat_gateway" {
  allocation_id = aws_eip.this_eip.id
  subnet_id     = aws_subnet.this_public_subnet[0].id
}

//FOR ROUTE TABLE AND ROUTE
resource "aws_route_table" "this_pub_route_table" {
  vpc_id = aws_vpc.this_vpc.id
}

resource "aws_route" "this_pub_route" {
  route_table_id         = aws_route_table.this_pub_route_table.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.this_igw.id
}

resource "aws_route_table" "this_pri_route_table" {
  vpc_id = aws_vpc.this_vpc.id
}

resource "aws_route" "this_pri_route" {
  route_table_id         = aws_route_table.this_pri_route_table.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_nat_gateway.this_nat_gateway.id
}

//FOR SUBNET ASSOCIATION
resource "aws_route_table_association" "this_public_rt_asso" {
  count          = length(var.public_cidr_block)
  subnet_id      = aws_subnet.this_public_subnet[count.index].id
  route_table_id = aws_route_table.this_pub_route_table.id
}
resource "aws_route_table_association" "this_private_rt_asso" {
  count          = length(var.private_cidr_block)
  subnet_id      = aws_subnet.this_private_subnet[count.index].id
  route_table_id = aws_route_table.this_pri_route_table.id
}