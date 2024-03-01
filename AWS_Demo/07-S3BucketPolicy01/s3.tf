# Configure aws provider
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

# Configure aws provider
provider "aws" {
  region  = "us-east-1"
  profile = "eraki"
}

# Create S3 Bucket
resource "aws_s3_bucket" "s3-01" {
  bucket = "eraki-s3-dev-01"

  tags = {
    Name = "eraki-s3-dev-01-Tag"
  }
}

# Block public access
resource "aws_s3_bucket_public_access_block" "s3-01-blockPubAcc" {
  bucket = aws_s3_bucket.s3-01.id
  block_public_acls = true
  block_public_policy = true
  ignore_public_acls = true
  restrict_public_buckets = true
}

# Assign Bucket policy
resource "aws_s3_bucket_policy" "s3-01-policy" {
  bucket = aws_s3_bucket.s3-01.id
  policy = <<EOF
  {
   "Version": "2012-10-17",
   "Statement": [
      {
         "Sid": "statement1",
         "Effect": "Allow",
         "Principal": {
            "AWS": "${aws_iam_user.user-Dave.arn}"
         },
         "Action": [
            "s3:GetBucketLocation",
            "s3:ListBucket"
         ],
         "Resource": [
            "${aws_s3_bucket.s3-01.arn}"
         ]
      },
      {
         "Sid": "statement2",
         "Effect": "Allow",
         "Principal": {
            "AWS": "${aws_iam_user.user-Dave.arn}"
         },
         "Action": [
             "s3:GetObject",
             "s3:PutObject"
         ],
         "Resource": [
            "${aws_s3_bucket.s3-01.arn}/*"
         ]
      }
   ]
}
  EOF
}