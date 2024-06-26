resource "aws_s3_bucket" "s3_01" {
  bucket = "eraki_s3_dev_01"
  force_destroy = true
  object_lock_enabled = false

  tags = {
    Name        = "eraki_s3_dev_01-Tag"
    Environment = "Dev"
  }
}

resource "aws_s3_bucket_public_access_block" "s3_01_dis_pubAcc" {
  bucket = aws_s3_bucket.s3_01.id
  block_public_acls = true
  
  block_public_policy = true
  ignore_public_acls = true
  restrict_public_buckets = true
}