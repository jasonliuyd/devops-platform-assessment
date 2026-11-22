# Production Approval and Deployment Gates

## 1. Purpose

Prevent unauthorized or unvalidated changes from being deployed
to production environments.

## 2. Deployment Requirements

All production deployments must:

- Pass the required CI pipeline.
- Pass unit and integration tests.
- Pass dependency and security scanning.
- Generate an SBOM where applicable.
- Use a verified and immutable artifact.
- Deploy the same artifact promoted from Staging.
- Receive approval before production deployment.

## 3. Production Approval

Production deployments require approval from an authorized reviewer.

Approvers must not approve their own deployment when separation
of duties is required.

Approval must be recorded and auditable.

## 4. Deployment Permissions

- Production access must use a dedicated AWS IAM role.
- Permissions must follow the principle of least privilege.
- GitHub Actions must use OIDC federation.
- No long-lived AWS credentials may be stored in GitHub secrets.
- Production deployment permissions must be separated from non-production.

## 5. Mandatory Gates

Production deployment must be blocked if:

- Required tests fail.
- Security checks fail.
- Artifact signature verification fails.
- Required approval is missing.
- The deployment artifact cannot be verified.
- Required deployment evidence is unavailable.

## 6. Ownership

The Platform Team owns production deployment controls,
approval policies, and pipeline enforcement.

Application Teams own application readiness, test quality,
release validation, and deployment monitoring.
