# Autonomous Delivery Operations Runbook

## Purpose

Operational playbook for running risk-tiered autonomous implementation with minimal human intervention.

## State Machine

`ingest -> plan -> artifact-generation -> implementation -> validation -> board-review -> gate -> release`

## Required Inputs

- Governance manifest with `automation` configured
- Planning artifacts with risk-tier assignment
- TDR artifacts with acceptance IDs
- Board review artifacts for high/critical tiers

## Tier Operations

- Low: run full automated path, auto-merge on green checks.
- Medium: run full automated path, require one reviewer at gate.
- High: run automated path + mandatory board-review artifacts + chair signoff.
- Critical: run automated path + mandatory board-review artifacts + chair and accountable approver signoff.

## Stop Conditions

Stop and fail closed when:

- required artifacts missing,
- validation checks fail,
- required signoffs missing,
- unresolved critical board findings exist without approved exception.

## Required Structured Outputs

- board finding records
- board decision records
- implementation handoff record
- transition status log per state
