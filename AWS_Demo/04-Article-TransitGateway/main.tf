# Configure aws provider
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

# Configure aws provider
provider "aws" {
  region = "us-east-1"
}


# Variables Section
variable "dev_vpc1_cidr_block" {} # Vpc1 cidr block
variable "dev_vpc2_cidr_block" {} # Vpc2 cidr block
variable "dev_vpc3_cidr_block" {} # Vpc3 cidr block

variable "dev_subnet1_cidr_block" {} # Subnet1 cidr block
variable "dev_subnet2_cidr_block" {} # Subnet2 cidr block
variable "dev_subnet3_cidr_block" {} # Subnet3 cidr block

variable "environment" {} # Envionment name, using in resource tags



#######################
## Resources Section ##
#######################

#############
## VPC ONE ##
#############

# Create a VPC-1 | VPC-1 Configurations
resource "aws_vpc" "vpc-1" {
  cidr_block = var.dev_vpc1_cidr_block
  tags = {
    Name = "${var.environment}-vpc-1" # Stage/Zone name, you can replace this with Region name Or Company name, etc
  }
}

# Create Internet gateway1 into vpc-1
resource "aws_internet_gateway" "igw-1" {
  vpc_id = aws_vpc.vpc-1.id
  tags = {
    Name = "${var.environment}-IGW-1"
  }
}

# Create subnet-1 into vpc-1
resource "aws_subnet" "subnet-1" {
  vpc_id            = aws_vpc.vpc-1.id
  cidr_block        = var.dev_subnet1_cidr_block
  availability_zone = "us-east-1a"

  tags = {
    Name = "${var.environment}-subnet-1"
  }
}


# Create Route table rt-1 into vpc-1
resource "aws_route_table" "rt-1" {
  vpc_id = aws_vpc.vpc-1.id

  # configure the roubte table, and route to other subnets
  route { # Route traffic to VPC-2
    cidr_block         = "13.0.1.0/24"
    transit_gateway_id = aws_ec2_transit_gateway.tgw-1.id
  }

  route { # Route traffic to VPC-3
    cidr_block         = "14.0.1.0/24"
    transit_gateway_id = aws_ec2_transit_gateway.tgw-1.id
  }

  route { # Route others traffics to the internet gateway
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw-1.id
  }

  tags = {
    Name = "${var.environment}-rt-1"
  }
}

# Associate the route table to the subent-1 into vpc-1
resource "aws_route_table_association" "rt-ass-1" {
  subnet_id      = aws_subnet.subnet-1.id
  route_table_id = aws_route_table.rt-1.id
}


# Create key pair based on your public key | You can put the public_key as plain text between ""
resource "aws_key_pair" "kp-1" {
  key_name   = "server_key"
  public_key = file("~/.ssh/id_rsa.pub")
}

# Create a security group to allow SSH connection into vpc-1
resource "aws_security_group" "secgrp-1" {
  name        = "secgrp-1"
  description = "Allow SSH inbound traffic"
  vpc_id      = aws_vpc.vpc-1.id

  tags = {
    Name = "${var.environment}-secgrp-1"
  }
}

# Configure secgrp-1 ingress rules
resource "aws_vpc_security_group_ingress_rule" "allow_SSH-1" {
  security_group_id = aws_security_group.secgrp-1.id
  cidr_ipv4         = "0.0.0.0/0" # Do not use this subnet in production - just for test
  #cidr_ipv4           = aws_vpc.vpc-1.cidr_block  # you can use the vpc cidr block instead
  from_port   = 22
  to_port     = 22
  ip_protocol = "tcp"
}

# Configure secgrp-1 egress rule
resource "aws_vpc_security_group_egress_rule" "allow_all_traffics-1" {
  security_group_id = aws_security_group.secgrp-1.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1" # equivalent to all ports
}

# Create an ec2 instance into vpc-1
resource "aws_instance" "ec2-1" {

  ami                         = "ami-0a3c3a20c09d6f377"
  instance_type               = "t2.micro"
  associate_public_ip_address = true
  subnet_id                   = aws_subnet.subnet-1.id
  key_name                    = aws_key_pair.kp-1.key_name
  vpc_security_group_ids      = [aws_security_group.secgrp-1.id]

  tags = {
    Name = "${var.environment}-ec2-1"
  }
}




