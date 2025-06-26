# 🔔 Alert Flows

## IAM Event (e.g. CreateUser)
- Trigger: AWS CloudTrail
- Routed: EventBridge → Lambda (`alert_function`) → SNS → Slack

## GuardDuty Finding (e.g. SSH brute-force)
- Trigger: GuardDuty
- Routed: EventBridge → Lambda (`guardduty_alert_function`) → SNS → Slack

## AWS Config Violation (e.g. S3 bucket public)
- Trigger: Config rule non-compliance
- Routed: SNS → Lambda (`aws_config_handler`) → Slack
