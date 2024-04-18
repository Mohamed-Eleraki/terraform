# run the bash script to install and package and all dependencies
resource "null_resource" "create_fetchVPCs_layer" {
  provisioner "local-exec" {
    command = "sh scripts/create_layer.sh"
  }
}

# Deploy lambda layer resource
resource "aws_lambda_layer_version" "fetchVPCs_layer" {
  # Delay untill dependencies packages are available
  depends_on = [ null_resource.create_fetchVPCs_layer ]

  # mention file path of created package
  filename            = "${path.module}/scripts/fetchVPCs_depens_packages.zip"

  layer_name          = "fetchVPCs_layer"
  compatible_runtimes = ["python3.12", "python3.11"]
}

# Deploy lambda function
resource "aws_lambda_function" "fetchVPCs_function" {
  function_name    = "fetch_vpcs_Function"

  # zip file path holds python script
  filename         = "${path.module}/scripts/fetch_vpcs.zip"
  source_code_hash = filebase64sha256("${path.module}/scripts/fetch_vpcs.zip")

  # handler name = file_name.python_function_name
  handler          = "fetch_vpcs.lambda_handler"
  runtime          = "python3.12"
  timeout          = 120

  # utilizing deployed Role
  role             = aws_iam_role.lambda_iam_role.arn

  # utilizing deployed layer
  layers = [aws_lambda_layer_version.fetchVPCs_layer.arn]
}

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
    "arn:aws:iam::aws:policy/AmazonEC2FullAccess"
  ]

}


# import {
#     to = aws_iam_role.lambda_iam_role
#     id = "lambda_iam_role"
# }

# import {
#     to = aws_lambda_layer_version.fetchVPCs_layer
#     #id = "fetchVPCs_layer"
#     id = "arn:aws:lambda:us-east-1:891377122503:layer:fetchVPCs_layer:2"
# }