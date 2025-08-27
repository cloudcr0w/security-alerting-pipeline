# 🗒️ Notes – AWS Security Alerting Pipeline
![Visitors](https://visitor-badge.laobi.icu/badge?page_id=cloudcr0w.security-alerting-pipeline)
![Updated](https://img.shields.io/badge/last_update-Aug%202025-blue)
![Status](https://img.shields.io/badge/project-learning-informational)

Work in progress – focused on **learning AWS security, IaC, and real-time monitoring**.

---

## ✅ Done (as of April 2025)

### 🔧 Core Setup
- Added `tags` to both Lambda functions (`Project`, `Environment`)
- Added `outputs` for `guardduty_alert_function`
- Verified `alert_email` variable description
- Daily GitHub commit streak maintained 💪
- Successfully deployed **full stack with Terraform**
- Fixed CloudTrail + S3 policy for logging
- Added IAM policy for Lambda → CloudWatch logging
- Tested GuardDuty Lambda manually (CLI)
- Cleaned up `output.json` via `.gitignore`
- Updated README with Lambda test instructions
- EventBridge rule: detect **root user login without MFA**
- Connected alert Lambda to root login rule + permissions
- Added **Ansible role** to install AWS CLI on localhost (Ubuntu WSL)
- Documented Ansible structure (`README.md` + `tree.txt`)
- Added `README.md` to `samples/` folder

### 🔔 AWS Config – SNS & Lambda Integration
- Created `sns_config.tf` for clarity
- Added SNS topic: `aws-config-alerts`
- Subscribed Lambda `aws_config_handler` to the topic
- Handler receives + logs Config alerts
- Manual Lambda zip (no CI/CD yet)
- Tested integration with NON_COMPLIANT rule
- Slack webhook added → real-time alerts

---

## 📌 TODO – Next Iterations

### 📢 Alert Routing
- [ ] Separate SNS topic for GuardDuty alerts
- [ ] Route alerts by **severity/type** (different emails)

### 🧑‍💻 Code Quality
- [ ] Add consistent logging (`print()` → `logger`)
- [ ] Split Lambda code into multiple folders if it grows
- [ ] Brainstorm CI/CD workflow (GitHub Actions + Terraform Plan/Apply)

### 🔒 Security & Rules
- [ ] Try real-time GuardDuty finding via AWS Console
- [ ] Add more AWS Config rules (`s3-bucket-public-write-prohibited`, `iam-user-no-mfa`)
- [ ] Add S3-related security event alerts (public bucket access)

---

## ❓ Questions to Explore
- How to route alerts by severity/type effectively (SNS filters? EventBridge patterns?)  
- What’s the best setup for **CloudWatch Logs retention + metric filters**?  
- Should I extend pipeline to cover **S3 public bucket events**?  

---

## 📝 Roadmap

**Now**
- GuardDuty sample JSON → run full Lambda test
- Add CloudWatch alarms for Lambda errors

**Next**
- CI/CD PoC (GitHub Actions → Terraform → Lambda update)
- Docker image naming cleanup (add version tags)

**Optional / Later**
- EKS/ECS simulation for alert receiver  
- Full observability integration (Prometheus/Grafana)

---
