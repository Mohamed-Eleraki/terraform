provider "aws" {
  region  = "us-east-1"
  profile = "eraki"
}

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
    "arn:aws:iam::aws:policy/AmazonEC2FullAccess"
  ]
}

resource "aws_lambda_function" "fetchVpc_function" {
  function_name    = "fetchVpc_function"
  filename         = "${path.module}/lambda.zip"
  source_code_hash = filebase64("${path.module}/lambda.zip")
  handler          = "lambda.lambda_handler"
  runtime          = "python3.11"
  timeout          = 120
  role             = aws_iam_role.lambda_iam_role.arn
}