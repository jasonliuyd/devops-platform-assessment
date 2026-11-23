# Container Security Policy

## Purpose

This policy defines the minimum security checks required before container images are deployed to Production.

## Image Security

- Container images must use trusted base images.
- Images must be scanned for known vulnerabilities.
- Critical vulnerabilities must be fixed before Production deployment.
- Base images and dependencies must be kept up to date.
- Production deployments should use image digests instead of mutable tags.

## Software Supply Chain

- Generate an SBOM for container images.
- SBOMs must include application dependencies and package versions.
- Container images must be signed before Production deployment.
- The pipeline must verify image signatures before deployment.

## CI/CD Enforcement

The pipeline should run the following steps:

1. Build the container image.
2. Scan the image using Trivy.
3. Generate an SBOM using Syft.
4. Sign the image using Cosign.
5. Verify the image signature before Production deployment.

## Vulnerability Handling

- Critical vulnerabilities must block Production deployment.
- High vulnerabilities must be reviewed and fixed based on risk.
- Exceptions must have a documented reason, an assigned owner, and an expiry date.

## Scope and Limitations

This policy defines the container security requirements for this assessment.

The scanning, SBOM generation, signing, and verification steps need to be configured in the CI/CD pipeline before they can be enforced.
