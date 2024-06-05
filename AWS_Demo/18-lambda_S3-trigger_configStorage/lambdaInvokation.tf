# Provide bucket one permission to invoke lambda
resource "aws_lambda_permission" "Allow_s3_invocation" {
  statement_id = "AllowExecutionFromS3"
  action = "lambda:InvokeFunction"
  function_name = aws_lambda_function.Object_migration_function.function_name
  principal = "s3.amazonaws.com"
  source_arn = aws_s3_bucket.BucketOne.arn
}

# configure Bukcet notification trigger
resource "aws_s3_bucket_notification" "BukcetOne_notification" {
  bucket = aws_s3_bucket.BucketOne.id

  lambda_function {
    lambda_function_arn = aws_lambda_function.Object_migration_function.arn
    events = ["s3:ObjectCreated:*"]
    # filter_prefix = "/path"
    filter_suffix = ".txt"
  }
}