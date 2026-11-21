Platform Architecture & Pipeline Flow
1. Architecture Overview
The platform is designed to support 40 application teams using a centralized, reusable CI/CD model while preserving application ownership and workload flexibility.
Each team maintains its own source code repository. GitHub Actions consumes centrally maintained, versioned reusable workflows provided by the Platform Team.
The platform standardizes security controls, deployment approvals, artifact management, and audit evidence. Workload-specific build and deployment configurations remain configurable.
2. High-Level Pipeline Flow
The standard delivery flow is:
1. Application team pushes code to GitHub.
2. GitHub Actions triggers the reusable CI/CD workflow.
3. The pipeline authenticates to AWS using GitHub OIDC federation.
4. The application is built and automated tests are executed.
5. Security and compliance checks are performed.
6. A versioned artifact is produced, verified, and published.
7. The artifact is deployed to the Development environment.
8. Validation is performed before promoting the same artifact to Staging.
9. Production deployment requires an approved release.
10. Progressive delivery is performed for critical workloads.
11. Monitoring validates deployment health and triggers rollback when defined thresholds are breached.
3. Shared Pipeline Model
The Platform Team maintains centrally managed reusable workflow templates.
Application teams consume the templates through their own GitHub Actions workflows and provide workload-specific inputs such as:
* Build commands and runtime versions
* Unit and integration test commands
* Application configuration
* Health check endpoints
* Deployment parameters
Mandatory security and deployment controls cannot be removed through team-level configuration.
Reusable workflows are version-controlled. Teams use approved template versions, and updates are introduced through a controlled upgrade process.
4. Artifact Management
Container-based applications are packaged as Docker images and stored in Amazon Elastic Container Registry (ECR).
Artifacts are versioned and immutable. Image tags should identify a release or commit, and deployment references should use the image digest where practical.
The same verified artifact is promoted across Development, Staging, and Production. Artifacts are not rebuilt separately for each environment.
Lambda workloads support deployment packages or container images, depending on the workload implementation.
5. Environment Promotion
The platform uses three environments:
* Development: Initial deployment and functional validation.
* Staging: Pre-production verification and release validation.
* Production: Controlled release to end users.
Promotion between environments is controlled by automated validation and environment protection rules.
Production deployment requires approval through GitHub Environment protection rules and the corresponding AWS deployment role.
Production accounts are isolated from non-production accounts to reduce the impact of credential misuse and deployment errors.
6. AWS Workload Deployment
The platform supports different workload types:
* Amazon ECS: Containerized applications deployed using a controlled ECS deployment strategy.
* Amazon EKS: Kubernetes workloads deployed using approved deployment templates and progressive delivery controls.
* AWS Lambda: Serverless applications deployed using versioned packages or container images, with controlled traffic shifting where applicable.
The platform provides common delivery controls while allowing deployment mechanisms to differ based on workload type.
7. Ownership Model
Platform Team owns:
* Reusable CI/CD workflow templates
* Pipeline security controls
* AWS role and permission standards
* Artifact integrity requirements
* Deployment guardrails
* Platform metrics and pipeline reliability
Application Teams own:
* Application source code
* Application testing
* Build-specific configuration
* Runtime and application configuration
* Health checks and service-level objectives
* Application behavior and operational support
8. Auditability
Deployment activities must provide traceable evidence, including:
* Source commit and repository
* Workflow execution details
* Test and security scan results
* Artifact version and digest
* Approver identity
* Deployment environment and timestamp
* Deployment outcome
* Rollback activity, if applicable
Audit records are retained centrally using AWS-native audit and monitoring services, including AWS CloudTrail and Amazon CloudWatch, together with GitHub workflow records.
