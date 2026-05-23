---
name: tdd
description: ADG RED-GREEN-MUTATE-KILL-REFACTOR cycle for Python/pytest. Use for every code change that lands under an SCN with risk tier >= medium. Source of truth is core/AI_ASSISTED_TDR_METHODOLOGY.md §TDR-RGM.
---

# tdd — Test-Driven Requirements cycle (pytest flavour)

**Source of truth:** `core/AI_ASSISTED_TDR_METHODOLOGY.md` §TDR-RGM
(Red-Green-Mutate). All normative directives live in that document — this
skill contains workflow ergonomics only and cites the source for every
quoted rule.

## When to load

- Authoring a pytest test for a new acceptance ID under any SCN.
- Resuming an in-flight TDR-RGM cycle and needing the next-step prompt.
- A board lens flags "missing RED-phase test" during sprint critique.

## Cycle (pytest)

```
RED        → write the failing pytest first; assert the acceptance
              behaviour the SCN names. Run it; confirm the failure
              message points at the missing production call, not at a
              syntax or import slip.
GREEN      → minimum implementation that flips the test from red to
              green. No speculative branches, no helpers without a
              second failing test demanding them.
MUTATE     → run the mutation harness (load the `mutation-testing`
              skill); record survivors with disposition column.
KILL       → strengthen the test or add a sibling test until each
              non-equivalent survivor is killed. Equivalent mutants
              follow the exception protocol in
              `core/MUTATION_EVIDENCE.md` §Equivalent Mutants.
REFACTOR   → only after the mutate/kill pass is green. Apply the
              refactor onramp from
              `core/CODE_IMPLEMENTATION_COMPLEXITY_GOVERNANCE.md`
              §Refactor Plan when the rubric scores >= 2. In a
              CodeGraph-declared consumer, run a CG impact,
              caller/callee, context, or explore query before native
              spidering or the first production refactor edit.
```

Reference to the normative rule (quoted, not authored): from
`core/AI_ASSISTED_TDR_METHODOLOGY.md` §TDR-RGM —
> "RED-first acceptance test required at risk-tier >= medium."

## Pytest scaffolding

- Tests live next to their bounded context (e.g.
  `astaire/tests/test_<module>.py`).
- Use `pytest.mark.parametrize` for boundary tables instead of looped
  asserts.
- Use the `tmp_path` fixture for any disk write; never write under the
  repo root from a test.
- For SQLite tests, parametrize against an in-memory database via the
  existing `astaire/tests/conftest.py` fixtures.

## Evidence linkage

Each SCN's evidence bundle references the test path under
`mutationReportURI` and `farleyScorecardURI` slots once the
`mutation-testing` and `test-design-reviewer` skills run downstream.
See `core/EVIDENCE_CONTRACT.md` for the per-acceptance URI contract.

## Smoke check

Load this skill, write a one-assertion failing pytest against a stub
function in a scratch fixture under `validation/fixtures/mutation/`,
run it, then add the minimal implementation. Confirm RED → GREEN
locally; attach the diff to the SCN evidence bundle.

## Provenance

Structure adapted from
`raw/skills-entourage/skills/tdd/SKILL.md` (Vitest / TypeScript
original); ADG version targets pytest and delegates all normative
authority to `core/AI_ASSISTED_TDR_METHODOLOGY.md`.
