# Create a lambda function that invoke SSM Document
resource "aws_lambda_function" "lambda_to_invoke_SSM" {
  function_name    = "invokeSSMFunction"
  filename         = "${path.module}/scripts/invokeSSMFunction.zip"
  source_code_hash = filebase64sha256("${path.module}/scripts/invokeSSMFunction.zip")
  handler          = "invokeSSMFunction.lambda_handler"
  runtime          = "python3.12"
  timeout          = 120
  role             = aws_iam_role.iam_role_ssm_full_access.arn

  #   vpc_config {
  #     subnet_ids         = [aws_subnet.subnet_1.id]
  #     security_group_ids = [aws_security_group.security_group_1_ec2.id]
  #   }

  environment {
    variables = {
      EC2_INSTANCE_ID = aws_instance.ec2_instance_1.id
    }
  }

}