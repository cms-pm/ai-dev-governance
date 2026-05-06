# HiL/SiL Predicate Router Adapter

## Purpose

Defines a token-governance pattern for teams running Hardware-in-the-Loop (HiL)
or Software-in-the-Loop (SiL) validation through AI-assisted workflows. Routes
deterministic capture-and-compare work off the high-context architect agent
onto a lightweight worker that consumes a pinned `predicate.json`, captures
output, diffs it against the predicate, and returns a structured verdict.

## Applicability

- Adapter is OPTIONAL. Projects with substantial HiL or SiL evidence capture
  in their phase plans SHOULD adopt it; projects with only unit/integration
  testing MAY skip it.
- Layered alongside provider adapters (`providers/claude`, `providers/codex`)
  and the RTK adapter (`tooling/rtk`). Does not replace them.
- Compatible with the contract test hygiene rule in
  `core/AI_ASSISTED_TDR_METHODOLOGY.md` and the scenario status vocabulary
  in `core/EVIDENCE_CONTRACT.md`.

## Required Artifacts

- `predicate.json` per scenario, stored under
  `docs/validation/<phase>/predicates/<scn-id>.json`. Schema is project-local
  during pilot; will be ratified once a representative cross-project sample
  has accumulated.
- A predicate runner script that reads the predicate, drives the HiL/SiL CLI,
  captures output, diffs against the predicate, and emits one ledger line
  per scenario in the form
  `{scn, status, evidence_uri, predicate_hash}`.
- `status` MUST be one of the values in the Scenario Status Vocabulary
  (`core/EVIDENCE_CONTRACT.md`).

## Routing Contract

- The architect-tier agent (Opus or equivalent) authors `predicate.json` once
  at chunk-plan time, reviews scope, and signs off.
- HiL/SiL CLI execution dispatches to a worker-tier agent (Haiku or
  equivalent) with a fixed system prompt:

  > Run command `X`, capture output, diff against predicate `Y`, emit
  > `{scn, status, evidence_uri}` JSON. Do not load architecture context.
  > Do not paraphrase the predicate.

- The worker-tier agent MUST NOT load the chunk plan, board packets, or
  prior architecture documents.
- The architect-tier agent re-engages only when the worker reports
  non-empty diff, an unexpected `status`, or `environment_unavailable`.

## Predicate Shape (provisional)

```json
{
  "schema_version": "0.1.0-pilot",
  "scn_id": "SCN-<phase>.<chunk>-<nn>",
  "scenarios": {
    "SCN-<phase>.<chunk>-<nn>": {
      "predicate_kind": "<one of the project-local enum values>",
      "...": "..."
    }
  },
  "routing_hint": {
    "haiku_eligible": ["SCN-..."],
    "in_process":     ["SCN-..."]
  }
}
```

`predicate_kind` is project-local during pilot. Examples observed in the
Phase 8 pilot: `queue_depth_at_least`, `all_symbols_declared`,
`status_field_additive`, `any_pair_present`, `fsm_no_transition`,
`fsm_must_transition`, `prior_contracts_importable`.

`routing_hint.haiku_eligible` lists the scenarios the architect has
pre-cleared for worker-tier execution. `routing_hint.in_process` lists
scenarios the architect must run themselves (typically because the diff
requires architectural judgment).

## Operating Rules

- The predicate file is the contract between tiers. The architect MUST
  treat predicate authorship as a load-bearing artifact, not a comment.
- The worker MUST NOT mutate the predicate. If the predicate is wrong,
  the worker reports `failing` with the captured evidence and the
  architect amends the predicate in a separate, reviewable commit.
- A predicate change MUST be a deliberate diff event — coupling a
  predicate change with an implementation change in the same commit
  defeats the routing pattern.
- The runner script MUST tolerate environment-unavailable states
  (missing hardware, missing broker socket) by emitting `skipped`
  intermediate state and a non-zero exit; the architect resolves to
  one of the five vocabulary values before sign-off.

## Evidence Requirements

- Per-run ledger output (one JSONL line per scenario) MUST be appended
  to a project-declared ledger path. Recommended:
  `artifacts/validation/scenario_ledger.jsonl`.
- Each line MUST carry `predicate_hash` (SHA-256 of the predicate file at
  run time) so future audits can detect predicate drift independent of
  scenario status.
- Release evidence under `core/EVIDENCE_CONTRACT.md` SHOULD include the
  per-phase scenario ledger when this adapter is declared.

## Token-Savings Posture

- The primary lever is the order-of-magnitude per-chunk cost gap between
  architect-tier and worker-tier inference. Routing HiL/SiL captures
  through the worker tier plausibly cuts per-chunk closeout token cost
  by an order of magnitude on chunks dominated by capture-and-compare
  work.
- Projects adopting this adapter SHOULD record routing telemetry (count
  of scenarios dispatched per tier, worker re-engagement rate) in the
  release evidence record alongside `rtk gain` / `rtk discover` output
  per the RTK adapter.

## Compatibility

- `core/AI_ASSISTED_TDR_METHODOLOGY.md` — Contract Test Hygiene: the
  worker-tier predicate runner MUST NOT use silent-skip mechanisms;
  pending-implementation scenarios use the runner's expected-fail
  surface or resolve to `expected-fail` in the ledger.
- `core/EVIDENCE_CONTRACT.md` — Scenario Status Vocabulary: the runner
  emits values from the enumerated set.
- `tooling/rtk` — RTK Context Adapter: predicate-runner shell
  invocations should be RTK-rewritten where possible to compound
  the savings.
- Astaire `scenario-ledger` collection (proposed) consumes the
  per-line ledger output for cross-session, low-token state recall.

## Pilot Reference

The first consumer of this adapter is cms-pm/cockpit Phase 8:

- Predicate pilot:
  `docs/validation/phase-8/predicates/scn-8.0t.json`
- Runner script:
  `scripts/validation/run_phase8_0t_fast_queue_backpressure.py`
- Amendment package context:
  `docs/governance/amendments/2026-05-04-test-hygiene-tdr-amendment-package.md`

Once a second project adopts the adapter, the predicate schema will be
promoted out of `0.1.0-pilot` into a ratified contract under
`contracts/`.
