import json
import boto3
import os

# Set up SNS client
sns = boto3.client("sns")

# Get SNS Topic ARN from environment variables
sns_topic = os.environ["SNS_TOPIC_ARN"]

def lambda_handler(event, context):
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
        sns.publish(
            TopicArn=sns_topic,
            Subject=f"GuardDuty Alert - {finding_type}",
            Message=message.strip()
        )
        print("Message sent successfully.")

    except Exception as e:
        print("Error during alert processing:", str(e))

    return {
        "statusCode": 200,
        "body": "GuardDuty alert processed"
    }
