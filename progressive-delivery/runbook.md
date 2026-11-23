# Progressive Delivery Runbook

## 1. Objective

This runbook describes how to monitor a progressive deployment, identify deployment issues, and roll back when the new version is unhealthy.

## 2. ECS Blue-Green Deployment

For ECS workloads:

- Blue is the current production version.
- Green is the new application version.
- Deploy the new version to Green while Blue continues serving production traffic.
- Run health checks and smoke tests against Green.
- Shift traffic to Green after validation.
- Monitor the new version during the release observation period.

If the new version causes issues, redirect traffic back to Blue.

## 3. EKS Canary Deployment

For EKS workloads, traffic is gradually shifted to the new version.

Example traffic progression:

- 5% Canary traffic
- 25% Canary traffic
- 50% Canary traffic
- 100% traffic after successful validation

At each stage, monitor application health, error rate, latency, and availability.

If the deployment fails to meet the defined health criteria, stop the rollout and return traffic to the stable version.

## 4. Deployment Health Thresholds

The following thresholds are examples and should be configured based on workload SLOs.

- HTTP 5xx error rate exceeds 5%.
- P95 latency exceeds 2 times the baseline.
- Health checks fail.
- Critical application errors are detected.

If a critical threshold is breached, stop the rollout and investigate the issue.

## 5. Rollback Procedure

Rollback is required when deployment health metrics exceed configured thresholds or critical validation fails.

1. Stop further traffic progression.
2. Redirect traffic to the last known stable version.
3. Verify application health and service availability.
4. Notify the application team.
5. Record the deployment failure and rollback evidence.
6. Investigate the issue before attempting another release.

The previous stable artifact must remain available to support rollback.

## 6. Database Change Considerations

Database changes must remain compatible with the current and new application versions during deployment.

Use the Expand-Migrate-Contract approach:

- **Expand:** Add new schema elements without removing existing ones.
- **Migrate:** Update application behavior and migrate data safely.
- **Contract:** Remove obsolete schema elements only after compatibility is confirmed.

Database changes must not rely on application rollback alone when the database schema is no longer compatible.

## 7. Monitoring and Ownership

Monitor deployment health through CloudWatch metrics, application health checks, and workload-specific monitoring tools.

**Platform Team:**
- Maintain deployment mechanisms and shared rollout controls.
- Provide standard rollback procedures.

**Application Teams:**
- Define application health indicators and service-level objectives.
- Validate application behavior during rollout.
- Confirm application readiness after deployment.
- Participate in investigation and recovery when rollback occurs.
