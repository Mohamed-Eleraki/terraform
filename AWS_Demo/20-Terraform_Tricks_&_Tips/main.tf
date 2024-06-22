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
    profile = "eraki"
}

resource "aws_iam_user" "test01" {
  name = "mohamed"

  tags = {
    Name = "mohamed_user"
    Environment = "terraformChamps"
    Owner = "eraki"
  }
}

resource "aws_iam_user" "test02" {
  name = "Hala"

  tags = {
    Name = "mohamed_user"
    Environment = "terraformChamps"
    Owner = "eraki"
  }

  lifecycle {
    ignore_changes = [
      id,  # by defining the resource ID will ingore the entire resource
    ]
  }
}

resource "aws_instance" "ec2-1" {
  ami = "ami-0a3c3a20c09d6f377"
  instance_type = "t2.micro"
  
  lifecycle {
    ignore_changes = [ 
      instance_type,
     ]
  }

}