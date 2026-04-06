# RTK Instructions Template

Use this snippet for repo-local RTK reinforcement when teams need a checked-in instruction file that complements RTK's global install.

```md
# RTK Local Instructions

- Prefer shell-first workflows for broad repo exploration, git inspection, test runs, linting, and container status.
- Use RTK-backed commands such as `rtk ls`, `rtk read`, `rtk grep`, `rtk git status`, `rtk git diff`, `rtk pytest`, and `rtk docker ps` when the shell path is available.
- Prefer `scripts/rtk-local.sh` when collecting RTK evidence or when repo-local tracking matters; it should set `RTK_DB_PATH` to `./.rtk/history.db`.
- Keep native internal inspection tools for narrow targeted lookups, not for bulk exploration.
- Preserve RTK evidence for release readiness: `rtk init --show`, `rtk gain`, and `rtk discover`.
```
