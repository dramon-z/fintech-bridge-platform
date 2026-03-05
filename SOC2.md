# SOC2 Alignment

## Access Control

IAM roles restrict access to infrastructure components.

RBAC controls access to Kubernetes services.

## Encryption

All communications use TLS.

Secrets stored in AWS Secrets Manager.

## Audit Logging

All transfers and txhash validations are logged.

Logs are centralized in CloudWatch.

## Incident Response

Monitoring alerts are configured in Prometheus and CloudWatch.

Automated alerts notify engineers when failures occur.