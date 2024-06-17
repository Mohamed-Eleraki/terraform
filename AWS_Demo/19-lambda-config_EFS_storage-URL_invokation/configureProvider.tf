# Configure aws provider
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }

  backend "s3" {
    bucket  = "erakiterrafromstatefiles"
    key     = "19-lambda-config_EFS_storage-URL_invokation/lambda_S3Trigger.tfstate"
    region  = "us-east-1"
    profile = "eraki"
  }
}

# Configure aws provider
provider "aws" {
  region  = "us-east-1"
  profile = "eraki"
}

