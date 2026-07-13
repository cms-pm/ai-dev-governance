# Harness Metrics

## Purpose

This core policy defines the metrics feedback system that lets an
autonomous delivery harness's own guardrails be tuned from measured
evidence, rather than asserted once and left static. It closes the loop
described in `core/AUTONOMOUS_DELIVERY_GOVERNANCE.md`'s loop primitives
(schedule, maker, separate checker, state-on-disk): guardrails produce
metrics, and metrics tune guardrails.

Keywords MUST, SHOULD, and MAY are normative.

## Scope

This document defines metric-family doctrine, the emit-contract shape,
and the tuning cadence. **It does not ship an ADG-side collector,
writer, or storage engine.** Consistent with `core/ACCEPTANCE_INTEGRITY.md`'s
already-established consumer-side-enforcement precedent, each consumer
implements its own writer against the version-pinned row schema in
`contracts/` and declares its storage engine and schema version in its
own governance manifest (see `contracts/governance-manifest.schema.json`
`harnessMetrics` property). No ADG-side validator consumes these values
at this release; treat any illustrative defaults as tune-before-use.

## Metric Families

Every gate run, audit, board review, and waiver event under this policy
MAY emit rows in one or more of the following families. A consumer
declaring `harnessMetrics` in its manifest MUST implement at least the
families relevant to the mechanisms it has adopted from
`core/ACCEPTANCE_INTEGRITY.md`.

1. **Verdict integrity.** Hollow-verdict rate, unverified-intent rate,
   intent-assertion coverage (percentage of passing gates with at least
   one adversarial/anti-proxy check), acceptance mode distribution.
2. **Drift-catch.** Count of specification-evasion incidents caught, by
   catching stage (automated checker vs. human read-gate vs. post-merge);
   mean time to catch; escaped-defect count (an incident caught only
   after a gate already reported a passing verdict — the bottleneck
   metric this family exists to surface).
3. **Checker effectiveness.** Findings per run, false-positive rate,
   loop iterations to a clean state, percentage of maker output rejected
   by the separate checker.
4. **Harness integrity (gate-mutation).** Gate-mutation kill rate (a
   known violation is injected into a gate's input; the gate MUST FAIL);
   percentage of gates with an associated mutation test; count of
   surviving gate-mutants (a gate that passes a planted violation is
   rotted). **This family is declared-but-unpopulated until its
   fast-follow collector mechanism lands** — a consumer MAY emit an
   explicit absent/deferred marker for this family rather than omitting
   it silently; see the no-silent-zero rule below.
5. **Waiver health.** Active and expired waiver counts, waiver-to-fix
   latency, percentage of hard requirements met vs. waived (per
   `core/EXCEPTIONS_AND_WAIVERS.md`).
6. **Leverage/cost.** Tokens per iteration, unattended iterations before
   a human intervention is required, operator-touch-rate (how often a
   human had to act as the separate checker — a rate this family exists
   to trend downward over time).

## Row Schema

The per-row emit-contract schema is defined in
`contracts/harness-metrics-row.schema.json`, **versioned independently
of `governanceVersion`** via its own `schemaVersion` field. The schema
is deliberately **engine-agnostic**: it defines field names and types
only, with no commitment to a JSONL, SQLite, or any other concrete
storage format. A consumer implementing a writer MUST declare which
`schemaVersion` it targets and which storage engine it uses in its own
governance manifest (`harnessMetrics.schemaVersion`,
`harnessMetrics.engine`) — the same declare-your-instantiation pattern
`acceptanceIntegrity` already established for a generic ADG contract
with consumer-side enforcement.

## No-Silent-Zero Rule

A metric family whose producer has not run, or is not yet instrumented,
MUST emit an explicit absent/opt-out marker rather than a fabricated
zero or default value. A downstream tuning rule reading a family's
values MUST be able to distinguish "measured and zero" from "not
measured" without inferring it from context. This rule applies in
particular to family 4 (harness integrity), which is
declared-but-unpopulated at this release per the Metric Families section
above.

## Tuning Cadence

Thresholds this system exists to tune (non-triviality floors, mutation
cadence, intent-coverage targets, mode-promotion bars — see
`core/ACCEPTANCE_INTEGRITY.md` and `core/MUTATION_EVIDENCE.md`) live as
config in the consuming project's own governance manifest, not in this
document. A review cadence, mirroring the exception review cadence in
`core/EXCEPTIONS_AND_WAIVERS.md`, MUST periodically re-derive threshold
recommendations from the accumulated metric rows — for example: a
sustained zero hollow-verdict rate across a defined number of review
cycles is grounds to relax an intent-coverage requirement; a rising
escaped-defect count is grounds to tighten a mode-promotion bar or raise
mutation cadence. This document does not mandate a specific cadence
length; the consuming project's manifest declares it.

## Disambiguation from Other Ledgers

A consumer's harness-metrics storage MUST be documented as a separate
database or schema from any other per-consumer evidence ledger it
maintains (for example, a mutation-report store or a performance-event
store), and the two MUST NOT be joined on a shared key without an
explicit, separately-reviewed data-model decision. This is a
documentation requirement, not new ADG machinery: it extends this
policy's existing collision-naming discipline to storage-engine choices
made entirely on the consumer side.

## Cross-References

- `core/ACCEPTANCE_INTEGRITY.md` — the consumer-side-enforcement
  precedent this policy's placement follows; the mechanisms (M1-M4)
  whose health families 1-5 above measure.
- `core/MUTATION_EVIDENCE.md` — the tier-threshold-table format this
  policy's consumer-declared thresholds mirror; family 4 extends
  mutation-testing evidence from tests to gates themselves.
- `core/EXCEPTIONS_AND_WAIVERS.md` — the review-cadence pattern this
  policy's tuning cadence mirrors; family 5's source data.
- `core/GATE_DESIGN.md` — the PARTIAL verdict and margin-reporting
  discipline that families 1 and 3 above measure adherence to.
- `contracts/harness-metrics-row.schema.json` — the versioned,
  engine-agnostic per-row schema.
- `contracts/governance-manifest.schema.json` — the `harnessMetrics`
  declaration property.
