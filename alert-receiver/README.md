# 🐍 Alert Receiver (Flask)

This is a simple Flask-based app that simulates receiving alerts from AWS services (e.g., via HTTP POST).

It is used to demonstrate containerization and basic Kubernetes deployment.

## Files

- `main.py` – Flask app
- `Dockerfile` – Builds the container
- `docker-compose.yaml` – Runs the app locally with Docker
- `requirements.txt` – Python dependencies

## Usage

### Run with Docker

```bash
docker-compose up
```

App will be available at http://localhost:5000/alert.

Run manually (optional)
```bash
python3 main.py
```