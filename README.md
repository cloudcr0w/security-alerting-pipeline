# 🛡️ AWS Security Alerting Pipeline

This project demonstrates a simple and effective AWS security alerting pipeline that detects IAM security events and sends notifications via email using AWS services.

## 🚀 Project Overview

The pipeline captures specific security-related events, such as the creation of a new IAM user, and sends an alert via email to notify administrators of potential risks or unauthorized changes in the AWS environment.

### ✅ Initial Use Case

> Detect and alert when a new IAM user is created (`CreateUser` event in AWS CloudTrail).

## 🧱 Architecture

![Architecture Diagram](diagram.png)

**Services used:**
- **AWS CloudTrail** – for logging all account activity
- **Amazon EventBridge** – for filtering specific security events
- **AWS Lambda (Python)** – for processing and formatting alert messages
- **Amazon SNS** – for sending email notifications

---

## 📁 Project Structure
```bash
CloudTrail --> EventBridge --> Lambda --> SNS --> Email
     |             |              |         |      
  Logs         Event Filter    Alert    Notification
                               Logic     via Email

GuardDuty ----^
   |
Threat Findings
```

## ⚙️ How It Works

1. CloudTrail records all actions in the account.
2. EventBridge rule filters for specific actions (e.g., `CreateUser`).
3. The rule triggers a Lambda function.
4. Lambda formats the alert and publishes it to an SNS topic.
5. SNS sends an email notification to the configured address.

## 🛡️ GuardDuty Integration (in progress)

The project will include a GuardDuty-based detection system for threats such as:
- Brute-force SSH attacks
- Malicious IP communication
- Unauthorized EC2 access

Current progress:
- ✅ GuardDuty detector created
- 🔄 EventBridge rule and alert forwarding – in development

##  Testing GuardDuty Events (in works )


## 🧪 Demo Alert Example

🚨 [SECURITY ALERT] IAM User Created
User: jansmith
Time: 2025-03-21T13:22:00Z
Event: CreateUser
Resource: arn:aws:iam::123456789012:user/jansmith

## ⚙️ Configuration with terraform.tfvars

You can create a `terraform.tfvars` file to store your input variables:

```hcl
region      = "us-east-1"
alert_email = "your-email@example.com"
```
Then run Terraform like this:
```bash
terraform apply -var-file="terraform.tfvars"
```
This keeps your configuration clean and reusable.

## 📦 Deploying the Pipeline

> Requirements:
> - AWS CLI configured
> - Terraform installed

```bash
cd terraform/
terraform init
terraform apply
Then confirm the subscription in the email you receive from SNS.
```

## 🧪 How to Test

1. Apply Terraform configuration
2. Confirm SNS subscription via email
3. Trigger event (e.g., create an IAM user)
4. Check your email inbox for an alert

## 🧪 Sample Event

Use the provided `sample-event.json` file to test the Lambda function directly in the AWS console.

📌 Next Steps (Ideas for Expansion)
Add support for more events (e.g., S3 bucket policy changes, root login)
Integrate with Slack or Discord via webhook
Connect with AWS Security Hub for aggregated security findings
Add log aggregation or storage with CloudWatch Logs or S3

## 🧠 Author

**Adam Wrona** – aspiring DevOps / AWS Cloud Engineer  
🔗 [LinkedIn](https://www.linkedin.com/in/adam-wrona-111ba728b) • [GitHub](https://github.com/cloudcr0w)
