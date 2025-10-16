import json, os, sys, types, importlib, pathlib, pytest

os.environ.setdefault("AWS_REGION", "eu-central-1")
os.environ.setdefault(
    "SNS_TOPIC_ARN", "arn:aws:sns:eu-central-1:111111111111:dummy-topic"
)


class DummySNS:
    def publish(self, **kwargs):
        print("Mock publish:", kwargs)
        return {"MessageId": "fake-5678"}


fake_boto3 = types.ModuleType("boto3")
fake_boto3.client = lambda *a, **k: DummySNS()
sys.modules["boto3"] = fake_boto3


from lambda_src.aws_config_handler.aws_config_handler import lambda_handler


def test_noncompliant_resource_event(tmp_path):
    with open("samples/aws-config-noncompliant.json") as f:
        event = json.load(f)
    resp = lambda_handler(event, context={})
    assert isinstance(resp, dict)
    assert resp.get("statusCode", 200) in (200, 202)
