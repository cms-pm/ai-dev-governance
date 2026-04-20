# Submodule Consumer Runbook

## Add as Submodule

```bash
git submodule add <PRIVATE_GIT_URL>/ai-dev-governance.git .governance/ai-dev-governance
git submodule update --init --recursive
```

Use `--recursive` from the start. Astaire is already nested under the
governance repo, and future tentacles may be added the same way, so consumers
should treat the governance module as a parent of sub-sub-modules rather than a
flat payload.

## Pin to Release Tag

```bash
cd .governance/ai-dev-governance
git fetch --tags
git checkout v0.6.0
cd -
git add .governance/ai-dev-governance
git commit -m "Pin governance submodule to v0.6.0"
```

Canonical consumer bootstrap branch for this release:

```bash
cd .governance/ai-dev-governance
git fetch origin
git checkout consumer/bootstrap-v0.6.0
cd -
git add .governance/ai-dev-governance
git commit -m "Pin governance submodule to consumer/bootstrap-v0.6.0"
```

Consumers should prefer the SemVer tag for stable pins. The
`consumer/bootstrap-*` branch exists as the human-readable bootstrap surface
that the corresponding GitHub release targets.

## Scheduled Bump

```bash
cd .governance/ai-dev-governance
git fetch --tags
git checkout <NEW_TAG>
cd -
git add .governance/ai-dev-governance
git commit -m "Bump governance submodule to <NEW_TAG>"
```

## Detached HEAD Recovery

```bash
cd .governance/ai-dev-governance
git checkout main
git pull --ff-only
```

## Rollback

```bash
git checkout <PREVIOUS_COMMIT_SHA> -- .governance/ai-dev-governance
git commit -m "Rollback governance submodule pin"
```

## Consumer Requirements

- Pin to tags, never track remote branches.
- Review changelog and migration notes before every bump.
- Use monthly or quarterly cadence from governance manifest.
- Configure `automation` and `boardReview` in governance manifest for strict baseline use.
- Configure `boardReview.selection` and `boardReview.composition` references.
- Strict Claude/Codex consumers must declare `tooling/rtk` in the governance manifest.
- Install RTK with `rtk init -g` or `rtk init -g --codex`, then verify with the provider-specific command:
  - Claude: `rtk init --show`
  - Codex: `rtk init --show --codex`
- For portable repo-local tracking, add `.rtk/` to `.gitignore`, install `scripts/rtk-local.sh` from `templates/RTK_LOCAL_WRAPPER_TEMPLATE.sh`, and keep the default database path at `./.rtk/history.db`.
- For Codex consumers using repo-local tracking or checked-in local reinforcement, also verify local `AGENTS.md` and local `RTK.md`, then prove one live RTK-tracked command through `scripts/rtk-local.sh gain --history` or equivalent database-mutation evidence.
- Capture RTK release evidence with `scripts/rtk-local.sh gain -p` and `scripts/rtk-local.sh discover`, or document a no-op result if no savings opportunities remain.
- Adopt board templates from `templates/` for packet, meeting, opportunity, and selection/composition reports.
- Use `runbooks/RTK_ADOPTION_RUNBOOK.md` plus `templates/AGENTS_RTK_SNIPPET_TEMPLATE.md`, `templates/RTK_INSTRUCTIONS_TEMPLATE.md`, and `templates/RTK_LOCAL_WRAPPER_TEMPLATE.sh` when repo-local RTK guidance is needed.
- If the consumer needs stricter project-local interpretation, place it in `docs/governance/amendments/` instead of editing the shared submodule.
- When using a local overlay, create `docs/governance/amendments/README.md` from `templates/GOVERNANCE_AMENDMENTS_README_TEMPLATE.md`.
- Run `scripts/validate_governance.sh` from the consumer root when possible so optional overlay checks run against `docs/governance/amendments/`.
- Expect the pinned release branch/tag to be a clean baseline. Consumer-local
  planning packets, release evidence, validation logs, and board records belong
  in the product repository, not in the governance submodule.

## Wire Astaire Access

Every consumer repo that pins `ai-dev-governance` MUST wire Astaire so agents
can read planning and release artifacts via the port-of-first-resort. This
section is pin-aware: the wrapper delegates to whichever commit of the Astaire
submodule `git submodule` has checked out, so a version bump automatically
picks up the new binary without touching the wrapper.

### Step 1 — Create the repo-local wrapper

From the consumer repo root:

