# Board Selection Dossier — 2026-04-18

> **Positioning notice.** All board members listed here are
> **expert-informed simulation profiles**. Each seat is filled by an AI persona
> grounded in the public corpus of a named real-world practitioner. These
> profiles MUST NOT be presented as endorsements by the named individuals, and
> MUST NOT be cited as if the real person participated. This framing is
> mandated by `core/BOARD_REVIEW_GOVERNANCE_METHODOLOGY.md` §Expert-Agent
> Board Selection and §Simulation Positioning.

## Purpose

Document candidate discovery, scoring, and recommendation for the inaugural
board composition covering Phase 1–5 of the Astaire/graphify/RTK integration
work.

## Required Lenses and Seat Roles

Per `core/BOARD_REVIEW_GOVERNANCE_METHODOLOGY.md` §Expert-Agent Board Selection
and the project's specific needs:

- **architecture** — software design and large-codebase evolution.
- **reliability** — SRE practice, fail-closed operations, incident response.
- **security** — threat modeling, data-transmission risk, secret handling.
- **performance** — latency/throughput, resource budgets, measurement.
- **operability** — observability, runbook quality, operational cognitive load.
- **cognitive-load** — team topologies, documentation ergonomics, process
  cost.
- **domain-specific: agentic-AI-systems** — LLM-backed agent design, memory
  architecture, eval discipline.

## Candidate Longlist

| Candidate ID | Seat Role | Lens | Corpus Count (approx.) | Prominence Evidence | Initial Fit |
|---|---|---|---|---|---|
| BM-001 | Architecture Steward | architecture | 30+ articles + 6 books + conference talks | martinfowler.com archive; *Refactoring* (2/e); *Patterns of Enterprise Application Architecture* | good |
| BM-002 | Reliability Steward | reliability | 2 books + multiple SREcon talks + published postmortems corpus | *Site Reliability Engineering* (ed.); *The Site Reliability Workbook* (ed.) | good |
| BM-003 | Security Steward | security | 15+ books + 1000+ essays (Schneier on Security) + academic publications | decades of crypto/security writing; CFR/EFF affiliations; public threat-model corpus | good |
| BM-004 | Performance Steward | performance | 3 books + talks + extensive technical blog | *Systems Performance* (2/e); *BPF Performance Tools*; flame-graph methodology papers | good |
| BM-005 | Operability Steward | operability | 1 book co-authored + substantial blog + conference talk corpus | *Observability Engineering* (co-author); honeycomb.io writing on observability practice | good |
| BM-006 | Cognitive-Load Steward | cognitive-load | 1 book + talks + team-topology assessment corpus | *Team Topologies* (co-author); teamtopologies.com patterns catalogue | good |
| BM-007 | Agentic-AI Steward | agentic-AI-systems | 500+ posts + open-source tool corpus (llm, datasette, simonw/llm-tools) + conference talks | simonwillison.net archive on LLMs, agentic workflows, prompt injection | good |
| BM-008 | Architecture Alternate | architecture | 2 books + cloud-patterns site + talks | *Cloud Native Patterns*; *The Software Architect Elevator* | good |
| BM-009 | Agentic-AI Alternate | agentic-AI-systems | 1 book + academic papers + practitioner blog | *Designing Machine Learning Systems*; Stanford CS329S materials | good |

## Scoring Table

Rubric: 1–5 per criterion; weighted average requires `>=4.0` with `RoleFit
>= 4` and `EvidenceAccessibility >= 4` per `core/BOARD_REVIEW_GOVERNANCE_METHODOLOGY.md`.

| Candidate ID | Prominence | CorpusDepth | RoleFit | EvidenceAccessibility | RecencyRelevance | Weighted Average | Eligible |
|---|---|---|---|---|---|---|---|
| BM-001 | 5 | 5 | 5 | 5 | 4 | 4.8 | true |
| BM-002 | 5 | 5 | 5 | 5 | 4 | 4.8 | true |
| BM-003 | 5 | 5 | 4 | 5 | 4 | 4.6 | true |
| BM-004 | 5 | 5 | 5 | 5 | 5 | 5.0 | true |
| BM-005 | 4 | 4 | 5 | 5 | 5 | 4.6 | true |
| BM-006 | 4 | 4 | 5 | 5 | 5 | 4.6 | true |
| BM-007 | 4 | 5 | 5 | 5 | 5 | 4.8 | true |
| BM-008 | 4 | 4 | 4 | 5 | 4 | 4.2 | true |
| BM-009 | 4 | 4 | 4 | 5 | 5 | 4.4 | true |

## Conflicts and Coverage Check

- **Conflicts detected.** None. All candidates are public writers with no
  undisclosed financial interest in the three submodule repos or in RTK.
  Simulation framing eliminates the possibility of conflict-of-interest by
  the real individuals because they are not participants.
- **All required lenses covered.** true.
- **Uncovered lenses.** none.

## Proposed Composition

- **Primary per seat.**
  - Architecture → BM-001
  - Reliability → BM-002
  - Security → BM-003
  - Performance → BM-004
  - Operability → BM-005
  - Cognitive-Load → BM-006
  - Agentic-AI → BM-007
- **Alternate per seat.**
  - Architecture → BM-008
  - Agentic-AI → BM-009
  - Reliability / Security / Performance / Operability / Cognitive-Load —
    alternate slots TBD at the next composition refresh; initial board ships
    with primaries only for those lenses.

## Chair Approval

- **Status.** PENDING.
- **Chair.** PENDING (human approver required per
  `core/BOARD_REVIEW_GOVERNANCE_METHODOLOGY.md` §Roles and Responsibilities).
- **Date.** TBD.
- **Notes.** Approval should record:
  (1) acceptance of expert-informed-simulation positioning;
  (2) acknowledgement that the Security Steward (BM-003) is primary owner of
  the SCN-1.6 / SCN-4.3 surface;
  (3) acknowledgement that the Architecture + Cognitive-Load stewards
  co-own the port-of-first-resort routing grammar (SCN-4.0);
  (4) refresh cadence (quarterly) and emergency-refresh triggers.

## Corpus Ingestion Note

Each member profile at `docs/planning/board/members/BM-<nnn>.md` enumerates
specific corpus artifacts. For machine-usable reasoning per
`core/BOARD_REVIEW_GOVERNANCE_METHODOLOGY.md` §Corpus-grounded expertise, at
least the book and primary-blog corpora MUST be ingested into Astaire under
the `raw/` tree (SCN-2.3) and re-graphified so board simulations can cite
inspectable evidence.
