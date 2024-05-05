# Deploy an S3 Bucket and directorites
resource "aws_s3_bucket" "s3_01" {
  bucket = "eraki-s3-dev-01"
}

# # Block public access  
# resource "aws_s3_bucket_public_access_block" "block_public_access_s3_01" {
#   bucket = aws_s3_bucket.s3_01.id
#   block_public_acls = true
#   block_public_policy = true
#   ignore_public_acls = true
#   restrict_public_buckets = true
# }

#########################
# Deploy s3 directories #
#########################
resource "aws_s3_object" "directory_object_s3_01_outgoing" {
  bucket       = aws_s3_bucket.s3_01.id
  key          = "outgoing/"
  content_type = "application/x-directory"
}

resource "aws_s3_object" "directory_object_s3_01_incoming" {
  bucket       = aws_s3_bucket.s3_01.id
  key          = "incoming/"
  content_type = "application/x-directory"
}

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

    transition { # move the files to infrequent access tier 30 days after creation time
      days          = 30
      storage_class = "STANDARD_IA"
    }

    transition { # move the files to Archive tier 90 days after creation time.
      days          = 90
      storage_class = "GLACIER"
    }

    transition { # move the files to the deep archive tier 180 days after creation time.
      days          = 180
      storage_class = "DEEP_ARCHIVE"
    }

    expiration { # Delete objects a year after creation time.
      days = 365
    }
    # Enable the rule
    status = "Enabled"
  }


  ###########################
  # outgoing directory rule #
  ###########################
  rule {
    id = "outgoing-directory"

    filter {
      tag { # filter objects based on objects tag & under outgoing directory object
        key   = "Name"
        value = "notDeepArchvie"
      }
      and {
        prefix = "outgoing/"
      }
    }

    transition { # Move to Infrequent access tier 30 days after creation time
      days          = 30
      storage_class = "STANDARD_IA"
    }

    transition { # Move to Archive access tier 90 days after creation time
      days          = 90
      storage_class = "GLACIER"
    }

    expiration { # Delete objects a year after creation time.
      days = 365
    }

    # Enable the rule
    status = "Enabled"
  }


  ###########################
  # incoming directory rule #
  ##########################
  rule {
    id = "incoming-directory"

    filter {
      prefix = "incoming/"

      # Filter files it's size is between 1MB to 1G
      object_size_greater_than = 1000000    # in Bytes
      object_size_less_than    = 1073741824 # in Bytes
    }

    transition { # Move to Infrequent access tier 30 days after creation time
      days          = 30
      storage_class = "STANDARD_IA"
    }

    transition { # Move to Archive access tier 90 days after creation time
      days          = 90
      storage_class = "GLACIER"
    }

    # Enable the rule
    status = "Enabled"
  }
}