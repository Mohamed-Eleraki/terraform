# Configure aws provider
terraform {
    required_providers {
        aws = {
            source = "hashicorp/aws"
            version = "~> 5.0"
        }
    }
}

# Configure aws provider
provider "aws" {
    region = "us-east-1"
}


# Variables Section
variable "environment" {}



# Resouces Section

# VPCs, Subnet Resources
resource "aws_vpc" "vpc-1" {
    cidr_block = "10.0.0.0/16"
    enable_dns_support = true
    enable_dns_hostnames = true
    tags = {
      Name = "${var.environment}-vpc-1"
    }
}

resource "aws_subnet" "subnet-1" {
  vpc_id = aws_vpc.vpc-1.id
  cidr_block = "10.0.0.0/16"
  availability_zone = "us-east-1a"

  tags = {
    Name = "${var.environment}-vpc-1"
  }
}

resource "aws_vpc" "vpc-2" {
    cidr_block = "20.0.0.0/16"
    enable_dns_support = true
    enable_dns_hostnames = true
  tags = {
    Name = "${var.environment}-vpc-2"
  }
}

resource "aws_subnet" "subnet-2" {
    vpc_id = aws_vpc.vpc-2.id
    cidr_block = "20.0.0.0/16"
    availability_zone = "us-east-1e"
    tags = {
      Name = "${var.environment}-vpc-1"
    }
}


# transitgateways Resources
resource "aws_ec2_transit_gateway" "tgw" {
    default_route_table_association = "enable"
    default_route_table_propagation = "enable"
    dns_support = "enable"
    vpn_ecmp_support = "enable"

    tags = {
      Name = "${var.environment}-tgw"
    }
}

resource "aws_ec2_transit_gateway_vpc_attachment" "tgw-attachment-vpc1" {
  vpc_id = aws_vpc.vpc-1.id
  subnet_ids = [aws_subnet.subnet-1.id]
  transit_gateway_id = aws_ec2_transit_gateway.tgw.id
}

resource "aws_ec2_transit_gateway_vpc_attachment" "tgw-attachment-vpc2" {
  vpc_id = aws_vpc.vpc-2.id
  subnet_ids = [aws_subnet.subnet-2.id]
  transit_gateway_id = aws_ec2_transit_gateway.tgw.id
}

resource "aws_ec2_transit_gateway_route_table" "tgw-rt-1" {
  transit_gateway_id = aws_ec2_transit_gateway.tgw.id
  #default_propagation_route_table = true
  #default_association_route_table = true
}

resource "aws_ec2_transit_gateway_route" "tgw-rt-vpc1" {
  destination_cidr_block = "10.0.0.0/16"
  transit_gateway_route_table_id = aws_ec2_transit_gateway_route_table.tgw-rt-1.id
  transit_gateway_attachment_id = aws_ec2_transit_gateway_vpc_attachment.tgw-attachment-vpc1.id

}


resource "aws_ec2_transit_gateway_route" "tgw-rt-vpc2" {
  destination_cidr_block = "20.0.0.0/16"
  transit_gateway_route_table_id = aws_ec2_transit_gateway_route_table.tgw-rt-1.id
  transit_gateway_attachment_id = aws_ec2_transit_gateway_vpc_attachment.tgw-attachment-vpc2.id
}

# Create and internet gateway to allow internet for ec2s
resource "aws_internet_gateway" "igw-1" {
  vpc_id = aws_vpc.vpc-1.id

  tags = {
    Name = "${var.environment}-igw-vpc-1"
  }
}

resource "aws_internet_gateway" "igw-2" {
  vpc_id = aws_vpc.vpc-2.id

  tags = {
    Name = "${var.environment}-igw-vpc-2"
  }
}

# VPCs Route Tables
resource "aws_route_table" "rt-vpc1" {
  vpc_id = aws_vpc.vpc-1.id
#  route {
#    cidr_block = "0.0.0.0/0"
#    gateway_id = aws_internet_gateway.igw-1.id
#  }

  tags = {
    Name = "${var.environment}-rt-vpc1"
  }
}


# Route table association
resource "aws_route_table_association" "rt-association-subnet1" {
  subnet_id      = aws_subnet.subnet-1.id
  route_table_id = aws_route_table.rt-vpc1.id
}

resource "aws_route_table" "rt-vpc2" {
  vpc_id = aws_vpc.vpc-2.id

 # route {
 #   cidr_block = "0.0.0.0/0"
 #   gateway_id = aws_internet_gateway.igw-2.id
 # }
    tags = {
    Name = "${var.environment}-rt-vpc2"
  }
}

# Route table association
resource "aws_route_table_association" "rt-association-subnet2" {
  subnet_id      = aws_subnet.subnet-2.id
  route_table_id = aws_route_table.rt-vpc2.id
}

# Security Groups for the instances
resource "aws_security_group" "secGrp-01" {
  name = "allow_SSH-01"
  vpc_id = aws_vpc.vpc-1.id
  
  tags = {
    Name = "${var.environment}-secGrp-01"
  }
}

resource "aws_vpc_security_group_ingress_rule" "Allow-SSH-secGrp01" {
  security_group_id = aws_security_group.secGrp-01.id
  cidr_ipv4 = "0.0.0.0/0"
  from_port = 22
  to_port   = 22
  ip_protocol = "tcp"
}

resource "aws_vpc_security_group_egress_rule" "Allow-outbound-secGrp01" {
  security_group_id = aws_security_group.secGrp-01.id
  cidr_ipv4 = "0.0.0.0/0"
  ip_protocol = "-1"
}

resource "aws_security_group" "secGrp-02" {
  name = "allow_SSH-02"
  vpc_id = aws_vpc.vpc-2.id
  tags = {
    Name = "${var.environment}-secGrp-02"
  }
}

resource "aws_vpc_security_group_ingress_rule" "Allow-SSH-secGrp02" {
  security_group_id = aws_security_group.secGrp-02.id
  cidr_ipv4 = "0.0.0.0/0"
  from_port = 22
  to_port   = 22
  ip_protocol = "tcp"
}

resource "aws_vpc_security_group_egress_rule" "Allow-outbound-secGrp02" {
  security_group_id = aws_security_group.secGrp-02.id
  cidr_ipv4 = "0.0.0.0/0"
  ip_protocol = "-1"
}

# Create a key pair
resource "aws_key_pair" "kp-1" {
  key_name = "server-key"
  public_key = "${file("~/.ssh/id_rsa.pub")}"
}

# ec2 Resources
resource "aws_instance" "ec2-01" {
  ami = "ami-0a3c3a20c09d6f377"
  instance_type = "t2.micro"
  associate_public_ip_address = true
  subnet_id = aws_subnet.subnet-1.id
  key_name = aws_key_pair.kp-1.key_name
  vpc_security_group_ids = [aws_security_group.secGrp-01.id]

  tags = {
    Name = "${var.environment}-ec2-01"
  }
}

resource "aws_instance" "ec2-02" {
  ami = "ami-0a3c3a20c09d6f377"
  instance_type = "t2.micro"
  associate_public_ip_address = true
  subnet_id = aws_subnet.subnet-2.id
  key_name = aws_key_pair.kp-1.key_name
  vpc_security_group_ids = [aws_security_group.secGrp-02.id]

  tags = {
    Name = "${var.environment}-ec2-02"
  }
}


