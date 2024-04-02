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

# Create inline policy have access on lambda funtions
resource "aws_iam_policy" "inlinePolicy_access_lambda" {
  name = "inlinePolicy_access_lambda"
  policy = jsonencode({
    Version   = "2012-10-17",
    Statement = [
        {
            Action = [
                "lambda:InvokeFunction",
                "lambda:InvokeAsync"
            ]
            Effect = "Allow"
            Resource = "arn:aws:lambda:*:*:function:*"

        }
    ]
  })
}

# Create iam role holds the policy 
resource "aws_iam_role" "iam_role_access_lambda" {
  name = "iam_role_acces_lambda"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
        {
            Action = "sts:AssumeRole"
            Principal = {
                Service = "lambda.amazonaws.com"
            }
            Effect = "Allow"
        },
    ]
  })
}

# Attaach custome policy to the role
resource "aws_iam_role_policy_attachment" "lambda_policy_attachment01" {
  role = aws_iam_role.iam_role_access_lambda.name
  policy_arn = aws_iam_policy.inlinePolicy_access_lambda.arn
}

# Create a default role for lambda to invoke
resource "aws_iam_role" "default_role" {
  name = "defaultRole_lambda_to_invoke"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect    = "Allow"
        Principal = {
          Service = "lambda.amazonaws.com"
        }
        Action    = "sts:AssumeRole"
      }
    ]
  })
}

# Create inline policy have access on ec2 in order to create lambda interface
resource "aws_iam_policy" "inlinePolicy_lambda_ec2Interface" {
  name = "inlinePolicy_lambda_ec2Interface"
  policy = jsonencode({
    Version   = "2012-10-17",
    Statement = [
        {
            Action = [
                "ec2:CreateNetworkInterface",
                "ec2:DescribeNetworkInterfaces",
                "ec2:DeleteNetworkInterface"
            ]
            Effect = "Allow"
            Resource = "*"

        }
    ]
  })
}

# Attaach custome policy to the role
resource "aws_iam_role_policy_attachment" "lambda_policy_attachment02" {
  role = aws_iam_role.default_role.name
  policy_arn = aws_iam_policy.inlinePolicy_lambda_ec2Interface02.arn
}


# Create inline policy have access on ec2 in order to create lambda interface
resource "aws_iam_policy" "inlinePolicy_lambda_ec2Interface02" {
  name = "inlinePolicy_lambda_ec2Interface02"
  policy = jsonencode({
    Version   = "2012-10-17",
    Statement = [
        {
            Action = [
                "ec2:CreateNetworkInterface",
                "ec2:DescribeNetworkInterfaces",
                "ec2:DeleteNetworkInterface"
            ]
            Effect = "Allow"
            Resource = "*"

        }
    ]
  })
}

# Attaach custome policy to the role
resource "aws_iam_role_policy_attachment" "lambda_policy_attachment04" {
  role = aws_iam_role.iam_role_access_lambda.name
  policy_arn = aws_iam_policy.inlinePolicy_lambda_ec2Interface.arn
}
/*
resource "aws_iam_role_policy_attachment" "lambda_policy_attachment03" {
  role       = aws_iam_role.default_role.id
  policy_arn = "arn:aws:iam::aws:policy/AWSLambdaBasicExecutionRole"
}*/

