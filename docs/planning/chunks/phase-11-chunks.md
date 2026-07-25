---
phase: 11
stage_produced: plan
---

# Phase 11 — Chunk Plans (Consumer Enforcement Surface)

Precondition: Phase 10 sign-off landed 2026-05-23 (MTG-0006). Releases
`v1.2.0` and `v1.2.1` shipped subsequently **outside** the phase/chunk/board
machinery; Phase 11 restores it. Carry-forward risks R-10-02, R-10-03,
R-10-04, R-8.2-02, R-8.2-05, R-9-04, R-9-05 remain in monitor lane and are
inherited unchanged.

Phase 11 closes ADG's **consumer contract** on two threads:

- **Thread A — enforcement.** The bootstrap installs no CI, so no governance
  check ever runs in a consumer repo automatically. The one consumer-side
  verifier is documented at a path that does not exist in a consumer repo.
- **Thread B — release surface.** The published consumer branch ships this
  repository's authoring artifacts and 259 files of unreferenced agent
  boilerplate.

Authoritative planning input:
`docs/planning/pool_questions/phase-11-consumer-enforcement-surface.md`
(Q1..Q6 resolved; strict-baseline gate score `0.0252` ≤ `0.10`; confidence
`4.50` ≥ `4.5`).

**Phase risk tier: high.** Board review required; chair signoff plus two
human approvals; Find-Gaps Loop mandatory.

**Design invariant for the phase.** Every check ADG asks a consumer to run
must be a check ADG *executes* against a generated consumer, not a string it
greps out of its own source. SCN-11.4 is the chunk that makes this true and
is the phase's keystone.

---

## SCN-11.0 — Bootstrap (planning artifacts + Astaire ingest)

- **Scope.** Meta-chunk. Produces every Phase 11 planning artifact:
  - `docs/planning/pool_questions/phase-11-consumer-enforcement-surface.md`
  - This chunk plan (`docs/planning/chunks/phase-11-chunks.md`).
  - `docs/planning/phase-11-risks.md` (R-11-01..07 + carry-forward).
  - `docs/planning/phase-11-todo.md`.
  - Traceability rows for SCN-11.0..SCN-11.10 appended to
    `docs/planning/traceability.md` (all `pending`).
  - Phase 11 sign-off row appended to `docs/planning/signoffs.md`
    (status `pending`).
  - `.astaire/astaire scan --root .` + lint 0/0.
- **Acceptance IDs.** SCN-11.0-01 (pool Q&A + gate scored against
  strict-baseline), SCN-11.0-02 (chunk plan), SCN-11.0-03 (risks),
  SCN-11.0-04 (TO-DO), SCN-11.0-05 (Astaire ingest verified),
  SCN-11.0-06 (signoffs + traceability rows appended).
- **Risk tier.** Low. Authoring only; no policy or code change.
- **Validation method.** Astaire `scan` + `lint` exit 0;
  `query --tag phase=11` returns the four new artifacts; signoffs row
  present with status `pending`.
- **Rollback.** Delete the four artifacts; no downstream dependency.
- **Atomic PR scope.** Single commit on branch `SCN-11.0`.
- **Complexity applicability.** N/A (documentation only).

---

## Thread A — Enforcement Wiring

## SCN-11.1 — Consumer CI template

- **Scope.** New `templates/ci/governance-check.yml` and
  `templates/ci/README.md`.
  - **Mandatory job** — runs
    `${GOVERNANCE_MOUNT}/scripts/validate_bootstrap.sh` from the consumer
    root. Checkout MUST use `submodules: recursive`; without it the Astaire
    tentacle is absent and chained checks degrade to vacuous passes.
    Verified dependency set is `git` / `grep` / `sed` only — no ripgrep,
    Python, or Docker — so the job runs on a stock runner with zero setup.
  - **Opt-in job (commented out)** — `validate_chunk_scope.sh`; requires
    `rg` and `fetch-depth: 0`. Implements
    `core/GIT_BRANCH_STRATEGY.md` §Atomic Scope Guardrails.
  - **Opt-in job (commented out)** — analyzer validators
    (`mutation_threshold`, `glossary_coverage`, `architecture_fitness`)
    against the consumer's own manifest; requires `python3`.
  - Each opt-in block MUST state what it enforces, its added dependencies,
    and the `core/` document it implements.
  - `templates/ci/README.md` documents non-GitHub CI wiring: the contract is
    "run this script from repo root with submodules initialized."
