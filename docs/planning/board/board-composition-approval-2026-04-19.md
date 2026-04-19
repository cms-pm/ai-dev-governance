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

**Status: FILLED — awaiting chair sign-off.**
Board size: **Lean-4** (per chair directive, 2026-04-19).

| # | Role | Member (name) | ID | Primary Lens | Secondary Lens | Weighted Avg | Rationale |
|---|---|---|---|---|---|---|---|
| 1 | Chair + Agentic-AI Steward | Simon Willison | BM-007 | agentic-AI-systems | — | 4.8 | Chair appointment per user directive 2026-04-19. Owns SCN-3.1 bridge spike and SCN-3.3 skeleton-promotion importer; prompt-injection corpus directly informs SCN-1.6 and SCN-3.4 security surface. |
| 2 | Cognitive-Load + Reliability Steward | Will Larson | BM-012 | cognitive-load | reliability | 4.8 | Highest-scoring multi-lens candidate. *Staff Engineer* / *An Elegant Puzzle* corpus directly applicable to port-of-first-resort cognitive-load discipline (SCN-4.0) and to reliability of rollout cadence. |
| 3 | Security + Operability Steward | Troy Hunt | BM-016 | security | operability | 4.4 | HIBP + practitioner web-security corpus covers the SCN-1.6 data-transmission threat surface while the operability secondary covers runbook ergonomics (SCN-3.5, SCN-4.1, SCN-4.2). |
| 4 | Performance + Architecture Steward | Martin Thompson | BM-014 | performance | architecture | 4.2 | Mechanical-sympathy + LMAX/Aeron corpus provides the rigor needed for L0/L1/L2 latency claims (SCN-4.2) and architecture review of the routing-first topology (SCN-4.0). |

**Why this trio (post-chair).** Larson + Hunt + Thompson is the *only* valid
3-member partition of the remaining 6 required lenses with no redundancy, and
it simultaneously maximises Σ(weighted-average) = **13.4** among all
coverage-complete trios. Composition total Σ = 13.4 + Willison's 4.8 = **18.2**.

## Seat-to-SCN Responsibility Notes

- **Simon Willison (Chair, Agentic-AI; BM-007)** — primary reviewer of
  SCN-3.1 (bridge spike), SCN-3.3 (skeleton-promotion importer); co-reviewer
  of SCN-1.6 / SCN-3.4 given prompt-injection corpus overlap with the
  security surface. Final tie-breaker on all board decisions in chair
  capacity.
- **Will Larson (Cognitive-Load + Reliability; BM-012)** — primary reviewer
  of SCN-4.0 (port-of-first-resort routing grammar) on the cognitive-load
  dimension; secondary reviewer of fail-closed state-machine posture
  (SCN-3.1, SCN-3.3).
- **Troy Hunt (Security + Operability; BM-016)** — primary reviewer of
  SCN-1.6 (data-transmitting adapter amendment) and SCN-3.4 (`restricted`
  security mode); secondary reviewer of SCN-3.5 / SCN-4.1 / SCN-4.2 runbooks
  and SCN-2.4 release-evidence bundle.
- **Martin Thompson (Performance + Architecture; BM-014)** — primary
  reviewer of SCN-4.2 (token-budget discipline) and L0/L1/L2 latency claims;
  secondary reviewer of SCN-4.0 architecture, and of any tentacle-sprawl
  concerns raised during SCN-2.x integrations.

## Coverage Check

| Lens | Covered By | Slot |
|---|---|---|
| architecture | Martin Thompson (BM-014) | secondary |
| reliability | Will Larson (BM-012) | secondary |
| security | Troy Hunt (BM-016) | primary |
| performance | Martin Thompson (BM-014) | primary |
| operability | Troy Hunt (BM-016) | secondary |
| cognitive-load | Will Larson (BM-012) | primary |
| agentic-AI-systems | Simon Willison (BM-007) | primary |

- All 7 lenses covered: **true**.
- Deferrals: **none**.
- Redundancy: zero (by construction — the Lean-4 partition has exactly 7
  lens slots for 7 required lenses).
- Redundancy trade-off noted: a single member's absence uncovers 1–2 lenses
  immediately. Chair retains discretion to pull an alternate from the pool
  for any absent member on a per-review basis.

## Conflicts Re-Check

- No conflicts of interest identified at composition approval time.
  Simulation framing removes conflict surface by construction; the
  named real-world corpus authors are not participants.

## Chair Approval

- Status: **APPROVED**.
- Chair Approver: **Simon Willison (BM-007)** (expert-informed-simulation;
  appointed by user directive 2026-04-19).
- Human Co-Approver: **cms-pm** (chris@praqsys.net).
- Approved At: 2026-04-19T00:00:00Z.
- Conditions: none.
- Board-Size Decision: **Lean-4** (recorded by chair directive 2026-04-19).
- Positioning Acknowledgement: **Acknowledged** — all seats filled by
  expert-informed-simulation personas per `core/AUTONOMOUS_DELIVERY_GOVERNANCE.md`
  §Simulation Positioning. No named real-world individual is a participant.

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
