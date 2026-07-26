---
phase: 11
stage_produced: plan
---

# Phase 11 Pool — Consumer Enforcement Surface

## Goal

Make ADG's governance **actually run in a generic consumer's build**, and
make the consumer's copy of ADG contain **only consumer-facing material**.

Phase 11 closes two defects that share one root cause: ADG has been
validated as an authoring repository rather than as a consumed product.

- **Thread A — enforcement.** `scripts/bootstrap_project.sh` installs
  structure (Astaire wrapper, `governance.yaml`, agent bootstrap blocks,
  doc directories) but installs **no CI**. Nothing in a consumer repo ever
  runs a governance check unless a human remembers to. The one real
  consumer-side verifier, `scripts/validate_bootstrap.sh`, is additionally
  documented at a path that does not exist in a consumer repo.
- **Thread B — release surface.** The published consumer branch ships this
  repository's authoring artifacts — board minutes, member dossiers, chunk
  plans, risk logs — plus 259 files of unreferenced agent boilerplate.

## Carry-forward inputs

**From `docs/planning/phase-10-risks.md` (monitor lane):**

- R-10-02 (Medium / Medium) — downstream CG adoption pending. Phase 11
  does not alter the CG contract; the monitor cadence is inherited
  unchanged.
- R-10-03 (Medium / Medium) — non-CG consumers rely on native discovery.
  Phase 11's CI template MUST remain correct for non-CG consumers; the
  mandatory job depends on no CG tooling.
- R-10-04 (Medium / Low) — CockpitVM pilot benchmark not captured.
  Unaffected by Phase 11.
- R-8.2-02, R-8.2-05, R-9-04, R-9-05 — inherited unchanged.

**From the evaluation that opened this phase.** Ten findings were raised
against ADG on 2026-07-25; Phase 11 addresses the four that concern the
consumer contract. The remainder (JSON-schema instance validation, grep-
assertion brittleness, absent validator unit tests, `core/` vs root
duplication) are registered in §Remaining Risks and deferred, not lost.

## Scope

**Thread A — enforcement wiring:**

- New `templates/ci/governance-check.yml` — tiered consumer CI workflow.
- `scripts/bootstrap_project.sh` — install the workflow (default-on for
  `--new`, opt-in via `--with-ci` for `--retrofit`); fix the broken
  `--verify` exec path and three printed next-step paths.
- Documentation path corrections across runbooks and templates.
- ADG self-CI: `submodules: recursive`, plus a `bootstrap-smoke` job that
  **executes** the installer instead of grepping its source.

**Thread B — release surface:**

- New `scripts/build_consumer_branch.sh` — deterministic allowlist-driven
  construction of the consumer branch from `main`.
- Validation that the built branch excludes authoring artifacts and
  retains every consumer-required path.
- `runbooks/PUBLISH_WORKFLOW.md` and `runbooks/RELEASE_PROCESS.md` updated
  to document consumer-branch composition.

**Out of scope (deferred, with rationale):**

- JSON-schema instance validation of a consumer's `governance.yaml`.
  Requires a new dependency and will surface pre-existing manifest defects;
  belongs in its own chunk. Registered as R-11-06.
- Making `scripts/validate_chunk_scope.sh` a mandatory consumer gate. It
  changes consumer *merge* behaviour, not consumer *wiring*. Ships as a
  commented-out opt-in tier in the CI template per the honor-system
  decision in Q5.
- Unit tests for `scripts/validators/*.py`. Registered as R-11-07.
- Retro-stripping published tags or `consumer/bootstrap-v1.1.0`. Settled
  forward-only in Q6.
- Layer-3 behavioural enforcement (verifying an agent actually queried
  Astaire before reading, that an SCN had a plan before code). Intentionally
  the consumer's decision; ADG offers examples, not mandates.

---

## Resolved Questions

### Q1 — Phase scope: one thread or two?

**Resolution.** Both threads run in Phase 11 under the theme "Consumer
Enforcement Surface."

**Reasoning.** The two threads share a single acceptance target — a correct
generic-consumer install — and interfere if separated. Shipping a CI
workflow (Thread A) onto a consumer branch that still carries authoring
artifacts (Thread B) means the new workflow is itself delivered alongside
the material it should have been packaged without. Splitting would also
require the allowlist in Thread B to be authored twice: once provisionally,
once for real.

- P `0.10` · U `0.5` · M `0.5` · I `4` → contribution `0.10`
- Confidence: **4** (reasoned; phase size is the residual concern)

### Q2 — How is the consumer branch constructed?

**Resolution.** A scripted, allowlist-driven strip at release time:
`scripts/build_consumer_branch.sh` produces the consumer branch from `main`
via an explicit allowlist of consumer-facing paths.

