# Test Design Review Runbook

Operational guide for applying the test-design lens in
`core/BOARD_REVIEW_GOVERNANCE_METHODOLOGY.md`. The core methodology
remains the source of authority for board cadence, finding shape, and
gate outcomes.

## Purpose

Use this runbook when preparing a Farley scorecard, reviewing mutation
evidence, or briefing a board packet on test-suite effectiveness.

## Inputs

- Current chunk or phase plan.
- Relevant acceptance IDs and risk tiers.
- Latest pytest result.
- Mutation report when the risk tier calls for one.
- Existing characterisation or seam-map evidence.

## Farley Scorecard Flow

1. Review the suite against the eight properties in the board
   methodology: authentic, repeatable, predictable, independent,
   specific, empathetic, fast, and necessary.
2. Score each property from 1 to 5.
3. Attach concrete evidence: commands, representative test files, and
   notable gaps.
4. Convert the highest-value gaps into board findings or follow-up
   planning items.
5. Register the scorecard under `docs/evidence/farley/`.

## Interpretation

Scores are directional evidence, not a replacement for failing tests or
mutation survivors. A high score with untriaged mutation survivors still
needs survivor disposition. A low score with strong mutation results
usually indicates maintainability or reviewability issues rather than
runtime gaps.

## Output Shape

The scorecard should include:

- scope and date,
- command evidence,
- one row per property,
- an average score,
- findings and recommendations,
- links to mutation and characterisation evidence where relevant.

## Board Integration

Use the scorecard as the test-design lens input in board packets. The
packet can cite the scorecard directly instead of repeating every row.
