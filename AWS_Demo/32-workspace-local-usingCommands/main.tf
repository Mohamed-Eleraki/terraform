locals {
  vpc_name = "${terraform.workspace}-vpc"
}

variable "vpc_cidr_block" {}

resource "aws_vpc" "vpc_01" {
  cidr_block = var.vpc_cidr_block

  tags = {
    Name = local.vpc_name
  }
}