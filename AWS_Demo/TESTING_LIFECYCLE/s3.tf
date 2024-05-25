# Deploy an S3 Bucket and directorites
resource "aws_s3_bucket" "s3_01" {
  bucket = "eraki-s3-dev-01"
}

#########################
# Deploy s3 directories #
#########################

resource "aws_s3_object" "directory_object_s3_01_logs" {
  bucket       = aws_s3_bucket.s3_01.id
  key          = "logs/"
  content_type = "application/x-directory"
}


#############################################
# Deploy lifecycle resources configurations #
#############################################

# Deploy lifecycle resource configuration
resource "aws_s3_bucket_lifecycle_configuration" "lifeCycle_configs" {
  bucket = aws_s3_bucket.s3_01.id

  #######################
  # logs directory rule #
  #######################
  rule {
    id = "log-directory"

    filter { # filter the bucket based on the path prefix 
      prefix = "logs/"
    }

    # transition { # move the files to infrequent access tier 30 days after creation time
    #   days          = 30
    #   storage_class = "STANDARD_IA"
    # }

    transition { # move the files to Archive tier 90 days after creation time.
      days          = 0
      storage_class = "GLACIER"
    }

    # transition { # move the files to the deep archive tier 180 days after creation time.
    #   days          = 180
    #   storage_class = "DEEP_ARCHIVE"
    # }

    expiration { # Delete objects a year after creation time.
      days = 3
    }
    # Enable the rule
    status = "Enabled"
  }
}