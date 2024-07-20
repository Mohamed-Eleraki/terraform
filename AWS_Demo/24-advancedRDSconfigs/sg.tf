# Deploy RDS security group
resource "aws_security_group" "secgrp_RDS_01" {
  vpc_id = aws_vpc.vpc-01.id

  ingress = {
    from_port   = 5432
    to_port     = 5432
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress = {
    from_port   = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "secgrp_RDS_01"
  }
}

# Deploy bastion host security group
resource "aws_security_group" "secgrp_bastion_02" {
  vpc_id = aws_vpc.vpc-01.id

  ingress = {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress = {
    from_port   = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}