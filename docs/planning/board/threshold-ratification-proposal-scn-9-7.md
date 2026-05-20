---
phase: 9
scn: 9.7
stage_produced: planning
decision_candidate: DEC-0005
produced_at: 2026-05-20
---

# Threshold Ratification Proposal — DEC-0005 Candidate

SCN-9.5 produced the first mutation baseline for the Astaire
claims/projection pilot. This proposal is the DEC-0005 input for
SCN-9.7.

## Baseline Data

Source: `docs/evidence/mutation/astaire-claims-projection-2026-05-20.md`.

| Metric | Value |
|---|---:|
| Cosmic Ray version | 8.4.6 |
| Total mutants | 70 |
| Killed mutants | 37 |
| Surviving mutants | 33 |
| Raw mutation score | 52.86% |
| Equivalent candidates | 33 |
| Equivalent-adjusted score if accepted | 100.00% |
| First rough-pass score before SCN-9.5 strengthening | 30.00% |
| Focused SCN-9.5 test result | 24 passed in 0.37s |

Farley scorecard source:
`docs/evidence/farley/astaire-pytest-2026-05-20.md` (average
`4.00 / 5`).

## Recommendation

**Recommendation: adopt-as-proposed, with DEC-0005 explicitly accepting
SCN-9.5-EQ-001 as an equivalent-mutant exception bundle.**

Rationale:

1. The raw score is below the proposed medium threshold because Cosmic
   Ray mutates PEP 604 return annotations on Protocol method stubs.
2. Those surviving mutants are type-only and do not change runtime
   behavior under `from __future__ import annotations`.
3. After excluding the equivalent candidates, no behavior-affecting
   survivor remains in the pilot domain package.
4. The proposed tier table remains appropriate for future runtime
   mutants: medium 70%, high 85%, critical 90% with zero untriaged
   domain-core survivors.

## DEC-0005 Adoption Text

Adopt the SCN-9.1 proposed mutation thresholds without numeric change:

| Risk tier | Mutation score | Additional requirement |
|---|---:|---|
| Low | not required | no mutation evidence required |
| Medium | 70% | survivor list reviewed; disposition recorded |
| High | 85% | survivor list reviewed; equivalent-mutant exceptions filed |
| Critical | 90% | zero survivors permitted in domain core except approved equivalent-mutant exceptions |

Approve `SCN-9.5-EQ-001` as an equivalent-mutant exception bundle for
Cosmic Ray's type-only Protocol return-annotation mutations in
`astaire/src/domain/claims/ports.py`.

## Alternative Outcomes

- **Revise.** Keep numeric thresholds but amend tooling guidance to
  exclude type-only annotations from Cosmic Ray sessions where the tool
  exposes that operator-level control.
- **Defer.** Leave `core/MUTATION_EVIDENCE.md` advisory and keep
  `validation/CONSISTENCY_RULES.md` §17 in WARN mode until a second
  baseline covers a behavior-heavy module.

The proposal prefers adoption because the behavior-affecting survivor
set is empty after the documented equivalent exception.
