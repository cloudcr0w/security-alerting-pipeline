"""Lambda function to process AWS Config compliance events and send Slack alerts."""

import json
import boto3
import os

# Parse incoming GuardDuty event
# Extract finding type and IP address
# Format message for Slack
# Send via webhook

# Set up SNS client
sns = boto3.client("sns")

# Get SNS Topic ARN from environment variables
sns_topic = os.environ["SNS_TOPIC_ARN"]

def lambda_handler(event, context):
     """Main Lambda handler for processing GuardDuty events."""
    try:
        # Extract details from GuardDuty event
        finding_type = event["detail"]["type"]
        severity = event["detail"]["severity"]
        instance_id = event["detail"]["resource"]["instanceDetails"]["instanceId"]

        # Build alert message
        message = f"""
GuardDuty Alert:
Type: {finding_type}
Severity: {severity}
Instance ID: {instance_id}
"""
        # Publish message to SNS
        response = sns.publish(
            TopicArn=sns_topic,
            Subject=f"GuardDuty Alert - {finding_type}",
            Message=message.strip()
        )
        print(f"[INFO] GuardDuty alert sent via SNS. Message ID: {response['MessageId']}")

    except Exception as e:
        print(f"[ERROR] Exception during GuardDuty alert processing: {type(e).__name__}: {e}")

    return {
        "statusCode": 200,
        "body": "GuardDuty alert processed"
    }
