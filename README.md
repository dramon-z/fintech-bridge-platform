# Payments API Platform

Prototype platform for a cross-border payments API that converts USDC → COP (Colombian Peso) using different vendor off-ramps.

The system validates that a blockchain deposit transaction exists and then routes the transfer to a selected vendor.

This repository demonstrates platform engineering practices, including:

- extensible vendor architecture
- observability (logging + metrics)
- infrastructure as code
- containerization
- Kubernetes deployment
- CI/CD pipelines
- DORA-style operational metrics


## Architecture

High level architecture:

```
Client
   |
   v
Payments API (FastAPI)
   |
   +----------------------+
   | Vendor Router        |
   | (Factory Pattern)    |
   +----------------------+
       |              |
       v              v
   Vendor A       Vendor B
       |
       v
Blockchain Validation (Mock)

Observability
   |
   +---- Logging
   +---- Prometheus Metrics
```
The API is designed to be vendor-agnostic, allowing new off-ramp providers to be added without modifying the core service. only change de file ``vendor/data.json``

``` json
{
  "vendors": {
    "vendorA": {
      "status": "success",
      "message": "Transfer processed via Vendor A"
    },
    "vendorB": {
      "status": "pending",
      "message": "Transfer pending via Vendor B"
    }
  },
  "default_response": {
    "status": "mocked_test",
    "message": "Vendor not recognized, returning generic mock response"
  }
}
```
## Repository Structure

```txt
fintech-bridge-platform
│
├── .github
│   └── workflows
│       ├── pipeline.yml
│       └── iac.ondemand.yml
├── api
│   ├── main.py
│   ├── blockchain_mock.py
│   ├── vendor_factory.py
|   ├── vendors
|   │   └── data.json
│   │
│   └── observability
│       ├── logger.py
│       └── metrics.py
│
├── docker
│   ├── Dockerfile
│   └── prometheus.yml
│
├── infra
│   └── terraform
│       ├── provider.tf
│       ├── main.tf
│       └── output.tf
│
├── k8s
│   ├── deployment.yaml
│   └── service.yaml
│
├── tests
│   ├── smoke_test.py
│   └── smoke_test2.py
│
├── docker-compose.yml
├── ARCHITECTURE.md
├── SOC2.md
└── README.md
```

## Application

The application is implemented using **FastAPI.**

Main endpoint:

```
POST /transfer
```

Example request:
```json
{
  "amount": 100,
  "vendor": "vendor_a",
  "txhash": "0xabc123"
}
```
Flow:

1. API receives transfer request
2. Blockchain transaction hash is validated
3. Vendor is selected through the vendor factory
4. Transfer request is sent to the vendor
5. Metrics and logs are generated

    
## Blockchain Validation

The system verifies the transaction hash using a mock blockchain validator:
```
api/blockchain_mock.py
```
This mock can later be replaced with:

* Blockchain indexer
* Custody platform integration

## Vendor Architecture

The system uses a Factory Pattern to support multiple off-ramp providers.
```
api/vendor_factory.py
```
This allows new vendors to be added with minimal changes.

Example extension:
```
api/vendors/data.json
```

``` json
{
  "vendors": {
    "vendorA": {
      "status": "success",
      "message": "Transfer processed via Vendor A"
    },
    "vendorB": {
      "status": "pending",
      "message": "Transfer pending via Vendor B"
    }
  },
  "default_response": {
    "status": "mocked_test",
    "message": "Vendor not recognized, returning generic mock response"
  }
}
```


## Observability

Observability is implemented using:

* structured logging
* Prometheus metrics

Located in:
```
api/observability
```
Components:
```
logger.py
metrics.py
```
Metrics exposed:
```
/metrics
```
Typical metrics include:

* request count
* payment success / failure
* vendor usage

## Running Locally
Using Docker Compose

Start the application:

```
python -m uvicorn api.main:app --reload --port 8000  
```
### Running with Docker

Build the container:

```
 docker build -t payments-api -f docker/Dockerfile .
```
Run container:
```
 docker run -p 8000:8000 payments-api uvicorn api.main:app --host 0.0.0.0 
```

### Testing

API will be available at:

http://localhost:8000/docs

Prometheus metrics:

http://localhost:8000/metrics

Test local
```
python -m pytest -vv -s --durations=5  --tb=short .\tests\smoke_test2.py
```

## Kubernetes Deployment

Kubernetes manifests are located in:
```
k8s/
```
Deploy application:
```
kubectl apply -f k8s/
```
Check resources:
```
kubectl get pods
kubectl get services
```
> Note: previously review the ``deployment.yml``, replace the ``$IMAGE`` variable with the location of the container image

## Infrastructure (Terraform)

Infrastructure as Code is defined in:
```
infra/terraform
```
Files:
```
provider.tf
main.tf
output.tf
```
Typical workflow:
```
terraform init
terraform plan
terraform apply
```
The Terraform configuration can be extended to provision:

* networking
* Kubernetes clusters
* load balancers
* monitoring infrastructure


## CI/CD

GitHub Actions workflows are located in:
```
.github/workflows
```
## Application Pipeline
```
pipeline.yml
```
Typical stages:

* Install dependencies
* Run tests
* Build container
* Validate application

## Infrastructure Pipeline
```
iac.ondemand.yml
```
Responsible for:

* Terraform validation
* Terraform plan
* Infrastructure deployment

## Tests

Basic smoke tests are provided in:
```
tests/
```

Run tests:
```
pytest tests
```
These tests validate that:

* the API starts correctly
* the transfer endpoint responds correctly

## Compliance Considerations

The repository includes documentation related to SOC2-style controls:
```
SOC2.md
```
Key aspects covered:

* audit logging
* infrastructure as code
* CI/CD controlled deployments
* observability

## Documentation

Additional architecture documentation:
```
ARCHITECTURE.md
```
This file explains design decisions and system components.+