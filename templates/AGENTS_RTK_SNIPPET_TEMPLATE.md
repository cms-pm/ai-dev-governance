# AGENTS.md RTK Snippet

Copy the following into a repo-local `AGENTS.md` when you need local reinforcement on top of RTK's global setup:

```md
@RTK.md

When a task can be handled through shell-visible inspection, search, git, test, lint, package, or container commands, prefer the RTK-backed shell path instead of high-token internal inspection tools.

Use targeted internal tools only when they are clearly more precise or when RTK cannot intercept the workflow.

Capture `rtk init --show`, `rtk gain`, and `rtk discover` outputs in release evidence for strict Claude/Codex changes.
```
