# Configure aws provider
terraform {
  required_providers {
    aws = {
        source = "hashicorp/aws"
        version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = "us-east-1"
  profile = "eraki"
}


# Create a document based on AWS-RunPatchBaseline Doc
resource "aws_ssm_document" "ssm_document_s3_put_filestream_01" {
  name          = "companyName-SSM-S3-PUT-Region-accountName-funcName"
  document_type = "Command"

  content = file("${path.module}/scripts/fileStream_offlineServer-PutTest.json")
}

# Create inline policy for defualt lambda policy
resource "aws_iam_policy" "policy_inline_Lambda_default" {
  name = "companyName-IAM-POLICY-Region-accountName-funcName"
  policy = jsonencode({
    Statement = [
      {
        Action = [
          "logs:CreateLogGroup",
        ]
        Effect   = "Allow"
        Resource = "*arn:aws:logs:us-east-1:098134220116:*"
      },
      {
        Action = [
          "logs:CreateLogStream",
          "logs:PutLogEvents",
        ]
        Effect   = "Allow"
        Resource = "arn:aws:logs:us-east-1:098134220116:log-group:/aws/lambda/${aws_lambda_function.fileStream_OfflineServer.function_name}:*"
      },
    ]
  })
}

# Create a role for lambda
resource "aws_iam_role" "iam_role_s3_ssm_full_access_01" {
  name = "companyName-IAM-ROLE-Region-accountName-funcName"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Principal = {
          Service = "s3.amazonaws.com"
        }
        Effect = "Allow"
        Sid    = ""
      },
    ]
  })

  managed_policy_arns = [  # Accept only managed policies
      "arn:aws:iam::aws:policy/AmazonS3FullAccess", 
      "arn:aws:iam::aws:policy/AmazonSSMFullAccess"   
  ]
}

# Attach default lambda role - Custom policy
resource "aws_iam_role_policy_attachment" "default_policy_att_01" {
  role       = aws_iam_role.iam_role_s3_ssm_full_access_01.name
  policy_arn = aws_iam_policy.policy_inline_Lambda_default.arn
}

# Create a Lambda funtion that run the SSM Document
resource "aws_lambda_function" "fileStream_OfflineServer" {
  filename = "${path.module}/scripts/fileStream-offlineServer.py"
  function_name = "companyName-FileStream-serverName"
  role          = aws_iam_role.iam_role_s3_ssm_full_access_01.arn
  handler       = "fileStream-serverName.lambda_handler"
  source_code_hash = filebase64sha256("${path.module}/scripts/fileStream-offlineServer.py")
  runtime = "python3.12"
  timeout     = 300
  vpc_config {
    subnet_ids = [aws_subnet.primary_private_subnets[0].id]
    security_group_ids = [aws_security_group.sgs["sgName"].id]
  }
}