resource "aws_iam_user" "iam_user_dave" {
  name = "Dave"
  #force_destroy = true # no need for it now as we not creating Secret Key
}

resource "aws_iam_user_policy" "iam_user_dave_policy" {
  name = "AllowDaveToPutGetS3"
  user = aws_iam_user.iam_user_dave.name

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
        Resource = "${aws_s3_bucket.s3_01.arn}/*"
      },
    ]
  })
}