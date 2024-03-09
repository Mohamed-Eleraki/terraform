resource "aws_iam_user" "Dave" {
  name = "Dave"
}

resource "aws_iam_user" "Paul" {
  name = "Paul"
}

resource "aws_iam_user" "Tom" {
  name = "Tom"
}



/*
<<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "Statement1",
            "Effect": "Allow",
            "Principal": {
                "AWS": "arn:aws:iam::891377122503:user/Dave"
            },
            "Action": [
                "s3:GetBucketLocation",
                "s3:ListBucket"
            ],
            "Resource": "arn:aws:s3:::eraki-s3-dev-01"
        },
        {
            "Sid": "statement2",
            "Effect": "Allow",
            "Principal": {
                "AWS": "arn:aws:iam::891377122503:user/Dave"
            },
            "Action": [
                "s3:PutObject",
                "s3:GetObject",
                "s3:DeleteObject"
            ],
            "Resource": "arn:aws:s3:::eraki-s3-dev-01/*"
        },
        {
            "Sid": "statement3",
            "Effect": "Allow",
            "Principal": {
                "AWS": "arn:aws:iam::891377122503:user/Tom"
            },
            "Action": [
                "s3:GetObject",
                "s3:PutObject"
            ],
            "Resource": "arn:aws:s3:::eraki-s3-dev-01/Tom/*"
        },
        {
            "Sid": "statement4",
            "Effect": "Allow",
            "Principal": {
                "AWS": "arn:aws:iam::891377122503:user/Paul"
            },
            "Action": "s3:GetObject",
            "Resource": "arn:aws:s3:::eraki-s3-dev-01/Tom/*"
        }
    ]
}
  EOF
  */