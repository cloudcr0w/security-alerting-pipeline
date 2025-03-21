
import os
import boto3
import json

def lambda_handler(event, context):
    sns = boto3.client('sns')
    topic_arn = os.environ['SNS_TOPIC_ARN']
    
    message = json.dumps(event, indent=2)
    
    sns.publish(
        TopicArn=topic_arn,
        Subject='[SECURITY ALERT] IAM CreateUser',
        Message=message
    )
    
    return {
        'statusCode': 200,
        'body': 'Alert sent via SNS.'
    }
