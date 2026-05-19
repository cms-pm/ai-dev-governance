---
phase: 8.3
stage_produced: plan
---

# Phase 8.3 Pool — Validator Hardening + Cross-Phase Closure

## Goal

Harden the Phase 8.2 deliverables (Power of 10 amendment, CockpitVM
Embedded Style, embedded-profile fail-closed gate, agency-string guard)
by factoring inline validator logic, expanding the guard surface,
tightening the analyzer-capability declaration, and driving the open
cross-phase risk **R-8.2-05** toward closure. Bootstraps Phase 8.3 with
pool questions, chunks, risks, and TO-DO mirroring the SCN-8.2.0 shape.

## Carry-forward inputs

**From `docs/planning/phase-8.2-risks.md` (monitor lane):**

- R-8.2-02 (Medium / Medium) — static-analyzer floor under-specified;
  capability auditing schema deferred from Phase 8.2.
- R-8.2-03 (High / Medium) — opt-in confusion for CockpitVM Embedded
  Style; triangulation in place but still subject to consumer drift.
- R-8.2-04 (Medium / Low) — CockpitVM rebrand lineage opacity for
  auditors; memo + Astaire query is the discovery path.
- **R-8.2-05 (High / Medium, open)** — Phase 8.1 in-flight cohort enters
  Power of 10 acceptance bar on next post-`5d47359` touch; closure
  requires reciprocal entry in `docs/planning/phase-8.1-risks.md` (file
  not yet on `main`). OPP-8.2-003 triggers an owned closure chunk here.

**From `docs/planning/board/committee-virtual-meeting-scn-8-2-5-phase-signoff-2026-05-18.md` (MTG-0003):**

- OPP-8.2-002 (Medium, deferred) — factor inline Python fail-closed gate
  in `scripts/validate_governance.sh` into a stand-alone validator with
  dedicated fixtures (FND-0007).
- OPP-8.2-003 (High, open) — agentic cross-phase trigger: escalate
  R-8.2-05 to owned closure chunk at Phase 8.3 bootstrap (FND-0008).
- OPP-8.2-004 (Low) — **closed without action.** One-time sweep across
  `core/`, `adapters/profiles/`, `docs/planning/board/`, and
  `validation/` returned zero agency strings outside the evaluation
  memo Sources footer. Widening the guard surface judged disproportionate
  to residual risk.

**From `docs/planning/phase-8.2-todo.md` §Follow-ups:**

1. Static-analyzer capability auditing schema in governance manifest
   (R-8.2-02 successor).
2. Wider language style coverage (Rust, Go, Python) — explicitly
   reaffirmed out-of-scope for Phase 8.3.
3. Upstream Astaire: fractional `phase` tag support
   (`phase=8.3` first-class).
4. Upstream Astaire: `docs/planning/evaluations/` path-to-type table
   entry (suggested `evaluation`).
5. Upstream Astaire: `adapters/profiles/` path-to-type table entry
   (suggested `adapter-profile`).

## Scope

- Validator refactor: extract inline embedded-profile fail-closed gate
  and any sibling inline Python out of `scripts/validate_governance.sh`
  into a versioned stand-alone validator under `scripts/validators/`.
- Static-analyzer capability declaration schema in
  `contracts/governance-manifest.schema.json` (tightened from free-form
  string to structured per-pattern capability claim).
- Cross-phase closure chunk for R-8.2-05: open a closure-request
  artifact targeting `docs/planning/phase-8.1-risks.md` and define the
  closure criterion under Phase 8.3's accountability.
- Astaire upstream enhancement chunks (three small PRs to the
  `astaire/` submodule's `governance_authoring` / `ai_dev_governance`
  collection plugins; submitted as a single coordinated upstream batch).
- Phase 8.3 board review packet + sign-off (mirror SCN-8.2.5 shape).

## Non-goals

- Wider language style coverage (Rust, Go, Python).
- Re-tuning the 25 / 40 LOC function cap or the Power of 10 ~60-line
  ancestor footnote.
- Modifying the autonomous-delivery state machine or risk-tier matrix.
- Authoring Phase 8.1's reciprocal risk-log entry directly — Phase 8.3
  may only open the request and define the closure criterion.

## Principles adopted

**Closure requires reciprocity.** R-8.2-05 cannot be closed by Phase 8.3
alone; closure waits on the reciprocal entry in `phase-8.1-risks.md`
landing on `main`. Phase 8.3 owns the request, not the unilateral
closure.

**Validator factoring preserves fail-closed semantics.** Extracting
inline Python into a stand-alone validator MUST preserve the existing
17/17 pass and the negative-fixture rejection without behaviour drift.

**Schema tightening is additive.** Existing free-form analyzer strings
remain valid via a transitional `analyzerDeclaration.legacyString`
field; new manifests SHOULD use the structured form.

## Questions and Resolutions

Ambiguity scoring follows `core/PLANNING_METHODOLOGY.md`:
`score = sum(P * U * M * I) / sum(I)` with `P ∈ [0,1]`,
`U ∈ {0, 0.5, 1.0}`, `M ∈ [0,1]`, `I ∈ [1,5]`. Confidence `c ∈ [1,5]`.

### Q1 — How does Phase 8.3 own R-8.2-05 closure when the reciprocal artifact lives in Phase 8.1?

**Resolution.** Phase 8.3 authors a *closure-request packet* under
`docs/planning/cross-phase/r-8.2-05-closure-request.md` that (a) cites
SHA `5d47359`, the Cross-Phase In-Flight Coordination clause, and the
closure criterion verbatim; (b) lists the illustrative Phase 8.1
branches (`chunk-8.1.0-*`..`chunk-8.1.3-*`); (c) defines the verification
hook (Phase 8.3 sprint critique reads `phase-8.1-risks.md` on `main`
each iteration and flips R-8.2-05 to closed when the reciprocal entry +
analyzer evidence lands). The closure-request packet is the artifact
Phase 8.3 owns; the reciprocal entry remains Phase 8.1's responsibility.

