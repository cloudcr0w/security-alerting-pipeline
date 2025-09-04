resource "aws_sns_topic" "aws_config_alerts" {
  name = "aws-config-alerts"

  tags = {
    Environment = "dev"
  }

  lifecycle {
    ignore_changes = [tags]
  }
}

resource "aws_sns_topic_subscription" "lambda_subscription" {
  topic_arn = aws_sns_topic.aws_config_alerts.arn
  protocol  = "lambda"
  endpoint  = aws_lambda_function.aws_config_handler.arn
}
