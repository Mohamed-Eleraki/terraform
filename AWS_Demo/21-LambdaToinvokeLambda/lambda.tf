resource "aws_lambda_function" "lambda_invoker" {
  function_name = "lambda_invoker"

  # zip file path holds python script
  filename         = "${path.module}/scripts/lambdaInvoker.zip"
  source_code_hash = filebase64sha256("${path.module}/scripts/lambdaInvoker.zip")

  # handler name = file_name.python_function_name
  handler = "lambdaInvoker.lambda_handler"
  runtime = "python3.11"
  timeout = 120

  # utilizing deployed Role
  role = aws_iam_role.lambda_invoker_iam_role.arn
}

resource "aws_lambda_function" "lambda_to_invoke" {
  function_name = "lambda_to_invoke"

  # zip file path holds python script
  filename         = "${path.module}/scripts/lambdaToInvoke.zip"
  source_code_hash = filebase64sha256("${path.module}/scripts/lambdaToInvoke.zip")

  # handler name = file_name.python_function_name
  handler = "lambdaToInvoke.lambda_handler"
  runtime = "python3.11"
  timeout = 120

  # utilizing deployed Role
  role = aws_iam_role.lambda_to_invoke.arn
}