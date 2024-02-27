resource "aws_vpc_endpoint" "endpoint-vpc1-s3" {
  vpc_id       = aws_vpc.vpc-1.id
  service_name = "com.amazonaws.us-east-1.s3"
  vpc_endpoint_type = "Gateway"
  route_table_ids = [aws_route_table.rt-1.id]
  #subnet_ids = [aws_subnet.subnet-1.id]

  tags = {
    Name = "${var.environment}-endpoint1-vpc1Tos3"
  }
}

resource "aws_vpc_endpoint" "endpoint-vpc2-s3" {
  vpc_id       = aws_vpc.vpc-2.id
  service_name = "com.amazonaws.us-east-1.s3"
  vpc_endpoint_type = "Gateway"
  route_table_ids = [aws_route_table.rt-2.id]
  #subnet_ids = [aws_subnet.subnet-2.id]

  tags = {
    Name = "${var.environment}-endpoint2-vpc2Tos3"
  }
}