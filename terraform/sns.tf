# SNS notification

resource "aws_sns_topic" "security_alerts" {
  name = "security_alerts_topic"
  tags = local.common_tags


}

resource "aws_sns_topic_subscription" "email_alert" {
  topic_arn = aws_sns_topic.security_alerts.arn
  protocol  = "email"
  endpoint  = var.alert_email
}