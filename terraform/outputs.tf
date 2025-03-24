output "sns_topic_arn" {
  value = aws_sns_topic.security_alerts.arn
}
output "guardduty_detector_id" {
  value = aws_guardduty_detector.main.id
}
