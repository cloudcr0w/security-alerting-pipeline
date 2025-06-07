"""Lambda function to process IAM CloudTrail events and send formatted security alerts via SNS."""

import json
import boto3
import os

def lambda_handler(event, context):
    sns = boto3.client('sns')
    topic_arn = os.environ['SNS_TOPIC_ARN']

    user = event['detail']['userIdentity'].get('userName', 'unknown-user')
    time = event['detail'].get('eventTime', 'unknown-time')
    ip = event['detail'].get('sourceIPAddress', 'unknown-ip')
    event_name = event['detail'].get('eventName', 'unknown-event')

    message = f"""
🚨 [SECURITY ALERT]
Event: {event_name}
User: {user}
Time: {time}
Source IP: {ip}
"""

    sns.publish(
        TopicArn=topic_arn,
        Subject=f"[SECURITY ALERT] {event_name}",
        Message=message.strip()
    )

    return {
        'statusCode': 200,
        'body': 'Alert sent.'
    }
