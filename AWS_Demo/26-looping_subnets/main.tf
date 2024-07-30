
provider "aws" {
  region = "us-east-1"
  profile = "eraki"
}

variable "availability_zones" {
  type = list(string)
  default = [ "us-east-1a", "us-east-1b" ]
}

resource "aws_vpc" "main" {
  cidr_block = "10.0.0.0/16"
}

resource "aws_subnet" "subnet_01" {
  for_each = toset(var.availability_zones)
  
  vpc_id = aws_vpc.main.id
  cidr_block = "10.0.1.0/24"
  availability_zone = each.value
}