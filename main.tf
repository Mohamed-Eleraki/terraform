#test
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

# Create a VPC
resource "aws_vpc" "development-vpc" {
  cidr_block = "10.0.0.0/16"
  tags = {
    Name = "main_vpc"
  }
}

# Create a subnet of the development-vpc Vpc
resource "aws_subnet" "dev-subnet-1" {
  
  vpc_id     = aws_vpc.development-vpc.id
  cidr_block = "10.0.10.0/24"
  availability_zone = "us-east-1a"
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
    Name = "default_dev_subnet"
  }
}