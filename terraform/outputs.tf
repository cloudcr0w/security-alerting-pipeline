output "sns_topic_arn" {
  value = aws_sns_topic.security_alerts.arn
}
output "guardduty_detector_id" {
  value = aws_guardduty_detector.main.id
}
output "guardduty_rule_arn" {
  value = aws_cloudwatch_event_rule.guardduty_finding.arn
}
output "guardduty_lambda_arn" {
  value = aws_lambda_function.guardduty_alert_function.arn
  description = "ARN of the Lambda handling GuardDuty alerts"
}
output "alert_lambda_version" {
  value = aws_lambda_function.alert_function.version
  description = "version od the IAM alert lambda function"
}