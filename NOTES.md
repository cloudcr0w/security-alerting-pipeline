# 🗒️ Notes – AWS Security Alerting Pipeline

Work in progress – focused on learning, improving, and building practical AWS security skills.

---

## ✅ Done – tuesday 1 april 2025

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

---

## 📌 TODO , still thinking about it ... open for ideas

- [ ] Add quick Slack/Discord integration via webhook
- [ ] Consider a separate SNS topic for GuardDuty alerts
- [ ] Try real-time GuardDuty finding in AWS Console
- [ ] Add `print()` debug to IAM alert Lambda for consistency
- [ ] Split Lambda code into separate folders if grows further

---

## ❓ Questions to Explore

- How to route alerts to different emails based on severity or type?
- What would full CloudWatch Logs retention + metric filters setup look like?
- Should I add support for S3 security-related events (e.g., public buckets)?

---

## 📝 Future Plan >>>

- ✅ Clean Docker image naming (add version tag)
- [ ] Run full test for GuardDuty Lambda using sample JSON
- ✅ Add `README.md` to `samples/` folder for test context
- [ ] Brainstorm CI/CD ideas (e.g., GitHub Actions + Terraform Plan/Apply)
- [ ] (Optional) Try minimal EKS or ECS simulation for alert receiver (maybe)
