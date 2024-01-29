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

# Variable
variable "dev_vpc1_cidr_block" {
    description = "Development step cidr_block"
}

variable "dev_vpc2_cidr_block" {
    description = "Development step cidr_block"
}
variable "dev_vpc3_cidr_block" {
    description = "Development step cidr_block"
}
variable "environment" {
    description = "Development step Name"
}

variable "dev_subnet1_cidr_block" {
    description = "Development subnet1 cidr_block"  
}

variable "dev_subnet2_cidr_block" {
    description = "Development subnet2 cidr_block"  
}

variable "dev_subnet3_cidr_block" {
    description = "Development subnet3 cidr_block"  
}


# Create a VPC-1
resource "aws_vpc" "vpc-1" {
    cidr_block = var.dev_vpc1_cidr_block
    tags = {
        Name = "${var.environment}-vpc-1"
    }
}

# Create Internet gateway1
resource "aws_internet_gateway" "igw-1" {
    vpc_id = aws_vpc.vpc-1.id
    tags = {
      Name = "${var.environment}-IGW-1"
    }
}

# Create subnet-1 for VPC-1
resource "aws_subnet" "subnet-1" {
  vpc_id = aws_vpc.vpc-1.id
  cidr_block = var.dev_subnet1_cidr_block

  tags = {
    Name = "${var.environment}-subnet-1"
  }
}

# Create a VPC-2
resource "aws_vpc" "vpc-2" {
    cidr_block = var.dev_vpc2_cidr_block
    tags = {
        Name = "${var.environment}-vpc-1"
    }
}

# Create Internet gateway2
resource "aws_internet_gateway" "igw-2" {
  vpc_id = aws_vpc.vpc-2.id
  tags = {
    Name = "${var.environment}-IGW-2"
  }
}

# Create subnet-2 for VPC-2
resource "aws_subnet" "subnet-2" {
  vpc_id = aws_vpc.vpc-1.id
  cidr_block = var.dev_subnet2_cidr_block

  tags = {
    Name = "${var.environment}-subnet-2"
  }
}

# Create a VPC-3
resource "aws_vpc" "vpc-3" {
    cidr_block = var.dev_vpc3_cidr_block
    tags = {
        Name = "${var.environment}-vpc-3"
    }
}

# Create Internetgateway3
resource "aws_internet_gateway" "igw-3" {
  vpc_id = aws_vpc.vpc-3.id
  tags = {
    Name = "${var.environment}-IGW-3"
  }
}

# Create subnet-3 for VPC-3
resource "aws_subnet" "subnet-3" {
  vpc_id = aws_vpc.vpc-1.id
  cidr_block = var.dev_subnet3_cidr_block

  tags = {
    Name = "${var.environment}-subnet3"
  }
}