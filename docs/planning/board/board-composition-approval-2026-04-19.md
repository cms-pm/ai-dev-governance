# Board Composition Approval — 2026-04-19

## Composition Metadata

- Board ID: `BRD-2026-04`
- Effective Date: 2026-04-19
- Target Composition: **lean board** — chair selects from the 22-candidate
  pool at `docs/planning/board/board-selection-dossier-2026-04-18.md`.
  Default target size is 3 seats; see §Chair Decision Required in the dossier
  for the 3-vs-4 trade-off imposed by the 7-lens / 2-lens-per-member ceiling.
- Refresh Cadence: quarterly (next refresh target 2026-07)
- Incident-Refresh Trigger: any severity=Critical finding involving a lens
  whose steward is newly introduced, any corpus-accessibility regression for
  a seated member, or chair-initiated refresh under
  `core/BOARD_REVIEW_GOVERNANCE_METHODOLOGY.md` §Expert-Agent Board Selection.
- Required Lenses: architecture, reliability, security, performance,
  operability, cognitive-load, agentic-AI-systems (domain-specific)
- Source Dossier: `docs/planning/board/board-selection-dossier-2026-04-18.md`
- Positioning: all seats filled by **expert-informed-simulation** personas per
  `core/AUTONOMOUS_DELIVERY_GOVERNANCE.md` §Simulation Positioning. No real
  individual named in the dossier is a participant.

## Selection Invariants

Any chair-selected board composition MUST satisfy:

1. **Lens coverage.** The union of `{primary, secondary}` lens declarations
   across seated members covers all 7 required lenses, OR a written
   deferral is recorded for any uncovered lens (see dossier §Chair
   Decision Required).
2. **Eligibility.** Every seated member has `Eligible: true` in the scoring
   table (RoleFit ≥ 4, EvidenceAccessibility ≥ 4, WeightedAverage ≥ 4.0).
3. **Positioning acknowledgement.** The chair records explicit acceptance of
   the expert-informed-simulation framing.
4. **Agentic-AI presence.** At least one seated member MUST carry
   `agentic-AI-systems` as primary or secondary, because the project's
   core domain is agentic AI.
5. **No conflicts.** Simulation framing removes conflict-of-interest by
   construction; any real-world disclosure obligations remain the chair's to
   surface.

## Seat Assignments

**Status: UNFILLED — awaiting chair selection.**

The prior 7-seat one-per-lens pre-assignment has been retired. The chair, once
approved, will select N members from BM-001..BM-022 and record them here.

| # | Member ID | Primary Lens | Secondary Lens | Notes |
|---|---|---|---|---|
| 1 | PENDING | — | — | — |
| 2 | PENDING | — | — | — |
| 3 | PENDING | — | — | — |
| 4 | PENDING (if Lean-4) | — | — | — |

## Seat-to-SCN Responsibility Notes

To be populated by the chair after seat assignments are recorded. Guidance:

- SCN-1.6 / SCN-3.4 (security surface) requires a seated reviewer whose
  lens set includes `security`, OR a recorded security-lens deferral plus a
  named ad-hoc consultant.
- SCN-4.0 (port-of-first-resort routing grammar) benefits from a reviewer
  carrying both `architecture` and `cognitive-load` — e.g. BM-010, BM-018.
- SCN-3.1 (bridge spike) benefits from a reviewer carrying
  `agentic-AI-systems` with eval discipline — e.g. BM-021, or BM-020 for
  routing-model critique lineage.
- SCN-4.2 (token-budget discipline) benefits from a reviewer carrying
  `performance` — e.g. BM-004, BM-014, BM-015, or BM-020 as secondary.

## Coverage Check

To be re-run against the filled seat table at chair sign-off. Approval is
blocked until all 7 required lenses are covered or a written deferral is
recorded per invariant (1).

## Conflicts Re-Check

- No conflicts of interest identified at composition approval time.
  Simulation framing removes conflict surface by construction; the
  named real-world corpus authors are not participants.

## Chair Approval

- Status: **PENDING**
- Chair Approver: PENDING (default candidate: **cms-pm**, same approver who
  signed the planning gate; redirect if a different chair should be
  designated before the first sprint-critique session)
- Approved At: PENDING (ISO-8601 UTC required at chair sign-off)
- Conditions (if any): PENDING
- Board-Size Decision: PENDING — chair to record Lean-3-with-deferral,
  Lean-4, or Lean-3-triple-lens per dossier §Chair Decision Required.
- Positioning Acknowledgement: PENDING — chair to affirm
  expert-informed-simulation framing.

## Post-Approval Next Steps

1. **Chair approval recorded.** Chair selects board-size option and records
   approval above with explicit acceptance of the
   expert-informed-simulation positioning.
2. **Member selection.** Chair picks N members from the pool following the
   same scoring-table + lens-coverage discipline used to build the pool,
   then records picks in §Seat Assignments. Each pick SHOULD be accompanied
   by a 1-line rationale tying the member's declared lenses to specific
   SCN responsibilities.
3. **Coverage verification.** Chair re-runs §Coverage Check against the
   filled seat table and records `PASS` or documents the deferral(s).
4. **Seat-to-SCN mapping.** Chair populates §Seat-to-SCN Responsibility
   Notes.
5. **Corpus ingestion (seated only).** Methodology Steward ingests the book
   + primary-blog corpora for **seated** members only (not the full pool)
   into `raw/` under SCN-2.3.
6. First sprint-critique packet scheduled for the week of the SCN-3.1
   board gate (target: pre-Phase-3 kickoff).
7. Opportunity register already initialised at
   `docs/planning/board/committee-opportunity-register-phase-1-2026-04-19.md`.