**Reasoning.** Three candidates were considered. A **manual strip** documented
as a release checklist item is a human-honored step — the exact failure class
Phase 11 exists to remove, and it would be indefensible to fix the CI gap by
introducing another unenforced manual step. **Reviving
`release/bootstrap-tabula-rasa`** was rejected as a base: it is 73 commits
behind `main` and still contains `graphify/`, removed at SCN-10.6. Its *file
shape* is nonetheless the best available evidence of the intended target and
is used as the seed for the allowlist. The **scripted allowlist** is
deterministic, re-runnable per release, auditable, and diffable against the
prior release — and it makes the consumer surface a reviewable artifact
rather than a side effect.

Allowlist (initial): `core/`, `adapters/`, `contracts/`, `runbooks/`,
`templates/`, `validation/`, `scripts/`, `docs/glossary/`, `README.md`,
`LICENSE`, `VERSION`, `CHANGELOG.md`, `MIGRATION.md`, `governance.yaml`,
`CODEOWNERS`, `.gitmodules`, `.gitignore`, `.astaire/`.

Denylist by construction (anything not allowlisted), notably:
`docs/planning/`, `docs/releases/`, `docs/validation/`, `docs/evidence/`,
`docs/governance/proposals/`, `.claude/`, `.claude-flow/`, `.swarm/`,
`artifacts/`, `raw/`.

