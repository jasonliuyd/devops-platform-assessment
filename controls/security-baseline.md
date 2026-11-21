Infrastructure Security Baseline
1. Purpose
Define minimum security requirements for infrastructure provisioning across application teams. Infrastructure changes must be reviewed and validated before they are deployed.
2. Terraform Security Controls
Control	Requirement
S3 Storage	Block public access by default
Encryption	Enable encryption at rest for supported resources
Network	Avoid unrestricted ingress from 0.0.0.0/0
IAM	Apply least-privilege permissions
Secrets	Never store credentials or secrets in Terraform code
Resource Protection	Review destructive changes before applying
3. Validation Gates
Infrastructure changes must pass the following checks before deployment:
* Terraform format validation
* Terraform configuration validation
* IaC security scanning
* Review of high and critical security findings
* Pull request review before production deployment
4. Exception Handling
Security exceptions must include:
* Business justification
* Risk assessment
* Named owner
* Expiration date
* Approval record
Exceptions must be reviewed and must not become permanent security bypasses.
5. Enforcement
Security validation is performed during CI. Production deployment must not proceed when mandatory security controls fail, unless an authorized and documented exception is approved.
