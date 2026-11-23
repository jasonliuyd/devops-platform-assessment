# Infrastructure Security Baseline

## 1. Purpose

Define the minimum security requirements for infrastructure managed by application teams.

Infrastructure changes must be reviewed and checked before deployment.

## 2. Terraform Security Controls

| Control | Requirement |
|---|---|
| S3 Storage | Block public access by default. |
| Encryption | Enable encryption at rest for supported resources. |
| Network | Avoid unrestricted access from `0.0.0.0/0` unless required. |
| IAM | Use least-privilege permissions. |
| Secrets | Do not store credentials or secrets in Terraform code. |
| Resource Protection | Review destructive changes before applying. |

## 3. Validation Gates

Infrastructure changes must pass the following checks before deployment:

- Terraform formatting check.
- Terraform configuration validation.
- Infrastructure security scanning.
- Review of high and critical security findings.
- Pull request review before Production deployment.

## 4. Exception Handling

Security exceptions must include:

- Business justification.
- Risk assessment.
- Assigned owner.
- Expiration date.
- Approval record.

Exceptions must be reviewed regularly and must not be used as permanent security bypasses.

## 5. Enforcement

Infrastructure security checks run in CI.

Production deployment must be blocked when mandatory security checks fail, unless an approved exception is in place.
