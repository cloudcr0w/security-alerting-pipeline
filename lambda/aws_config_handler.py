"""Lambda function to process GuardDuty findings and send alerts to SNS or Slack."""
import json
import os
import requests

SLACK_WEBHOOK_URL = os.environ.get("SLACK_WEBHOOK_URL")

def lambda_handler(event, context):
    print("Received AWS Config alert:")
    print(json.dumps(event, indent=2))

    compliance_type = event.get("detail", {}).get("newEvaluationResult", {}).get("complianceType", "UNKNOWN")
    rule_name = event.get("detail", {}).get("configRuleName", "UnknownRule")

    if compliance_type == "NON_COMPLIANT":
        message = {
            "text": f":warning: AWS Config rule *{rule_name}* is NON_COMPLIANT!"
        }
        if SLACK_WEBHOOK_URL:
            try:
                response = requests.post(
                    SLACK_WEBHOOK_URL,
                    data=json.dumps(message),
                    headers={"Content-Type": "application/json"}
                )
                print(f"Sent to Slack: {response.status_code}")
            except Exception as e:
                print(f"Error sending to Slack: {str(e)}")
        else:
            print("No SLACK_WEBHOOK_URL set – skipping Slack notification")

    return {"status": "ok"}
