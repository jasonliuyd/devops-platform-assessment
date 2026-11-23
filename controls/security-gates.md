# Security Gates and Controls

## 1. Purpose

Security checks are required in the shared CI/CD pipeline.

They check application code, dependencies, container images, and infrastructure before deployment.

The Platform Team maintains these checks. Application teams cannot bypass mandatory security controls through their own pipeline configuration.

## 2. Pipeline Security Gates

| Stage | Security Check | Tool | Failure Action |
|---|---|---|---|
| Source | Secret detection | Gitleaks | Fail if secrets are detected |
| Build | Unit tests | Application test framework | Fail if tests fail |
| Dependencies | Vulnerability scan | Trivy | Block based on vulnerability policy |
| Container | Image scan | Trivy | Block based on vulnerability policy |
| Infrastructure | IaC security scan | Checkov | Block policy violations |
| Artifact | SBOM generation | Syft | Generate software inventory |
| Artifact | Image signing | Cosign | Sign and verify artifacts |
| Production | Deployment approval | GitHub Environment | Require authorized approval |

## 3. Security Enforcement

The following controls must be enforced by the platform:

- Do not store secrets in source code or repository files.
- Use federated identity and short-lived credentials for Production access.
- Scan container images and application dependencies before Production deployment.
- Run security checks on infrastructure changes.
- Link Production artifacts to their source commit.
- Block releases with critical security findings unless an approved exception is in place.
- Require approval before Production deployment.
- Verify artifact signatures before deployment.

## 4. Vulnerability Policy

| Severity | Policy |
|---|---|
| Critical | Block release. Fix before Production unless an approved exception is in place. |
| High | Block release unless an approved exception is in place. |
| Medium | Track remediation with an owner and due date. |
| Low | Track through the normal backlog. |

Security exceptions must include:

- Business justification
- Risk assessment
- Responsible owner
- Approval record
- Expiry date

Expired exceptions are no longer valid.

## 5. Enforcement Model

Mandatory security checks are maintained in reusable workflows managed by the Platform Team.

Application teams can customize build commands, test commands, and deployment settings, but they cannot remove or skip mandatory security checks.

The same security requirements apply across ECS, EKS, and Lambda workloads.

Scanning depends on the workload:

- Container images are scanned using Trivy.
- Application dependencies and Lambda packages are checked for vulnerabilities.
- Infrastructure code is scanned using Checkov.

## 6. Evidence and Audit

Each pipeline run should retain the following evidence:

- Source commit SHA
- Workflow run ID
- Test results
- Security scan results
- SBOM
- Artifact version and digest
- Signature verification results
- Approval records
- Deployment status

Security reports, SBOMs, and verification results must be retained as release evidence.

The artifact digest must be linked to the deployment record so the deployed version can be traced back to its source code and build.

Evidence must be available for audits and incident investigations.

## 7. Ownership

**Platform Team**

- Maintains security policies and reusable workflows.
- Defines mandatory security checks.
- Manages security tools and exceptions.
- Reviews platform security metrics.

**Application Teams**

- Maintain application code and tests.
- Fix application vulnerabilities.
- Provide workload-specific configuration.
- Remain responsible for their application security.
