# Board Review Operations Runbook

## Purpose

Operational procedure for running board review governance in consuming repositories.

## Required Inputs

- Governance manifest with `boardReview` configured
- Current risk log
- Current traceability and evidence status
- Prior meeting action closure report
- Current approved board composition and member profiles

## Operating Cadence

1. Weekly sprint critique during active delivery.
2. Monthly accountability review.
3. Incident review within 24 hours of critical governance breach.
4. Quarterly composition refresh (or incident-triggered refresh).

## Board Selection and Composition Workflow

1. Define seat roles and required lenses.
2. Prepare candidate longlist and corpus sources.
3. Score candidates (`Prominence`, `CorpusDepth`, `RoleFit`, `EvidenceAccessibility`, `RecencyRelevance`).
4. Propose composition with primary and alternate per seat.
5. Run conflict checks and coverage checks.
6. Obtain human chair approval.
7. Publish composition artifacts.

## Execution Steps

1. Create packet from `templates/BOARD_REVIEW_PACKET_TEMPLATE.md`.
2. If the consumer repository has a local overlay in `docs/governance/amendments/`, load any project-local board addenda after the upstream template.
3. Run meeting using `templates/BOARD_REVIEW_MEETING_TEMPLATE.md`.
4. Update opportunity register using `templates/BOARD_OPPORTUNITY_REGISTER_TEMPLATE.md`.
5. Emit structured findings and decision artifacts.
6. Emit implementation handoff artifact for adopted actions.
7. Integrate adopted actions into planning/TDR/risk artifacts.
8. Update validation traceability and closure evidence.

## Release Gate Implication

- Release is blocked if unresolved critical board findings exist and no approved exception covers them.

## Artifacts Checklist

- Board packet
- Meeting record
- Opportunity register update
- Structured finding records
- Structured decision records
- Structured implementation handoff
- Risk update
- Traceability update
- Sign-off record
- Composition approval record
