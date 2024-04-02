# Create lambda funtion - to invoke
resource "aws_lambda_function" "lambda_to_invoke" {
  function_name = "lambda_to_invoke"
  filename = "${path.module}/lambdaToInvoke.zip"
  source_code_hash = filebase64sha256("${path.module}/lambdaToInvoke.zip")
  handler = "lambda_to_invoke.lambda_handler"
  role = aws_iam_role.default_role.arn
  runtime = "python3.12"
  timeout = 300

  vpc_config {
    subnet_ids = [ aws_subnet.subnet-1.id ]
    security_group_ids = [ aws_security_group.lambda_sg.id ]
  }
}

# Create lambda function - invoker
resource "aws_lambda_function" "lambda_invoker" {
  depends_on = [ aws_lambda_function.lambda_to_invoke ]
  function_name = "lambda_invoker"
  filename = "${path.module}/lambdaInvoker.zip"
  source_code_hash = filebase64sha256("${path.module}/lambdaInvoker.zip")
  handler = "lambda_invoker.lambda_handler"
  role = aws_iam_role.iam_role_access_lambda.arn
  runtime = "python3.12"
  timeout = 300

  vpc_config {
    subnet_ids = [ aws_subnet.subnet-1.id ]
    security_group_ids = [ aws_security_group.lambda_sg.id ]
  }
}

output "lambda_to_invoker_arn" {
  value = aws_lambda_function.lambda_to_invoke.arn
}