.PHONY: init plan apply test-lambda test-config-lambda logs lint

init:
	cd terraform && terraform init

plan:
	cd terraform && terraform plan

apply:
	cd terraform && terraform apply

test-lambda:
	aws lambda invoke \
		--function-name security-alert-function \
		--payload fileb://samples/sample-event.json \
		out.json && cat out.json

test-config-lambda:
	aws lambda invoke \
		--function-name aws_config_handler \
		--payload fileb://samples/aws-config-noncompliant.json \
		out.json && cat out.json

logs:
	aws logs tail /aws/lambda/security-alert-function --follow

lint:
	black lambda/*.py
