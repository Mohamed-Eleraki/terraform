# Deploy lambda layer resource - Create your layer zip file first , Then upload it to Bucket
resource "aws_lambda_layer_version" "object_migration_layer" {

  # mention the layer pacakge from S3 Bucket instead
  # This is to avoid upload the packge every time you run your code.
  s3_bucket = "erakiterrafromstatefiles"                              # S3 Bucket name
  s3_key    = "18-lambda_S3-trigger/objectMigration_dependencies.zip" # path to your Package

  layer_name          = "objectMigrationLayer"
  compatible_runtimes = ["python3.11"]
}

# Deploy lambda function
resource "aws_lambda_function" "Object_migration_function" {
  function_name = "objectMigrationFunction01"

  # zip file path holds python script
  filename         = "${path.module}/scripts/objectMigration.zip"
  source_code_hash = filebase64sha256("${path.module}/scripts/objectMigration.zip")

  # handler name = file_name.python_function_name
  handler = "objectMigration.lambda_handler"
  runtime = "python3.11"
  timeout = 120

  # utilizing deployed Role
  role = aws_iam_role.lambda_iam_role.arn

  # utilizing deployed layer
  layers = [aws_lambda_layer_version.object_migration_layer.arn]

  environment {
    variables = {
      DEST_BUCKET = aws_s3_bucket.BucketTwo.bucket
    }
  }
}

# Lambda destination configuration for failures
resource "aws_lambda_function_event_invoke_config" "migration_lambda_sns_destination" {
  depends_on = [ aws_iam_role.lambda_iam_role ]
  function_name = aws_lambda_function.Object_migration_function.function_name

  destination_config {
    on_failure {
      destination = aws_sns_topic.migration_lambda_failures.arn
    }

    on_success {
      destination = aws_sns_topic.migration_lambda_failures.arn
    }
  }
}
# Reference
# - https://docs.aws.amazon.com/lambda/latest/dg/with-s3-example.html