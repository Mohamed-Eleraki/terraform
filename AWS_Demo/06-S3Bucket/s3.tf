resource "aws_s3_bucket" "s3-01" {
    bucket = "eraki-s3-dev-01"

    force_destroy = false
    object_lock_enabled = false

    tags    =   {
        Name = "eraki-s3-dev-01-Tag"
        Environment = "Dev"
    }
}

resource "aws_s3_bucket_ownership_controls" "s3-01-ownership" {
  bucket = aws_s3_bucket.s3-01.id
  rule {
    object_ownership = "BucketOwnerPreferred" # BucketOwnerPreferred >> Bucket owner automatically 
    # owns and has full control over every object in the bucket. ACLs no longer affect permissions 
    # to data in the S3 bucket.
    # https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_ownership_controls#object_ownership
  }
}

resource "aws_s3_bucket_acl" "s3-01-acl" {
  depends_on = [aws_s3_bucket_ownership_controls.s3-01-ownership]

  bucket = aws_s3_bucket.s3-01.id
  acl    = "private"  # only the owner of the S3 bucket will have access to list or 
  # upload objects in the bucket.
  # https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_acl
}

resource "aws_kms_key" "s3-01-key" {
  description             = "This key is used to encrypt bucket objects"
  deletion_window_in_days = 10
}

/*
resource "aws_s3_bucket_server_side_encryption_configuration" "s3-01-encryption-configs" {
  bucket = aws_s3_bucket.s3-01.id

  rule {
    apply_server_side_encryption_by_default {
      kms_master_key_id = aws_kms_key.s3-01-key.arn
      sse_algorithm     = "aws:kms"
    }
  }
}
*/

resource "aws_s3_bucket_versioning" "s3-01-versioning-configs" {
  bucket = aws_s3_bucket.s3-01.id
  versioning_configuration {
    status = "Disabled"
  }
}

/*
resource "aws_s3_bucket_object_lock_configuration" "s3-01-obj-lock" {
  bucket = aws_s3_bucket.s3-01.id

  rule {
    default_retention {
      mode = "COMPLIANCE"
      days = 5
      # This rule configure the S3 to enable lock configs, to prevent accidentally deleting 
      # However, the lock retention sets to 5 days, after this period you can delete objects.
    }
  }
  # Please note, that by using the resource, Object Lock can be enabled/disabled without destroying 
  # and recreating the bucket.
} */

resource "aws_s3_bucket_public_access_block" "s3-01-dis-pubacc" {
  bucket = aws_s3_bucket.s3-01.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}