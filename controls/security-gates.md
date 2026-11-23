# Security Gates and Controls

## 1. Purpose

Security gates are mandatory checks within the shared CI/CD pipeline.
They help ensure that application code, infrastructure, dependencies,
and container images meet the platform security requirements before deployment.

Security checks are centrally maintained by the Platform Team.
Application teams cannot bypass mandatory security controls through
their own pipeline configuration.

## 2. Pipeline Security Gates

| Stage | Security Control | Tool | Failure Action |
|---|---|---|---|
| Source | Secret detection | Gitleaks | Fail pipeline if secrets are detected |
| Build | Unit tests | Application test framework | Fail pipeline if tests fail |
| Dependencies | Dependency vulnerability scan | Trivy | Block critical vulnerabilities |
| Container | Container image scan | Trivy | Block critical vulnerabilities |
| Infrastructure | IaC security scan | Checkov | Block policy violations |
| Artifact | SBOM generation | Syft | Generate software inventory |
| Artifact | Image signing | Cosign | Require signature before production |
| Production | Approval | GitHub Environment | Require authorized approval |

## 3. Security Enforcement

The following controls are mandatory:

- Secrets must not be stored in source code or repository files.
- Production access must use federated identity with short-lived credentials.
- Container images must be scanned before production deployment.
- Infrastructure changes must pass security policy checks.
- Production artifacts must be traceable to their source commit.
- Critical security findings must block promotion to Production.
- Production deployment requires an authorized approval.

## 4. Vulnerability Policy

| Severity | Policy |
|---|---|
| Critical | Block release. Remediation required before production |
| High | Block release unless an approved exception exists |
| Medium | Remediation tracked with an assigned owner and due date |
| Low | Remediation tracked through normal backlog |

Security exceptions must include:

- Business justification
- Risk assessment
- Responsible owner
- Approval
- Expiry date

Expired exceptions are no longer valid.

## 5. Enforcement Model

Mandatory security gates are implemented in centrally maintained reusable workflows.

Application teams may customize build commands, test commands, and deployment configuration, but mandatory security checks cannot be removed or skipped.

The platform enforces controls consistently across ECS, EKS, and Lambda workloads.

## 6. Evidence and Audit

Each pipeline execution should retain:

- Source commit SHA
- Workflow run ID
- Test results
- Security scan results
- SBOM
- Artifact version and digest
- Approval records
- Deployment status

Evidence is linked to the release to support auditing, incident investigation, and compliance reviews.

## 7. Ownership

**Platform Team**

- Maintains security policies and reusable workflows.
- Defines mandatory security gates.
- Manages approved tooling and exceptions.
- Reviews platform security metrics.

**Application Teams**

- Maintain application code and tests.
- Remediate application vulnerabilities.
- Provide workload-specific configuration.
- Maintain application security ownership.
