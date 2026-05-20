---
description: Run the test-design-reviewer skill against the named pytest suite and produce a Farley 8-property scorecard under docs/evidence/farley/.
argument-hint: <suite path or module> [optional date override]
---

Load the `test-design-reviewer` skill. The skill's source of truth is
`core/BOARD_REVIEW_GOVERNANCE_METHODOLOGY.md` §Test-Design Lens.

Target suite: `$ARGUMENTS` (default: `astaire/tests/`).

Steps:

1. Enumerate test files in the target.
2. Sample tests per the skill's workflow; score each of the eight
   properties 1-5 with a one-sentence rationale and a specific test
   reference.
3. Write the scorecard to
   `docs/evidence/farley/<suite-slug>-<YYYY-MM-DD>.md`.
4. Run `.astaire/astaire scan --root .` so the file registers as
   `farley-scorecard`.
5. Report the aggregate score and any property scoring <= 2.

Cite every quoted directive back to its `core/` source per the
authority boundary in Phase 9 Q4.
