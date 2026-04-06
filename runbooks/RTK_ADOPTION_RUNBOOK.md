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
  - `templates/RTK_LOCAL_WRAPPER_TEMPLATE.sh`

## Portable Repo-Local Tracking Pattern

Use this pattern when you want RTK tracking to stay inside the consumer repository workspace, especially for sandboxed execution and checked-in release workflows.

1. Add `.rtk/` to the consumer repo `.gitignore`.
2. Copy `templates/RTK_LOCAL_WRAPPER_TEMPLATE.sh` to `scripts/rtk-local.sh`.
3. Make the wrapper executable with `chmod +x scripts/rtk-local.sh`.
4. Keep the default repo-local tracking path at `./.rtk/history.db`.

The wrapper sets `RTK_DB_PATH` to the repo-local database before invoking `rtk`.

Equivalent alternatives such as exporting `RTK_DB_PATH` directly or setting RTK config `tracking.database_path` are allowed, but the wrapper is the preferred portable pattern because it is easy to audit and share across teams.

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
- For evidence capture and sandbox-sensitive tracking, prefer the repo-local wrapper:

```bash
scripts/rtk-local.sh init --show
scripts/rtk-local.sh gain -p
scripts/rtk-local.sh discover
```

## Evidence Capture

Store the following under the release evidence path declared in the governance manifest:

```bash
scripts/rtk-local.sh init --show
scripts/rtk-local.sh gain -p
scripts/rtk-local.sh discover
```

- Direct `rtk init --show`, `rtk gain`, and `rtk discover` are still acceptable when repo-local tracking is not needed.
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
