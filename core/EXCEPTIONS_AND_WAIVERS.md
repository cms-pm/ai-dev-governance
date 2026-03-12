# Exceptions and Waivers Protocol

## Purpose

This policy governs temporary deviations from core governance requirements.

## Mandatory Fields

Every exception request MUST include:

- unique ID
- policy clause reference
- business and technical rationale
- risk assessment
- compensating controls
- owner
- approver
- creation date
- expiry date
- closure criteria

## Rules

- Exceptions MUST be time-bound.
- Expired exceptions automatically fail governance checks.
- Exceptions MAY not remove accountable human approval requirements.
- Exceptions for security controls require security approver sign-off.

## Storage

Default location: `docs/governance/exceptions.yaml` (override via governance manifest).

## Review Cadence

- Active exceptions MUST be reviewed at least once per sprint.
- Release gates MUST fail when critical exceptions are expired or missing compensating controls.
