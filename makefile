TF_DIR        ?= terraform
AWS_REGION    ?= eu-central-1
AWS_PROFILE   ?= default
ENV           ?= dev
TF_VAR_FILE   ?= $(TF_DIR)/env/$(ENV).tfvars
LAMBDA_FN     ?= security-alert-function
CFG_LAMBDA_FN ?= aws_config_handler
LOG_GROUP     ?= /aws/lambda/$(LAMBDA_FN)

PY_SRC        := lambda_src
PY_TESTS      := tests

IMAGE_NAME    := alert-receiver
IMAGE_TAG     := local

SAMPLES_DIR   := samples
SAMPLE_EVENT  := $(SAMPLES_DIR)/sample-event.json
SAMPLE_CFG    := $(SAMPLES_DIR)/aws-config-noncompliant.json

.PHONY: help init fmt validate plan apply destroy \
        lint test preflight test-lambda test-config-lambda logs \
        docker-build docker-run docker-scan \
        k8s-apply k8s-delete pre-commit-all ci-all

help:
	@echo "Targets:"
	@echo "  init / fmt / validate / plan / apply / destroy"
	@echo "  lint / test"
	@echo "  preflight"
	@echo "  test-lambda / test-config-lambda / logs"
	@echo "  docker-build / docker-run / docker-scan"
	@echo "  k8s-apply / k8s-delete"
	@echo "  pre-commit-all"
	@echo "  ci-all"

init:
	cd $(TF_DIR) && AWS_REGION=$(AWS_REGION) AWS_PROFILE=$(AWS_PROFILE) terraform init

fmt:
	cd $(TF_DIR) && terraform fmt -recursive

validate:
	cd $(TF_DIR) && terraform init -backend=false && terraform validate -no-color

plan: fmt validate
	cd $(TF_DIR) && AWS_REGION=$(AWS_REGION) AWS_PROFILE=$(AWS_PROFILE) \
	terraform plan -var-file="$(TF_VAR_FILE)"

apply:
	cd $(TF_DIR) && AWS_REGION=$(AWS_REGION) AWS_PROFILE=$(AWS_PROFILE) \
	terraform apply -var-file="$(TF_VAR_FILE)"

destroy:
	cd $(TF_DIR) && AWS_REGION=$(AWS_REGION) AWS_PROFILE=$(AWS_PROFILE) \
	terraform destroy -var-file="$(TF_VAR_FILE)"

lint:
	flake8 $(PY_SRC) $(PY_TESTS) && \
	black --check --exclude "(requests|urllib3|idna|charset_normalizer|certifi|bin)" $(PY_SRC) $(PY_TESTS)

test:
	pytest -q --maxfail=1 --disable-warnings

preflight: fmt
	@echo "Preflight: terraform plan + unit tests"
	cd $(TF_DIR) && AWS_REGION=$(AWS_REGION) AWS_PROFILE=$(AWS_PROFILE) terraform init -backend=false
	cd $(TF_DIR) && AWS_REGION=$(AWS_REGION) AWS_PROFILE=$(AWS_PROFILE) \
		terraform plan -no-color -var-file="$(TF_VAR_FILE)" -out=tfplan
	PYTHONPATH=. pytest -q --maxfail=1 --disable-warnings

test-lambda:
	AWS_REGION=$(AWS_REGION) AWS_PROFILE=$(AWS_PROFILE) \
	aws lambda invoke --function-name $(LAMBDA_FN) \
		--payload fileb://$(SAMPLE_EVENT) out.json && cat out.json

test-config-lambda:
	AWS_REGION=$(AWS_REGION) AWS_PROFILE=$(AWS_PROFILE) \
	aws lambda invoke --function-name $(CFG_LAMBDA_FN) \
		--payload fileb://$(SAMPLE_CFG) out.json && cat out.json

logs:
	AWS_REGION=$(AWS_REGION) AWS_PROFILE=$(AWS_PROFILE) \
	aws logs tail $(LOG_GROUP) --follow

docker-build:
	docker build -t $(IMAGE_NAME):$(IMAGE_TAG) ./alert-receiver

docker-run:
	docker run --rm -p 5000:5000 $(IMAGE_NAME):$(IMAGE_TAG)

docker-scan:
	trivy image --ignore-unfixed --severity HIGH,CRITICAL $(IMAGE_NAME):$(IMAGE_TAG)

k8s-apply:
	kubectl apply -f k8s/

k8s-delete:
	kubectl delete -f k8s/ || true

pre-commit-all:
	pre-commit run --all-files

ci-all:
	@echo "Running local CI: fmt → validate → lint → test → docker build"
	$(MAKE) fmt validate lint test docker-build
