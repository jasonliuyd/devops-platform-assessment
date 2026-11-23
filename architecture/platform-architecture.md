# AWS DevOps Platform Architecture

## 1. Architecture Overview

This architecture proposes a centralized AWS DevOps delivery platform designed to support 40 application teams using different workload types, including Amazon ECS, Amazon EKS, and AWS Lambda.

The platform standardizes CI/CD workflows, security validation, artifact management, environment promotion, monitoring, and auditability while allowing application teams to retain ownership of their applications.

The architecture is divided into four layers:

- CI/CD Delivery Pipeline
- AWS Deployment Targets
- Monitoring, Audit & Rollback
- Security Foundation

---

## 2. Layer 1 — CI/CD Delivery Pipeline

### Application Teams

Forty application teams maintain their own GitHub repositories containing application source code and workload-specific configurations.

Teams remain responsible for their application code, testing, and application requirements.

### CI/CD Platform

GitHub Actions provides the CI/CD execution platform using centrally maintained and reusable workflows.

The Platform Team maintains common pipeline standards and reusable workflow templates, allowing teams to adopt consistent delivery practices without requiring every application to use the same build process.

### Security Gates

Automated validation is performed before artifacts are approved for deployment.

The pipeline includes:

- Build and unit tests
- SAST and dependency scanning
- Terraform and Infrastructure-as-Code validation
- Container security scanning
- SBOM generation and artifact signing

Failed mandatory checks prevent the pipeline from progressing to the next stage.

### Artifact Repository

Amazon Elastic Container Registry (ECR) stores versioned container images.

Artifacts are verified and signed before promotion. The same validated artifact is promoted across environments instead of rebuilding separately for each environment.

### Environment Promotion

The platform follows a controlled promotion process:

**Development → Staging → Production**

Production deployment requires approval before the release proceeds.

Environment protection and deployment permissions help prevent unauthorized production releases.

---

## 3. Layer 2 — AWS Deployment Targets

The platform supports different AWS workload types while maintaining common security and delivery standards.

### Amazon ECS — Blue/Green Deployment

ECS workloads use Blue/Green deployment to introduce a new application version while maintaining the existing version as a fallback.

Traffic can be shifted to the new version after validation, with rollback available if deployment health deteriorates.

### Amazon EKS — Canary Deployment

EKS workloads use Canary deployment to expose a new version to a limited portion of traffic before expanding the rollout.

Deployment health and application metrics are evaluated before proceeding with the rollout.

### AWS Lambda — Weighted Traffic Shifting

Lambda workloads use versioned deployments and weighted traffic shifting to gradually direct traffic to a new version.

If validation fails, traffic can be shifted back to the previous stable version.

Each deployment strategy is selected according to the workload type, while common platform controls remain consistent.

---

## 4. Layer 3 — Monitoring, Audit & Rollback

### AWS CloudTrail

CloudTrail records AWS API activity and provides audit records for AWS account activity, access, and deployment-related operations.

These records support investigation, traceability, and compliance requirements.

### Amazon CloudWatch

CloudWatch collects application and deployment metrics, logs, and alerts.

Deployment health can be evaluated using indicators such as:

- HTTP 5xx error rate
- Application latency
- Health check failures
- Resource utilization
- Deployment-specific health metrics

### Automated Rollback

Automated rollback is triggered when deployment health checks fail or configured deployment metrics breach defined thresholds.

The deployment process stops or reverses the rollout and restores the previous stable version where the workload's deployment mechanism supports rollback.

Rollback thresholds are configurable based on workload requirements.

---

## 5. Layer 4 — Security Foundation

Security controls apply across all layers of the platform.

### GitHub OIDC — Federated Identity

GitHub Actions authenticates to AWS using OpenID Connect (OIDC) federation.

This avoids the need to store long-lived AWS access keys in GitHub repositories or pipeline secrets.

### AWS IAM — Least Privilege Roles

IAM roles provide scoped permissions for pipeline and deployment activities.

Permissions are separated by workload, environment, and deployment responsibility to reduce unnecessary access.

### AWS Secrets Manager — Secret Management

Application and deployment secrets are stored and retrieved securely through Secrets Manager rather than hardcoded into source code or pipeline files.

### AWS KMS — Encryption

AWS Key Management Service (KMS) provides encryption key management for supported data and secrets.

### Separate AWS Accounts

Development, Staging, and Production environments are isolated using separate AWS accounts.

This separation reduces the impact of compromised credentials, accidental changes, and deployment failures across environments.

---

## 6. Ownership & Responsibilities

### Platform Team

- Maintain centralized reusable CI/CD workflows.
- Define mandatory security and pipeline controls.
- Maintain deployment standards and platform guardrails.
- Manage pipeline reliability and platform metrics.
- Improve reusable templates based on team feedback.

### Application Teams

- Maintain application source code.
- Define application build and test requirements.
- Manage application configurations.
- Define health checks and deployment validation requirements.
- Own application reliability and operational support.

---

## 7. Design Principles

- Standardize delivery controls without forcing identical workload deployment methods.
- Build and verify artifacts once, then promote the same artifacts across environments.
- Use federated identity and short-lived AWS credentials.
- Enforce security validation before production deployment.
- Require production approval and controlled deployment access.
- Support progressive delivery and rollback for critical workloads.
- Maintain application ownership while providing a standardized paved road.
- Ensure deployment activity is traceable and auditable.

---

## 8. Scope & Assumptions

This architecture represents a proposed reference design for the assessment.

It demonstrates the intended platform architecture, security controls, deployment strategies, and operational capabilities.

The diagram and design do not represent a fully deployed AWS production environment. AWS integrations, deployment automation, monitoring thresholds, and rollback mechanisms would require implementation, workload-specific configuration, and validation before production use.
