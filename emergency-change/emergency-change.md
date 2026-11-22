# Emergency Change Workflow

## 1. Purpose

The emergency change process allows teams to release urgent production fixes while maintaining essential security, traceability, and operational controls.

Emergency changes must not become a permanent bypass for the standard delivery pipeline.

## 2. Emergency Change Criteria

The expedited release path may only be used for situations such as:

- Production service outage
- Critical security vulnerability
- Severe customer impact
- Urgent incident requiring immediate remediation

The incident must have a documented incident ID and justification.

## 3. Approval and Access

- Emergency changes require approval from an authorized incident approver.
- Production access must use a dedicated, least-privilege role.
- Access must be time-limited and revoked after the emergency.
- Emergency permissions must not grant unrestricted administrative access.

## 4. Minimum Required Checks

The emergency path may reduce non-essential waiting time but must retain minimum safety checks:

- Source code review or emergency reviewer approval
- Build validation
- Minimum critical tests
- Secret scanning
- Critical vulnerability scanning
- Artifact versioning and integrity verification

Security checks must not be silently disabled.

## 5. Emergency Deployment Process

1. Record the incident ID, impact, and change justification.
2. Obtain emergency approval.
3. Assume the restricted emergency deployment role.
4. Build and validate the fix.
5. Run the required minimum security and test checks.
6. Deploy the immutable artifact to production.
7. Monitor application health and rollback if necessary.
8. Revoke temporary access.
9. Record deployment and approval evidence.

## 6. Post-Incident Reconciliation

After the emergency release:

- Complete the normal review and documentation process.
- Review any temporarily reduced controls.
- Record the reason for expedited release.
- Complete missing tests or validations where appropriate.
- Conduct a post-incident review.
- Identify preventive actions to reduce future emergency releases.

## 7. Audit Evidence

The following evidence must be retained:

- Incident ID and justification
- Approver identity and approval timestamp
- Source commit
- Build and test results
- Security scan results
- Artifact version or digest
- Deployment timestamp and outcome
- Monitoring results
- Temporary access grant and revocation records
- Post-incident review
