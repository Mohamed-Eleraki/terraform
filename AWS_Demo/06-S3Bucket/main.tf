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
  region  = "us-east-1"
  profile = "eraki"
}



#######################
## Variables Section ##
#######################
variable "dev_vpc1_cidr_block" {}
variable "dev_vpc2_cidr_block" {}
variable "dev_vpc3_cidr_block" {}

variable "dev_subnet1_cidr_block" {}
variable "dev_subnet2_cidr_block" {}
variable "dev_subnet3_cidr_block" {}
variable "dev_subnet4_cidr_block" {}

variable "environment" {}


#######################
## Resources Section ##
#######################

################
# Create VPC-1 #
################
resource "aws_vpc" "vpc-1" {
  cidr_block = var.dev_vpc1_cidr_block

  tags = {
    Name = "${var.environment}-vpc-1"
  }
}

# create Subnet-1 for VPC-1
resource "aws_subnet" "subnet-1" {
  vpc_id     = aws_vpc.vpc-1.id
  cidr_block = var.dev_subnet1_cidr_block
  availability_zone = "us-east-1c"

  tags = {
    Name = "${var.environment}-subnet-1"
  }
}

# Create a route table to route to transit gateway for VPC-1
resource "aws_route_table" "rt-1" {
  vpc_id = aws_vpc.vpc-1.id

  route { # Route all traffic through the Transit Gateway
    cidr_block         = "0.0.0.0/0"
    transit_gateway_id = aws_ec2_transit_gateway.tgw.id
  }

  tags = {
    Name = "${var.environment}-rt-1"
  }
}

# Create Route table association to Subnet-1 in VPC-1
resource "aws_route_table_association" "rt-ass-1" {
  subnet_id      = aws_subnet.subnet-1.id
  route_table_id = aws_route_table.rt-1.id
}


# Create key pair for SSH access into EC2 instances
resource "aws_key_pair" "kp-1" {
  key_name   = "server_key"
  public_key = file("~/.ssh/id_rsa.pub")
}

# Create Security Group to allow SSH connection to EC2-1
resource "aws_security_group" "secgrp-1" {
  name        = "secgrp-1"
  description = "Allow SSH from anywhere."
  vpc_id      = aws_vpc.vpc-1.id
}

# Create egress rules for secgrp-1 for VPC-1
resource "aws_vpc_security_group_egress_rule" "outbound-secgrp-1" {
  security_group_id = aws_security_group.secgrp-1.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1" # equivalent to all ports
}

# Create ingress rules for secgrp-1 for VPC-1
resource "aws_vpc_security_group_ingress_rule" "inbound-secgrp-1" {
  security_group_id = aws_security_group.secgrp-1.id
  cidr_ipv4         = "0.0.0.0/0" # do Not apply such subnet in production, just for test
  ip_protocol       = "tcp"
  from_port         = 22
  to_port           = 22
}


# Create EC2-1 for VPC-1
resource "aws_instance" "ec2-1" {
  ami           = "ami-0440d3b780d96b29d"
  instance_type = "m5.large"  # this instance type allow Serial port connection
  #associate_public_ip_address   = true
  subnet_id              = aws_subnet.subnet-1.id
  vpc_security_group_ids = [aws_security_group.secgrp-1.id]
  key_name               = aws_key_pair.kp-1.key_name

  iam_instance_profile = aws_iam_instance_profile.s3_full_access_profile_01.name

  tags = {
    Name = "${var.environment}-EC2-1"
  }
}

resource "aws_iam_instance_profile" "s3_full_access_profile_01" {
  name = "S3FullAccessProfile01"
  role = aws_iam_role.s3_full_access_role_01.name
}


################
# Create VPC-2 #
################
resource "aws_vpc" "vpc-2" {
  cidr_block = var.dev_vpc2_cidr_block

  tags = {
    Name = "${var.environment}-vpc-2"
  }
}

# create Subnet-2 for VPC-2
resource "aws_subnet" "subnet-2" {
  vpc_id     = aws_vpc.vpc-2.id
  cidr_block = var.dev_subnet2_cidr_block
  availability_zone = "us-east-1c"

  tags = {
    Name = "${var.environment}-subnet-2"
  }
}

# Create a route table to route to transit gateway for VPC-2
resource "aws_route_table" "rt-2" {
  vpc_id = aws_vpc.vpc-2.id

  route { # Route all traffic through the Transit Gateway
    cidr_block         = "0.0.0.0/0"
    transit_gateway_id = aws_ec2_transit_gateway.tgw.id
  }


  tags = {
    Name = "${var.environment}-rt-2"
  }
}

# Create Route table association to Subnet-2 in VPC-2
resource "aws_route_table_association" "rt-ass-2" {
  subnet_id      = aws_subnet.subnet-2.id
  route_table_id = aws_route_table.rt-2.id
}

