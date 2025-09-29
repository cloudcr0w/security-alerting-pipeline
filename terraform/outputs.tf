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
  value       = aws_lambda_function.guardduty_alert_function.arn
  description = "ARN of the Lambda handling GuardDuty alerts"
}
output "alert_lambda_version" {
  value       = aws_lambda_function.alert_function.version
  description = "version od the IAM alert lambda function"
}
output "guardduty_lambda_version" {
  value       = aws_lambda_function.guardduty_alert_function.version
  description = "version of GuardDuty alert Lambda function"
}
output "guardduty_sns_topic_arn" {
  value = aws_sns_topic.guardduty_alerts.arn
}
output "config_rules" {
  value = [
    aws_config_config_rule.iam_user_no_mfa.name,
    aws_config_config_rule.root_mfa_enabled.name
  ]
}
output "slack_webhook_configured" {
  description = "Indicates whether Slack webhook is configured"
  value       = var.slack_webhook_url != "" ? true : false
  sensitive   = false
}
