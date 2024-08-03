resource "random_id" "id" {
  byte_length = 8
}

resource "aws_vpc" "vpc_01" {
  cidr_block = var.dev_vpc1_cidr_block

  tags = local.common_tags
}

resource "aws_subnet" "subnet_01" {
  vpc_id     = aws_vpc.vpc_01.id
  cidr_block = var.dev_subnet1_cidr_block

  tags = local.common_tags
}


# Resources
# - https://developer.hashicorp.com/terraform/tutorials/configuration-language/expressions