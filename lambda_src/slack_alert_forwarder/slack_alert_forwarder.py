import json
import os
import urllib3

http = urllib3.PoolManager()
SLACK_WEBHOOK_URL = os.environ.get("SLACK_WEBHOOK_URL")

def format_slack_message(msg: str) -> dict:
    return {
        "text": f"🚨 *SNS Alert received!*\n```{msg}```"
    }

def lambda_handler(event, context):
    for record in event["Records"]:
        msg = record["Sns"]["Message"]
        payload = format_slack_message(msg)

        encoded_msg = json.dumps(payload).encode("utf-8")
        resp = http.request(
            "POST",
            SLACK_WEBHOOK_URL,
            body=encoded_msg,
            headers={"Content-Type": "application/json"},
            timeout=10.0
        )

    print(f"Slack response: {resp.status}")
