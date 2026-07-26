---
phase: 11
stage_produced: plan
---

# Phase 11 Risk Log — Consumer Enforcement Surface

Linked to: `docs/planning/pool_questions/phase-11-consumer-enforcement-surface.md`,
`docs/planning/chunks/phase-11-chunks.md`.

Phase risk tier: **high**. Board review required; Find-Gaps Loop mandatory.

## Open Risks

| ID | Title | Severity | Likelihood | Trigger SCN(s) | Mitigation | Owner | Review Window |
|---|---|---|---|---|---|---|---|
| R-11-01 | **Allowlist incompleteness.** The consumer-branch allowlist (pool Q2) omits a path a consumer needs, producing a branch that looks clean but yields a broken install. **Realized at planning time**: the allowlist as originally authored omitted the `astaire` gitlink and `docs/governance/exceptions.yaml`; a consumer built from it has no Astaire at all. Corrected and re-verified — see `docs/validation/scn-11.0/allowlist-verification.md`. Residual risk is now *undetectable* incompleteness, per R-11-08. | High | **High (realized; corrected)** | SCN-11.6, SCN-11.7 | SCN-11.7 does not inspect the allowlist; it **bootstraps a consumer from the built branch and runs the full smoke against it**, so a missing path fails rather than passes silently. SCN-11.7-01 is `hard: true` with an antiProxy requiring a non-zero executed-check count, closing the "validator skipped everything and exited 0" cheap path. | Accountable Delivery Lead | At SCN-11.7; re-score before `v1.3.0` cut |
| R-11-02 | **Retrofit CI intrusion.** Writing `.github/workflows/` into an existing consumer repo collides with established CI or triggers unexpected billing. | Medium | Medium | SCN-11.2 | Pool Q5 resolves retrofit to **opt-in via `--with-ci`**; `--new` remains default-on. Installation is non-destructive in both modes (never overwrites an existing workflow), consistent with `governance.yaml` retrofit handling. SCN-11.2-02 asserts the negative case explicitly. | Accountable Delivery Lead | At SCN-11.2; first retrofit adoption |
| R-11-03 | **Smoke-job fragility.** The SCN-11.4 bootstrap smoke depends on `git config protocol.file.allow always` for local-path submodule adds (required on git ≥ 2.38). Runner git-version drift, or a future git default change, breaks the keystone gate. | Medium | Low | SCN-11.4 | Pin the behaviour explicitly in the job rather than relying on runner defaults; assert the submodule materialized before proceeding, so a protocol failure surfaces as an explicit FAIL rather than a skipped step. Fallback: `file://` transport or a bare intermediate clone. | Accountable Delivery Lead | At SCN-11.4; each runner-image bump |
| R-11-04 | **Gate-threshold discrepancy in closed phases.** `governance.yaml` declares `profile: strict-baseline` (ambiguity ≤ `0.10`, confidence ≥ `4.5`), but Phases 8.2–10 scored against the default gate (≤ `0.20` / ≥ `4.0`). Phase 10 signed off at confidence `4.10`, which does not satisfy the declared profile's gate. | Medium | High (already realized) | Discovered at SCN-11.0 | Phase 11 scores against the **strict-baseline** gate and declines to inherit the looser one. Closed phases are **not** reopened — `core/ACCEPTANCE_INTEGRITY.md` §Boundary Invariants forbids re-grading a closed chunk. Disposition options for board: (a) accept as historical and document the gate in effect per phase, (b) file a time-bound waiver under `core/EXCEPTIONS_AND_WAIVERS.md`, (c) amend `PLANNING_METHODOLOGY.md` if the strict gate was never the intent. Requires a board decision, not an agent decision. | Board (chair) | SCN-11.9 board packet |
| R-11-05 | **Pre-v1.3.0 consumers keep receiving authoring artifacts.** Forward-only stripping (pool Q6) means existing consumers on `consumer/bootstrap-v1.1.0` continue to pull board minutes, chunk plans, and 259 `.claude/` files until they upgrade. | Low | High (by design) | SCN-11.8 | Accepted consequence of not rewriting published history. SCN-11.8-03 adds a README note so the shrink on upgrade is expected rather than alarming. No consumer is harmed beyond repository weight; no governance control depends on the stripped paths. | Accountable Delivery Lead | At `v1.3.0` release note |
| R-11-06 | **Manifest schema remains unenforced.** No JSON-schema instance validation exists anywhere: `contracts/governance-manifest.schema.json` (413 lines) has never validated a manifest, and four hand-rolled regex YAML parsers stand in for it. A consumer can declare a malformed manifest and every ADG tool reports green. | High | High (already realized) | Deferred from Phase 11 scope | Explicitly out of scope (pool §Scope) — needs a new dependency and will surface pre-existing defects, including this repo's own `governance.yaml` whose `frozenPaths.manifestPath` and `harnessMetrics.metricsPath` point at files that do not exist. Registered in the SCN-11.9 opportunity register as the leading Phase 12 candidate. | Accountable Delivery Lead | SCN-11.9; Phase 12 planning |
| R-11-07 | **Enforcement code is untested.** `scripts/` and `scripts/validators/` — 2,669 lines that constitute the governance product — have no unit tests. No meta-gate plants a violation and asserts the *validator* fails. | Medium | High (already realized) | Deferred from Phase 11 scope | Partially mitigated in-phase: SCN-11.4-05 and SCN-11.6-02 introduce the first planted-violation checks in the repository, establishing the pattern per `core/MUTATION_EVIDENCE.md`. Full unit coverage deferred; registered in the SCN-11.9 opportunity register. | Accountable Delivery Lead | SCN-11.9; Phase 12 planning |

