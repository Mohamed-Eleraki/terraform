resource "aws_security_group" "lambda_sg" {
  name = "lambda_sg"
  description = "Security group for lambda"
  vpc_id = aws_vpc.vpc-1.id

  ingress {
    from_port = 0
    to_port = 0
    protocol = "-1"  # Allow all inbound traffic
    cidr_blocks = ["0.0.0.0/0"] 
  }

  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"  # Allow all outbound traffic
  }
}
