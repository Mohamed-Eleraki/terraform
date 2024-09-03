module "vpc" {
  source = "terraform-aws-modules/vpc/aws"
  version = "5.7.0"
  cidr = var.vpc_cidr_block

  public_subnets = slice(var.public_subnet_list, 0, var.public_subnet_count)
  private_subnets = slice(var.private_subnet_list, 0, var.private_subnet_count)

  azs = data.aws_availability_zones.available.names
  # azs for us-east-1?

  tags = var.resource_tags
}

data "aws_availability_zones" "available" {
  state = "available"
}