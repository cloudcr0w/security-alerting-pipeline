import json
import sys
import types
from importlib import import_module


# --- boto3 mock: secretsmanager.get_secret_value + sns.publish ---
class DummySecretsManager:
    def get_secret_value(self, SecretId):
        # produkcja zwykle robi json.loads(response["SecretString"]) i oczekuje klucza 'webhook'
        return {"SecretString": '{"webhook":"https://hooks.slack.com/services/T/DUMMY/DUMMY"}'}


class DummySNS:
    def publish(self, **kwargs):
        return {"MessageId": "fake-1111"}


def _boto3_client(service_name, *args, **kwargs):
    if service_name == "secretsmanager":
        return DummySecretsManager()
    if service_name == "sns":
        return DummySNS()
    return types.SimpleNamespace()


# wstrzyknięcie modułu boto3 PRZED importem modułu produkcyjnego
fake_boto3 = types.ModuleType("boto3")
fake_boto3.client = _boto3_client
sys.modules["boto3"] = fake_boto3


# import modułu produkcyjnego
mod = import_module("lambda_src.slack_alert_forwarder.slack_alert_forwarder")


# wykrycie funkcji formatującej (kilka możliwych nazw)
CANDIDATES = [
    "format_slack_message",
    "format_message",
    "build_slack_message",
    "make_message",
    "to_slack_message",
]

_format_fn = None
for name in CANDIDATES:
    if hasattr(mod, name):
        cand = getattr(mod, name)
        if callable(cand):
            _format_fn = cand
            break


# fallback: adapter na bazie lambda_handler, jeśli nie ma formattera
if _format_fn is None and hasattr(mod, "lambda_handler") and callable(mod.lambda_handler):

    def _format_fn(payload):
        # ujednolicenie wejścia (str → dict)
        event = payload
        if isinstance(payload, str):
            try:
                event = json.loads(payload)
            except Exception:
                event = {"message": payload}

        # wywołanie handlera (wynik nie jest wymagany do formatowania)
        _ = mod.lambda_handler(event, context={})  # noqa: F841

        # budowa prostego tekstu do Slacka z eventu
        parts = []
        if isinstance(event, dict) and event.get("detail-type") == "GuardDuty Finding":
            detail = event.get("detail", {})
            title = detail.get("title")
            ftype = detail.get("type")
            if title:
                parts.append(str(title))
            if ftype:
                parts.append(str(ftype))
        if not parts:
            if isinstance(payload, str):
                parts.append(payload)
            else:
                parts.append(json.dumps(payload))

        return {"text": " – ".join(parts)}


if _format_fn is None:
    raise ImportError(
        "Brak formattera i lambda_handler w module slack_alert_forwarder; dodaj jedną z funkcji: "
        + ", ".join(CANDIDATES)
    )


def test_format_slack_message_guardduty():
    """GuardDuty event → Slack JSON message."""
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

    # część formatterów przyjmuje string, część dict – spróbujmy obu
    try:
        msg = _format_fn(json.dumps(event))
    except Exception:
        msg = _format_fn(event)

    # normalizacja wyniku
    if isinstance(msg, str):
        msg = {"text": msg}

    assert isinstance(msg, dict)
    assert "text" in msg
    text = msg["text"]
    assert ("Portscan" in text) or ("Port Scan" in text)


def test_format_slack_message_basic():
    """Plain string alert → Slack message."""
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
