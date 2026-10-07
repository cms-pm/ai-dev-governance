---
phase: 12
stage_produced: plan
---

# Phase 12 — Chunk Plans (Launch Readiness)

Precondition: `main` at `8ab5331` (Astaire repin to v0.6.2, release
`v1.2.3`). Phase 11 is deferred (pool Q2); its branch is preserved as
`archive/SCN-11.0`. Carry-forward risks R-8.2-02, R-8.2-05, R-9-04,
R-9-05, R-10-02..04 are inherited unchanged, plus R-11-04, R-11-06,
R-11-07, R-11-10, R-11-11 from the deferred phase.

Cross-repo rule: Astaire changes are made in the standalone Astaire
checkout against `cms-pm/astaire`, never from ADG's `astaire/` submodule.
ADG consumes them only via a submodule repin.

---

## SCN-12.0 — Bootstrap

- **Scope.** Pool (`pool_questions/phase-12-launch-readiness.md`), this
  chunk plan, `phase-12-risks.md`, `phase-12-todo.md`, traceability rows,
  pending sign-off row. Astaire scan + lint.
- **Acceptance IDs.** SCN-12.0-01 (chunk plan), SCN-12.0-02 (pool),
  SCN-12.0-03 (risks), SCN-12.0-04 (TO-DO), SCN-12.0-05 (Astaire ingest
  verified; `query --tag phase=12` returns four artifacts).
- **Risk tier.** Low. **Validation.** `astaire scan` + `lint` 0 errors.

## SCN-12.1 — Stranded-work rescue (push-only)

- **Scope.** Push archive branches for every ADG/Astaire commit not on a
  remote: consumer-nested Astaire test-card commits, consumer-nested ADG
  v0.7.5 test-card docs, Astaire local `dev`, ADG `SCN-11.0` and
  `SCN-8.3.1`. Record refs in `docs/validation/scn-12.1/archive-refs.md`.
- **Acceptance IDs.** SCN-12.1-01 (five archive refs on remotes, SHAs
  match source), SCN-12.1-02 (`git log --branches --not --remotes` empty
  in ADG and Astaire checkouts).
- **Risk tier.** Low (additive refs only).
- **Validation.** `git ls-remote origin 'refs/heads/archive/*'`.

## SCN-12.2 — Licence + community files

- **Scope.** `LICENSE` → MIT (all prior tags relicensed; note in
  `CHANGELOG.md` and `README.md`). Add `CONTRIBUTING.md`, `SECURITY.md`,
  `CITATION.cff`.
- **Acceptance IDs.** SCN-12.2-01 (GitHub `licenseInfo.spdxId == MIT`),
  SCN-12.2-02 (relicensing note present), SCN-12.2-03 (community files
  present; `CITATION.cff` parses as YAML with `version`).
- **Risk tier.** Medium (legal surface). **Validation.**
  `gh repo view --json licenseInfo` after merge.

## SCN-12.3 — Phase 11 fix salvage

- **Scope.** Cherry-pick `06b1558` (R-11-08 fail-closed tentacle check);
  fix R-11-09 (guard check-1 `pass`); cherry-pick `a074761`
  (`docs/releases/v1.2.1/` evidence). Phase 11 deferral note in
  `docs/planning/phase-12-risks.md` (carry-forward table).
- **Acceptance IDs.** SCN-12.3-01 (consumer without tentacle → exit 1
  with an explicit FAIL), SCN-12.3-02 (consumer without wrapper prints no
  `[PASS]` for the wrapper), SCN-12.3-03 (healthy consumer still exit 0),
  SCN-12.3-04 (v1.2.1 evidence on `main`).
- **Risk tier.** Medium (validator behaviour). **Validation.** Planted-
  violation runs against scratch consumers bootstrapped by
  `scripts/bootstrap_project.sh`; logs under `docs/validation/scn-12.3/`.

## SCN-12.4 — Release-record hygiene + issue triage

- **Scope.** `runbooks/COMPATIBILITY_MATRIX.md` rows for v0.7.1, v1.2.0,
  v1.2.1, v1.2.2; `CHANGELOG.md` `[1.2.2]` section; back-fill GitHub
  Release v1.2.1. Verify and close #3; triage #1 (`post-launch`).
- **Acceptance IDs.** SCN-12.4-01 (every tag ≥ v1.0.0 has a matrix row),
  SCN-12.4-02 (every tag ≥ v1.2.0 has a CHANGELOG section and a GitHub
  Release), SCN-12.4-03 (#3 closed with evidence), SCN-12.4-04 (#1
  triaged).
- **Risk tier.** Low. **Validation.** Script diffing `git tag` against
  matrix rows, CHANGELOG headings and `gh release list`.

## SCN-12.5 — Astaire test-card forward-port (tracked in `cms-pm/astaire`)

- **Scope.** Port the three archived commits onto Astaire `main`
  (v0.6.2) with their tests; release Astaire v0.6.3; back-fill GitHub
  Release v0.6.2; add repo topics.
- **Acceptance IDs.** SCN-12.5-01 (PR merged, links the archive branch),
  SCN-12.5-02 (`uv run pytest` green incl. ported tests), SCN-12.5-03
  (GitHub Releases v0.6.2 and v0.6.3 exist).
- **Risk tier.** Medium (see R-12-03).

## SCN-12.6 — Test-card docs, README positioning, metadata

- **Scope.** Port the test-card read-pattern guidance (`runbooks/
  ASTAIRE_ACCESS.md`, `CLAUDE.md`) from `archive/cockpit-v0.7.5-test-card`.
  README: plain pitch, badges, who-for/not-for, quickstart first,
  vendor-neutral first screen, link to the guide. Root `AGENTS.md`.
  Repo topics (pool Q8).
- **Acceptance IDs.** SCN-12.6-01 (test-card guidance on `main`),
  SCN-12.6-02 (README first screen free of vendor names and of L0/
  tentacle jargon), SCN-12.6-03 (`AGENTS.md` present), SCN-12.6-04
  (topics set).
- **Risk tier.** Low.

## SCN-12.7 — Release v1.3.0 + book cross-check + sign-off

- **Scope.** Repin `astaire` to v0.6.3; bump `VERSION`, example manifest,
  fixtures, and the repo's own `governance.yaml` (currently v1.2.1);
  CHANGELOG + matrix row; release evidence per `runbooks/
  RELEASE_PROCESS.md`; tag + GitHub Release. Read-only cross-check of the
  book's ADG citations; rename follow-on issue; Phase 12 sign-off row.
- **Acceptance IDs.** SCN-12.7-01 (release evidence bundle), SCN-12.7-02
  (`governance.yaml` == `VERSION`), SCN-12.7-03 (book citation report
  listing any shifted line refs), SCN-12.7-04 (rename issue open),
  SCN-12.7-05 (human sign-off recorded).
- **Risk tier.** Medium. **Validation.** `scripts/validate_governance.sh`,
  `scripts/validate_astaire_wiring.sh --root .`, CI green.
