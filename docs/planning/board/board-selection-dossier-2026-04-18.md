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

## Expansion Note (2026-04-19)

The initial 9-candidate longlist was built around a 7-seat one-steward-per-lens
composition. Per updated direction, the target is a **3-seat lean board**
selected by the chair from a broader multi-lens-capable pool. The pool is
therefore expanded to **22 candidates (BM-001..BM-022)**. Each new entrant
(BM-010..BM-022) declares a **primary** and **secondary** lens so the chair
can verify that any trio covers all 7 required lenses. Selection criteria,
scoring rubric, and simulation positioning are unchanged.

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

| Candidate ID | Seat Role | Lens (primary / secondary) | Corpus Count (approx.) | Prominence Evidence | Initial Fit |
|---|---|---|---|---|---|
| BM-001 | Architecture Steward | architecture / — | 30+ articles + 6 books + conference talks | martinfowler.com archive; *Refactoring* (2/e); *Patterns of Enterprise Application Architecture* | good |
| BM-002 | Reliability Steward | reliability / — | 2 books + multiple SREcon talks + published postmortems corpus | *Site Reliability Engineering* (ed.); *The Site Reliability Workbook* (ed.) | good |
| BM-003 | Security Steward | security / — | 15+ books + 1000+ essays (Schneier on Security) + academic publications | decades of crypto/security writing; CFR/EFF affiliations; public threat-model corpus | good |
| BM-004 | Performance Steward | performance / — | 3 books + talks + extensive technical blog | *Systems Performance* (2/e); *BPF Performance Tools*; flame-graph methodology papers | good |
| BM-005 | Operability Steward | operability / — | 1 book co-authored + substantial blog + conference talk corpus | *Observability Engineering* (co-author); honeycomb.io writing on observability practice | good |
| BM-006 | Cognitive-Load Steward | cognitive-load / — | 1 book + talks + team-topology assessment corpus | *Team Topologies* (co-author); teamtopologies.com patterns catalogue | good |
| BM-007 | Agentic-AI Steward | agentic-AI-systems / — | 500+ posts + open-source tool corpus | simonwillison.net on LLMs, agentic workflows, prompt injection | good |
| BM-008 | Architecture Alternate | architecture / — | 2 books + cloud-patterns site + talks | *Cloud Native Patterns*; *The Software Architect Elevator* | good |
| BM-009 | Agentic-AI Alternate | agentic-AI-systems / — | 1 book + academic papers + practitioner blog | *Designing Machine Learning Systems*; Stanford CS329S materials | good |
| BM-010 | Multi-Lens Candidate | architecture / cognitive-load | books + talks + article archive | Kent Beck: XP, TDD, *Tidy First?* | good |
| BM-011 | Multi-Lens Candidate | reliability / architecture | book + talk archive | Michael Nygard: *Release It!* stability-patterns corpus | good |
| BM-012 | Multi-Lens Candidate | cognitive-load / reliability | book + long-form blog | Will Larson: *An Elegant Puzzle*, *Staff Engineer*, lethain.com | good |
| BM-013 | Multi-Lens Candidate | operability / reliability | articles + talks | Cindy Sridharan: distributed-tracing / testing-in-production essays | good |
| BM-014 | Multi-Lens Candidate | performance / architecture | talks + mechanical-sympathy corpus | Martin Thompson: LMAX Disruptor, Aeron | good |
| BM-015 | Multi-Lens Candidate | performance / reliability | talks + HdrHistogram corpus | Gil Tene: latency-measurement methodology ("How NOT to Measure Latency") | good |
| BM-016 | Multi-Lens Candidate | security / operability | breach-data corpus + blog + talks | Troy Hunt: HIBP, practitioner web-security writing | good |
| BM-017 | Multi-Lens Candidate | security / cognitive-load | book + course materials | Tanya Janca: *Alice and Bob Learn Application Security* | good |
| BM-018 | Multi-Lens Candidate | architecture / cognitive-load | talks + language corpus | Rich Hickey: *Simple Made Easy*, *Hammock-Driven Development* | good |
| BM-019 | Multi-Lens Candidate | cognitive-load / operability | article + zine archive | Julia Evans: jvns.ca, wizardzines.com | good |
| BM-020 | Multi-Lens Candidate | agentic-AI-systems / performance | articles + repos + video series | Andrej Karpathy: nanoGPT, "Zero to Hero", LLM Wiki concept | good |
| BM-021 | Multi-Lens Candidate | agentic-AI-systems / reliability | articles + course materials + talks | Hamel Husain: "Your AI Product Needs Evals" | good |
| BM-022 | Multi-Lens Candidate | agentic-AI-systems / architecture | article archive + OpenAI research blog | Lilian Weng: "LLM Powered Autonomous Agents" | good |

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
| BM-010 | 5 | 5 | 4 | 5 | 4 | 4.6 | true |
| BM-011 | 4 | 4 | 5 | 5 | 4 | 4.4 | true |
| BM-012 | 5 | 5 | 5 | 5 | 5 | 4.8 | true |
| BM-013 | 4 | 4 | 5 | 4 | 5 | 4.4 | true |
| BM-014 | 4 | 4 | 4 | 4 | 4 | 4.2 | true |
| BM-015 | 4 | 4 | 4 | 5 | 4 | 4.2 | true |
| BM-016 | 4 | 4 | 4 | 5 | 5 | 4.4 | true |
| BM-017 | 4 | 4 | 4 | 5 | 5 | 4.4 | true |
| BM-018 | 5 | 4 | 4 | 5 | 4 | 4.4 | true |
| BM-019 | 4 | 4 | 4 | 5 | 5 | 4.4 | true |
| BM-020 | 5 | 5 | 5 | 5 | 5 | 5.0 | true |
| BM-021 | 4 | 4 | 5 | 5 | 5 | 4.6 | true |
| BM-022 | 4 | 4 | 5 | 5 | 5 | 4.6 | true |

