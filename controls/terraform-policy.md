# Terraform Security Policy

## Purpose

This policy defines the minimum security requirements for AWS infrastructure provisioned through Terraform.

The objective is to detect misconfigurations before infrastructure changes are deployed.

## Mandatory Security Checks

Terraform code must pass the following checks before deployment:

- S3 buckets must not allow public access.
- S3 buckets must use encryption at rest.
- S3 buckets storing important artifacts should have versioning enabled.
- Infrastructure changes must be reviewed before production deployment.
- IAM policies must follow least privilege principles.
- Security groups must not expose unnecessary ports or unrestricted access.
- Infrastructure must be scanned using Checkov before deployment.

## Security Validation Pipeline

The Terraform validation pipeline performs the following checks:

1. Terraform formatting validation.
2. Terraform configuration validation.
3. Checkov security scanning.
4. Review of security findings.
5. Approval before applying changes to production.

## Handling Security Findings

- Critical and high-risk findings must be resolved before production deployment.
- Findings must not be bypassed without documented justification.
- Exceptions must include a reason, an owner, and an expiration date.
- Security exceptions must be reviewed periodically.

## Scope and Limitations

This policy is a reference implementation for the DevOps Platform Assessment.

It demonstrates infrastructure security controls using Terraform and Checkov. Actual AWS deployment, account configuration, and enforcement require environment-specific configuration.
