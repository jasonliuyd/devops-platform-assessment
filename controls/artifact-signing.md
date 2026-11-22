# Artifact Integrity and Signing Policy

## 1. Purpose

Ensure that artifacts deployed to production are verified,
traceable, and have not been tampered with after the build process.

## 2. Artifact Requirements

- Artifacts must have a unique version identifier.
- Container images should be referenced using immutable digests.
- Artifacts must not be rebuilt separately for each environment.
- The same artifact must be promoted from Development to Staging and Production.
- Software Bill of Materials (SBOM) must be generated for supported artifacts.

## 3. Signing

- Container images must be signed using Cosign.
- Signing should use keyless signing with GitHub OIDC where supported.
- Signing identity must be associated with the trusted CI workflow.
- Signing evidence must be retained for verification and audit purposes.

## 4. Verification

Before production deployment:

- Verify the artifact signature.
- Verify the artifact digest.
- Confirm the signing identity matches the approved workflow.
- Reject artifacts that fail verification.

## 5. Enforcement

Artifact verification is a mandatory production deployment gate.

Application teams cannot bypass artifact verification
through workload-specific pipeline configuration.

## 6. Ownership

The Platform Team owns signing and verification standards.

Application Teams own application source code and
workload-specific build configuration.