#############
## VPC TWO ##
#############

# Create a VPC-2 | VPC-2 Configurations
resource "aws_vpc" "vpc-2" {
  cidr_block = var.dev_vpc2_cidr_block
  tags = {
    Name = "${var.environment}-vpc-2"
  }
}

# Create Internet gateway2 into vpc-2
resource "aws_internet_gateway" "igw-2" {
  vpc_id = aws_vpc.vpc-2.id
  tags = {
    Name = "${var.environment}-IGW-2"
  }
}

# Create subnet-2 into vpc-2
resource "aws_subnet" "subnet-2" {
  vpc_id            = aws_vpc.vpc-2.id
  cidr_block        = var.dev_subnet2_cidr_block
  availability_zone = "us-east-1c"

  tags = {
    Name = "${var.environment}-subnet-2"
  }
}


# Create Route table rt-2 into vpc-2
resource "aws_route_table" "rt-2" {
  vpc_id = aws_vpc.vpc-2.id

  # configure the roubte table, and route to other subnets
  route {  # route the traffic to the vpc-1
    cidr_block         = "12.0.1.0/24"
    transit_gateway_id = aws_ec2_transit_gateway.tgw-1.id
  }

  route {  # Route the traffic to vpc-3
    cidr_block         = "14.0.1.0/24"
    transit_gateway_id = aws_ec2_transit_gateway.tgw-1.id
  }

  route {  # Route others traffics to the internet gateway
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw-2.id
  }

  tags = {
    Name = "${var.environment}-rt-2"
  }
}

# Associate the route table to the subent-2 into vpc-2
resource "aws_route_table_association" "rt-ass-2" {
  subnet_id      = aws_subnet.subnet-2.id
  route_table_id = aws_route_table.rt-2.id
}


# Create a security group to allow SSH connection into vpc-2
resource "aws_security_group" "secgrp-2" {
  name        = "secgrp-2"
  description = "Allow SSH inbound traffic"
  vpc_id      = aws_vpc.vpc-2.id

  tags = {
    Name = "${var.environment}-secgrp-2"
  }
}

# Configure secgrp-2 ingress rules
resource "aws_vpc_security_group_ingress_rule" "allow_SSH-2" {
  security_group_id = aws_security_group.secgrp-2.id
  #cidr_ipv4           = aws_vpc.vpc-2.cidr_block
  cidr_ipv4   = "0.0.0.0/0" # Do not use this subnet in production - just for test
  from_port   = 22
  to_port     = 22
  ip_protocol = "tcp"
}

# Configure secgrp-2 egress rule
resource "aws_vpc_security_group_egress_rule" "allow_all_traffics-2" {
  security_group_id = aws_security_group.secgrp-2.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1" # equivalent to all ports
}

# Create an ec2 instance into vpc-2 - using the same key pair generated above
resource "aws_instance" "ec2-2" {

  ami                         = "ami-0a3c3a20c09d6f377"
  instance_type               = "t2.micro"
  associate_public_ip_address = true
  subnet_id                   = aws_subnet.subnet-2.id
  key_name                    = aws_key_pair.kp-1.key_name # use the same key pair
  vpc_security_group_ids      = [aws_security_group.secgrp-2.id]

  tags = {
    Name = "${var.environment}-ec2-2"
  }
}



###############
## VPC THREE ##
###############

# Create a VPC-3 | VPC-3 Configurations
resource "aws_vpc" "vpc-3" {
  cidr_block = var.dev_vpc3_cidr_block
  tags = {
    Name = "${var.environment}-vpc-3"
  }
}

# Create Internet gateway3 into vpc-3
resource "aws_internet_gateway" "igw-3" {
  vpc_id = aws_vpc.vpc-3.id
  tags = {
    Name = "${var.environment}-IGW-3"
  }
}

# Create subnet-3 into vpc-3
resource "aws_subnet" "subnet-3" {
  vpc_id            = aws_vpc.vpc-3.id
  cidr_block        = var.dev_subnet3_cidr_block
  availability_zone = "us-east-1b"

  tags = {
    Name = "${var.environment}-subnet-3"
  }
}


