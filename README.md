# 🛡️ AWS Security Alerting Pipeline

### AWS-native alerting system for IAM and GuardDuty events – built with Terraform, Lambda and SNS

This project demonstrates a simple and effective AWS security alerting pipeline that detects IAM and GuardDuty security events and sends notifications via email using AWS services.

---

## 🚀 Project Overview

The pipeline captures specific security-related events, such as:

- IAM user creation (`CreateUser`)
- GuardDuty findings (e.g., SSH brute-force)

Once detected, the pipeline sends an email alert to notify administrators of potential risks or unauthorized changes in the AWS environment.

---

## ✅ Initial Use Case

> Detect and alert when a new IAM user is created (CreateUser event in AWS CloudTrail).

---

## 🧱 Architecture

**High-level flow:**

CloudTrail --> EventBridge --> Lambda --> SNS --> Email  
     |             |              |         |  
  Logs         Event Filter    Alert    Notification  
                               Logic     via Email  

GuardDuty ----^  
   |  
Threat Findings

*(Architecture diagram coming soon)*

---

## 🔧 Services Used

- **AWS CloudTrail** – Logs account activity  
- **Amazon EventBridge** – Filters specific events  
- **AWS Lambda (Python)** – Processes and formats alert messages  
- **Amazon SNS** – Sends email notifications  
- **AWS GuardDuty** – Detects security threats

---

## 📁 Project Structure

- `terraform/` – Infrastructure as code  
- `lambda/` – Lambda function code (Python)  
- `samples/` – Sample input events and variables  
- `alert-receiver/` – Flask container to simulate external alert handling  
- `k8s/` – Simple Kubernetes deployment config  
- `README.md` – Project documentation

---

## ⚙️ How It Works

1. CloudTrail records all actions in the account  
2. EventBridge rule filters for specific actions (e.g., CreateUser)  
3. The rule triggers a Lambda function  
4. Lambda formats the alert and publishes to an SNS topic  
5. SNS sends an email notification

---

## 🛡️ GuardDuty Integration (in progress)

This project will support GuardDuty-based detection for:

- Brute-force SSH attacks  
- Malicious IP traffic  
- Unauthorized EC2 access

Current progress:

- ✅ GuardDuty detector created  
- 🔄 EventBridge rule + Lambda forwarding in development

---

## ✅ GuardDuty Lambda Test Info

Test GuardDuty Lambda manually using the AWS CLI:

```bash
aws lambda invoke \
  --function-name guardduty_alert_function \
  --payload file://test-events/guardduty-ssh-brute.json \
  --cli-binary-format raw-in-base64-out \
  output.json
```

Make sure:

- Lambda has CloudWatch Logs + SNS permissions  
- SNS email subscription is confirmed  
- Logs appear in `/aws/lambda/guardduty_alert_function`

Expected response:

```json
{
  "statusCode": 200,
  "body": "GuardDuty alert processed"
}
```

---

## 📦 Deploying the Pipeline

**Requirements:**

- AWS CLI configured  
- Terraform installed

```bash
cd terraform/
terraform init
terraform apply
```

Then confirm the subscription in the email you receive from SNS.

---

## ⚙️ Configuration with terraform.tfvars

Create `terraform.tfvars`:

```hcl
region      = "us-east-1"
alert_email = "your-email@example.com"
```

Apply configuration:

```bash
terraform apply -var-file="terraform.tfvars"
```

---

## 🐍 Alert Receiver (Flask)

A simple Flask app in a container to simulate alert processing:

- Listens on `/alert` for POST requests  
- Logs incoming JSON to the console  
- Used to explore containerization and K8s basics

---

## 🐳 Docker & Kubernetes Integration

| Component              | Description                                     |
|------------------------|-------------------------------------------------|
| `Dockerfile`           | In `alert-receiver/`, builds Flask alert app    |
| `docker-compose`       | Runs the app locally in a container             |
| `k8s/deployment.yaml`  | Deploys the alert app to Kubernetes             |

Run locally:

```bash
docker-compose up
```

Deploy to Kubernetes:

```bash
kubectl apply -f k8s/deployment.yaml
```

---

## 📄 Sample Files

Located in `samples/`:

- `terraform.tfvars.example`  
- `sample-event.json`  
- `sample-guardduty-event.json`

---

## 🧠 What I Learned

- How to use Terraform to deploy a real security alerting pipeline  
- How IAM + GuardDuty + EventBridge + Lambda + SNS work together  
- How to log to CloudWatch and test Lambda manually  
- First hands-on experience with GuardDuty in a personal project  
- Basics of Docker and K8s for alert receiver integration

---

## 🔭 Next Steps (Ideas for Expansion)

- Add support for more events (e.g., S3 bucket policy changes, root login)  
- Integrate with Slack or Discord via webhook  
- Add CI/CD for Terraform + Lambda packaging  
- Improve error handling and logging  
- Add CloudWatch metrics and alarms

---

## 👤 Author

**Adam Wrona** – aspiring DevOps / AWS Cloud Engineer  
🔗 [LinkedIn](https://www.linkedin.com/in/adam-wrona-111ba728b) • [GitHub](https://github.com/cloudcr0w)

_Last updated: April 7, 2025_
