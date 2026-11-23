# Production Approval and Deployment Gates

## 1. Purpose

Prevent unauthorized or untested changes from being deployed to Production.

## 2. Deployment Requirements

All Production deployments must:

- Pass the required CI pipeline checks.
- Pass unit and integration tests.
- Pass dependency and security scans.
- Generate an SBOM where required.
- Use a verified artifact with an immutable reference.
- Promote the same artifact that was tested in Staging.
- Receive approval before deployment.

## 3. Production Approval

Production deployments must be approved by an authorized reviewer.

Where separation of duties is required, the person approving the deployment must not be the person who initiated it.

All approvals must be recorded for auditing.

## 4. Deployment Permissions

- Use a dedicated AWS IAM role for Production deployment.
- Follow the principle of least privilege.
- Use OIDC federation for GitHub Actions authentication.
- Do not store long-lived AWS credentials in GitHub Secrets.
- Keep Production permissions separate from non-production environments.

## 5. Mandatory Gates

Production deployment must be blocked if:

- Required tests fail.
- Security checks fail.
- Artifact signature verification fails.
- Required approval is missing.
- The artifact cannot be verified.
- Required deployment evidence is missing.

## 6. Ownership

**Platform Team**

Maintains production deployment controls, approval policies, and pipeline enforcement.

**Application Teams**

Responsible for application readiness, test quality, release validation, and monitoring after deployment.
