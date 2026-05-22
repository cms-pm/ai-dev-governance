# Security Controls for AI-Assisted Development

## Purpose

This policy defines minimum security controls for AI-assisted coding workflows.

## Control Baseline

- Human review is mandatory before merge.
- Secrets MUST not be pasted into AI prompts.
- Prompt and context inputs MUST follow data classification policy.
- Generated code MUST pass security scanning and dependency checks.
- Third-party code patterns introduced by AI MUST be license reviewed.
- Build provenance and artifact integrity SHOULD be recorded.

## Required Checks

- SAST and dependency scanning in CI
- Secret scanning pre-merge and pre-release
- High/critical vulnerability gate before release
- Dependency lockfile and provenance verification (where supported)

## Data-transmitting adapters

Adapters that transmit repository content to an external model or service
are a higher-risk surface than local-only tooling. Consumers using such
adapters MUST configure them through a reviewed governance contract rather
than invoking them directly. Graphify is not an ADG-supported adapter.

## Incident Handling

- Security incidents tied to AI-assisted changes MUST be tagged in postmortems.
- Corrective controls MUST be codified into policy or adapters.
