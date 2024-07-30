resource "aws_subnet" "subnet_01" {
  vpc_id     = aws_vpc.vpc_01.id
  cidr_block = var.subnet_cidr_block

  tags = {
    Name = "subnet_01"
  }
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.vpc_01.id
  
  tags = {
    Name = "igw"
  }
}

resource "aws_route_table" "rtb_01" {
  vpc_id = aws_vpc.vpc_01.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }
}

resource "aws_route_table_association" "ass_rt_01" {
  subnet_id = aws_subnet.subnet_01.id
  route_table_id = aws_route_table.rtb_01.id
}