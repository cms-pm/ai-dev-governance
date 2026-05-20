---
name: test-design-reviewer
description: Score a pytest test suite against Dave Farley's eight test-design properties and produce a Farley scorecard for the SCN evidence bundle. Source of truth is core/BOARD_REVIEW_GOVERNANCE_METHODOLOGY.md §Test-Design Lens.
---

# test-design-reviewer — Farley 8-property scorecard

**Source of truth:** `core/BOARD_REVIEW_GOVERNANCE_METHODOLOGY.md`
§Test-Design Lens (the eighth required board lens) and the inline
Farley 8-property scorecard rubric registered there. This skill turns
that rubric into an artifact the test-design lens can review.

## When to load

- A board review packet is being assembled and the test-design lens
  needs a Farley scorecard for the target test suite.
- The `farleyScorecardURI` evidence slot is missing for an SCN that
  declares the `architectureFitness` or `mutation` analyzer block.

## The eight properties (quoted from the source-of-truth rubric)

> 1. Behaviour-focused
> 2. Isolated
> 3. Repeatable
> 4. Fast
> 5. Self-checking
> 6. Deterministic
> 7. Maintainable
> 8. Targeting one reason to change

Each property is scored 1-5 with a one-sentence rationale and at least
one example test path cited. The scorecard's structure is the rubric
template referenced in `core/BOARD_REVIEW_GOVERNANCE_METHODOLOGY.md`
§Test-Design Lens.

## Output template

```
# Farley scorecard — <suite name> — <DATE>

| Property | Score (1-5) | Rationale | Example test |
|---|---|---|---|
| Behaviour-focused | … | … | astaire/tests/test_<x>.py::test_<y> |
| Isolated | … | … | … |
| Repeatable | … | … | … |
| Fast | … | … | … |
| Self-checking | … | … | … |
| Deterministic | … | … | … |
| Maintainable | … | … | … |
| Targeting one reason to change | … | … | … |

## Aggregate
- Sum: <0-40>
- Recommendations: …
```

File location:
`docs/evidence/farley/<suite>-<DATE>.md` (registered as
`farley-scorecard` by the Astaire `governance_authoring` plugin path
entry added at SCN-9.2).

## Workflow

1. Enumerate test files in scope (`find astaire/tests -name 'test_*.py'`).
2. Sample at least 10% of tests per property; cite specific test names.
3. Score each property; flag any score <= 2 with a recommendation.
4. Write the scorecard file; register with `.astaire/astaire scan`.

## Smoke check

Score `astaire/tests/test_registry.py` against the eight properties;
publish a one-page scorecard under `docs/evidence/farley/`; confirm
Astaire scan registers it as `farley-scorecard`.

## Provenance

Structure adapted from
`raw/skills-entourage/skills/test-design-reviewer/SKILL.md`
(TypeScript original); ADG version targets pytest suites and
delegates all normative authority to
`core/BOARD_REVIEW_GOVERNANCE_METHODOLOGY.md`.
