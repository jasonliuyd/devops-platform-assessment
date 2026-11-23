# AWS DevOps Platform Architecture

## 1. Architecture Overview

This design provides a shared CI/CD platform for 40 application teams running workloads on Amazon ECS, Amazon EKS, and AWS Lambda.

The goal is to make deployments more consistent and secure without forcing every team to use the same deployment method. Teams can continue to manage their applications, while the platform provides common workflows, security checks, artifact handling, and deployment controls.

The platform consists of four main areas:

- CI/CD Pipeline
- AWS Workload Deployment
- Monitoring and Rollback
- Security and Access Control

## 2. Layer 1 — CI/CD Delivery Pipeline

### Application Teams

Each team maintains its own GitHub repository, application code, and workload-specific configuration.

Teams are responsible for their application build requirements and tests. The platform provides shared workflows and security checks that can be reused across repositories.

### GitHub Actions

GitHub Actions is used to run the CI/CD pipeline.

The Platform Team maintains reusable workflows for common tasks such as building, testing, scanning, and deployment. Teams can use these workflows while adding steps required by their own applications.

This avoids maintaining completely different pipelines for every team, while still allowing differences between ECS, EKS, and Lambda workloads.

### Pipeline Validation

Before an application is deployed, the pipeline runs the required checks. Depending on the workload, these may include:

- Build and unit tests
- Code and dependency scanning
- Terraform validation and security checks
- Container image scanning using Trivy
- SBOM generation and artifact signing

If a mandatory check fails, the pipeline stops and the artifact is not promoted to the next stage.

### Artifact Management

Container images are stored in Amazon ECR.

Once an artifact passes the required checks, the same artifact is promoted through Development, Staging, and Production. It is not rebuilt separately for each environment, which helps avoid differences between the tested version and the version eventually deployed.

### Environment Promotion

The deployment process follows these stages:

**Development → Staging → Production**

Each stage provides an opportunity to validate the application before moving to the next environment. Production deployment is protected by approval and environment-level access controls.

## 3. Layer 2 — AWS Deployment Targets

The platform supports ECS, EKS, and Lambda. Each workload uses a deployment strategy suited to its runtime rather than forcing a single deployment method across all applications.

### Amazon ECS — Blue/Green Deployment

For ECS services, Blue/Green deployment can be used to run the new version alongside the current version.

The new version is validated before traffic is switched over. If the deployment causes problems, traffic can be returned to the previous version, provided the deployment and traffic-routing configuration support rollback.

### Amazon EKS — Canary Deployment

For EKS workloads, Canary deployment can be used to release a new version to a smaller portion of traffic first.

The rollout is monitored before more traffic is sent to the new version. This helps identify issues early without affecting all users at once.

Canary rollout and traffic control require an appropriate deployment and routing setup within the EKS environment.

### AWS Lambda — Weighted Traffic Shifting

Lambda supports versioned deployments using aliases and weighted traffic routing.

Traffic can be gradually directed to the new version while the existing version remains available. If the new version shows problems, traffic can be shifted back to the stable version.

The deployment strategy depends on the workload, but the same platform security and validation requirements apply to all three deployment targets.

## 4. Layer 3 — Monitoring, Audit & Rollback

### AWS CloudTrail

CloudTrail records AWS API activity, including actions performed by users, roles, and services.

These logs can be used to investigate changes, identify who performed an action, and provide audit evidence for deployment and infrastructure activities.

### Amazon CloudWatch

CloudWatch is used to monitor application and deployment health through logs, metrics, and alarms.

Depending on the application, monitoring may include:

- HTTP 5xx error rate
- Application latency
- Health check failures
- CPU and memory utilization
- Application-specific metrics

The monitoring thresholds should be defined based on each application's normal behavior and service requirements.

### Rollback

If a deployment fails its health checks or breaches configured monitoring thresholds, the rollout should stop and rollback should be initiated where supported.

The rollback method depends on the deployment type. ECS can return traffic to the previous task set, EKS can revert the rollout using its deployment mechanism, and Lambda can shift traffic back to the previous version.

Rollback behavior and thresholds need to be configured and tested for each workload before being relied on in Production.

## 5. Layer 4 — Security Foundation

Security is applied throughout the pipeline and deployment process. The platform avoids relying on shared long-lived credentials and uses separate permissions for different deployment responsibilities.

### GitHub OIDC

GitHub Actions uses OIDC federation to authenticate with AWS.

Instead of storing permanent AWS access keys in GitHub Secrets, the workflow requests an identity token. AWS validates the trusted GitHub identity and allows the workflow to assume an IAM role with temporary credentials.

The trust policy should restrict access to the intended repository and branch or environment.

### AWS IAM

IAM roles are used to control what the pipeline can access and which actions it can perform.

Permissions are scoped according to the workload and environment. Production deployment permissions are kept separate from development and staging access to reduce the risk of accidental or unauthorized changes.

### AWS Secrets Manager

Application secrets and credentials are stored in Secrets Manager rather than being hardcoded into repositories or workflow files.

Only the workloads or roles that need a secret should be allowed to retrieve it.

### AWS KMS

KMS is used to manage encryption keys for supported AWS services and stored data.

Encryption requirements should be applied to relevant resources, including secrets and storage, based on the platform's security requirements.

### AWS Account Separation

Development, Staging, and Production are separated into different AWS accounts.

This provides an additional boundary between environments and reduces the risk that a change or compromised credential in one environment can affect another.

## 6. Ownership & Responsibilities

### Platform Team

The Platform Team maintains shared workflows, security controls, and platform tools. It also manages improvements to the platform.

### Application Teams

Application Teams manage their own code, tests, configuration, and application health.

They use the shared workflows but can add steps based on their application requirements.

## 7. Scope & Assumptions

This repository is a reference design and proof of concept for the proposed DevOps platform.

It shows how the platform could work, including the CI/CD process, security controls, and deployment strategies. It is not a fully deployed AWS environment.

Some parts would still need to be configured and tested in AWS before they could be used in Production.
