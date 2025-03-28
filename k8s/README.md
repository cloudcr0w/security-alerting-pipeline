# ☸️ Kubernetes Deployment – Alert Receiver

This directory contains a simple Kubernetes deployment for the Flask-based alert receiver.

## Files

- `deployment.yaml` – Defines:
  - A `Deployment` with 1 replica of the `alert-receiver` container
  - A `Service` of type `NodePort` exposing the app on port 80 → 5000

## How to use

Make sure your image `alert-receiver:latest` is available (locally or in a registry).

Then apply the deployment:

```bash
kubectl apply -f deployment.yaml
```

To access the app (e.g., using minikube):
```bash
minikube service alert-receiver-service
```
This is a minimal K8s setup to demonstrate how a containerized alert receiver could be deployed in a real cluster.