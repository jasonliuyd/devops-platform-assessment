# Progressive Delivery Strategy

## 1. Objective

Progressive delivery reduces deployment risk by gradually introducing new application versions to Production.

Instead of releasing a new version to all users immediately, the platform checks application health during deployment and increases traffic only when the new version is performing well.

Different workloads use different deployment strategies:

- Amazon ECS — Blue/Green Deployment
- Amazon EKS — Canary Deployment
- AWS Lambda — Weighted Traffic Shifting

## 2. Deployment Strategies

### 2.1 Amazon ECS — Blue/Green Deployment

Blue/Green deployment maintains two application environments:

- Blue — Current stable version
- Green — New application version

Deployment process:

1. Deploy the new version to the Green environment.
2. Run health checks and validation.
3. Shift traffic to the new version based on the configured deployment strategy.
4. Monitor application health and deployment metrics.
5. Complete the deployment if all validation checks pass.
6. Roll back to Blue if the new version fails validation.

Rollback:

The previous Blue version remains available during the deployment process and can be restored if the new version fails validation.

### 2.2 Amazon EKS — Canary Deployment

Canary deployment introduces a new version to a small percentage of production traffic before a full rollout.

Example rollout stages:

- 5% traffic — Initial validation
- 25% traffic — Expanded validation
- 50% traffic — Monitor application health
- 100% traffic — Complete rollout

Traffic shifting is managed through the configured ingress, traffic management, or progressive delivery components.

At each stage, application health and deployment metrics are checked before proceeding.

Rollback:

If the canary version exceeds configured failure thresholds, traffic is returned to the previous stable version and the rollout is stopped.

### 2.3 AWS Lambda — Weighted Traffic Shifting

Lambda deployment uses versioned functions and weighted traffic shifting through Lambda aliases.

Example rollout stages:

- 10% traffic to the new version
- 50% traffic to the new version
- 100% traffic to the new version

The rollout proceeds only when health checks and monitoring metrics remain within acceptable thresholds.

Rollback:

Traffic is shifted back to the previous stable Lambda version when deployment validation fails.

## 3. Deployment Health & Rollback Thresholds

The platform uses monitoring to determine whether a release should continue or be rolled back.

Example thresholds:

| Metric | Rollback Condition |
|---|---|
| HTTP 5xx Error Rate | Greater than 5% |
| Application Latency | P95 latency exceeds 2x baseline |
| Health Checks | Critical health check failure |
| Deployment Status | Deployment fails or new version becomes unhealthy |

These thresholds are example values for this assessment. Production thresholds should be configured based on application baselines, traffic patterns, and service-level objectives.

Deployment monitoring uses Amazon CloudWatch metrics, alarms, and application health checks.

## 4. Deployment Decision Process

### Continue Deployment

The rollout proceeds to the next traffic stage when:

- Health checks pass.
- Error rate remains within the configured threshold.
- Application latency remains acceptable.
- No critical deployment alarms are triggered.

### Stop and Roll Back

The rollout stops and rollback is initiated when:

- Critical health checks fail.
- Error rate exceeds the configured threshold.
- Application latency breaches the configured limit.
- Deployment alarms indicate application instability.

The previous stable version is restored where supported by the deployment mechanism.

## 5. Database Change Strategy

Database changes must remain compatible with both the current and new application versions during progressive deployment.

The platform follows the Expand-and-Contract approach:

1. Expand — Add new schema or fields without breaking the current application.
2. Migrate — Update application logic and migrate data gradually if required.
3. Validate — Confirm the new application version works with the updated schema.
4. Contract — Remove obsolete schema only after the old application version is no longer required.

Destructive database changes must not be automatically reversed without validating data safety.

Database rollback may require a forward-fix migration or recovery procedure instead of simply reverting the application version.

## 6. Responsibilities

### Platform Team

- Maintain progressive delivery templates.
- Provide standard deployment and rollback mechanisms.
- Define configurable monitoring and health check requirements.
- Ensure deployment evidence is collected.

### Application Teams

- Define application health checks.
- Configure workload-specific deployment parameters.
- Define application metrics and service-level objectives.
- Validate application behavior after deployment.
- Participate in incident response when rollback occurs.

## 7. Expected Outcome

Progressive delivery allows application teams to release changes with lower production risk.

The platform provides common deployment safeguards while allowing ECS, EKS, and Lambda workloads to use their appropriate deployment strategies.

Health checks, controlled traffic shifting, and rollback mechanisms help reduce deployment failures and improve service reliability.
