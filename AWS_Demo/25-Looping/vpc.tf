resource "aws_vpc" "vpc_01" {
  cidr_block = var.vpc_cidr_block

  tags = {
    Name = "vpc_01"
  }
}