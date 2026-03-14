# Board Review Operations Runbook

## Purpose

Operational procedure for running board review governance in consuming repositories.

## Required Inputs

- Governance manifest with `boardReview` configured
- Current risk log
- Current traceability and evidence status
- Prior meeting action closure report

## Operating Cadence

1. Weekly sprint critique during active delivery.
2. Monthly accountability review.
3. Incident review within 24 hours of critical governance breach.

## Execution Steps

1. Create packet from `templates/BOARD_REVIEW_PACKET_TEMPLATE.md`.
2. Run meeting using `templates/BOARD_REVIEW_MEETING_TEMPLATE.md`.
3. Update opportunity register using `templates/BOARD_OPPORTUNITY_REGISTER_TEMPLATE.md`.
4. Integrate adopted actions into planning/TDR/risk artifacts.
5. Update validation traceability and closure evidence.

## Release Gate Implication

- Release is blocked if unresolved critical board findings exist and no approved exception covers them.

## Artifacts Checklist

- Board packet
- Meeting record
- Opportunity register update
- Risk update
- Traceability update
- Sign-off record
