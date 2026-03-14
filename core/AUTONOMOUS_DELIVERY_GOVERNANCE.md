# Autonomous Delivery Governance

## Purpose

Define a policy-driven automation state machine that minimizes human intervention for low and medium risk work while preserving strict quality gates.

Keywords `MUST`, `SHOULD`, and `MAY` are normative.

## Automation State Machine

Required lifecycle:

1. `ingest`
2. `plan`
3. `artifact-generation`
4. `implementation`
5. `validation`
6. `board-review`
7. `gate`
8. `release`

Transitions MUST fail closed when required artifacts are missing or checks are red.

## Deterministic Stop Rules

Execution MUST stop when any of the following are true:

- Required planning or TDR artifacts are missing.
- Validation checks fail.
- Required board artifacts are missing for high/critical work.
- Open critical board findings exist without approved exception.
- Required human approvals are missing for the assigned risk tier.

## Risk-Tiered Autonomy

| Tier | Typical Scope | Automation Behavior | Human Requirement | Board Requirement |
|---|---|---|---|---|
| low | localized low-risk change | auto-merge on green checks | none | no |
| medium | moderate scope, low blast radius | automated execution + merge gate | 1 reviewer | no |
| high | broad impact or hard-to-reverse change | automated execution, manual gate | chair signoff + reviewer | yes |
| critical | safety/security/data-integrity/runtime critical | automated execution with strict fail-closed gates | chair signoff + designated accountable approver | yes (mandatory) |

## Human Intervention Rules

Human intervention is required only for:

1. Initial and refresh board composition approval.
2. High/critical board outcomes.
3. Exception approvals and renewals.

All other paths SHOULD run with minimal manual operations under policy controls.

## Artifact-First Execution

Automation MUST emit machine-readable artifacts at each state boundary.

Minimum required structured artifacts:

- Board findings
- Board decisions
- Implementation handoff packet
- Risk-tier assignment record
- Validation status summary

## Release Gating

Release MUST be blocked when:

- unresolved critical findings exist and `criticalFindingsBlockRelease=true`
- required exception is missing or expired
- required checks fail

## Simulation Positioning

Expert-agent board personas are expert-informed simulations. They MUST not imply endorsement by real individuals.
