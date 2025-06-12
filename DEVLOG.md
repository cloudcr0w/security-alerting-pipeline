# 📓 DEVLOG – AWS Security Alerting Pipeline
![Visitors](https://visitor-badge.laobi.icu/badge?page_id=cloudcr0w.security-alerting-pipeline)
![Last Updated](https://img.shields.io/badge/updated-June%202025-blue)
![Status](https://img.shields.io/badge/project-learning-informational)

Work in progress – focused on learning, improving, and building practical AWS security skills.

---

## ✅ Done – Tuesday, 3 June 2025

- ✅ Unified test files under `tests/` folder and renamed for clarity
- ✅ Refactored Terraform to use `local.common_tags` for consistent tagging
- ✅ Added CloudWatch log group and Lambda error alarm
- ✅ Simplified and rewrote `README.md` and moved details to `DETAILS.md`
- ✅ Created/updated `SECURITY.md`, `LICENSE`, `CONTRIBUTING.md`, and `DEVLOG.md`
- ✅ Maintained commit streak 💪

---

## ✅ Earlier – Tuesday, 16 April 2025

- ✅ Added `tags` to both Lambda functions (`Project`, `Environment`)
- ✅ Added `outputs` for `guardduty_alert_function`
- ✅ Verified `alert_email` variable has a proper description
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

## 🔔 AWS Config & GuardDuty – SNS & Lambda Integration

- ✅ Created separate `sns_config.tf` file for AWS Config clarity
- ✅ Added SNS topic: `aws-config-alerts`
- ✅ Subscribed Lambda function `aws_config_handler` to the topic
- ✅ Handler receives and logs Config alerts
- ✅ Slack webhook added to Config handler for real-time alerts
- ✅ Created **separate SNS topic** for GuardDuty alerts
- ✅ GuardDuty Lambda now supports **Slack and SNS alerts**
- ✅ Improved **logging and exception handling** in all Lambda handlers
- ✅ Split Lambda code into separate folders (per function)
---

## 📌 TODO – Next up

- [ ] Test GuardDuty with real-time console findings
- [ ] Add CI/CD workflow (Terraform Plan/Apply, Lambda deploy)
- [ ] Add CloudWatch metric filters for Lambda invocations, throttles
- [ ] Deploy Flask alert receiver in ECS or EKS
- [ ] Explore more AWS Config rules (e.g., `s3-bucket-public-write-prohibited`, `iam-user-no-mfa`)


---

## ❓ Questions to Explore

- How to route alerts by severity/type (different SNS topics, filters)?
- What’s the best way to enrich alerts (GeoIP, user identity, region)?
- Should I support public S3 detection via CloudTrail and Config?

---

## 🛠️ CI/CD Notes

- Plan:
  - Automatically package Lambda zip on commit
  - Upload via GitHub Actions using AWS CLI
  - Run `terraform fmt` and `terraform validate`
  - Run `terraform plan` with summary
- Later:
  - Test Lambdas with sample payloads in GitHub Actions
  - Auto-approve + apply for `main` branch commits

---

> _This file serves as a personal changelog and learning log. Updated manually after work sessions._
