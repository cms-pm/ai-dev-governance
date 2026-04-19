# Board Composition Approval — 2026-04-19

## Composition Metadata

- Board ID: `BRD-2026-04`
- Effective Date: 2026-04-19
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

## Seat Assignments

| Seat Role | Lens | Primary Member ID | Alternate Member IDs |
|---|---|---|---|
| Architecture Steward | architecture | BM-001 | BM-008 |
| Reliability Steward | reliability | BM-002 | — |
| Security Steward | security | BM-003 | — |
| Performance Steward | performance | BM-004 | — |
| Operability Steward | operability | BM-005 | — |
| Cognitive-Load Steward | cognitive-load | BM-006 | — |
| Agentic-AI Steward | agentic-AI-systems | BM-007 | BM-009 |

## Seat-to-SCN Responsibility Notes

- **Security Steward (BM-003)** — primary reviewer of SCN-1.6 (data-transmitting
  adapter amendment) and SCN-3.4 (dogfood `restricted` security mode).
- **Architecture Steward (BM-001) + Cognitive-Load Steward (BM-006)** —
  co-owners of the SCN-4.0 routing-grammar review.
- **Agentic-AI Steward (BM-007)** — primary reviewer of the SCN-3.1 bridge
  spike and SCN-3.3 skeleton-promotion importer.
- **Performance Steward (BM-004)** — primary reviewer of token-budget
  discipline (SCN-4.2) and L0/L1/L2 latency claims.
- **Reliability Steward (BM-002)** — primary reviewer of the
  autonomous-delivery state-machine fail-closed posture for high-tier chunks
  (SCN-3.1, SCN-3.3).
- **Operability Steward (BM-005)** — primary reviewer of runbook additions
  (SCN-3.5, SCN-4.1, SCN-4.2) and release-evidence bundle ergonomics
  (SCN-2.4).

## Coverage Check

- All lenses covered: **true**.
- Uncovered lenses: **none**.
- Alternate coverage gaps: reliability, security, performance, operability,
  and cognitive-load lenses ship without alternates in this cycle.
  Mitigation: inaugural board; alternates added at the 2026-07 quarterly
  refresh, prioritising lenses that owned high-tier SCNs during Phase 3.

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

## Post-Approval Next Steps

1. Chair records approval above with explicit acceptance of the
   expert-informed-simulation positioning.
2. Methodology Steward ingests the book + primary-blog corpora listed in
   `BM-001..BM-009.md` into `raw/` under SCN-2.3 so board simulations can
   cite inspectable evidence.
3. First sprint-critique packet scheduled for the week of the SCN-3.1
   board gate (target: pre-Phase-3 kickoff).
4. Opportunity register initialised at
   `docs/planning/board/committee-opportunity-register-phase-1-2026-04-19.md`.
