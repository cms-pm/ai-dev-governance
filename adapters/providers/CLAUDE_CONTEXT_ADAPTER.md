# Claude Context Adapter

## Purpose

Defines recommended context conventions for teams using Claude-style assistants.

## Conventions

- Keep main context files concise and link to governance docs instead of duplicating content.
- Keep provider-specific operational guidance in adapter docs, not in `core/`.
- Preserve auditable human approvals in repository artifacts.
- For strict baseline projects, use shell-first inspection and validation flows so RTK can compress Bash-visible command output before it reaches Claude context.

## RTK Integration

- Strict baseline consumers using `providers/claude` MUST also declare `tooling/rtk`.
- Install and verify RTK with:
  - `rtk init -g`
  - `rtk init --show`
- Prefer Bash-visible workflows for high-volume reads, searches, listings, git, test, and CI commands because Claude's hook can rewrite them to `rtk ...`.
- Claude built-in tools such as `Read`, `Grep`, and `Glob` are allowed for narrow targeted inspection, but they do not benefit from RTK hook rewriting and SHOULD NOT be the default for broad repo exploration.
- Release evidence for strict Claude consumers MUST include RTK setup verification plus `rtk gain` and `rtk discover` output or a documented no-op result.

## Required Mapping

- `core/*` policies map directly to project governance docs.
- Adapter-specific preferences must be declared in governance manifest under `adapters`.
- RTK-specific setup, exceptions, and evidence requirements map to `adapters/tooling/RTK_CONTEXT_ADAPTER.md`.
