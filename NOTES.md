# 🗒️ Notes – AWS Security Alerting Pipeline
![Visitors](https://visitor-badge.laobi.icu/badge?page_id=cloudcr0w.security-alerting-pipeline)
![Last Updated](https://img.shields.io/badge/updated-June%202025-blue)
![Status](https://img.shields.io/badge/project-learning-informational)

Work in progress – focused on learning, improving, and building practical AWS security skills.

---

## ✅ Done – Tuesday, 16 April 2025

- ✅ Added `tags` to both Lambda functions (`Project`, `Environment`)
- ✅ Added `outputs` for `guardduty_alert_function`
- ✅ Verified `alert_email` variable has a proper description
- ✅ Maintained daily GitHub commit streak 💪
- ✅ Successfully deployed full stack using Terraform
- ✅ Fixed CloudTrail + S3 policy for logging
- ✅ Added logging IAM policy for Lambda (CloudWatch integration)
- ✅ Tested GuardDuty Lambda manually via CLI
- ✅ Cleaned up `output.json` with `.gitignore` entry
- ✅ Updated README with Lambda test instructions
- ✅ Added EventBridge rule to detect root user login without MFA
- ✅ Connected alert Lambda to root login rule
- ✅ Added permission for EventBridge to invoke Lambda
- ✅ Successfully tested Ansible role for installing AWS CLI on localhost (Ubuntu WSL)
- ✅ Added simple Ansible role to install AWS CLI
- ✅ Documented Ansible structure (`README.md` + `tree.txt`)
- ✅ Added `README.md` to `samples/` folder to explain usage

---

### 🔔 AWS Config – SNS & Lambda integration

- ✅ Created separate `sns_config.tf` file for clarity
- ✅ Added SNS topic: `aws-config-alerts`
- ✅ Subscribed Lambda function `aws_config_handler` to the topic
- ✅ Handler receives and logs Config alerts

+ ✅ Manual Lambda zip used (CI/CD not implemented yet)
+ ✅ Lambda integration tested with NON_COMPLIANT Config rule
+ ✅ Slack webhook added to handler for real-time alerts

---

## 📌 TODO – Still thinking about it

+ ✅ Add quick Slack/Discord integration via webhook
- [ ] Consider a separate SNS topic for GuardDuty alerts
- [ ] Try real-time GuardDuty finding in AWS Console
- [ ] Add consistent logging (`print()` or `logger`) to IAM alert Lambda
- [ ] Split Lambda code into separate folders if it grows further
- [ ] Explore more AWS Config rules (e.g. `s3-bucket-public-write-prohibited`, `iam-user-no-mfa`)

---

## ❓ Questions to Explore

- How to route alerts to different emails based on severity or type?
- What would full CloudWatch Logs retention + metric filters setup look like?
- Should I add support for S3 security-related events (e.g., public buckets)?

---

## 📝 Roadmap – What's next?

- ✅ Clean Docker image naming (add version tag)
- ✅ Added `README.md` to `samples/` folder to explain usage
- [ ] Run full test for GuardDuty Lambda using sample JSON
- [ ] Brainstorm CI/CD ideas (e.g., GitHub Actions + Terraform Plan/Apply)
- [ ] Add CloudWatch metric filters + alarms for Lambda errors
- [ ] (Optional) Try minimal EKS or ECS simulation for alert receiver
