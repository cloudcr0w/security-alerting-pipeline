# 📓 DEVLOG – AWS Security Alerting Pipeline
![Visitors](https://visitor-badge.laobi.icu/badge?page_id=cloudcr0w.security-alerting-pipeline)
![Updated](https://img.shields.io/badge/last_update-Sep%202025-blue)
![Status](https://img.shields.io/badge/project-learning-informational)

Ongoing project – focused on **AWS security, IaC, and DevSecOps practices**.  
This file acts as a **changelog + learning log**, updated manually after each session.

---

## 🚀 Latest Progress
- Unified all test files under `tests/` (renamed for clarity)
- Refactored Terraform → using `local.common_tags` for consistent tagging
- Added CloudWatch log group + Lambda error alarm
- Simplified `README.md` (moved details to `DETAILS.md`)
- Created/updated project docs: `SECURITY.md`, `LICENSE`, `CONTRIBUTING.md`, `DEVLOG.md`
- Maintained GitHub commit streak 💪
- Lambda subscription → SNS topic `guardduty_alerts_topic`.
- Corrections to `slack_alert_forwarder` (debug format SNS/Slack)
- Terraform apply: performance test of SNS → Lambda → Slack subscription
- Adding Slack alert screenshot (docs/screenshots/)
- Updating `.gitignore` - ignoring Python packages and outputs
- Initial configuration of Lambda subscription → AWS Config alerts

---

## 📅 Earlier Milestones
- Added tags to all Lambdas (`Project`, `Environment`)
- Added Terraform outputs for `guardduty_alert_function`
- Verified `alert_email` variable with description
- Successfully deployed **full stack via Terraform**
- Fixed CloudTrail + S3 policy for logging
- Added IAM policy for Lambda → CloudWatch logs
- Tested GuardDuty Lambda manually (CLI)
- Ignored `output.json` via `.gitignore`
- EventBridge rule: detect **root login without MFA**
- Linked alert Lambda with EventBridge rule + permissions
- Built Ansible role → AWS CLI installation (Ubuntu WSL)
- Documented Ansible structure (`README.md` + `tree.txt`)
- Added `README.md` to `samples/` folder

---

## 🔔 AWS Config Integration
- `sns_config.tf` → added for clarity
- SNS topic `aws-config-alerts` created
- Subscribed Lambda `aws_config_handler` to topic
- Handler receives + logs Config alerts
- Slack webhook added → real-time notifications

---

## 🛡️ GuardDuty Integration
- Created **separate SNS topic** for GuardDuty alerts
- GuardDuty Lambda → sends to Slack & SNS
- Improved logging + exception handling in all handlers
- Split Lambda code into dedicated folders
- Added CloudWatch metric filters (invocations, throttles)
- Explored more AWS Config rules (`s3-bucket-public-write-prohibited`, `iam-user-no-mfa`)

---

## 📌 TODO – Backlog
- [ ] Test GuardDuty with **real-time console findings**
- [ ] Add CI/CD pipeline (Terraform Plan/Apply + Lambda deploy)
- [ ] Deploy Flask alert receiver in ECS or EKS

## Known Issues
- SNS retries may cause duplicate Slack messages  
- Lambda cold starts increase alert latency (~2s)  

---

## ❓ Open Questions
- Best way to route alerts by **severity/type**? (SNS filters? EventBridge patterns?)
- How to enrich alerts (GeoIP, IAM user identity, region)?
- Should I add **S3 public access** detection (CloudTrail + Config)?

---

## 🛠️ CI/CD Plans

**Phase 1**
- [ ] Auto-package Lambda zip on commit  
- [ ] Upload with GitHub Actions + AWS CLI  
- [ ] Run `terraform fmt` + `terraform validate`  
- [ ] Run `terraform plan` (summarized)  

**Phase 2**
- [ ] Test Lambdas with sample payloads in CI  
- [ ] Auto-approve + apply on `main` branch commits  

---

📌 *This file is maintained as a dev journal – updated after each coding session.*
