# Create a VPC holds the ec2 configs
resource "aws_vpc" "vpc_1" {
  cidr_block = "10.0.0.0/16"

  tags = {
    name = "vpc_1"
  }
}

# Create subnet for EC2 instance
resource "aws_subnet" "subnet_1" {
  vpc_id     = aws_vpc.vpc_1.id
  cidr_block = "10.0.1.0/24"

  tags = {
    name = "subnet_1"
  }
}

# Create IGW to allow Internet traffic
resource "aws_internet_gateway" "vpc_1_igw" {
  vpc_id = aws_vpc.vpc_1.id

  tags = {
    name = "vpc_1_igw"
  }
}

# create route table to route all vpc traffic to igw
resource "aws_route_table" "vpc_1_rt" {
  vpc_id = aws_vpc.vpc_1.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.vpc_1_igw.id
  }

  tags = {
    name = "vpc_1_rt"
  }
}

# Associate subnet with the route teble
resource "aws_route_table_association" "rt_acc" {
  subnet_id      = aws_subnet.subnet_1.id
  route_table_id = aws_route_table.vpc_1_rt.id
}
