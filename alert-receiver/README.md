# 🐍 Alert Receiver (Flask)

This is a simple Flask-based app that simulates receiving alerts from AWS services (e.g., via HTTP POST).  
Used to demonstrate containerization, HTTP integration, and basic Kubernetes deployment.

---

## 📁 Files

- `app.py` – Flask app that handles `/alert` POST requests
- `Dockerfile` – Builds the container
- `docker-compose.yml` – Runs the app locally
- `requirements.txt` – Python dependencies
- `.env.example` – (Optional) Environment config
- `k8s/deployment.yaml` – Example K8s deployment

---

## ▶️ Usage

### 🔧 Local with Docker

```bash
docker-compose up
```

App will be available at:
👉 http://localhost:5000/alert

🐍 Manually (dev mode)

```bash
python3 app.py
```

## 🔬 Purpose

This component is used in the AWS Security Alerting Pipeline as a simulated external alert consumer.
It can be replaced with any real system that accepts HTTP notifications (e.g., PagerDuty, SIEM, etc.).


