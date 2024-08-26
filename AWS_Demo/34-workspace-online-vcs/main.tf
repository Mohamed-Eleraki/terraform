variable "environment" {}
variable "owner" {}

resource "aws_vpc" "vpc_01" {
  cidr_block = "10.0.0.0/16"

  tags = {
    Name = "${var.environment}-vpc_01"
    Owner = "${var.owner}"
  }
}

resource "aws_subnet" "name" {
  vpc_id = aws_vpc.vpc_01.id
  cidr_block = "10.0.1.0/24"
}

output "vpc_tags" {
  value = aws_vpc.vpc_01.tags_all
}
# just change to trigger 02