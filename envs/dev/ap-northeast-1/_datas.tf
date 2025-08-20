# Data sources để lấy thông tin về VPC và subnets hiện có
data "aws_vpc" "main" {
  filter {
    name   = "tag:Name"
    values = [var.vpc_name]
  }
}

data "aws_subnet" "private_01" {
  filter {
    name   = "tag:Name"
    values = [var.private_subnet_01_name]
  }
}

data "aws_subnet" "private_02" {
  filter {
    name   = "tag:Name"
    values = [var.private_subnet_02_name]
  }
}

data "aws_subnet" "public_01" {
  filter {
    name   = "tag:Name"
    values = [var.public_subnet_01_name]
  }
}

data "aws_subnet" "public_02" {
  filter {
    name   = "tag:Name"
    values = [var.public_subnet_02_name]
  }
}
