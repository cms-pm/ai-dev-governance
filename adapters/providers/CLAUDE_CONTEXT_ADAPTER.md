# Claude Context Adapter

## Purpose

Defines recommended context conventions for teams using Claude-style assistants.

## Conventions

- Keep main context files concise and link to governance docs instead of duplicating content.
- Keep provider-specific operational guidance in adapter docs, not in `core/`.
- Preserve auditable human approvals in repository artifacts.

## Required Mapping

- `core/*` policies map directly to project governance docs.
- Adapter-specific preferences must be declared in governance manifest under `adapters`.
