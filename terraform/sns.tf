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
