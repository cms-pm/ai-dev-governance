# Phase 2 — Chunk Plans (Astaire as memory palace)

Precondition: Phase 1 gate signed off; `governance.yaml` declares `tooling/rtk`
and the graphify adapter contract is merged (SCN-1.5).

---

## SCN-2.1 — `governance-authoring` Astaire collection plugin

- **Scope.** Upstream PR to `cms-pm/astaire` adding
  `src/collections/governance_authoring.py`. Doc types: `core-policy`,
  `adapter-spec`, `contract-schema`, `template`, `runbook`,
  `compatibility-entry`, `changelog-entry`. Tag keys: `policy_area`, `version`,
  `status`. Scan rules cover `core/**`, `adapters/**`, `contracts/**`,
  `templates/**`, `runbooks/**`. Plugin honors `collectionStrategy` from this
  repo's `governance.yaml` (both `split` and `unified` shapes).
- **Acceptance IDs.** SCN-2.1-01.
- **Acceptance criteria.**
  - `uv run astaire scan --root <ai-dev-governance>` registers at least one
    document per doc type.
  - `uv run astaire query -c governance-authoring -t core-policy` returns the
    `core/` policy files.
  - Plugin unit tests pass in Astaire's test suite.
- **Validation method.** Automated — Astaire unit tests + integration scan
  against this repo.
- **Risks.** Collection naming collision with future Astaire collections
  (R-1). Mitigation: single registered name documented in adapter.
- **Rollback.** Revert upstream PR; scan would no longer register this repo.
- **Owner.** Accountable Delivery Lead.
- **Risk tier.** medium (upstream change to a published tool).
- **Atomic PR scope.** `SCN-2.1` (upstream repo).

---

## SCN-2.2 — Repo-local Astaire hooks

- **Scope.** Add `.claude/settings.json` with `UserPromptSubmit` →
  `uv run astaire startup --root "$(git rev-parse --show-toplevel)"` and
  `PostToolUse: Bash(git commit*)` → `uv run astaire scan --root ...`.
- **Acceptance IDs.** SCN-2.2-01.
- **Acceptance criteria.**
  - Hook fires on prompt submission and writes a log line confirming
    `astaire startup` ran.
  - Post-commit scan picks up a new planning artifact within one session.
  - Timeouts set to 10000ms so hooks never block agent flow.
- **Validation method.** Manual — trigger a session, inspect hook log; commit
  a test file and verify registration.
- **Risks.** Hook failure blocks prompts. Mitigation: `2>/dev/null || true`
  suffix so failures are non-fatal.
- **Rollback.** Delete hooks from `.claude/settings.json`.
- **Owner.** Accountable Delivery Lead.
- **Risk tier.** low.
- **Atomic PR scope.** `SCN-2.2`.

---

## SCN-2.3 — `raw/` corpus scaffolding and first ingest

- **Scope.** Create `raw/articles/`, `raw/papers/`, `raw/transcripts/`,
  `raw/notes/` with README describing conventions. Run first
  `uv run astaire ingest` against a curated subset of core methodology docs so
  L0 has non-empty content. Commit the resulting `db/memory_palace.db` (or a
  doc explaining where it lives — see risk note).
- **Acceptance IDs.** SCN-2.3-01.
- **Acceptance criteria.**
  - `raw/` tree exists with README.
  - `uv run astaire status` after first ingest reports non-zero claims and
    entities.
  - L0 summary contains references to `core/` policy names.
- **Validation method.** Manual review of L0 output.
- **Risks.** Whether to commit the binary SQLite DB is an open convention.
  Mitigation: default to not committing; document regeneration steps in a new
  `runbooks/ASTAIRE_BOOTSTRAP.md`.
- **Rollback.** Remove `raw/` and regenerate DB elsewhere.
- **Owner.** Methodology Steward.
- **Risk tier.** low.
- **Atomic PR scope.** `SCN-2.3`.

---

## SCN-2.4 — Release-evidence integration

- **Scope.** Update `runbooks/RELEASE_PROCESS.md` and `core/EVIDENCE_CONTRACT.md`
  (if SCN-1.6 has not already added this field) to require an L0 snapshot and
  `astaire lint` health report in each release bundle. Add a release script
  target that emits both.
- **Acceptance IDs.** SCN-2.4-01.
- **Acceptance criteria.**
  - `docs/releases/v0.6.0/l0-snapshot.md` present and matches live L0 at
    release tag cut.
  - `docs/releases/v0.6.0/health-report.md` present with zero blocking lint
    findings.
- **Validation method.** Automated — release script emits both; CI check on
  tagged releases.
- **Risks.** Evidence drift between L0 at release cut and post-cut changes.
  Mitigation: snapshot is immutable; any post-cut changes require a new release.
- **Rollback.** Revert runbook updates; release evidence fields become
  documentation-only until re-added.
- **Owner.** Release manager (held by Accountable Delivery Lead until a named
  role emerges).
- **Risk tier.** low.
- **Atomic PR scope.** `SCN-2.4`.
