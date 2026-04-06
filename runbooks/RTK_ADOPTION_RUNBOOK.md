# RTK Adoption Runbook

## Purpose

Standardize RTK rollout for strict Claude and Codex consumers so shell-visible commands are compressed before they enter model context.

## When This Is Required

- Required for strict baseline consumers that use `providers/claude`.
- Required for strict baseline consumers that use `providers/codex`.
- Optional for other consumers unless a stricter local policy adopts it.

## Install RTK

Choose one installation path and keep it pinned through normal workstation management:

```bash
brew install rtk
```

```bash
curl -fsSL https://raw.githubusercontent.com/rtk-ai/rtk/refs/heads/master/install.sh | sh
```

```bash
cargo install --git https://github.com/rtk-ai/rtk
```

Verify the binary:

```bash
rtk --version
rtk gain
```

## Claude Code Setup

```bash
rtk init -g
rtk init --show
```

- Restart Claude Code after setup.
- RTK rewrites Bash-visible commands before execution, so shell-driven `git`, `rg`, `cat`, `ls`, test, and container workflows should be the default for broad exploration and validation.

## Codex Setup

```bash
rtk init -g --codex
rtk init --show
```

- Restart Codex after setup.
- RTK writes global `AGENTS.md` and `RTK.md` instructions under `~/.codex/`; keep any repo-local instructions compatible with those global rules.
- For repo-local reinforcement, start from:
  - `templates/AGENTS_RTK_SNIPPET_TEMPLATE.md`
  - `templates/RTK_INSTRUCTIONS_TEMPLATE.md`

## Recommended Command Patterns

Use shell or explicit `rtk` commands for high-token workflows:

```bash
rtk ls
rtk read path/to/file
rtk grep "pattern" src
rtk git status
rtk git diff
rtk pytest
rtk docker ps
```

- Narrow built-in inspection tools remain acceptable for precise lookups, but broad exploration should stay on RTK-visible shell paths.

## Evidence Capture

Store the following under the release evidence path declared in the governance manifest:

```bash
rtk init --show
rtk gain
rtk discover
```

- Keep the `rtk gain` snapshot for adoption and trend evidence.
- Keep the `rtk discover` snapshot to show whether shell flows are still bypassing RTK.
- If `rtk discover` reports no additional opportunities, record that no-op result instead of fabricating savings activity.

## Exceptions and Recovery

- If a command must bypass RTK for correctness or tool compatibility, document the command, reason, and review window.
- If RTK is partially disabled through config exclusions, record the exclusions in release evidence or the exceptions registry.
- To remove global setup:

```bash
rtk init -g --uninstall
rtk init -g --codex --uninstall
```
