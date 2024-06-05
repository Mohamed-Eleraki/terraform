resource "aws_s3_bucket" "BucketOne" {
  bucket = "bucket-one50001"
  force_destroy = true
  tags = {
    Name = "BucketOne"
  }
}

resource "aws_s3_bucket" "BucketTwo" {
  bucket = "bucket-two50002"
  force_destroy = true
  tags = {
    Name = "BucketTwo"
  }
}