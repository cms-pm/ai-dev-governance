# Strict Baseline Profile

## Purpose

This profile is mandatory for production-bound projects and is the default organizational baseline.

## Overrides Relative to Core

- Ambiguity score gate: <= 0.10
- Confidence gate: >= 4.5
- Required human review: 2 reviewers for critical paths
- Hotfix backfill SLA: 24 hours
- Release requires green pre-merge checks and green release gate checks
- Board review is mandatory (weekly sprint critique, monthly accountability, and emergency lane)
- Open critical board findings block release unless approved exception exists
- Risk-tier autonomy policy is mandatory
- Expert-agent board selection records are mandatory
- Strict Claude/Codex consumers must enable `tooling/rtk` and retain RTK setup plus usage evidence for release

## Non-Weakening Rule

Project-level overlays may add stricter controls but may not relax this profile.
