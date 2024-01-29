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
variable "dev_vpc1_cider_block" {
    description = "Development step cider block"
}

variable "dev_vpc2_cider_block" {}
variable "dev_vpc3_cider_block" {}
variable "environment" {}

# Create a VPC-1
resource "aws_vpc" "vpc-1" {
    cider_block = var.dev_vpc1_cider_block
    tags = {
        Name = "${var.environment}-vpc-1"
    }
}

# Create a VPC-2
resource "aws_vpc" "vpc-2" {
    cider_block = var.dev_vpc2_cider_block
    tags = {
        Name = "${var.environment}-vpc-1"
    }
}

# Create a VPC-3
resource "aws_vpc" "vpc-3" {
    cider_block = var.dev_vpc3_cider_block
    tags = {
        Name = "${var.environment}-vpc-3"
    }
}