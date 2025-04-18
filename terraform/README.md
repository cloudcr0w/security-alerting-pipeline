## 📁 Structure

| File                        | Purpose                                      |
|-----------------------------|----------------------------------------------|
| `main.tf`                   | Provider and shared config                   |
| `iam.tf`                    | IAM roles and policies for Lambda + Config   |
| `cloudtrail.tf`             | CloudTrail + logging setup                   |
| `lambda.tf`                 | Lambda function deployment                   |
| `sns_config.tf`             | SNS topic for alert notifications            |
| `eventbridge_config.tf`     | EventBridge rule for AWS Config changes      |
| `test.tf`                   | Intentional misconfig (public S3) for testing|


## 🚨 Testing Alerts

To simulate a violation, deploy the `test.tf` S3 bucket with public read access.  
Then check AWS Config for a NON_COMPLIANT status and look at logs in CloudWatch from the alert Lambda.

## 🧱 Project Tree

Current file structure: [`tree.txt`](../tree.txt)