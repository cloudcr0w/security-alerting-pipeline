resource "aws_cloudwatch_event_rule" "guardduty_finding" {
  name        = "guardduty_finding"
  description = "Catches all GuardDuty findings for further alerting"
  event_pattern = jsonencode({
    source      = ["aws.guardduty"],
    detail-type = ["GuardDuty Finding"]
  })
}
