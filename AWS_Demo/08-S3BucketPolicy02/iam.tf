resource "aws_iam_user" "iam-user-dave" {
  name = "Dave"
  force_destroy = true
}

resource "aws_iam_user_policy" "iam-user-dave_policy" {
  name = "AllowDaveToPutGetS3"
  user = aws_iam_user.iam-user-dave.name

  # Terraform's "jsonencode" function converts a
  # Terraform expression result to valid JSON syntax.
    policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "s3:PutObject",
          "s3:GetObject"
        ]
        Effect   = "Allow"
        Resource = "${aws_s3_bucket.s3-01.arn}/*"
      },
    ]
  })
}



resource "aws_iam_access_key" "iam-user-dave-AccKey" {
  user = aws_iam_user.iam-user-dave.name
}