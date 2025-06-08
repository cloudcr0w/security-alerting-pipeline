# 🛡️ AWS Security Alerting Pipeline

![Visitors](https://visitor-badge.laobi.icu/badge?page_id=cloudcr0w.security-alerting-pipeline)
![Last Updated](https://img.shields.io/badge/updated-June%202025-blue)
![Status](https://img.shields.io/badge/project-learning-informational)

> Real-time AWS security monitoring using native services like CloudTrail, GuardDuty, Lambda, EventBridge, and SNS – fully automated with Terraform.

---

## ✅ Initial Use Case
> Detect and alert when a new IAM user is created (CreateUser event in AWS CloudTrail).

---

## 🔍 Use case
Detects suspicious activity like:
- 👤 IAM user creation
- ❌ Root login without MFA
- 🧐 GuardDuty findings (SSH brute-force, port scan)
- 💼 AWS Config non-compliant resources (e.g. public S3)

---

## ⚖️ Stack

| Category      | Tech                              |
|---------------|-----------------------------------|
| IaC           | Terraform                         |
| Detection     | CloudTrail, GuardDuty, AWS Config |
| Processing    | Lambda (Python)                   |
| Alerting      | SNS, Slack                        |
| Optional UI   | Flask receiver in Docker/K8s      |

---

## 🧱 Architecture

![AWS Security Alerting Pipeline](diagram.png)

1. CloudTrail or GuardDuty detects an event  
2. EventBridge filters and routes the event  
3. Lambda formats alert and sends via SNS  
4. Alerts go to email, Slack, or external receiver

---

## 📂 Structure

terraform/ # Infrastructure as code
lambda/ # Lambda functions (Python)
tests/ # Sample CloudTrail/GuardDuty events
alert-receiver/ # Flask app in container
ansible/ # Simple AWS CLI provisioner
k8s/ # K8s deployment for receiver


---

## 📄 Detailed Setup & Features

See [DETAILS.md](DETAILS.md) for:
- Deployment instructions
- Sample test events
- Lambda test CLI commands
- Slack integration setup
- Roadmap and future improvements

---

## 🧠 What I Learned
- How to use Terraform to deploy a real security alerting pipeline  
- How IAM + GuardDuty + EventBridge + Lambda + SNS work together  
- How to log to CloudWatch and test Lambda manually  
- First hands-on experience with GuardDuty in a personal project  
- Basics of Docker and K8s for alert receiver integration

---

## 👨‍💼 Author
**Adam Wrona** – aspiring DevOps / AWS Cloud Engineer  
🔗 [LinkedIn](https://www.linkedin.com/in/adam-wrona-111ba728b) • [GitHub](https://github.com/cloudcr0w)

_Last updated: May 12, 2025_

---

## 🌐 License
[MIT](LICENSE)

---

## 🚫 Security Policy
For vulnerability reports, please see [SECURITY.md](SECURITY.md)

