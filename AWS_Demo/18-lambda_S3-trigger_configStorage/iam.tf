
# Create an IAM role of lambda function
resource "aws_iam_role" "lambda_iam_role" {
  name = "lambda_iam_role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Principal = {
          Service = "lambda.amazonaws.com"
        }
        Effect = "Allow"
        Sid    = "111"
      },
    ]
  })

  managed_policy_arns = [
    #"arn:aws:iam::aws:policy/AmazonSSMFullAccess",
    "arn:aws:iam::aws:policy/AmazonEC2FullAccess",
    "arn:aws:iam::aws:policy/AmazonS3FullAccess"
  ]

}

# # Create policy document
# data "aws_iam_policy_document" "lambda_policy_allow_s3" {
#   statement {
#     sid    = 001
#     effect = "Allow"
#     actions = [
#       "s3:*"
#     ]
#     resources = [
#       "${aws_s3_bucket.BucketOne.arn}/*",
#       "${aws_s3_bucket.BucketTwo.arn}/*"
#     ]
#   }
#   statement {
#     sid    = 002
#     effect = "Allow"
#     actions = [
#       "logs:*"
#     ]
#     resources = [
#       "arn:aws:logs:*:*:*"
#     ]
#   }
# } # grants the Lambda function permission to write logs to Amazon CloudWatch

# # Creaet policy just to hold the document created
# resource "aws_iam_policy" "lambda_Custom_policy" {
#   name   = "lambda_Custom_policy"
#   policy = data.aws_iam_policy_document.lambda_policy_allow_s3.json
# }

# # Attch policy to role
# resource "aws_iam_role_policy_attachment" "lambda_policy_attachemnt" {
#   role       = aws_iam_role.lambda_iam_role.name
#   policy_arn = aws_iam_policy.lambda_Custom_policy.arn
# }
