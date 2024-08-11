resource "aws_subnet" "subnet_01" {
  vpc_id = var.vpc_id
  cidr_block = var.cidr_block
  availability_zone = var.avail_zone

  tags = {
    Name = "${var.env_prefix}-subnet_01"
  }
}

resource "aws_internet_gateway" "igw_01" {
  vpc_id = var.vpc_id
  tags = {
    Name = "${var.env_prefix}-igw_01"
  }
}

resource "aws_default_route_table" "main_rt" {
  default_route_table_id = var.default_route_table_id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw_01.id
  }

  tags = {
    Name = "${var.env_prefix}-main_rt"
  }
}