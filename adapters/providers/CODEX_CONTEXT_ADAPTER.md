# Codex Context Adapter

## Purpose

Defines recommended context conventions for teams using Codex-style assistants.

## Conventions

- Keep governance paths stable and referenced by absolute or repo-root relative paths.
- Keep provider-specific operational hints outside `core/`.
- Capture decision links in sign-offs using commit/PR references.
- For strict baseline projects, prefer shell-capable workflows that can be routed through RTK before falling back to native internal inspection tools.

## RTK Integration

- Strict baseline consumers using `providers/codex` MUST also declare `tooling/rtk`.
- Install and verify RTK with:
  - `rtk init -g --codex`
  - `rtk init --show --codex`
- `rtk init -g --codex` creates global `AGENTS.md` and `RTK.md` instructions. Teams SHOULD keep repo-local instructions compatible with those global rules and use the RTK templates in this repository when they need local reinforcement.
- When repo-local Codex reinforcement is desired, teams SHOULD check in local `AGENTS.md` plus local `RTK.md` and verify one live RTK-tracked command against the chosen tracking database.
- Prefer RTK-backed shell commands for high-volume reads, searches, listings, git, test, and CI output. Native internal tools remain allowed for narrow targeted inspection, but they SHOULD NOT be the default when a shell flow is available.
- Release evidence for strict Codex consumers MUST include Codex-specific RTK setup verification plus `rtk gain` and `rtk discover` output or a documented no-op result. When repo-local tracking is used, include live usage proof such as `rtk gain --history` after a repo-local RTK command.

## Required Mapping

- `core/*` policies map directly to project governance docs.
- Adapter-specific preferences must be declared in governance manifest under `adapters`.
- RTK-specific setup, exceptions, and evidence requirements map to `adapters/tooling/RTK_CONTEXT_ADAPTER.md`.
