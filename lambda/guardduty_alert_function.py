import json
import boto3
import os

# lets work with sns
sns = boto3.client("sns")

# get arn form env
sns_topic = os.environ["SNS_TOPIC_ARN"]

def lambda_handler(event, context):
    # get data form event
    finding_type = event["detail"]["type"]
    severity = event["detail"]["severity"]
    instance_id = event["detail"]["resource"]["instanceDetails"]["instanceId"]

    # build message
    message = f"""
🚨 [GuardDuty Alert]
Type: {finding_type}
Severity: {severity}
Instance ID: {instance_id}
"""

    # send to SNS
    sns.publish(
        TopicArn=sns_topic,
        Subject=f"[GuardDuty Alert] {finding_type}",
        Message=message.strip()
    )
