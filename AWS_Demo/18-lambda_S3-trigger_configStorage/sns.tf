# Create an sns topic
resource "aws_sns_topic" "migration_lambda_failures" {
  name = "lambda-failures-topic"
}

resource "aws_sns_topic_subscription" "sns_migration_lambda_email_subscription" {
  topic_arn = aws_sns_topic.migration_lambda_failures.arn
  protocol  = "email"
  endpoint  = "mohamed-ibrahim2021@outlook.com"
}