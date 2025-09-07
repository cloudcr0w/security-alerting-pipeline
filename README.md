# AWS Security Alerting Pipeline

![Built with anxiety](https://img.shields.io/badge/built%20with-anxiety-red)
![Status](https://img.shields.io/badge/status-WIP-yellow)
![Terraform](https://img.shields.io/badge/IaC-Terraform-623CE4?logo=terraform)
![AWS](https://img.shields.io/badge/Cloud-AWS-232F3E?logo=amazon-aws)
![Python](https://img.shields.io/badge/python-3.12-blue)
![Dockerized](https://img.shields.io/badge/containerized-yes-informational)
![Lambda](https://img.shields.io/badge/Compute-Lambda-orange?logo=aws-lambda)
![Slack Alerts](https://img.shields.io/badge/Alerts-Slack-4A154B?logo=slack)
![License: MIT](https://img.shields.io/badge/License-MIT-blue.svg)
![PRs Welcome](https://img.shields.io/badge/PRs-welcome-brightgreen.svg)
![TODO](https://img.shields.io/badge/TODO-in%20progress-blueviolet)
![Updated](https://img.shields.io/badge/last_update-Sep%202025-blue)


  End-to-end real-time threat detection and alerting system built on AWS with Terraform and Python Lambda functions.
  Hands-on DevSecOps project showing real-time AWS security monitoring and alerting.

## Table of Contents

- [Initial Use Case](#initial-use-case)
- [Use Case](#use-case)
- [Stack](#stack)
- [Architecture](#architecture)
- [Project Structure](#project-structure)
- [Detailed Setup & Features](#detailed-setup--features)
- [What I Learned](#what-i-learned)
- [Author](#author)
- [License](#license)
- [Security Policy](#security-policy)

---

## Initial Use Case
> Detect and alert when a new IAM user is created (`CreateUser` event in AWS CloudTrail).

---

## Use Case
Detects suspicious activity like:
- IAM user creation  
- Root login without MFA  
- GuardDuty findings (SSH brute-force, port scan)  
- AWS Config non-compliant resources (e.g., public S3)

---

## Stack

| Category      | Technology                         |
|---------------|------------------------------------|
| IaC           | Terraform                          |
| Detection     | CloudTrail, GuardDuty, AWS Config  |
| Processing    | Lambda (Python)                    |
| Alerting      | SNS, Slack                         |
| Optional UI   | Flask receiver in Docker/K8s       |

---

## Architecture

![AWS Security Alerting Pipeline](diagram.png)

1. CloudTrail or GuardDuty detects an event  
2. EventBridge filters and routes the event  
3. Lambda formats the alert and sends via SNS  
4. Alerts go to email, Slack, or an external receiver

---

## Project Structure

```bash
terraform/ # Infrastructure as Code
lambda/ # Lambda functions (Python)
tests/ # Sample CloudTrail/GuardDuty events
alert-receiver/ # Flask app (containerized)
ansible/ # AWS CLI provisioning
k8s/ # Kubernetes deployment manifests
slack_alert_forwarder/ # Lambda function forwarding SNS alerts to Slack

```

## 🔔 Slack Integration – Alert Example

This is a real example of a GuardDuty alert forwarded via AWS Lambda → SNS → Lambda → Slack.
The forwarding is handled by the `slack_alert_forwarder` function subscribed to the `guardduty_alerts` SNS topic.


![Slack Alert Example](docs/screenshots/slack_screenshot.png)

## Frontend UI Preview

This project includes an optional frontend in `/frontend` built with HTML, CSS (Bootstrap), and JS.

Features:
- Color-coded alert cards
- Emoji for each state (ALARM/OK/WARNING)
- Reload button
- Clean and responsive design

Open `frontend/index.html` in browser to preview alerts locally.

![Frontend Preview](frontend/frontend-preview.png)

## Detailed Setup & Features

See [docs/DETAILS.md](docs/DETAILS.md) for:

- Deployment instructions  
- Sample test events  
- Lambda test CLI commands  
- Slack integration setup  
- Roadmap and future improvements

---

## What I Learned

- How to use Terraform to deploy a real security alerting pipeline  
- How IAM, GuardDuty, EventBridge, Lambda, and SNS integrate  
- How to log to CloudWatch and test Lambda manually  
- Hands-on experience with GuardDuty in a personal project  
- Basics of Docker and Kubernetes for alert receiver deployment

---
## Why This Project?

The AWS Security Alerting Pipeline was created to:
- Gain hands-on experience with Terraform, Lambda, SNS, and security services
- Build a real-world cloud monitoring & alerting use case
- Demonstrate cloud infrastructure skills and DevSecOps thinking
- Provide actionable Slack/email alerts on suspicious activities in near real-time

## References

This project was inspired and supported by the following resources:

- AWS Documentation – [AWS Config](https://docs.aws.amazon.com/config/)
- Terraform Registry – [aws_config_config_rule](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/config_config_rule)
- Real-time alerting tutorial by FreeCodeCamp
- Flask documentation – [https://flask.palletsprojects.com/](https://flask.palletsprojects.com/)

## Author

**Adam Wrona** – aspiring DevOps / AWS Cloud Engineer  
🔗 [LinkedIn](https://www.linkedin.com/in/adam-wrona-111ba728b) • [GitHub](https://github.com/cloudcr0w)

_Last updated: July 3, 2025_

---


## 🚧 TODO

Planned improvements and features:

- [x] 🎨 Add basic frontend dashboard (HTML + Bootstrap)
- [x] 🧪 Add unit tests for Lambda functions (pytest)
- [x] 🔁 Refactor Lambda folder for better test discovery and modularity
- [ ] ☁️ Add CloudWatch Alarms for specific metrics (e.g., unauthorized API calls)
- [ ] 📦 Deploy alert-receiver to ECS (Fargate) or EKS with proper Terraform setup
- [x] 🔐 Integrate secrets manager for storing Slack webhook URL securely
- [ ] 📊 Add CloudWatch dashboard for visual monitoring
- [ ] 🔄 Enable automatic rotation of Lambda access keys
- [ ] 🛠️ Implement CI/CD pipeline for infrastructure and Lambda (GitHub Actions)
- [ ] 🌍 Add multi-region support
- [ ] 🧩 Add additional EventBridge rules (e.g., for API Gateway abuse or EC2 activity)
- [ ] 📁 Archive alerts to S3 for long-term storage & audit
- [ ] 📖 Write a blog post or LinkedIn article describing project use case and learnings
- [ ] 📬 Email alert fallback via SES
- [ ] 🧠 AI-based alert prioritization (testowy NLP scoring w Lambda)
- [ ] 🧼 Terraform remote state (S3 + DynamoDB lock)
- [ ] 📦 Containerize Lambda runtime for advanced dependency isolation
- [x] Slack alert forwarding via Lambda
- [x] Manual test publishing to SNS confirmed end-to-end

## License

[MIT](LICENSE)

---

## Security Policy

For vulnerability reports, please see [SECURITY.md](SECURITY.md)

```markdown
> "Trust me, I'm a Lambda."  
> — this function, probably right before it timed out
```

```markdown
> "Monitoring without alerts is just stalking your own infrastructure."  
> — Unknown DevOps Philosopher
```