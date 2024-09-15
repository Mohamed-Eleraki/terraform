terraform {
  required_providers {
    aws = {
        source = "hashicorp/aws"
        version = "~> 5.0"
    }
  }
/*
  backend "s3" {
    bucket = "erakiterrafromstatefiles"
    key = "test-pipeline.tf"
    region = "us-east-1"
    #profile = "eraki"
  }*/
}

provider "aws" {
  region = "us-east-1" # Change this to your desired region
  assume_role {
    role_arn     = "arn:aws:iam::891377122503:role/service-role/AWSCodePipelineServiceRole-us-east-1-eraki_pipeline_us1_tagtrig"
    session_name = "TerraformSession"
  }
}