# Operations Guide

## 1. Health Checks

- Check Lambda invocations & errors (CloudWatch)
- Verify SNS delivery
- Confirm Slack webhook response (HTTP 200)

## 2. Log Inspection

aws logs tail /aws/lambda/guardduty_alert_function --follow

## 3. Manual Test Event

aws sns publish \
  --topic-arn <SNS_TOPIC_ARN> \
  --message file://samples/sample-guardduty-event.json

## 4. Common Failure Scenarios

### Slack not receiving alerts
- Verify webhook secret in AWS Secrets Manager
- Check Lambda execution role
- Validate SNS subscription

### Event not triggered
- Inspect EventBridge rule pattern
- Confirm GuardDuty is enabled

## 5. Metrics to Monitor

- Lambda Errors
- Lambda Duration
- SNS Failed Deliveries
- GuardDuty finding frequency

## 6. On-call Notes

- IAM changes should be reviewed immediately
- Root login without MFA = critical alert
- Consider temporary SNS email fallback if Slack fails