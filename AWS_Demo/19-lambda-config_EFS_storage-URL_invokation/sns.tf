# Create an sns topic
resource "aws_sns_topic" "url_invokation_lambda_failures_success" {
  name = "lambda-URLinvoke-topic"
}

resource "aws_sns_topic_subscription" "sns_url_invokation_lambda_email_subscription" {
  topic_arn = aws_sns_topic.url_invokation_lambda_failures_success.arn
  protocol  = "email"
  endpoint  = "YOUR-EMAIL-HERE"
}