## Lens-Coverage Matrix

`P` = primary lens, `S` = secondary lens. A chair-selected trio MUST have at
least one `P` or `S` in every column.

| Candidate | arch | rel | sec | perf | oper | cog | agentic |
|---|---|---|---|---|---|---|---|
| BM-001 | P |   |   |   |   |   |   |
| BM-002 |   | P |   |   |   |   |   |
| BM-003 |   |   | P |   |   |   |   |
| BM-004 |   |   |   | P |   |   |   |
| BM-005 |   |   |   |   | P |   |   |
| BM-006 |   |   |   |   |   | P |   |
| BM-007 |   |   |   |   |   |   | P |
| BM-008 | P |   |   |   |   |   |   |
| BM-009 |   |   |   |   |   |   | P |
| BM-010 | P |   |   |   |   | S |   |
| BM-011 | S | P |   |   |   |   |   |
| BM-012 |   | S |   |   |   | P |   |
| BM-013 |   | S |   |   | P |   |   |
| BM-014 | S |   |   | P |   |   |   |
| BM-015 |   | S |   | P |   |   |   |
| BM-016 |   |   | P |   | S |   |   |
| BM-017 |   |   | P |   |   | S |   |
| BM-018 | P |   |   |   |   | S |   |
| BM-019 |   |   |   |   | S | P |   |
| BM-020 |   |   |   | S |   |   | P |
| BM-021 |   | S |   |   |   |   | P |
| BM-022 | S |   |   |   |   |   | P |

## Conflicts and Coverage Check

- **Conflicts detected.** None. All candidates are public writers with no
  undisclosed financial interest in the three submodule repos or in RTK.
  Simulation framing eliminates the possibility of conflict-of-interest by
  the real individuals because they are not participants.
- **All required lenses representable in the pool.** true.
- **Uncovered lenses.** none.

## Recommended Trios (chair may override)

All three recommendations are verified to cover every required lens across
`{primary ∪ secondary}` of the seated members. The chair is free to select any
trio from the pool provided coverage is preserved.

- **Trio A — balance-leaning (recommended default).**
  BM-012 (cog P / rel S) + BM-004 (perf P) + BM-020 (agentic P / perf S).
  Coverage gap: architecture, security, operability lack a `P` or `S` — **rejected**.

- **Trio B — coverage-complete, high-score.**
  BM-010 (arch P / cog S) + BM-005 (oper P) + BM-020 (agentic P / perf S).
  Missing: reliability, security. **Rejected**.

- **Trio C — coverage-complete verification.**
  A full 7-lens sweep cannot be achieved by any 3-member subset when each
  member carries at most 2 lenses (3 × 2 = 6 < 7). The chair MUST therefore
  either (i) expand the lean-board target from 3 to 4 seats, or (ii) accept
  a documented lens-deferral where one lens is covered by ad-hoc consultation
  rather than a seated steward.

See §Chair Decision Required below.

## Chair Decision Required

The mathematical ceiling on 3 seats × 2 lenses is 6 distinct lenses; the
project requires 7. The chair MUST pick one:

1. **Lean-4.** Expand the target to a 4-seat board (8-lens ceiling). Adds one
   steward; still well below the original 7-seat model.
2. **Lean-3-with-deferral.** Accept a 3-seat board and formally defer one
   lens to ad-hoc consultation (naming which lens, and the consultation
   protocol). Lowest-risk deferral candidates are `security` (tier-gated by
   SCN-1.6 spike regardless of board composition) or `performance`
   (measurement-driven, less judgment-heavy).
3. **Lean-3-triple-lens.** Require at least one seated member to carry a
   tertiary lens. No current profile declares three; the chair would need to
   request a re-scoring pass.

Option (1) is the methodology-aligned default. §Post-Approval Next Steps
assume (1) unless the chair records otherwise.

## Corpus Ingestion Note

Each member profile at `docs/planning/board/members/BM-<nnn>.md` enumerates
specific corpus artifacts. For machine-usable reasoning per
`core/BOARD_REVIEW_GOVERNANCE_METHODOLOGY.md` §Corpus-grounded expertise, at
least the book and primary-blog corpora of the **seated** members MUST be
ingested into Astaire under the `raw/` tree (SCN-2.3) and re-graphified so
board simulations can cite inspectable evidence. Non-seated pool members do
not require ingestion at this time.
