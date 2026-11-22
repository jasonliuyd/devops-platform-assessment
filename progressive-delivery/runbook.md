# Progressive Delivery Strategy

## 1. Objective

Progressive delivery reduces deployment risk by gradually exposing new application versions to users.

Instead of releasing a new version to all users immediately, the platform gradually increases traffic while monitoring application health and performance.

If deployment metrics exceed defined failure thresholds, the release must be stopped and rolled back.

## 2. ECS Blue-Green Deployment

For ECS workloads, the platform uses a Blue-Green deployment strategy.

- Blue represents the current production version.
- Green represents the new application version.
- The new version is deployed to Green while Blue continues serving production traffic.
- Green is validated using health checks and smoke tests.
- Traffic is shifted to Green after validation.
- Blue remains available during the release observation period.

If the new deployment causes issues, traffic is redirected back to Blue.

## 3. EKS Canary Deployment

For EKS workloads, the platform uses Canary deployment.

The new version initially receives a small percentage of production traffic.

Example traffic progression:

- 5% Canary traffic
- 25% Canary traffic
- 50% Canary traffic
- 100% traffic after successful validation

At each stage, the platform monitors application health, error rate, latency, and availability.

If the deployment fails to meet the defined health criteria, the rollout is stopped and traffic is returned to the stable version.

## 4. Deployment Health Thresholds

The following thresholds are illustrative and should be configurable based on workload SLOs.

- HTTP 5xx error rate exceeds 5%.
- P95 latency exceeds 2 times the baseline.
- Health checks fail.
- Critical application errors are detected.

If any critical threshold is breached, the deployment must stop progressing.

## 5. Rollback Strategy

Rollback is triggered when deployment health metrics exceed configured thresholds or critical validation fails.

The rollback process:

1. Stop further traffic progression.
2. Redirect traffic to the last known stable version.
3. Verify service health.
4. Notify the application team.
5. Record the deployment failure and rollback evidence.

The previous stable artifact must remain available to support rollback.

## 6. Database Change Considerations

Database changes must follow backward-compatible migration practices.

The platform recommends the Expand-Migrate-Contract approach:

- Expand: Add new schema elements without removing existing ones.
- Migrate: Update application behavior and migrate data safely.
- Contract: Remove obsolete schema elements only after compatibility is confirmed.

Database changes must not depend on an application rollback that would be incompatible with the current database schema.

## 7. Monitoring and Ownership

The platform monitors deployment health through CloudWatch metrics, application health checks, and workload-specific observability tools.

The Platform Team owns deployment mechanisms and shared rollout guardrails.

Application Teams own application health indicators, service-level objectives, application validation, and release decisions.
