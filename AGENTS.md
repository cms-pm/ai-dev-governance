@RTK.md

When a task can be handled through shell-visible inspection, search, git, test,
lint, package, or container commands, prefer the RTK-backed shell path instead
of high-token internal inspection tools.

Use targeted internal tools only when they are clearly more precise or when RTK
cannot intercept the workflow.

Prefer `scripts/rtk-local.sh` for RTK evidence capture and other shell-visible
workflows that should keep RTK tracking under `./.rtk/history.db`.

For Codex repos, keep this local `AGENTS.md` checked in so repo-local RTK
reinforcement survives cleanup and onboarding.

Capture `rtk init --show --codex`, `rtk gain`, and `rtk discover` outputs in
release evidence for strict Codex changes.
