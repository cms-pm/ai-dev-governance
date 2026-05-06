# Scenario Ledger Runbook

## Purpose

Defines the per-SCN status ledger that backs the Scenario Status
Vocabulary (`core/EVIDENCE_CONTRACT.md`) and the HiL/SiL Predicate
Router adapter (`adapters/tooling/HIL_SIL_PREDICATE_ROUTER.md`). The
ledger is a JSONL artifact written by contract test suites and HiL/SiL
predicate runners; future agents read state from the ledger in roughly
200 tokens instead of re-deriving from chunk plans, contract tests, and
evidence records.

## Applicability

- Required for projects that adopt the HiL/SiL Predicate Router adapter.
- Recommended for any project running contract test suites that exercise
  the Path A tombstone pattern (one test per ratified SCN).

## Ledger Format

JSONL, one row per scenario-run event, appended only. Default location:
`artifacts/validation/scenario_ledger.jsonl`.

Each row MUST include:

| Field            | Type   | Notes                                                  |
|------------------|--------|--------------------------------------------------------|
| `scn`            | string | Scenario ID (e.g. `SCN-8.0t-03`)                       |
| `status`         | enum   | One of the five values in the Scenario Status Vocabulary |
| `ts`             | float  | Unix epoch seconds when the row was written            |
| `evidence_path`  | string | Path or URI of the evidence artifact (nullable)        |
| `branch`         | string | Git branch at write time (sourced from `GIT_BRANCH`)   |

Each row SHOULD include when available:

| Field            | Type   | Notes                                                  |
|------------------|--------|--------------------------------------------------------|
| `predicate_hash` | string | SHA-256 of the predicate file driving the run         |
| `tool`           | string | Test tool / runner identifier                          |
| `env_profile`    | string | Environment profile name (HiL, SiL, unit, etc.)        |

## Writer Contract

- Writers MUST validate `status` against the five-value enum before
  appending. Invalid values MUST raise rather than write.
- Writers MUST be append-only. Existing rows MUST NOT be rewritten;
  status corrections MUST be expressed as a new row whose `ts` is later
  than the row it supersedes.
- Writers MUST tolerate concurrent appends (open with append mode and
  newline-terminated JSON encoding).
- Writers SHOULD emit `predicate_hash` whenever a predicate file drives
  the run.

## Reader Contract

- The current status of a scenario is the row with the latest `ts` for
  that `scn`.
- Readers MUST NOT treat the absence of a row as `passing`. Absent rows
  resolve to `not-started`.
- Readers MAY compute per-predicate drift by grouping rows by
  `(scn, predicate_hash)` and detecting status changes within a fixed
  predicate.

## Astaire Collection (proposed)

The ledger is the file-system source of truth. Astaire SHOULD ingest
the ledger as a `scenario-ledger` collection with one document per
unique `(scn, predicate_hash)` pair, storing the latest row state
plus the count of historical rows. This gives agents an
O(N-scenarios) projection rather than reading raw JSONL on every
session.

Tracking issue: [`cms-pm/astaire#16`](https://github.com/cms-pm/astaire/issues/16).

The companion `scenario-predicate` collection (one document per
`predicate.json`, keyed by `predicate_hash`) is tracked at
[`cms-pm/astaire#17`](https://github.com/cms-pm/astaire/issues/17)
and supplies the right-hand side of the join.

## Pilot Reference

cms-pm/cockpit Phase 8:

- Writer:
  `tests/_contract_support.py` — `record_scenario(scn_id, status, …)`
  appends to `artifacts/validation/scenario_ledger.jsonl` and
  validates against the five-value enum.
- HiL writer (deferred to hardware-bearing session):
  `scripts/validation/run_phase8_0t_fast_queue_backpressure.py` —
  emits `{scn, status, evidence_uri}` per scenario.
- Predicate registry:
  `docs/validation/phase-8/predicates/scn-8.0t.json`.

## Compatibility

- `core/EVIDENCE_CONTRACT.md` — Scenario Status Vocabulary defines
  the `status` enum.
- `core/AI_ASSISTED_TDR_METHODOLOGY.md` — Contract Test Hygiene
  governs which scenarios SHOULD appear in the ledger and with what
  initial status.
- `adapters/tooling/HIL_SIL_PREDICATE_ROUTER.md` — defines the
  worker-tier emission contract whose output lands in the ledger.
- `tooling/rtk` — RTK Context Adapter: ledger writes occur during
  RTK-rewritten test invocations; no special treatment required.

## Schema Promotion Path

The ledger row schema is provisional. Promotion criteria:

1. A second project adopts the runbook and writes the same row shape
   without bespoke fields.
2. The Astaire `scenario-ledger` collection ingests the rows
   end-to-end and emits a useful L1 projection.
3. The schema is moved into `contracts/scenario-ledger.schema.json`
   and version-pinned alongside the manifest schema.

Until promotion, projects MAY add bespoke fields under a `local_*`
prefix; readers MUST ignore unknown keys.
