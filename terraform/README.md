# ☁️ Terraform Configuration

This directory contains all Terraform modules for the AWS Security Alerting Pipeline:

- IAM roles and policies
- CloudTrail + EventBridge
- Lambda functions
- SNS notifications
- GuardDuty integration

To deploy:

```bash
cd terraform/
terraform init
terraform apply
```