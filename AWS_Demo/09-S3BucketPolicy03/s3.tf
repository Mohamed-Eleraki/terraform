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

resource "aws_s3_bucket" "s3_01" {
  bucket = "eraki-s3-dev-01"

  force_destroy       = true  # force destroy even if the bucket not empty
  object_lock_enabled = false

  tags = {
    Name        = "eraki-s3-dev-01-Tag"
    Environment = "Dev"
  }
}

resource "aws_s3_bucket_ownership_controls" "ownership_s3_01" {
  bucket = aws_s3_bucket.s3_01.id
  rule {
    #object_ownership = "BucketOwnerPreferred"
    object_ownership = "ObjectWriter"
  }
}

resource "aws_s3_bucket_acl" "acl_s3_01" {
  depends_on = [aws_s3_bucket_ownership_controls.ownership_s3_01]

  bucket = aws_s3_bucket.s3_01.id
  acl    = "private"
}

# Create bucket policy
resource "aws_s3_bucket_policy" "Policy_s3_01" {
  bucket = aws_s3_bucket.s3_01.id
  policy = <<EOD
  {
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "111",
            "Effect": "Allow",
            "Principal": {
                "AWS": "${aws_iam_user.Hala.arn}"
            },
            "Action": "s3:PutObject",
            "Resource": "${aws_s3_bucket.s3_01.arn}/*"
        }
    ]
}
  EOD
}