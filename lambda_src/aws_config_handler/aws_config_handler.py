"""Lambda function to process AWS Config findings and send alerts to Slack."""

import json
import os

import requests

SLACK_WEBHOOK_URL = os.environ.get("SLACK_WEBHOOK_URL")


def lambda_handler(event, context):
    print("[INFO] Lambda triggered with AWS Config alert:")
    print(json.dumps(event, indent=2))

    try:
        compliance_type = (
            event.get("detail", {})
            .get("newEvaluationResult", {})
            .get("complianceType", "UNKNOWN")
        )
        rule_name = event.get("detail", {}).get("configRuleName", "UnknownRule")

        print(f"[INFO] Rule: {rule_name}, Compliance status: {compliance_type}")

        if compliance_type == "NON_COMPLIANT":
            message = {
                "text": f":warning: AWS Config rule *{rule_name}* is NON_COMPLIANT!"
            }

            if SLACK_WEBHOOK_URL:
                try:
                    response = requests.post(
                        SLACK_WEBHOOK_URL,
                        data=json.dumps(message),
                        headers={"Content-Type": "application/json"},
                    )
                    print(f"[INFO] Sent to Slack. Status: {response.status_code}")
                except Exception as e:
                    print(f"[ERROR] Failed to send to Slack: {type(e).__name__}: {e}")
            else:
                print("[WARN] SLACK_WEBHOOK_URL not set. Skipping Slack alert.")
        else:
            print("[INFO] Resource is compliant. No alert sent.")

    except Exception as e:
        print(
            f"[ERROR] Exception during AWS Config event processing: {type(e).__name__}: {e}"
        )

    return {"status": "ok"}
