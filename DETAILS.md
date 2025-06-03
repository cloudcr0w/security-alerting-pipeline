# 📄 DETAILS.md – AWS Security Alerting Pipeline

## 🚫 Use Cases

* Detect IAM CreateUser events (CloudTrail)
* Detect root logins without MFA
* GuardDuty threats (SSH brute-force, reconnaissance, EC2 port scan)
* AWS Config rule violations (e.g. public S3 buckets, no MFA, weak password policy)

---

## 📅 Prerequisites

* AWS CLI configured
* Terraform installed (>= 1.4)

---

## 🚀 Deployment

```bash
cd terraform/
terraform init
terraform apply -var-file="../tests/terraform.tfvars.sample"
```

Then confirm email subscription from SNS alert.

---

## 🧪 Manual Testing (Lambda)

Run sample events manually via AWS CLI:

### GuardDuty Lambda

```bash
aws lambda invoke \
  --function-name guardduty_alert_function \
  --payload file://tests/guardduty_ssh_brute_event.json \
  --cli-binary-format raw-in-base64-out \
  output.json
```

Expected:

```json
{
  "statusCode": 200,
  "body": "GuardDuty alert processed"
}
```

---

## 📊 Monitoring

### Log Group Retention

Defined via `cloudwatch.tf`:

```hcl
resource "aws_cloudwatch_log_group" "iam_alert_logs" {
  name              = "/aws/lambda/security-alert-function"
  retention_in_days = 7
  tags              = local.common_tags
}
```

### Alarm for Lambda errors

```hcl
resource "aws_cloudwatch_metric_alarm" "iam_alert_errors" {
  alarm_name = "iam_alert_lambda_errors"
  metric_name = "Errors"
  threshold = 0
  ...
  alarm_actions = [aws_sns_topic.security_alerts.arn]
}
```

---

## 📣 Slack Integration

### Setup

1. Create a Slack Webhook URL
2. Add to `terraform.tfvars`:

```hcl
slack_webhook_url = "https://hooks.slack.com/services/..."
```

3. Lambda reads and posts alert via `requests.post()`

---

## 📁 File structure

```
terraform/
  cloudtrail.tf
  config.tf
  sns.tf
  eventbridge_guardduty.tf
  eventbridge_config.tf
  lambda.tf
  outputs.tf
  cloudwatch.tf
  variables.tf

lambda/
  alert_function.py
  guardduty_alert_function.py
  aws_config_handler.py

alert-receiver/
  Dockerfile
  app.py
  docker-compose.yml

tests/
  terraform.tfvars.sample
  cloudtrail_create_user_event.json
  guardduty_ssh_brute_event.json
  README.md

ansible/
  playbook.yml
  inventory

k8s/
  deployment.yaml
```

---

## 🧭 Roadmap

* [x] Add root login alert
* [x] Add Slack webhook for AWS Config
* [x] Add CloudWatch alarms for Lambda errors
* [ ] Add Slack alerting for GuardDuty
* [ ] Add Terraform CI/CD GitHub Actions
* [ ] ECS deployment for alert-receiver
* [ ] Alert enrichment (GeoIP, who triggered)
* [ ] Auto-remediation (detach policy, block IP)

---

## 📚 Learning Highlights

* Terraform module design & structure
* Event-driven AWS security pipelines
* Slack + SNS integration with Lambda
* CloudWatch logs & alerting
* Docker + K8s app deployment
* IAM permissions & CloudTrail filtering
