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
  profile = "eraki" # force destroy even if the bucket not empty
}

# Create S3 Bucket
resource "aws_s3_bucket" "s3_01" {
  bucket = "eraki-s3-dev-01"

  force_destroy       = true # force destroy even if the bucket not empty
  object_lock_enabled = false

  tags = {
    Name        = "eraki-s3-dev-01-Tag"
    Environment = "Dev"
  }
}

# Set the ownership of objects to the object writer
resource "aws_s3_bucket_ownership_controls" "ownership_s3_01" {
  bucket = aws_s3_bucket.s3_01.id
  rule {
    #object_ownership = "BucketOwnerPreferred"
    object_ownership = "ObjectWriter"
  }
}

# Enable ACL as private
resource "aws_s3_bucket_acl" "acl_s3_01" {
  depends_on = [aws_s3_bucket_ownership_controls.ownership_s3_01]

  bucket = aws_s3_bucket.s3_01.id
  acl    = "private"
}


# Create bucket policy by mentioning the policy below
resource "aws_s3_bucket_policy" "Policy_s3_01" {
  bucket = aws_s3_bucket.s3_01.id
  policy = data.aws_iam_policy_document.policy_document_s3_01.json
}

# Fetch the Bucket Owner canonical id
data "aws_canonical_user_id" "current_user" {}

# Create policy document
data "aws_iam_policy_document" "policy_document_s3_01" {
  statement {
    sid    = "111"
    effect = "Allow"
    principals {
      type        = "AWS"
      identifiers = ["${aws_iam_user.Mostafa.arn}"]
    }

    actions = [
      "s3:PutObject"
    ]

    resources = [
      "${aws_s3_bucket.s3_01.arn}/mostafa/*"
    ]
  }

  statement {
    sid    = "112"
    effect = "Deny"
    principals {
      type        = "AWS"
      identifiers = ["${aws_iam_user.Mostafa.arn}"]
    }

    actions = [
      "s3:PutObject"
    ]

    resources = [
      "${aws_s3_bucket.s3_01.arn}/mostafa/*"
    ]

    condition {
      test     = "StringNotEquals"
      variable = "s3:x-amz-grant-full-control"
      values   = ["id=${data.aws_canonical_user_id.current_user.id}"]
    }
  }

  statement {
    sid    = "113"
    effect = "Allow"
    principals {
      type        = "AWS"
      identifiers = ["${aws_iam_user.Mohamed.arn}"]
    }

    actions = [
      "s3:PutObject",
      "s3:GetObject",
      "s3:DeleteObject",
      "s3:ListBucket"
    ]

    resources = [
      aws_s3_bucket.s3_01.arn,
      "${aws_s3_bucket.s3_01.arn}/*"
    ]
  }
}

# Create S3 objects (i.e directories)
resource "aws_s3_object" "directory_object_s3_01_mostafa" {
  bucket       = aws_s3_bucket.s3_01.id
  key          = "mostafa/"
  content_type = "application/x-directoy"
}





# s3api commands
# aws s3api put-object --bucket eraki-s3-dev-01 --key mostafa/uploadMostafa.file --body uploadMostafa.file --grant-full-control id="b6d5c09c7a1d221375aced56c0bd9d32a1591e6a1512b61f1924e0e505c715cd" --profile mostafa