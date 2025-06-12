"""Lambda function to process GuardDuty findings and send alerts to SNS or Slack."""

import json
import boto3
import os
import requests

# Get environment variables
slack_webhook_url = os.environ.get("SLACK_WEBHOOK_URL")
sns_topic = os.environ["SNS_TOPIC_ARN"]

# Set up SNS client
sns = boto3.client("sns")

def lambda_handler(event, context):
    """Main Lambda handler for processing GuardDuty events."""

    try:
        # Extract details from GuardDuty event
        finding_type = event["detail"]["type"]
        severity = event["detail"]["severity"]
        instance_id = event["detail"]["resource"]["instanceDetails"]["instanceId"]

        # Build alert message
        message = f"""
🚨 *GuardDuty Alert* 🚨
*Type:* {finding_type}
*Severity:* {severity}
*Instance ID:* {instance_id}
"""

        if slack_webhook_url:
            response = requests.post(
                slack_webhook_url,
                data=json.dumps({"text": message.strip()}),
                headers={"Content-Type": "application/json"}
            )
            print(f"[INFO] Slack alert sent. Status: {response.status_code}")
        else:
            sns_response = sns.publish(
                TopicArn=sns_topic,
                Subject=f"GuardDuty Alert - {finding_type}",
                Message=message.strip()
            )
            print(f"[INFO] SNS alert sent. Message ID: {sns_response['MessageId']}")

    except Exception as e:
        print(f"[ERROR] Exception during GuardDuty alert processing: {type(e).__name__}: {e}")

    return {
        "statusCode": 200,
        "body": "GuardDuty alert processed"
    }