- **Acceptance IDs.** SCN-11.1-01 (template on disk, valid YAML),
  SCN-11.1-02 (mandatory job depends only on the verified stock-runner tool
  set), SCN-11.1-03 (`submodules: recursive` present), SCN-11.1-04 (both
  opt-in blocks present, commented, each citing its `core/` doc),
  SCN-11.1-05 (`templates/ci/README.md` covers non-GitHub CI).
- **Risk tier.** Medium (new consumer-facing template; not yet installed).
- **Validation method.** YAML parses; SCN-11.4's smoke job consumes it.
- **Rollback.** Delete `templates/ci/`; nothing depends on it until SCN-11.2.
- **Atomic PR scope.** Branch `SCN-11.1`.
- **Complexity applicability.** Applicable — new template surface; evidence
  to `docs/validation/scn-11.1/`.

## SCN-11.2 — Bootstrap installs CI; broken paths fixed

- **Scope.** `scripts/bootstrap_project.sh`:
  - New `write_ci_workflow()` following the existing
    `write_codegraph_contract()` pattern (`cp` template, substitute the
    configured mount path). Non-destructive: skip if the target exists,
    consistent with `governance.yaml` retrofit handling.
  - Default-on for `--new`; new `--with-ci` flag for `--retrofit`, mirroring
    the existing `--with-board` precedent (pool Q5).
  - **Fix `--verify`** (line 369): exec
    `"${CONSUMER_ROOT}/${GOVERNANCE_MOUNT}/scripts/validate_bootstrap.sh"`.
    The current path assumes a `scripts/` directory the bootstrap never
    creates in a consumer repo, so `--verify` fails for every consumer.
  - Fix the three printed next-step paths (lines 357, 456, 526) to the
    submodule-relative form.
  - Add a CI-workflow row to `write_evidence_bundle()`'s wire-up table.
- **Acceptance IDs.** SCN-11.2-01 (`--new` writes the workflow),
  SCN-11.2-02 (`--retrofit` does not write it without `--with-ci`),
  SCN-11.2-03 (`--retrofit --with-ci` writes it), SCN-11.2-04 (existing
  workflow never overwritten), SCN-11.2-05 (`--verify` resolves and runs),
  SCN-11.2-06 (evidence bundle reports CI wiring).
- **Risk tier.** High (changes what every new consumer receives).
- **Validation method.** SCN-11.4's executed smoke, both modes. Manual
  pre-check: bootstrap into a temp dir, assert the workflow exists, run
  `--verify` and observe a real verdict rather than a missing-file error.
- **Rollback.** Revert; the workflow is additive and consumer-deletable.
- **Atomic PR scope.** Branch `SCN-11.2`.
- **Complexity applicability.** Applicable — evidence to
  `docs/validation/scn-11.2/`.

## SCN-11.3 — Documentation path corrections

- **Scope.** Correct the consumer-invocation path for
  `validate_bootstrap.sh` to the `.governance/ai-dev-governance/scripts/...`
  form already used correctly at `README.md:90`:
  - `runbooks/PROJECT_BOOTSTRAP.md` (lines 48, 103, 182)
  - `runbooks/SUBMODULE_CONSUMER_RUNBOOK.md` (line 77)
  - `templates/AGENTS_BOOTSTRAP_TEMPLATE.md` (line 116)
  Add a "CI wiring" section to `runbooks/PROJECT_BOOTSTRAP.md` covering the
  mandatory job and the two opt-in tiers.
- **Acceptance IDs.** SCN-11.3-01 (no bare `scripts/validate_bootstrap.sh`
  invocation remains in consumer-facing docs), SCN-11.3-02 (CI wiring
  section present), SCN-11.3-03 (Astaire scan + lint 0/0).
