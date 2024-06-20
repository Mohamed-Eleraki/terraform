# Deploy lambda layer resource - Create your layer zip file first , Then upload it to Bucket
resource "aws_lambda_layer_version" "url_invokation_layer" {

  # mention the layer pacakge from S3 Bucket instead
  # This is to avoid upload the packge every time you run your code.
  s3_bucket = "erakiterrafromstatefiles"                              # S3 Bucket name
  s3_key    = "19-lambda-config_EFS_storage-URL_invokation/URL_Invokation_depends.zip" # path to your Package

  layer_name          = "invokationLayer"
  compatible_runtimes = ["python3.11"]
}

# Deploy lambda function
resource "aws_lambda_function" "url_invokation_function" {
  function_name = "invokationFunction"

  # zip file path holds python script
  filename         = "${path.module}/scripts/URLinvokation05.zip"
  source_code_hash = filebase64sha256("${path.module}/scripts/URLinvokation05.zip")

  # handler name = file_name.python_function_name
  handler = "URLinvokation.lambda_handler"
  runtime = "python3.11"
  timeout = 120

  # utilizing deployed Role
  role = aws_iam_role.lambda_iam_role.arn

  # utilizing deployed layer
  layers = [aws_lambda_layer_version.url_invokation_layer.arn]

  file_system_config {
    # EFS file system access point ARN
    arn = aws_efs_access_point.access_point_for_lambda.arn

    # Local mount path inside the lambda function. Must start with '/mnt/'.
    local_mount_path = "/mnt/efs"
  }

  vpc_config {
    # Every subnet should be able to reach an EFS mount target in the same Availability Zone. Cross-AZ mounts are not permitted.
    subnet_ids         = [aws_subnet.subnet_01.id]
    security_group_ids = [aws_security_group.lambda_sg.id]
  }

  # Explicitly declare dependency on EFS mount target.
  # When creating or updating Lambda functions, mount target must be in 'available' lifecycle state.
  depends_on = [aws_efs_mount_target.efs_mount_target]

  # Specifically, create_before_destroy ensures that when a resource needs to be replaced, the new resource is created before the old resource is destroyed
  lifecycle {
    create_before_destroy = true
  }

}

# Lambda destination configuration for failures
resource "aws_lambda_function_event_invoke_config" "invokation_lambda_sns_destination" {
  depends_on    = [aws_iam_role.lambda_iam_role]
  function_name = aws_lambda_function.url_invokation_function.function_name

  destination_config {
    on_failure {
      destination = aws_sns_topic.url_invokation_lambda_failures_success.arn
    }

    on_success {
      destination = aws_sns_topic.url_invokation_lambda_failures_success.arn
    }
  }
}

resource "aws_lambda_function_url" "lambda_url" {
  function_name = aws_lambda_function.url_invokation_function.function_name
  authorization_type = "NONE"
}

output "lambda_function_url" {
  value = aws_lambda_function_url.lambda_url.function_url
}


# invokation commands
# curl -X POST https://nowfrll677igoqi3zh2ebl5aqm0keszy.lambda-url.us-east-1.on.aws/ -d '{"directory_name": "test_dir"}' -H "Content-Type: application/json"
# curl -X POST https://nowfrll677igoqi3zh2ebl5aqm0keszy.lambda-url.us-east-1.on.aws/ -d "{'directory_name': 'test_dir'}" -H "Content-Type: application/json"
# curl -v https://nowfrll677igoqi3zh2ebl5aqm0keszy.lambda-url.us-east-1.on.aws/ -d '{"directory_name": "test_dir"}' -H "Content-Type: application/json"


# curl -v 'https://fhoozovovlwi2hotj7glpl6mem0oilyv.lambda-url.us-east-1.on.aws/' \
# -H 'content-type: application/json' \
# -d '{ "directory_name": "dir_from_curl_024" }'

# aws sns publish --topic-arn arn:aws:sns:us-east-1:891377122503:lambda-failures-topic --message "Test Success Message" --profile eraki