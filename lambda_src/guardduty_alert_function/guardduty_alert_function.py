"""
Lambda processes GuardDuty findings coming from EventBridge or SNS
and forwards alerts to Slack or SNS topic depending on configuration.
"""

import json
import os
import logging

import boto3
import requests

logger = logging.getLogger()
logger.setLevel(logging.INFO)

# Get environment variables
sns_topic = os.environ["SNS_TOPIC_ARN"]
# Initialize SNS client used to publish fallback alerts
sns = boto3.client("sns")


# Retrieve Slack webhook URL from AWS Secrets Manager.
# If the secret cannot be accessed, fallback to environment variable.
def get_slack_webhook_url():
    secret_name = "slack/webhook-url"
    region_name = os.getenv("AWS_REGION", "us-east-1")

    try:
        client = boto3.client("secretsmanager", region_name=region_name)
        response = client.get_secret_value(SecretId=secret_name)
        secret = json.loads(response["SecretString"])
        return secret.get("webhook") or secret.get("SLACK_WEBHOOK_URL")
    except Exception as e:
        print(f"[WARN] Falling back to env Slack webhook: {e}")
        return os.getenv("SLACK_WEBHOOK_URL")


slack_webhook_url = get_slack_webhook_url()


def lambda_handler(event, context):
    """Main Lambda handler for processing GuardDuty events."""

    logger.info("GuardDuty alert handler start")
    logger.debug("Raw event: %s", json.dumps(event))

    try:
        # GuardDuty events can arrive wrapped in SNS
        if "Records" in event and "Sns" in event["Records"][0]:
            logger.info("Detected SNS format")
            sns_message_str = event["Records"][0]["Sns"]["Message"]
            event = json.loads(sns_message_str)

        finding_type = event["detail"]["type"]
        severity = event["detail"]["severity"]
        instance_id = event["detail"]["resource"]["instanceDetails"]["instanceId"]

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
                headers={"Content-Type": "application/json"},
            )
            logger.info("Slack alert sent. Status: %s", response.status_code)

        else:
            sns_response = sns.publish(
                TopicArn=sns_topic,
                Subject=f"GuardDuty Alert - {finding_type}",
                Message=message.strip(),
            )
            logger.info("SNS alert sent. Message ID: %s", sns_response["MessageId"])

    except Exception as e:
        logger.error("Exception during GuardDuty alert processing: %s", e)

    return {"statusCode": 200, "body": "GuardDuty alert processed"}