- **Risk tier.** Low (documentation only).
- **Validation method.** `rg -n 'scripts/validate_bootstrap\.sh'` across
  `runbooks/`, `templates/`, `README.md` returns only submodule-prefixed
  forms.
- **Rollback.** Revert.
- **Atomic PR scope.** Branch `SCN-11.3`.
- **Complexity applicability.** N/A.

## SCN-11.4 — ADG self-CI: execute the installer (keystone)

- **Scope.** `.github/workflows/governance-consistency.yml`:
  - Add `submodules: recursive` to checkout. Without it,
    `architecture_fitness --audit` cannot see its protected path
    (`astaire/src/domain/claims/`), emits `[WARN]`, and **exits 0** — a
    silent-zero pass, the failure mode `core/HARNESS_METRICS.md` names.
  - New `bootstrap-smoke` job that **executes** the installer:
    ```
    git config --global protocol.file.allow always
    scripts/bootstrap_project.sh --new /tmp/consumer \
      --governance-url "$GITHUB_WORKSPACE"
    cd /tmp/consumer && \
      .governance/ai-dev-governance/scripts/validate_bootstrap.sh
    ```
    `git submodule add` accepts a local path as URL; `protocol.file.allow`
    is required on git ≥ 2.38. The `astaire startup` call inside `--new` is
    already `|| true`-guarded and its missing DB is a WARN, so the job needs
    no network.
  - Assert the generated consumer contains
    `.github/workflows/governance-check.yml`.
  - **Planted-violation check.** Delete `.astaire/astaire` from the
    generated consumer and assert `validate_bootstrap.sh` exits non-zero.
    Per `core/MUTATION_EVIDENCE.md`, a gate that has never failed a planted
    violation is unproven.
- **Acceptance IDs.** SCN-11.4-01 (`submodules: recursive` present),
  SCN-11.4-02 (architecture-fitness audit reports a non-zero file count,
  not `[WARN] protectedPath does not exist`), SCN-11.4-03 (smoke job
  bootstraps and validates a generated consumer), SCN-11.4-04 (generated
  consumer carries the CI workflow), SCN-11.4-05 (planted violation
  produces a non-zero exit).
  - SCN-11.4-02 and SCN-11.4-05 are **`hard: true`**.
    - SCN-11.4-02 `predicate`: audit stdout reports ≥ 1 scanned file for
      `astaire/src/domain/claims/`. `antiProxy`: assert the literal string
      `protectedPath does not exist` is **absent** from job output — a
      passing audit over zero files is the exact cheap path.
    - SCN-11.4-05 `predicate`: `validate_bootstrap.sh` exit code ≠ 0 after
      wrapper deletion. `antiProxy`: the same command MUST exit 0 on the
      unmodified consumer in the same job, proving the non-zero exit is
      caused by the planted violation and not by a broken harness.