- P `0.15` · U `0.5` · M `0.8` · I `5` → contribution `0.30`
- Confidence: **4** (allowlist completeness is unverified until SCN-11.7
  builds and smoke-tests the branch; this is the phase's largest residual)

### Q3 — Disposition of `.claude/` (259 files, 2.7 MB)

**Resolution.** Excluded from the consumer surface by the Q2 allowlist.
Left tracked on `main` unchanged.

**Reasoning.** It is authoring-side tooling for this repository: measured at
259 tracked files, and referenced by zero governance artifacts. Removing it
from the consumer surface costs nothing and removes ~40× the weight of
`core/` from every consumer. Un-tracking it on `main` was considered and
declined for this phase — it would trade a real convenience (committed agent
config across machines) for a cosmetic gain, and it is not on the consumer
contract's critical path.

- P `0.05` · U `0.0` · M `0.3` · I `3` → contribution `0.00`
- Confidence: **5** (verified by measurement: file count and reference count)

### Q4 — Risk tier for Phase 11

**Resolution.** **High.** Per `governance.yaml` §automation.tiers: board
review required, chair signoff plus two human approvals, and the Find-Gaps
Loop is mandatory per `core/PLANNING_METHODOLOGY.md` §Pool Question
Sub-Protocol.

**Reasoning.** Phase 11 changes what every consumer receives and adds a
blocking gate to a consumer's build — the two highest-blast-radius change
classes ADG can make. The tier is also corrective: `v1.2.0` and `v1.2.1`
shipped outside the phase/chunk/board/signoff machinery entirely, and Phase
11 is the change that restores it. Running the process loosely on the change
that re-establishes the process would be self-defeating.

- P `0.10` · U `0.5` · M `0.4` · I `3` → contribution `0.06`
- Confidence: **5** (verified against the manifest tier table)

### Q5 — Is the consumer CI workflow installed by default?

**Resolution.** **Default-on for `--new`; opt-in via `--with-ci` for
`--retrofit`.**

**Reasoning.** A generic new consumer must not have to read a runbook to get
enforcement — default-off for `--new` would reproduce exactly the gap this
phase closes. But `--retrofit` lands inside someone else's established CI,
where writing to `.github/workflows/` unasked is an intrusion with real
potential to break a working pipeline. The split respects both. It also
mirrors the existing `--with-board` flag precedent, so the CLI surface gains
no new idiom. Installation is non-destructive in both modes: an existing
`.github/workflows/governance-check.yml` is never overwritten, consistent
with how `governance.yaml` is treated on retrofit.

This resolution also carries the honor-system decision: the workflow ships
**tiered**, with one mandatory job (bootstrap/wiring validation, zero extra
dependencies) and two commented-out opt-in jobs (chunk-scope enforcement;
analyzer validators). Each opt-in block states what it enforces, its
dependencies, and which `core/` document it implements. Doctrine adoption
remains the consumer's decision; ADG supplies the worked example.

- P `0.10` · U `0.5` · M `0.6` · I `4` → contribution `0.12`
- Confidence: **4** (reasoned; retrofit ergonomics unverified until piloted)

### Q6 — Are published tags and consumer branches retro-stripped?

**Resolution.** **Forward-only from `v1.3.0`.** `v1.1.5`, `v1.2.x`, and
`consumer/bootstrap-v1.1.0` are left exactly as published.

**Reasoning.** Rewriting a published consumer branch breaks submodule SHA
pins and violates the reproducibility guarantee that pinning exists to
provide. `core/GIT_BRANCH_STRATEGY.md` treats published releases as
immutable, and `core/ACCEPTANCE_INTEGRITY.md` §Boundary Invariants makes the
general form of this argument: corrections are made in a new chunk, never by
editing history. Existing consumers receive the clean surface when they
choose to upgrade.

- P `0.05` · U `0.0` · M `0.5` · I `4` → contribution `0.00`
- Confidence: **5** (settled practice; consistent with two existing core
  policies)

---

## Ambiguity Gate

**Superseded scoring (2026-07-25).** The original gate claimed
`0.0252` / `4.50` — a PASS exactly at the confidence threshold. Independent
audit rejected it: three confidence-5 ratings (Q3, Q4, Q6) did not meet the
rubric's `5: verified by measurement/test/data`, and Q3's stated measurement
(".claude/ referenced by zero governance artifacts") was **false** —
`runbooks/PUBLISH_WORKFLOW.md:12` and
`runbooks/SUBMODULE_CONSUMER_RUNBOOK.md:174` both reference it. Correcting
only those three yields `4.00`. The scoring below is the re-score after the
verification work described in
`docs/validation/scn-11.0/allowlist-verification.md`.

### Re-scored (2026-07-26, post-verification)

| Q | P | U | M | I | `P·U·M·I` | Conf | Basis |
|---|---|---|---|---|---|---|---|
| Q1 | 0.20 | 0.5 | 0.5 | 4 | 0.200 | 4 | 11 chunks / 5 high-tier; over-scope risk priced in. Reasoned. |
| Q2 | 0.20 | 0.5 | 0.8 | 5 | 0.400 | **5** | Verified by test, both directions. `P` held at 0.20, not reduced — verification proved the oracle cannot certify completeness (R-11-08). |
| Q3 | 0.05 | 0.5 | 0.3 | 3 | 0.023 | **5** | Reference count re-measured correctly; strip executed and consumer built without `.claude/` passes. |
| Q4 | 0.05 | 0.5 | 0.4 | 3 | 0.030 | 4 | Tier lookup verified; the *classification* judgement is reasoned, not measured. |
| Q5 | 0.15 | 0.5 | 0.6 | 4 | 0.180 | 4 | Retrofit ergonomics remain unverified. |
| Q6 | 0.05 | 0.0 | 0.5 | 4 | 0.000 | 4 | Compelled by two core policies — rubric-4 wording verbatim. |

```
score = 0.8325 / 23 = 0.0362
confidence = (4 + 5 + 5 + 4 + 4 + 4) / 6 = 4.33
```

| Metric | Value | Strict-baseline gate | Verdict |
|---|---|---|---|
| Ambiguity score | `0.0362` | `<= 0.10` | PASS |
| Confidence average | `4.33` | `>= 4.5` | **FAIL** |

**The gate does not pass, and cannot be made to pass by further
verification of this question set.** Reaching `4.5` requires three of six
questions at rubric-5. Q2 and Q3 now hold it legitimately. Q1 (phase
scope), Q4 (risk-tier classification), Q5 (CLI ergonomics), and Q6
(release-history policy) are irreducibly judgement calls: no measurement
exists that would verify them without inventing one, which would be
Goodharting the rubric — the precise move `core/ACCEPTANCE_INTEGRITY.md`
§Anti-Patterns item 1 prohibits.

This is a **gate-design finding**, not merely a Phase 11 finding: the
strict-baseline confidence gate of `>= 4.5` appears unreachable for any
predominantly doctrinal or packaging phase, as distinct from an empirical
one. It is escalated to the board alongside R-11-04 and is the reason
Phase 11 cannot self-certify past planning. Related: `core/GATE_DESIGN.md`
§tiered checks and the first-class `PARTIAL` verdict, which is the shape
this gate arguably needs.

**Ambiguity-model observation.** With `sum(I) = 23` and `U` capped at 0.5
for any genuinely uncertain question, no single defective resolution can
fail this phase on ambiguity — Q2 scored at `P = 0.50` still yields only
`0.0623`. Confidence is the sole load-bearing constraint at this phase
size. Escalated with R-11-04.

**Gate selection note.** This phase is scored against the **strict-baseline**
gate (`<= 0.10` / `>= 4.5`) because `governance.yaml` declares
`profile: strict-baseline`. Phases 8.2 through 10 scored themselves against
the **default** gate (`<= 0.20` / `>= 4.0`); Phase 10 signed off at confidence
`4.10`, which does not satisfy the strict-baseline gate the manifest declares.
This discrepancy is registered as **R-11-04** and is not resolved here —
Phase 11 declines to inherit the looser gate, but does not retroactively
reopen closed phases (`core/ACCEPTANCE_INTEGRITY.md` §Boundary Invariants).

The confidence average sits **exactly at** the strict threshold. It has not
been rounded up, and Q2's confidence of 4 is the binding constraint: the
allowlist is unverified until SCN-11.7 executes it. Any downward revision of
Q2 fails the gate and requires re-planning.

## Find-Gaps Loop

Mandatory at risk-tier high. Record: `docs/planning/phase-11-find-gaps.md`
(authored at SCN-11.9, before board review). The loop exits after three
consecutive questions returning "no new artifact required."

## Remaining Risks

Enumerated in `docs/planning/phase-11-risks.md`: R-11-01 through R-11-07,
plus carry-forward monitoring of R-10-02, R-10-03, R-10-04, R-8.2-02,
R-8.2-05, R-9-04, R-9-05.
