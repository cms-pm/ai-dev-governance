---
phase: 11
stage_produced: plan
---

# Phase 11 — Running TO-DO

Linked to: `docs/planning/chunks/phase-11-chunks.md`,
`docs/planning/pool_questions/phase-11-consumer-enforcement-surface.md`,
`docs/planning/phase-11-risks.md`.

Each chunk ticks down its rows on merge. Evidence annotations are appended
in `(parens)` after each box is checked.

## SCN-11.0 — Bootstrap

- [x] Pool-questions doc on disk at
      `docs/planning/pool_questions/phase-11-consumer-enforcement-surface.md`
      (Q1..Q6; strict-baseline gate score `0.0252` ≤ `0.10`,
      conf `4.50` ≥ `4.5`).
- [x] Chunk plan on disk at `docs/planning/chunks/phase-11-chunks.md`.
- [x] Risk log on disk at `docs/planning/phase-11-risks.md`
      (R-11-01..07 + R-10-02/03/04, R-8.2-02, R-8.2-05, R-9-04, R-9-05
      carry-forward).
- [x] This TO-DO on disk.
- [x] Traceability rows for SCN-11.0..SCN-11.10 appended to
      `docs/planning/traceability.md` (all `pending`; 51 rows).
- [x] Phase 11 sign-off row appended to `docs/planning/signoffs.md`
      (status `pending`, score `0.0252`, conf `4.50`).
- [x] `.astaire/astaire scan --root .` + lint 0/0; all four artifacts
      registered (`query --tag phase=11` returns 4 documents; initial
      lint reported a stale-L0 cache error, cleared by regeneration).

## Landed Out of Order — covered by EXC-0002

Recorded here for auditability rather than hidden in the SCN-11.1 rows.
The R-11-08 fix landed on branch `SCN-11.0`, whose declared scope is
"authoring only; no policy or code change", ahead of SCN-11.1's ceremony.
Rationale: R-11-08 was a live fail-open in the validator Thread A promotes
to a **blocking** consumer CI gate; shipping that gate over an undetected
silent-pass was the worse outcome. Waiver `EXC-0002`
(`docs/governance/exceptions.yaml`), approved 2026-07-26, expires
2026-08-09.

- [x] R-11-08 closed — tentacle presence is now a fail-closed check
      (`scripts/validate_bootstrap.sh` check 9); commit `06b1558`.
- [x] Every branch of the pin check (9b) emits a verdict; no silent exit.
- [x] Executed-check floor added (`MIN_CHECKS`, default 13).
- [x] Verified across 4 cases on 2 bootstrapped consumers with
      two-directional discrimination
      (`docs/validation/scn-11.0/allowlist-verification.md`).
- [x] Regression bounded: `COMPATIBILITY_MATRIX.md` confirmed present on
      `consumer/bootstrap-v0.6.0`, `-v1.0.0`, `-v1.1.0`.
- [x] EXC-0002 approved by named human; status `active`.
- [ ] **Carried to SCN-11.1:** R-11-09 (unconditional PASS in check 1).
- [ ] **Carried to SCN-11.1:** R-11-10 (MIN_CHECKS headroom + maker-
      controlled override; replace with required-check-ID set).

## Thread A — Enforcement Wiring

### SCN-11.1 — Consumer CI template

- [ ] `templates/ci/governance-check.yml` on disk; parses as valid YAML.
- [ ] Mandatory job runs `validate_bootstrap.sh` from the consumer root
      through `${GOVERNANCE_MOUNT}`.
- [ ] Checkout uses `submodules: recursive`.
- [ ] Mandatory job depends only on `git` / `grep` / `sed` (stock runner;
      no `rg`, `python3`, or Docker).
- [ ] Opt-in chunk-scope job present, commented, citing
      `core/GIT_BRANCH_STRATEGY.md` and its `rg` + `fetch-depth: 0` deps.
- [ ] Opt-in analyzer-validator job present, commented, citing its
      `python3` dep.
- [ ] `templates/ci/README.md` documents non-GitHub CI wiring.

### SCN-11.2 — Bootstrap installs CI; broken paths fixed

- [ ] `write_ci_workflow()` added, following `write_codegraph_contract()`.
- [ ] `--new` writes the workflow by default.
- [ ] `--retrofit` does **not** write it without `--with-ci`.
- [ ] `--retrofit --with-ci` writes it.
- [ ] Existing `.github/workflows/governance-check.yml` never overwritten.
- [ ] `--verify` exec path fixed (line 369) to the submodule-relative form;
      `--verify` runs and returns a real verdict.
- [ ] Printed next-step paths fixed (lines 357, 456, 526).
- [ ] `write_evidence_bundle()` reports CI wiring state.

