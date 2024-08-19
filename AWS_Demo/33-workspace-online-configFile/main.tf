resource "aws_vpc" "vpc_01" {
  cidr_block = "10.0.0.0/16"

  tags = {
    Name = "vpc_01-workspaceConfig"
  }
}