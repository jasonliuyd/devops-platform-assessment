# Platform Metrics & KPIs

## 1. Objectives

Platform metrics are used to measure delivery efficiency, platform reliability, security control effectiveness, and adoption across 40 application teams.

Metrics should help teams identify bottlenecks and improve delivery quality rather than encourage teams to focus on numbers at the expense of reliability.

## 2. Delivery Performance (DORA Metrics)

The platform tracks the following delivery metrics:

- Deployment Frequency: How frequently production deployments occur.
- Lead Time for Changes: Time from code commit to production deployment.
- Change Failure Rate: Percentage of production deployments that cause incidents, rollbacks, or hotfixes.
- Mean Time to Recovery (MTTR): Time required to restore service following a production incident.

These metrics are reviewed at platform and team level to identify areas for improvement.

## 3. Platform Reliability Metrics

- Pipeline success rate
- Pipeline execution duration
- Pipeline queue time
- Reusable workflow availability
- Failed deployment rate
- Rollback frequency

The Platform Team uses these metrics to identify shared pipeline failures and platform bottlenecks.

## 4. Security and Compliance Metrics

- Percentage of releases with successful security checks
- Percentage of production artifacts with verified signatures
- SBOM generation coverage
- Critical and high vulnerability remediation time
- Production deployment approval compliance
- Emergency change frequency
- Secret scanning coverage

Production releases must not bypass mandatory security controls without an approved emergency process.

## 5. Adoption Metrics

- Number of teams onboarded to reusable workflows
- Percentage of teams using approved pipeline templates
- Number of workloads migrated from legacy pipelines
- Number of teams using progressive delivery
- Team feedback and onboarding issues

Adoption metrics help the Platform Team identify migration blockers and improve the developer experience.

## 6. Data Collection

Metrics can be collected from multiple sources:

- GitHub Actions workflow execution data
- GitHub deployment and environment approval records
- AWS CloudTrail audit records
- Amazon CloudWatch application and deployment metrics
- Security scanning and SBOM workflow outputs

These data sources can be used to build dashboards for engineering leadership and platform operations.

## 7. Review and Improvement

Metrics are reviewed regularly by the Platform Team and engineering leadership.

The review focuses on:

- Identifying pipeline bottlenecks
- Improving deployment reliability
- Reducing recovery time
- Increasing adoption of standard workflows
- Improving security control effectiveness

Metrics must not be used to rank individual developers or encourage teams to increase deployment frequency at the expense of stability.

The goal is continuous improvement across the delivery platform.
