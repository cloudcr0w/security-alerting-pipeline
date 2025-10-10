# -------- Settings --------
TF_DIR        ?= terraform
AWS_REGION    ?= eu-central-1
AWS_PROFILE   ?= default
ENV           ?= dev                        # nazwa środowiska (opcjonalnie)
TF_VAR_FILE   ?= $(TF_DIR)/env/$(ENV).tfvars # jeśli nie używasz, usuń flagi -var-file
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

# -------- Phony --------
.PHONY: help init fmt validate plan apply destroy \
        lint test test-lambda test-config-lambda logs \
        docker-build docker-run docker-scan \
        k8s-apply k8s-delete pre-commit-all ci-all

# -------- Help --------
help:
	@echo "Targets:"
	@echo "  init / fmt / validate / plan / apply / destroy    - Terraform lifecycle"
	@echo "  lint / test                                       - Python lint & tests"
	@echo "  test-lambda / test-config-lambda / logs           - AWS Lambda helpers"
	@echo "  docker-build / docker-run / docker-scan           - Alert Receiver docker"
	@echo "  k8s-apply / k8s-delete                            - Apply/delete k8s manifests"
	@echo "  pre-commit-all                                    - Run pre-commit on all files"
	@echo "  ci-all                                            - Local CI suite"

# -------- Terraform --------
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

# -------- Python (Lambda) --------
lint:
	flake8 $(PY_SRC) $(PY_TESTS) && black --check $(PY_SRC) $(PY_TESTS)

test:
	pytest -q --maxfail=1 --disable-warnings

# -------- Lambda manual invoke --------
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

# -------- Docker (alert-receiver) --------
docker-build:
	docker build -t $(IMAGE_NAME):$(IMAGE_TAG) ./alert-receiver

docker-run:
	docker run --rm -p 5000:5000 $(IMAGE_NAME):$(IMAGE_TAG)

# wymaga zainstalowanego trivy lokalnie
docker-scan:
	trivy image --ignore-unfixed --severity HIGH,CRITICAL $(IMAGE_NAME):$(IMAGE_TAG)

# -------- Kubernetes --------
k8s-apply:
	kubectl apply -f k8s/

k8s-delete:
	kubectl delete -f k8s/ || true

# -------- Repo hygiene --------
pre-commit-all:
	pre-commit run --all-files

# -------- Full local CI --------
ci-all:
	@echo "Running local CI: fmt → validate → lint → test → docker build → k8s lint(apply optional)"
	$(MAKE) fmt validate lint test docker-build
