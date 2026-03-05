# Payments API Platform

Example infrastructure for a cross-border payments API.

Features

Containerized FastAPI
Extensible vendor architecture
Terraform infrastructure
CI/CD with GitHub Actions
Observability
SOC2 aligned design

Run locally

docker build -t payments-api .
docker run -p 8000:8000 payments-api



----

## Probar que funciona

Arranca tu API:

python -m uvicorn main:app --reload --port 8001

Luego abre:

http://localhost:8001/metrics

Verás algo como:

http_requests_total
transfer_success_total
transfer_fail_total
transfer_latency_seconds

## Test
 python -m pytest -vv -s --durations=5  --tb=short tests/