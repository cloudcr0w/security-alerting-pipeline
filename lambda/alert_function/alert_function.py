"""Lambda function to process IAM CloudTrail events and send formatted security alerts via SNS."""

import json
import boto3
import os

def lambda_handler(event, context):
    print("[INFO] Lambda triggered with event:")
    print(json.dumps(event, indent=2))

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

    print(f"[INFO] Composed alert for event: {event_name}")
    print(f"[INFO] Sending alert to SNS topic: {topic_arn}")

    try:
        response = sns.publish(
            TopicArn=topic_arn,
            Subject=f"[SECURITY ALERT] {event_name}",
            Message=message.strip()
        )
        print(f"[INFO] SNS message published successfully. Message ID: {response['MessageId']}")
    except Exception as e:
        print(f"[ERROR] Failed to publish to SNS: {type(e).__name__}: {e}")
    """Lambda function to process IAM CloudTrail events and send formatted security alerts via SNS."""

import json
import boto3
import os

def lambda_handler(event, context):
    print("[INFO] Lambda triggered with event:")
    print(json.dumps(event, indent=2))

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

    print(f"[INFO] Composed alert for event: {event_name}")
    print(f"[INFO] Sending alert to SNS topic: {topic_arn}")

    try:
        response = sns.publish(
            TopicArn=topic_arn,
            Subject=f"[SECURITY ALERT] {event_name}",
            Message=message.strip()
        )
        print(f"[INFO] SNS message published successfully. Message ID: {response['MessageId']}")
    except Exception as e:
        print(f"[ERROR] Failed to publish to SNS: {type(e).__name__}: {e}")

    return {
        'statusCode': 200,
        'body': 'Alert sent.'
    }

