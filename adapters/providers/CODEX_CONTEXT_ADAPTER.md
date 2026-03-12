# Codex Context Adapter

## Purpose

Defines recommended context conventions for teams using Codex-style assistants.

## Conventions

- Keep governance paths stable and referenced by absolute or repo-root relative paths.
- Keep provider-specific operational hints outside `core/`.
- Capture decision links in sign-offs using commit/PR references.

## Required Mapping

- `core/*` policies map directly to project governance docs.
- Adapter-specific preferences must be declared in governance manifest under `adapters`.
