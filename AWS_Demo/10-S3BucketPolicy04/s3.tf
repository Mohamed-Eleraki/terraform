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
resource "aws_s3_bucket" "s3_01" {
  bucket = "eraki-s3-dev-01"
  force_destroy = true
  object_lock_enabled = false
}

# Block public access
resource "aws_s3_bucket_public_access_block" "block_public_access_s3_01" {
  bucket = aws_s3_bucket.s3_01.id
  block_public_acls = true
  block_public_policy = true
  ignore_public_acls = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket_policy" "s3_01_policy" {
  bucket = aws_s3_bucket.s3_01.id
  policy = data.aws_iam_policy_document.policy_document_s3_01_dave.json
}

# Create policy document
data "aws_iam_policy_document" "policy_document_s3_01_dave" {
  statement {
    principals {
      type        = "AWS"
      identifiers = ["${aws_iam_user.Dave.arn}"]
    }

    actions = [
      "s3:GetBucketLocation",
      "s3:ListBucket",
      "s3:PutObject",
      "s3:GetObject",
      "s3:DeleteObject",
    ]

    resources = [
      aws_s3_bucket.s3_01.arn,
      "${aws_s3_bucket.s3_01.arn}/*",
    ]
  }

  statement {
    principals {
      type        = "AWS"
      identifiers = ["${aws_iam_user.Tom.arn}"]
    }

    actions = [
      "s3:PutObject",
      "s3:GetObject",
    ]

    resources = [
      "${aws_s3_bucket.s3_01.arn}/Tom/*",
    ]
  }

  statement {
    principals {
      type        = "AWS"
      identifiers = ["${aws_iam_user.Paul.arn}"]
    }

    actions = [
      "s3:GetObject",
    ]

    resources = [
      "${aws_s3_bucket.s3_01.arn}/Tom/*",
    ]
  }
}

# Create S3 objects (i.e directories) for Tom
resource "aws_s3_object" "directory_object_s3_01_tom" {
  bucket = aws_s3_bucket.s3_01.id
  key    = "Tom/"
  content_type = "application/x-directory"
}

# Create S3 Object (i.e directories)
resource "aws_s3_object" "directory_object_s3_01_public" {
  bucket = aws_s3_bucket.s3_01.id
  key = "Public/"
  content_type = "application/x-directory"
}

# List of policies
#  * s3:GetObject
#  * s3:PutObject
#  * s3:DeleteObject
#  * s3:ListBucket
#  * s3:GetObjectAcl
#  * s3:PutObjectAcl
#  * s3:CreateBucket
#  * s3:ListBuckets
#  * s3:DeleteBucket
#  * s3:GetBucketAcl
#  * s3:PutBucketAcl
#  * s3:GetObjectVersion
#  * s3:DeleteObjectVersion
#  * s3:GetObjectEncryption
#  * s3:PutObjectAcl