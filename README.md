# AWS DevOps Platform Assessment

## 1. Project Overview

This project proposes a standardized DevOps delivery platform for 40 application teams running workloads across Amazon ECS, Amazon EKS, and AWS Lambda.

The objective is to improve release consistency, security, deployment reliability, auditability, and developer experience while allowing application teams to retain ownership of their applications and workload-specific delivery requirements.

The platform adopts reusable CI/CD workflows and automated security controls, with a paved-road approach rather than forcing every application into the same build and deployment process.

## 2. Platform Objectives

- Standardize CI/CD workflows across application teams.
- Enforce security and quality controls throughout the delivery lifecycle.
- Promote the same verified artifact across environments.
- Reduce excessive production access through federated identity and least privilege.
- Support progressive delivery and controlled rollback.
- Provide an auditable emergency change process.
- Improve delivery performance through measurable platform KPIs.
- Migrate teams gradually without a big-bang transition.

## 3. Architecture

**Cloud Provider: AWS**

The proposed platform uses GitHub Actions for CI/CD orchestration and AWS OIDC federation for secure, short-lived credentials.

Key services and technologies include:

- GitHub Actions — CI/CD workflows
- AWS IAM and OIDC — federated authentication and access control
- Amazon ECR — container artifact storage
- Amazon ECS, Amazon EKS, AWS Lambda — workload deployment targets
- AWS Secrets Manager and AWS KMS — secrets and encryption
- Amazon CloudWatch — monitoring and operational metrics
- AWS CloudTrail — audit records
- Terraform — Infrastructure as Code
- Trivy — vulnerability scanning
- SBOM generation and artifact signing — software supply chain security

## 4. Assessment Deliverables

### Task 1 — Platform Design
Reusable pipeline architecture, artifact management, environment promotion, identity boundaries, and application team extension points.

### Task 2 — Controls as Code
Automated testing, infrastructure security scanning, secrets scanning, dependency scanning, SBOM generation, artifact integrity, and production approval gates.

### Task 3 — Progressive Delivery
Deployment strategies for ECS and EKS, deployment health validation, traffic shifting, monitoring thresholds, rollback procedures, and database change considerations.

### Task 4 — Emergency Change
Controlled expedited release process with documented justification, restricted access, minimum validation requirements, monitoring, and post-incident reconciliation.

### Task 5 — Metrics and KPIs
DORA metrics, CI/CD performance, platform adoption, security control compliance, and guardrails against metric gaming.

### Task 6 — Migration and Adoption
Phased migration plan for 40 application teams, including pilot teams, onboarding, support, and gradual legacy pipeline retirement.

## 5. Security Principles

- Short-lived credentials through federated authentication.
- Least-privilege access to AWS environments.
- Separation of development, staging, and production.
- Mandatory security and quality gates.
- Immutable artifact promotion.
- Production approval and deployment restrictions.
- Centralized audit and deployment evidence.
- Controlled emergency access with expiry.

## 6. Validation and Limitations

This repository is an assessment reference design and proof of concept.

GitHub Actions workflows and security checks are included to demonstrate selected automation controls. AWS infrastructure deployment and workload-specific progressive delivery require environment configuration, AWS credentials through OIDC, application workloads, and additional integration testing.

The design does not claim to have deployed or operated a production AWS platform.

## 7. Ownership Model

**Platform Team**

- Maintains shared workflows and platform guardrails.
- Defines security and deployment standards.
- Manages platform integrations and reliability.
- Provides onboarding documentation and support.

**Application Teams**

- Own application code and testing.
- Maintain build and runtime configuration.
- Define health checks and service objectives.
- Operate and support their workloads.

## 8. Repository Structure

- `architecture/` — platform architecture and design
- `.github/workflows/` — GitHub Actions automation
- `controls/` — security and compliance controls
- `progressive-delivery/` — rollout and rollback strategy
- `emergency-change/` — emergency release workflow
- `metrics/` — KPI and measurement strategy
- `migration/` — adoption and migration plan
- `evidence/` — validation and assessment evidence

## 9. Expected Outcomes

- Consistent delivery controls across 40 application teams.
- Improved visibility into releases and security posture.
- Reduced reliance on manual production processes.
- Safer deployments with controlled progressive rollout.
- Improved audit readiness and operational accountability.
- Gradual platform adoption with reduced migration risk.
