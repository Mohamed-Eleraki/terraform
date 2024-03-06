# Configure aws provider
terraform {
  required_providers {
    aws = {
        source = "hashicorp/aws"
        version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = "us-east-1"
  profile = "eraki"
}

resource "aws_s3_bucket" "s3-01" {
  bucket = "eraki-s3-dev-01"
  force_destroy = true
  object_lock_enabled = false

  tags = {
    Name        = "eraki-s3-dev-01-Tag"
    Environment = "Dev"
  }
}

resource "aws_s3_bucket_public_access_block" "s3-01-dis-pubAcc" {
  bucket = aws_s3_bucket.s3-01.id
  block_public_acls = true
  block_public_policy = true
  ignore_public_acls = true
  restrict_public_buckets = true
}