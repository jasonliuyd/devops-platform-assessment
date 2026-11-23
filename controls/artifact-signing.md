# Artifact Integrity and Signing Policy

## 1. Purpose

Ensure that artifacts deployed to Production are verified and have not been changed after they are built.

## 2. Artifact Requirements

- Each artifact must have a unique version.
- Container images should be referenced by immutable digests.
- Artifacts must not be rebuilt for each environment.
- The same artifact must be promoted from Development to Staging and Production.
- An SBOM must be generated for supported artifacts.

## 3. Signing

- Container images must be signed using Cosign.
- Keyless signing with GitHub OIDC should be used where supported.
- The signature must be linked to a trusted CI workflow.
- Signing records must be kept for later verification.

## 4. Verification

Before deploying to Production, the pipeline must:

- Verify the artifact signature.
- Check the artifact digest.
- Confirm that the signing identity belongs to an approved workflow.
- Reject artifacts that fail verification.

## 5. Enforcement

Artifact verification is required before Production deployment.

Application teams must not be able to bypass verification through their own pipeline configuration.

## 6. Ownership

**Platform Team**

Maintains the signing and verification standards.

**Application Teams**

Maintain application code and their build configuration.
