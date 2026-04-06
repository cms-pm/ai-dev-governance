# RTK Context Adapter

## Purpose

Defines token-governance guardrails for teams using RTK to compress shell-visible command output before it reaches Claude or Codex context.

## Applicability

- Strict baseline consumers that declare `providers/claude` or `providers/codex` MUST also declare `tooling/rtk`.
- RTK is a tooling adapter layered alongside provider adapters; it does not replace `providers/claude` or `providers/codex`.

## Required Setup

- Install RTK using an approved distribution path such as Homebrew, the upstream install script, Cargo git install, or a pinned prebuilt binary.
- Claude Code setup:
  - `rtk init -g`
  - `rtk init --show`
- Codex setup:
  - `rtk init -g --codex`
  - `rtk init --show`
- Restart the AI tool after setup so the hook or global instructions are reloaded.

## Operating Rules

- Use shell-first workflows for high-volume repository inspection, git, test, lint, package, and container commands whenever the workflow is available in Bash.
- Prefer commands RTK already rewrites or supports directly, including `git`, `gh`, `rg`, `grep`, `cat`, `head`, `tail`, `ls`, `pytest`, `cargo test`, `npm test`, `docker`, and `kubectl`.
- Claude built-in `Read`, `Grep`, and `Glob` style tools remain allowed for narrow targeted inspection, but they SHOULD NOT be the default for broad repo exploration because RTK cannot rewrite them.
- Codex internal inspection tools remain allowed for narrow targeted inspection, but shell or explicit `rtk` commands SHOULD be the default when a shell-capable path exists.
- Commands already using `rtk`, heredocs, and commands intentionally excluded through RTK config may pass through unchanged; any sustained exclusions require documented rationale.

## Release Evidence

- Save `rtk init --show` output as setup verification.
- Save `rtk gain` output as token-savings evidence.
- Save `rtk discover` output as missed-opportunity evidence, or record a documented no-op result when no additional opportunities are identified.
- If RTK excludes specific commands through config, record the excluded commands and rationale in release evidence or the exceptions registry.

## Required Mapping

- Declare `tooling/rtk` in the governance manifest `adapters` list.
- Map RTK release evidence into the release artifact path declared in the governance manifest.
- Use `runbooks/RTK_ADOPTION_RUNBOOK.md` for bootstrap and `templates/AGENTS_RTK_SNIPPET_TEMPLATE.md` plus `templates/RTK_INSTRUCTIONS_TEMPLATE.md` when repo-local instruction overlays are needed.
