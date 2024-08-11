module "subnet" {
  source                 = "./modules/subnet"
  vpc_id                 = aws_vpc.vpc_01.id
  cidr_block             = var.cidr_block
  avail_zone             = var.avail_zone
  env_prefix             = var.env_prefix
  default_route_table_id = aws_vpc.vpc_01.default_route_table_id
}

resource "aws_vpc" "vpc_01" {
  cidr_block = "10.0.0.0/16"

  tags = {
    Name = "${var.env_prefix}-vpc_01"
  }
}

resource "aws_instance" "ec2-1" {
  ami = "ami-0a3c3a20c09d6f377"
  instance_type = "t2.micro"
  associate_public_ip_address = true
  subnet_id = module.subnet.subent_id  # fetch the subnet ID from the output

  tags = {
    Name = "${var.env_prefix}-vpc_01"
  }
}