### SCN-11.3 — Documentation path corrections

- [ ] `runbooks/PROJECT_BOOTSTRAP.md` lines 48, 103, 182 corrected.
- [ ] `runbooks/SUBMODULE_CONSUMER_RUNBOOK.md` line 77 corrected.
- [ ] `templates/AGENTS_BOOTSTRAP_TEMPLATE.md` line 116 corrected.
- [ ] "CI wiring" section added to `runbooks/PROJECT_BOOTSTRAP.md`.
- [ ] `rg -n 'scripts/validate_bootstrap\.sh'` across `runbooks/`,
      `templates/`, `README.md` returns only submodule-prefixed forms.

### SCN-11.4 — ADG self-CI: execute the installer (keystone)

- [ ] `submodules: recursive` added to
      `.github/workflows/governance-consistency.yml`.
- [ ] **[hard]** Architecture-fitness audit reports ≥ 1 scanned file for
      `astaire/src/domain/claims/`; string `protectedPath does not exist`
      absent from job output.
- [ ] `bootstrap-smoke` job bootstraps a consumer from the local checkout
      and runs `validate_bootstrap.sh` against it.
- [ ] Generated consumer carries `.github/workflows/governance-check.yml`.
- [ ] **[hard]** Planted violation (delete `.astaire/astaire`) produces a
      non-zero exit, **and** the unmodified consumer exits 0 in the same
      job.

### SCN-11.5 — Retire grep-the-source assertions

- [ ] `validate_governance.sh` lines 263-268 retired or demoted, with a
      comment citing SCN-11.4 as the real gate.
- [ ] `templates/ci/governance-check.yml` and `templates/ci/README.md`
      added to `required_files`.
- [ ] README-vs-`VERSION` drift check added and observed to FAIL on a
      deliberately desynchronized README.
- [ ] `./scripts/validate_governance.sh` exits 0.

## Thread B — Release Surface

### SCN-11.6 — Consumer-branch build script

- [ ] `scripts/build_consumer_branch.sh` on disk; allowlist declared as
      data at the top of the file.
- [ ] Built branch contains every allowlisted path.
- [ ] **[hard]** `docs/planning/`, `docs/releases/`, `.claude/`,
      `.claude-flow/`, `.swarm/`, `artifacts/` absent from the built
      branch — **and** present on `main` (assertion discriminates).
- [ ] Path manifest + prior-release diff emitted for release evidence.
- [ ] Refuses to run on a dirty working tree.
- [ ] Refuses to overwrite a published branch.

### SCN-11.7 — Built-branch verification (closes R-11-01)

- [ ] **[hard]** Consumer bootstrapped from the **built** branch passes
      `validate_bootstrap.sh`, reporting a non-zero executed-check count.
- [ ] Generated consumer carries the CI workflow.
- [ ] Planted-violation check still bites on this path.
- [ ] R-11-01 closed or re-scored with evidence recorded.

### SCN-11.8 — Release runbook updates

- [ ] `runbooks/PUBLISH_WORKFLOW.md` documents the
      `build_consumer_branch.sh` step.
- [ ] `runbooks/RELEASE_PROCESS.md` requires consumer-surface evidence
      (path manifest + prior-release diff).
- [ ] `README.md` carries the forward-only note and a corrected stable tag.
- [ ] Astaire scan + lint 0/0.

## Phase Close

### SCN-11.9 — Find-Gaps Loop + board packet

- [ ] `docs/planning/phase-11-find-gaps.md` on disk; one question per
      iteration.
- [ ] Every answer lands as a pool amendment, a new acceptance ID, or a new
      risk row.
- [ ] Loop exit recorded: three consecutive "no new artifact required" with
      rationale.
- [ ] Board review packet authored from
      `templates/BOARD_REVIEW_PACKET_TEMPLATE.md`.
- [ ] Opportunity register authored, seeded with R-11-06 and R-11-07.
- [ ] R-11-04 (gate-threshold discrepancy) placed before the board for
      disposition.

### SCN-11.10 — Sign-off and closeout

- [ ] Board meeting record with decision rows.
- [ ] Traceability SCN-11.0..SCN-11.10 all `done`.
- [ ] Sign-off row dated, named human approver, immutable trace.
- [ ] Risk dispositions recorded (R-11-01..07 + carry-forward).
- [ ] `docs/releases/v1.3.0/evidence-bundle.md` present — the artifact
      `v1.2.0` and `v1.2.1` omitted — including `rtk gain` / `rtk discover`
      output per `runbooks/RELEASE_PROCESS.md`.
- [ ] `v1.3.0` consumer branch built via `build_consumer_branch.sh` and
      verified per SCN-11.7.
