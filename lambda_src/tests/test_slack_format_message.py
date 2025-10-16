from lambda_src.slack_alert_forwarder.slack_alert_forwarder import format_slack_message

import json


def test_format_slack_message_guardduty():
    event = {
        "detail-type": "GuardDuty Finding",
        "detail": {
            "type": "Recon:EC2/Portscan",
            "region": "us-east-1",
            "severity": 5,
            "title": "EC2 Port Scan",
            "updatedAt": "2025-09-01T12:00:00Z",
        },
    }

    event_str = json.dumps(event)

    message = format_slack_message(event_str)
    assert "Portscan" in message["text"]
    assert "🚨" in message["text"] or "⚠️" in message["text"]


def test_format_slack_message_basic():
    msg = "Test alert: AccessDenied for user"
    result = format_slack_message(msg)

    assert isinstance(result, dict)
    assert "text" in result
    assert "AccessDenied" in result["text"]
    assert "🚨" in result["text"]
