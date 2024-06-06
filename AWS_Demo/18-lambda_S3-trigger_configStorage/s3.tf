# Deploy Bucket one
resource "aws_s3_bucket" "BucketOne" {
  bucket        = "bucket-one50001"
  force_destroy = true
  tags = {
    Name = "BucketOne"
  }
}

# Deploy Bucket two
resource "aws_s3_bucket" "BucketTwo" {
  bucket        = "bucket-two50002"
  force_destroy = true
  tags = {
    Name = "BucketTwo"
  }
}

# Deploy lifecycle configurations of BuckettOne
resource "aws_s3_bucket_lifecycle_configuration" "lifecycle_BucketOne" {
  bucket = aws_s3_bucket.BucketOne.id

  rule {
    id = "BucketOne_expiration"

    expiration { # Delete objects a Week after creation time.
      days = 7
    }
    status = "Enabled"
  }
}

# Deploy lifecycle configurations of BuckettTwo
resource "aws_s3_bucket_lifecycle_configuration" "lifecycle_BucketTwo" {
  bucket = aws_s3_bucket.BucketTwo.id

  rule {
    id = "BucketTwo_rules"

    transition { # Store the files into Glacier class from day one.
      days          = 0
      storage_class = "GLACIER"
    }
    expiration { # Delete objects Three years after creation time.
      days = 1095
    }
    status = "Enabled"
  }
}