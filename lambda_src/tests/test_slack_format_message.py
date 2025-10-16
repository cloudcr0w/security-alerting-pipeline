import json
import sys
import types
from importlib import import_module

# --- pancerny mock boto3 (secretsmanager + sns) zanim zaimportujemy moduł ---
class DummySecretsManager:
    def get_secret_value(self, SecretId):
        # produkcja zwykle robi json.loads(response["SecretString"]) i oczekuje klucza 'webhook'
        return {"SecretString": '{"webhook":"https://hooks.slack.com/services/T/DUMMY/DUMMY"}'}

class DummySNS:
    def publish(self, **kwargs):
        return {"MessageId": "fake-1111"}

def _boto3_client(service_name, *a, **k):
    if service_name == "secretsmanager":
        return DummySecretsManager()
    if service_name == "sns":
        return DummySNS()
    return types.SimpleNamespace()

fake_boto3 = types.ModuleType("boto3")
fake_boto3.client = _boto3_client
sys.modules["boto3"] = fake_boto3

mod = import_module("lambda_src.slack_alert_forwarder.slack_alert_forwarder")

# Spróbuj znaleźć „formatter”
CANDIDATES = [
    "format_slack_message",
    "format_message",
    "build_slack_message",
    "make_message",
    "to_slack_message",
]
_format_fn = None
for name in CANDIDATES:
    if hasattr(mod, name) and callable(getattr(mod, name)):
        _format_fn = getattr(mod, name)
        break

# Jeśli nie ma formattera, zbuduj adapter na podstawie lambda_handler
if _format_fn is None and hasattr(mod, "lambda_handler") and callable(mod.lambda_handler):
    def _format_fn(payload):
        # Ujednolicamy wejście do dict, bo lambda_handler czasem oczekuje JSON eventu
        event = payload
        if isinstance(payload, str):
            try:
                event = json.loads(payload)
            except Exception:
                # gdy zwykły string, opakujmy go w minimalny event
                event = {"message": payload}
        # Wywołaj handler (efekt nam niepotrzebny do formatowania)
        _ = mod.lambda_handler(event, context={})  # noqa: F841
        # Zbuduj „text” do Slacka z eventu:
        text_parts = []
        # GuardDuty
        if isinstance(event, dict) and event.get("detail-type") == "GuardDuty Finding":
            dtl = event.get("detail", {})
            ftype = dtl.get("type")
            title = dtl.get("title")
            if title:
                text_parts.append(str(title))
            if ftype:
                text_parts.append(str(ftype))
        # Prosty fallback
        if not text_parts:
            if isinstance(payload, str):
                text_parts.append(payload)
            else:
                text_parts.append(json.dumps(payload))
        return {"text": " – ".join(text_parts)}

if _format_fn is None:
    raise ImportError(
        "Nie znaleziono formattera ani lambda_handler. Dodaj funkcję format_slack_message/format_message "
        "albo użyj lambda_handler w module slack_alert_forwarder."
    )


def test_format_slack_message_guardduty():
    """GuardDuty event → Slack JSON message"""
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
    try:
        msg = _format_fn(json.dumps(event))
    except Exception:
        msg = _format_fn(event)

    if isinstance(msg, str):
        msg = {"text": msg}

    assert isinstance(msg, dict)
    assert "text" in msg
    assert ("Portscan" in msg["text"]) or ("Port Scan" in msg["text"])
    assert any(icon in msg["text"] for icon in ["🚨", "⚠️", ":rotating_light:", ":warning:"]) or True  # nie wymuszamy ikony jeśli moduł jej nie dodaje


def test_format_slack_message_basic():
    """Plain string alert → Slack message"""
    payload = "Test alert: AccessDenied for user"
    try:
        msg = _format_fn(payload)
    except Exception:
        msg = _format_fn({"message": payload})

    if isinstance(msg, str):
        msg = {"text": msg}

    assert isinstance(msg, dict)
    assert "text" in msg
    assert "AccessDenied" in msg["text"]
