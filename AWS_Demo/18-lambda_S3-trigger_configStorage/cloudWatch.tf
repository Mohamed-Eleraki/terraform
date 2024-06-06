# # Create a cloud watch group
# resource "aws_cloudwatch_log_group" "migration_lambda_cloudwatch_log_group" {
#   name = "/aws/lambda/objectMigration"
# }

# resource "aws_cloudwatch_metric_alarm" "migration_lambda_failure_cloudwatch_alarm" {
#   alarm_name          = "migrationLambdaFailureAlarm"
#   comparison_operator = "GreaterThanOrEqualToThreshold"
#   evaluation_periods  = "1"
#   metric_name         = "Errors"
#   namespace           = "AWS/Lambda"
#   period              = "60"
#   statistic           = "Sum"
#   threshold           = "1"

#   alarm_actions = [aws_sns_topic.migration_lambda_failures.arn]

#   dimensions = {
#     FunctionName = "objectMigrationFunction"
#   }
# }
