# Submodule Consumer Runbook

## Add as Submodule

```bash
git submodule add <PRIVATE_GIT_URL>/ai-dev-governance.git .governance/ai-dev-governance
git submodule update --init --recursive
```

## Pin to Release Tag

```bash
cd .governance/ai-dev-governance
git fetch --tags
git checkout v0.5.1
cd -
git add .governance/ai-dev-governance
git commit -m "Pin governance submodule to v0.5.1"
```

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
- Install RTK with `rtk init -g` or `rtk init -g --codex`, then verify with `rtk init --show`.
- For portable repo-local tracking, add `.rtk/` to `.gitignore`, install `scripts/rtk-local.sh` from `templates/RTK_LOCAL_WRAPPER_TEMPLATE.sh`, and keep the default database path at `./.rtk/history.db`.
- Capture RTK release evidence with `scripts/rtk-local.sh gain -p` and `scripts/rtk-local.sh discover`, or document a no-op result if no savings opportunities remain.
- Adopt board templates from `templates/` for packet, meeting, opportunity, and selection/composition reports.
- Use `runbooks/RTK_ADOPTION_RUNBOOK.md` plus `templates/AGENTS_RTK_SNIPPET_TEMPLATE.md`, `templates/RTK_INSTRUCTIONS_TEMPLATE.md`, and `templates/RTK_LOCAL_WRAPPER_TEMPLATE.sh` when repo-local RTK guidance is needed.
- If the consumer needs stricter project-local interpretation, place it in `docs/governance/amendments/` instead of editing the shared submodule.
- When using a local overlay, create `docs/governance/amendments/README.md` from `templates/GOVERNANCE_AMENDMENTS_README_TEMPLATE.md`.
- Run `scripts/validate_governance.sh` from the consumer root when possible so optional overlay checks run against `docs/governance/amendments/`.

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
