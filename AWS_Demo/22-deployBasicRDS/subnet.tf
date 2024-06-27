resource "aws_subnet" "subnet-01" {
  vpc_id            = aws_vpc.vpc-01.id
  cidr_block        = "10.0.1.0/24"
  availability_zone = "us-east-1a"

  tags = {
    Name = "subnet-01"
  }
}

resource "aws_subnet" "subnet-02" {
  vpc_id            = aws_vpc.vpc-01.id
  cidr_block        = "10.0.2.0/24"
  availability_zone = "us-east-1b"

  tags = {
    Name = "subnet-02"
  }
}


# Create Internet gateway1
resource "aws_internet_gateway" "igw-1" {
    vpc_id = aws_vpc.vpc-01.id
    tags = {
      Name = "IGW-1"
    }
}

# Create a route table
resource "aws_route_table" "rt-1" {
  vpc_id = aws_vpc.vpc-01.id

  route {
    cidr_block = "0.0.0.0/0"  # Represents all IP addresses (i.e., internet-bound traffic)
    gateway_id = aws_internet_gateway.igw-1.id
  }
}

# route table association 01
resource "aws_route_table_association" "rt-1-association" {
  subnet_id = aws_subnet.subnet-01.id
  route_table_id = aws_route_table.rt-1.id
}

# route table association 02
resource "aws_route_table_association" "rt-2-association" {
  subnet_id = aws_subnet.subnet-02.id
  route_table_id = aws_route_table.rt-1.id
}
