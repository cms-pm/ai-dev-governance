# Codex Context Adapter

## Purpose

Defines recommended context conventions for teams using Codex-style assistants.

## Conventions

- Keep governance paths stable and referenced by absolute or repo-root relative paths.
- Keep provider-specific operational hints outside `core/`.
- Capture decision links in sign-offs using commit/PR references.
- For strict baseline projects, prefer shell-capable workflows that can be routed through RTK before falling back to native internal inspection tools.

## Astaire Integration (port-of-first-resort)

- Strict baseline Codex consumers MUST treat Astaire as the
  port-of-first-resort for planning and implementation artifacts.
- The Astaire CLI surface (see `runbooks/ASTAIRE_ACCESS.md`) MUST be
  loaded into the agent's working context at session start —
  typically by inlining `templates/ASTAIRE_CLI_SNIPPET.md` into the
  consumer's `AGENTS.md` or equivalent.
- Before invoking native file-inspection tools on any
  `docs/planning/**`, `docs/releases/**`, board artifact, or
  governance core policy, the agent MUST first query Astaire via the
  repo-local wrapper (for example, `.astaire/astaire query ...` or
  `.astaire/astaire context ...`).
- Direct native-tool reads are permitted only when Astaire has no
  projection for the target, or when the read is in immediate service
  of an edit on that file.
- Release evidence for strict Codex consumers MUST include an Astaire
  L0 snapshot and `astaire lint` health report (see
  `core/EVIDENCE_CONTRACT.md`).

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