# Create Route table rt-3 into vpc-3
resource "aws_route_table" "rt-3" {
  vpc_id = aws_vpc.vpc-3.id

  # configure the roubte table, and route to other subnets
  route {   # Route the traffic to vpc-1
    cidr_block         = "12.0.1.0/24"
    transit_gateway_id = aws_ec2_transit_gateway.tgw-1.id
  }

  route {  # Route the traffic to vpc-2
    cidr_block         = "13.0.1.0/24"
    transit_gateway_id = aws_ec2_transit_gateway.tgw-1.id
  }

  route {  # Route any other traffic to the internet gateway
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw-3.id
  }


  tags = {
    Name = "${var.environment}-rt-3"
  }
}

# Associate the route table to subent-3 into vpc-3
resource "aws_route_table_association" "rt-ass-3" {
  subnet_id      = aws_subnet.subnet-3.id
  route_table_id = aws_route_table.rt-3.id
}



# Create a security group to allow SSH connection into vpc-3
resource "aws_security_group" "secgrp-3" {
  name        = "secgrp-3"
  description = "Allow SSH inbound traffic"
  vpc_id      = aws_vpc.vpc-3.id

  tags = {
    Name = "${var.environment}-secgrp-3"
  }
}

# Configure secgrp-3 ingress rules
resource "aws_vpc_security_group_ingress_rule" "allow_SSH-3" {
  security_group_id = aws_security_group.secgrp-3.id
  #cidr_ipv4           = aws_vpc.vpc-3.cidr_block
  cidr_ipv4   = "0.0.0.0/0" # Do not use this subnet in production - just for test
  from_port   = 22
  to_port     = 22
  ip_protocol = "tcp"
}

# Configure secgrp-3 egress rule
resource "aws_vpc_security_group_egress_rule" "allow_all_traffics-3" {
  security_group_id = aws_security_group.secgrp-3.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1" # equivalent to all ports
}

# Create an ec2 instance into vpc-3 - and use the same key pair ganerated above
resource "aws_instance" "ec2-3" {

  ami                         = "ami-0a3c3a20c09d6f377"
  instance_type               = "t2.micro"
  associate_public_ip_address = true
  subnet_id                   = aws_subnet.subnet-3.id
  key_name                    = aws_key_pair.kp-1.key_name # use the same key
  vpc_security_group_ids      = [aws_security_group.secgrp-3.id]

  tags = {
    Name = "${var.environment}-ec2-3"
  }
}




#####################
## TRANSIT GATEWAY ##
#####################

# Create a transit gateway
resource "aws_ec2_transit_gateway" "tgw-1" {

  description                     = "Development Main Transitgateway"
  default_route_table_association = "enable"
  default_route_table_propagation = "enable"
  dns_support                     = "enable"
  vpn_ecmp_support                = "enable"

  tags = {
    Name = "${var.environment}-tgw-1"
  }
}

# Create attachment to attache to subnet-1 
resource "aws_ec2_transit_gateway_vpc_attachment" "tgw-att-1" {
  vpc_id             = aws_vpc.vpc-1.id
  subnet_ids         = [aws_subnet.subnet-1.id]
  transit_gateway_id = aws_ec2_transit_gateway.tgw-1.id

  tags = {
    Name = "${var.environment}-tgw-att-1"
  }
}

# Create attachment to attache to subnet-2
resource "aws_ec2_transit_gateway_vpc_attachment" "tgw-att-2" {
  vpc_id             = aws_vpc.vpc-2.id
  subnet_ids         = [aws_subnet.subnet-2.id]
  transit_gateway_id = aws_ec2_transit_gateway.tgw-1.id

  tags = {
    Name = "${var.environment}-tgw-att-3"
  }
}

# Create attachment to attache to subnet-3
resource "aws_ec2_transit_gateway_vpc_attachment" "tgw-att-3" {
  vpc_id             = aws_vpc.vpc-3.id
  subnet_ids         = [aws_subnet.subnet-3.id]
  transit_gateway_id = aws_ec2_transit_gateway.tgw-1.id

  tags = {
    Name = "${var.environment}-tgw-att-3"
  }
}