| R-11-08 | **`validate_bootstrap.sh` fails open on a missing tentacle.** The tentacle-pin check (`scripts/validate_bootstrap.sh:141-156`) is guarded on `git -C "$GOVERNANCE_MOUNT/astaire" rev-parse` succeeding; when the submodule is absent the entire check is **skipped silently** — no WARN, no FAIL. A consumer with no Astaire submodule is certified `Bootstrap validation passed`, exit 0. Verified by differential observation: the `Astaire submodule pinned` line appears 1× on a good consumer and 0× on a broken one. Discovered during SCN-11.0 allowlist verification. | High | High (realized) | SCN-11.1, SCN-11.2 | Thread A MUST add a fail-closed criterion: when `GOVERNANCE_MOUNT` exists, the tentacle path MUST exist and the pin check MUST execute; a skipped pin check is a FAIL. This is load-bearing for the whole phase — Thread A promotes this validator to a **blocking CI gate**, so shipping it as-is would enforce a check that cannot see the defect it most needs to catch. Silent-zero per `core/HARNESS_METRICS.md`. | Accountable Delivery Lead | Before SCN-11.1 completes |

## Carry-Forward Monitoring (inherited, unchanged)

| ID | Source Phase | Disposition in Phase 11 |
|---|---|---|
| R-10-02 | 10 | Monitor. Phase 11 does not alter the CG contract. The consumer CI template's mandatory job depends on no CG tooling, so non-CG consumers are not coerced — consistent with the original mitigation. |
| R-10-03 | 10 | Monitor. Phase 11 MUST keep the mandatory CI job correct for non-CG consumers; verified by SCN-11.1-02 (stock-runner dependency set only). |
| R-10-04 | 10 | Monitor. CockpitVM pilot benchmark unaffected by Phase 11. |
| R-8.2-02 | 8.2 | Monitor. Static-analyzer-capability downstream adoption still pending. |
| R-8.2-05 | 8.2 | Monitor. Phase 8.1 reciprocal entry on `main` still outstanding. |
| R-9-04 | 9 | Monitor. Manifest-schema downstream adoption pending; interacts with R-11-06 — if Phase 12 lands schema validation, these two should be dispositioned together. |
| R-9-05 | 9 | Monitor. Glossary authoring authority drift; quarterly review cadence unchanged. |

## Rollback Posture

Every Phase 11 chunk is revertible without consumer impact:

- Thread A additions are new files plus additive edits; the installed CI
  workflow is consumer-deletable and never overwrites existing CI.
- Thread B never mutates a published branch or tag (pool Q6). The consumer
  branch is built into a new ref; a defective build is discarded, not
  force-pushed over.
- The only irreversible act in the phase is the `v1.3.0` tag at SCN-11.10,
  which is gated on SCN-11.7's executed verification.