```bash
mkdir -p .astaire
cat > .astaire/astaire << 'EOF'
#!/usr/bin/env bash
set -euo pipefail
REPO_ROOT="$(git rev-parse --show-toplevel)"
UV_CACHE_DIR_DEFAULT="${REPO_ROOT}/.astaire/.uv-cache"
if ! command -v uv >/dev/null 2>&1; then
  echo "[astaire-wrapper] FAIL: 'uv' is required but was not found on PATH." >&2
  exit 127
fi
mkdir -p "${UV_CACHE_DIR_DEFAULT}"
export UV_CACHE_DIR="${UV_CACHE_DIR:-${UV_CACHE_DIR_DEFAULT}}"
exec uv run --project "${REPO_ROOT}/.governance/ai-dev-governance/astaire" \
  astaire --db "${REPO_ROOT}/.astaire/memory_palace.db" "$@"
EOF
chmod +x .astaire/astaire
echo '.astaire/memory_palace.db' >> .gitignore
echo '.astaire/.uv-cache/' >> .gitignore
```

Adjust the submodule mount path if the governance submodule is not at
`.governance/ai-dev-governance`.

### Step 2 — Initialize and verify

```bash
.astaire/astaire startup --root .
.astaire/astaire status
```

`startup` runs `init → scan → sync → status`. A successful run writes
the first L0 projection to `.astaire/memory_palace.db`. The wrapper
also creates a repo-local `uv` cache at `.astaire/.uv-cache/` unless
`UV_CACHE_DIR` is already set.

### Step 3 — Inline the CLI snippet into AGENTS.md / CLAUDE.md

Copy `templates/ASTAIRE_CLI_SNIPPET.md` (relative to the submodule
mount) into the consumer's `AGENTS.md` or `CLAUDE.md`. The snippet
already uses `.astaire/astaire` as the wrapper path — no substitution
required when the wrapper lives at the default location.

```bash
cat .governance/ai-dev-governance/templates/ASTAIRE_CLI_SNIPPET.md \
  >> AGENTS.md          # or CLAUDE.md
```

Verify by running `scripts/validate_governance.sh` from the consumer
root; it checks that each strict-baseline provider adapter carries the
Astaire port-of-first-resort clause.

### Step 4 — Add post-commit hook (optional but recommended)

Add to `.claude/settings.json` (Claude consumers):

```json
"hooks": {
  "PostToolUse": [
    {
      "matcher": "Bash(git commit*)",
      "hooks": [
        {
          "type": "command",
          "command": ".astaire/astaire scan --root . 2>/dev/null || true",
          "timeout": 10000
        }
      ]
    }
  ]
}
```

This keeps the knowledge base current after every commit without
blocking agent flow on hook failure.

### Consumer requirements checklist

- [ ] `.astaire/astaire` wrapper executable at repo root.
- [ ] `.astaire/memory_palace.db` in `.gitignore`.
- [ ] `.astaire/.uv-cache/` in `.gitignore`.
- [ ] `AGENTS.md` / `CLAUDE.md` contains the inlined Astaire CLI snippet.
- [ ] `.astaire/astaire startup --root .` exits zero.
- [ ] `scripts/validate_governance.sh` passes (if present in consumer).

## Fork-Based Contribution Model (Recommended for Product Extensions)

When consuming a fast-moving upstream (for example, `paperclip`) while adding product-specific behavior:

1. Fork upstream repository into organization namespace.
2. Add upstream as a second remote in the fork (`upstream`).
3. Build feature branches in fork with one chunk/SCN scope per branch.
4. Pin consumer submodule to exact fork commit SHA in integration repo.
5. Open upstream backport PRs from fork branches for generally useful improvements.

This preserves:

- reproducible integration via pinned submodule SHA
- clean separation of product delta vs upstream baseline
- low-friction upstream contribution path

## Upstream Sync Cadence (Fork Maintainers)

```bash
cd <fork-worktree>
git fetch upstream
git checkout main
git rebase upstream/main
git push --force-with-lease origin main
```

After syncing fork `main`, update consumer submodule pointer in a dedicated chunk PR.

## Backport Procedure (Fork -> Upstream)

1. Ensure branch is atomic to one chunk/SCN.
2. Confirm tests/checks are green in fork.
3. Open upstream PR with:
   - motivation
   - scoped behavior change
   - validation evidence
4. Link upstream PR in consumer repo signoff/traceability notes.
