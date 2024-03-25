# Create lambda funtion - to invoke
resource "aws_lambda_function" "lambda_to_invoke" {
  function_name = "lambda_to_invoke"
  filename = "${path.module}/lambdaToInvoke.py"
  source_code_hash = filebase64sha256("${path.module}/lambdaToInvoke.py")
  handler = "lambda_to_invoke.lambda_handler"
  role = aws_iam_role.default_role.arn
  runtime = "python3.12"
  timeout = 300
}

# Create lambda function - invoker
resource "aws_lambda_function" "lambda_invoker" {
  function_name = "lambda_invoker"
  filename = "${path.module}/lambdaInvoker.py"
  source_code_hash = filebase64sha256("${path.module}/lambdaInvoker.py")
  role = aws_iam_role.iam_role_access_lambda.arn
  runtime = "python3.12"
  timeout = 300
}