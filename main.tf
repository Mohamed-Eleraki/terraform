# Configure the AWS Provider
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

# Configure the AWS Provider
provider "aws" {
  region = "us-east-1"
}

# Variables
variable "dev_subnet_cider_block" {
  description = "Development subnet cider block"
}

variable "environment" {
  description = "Development environment name"
}


# Create a VPC
resource "aws_vpc" "development-vpc" {
  cidr_block = "10.0.0.0/16"
  tags = {
    Name = "${var.environment}-prv-vpc"
  }
}

# Create a subnet of the development-vpc Vpc
resource "aws_subnet" "dev-subnet-1" {
  
  vpc_id     = aws_vpc.development-vpc.id
  cidr_block = var.dev_subnet_cider_block
  availability_zone = "us-east-1a"
  tags = {
    Name = "${var.environment}-Subnet-1"
  }
}

# Fetch the default VPC in order to create a subnet in it
data "aws_vpc" "existing-vpc" {
  default = true
}

# Create a subnet in the default vpc
resource "aws_subnet" "dev-subnet-2" {
  vpc_id = data.aws_vpc.existing-vpc.id 
  cidr_block = "172.31.30.0/24"
  availability_zone =  "us-east-1a"
  tags = {
    Name = "default_subnet"
  }
}

output "development-vpc" {
  value = aws_vpc.development-vpc.id
}

output "development-subnet" {
  value = aws_subnet.dev-subnet-1.id
}

output "existing-vpc" {
  value = aws_subnet.dev-subnet-2.id
}