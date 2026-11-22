# Container Security Policy

## Purpose

This policy defines the minimum security requirements for container images before they are deployed to production.

## Image Security

- Container images must use trusted base images.
- Images must be scanned for known vulnerabilities.
- Critical vulnerabilities must be resolved before production deployment.
- Base images and dependencies should be regularly updated.
- Production deployments should use immutable image digests instead of mutable tags where possible.

## Software Supply Chain

- Generate a Software Bill of Materials (SBOM) for container images.
- SBOMs must identify application dependencies and package versions.
- Container images should be cryptographically signed before production deployment.
- Production deployment pipelines should verify image signatures.

## CI/CD Enforcement

The pipeline should perform the following checks:

1. Build the container image.
2. Scan the image for vulnerabilities using Trivy.
3. Generate an SBOM using Syft.
4. Sign the image using Cosign.
5. Verify the image signature before production deployment.

## Vulnerability Handling

- Critical vulnerabilities must block production releases.
- High vulnerabilities must be reviewed and remediated according to risk.
- Exceptions require documented justification, an owner, and an expiry date.

## Scope and Limitations

This policy defines the intended container security controls for the assessment.

Actual image scanning, SBOM generation, signing, and signature verification must be implemented in the CI/CD pipeline.
