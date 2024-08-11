terraform {
  required_providers {
    aws = {
        source = "hashicorp/aws"
        version = "~> 5.0"
    }
  }

  backend "s3" {
    bucket = "erakiterrafromstatefiles"
    key = "create_modules.tf"
    region = "us-east-1"
    profile = "eraki"
  }
}


provider "aws" {
  region = "us-east-1"
  profile = "eraki"
}