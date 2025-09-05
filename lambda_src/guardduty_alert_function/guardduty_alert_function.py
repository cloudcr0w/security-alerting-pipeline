"""Lambda function to process GuardDuty findings and send alerts to SNS or Slack."""

import json
import boto3
import os
import requests

# Get environment variables
sns_topic = os.environ["SNS_TOPIC_ARN"]
# Set up SNS client
sns = boto3.client("sns")

def get_slack_webhook_url():
    secret_name = "slack/webhook-url"
    region_name = "us-east-1"

    client = boto3.client("secretsmanager", region_name=region_name)
    response = client.get_secret_value(SecretId=secret_name)

    secret = json.loads(response["SecretString"])
    return secret["webhook"]

slack_webhook_url = get_slack_webhook_url()


def lambda_handler(event, context):
    """Main Lambda handler for processing GuardDuty events."""

    try:
        # msg
        if "Records" in event and "Sns" in event["Records"][0]:
            print("[DEBUG] Detected SNS format")
            sns_message_str = event["Records"][0]["Sns"]["Message"]
            event = json.loads(sns_message_str)

        # Tutaj zakładamy że `event` ma już bezpośredni format GuardDuty
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
