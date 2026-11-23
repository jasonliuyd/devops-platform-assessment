# Progressive Delivery Strategy

## 1. Objective

Progressive delivery reduces deployment risk by gradually introducing new application versions to production.

Instead of releasing a new version to all users immediately, the platform validates application health during deployment and increases traffic only when the deployment is successful.

The platform supports different progressive delivery strategies based on workload type:

- Amazon ECS — Blue/Green Deployment
- Amazon EKS — Canary Deployment
- AWS Lambda — Weighted Traffic Shifting

---

## 2. Deployment Strategies

### 2.1 Amazon ECS — Blue/Green Deployment

Blue/Green deployment maintains two application environments:

- Blue — Current stable version
- Green — New application version

Deployment process:

1. Deploy the new version to the Green environment.
2. Run health checks and validation.
3. Route traffic to Green gradually or after validation, according to the configured deployment strategy.
4. Monitor application health and deployment metrics.
5. Complete deployment if all validation checks pass.
6. Roll back to Blue if deployment health fails.

Rollback:

The previous Blue version remains available during the deployment process and can be restored if the new version fails validation.

---

### 2.2 Amazon EKS — Canary Deployment

Canary deployment introduces a new version to a small percentage of production traffic before a full rollout.

Example rollout stages:

- 5% traffic — Initial validation
- 25% traffic — Expanded validation
- 50% traffic — Monitor application health
- 100% traffic — Complete rollout

At each stage, application health and deployment metrics are evaluated before proceeding.

Rollback:

If the canary version exceeds configured failure thresholds, traffic is returned to the previous stable version and the rollout is stopped.

---

### 2.3 AWS Lambda — Weighted Traffic Shifting

Lambda deployment uses versioned functions and weighted traffic shifting through Lambda aliases.

Example rollout stages:

- 10% traffic to the new version
- 50% traffic to the new version
- 100% traffic to the new version

The rollout proceeds only when health checks and monitoring metrics remain within acceptable thresholds.

Rollback:

Traffic is shifted back to the previous stable Lambda version when deployment validation fails.

---

## 3. Deployment Health & Rollback Thresholds

The platform uses automated monitoring to determine whether a release should continue or be rolled back.

Example thresholds:

| Metric | Rollback Condition |
|---|---|
| HTTP 5xx Error Rate | Greater than 5% |
| Application Latency | P95 latency exceeds 2x baseline |
| Health Checks | Critical health check failure |
| Deployment Status | Deployment fails or new version becomes unhealthy |

These thresholds are example defaults for the assessment. Production thresholds should be adjusted based on application baselines, traffic patterns, and service-level objectives.

Deployment monitoring uses Amazon CloudWatch metrics, alarms, and application health checks.

---

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

---

## 5. Database Change Strategy

Database changes must remain compatible with both the current and new application versions during progressive deployment.

The platform follows the Expand-and-Contract approach:

1. Expand — Add new schema or fields without breaking the current application.
2. Migrate — Update application logic and migrate data gradually if required.
3. Validate — Confirm the new application version works with the updated schema.
4. Contract — Remove obsolete schema only after the old application version is no longer required.

Destructive database changes must not be automatically reversed without validating data safety.

Database rollback may require a forward-fix migration or recovery procedure instead of simply reverting the application version.

---

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

---

## 7. Expected Outcome

Progressive delivery enables application teams to release changes with reduced production risk.

The platform provides consistent deployment safeguards while allowing ECS, EKS, and Lambda workloads to use their appropriate deployment strategies.

Automated health validation, controlled traffic progression, and rollback mechanisms help reduce deployment failures and improve service reliability.
