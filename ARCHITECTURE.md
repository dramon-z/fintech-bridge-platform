# Payments Platform Architecture

## Overview

This platform processes cross-border payments from USDC to COP.

Transfers require a blockchain txhash verification before processing through vendors.

## Components

Payments API
Vendor abstraction layer
Mock blockchain validation
Infrastructure via Terraform


Componentes principales
Client
   |
   v
Load Balancer
   |
   v
Payments API (FastAPI container)
   |
   |---- TxHash Validation Service (mock)
   |
   |---- Vendor Router
            |--- vendorA
            |--- vendorB

Infraestructura:

Terraform
 ├── VPC
 ├── Subnets
 ├── Load Balancer
 ├── ECS / Kubernetes
 ├── Secrets Manager / SSM
 └── CloudWatch (logs + metrics)
## Vendor Extensibility

Vendors implement a common interface.

Adding a new vendor requires:

1. Implementing Vendor class
2. Registering in vendor_factory

No other changes required.

## Transfer Flow

Client -> API -> Validate txhash -> Vendor -> Response