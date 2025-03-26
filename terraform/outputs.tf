output "sns_topic_arn" {
  value = aws_sns_topic.security_alerts.arn
}
output "guardduty_detector_id" {
  value = aws_guardduty_detector.main.id
}
output "guardduty_rule_arn" {
  value = aws_cloudwatch_event_rule.guardduty_finding.arn
}