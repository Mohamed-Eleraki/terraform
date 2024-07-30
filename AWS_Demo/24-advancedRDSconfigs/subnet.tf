resource "aws_subnet" "pub_subnet_01" {
  vpc_id            = aws_vpc.vpc-01.id
  cidr_block        = "10.0.1.0/24"
  availability_zone = "us-east-1a"

  tags = {
    Name = "pub-subnet-01"
  }
}

resource "aws_subnet" "prv_subnet_01" {
  vpc_id            = aws_vpc.vpc-01.id
  cidr_block        = "10.0.2.0/24"
  availability_zone = "us-east-1b"
}