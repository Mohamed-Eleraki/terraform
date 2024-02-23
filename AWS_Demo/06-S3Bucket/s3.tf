resource "aws_s3_bucket" "s3-01" {
    bucket = "eraki-s3-dev-01"

    force_destroy = false
    object_lock_enabled = false

    tags    =   {
        Name = "My Bucket"
        Environment = "Dev"
    }
}

resource "aws_s3_bucket_ownership_controls" "s3-01-ownership" {
  bucket = aws_s3_bucket.s3-01.id
  rule {
    object_ownership = "BucketOwnerPreferred"
  }
}

resource "aws_s3_bucket_acl" "s3-01-acl" {
  depends_on = [aws_s3_bucket_ownership_controls.s3-01-ownership]

  bucket = aws_s3_bucket.example.id
  acl    = "private"
}

resource "aws_kms_key" "s3-01-key" {
  description             = "This key is used to encrypt bucket objects"
  deletion_window_in_days = 10
}

resource "aws_s3_bucket_server_side_encryption_configuration" "s3-01-encryption-configs" {
  bucket = aws_s3_bucket.s3-01.id

  rule {
    apply_server_side_encryption_by_default {
      kms_master_key_id = aws_kms_key.s3-01-key.arn
      sse_algorithm     = "aws:kms"
    }
  }
}

resource "aws_s3_bucket_versioning" "s3-01-versioning-configs" {
  bucket = aws_s3_bucket.s3-01.id
  versioning_configuration {
    status = "disabled"
  }
}

# Please note, that by using the resource, Object Lock can be enabled/disabled without destroying and recreating the bucket.
resource "aws_s3_bucket_object_lock_configuration" "s3-01-obj-lock" {
  bucket = aws_s3_bucket.s3-01.id

  rule {
    default_retention {
      mode = "COMPLIANCE"
      days = 5
    }
  }
}

resource "aws_s3_bucket_public_access_block" "s3-01-dis-pubacc" {
  bucket = aws_s3_bucket.s3-01.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}