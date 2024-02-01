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

    tags = {
      Name = "${var.environment}-vpc-1"
    }
}

resource "aws_subnet" "subnet-1" {
  vpc_id = aws_vpc.vpc-1.id
  cidr_block = "10.0.0.0/16"

  tags = {
    Name = "${var.environment}-vpc-1"
  }
}

resource "aws_vpc" "vpc-2" {
  cidr_block = "20.0.0.0/16"

  tags = {
    Name = "${var.environment}-vpc-2"
  }
}

resource "aws_subnet" "subnet-2" {
    vpc_id = aws_vpc.vpc-2.id
    cidr_block = "20.0.0.0/16"

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

# VPCs Route Tables
resource "aws_route_table" "rt-vpc1" {
  vpc_id = aws_vpc.vpc-1.id

  route {
    cidr_block = "0.0.0.0/0"
    transit_gateway_id = aws_ec2_transit_gateway.tgw.id
  }
}

resource "aws_route_table" "rt-vpc2" {
  vpc_id = aws_vpc.vpc-2.id
  route {
    cidr_block = "0.0.0.0/0"
    transit_gateway_id = aws_ec2_transit_gateway.tgw.id
  }
}



# Create 2 security groups
# Create 2 ec2s's
# Test connection