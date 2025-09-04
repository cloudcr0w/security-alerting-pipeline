import boto3
import json
import urllib3

http = urllib3.PoolManager()

def get_slack_webhook_url(secret_name="slack/webhook-url", region_name="us-east-1"):
    try:
        client = boto3.client("secretsmanager", region_name=region_name)
        response = client.get_secret_value(SecretId=secret_name)
        return response["SecretString"]
    except Exception as e:
        print(f"❌ Error fetching secret: {e}")
        return None

def lambda_handler(event, context):
    webhook_url = get_slack_webhook_url()

    if not webhook_url:
        print("❌ Slack webhook URL not found. Aborting.")
        return {"statusCode": 500, "body": "Slack webhook not configured"}

    for record in event["Records"]:
        msg = record["Sns"]["Message"]
        payload = format_slack_message(msg)

        encoded_msg = json.dumps(payload).encode("utf-8")
        resp = http.request(
            "POST",
            webhook_url,
            body=encoded_msg,
            headers={"Content-Type": "application/json"},
            timeout=10.0
        )

        print(f"Slack response: {resp.status}")

    return {"statusCode": 200, "body": "Sent to Slack"}
