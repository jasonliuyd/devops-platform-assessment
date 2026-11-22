# Progressive Delivery Strategy and Rollback Runbook

## 1. Purpose

Progressive delivery reduces deployment risk by gradually introducing application changes into production while monitoring application health.

The platform supports workload-specific deployment strategies for Amazon ECS and Amazon EKS.

## 2. Deployment Strategies

### Amazon ECS — Blue/Green Deployment

Blue/Green deployment maintains two application environments:

- Blue: Current production version.
- Green: New application version.

The new version is deployed to Green and validated before production traffic is shifted.

Traffic is gradually shifted to the new version after validation. If deployment health deteriorates, traffic is redirected to the previous stable version.

### Amazon EKS — Canary Deployment

Canary deployment introduces a new application version to a small percentage of production traffic.

The rollout gradually increases traffic when health checks and monitoring metrics remain within acceptable thresholds.

If metrics exceed defined thresholds, the rollout is paused or rolled back.

## 3. Deployment Validation

During progressive rollout, the platform monitors:

- Application error rate
- HTTP 5xx responses
- Response latency (p95)
- Pod or task health
- CPU and memory utilization
- Application-specific health checks

Example rollout stages:

- 5% traffic — Initial validation
- 25% traffic — Expanded validation
- 50% traffic — Intermediate validation
- 100% traffic — Full rollout

Progression between stages requires healthy metrics and successful validation.

## 4. Rollback Triggers

Rollback or rollout pause is triggered when:

- HTTP 5xx error rate exceeds 5%.
- p95 latency exceeds twice the established baseline.
- Application health checks fail.
- Critical application functionality is degraded.
- Container or pod health becomes unstable.

Thresholds are illustrative and must be adjusted based on application SLOs and baseline performance.

## 5. Rollback Procedure

1. Stop further traffic progression.
2. Confirm the deployment is unhealthy using monitoring metrics.
3. Redirect traffic to the previous stable version or roll back to the previous deployment.
4. Verify application health and service recovery.
5. Notify stakeholders and record the rollback event.
6. Investigate the failure before attempting another release.

## 6. Database Migration Safety

Database changes must support application compatibility during progressive deployment.

The platform recommends the Expand–Migrate–Contract approach:

- **Expand:** Add backward-compatible schema changes.
- **Migrate:** Deploy application changes and migrate data incrementally.
- **Contract:** Remove obsolete schema or fields only after old application versions are no longer running.

Destructive database changes must not be tied to an immediate application rollback.

## 7. Ownership

**Platform Team**

- Provides deployment templates and rollout guardrails.
- Defines monitoring and rollback mechanisms.
- Maintains progressive delivery standards.

**Application Teams**

- Define application health checks and SLOs.
- Validate application behavior during rollout.
- Own application-specific rollback readiness and database compatibility.