# Create Security Group to allow SSH connection to EC2-2
resource "aws_security_group" "secgrp-2" {
  name        = "secgrp-2"
  description = "Allow SSH from anywhere."
  vpc_id      = aws_vpc.vpc-2.id
}

# Create egress rules for secgrp-2 for VPC-2
resource "aws_vpc_security_group_egress_rule" "outbound-secgrp-2" {
  security_group_id = aws_security_group.secgrp-2.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1" # equivalent to all ports
}

# Create ingress rules for secgrp-2 for VPC-2
resource "aws_vpc_security_group_ingress_rule" "inbound-secgrp-2" {
  security_group_id = aws_security_group.secgrp-2.id
  cidr_ipv4         = "0.0.0.0/0" # do not apply such subnet in production, just for test
  ip_protocol       = "tcp"
  from_port         = 22
  to_port           = 22
}


# Create EC2-2 for VPC-2
resource "aws_instance" "ec2-2" {
  ami           = "ami-0440d3b780d96b29d"
  instance_type = "m5.large"  # this instance type allow Serial port connection
  #associate_public_ip_address   = true
  subnet_id              = aws_subnet.subnet-2.id
  vpc_security_group_ids = [aws_security_group.secgrp-2.id]
  key_name               = aws_key_pair.kp-1.key_name # use the same key

  iam_instance_profile = aws_iam_instance_profile.s3_full_access_profile_02.name
  
  tags = {
    Name = "${var.environment}-EC2-2"
  }
}

resource "aws_iam_instance_profile" "s3_full_access_profile_02" {
  name = "S3FullAccessProfile02"
  role = aws_iam_role.s3_full_access_role_02.name
}

################
# Create VPC-3 #
################
resource "aws_vpc" "vpc-3" {
  cidr_block = var.dev_vpc3_cidr_block

  tags = {
    Name = "${var.environment}-vpc-3"
  }
}

# Create an internet gateway
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.vpc-3.id

  tags = {
    Name = "${var.environment}-igw"
  }
}

# Create subnet-4 for vpc-3 - Public subnet
resource "aws_subnet" "subnet-4" {
  vpc_id            = aws_vpc.vpc-3.id
  cidr_block        = var.dev_subnet4_cidr_block
  availability_zone = "us-east-1c" # subnet 3 & 4 must be at the same zone

  tags = {
    Name = "${var.environment}-subnet-4-Pub"
  }
}

# Create route for subnet-4 to internet gateway - public subnet
resource "aws_route_table" "rtable-pub" {
  vpc_id = aws_vpc.vpc-3.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  route { # route to vpc-1
    cidr_block         = var.dev_vpc1_cidr_block
    transit_gateway_id = aws_ec2_transit_gateway.tgw.id
  }

  route { # route to vpc-2
    cidr_block         = var.dev_vpc2_cidr_block
    transit_gateway_id = aws_ec2_transit_gateway.tgw.id
  }
}

# Associate the route table to public subnet
resource "aws_route_table_association" "rt-ass-Pub" {
  subnet_id      = aws_subnet.subnet-4.id
  route_table_id = aws_route_table.rtable-pub.id
}


# Create an elastic IP for the NAT Gateway
resource "aws_eip" "nat-eip" {
  #vpc   = true
  domain = "vpc"
}

# Create a NAT Gateway in the public subnet for vpc-3
resource "aws_nat_gateway" "nat-gw" {
  subnet_id     = aws_subnet.subnet-4.id
  allocation_id = aws_eip.nat-eip.id
}

# Create subnet-3 for vpc-3
# The private subnet should be in the same Availability Zone as the public subnet
resource "aws_subnet" "subnet-3" {
  vpc_id            = aws_vpc.vpc-3.id
  cidr_block        = var.dev_subnet3_cidr_block
  availability_zone = "us-east-1c" # subnet 3 & 4 must be at the same zone

  tags = {
    Name = "${var.environment}-subnet-3-Prv"
  }
}

# Create a route table for the private subnet
resource "aws_route_table" "private-rt" {
  vpc_id = aws_vpc.vpc-3.id
}

# Add a route to the private route table to direct all traffic to the NAT Gateway
resource "aws_route" "private-route" {
  route_table_id         = aws_route_table.private-rt.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.nat-gw.id
}

# Associate the private route table with the private subnet
resource "aws_route_table_association" "private_subnet_association" {
  subnet_id      = aws_subnet.subnet-3.id
  route_table_id = aws_route_table.private-rt.id
}


# Create Transitgateway
resource "aws_ec2_transit_gateway" "tgw" {
  description                     = "Development Main Transitgateway"
  default_route_table_association = "disable"
  /*default_route_table_propagation = "disable"
  dns_support                     = "enable"
  vpn_ecmp_support                = "enable"*/


  tags = {
    Name = "${var.environment}-tgw"
  }
}

