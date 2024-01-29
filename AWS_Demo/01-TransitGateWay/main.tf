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

# Create a VPC-1
resource "aws_vpc" "vpc-1" {
    cidr_block = var.dev_vpc1_cidr_block
    tags = {
        Name = "${var.environment}-vpc-1"
    }
}

# Create a VPC-2
resource "aws_vpc" "vpc-2" {
    cidr_block = var.dev_vpc2_cidr_block
    tags = {
        Name = "${var.environment}-vpc-1"
    }
}

# Create a VPC-3
resource "aws_vpc" "vpc-3" {
    cidr_block = var.dev_vpc3_cidr_block
    tags = {
        Name = "${var.environment}-vpc-3"
    }
}