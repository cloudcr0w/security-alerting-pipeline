import boto3
import json
import urllib3
import requests
import os

http = urllib3.PoolManager()

def get_slack_webhook_url(secret_name="slack/webhook-url", region_name="us-east-1"):
    try:
        client = boto3.client("secretsmanager", region_name=region_name)
        response = client.get_secret_value(SecretId=secret_name)
        secret = json.loads(response["SecretString"])
        return secret["webhook"]
    except Exception as e:
        print(f"❌ Error fetching secret: {e}")
        return None

slack_webhook_url = get_slack_webhook_url()

def lambda_handler(event, context):
    try:
        print("[DEBUG] Incoming event:", json.dumps(event))

        sns_message_str = event["Records"][0]["Sns"]["Message"]
        sns_message = json.loads(sns_message_str)

        finding_type = sns_message["detail"]["type"]
        severity = sns_message["detail"]["severity"]
        instance_id = sns_message["detail"]["resource"]["instanceDetails"]["instanceId"]

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
            print("[WARN] No Slack webhook configured. Alert not sent.")

    except Exception as e:
        print(f"[ERROR] Exception during GuardDuty alert processing: {type(e).__name__}: {e}")

    return {
        "statusCode": 200,
        "body": "GuardDuty alert forwarded to Slack"
    }
