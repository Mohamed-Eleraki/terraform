# Create a VPC
resource "aws_vpc" "vpc-1" {
cidr_block = "10.0.0.0/16"
}

# Craete a subnet
resource "aws_subnet" "subnet-1" {
  vpc_id = aws_vpc.vpc-1.id
  cidr_block = "10.0.1.0/24"
}