- **Risk tier.** High (keystone; establishes the phase's design invariant).
- **Validation method.** CI job output. Both hard predicates observed in the
  same run at `sil` depth.
- **Rollback.** Revert the workflow; no consumer impact.
- **Atomic PR scope.** Branch `SCN-11.4`.
- **Complexity applicability.** Applicable — evidence to
  `docs/validation/scn-11.4/`.

## SCN-11.5 — Retire grep-the-source assertions

- **Scope.** `scripts/validate_governance.sh`:
  - Lines 263-268 assert ADG's onboarding story by `rg`-ing the installer's
    own source for English strings. With SCN-11.4 executing the installer,
    demote these to cheap fast-fail or remove them; the smoke job is the
    real gate.
  - Add `templates/ci/governance-check.yml` and `templates/ci/README.md` to
    `required_files`.
  - Add a README-vs-`VERSION` consistency check: `README.md` advertises
    `v1.1.5` while `VERSION` reads `1.2.1`. `$version` is already in scope
    at line 307.
- **Acceptance IDs.** SCN-11.5-01 (grep-the-source assertions retired or
  demoted with a comment citing SCN-11.4), SCN-11.5-02 (new required files
  enforced), SCN-11.5-03 (README/VERSION drift check fails on drift),
  SCN-11.5-04 (`validate_governance.sh` exits 0).
- **Risk tier.** Medium.
- **Validation method.** Run `./scripts/validate_governance.sh`. Negative:
  temporarily desynchronize the README tag and assert a FAIL.
- **Rollback.** Revert.
- **Atomic PR scope.** Branch `SCN-11.5`.
- **Complexity applicability.** N/A (validator change).

---

## Thread B — Release Surface

## SCN-11.6 — Consumer-branch build script

- **Scope.** New `scripts/build_consumer_branch.sh` implementing the pool-Q2
  allowlist. Produces the consumer branch from `main` deterministically and
  re-runnably. Requirements:
  - Allowlist declared as data at the top of the script, not scattered
    through logic, so the consumer surface is reviewable in one place.
  - Refuse to run with a dirty working tree.
  - Emit a manifest of included paths and a diff against the previous
    consumer branch, for release evidence.
  - Never force-push or rewrite an existing published branch (pool Q6).
- **Acceptance IDs.** SCN-11.6-01 (script produces a branch containing every
  allowlisted path), SCN-11.6-02 (`docs/planning/`, `docs/releases/`,
  `.claude/`, `.claude-flow/`, `.swarm/`, `artifacts/` absent from the
  result), SCN-11.6-03 (path manifest + prior-release diff emitted),
  SCN-11.6-04 (refuses a dirty tree), SCN-11.6-05 (refuses to overwrite a
  published branch).
  - SCN-11.6-02 is **`hard: true`**. `predicate`: `git ls-tree -r` on the
    built branch returns zero paths matching the denylist prefixes.
    `antiProxy`: the same command MUST return non-zero counts on `main`,
    proving the assertion discriminates rather than matching nothing.
- **Risk tier.** High (defines what every future consumer receives).
- **Validation method.** Build into a scratch branch; assert both directions
  of SCN-11.6-02.
- **Rollback.** Delete the script and the scratch branch; published branches
  are untouched by construction.
- **Atomic PR scope.** Branch `SCN-11.6`.
- **Complexity applicability.** Applicable — evidence to
  `docs/validation/scn-11.6/`.

## SCN-11.7 — Built-branch verification (closes R-11-01)

- **Scope.** Prove the allowlist is *complete*, not merely restrictive — the
  phase's largest residual risk (pool Q2, confidence 4). Build the consumer
  branch, then run the **full SCN-11.4 bootstrap smoke against it** rather
  than against `main`. A missing consumer-facing path fails the smoke.
  - Extend the SCN-11.4 CI job (or add a sibling) to bootstrap from the
    built consumer branch.
- **Acceptance IDs.** SCN-11.7-01 (consumer bootstrapped from the built
  branch passes `validate_bootstrap.sh`), SCN-11.7-02 (the generated
  consumer carries the CI workflow), SCN-11.7-03 (planted-violation check
  still bites on this path), SCN-11.7-04 (R-11-01 closed or re-scored with
  evidence).
  - SCN-11.7-01 is **`hard: true`**. `predicate`: `validate_bootstrap.sh`
    exits 0 against a consumer bootstrapped from the *built* branch.
    `antiProxy`: the run MUST report a non-zero count of executed checks —
    a validator that skips everything also exits 0.
- **Risk tier.** High.
- **Validation method.** CI job output at `sil` depth.
- **Rollback.** Revert; SCN-11.6's script remains unreleased.
- **Atomic PR scope.** Branch `SCN-11.7`.
- **Complexity applicability.** Applicable — evidence to
  `docs/validation/scn-11.7/`.

## SCN-11.8 — Release runbook updates

- **Scope.**
  - `runbooks/PUBLISH_WORKFLOW.md` — currently 29 lines describing
    `git push` and branch protection, with no mention of consumer-branch
    composition. Document the `build_consumer_branch.sh` step as the
    required mechanism.
  - `runbooks/RELEASE_PROCESS.md` — add consumer-surface verification to
    the release gate; require the path manifest and prior-release diff as
    release evidence.
  - `README.md` — note that pre-`v1.3.0` consumer branches carry authoring
    artifacts, so consumers understand why the submodule shrinks on
    upgrade (pool Q6). Correct the advertised stable tag.
- **Acceptance IDs.** SCN-11.8-01 (PUBLISH_WORKFLOW documents the build
  step), SCN-11.8-02 (RELEASE_PROCESS requires consumer-surface evidence),
  SCN-11.8-03 (README forward-only note + corrected tag),
  SCN-11.8-04 (Astaire scan + lint 0/0).
- **Risk tier.** Medium.
- **Validation method.** `validate_governance.sh` passes, including the new
  README/VERSION check from SCN-11.5.
- **Rollback.** Revert.
- **Atomic PR scope.** Branch `SCN-11.8`.
- **Complexity applicability.** N/A.

---

## Phase Close

## SCN-11.9 — Find-Gaps Loop + board review packet

- **Scope.** Mandatory at high tier per `core/PLANNING_METHODOLOGY.md`
  §Pool Question Sub-Protocol.
  - `docs/planning/phase-11-find-gaps.md` — one question per iteration,
    each answer landing as a pool amendment, a new acceptance ID, or a new
    risk row. Loop exits after three consecutive "no new artifact required."
  - `docs/planning/board/committee-review-packet-<date>-scn-11-9.md` using
    `templates/BOARD_REVIEW_PACKET_TEMPLATE.md`.
  - Opportunity register per
    `templates/BOARD_OPPORTUNITY_REGISTER_TEMPLATE.md`, seeded with the
    deferred evaluation findings (R-11-06, R-11-07).
- **Acceptance IDs.** SCN-11.9-01 (find-gaps record with explicit exit
  rationale), SCN-11.9-02 (board packet), SCN-11.9-03 (opportunity
  register), SCN-11.9-04 (every find-gaps answer traceable to an artifact).
- **Risk tier.** Medium.
- **Validation method.** Loop exit condition satisfied and recorded; packet
  conforms to template.
- **Rollback.** N/A (additive records).
- **Atomic PR scope.** Branch `SCN-11.9`.
- **Complexity applicability.** N/A.

## SCN-11.10 — Phase 11 sign-off and closeout

- **Scope.** Board meeting record, decision rows, risk disposition,
  traceability closure, signoff row dated with named human approver, and
  the `v1.3.0` release evidence bundle — including the
  `evidence-bundle.md` that `v1.2.0` and `v1.2.1` omitted.
- **Acceptance IDs.** SCN-11.10-01 (meeting record), SCN-11.10-02
  (traceability SCN-11.0..11.10 all `done`), SCN-11.10-03 (signoff row
  dated with named approver), SCN-11.10-04 (risk dispositions recorded),
  SCN-11.10-05 (`docs/releases/v1.3.0/evidence-bundle.md` present with RTK
  `gain`/`discover` output per `runbooks/RELEASE_PROCESS.md`).
- **Risk tier.** High (board review completion + chair signoff + designated
  accountable approver).
- **Validation method.** `validate_governance.sh` passes; Astaire lint 0/0;
  zero open critical board findings.
- **Rollback.** N/A.
- **Atomic PR scope.** Branch `SCN-11.10`.
- **Complexity applicability.** N/A.

---

## Dependency Order

```
SCN-11.0
  ├─ Thread A: 11.1 → 11.2 → 11.4 → 11.5
  │                     └─ 11.3 (independent, any time after 11.2)
  └─ Thread B: 11.6 → 11.7   (11.7 depends on 11.4's smoke job)
                        └─ 11.8
                              └─ 11.9 → 11.10
```

SCN-11.4 is the join point: Thread B's verification (SCN-11.7) reuses the
executed-smoke harness that Thread A builds. Sequencing 11.4 before 11.7 is
mandatory, not stylistic.
