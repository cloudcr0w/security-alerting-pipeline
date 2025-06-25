# -----------------------------------------------------------------------------
# SNS topic and email subscription used for security alerting
# -----------------------------------------------------------------------------


resource "aws_sns_topic" "security_alerts" {
  name = "security_alerts_topic"
  tags = local.common_tags


}

resource "aws_sns_topic_subscription" "email_alert" {
  topic_arn = aws_sns_topic.security_alerts.arn
  protocol  = "email"
  endpoint  = var.alert_email
}

resource "aws_sns_topic" "guardduty_alerts" {
  name = "guardduty_alerts_topic"
  tags = local.common_tags
}

resource "aws_lambda_permission" "allow_config_sns" {
  statement_id  = "AllowExecutionFromSNSConfig"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.aws_config_handler.function_name
  principal     = "sns.amazonaws.com"
  source_arn    = aws_sns_topic.security_alerts.arn
}

resource "aws_sns_topic_subscription" "config_lambda" {
  topic_arn = aws_sns_topic.security_alerts.arn
  protocol  = "lambda"
  endpoint  = aws_lambda_function.aws_config_handler.arn
}
