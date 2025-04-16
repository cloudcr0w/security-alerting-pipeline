import json

def lambda_handler(event, context):
    print("Received AWS Config alert:")
    print(json.dumps(event, indent=2))
    return {"status": "ok"}