# Create an attachment to subnet-1
resource "aws_ec2_transit_gateway_vpc_attachment" "tgw-att-1" {
  vpc_id             = aws_vpc.vpc-1.id
  subnet_ids         = [aws_subnet.subnet-1.id]
  transit_gateway_id = aws_ec2_transit_gateway.tgw.id
  #transit_gateway_default_route_table_propagation = true

  tags = {
    Name = "${var.environment}-tgw-att-1"
  }
}

# Associate the route table to attachment
resource "aws_ec2_transit_gateway_route_table_association" "tgw-rt-ass-01" {
  transit_gateway_attachment_id  = aws_ec2_transit_gateway_vpc_attachment.tgw-att-1.id
  transit_gateway_route_table_id = aws_ec2_transit_gateway_route_table.tgw-rtb.id
}

# Create an attachment to subnet-2
resource "aws_ec2_transit_gateway_vpc_attachment" "tgw-att-2" {
  vpc_id             = aws_vpc.vpc-2.id
  subnet_ids         = [aws_subnet.subnet-2.id]
  transit_gateway_id = aws_ec2_transit_gateway.tgw.id
  #transit_gateway_default_route_table_propagation = true

  tags = {
    Name = "${var.environment}-tgw-att-2"
  }
}

# Associate the route table to attachment
resource "aws_ec2_transit_gateway_route_table_association" "tgw-rt-ass-02" {
  transit_gateway_attachment_id  = aws_ec2_transit_gateway_vpc_attachment.tgw-att-2.id
  transit_gateway_route_table_id = aws_ec2_transit_gateway_route_table.tgw-rtb.id
}

# Create an attachment to subnet-4
resource "aws_ec2_transit_gateway_vpc_attachment" "tgw-att-4" {
  vpc_id = aws_vpc.vpc-3.id
  #subnet_ids = [aws_subnet.subnet-3.id, aws_subnet.subnet-4.id]
  subnet_ids         = [aws_subnet.subnet-3.id]
  transit_gateway_id = aws_ec2_transit_gateway.tgw.id
  ##transit_gateway_default_route_table_propagation = true

  tags = {
    Name = "${var.environment}-tgw-att-4"
  }
}

# Associate the route table to attachment
resource "aws_ec2_transit_gateway_route_table_association" "tgw-rt-ass-03" {
  transit_gateway_attachment_id  = aws_ec2_transit_gateway_vpc_attachment.tgw-att-4.id
  transit_gateway_route_table_id = aws_ec2_transit_gateway_route_table.tgw-rtb.id
}


# Create a transit gateway route table
resource "aws_ec2_transit_gateway_route_table" "tgw-rtb" {
  transit_gateway_id = aws_ec2_transit_gateway.tgw.id

  tags = {
    Name = "${var.environment}-tgw-rtb"
  }
}

# Create transit gateway route rules for subnet 1
resource "aws_ec2_transit_gateway_route" "tgw-route-subnet-1" {
  transit_gateway_route_table_id = aws_ec2_transit_gateway_route_table.tgw-rtb.id
  destination_cidr_block         = var.dev_subnet1_cidr_block # The CIDR block for the development VPC Subnet 1
  transit_gateway_attachment_id  = aws_ec2_transit_gateway_vpc_attachment.tgw-att-1.id
}

# Create transit gateway route rules for subnet 2
resource "aws_ec2_transit_gateway_route" "tgw-route-subnet-2" {
  transit_gateway_route_table_id = aws_ec2_transit_gateway_route_table.tgw-rtb.id
  destination_cidr_block         = var.dev_subnet2_cidr_block # The CIDR block for the development VPC Subnet 1
  transit_gateway_attachment_id  = aws_ec2_transit_gateway_vpc_attachment.tgw-att-2.id
}

# Create transit gateway route rules for subnet 4
resource "aws_ec2_transit_gateway_route" "tgw-route-subnet-4" {
  transit_gateway_route_table_id = aws_ec2_transit_gateway_route_table.tgw-rtb.id
  destination_cidr_block         = var.dev_subnet3_cidr_block
  transit_gateway_attachment_id  = aws_ec2_transit_gateway_vpc_attachment.tgw-att-4.id
}

# Create transit gateway route rules for subnet 4
resource "aws_ec2_transit_gateway_route" "tgw-route-subnet-4-all" {
  transit_gateway_route_table_id = aws_ec2_transit_gateway_route_table.tgw-rtb.id
  destination_cidr_block         = "0.0.0.0/0"
  transit_gateway_attachment_id  = aws_ec2_transit_gateway_vpc_attachment.tgw-att-4.id
}

/*
# Create an endpoint to connect on ec2 machine - just for test purose
resource "aws_vpc_endpoint" "endpoint-vpc1" {
  vpc_id       = aws_vpc.vpc-1.id
  service_name = "com.amazonaws.us-east-1.ec2"
  #security_group_ids = [aws_security_group.secgrp-1.id]
  #subnet_ids        = [aws_subnet.subnet-1.id]
  #vpc_endpoint_type = "Interface"

  tags = {
    Environment = "${var.environment}-endpoint-vpc1"
  }
}
*/