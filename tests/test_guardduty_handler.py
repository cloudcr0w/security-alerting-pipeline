import os, sys, json, types, importlib, pkgutil, pathlib, pytest

# --- ENV zanim zaimportujemy lambdę ---
os.environ.setdefault("SNS_TOPIC_ARN", "arn:aws:sns:eu-central-1:111111111111:dummy-topic")
os.environ.setdefault("SLACK_WEBHOOK_URL", "https://hooks.slack.com/services/T/DUMMY/DUMMY")
os.environ.setdefault("AWS_REGION", "eu-central-1")

ROOT = pathlib.Path(__file__).resolve().parents[1]
if str(ROOT) not in sys.path:
    sys.path.insert(0, str(ROOT))

PKG_NAME = "lambda_src"

class DummySecretsManager:
    def get_secret_value(self, SecretId):
        # produkcja robi: secret = json.loads(response["SecretString"]); secret["webhook"]
        return {
            "SecretString": '{"webhook":"https://hooks.slack.com/services/T/DUMMY/DUMMY"}'
        }



class DummySNS:
    def publish(self, **kwargs):
        return {"MessageId": "fake-1234"}

def _boto3_client(service_name, *a, **k):
    if service_name == "secretsmanager":
        return DummySecretsManager()
    if service_name == "sns":
        return DummySNS()
    return types.SimpleNamespace()

fake_boto3 = types.ModuleType("boto3")
fake_boto3.client = _boto3_client
sys.modules["boto3"] = fake_boto3


def _discover_lambda_handler():
    """Znajdź lambda_handler — użyj LAMBDA_MODULE albo przeszukaj lambda_src/* ."""
    mod_name = os.getenv("LAMBDA_MODULE")
    if mod_name:
        # Czyść cache importów, żeby mieć pewność użycia naszego mocka
        for i in range(1, len(mod_name.split(".")) + 1):
            sys.modules.pop(".".join(mod_name.split(".")[:i]), None)
        mod = importlib.import_module(mod_name)
        fn = getattr(mod, "lambda_handler", None)
        if not fn:
            raise ImportError(f"Module {mod_name} has no lambda_handler()")
        return fn

    pkg = importlib.import_module(PKG_NAME)
    pkg_path = pathlib.Path(pkg.__file__).parent
    for finder, name, ispkg in pkgutil.walk_packages([str(pkg_path)], prefix=f"{PKG_NAME}."):
        if ispkg:
            continue
        sys.modules.pop(name, None)
        mod = importlib.import_module(name)
        fn = getattr(mod, "lambda_handler", None)
        if callable(fn):
            return fn
    raise ImportError("No lambda_handler() found in lambda_src/*")


def test_guardduty_event_returns_200():
    handler = _discover_lambda_handler()
    with open("samples/sample-event.json") as f:
        event = json.load(f)
    resp = handler(event, context={})
    if isinstance(resp, dict) and "statusCode" in resp:
        assert resp["statusCode"] in (200, 202)
    else:
        assert resp is None or resp is True or resp == {}