**Rationale.** Methodology forbids one phase writing into another
phase's risk log unilaterally. A closure-request packet is the
auditable handoff, and the standing sprint-critique read is the
verification cadence. R-8.2-05 stays "open" in Phase 8.3 monitoring
until both sides of the bidirectional protocol are satisfied.

`P=0.45`, `U=0.5`, `M=0.20`, `I=5`, weighted impact `0.225`. Confidence `4`.

### Q2 — What is the factor-out boundary for the inline fail-closed gate?

**Resolution.** Extract the embedded-profile gate AND the agency-string
guard invocation into a stand-alone Python validator at
`scripts/validators/governance_gates.py` callable as
`python -m scripts.validators.governance_gates --manifest <path>`.
`scripts/validate_governance.sh` retains its top-level orchestration
(directory walks, fixture iteration, exit-code aggregation) but
delegates per-manifest verdict logic to the new validator. The existing
17/17 PASS and negative-fixture rejection MUST be preserved; the
factor-out chunk's acceptance is byte-identical exit codes against the
existing fixture suite plus new dedicated unit fixtures under
`validation/fixtures/validators/`.

**Rationale.** Bash is appropriate for orchestration; per-manifest YAML
parsing + conditional rule evaluation is poorly served by inline
Python heredocs. A stand-alone validator is unit-testable in isolation
and removes one source of bash-quoting fragility (FND-0007 root cause).

`P=0.30`, `U=0.5`, `M=0.15`, `I=4`, weighted impact `0.090`. Confidence `4`.

### Q3 — Are the three Astaire upstream enhancements in-scope for Phase 8.3, or deferred to upstream-only PRs?

**Resolution.** In-scope as a single coordinated SCN chunk targeting
the `astaire/` submodule. The submodule lives in this repo's working
tree; the three enhancements (fractional `phase` tag, `evaluations/`
path-to-type, `adapters/profiles/` path-to-type) are small,
independent, and unblock three current workarounds documented in
`phase-8.2-todo.md` §Follow-ups. The chunk lands a single commit in
the `astaire/` submodule, bumps the pin, and re-scans this repo to
verify the new types appear in the registry.

**Rationale.** Treating these as out-of-band upstream PRs delays
auditor-facing discoverability indefinitely. Bundling them in Phase
8.3 keeps the workaround-removal visible in this phase's evidence
bundle and tests the cross-repo coordination pattern in a low-risk
context.

`P=0.40`, `U=0.5`, `M=0.15`, `I=3`, weighted impact `0.090`. Confidence `4`.

### Q4 — What is the structured shape of the analyzer-capability declaration in the manifest schema?

**Resolution.** Add an `analyzerDeclaration` object to
`contracts/governance-manifest.schema.json` with shape:

```yaml
analyzerDeclaration:
  legacyString: "<free-form>"    # transitional, mutually exclusive with structured
  structured:
    analyzer: "<tool-name>"
    version: "<semver>"
    capabilitiesDetected:
      recursion: true
      unboundedLoops: true
      dynamicAllocationPostInit: true
      uncheckedReturnValues: true
    selfAttestedBy: "<accountable human>"
    attestationDate: "<ISO-8601>"
```

A new contract rule (`validation/CONSISTENCY_RULES.md` §16) requires
exactly one of `legacyString` or `structured` to be present. When
`structured` is present, all four capability booleans MUST be `true`
(any `false` fails the gate with a pointer to upgrade the analyzer or
declare an `core/EXCEPTIONS_AND_WAIVERS.md` entry).

**Rationale.** A boolean per pattern matches the four newly forbidden
P10 patterns one-to-one and makes capability gaps explicit. Self-
attestation by a named human preserves the human-accountability
boundary; the legacy-string field preserves backward compatibility for
manifests that haven't migrated.

`P=0.35`, `U=0.5`, `M=0.20`, `I=4`, weighted impact `0.140`. Confidence `4`.

## Ambiguity Gate

| Question | P | U | M | I | P·U·M·I | Confidence |
|---|---:|---:|---:|---:|---:|---:|
| Q1 R-8.2-05 closure ownership | 0.45 | 0.5 | 0.20 | 5 | 0.225 | 4 |
| Q2 Validator factor-out boundary | 0.30 | 0.5 | 0.15 | 4 | 0.090 | 4 |
| Q3 Astaire upstream scope | 0.40 | 0.5 | 0.15 | 3 | 0.090 | 4 |
| Q4 Analyzer-capability schema | 0.35 | 0.5 | 0.20 | 4 | 0.140 | 4 |
| **Totals** | | | | **16** | **0.545** | |

- Weighted impact total: `0.545`
- Sum of `I`: `16`
- **Ambiguity score: `0.545 / 16 = 0.0341`** ≤ `0.20` ✅
- **Average confidence: `(4 + 4 + 4 + 4) / 4 = 4.0`** ≥ `4.0` ✅

Gate passed. Phase 8.3 cleared to proceed past bootstrap.

## Linked artifacts (to be produced under SCN-8.3.0)

- Chunk plan: `docs/planning/chunks/phase-8.3-chunks.md`
- Risks: `docs/planning/phase-8.3-risks.md`
- TO-DO: `docs/planning/phase-8.3-todo.md`
- Closure-request packet (under SCN-8.3.x): `docs/planning/cross-phase/r-8.2-05-closure-request.md`
