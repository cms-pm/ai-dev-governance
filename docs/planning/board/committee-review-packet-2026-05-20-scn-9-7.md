# Committee Review Packet — SCN-9.7 Phase 9 Sign-Off — 2026-05-20

- Cadence lane: `Accountability Review`.
- Chair continuity: Will Larson (BM-012), continuing from MTG-0004.
- Scope: final Phase 9 sign-off for SCN-9.0 through SCN-9.7.
- Requested outcome: adopt Phase 9, ratify mutation thresholds through
  DEC-0005, close completed traceability rows, and carry forward only
  downstream-adoption risks that cannot close inside Phase 9.

## Evidence

| Area | Evidence | Status |
|---|---|---|
| Phase 9 planning | `docs/planning/chunks/phase-9-chunks.md`; `docs/planning/phase-9-todo.md`; `docs/planning/phase-9-risks.md` | Complete |
| Core policy | `core/MODULARITY_GOVERNANCE.md`; `core/DOMAIN_LANGUAGE_GOVERNANCE.md`; `core/MUTATION_EVIDENCE.md` | Complete; mutation policy ready for DEC-0005 flip |
| Contracts and validators | `contracts/governance-manifest.schema.json`; `validation/CONSISTENCY_RULES.md` §17-§19; `scripts/validators/` | Complete |
| Claude skills | `adapters/providers/claude/skills/`; `docs/evidence/scn-9-3-skills-smoke/README.md` | Complete |
| Self-application Part A | `docs/glossary/`; `docs/evidence/seam-maps/astaire-seam-map.md`; `astaire/` submodule refactor | Complete |
| Self-application Part B | `docs/evidence/mutation/astaire-claims-projection-2026-05-20.md`; `docs/evidence/farley/astaire-pytest-2026-05-20.md`; `docs/evidence/seam-maps/astaire-characterisation-suite.md` | Complete |
| DEC-0005 candidate | `docs/planning/board/threshold-ratification-proposal-scn-9-7.md` | Recommends adopt-as-proposed with SCN-9.5-EQ-001 accepted |
| Migration docs | `runbooks/MUTATION_TESTING.md`; `runbooks/GLOSSARY_AUTHORING.md`; `runbooks/TEST_DESIGN_REVIEW.md`; `templates/MIGRATION_PHASE_9.md` | Complete |

## Findings

| ID | Finding | Severity | Disposition |
|---|---|---|---|
| FND-0019 | Cosmic Ray raw score is 52.86%, but all 33 survivors are type-only Protocol annotation mutants covered by SCN-9.5-EQ-001. | Medium | Accept equivalent-mutant bundle and adopt thresholds unchanged. |
| FND-0020 | mutmut 3.5.0 is useful as an installed inner-loop tool but cannot cleanly gate the Astaire `src` package layout. | Low | Documented in mutation report; Cosmic Ray remains the evidence tool. |
| FND-0021 | R-9-04 still requires first downstream adoption of the new analyzer blocks. | Medium | Carry to Phase 10 monitoring. |
| FND-0022 | R-8.2-05 still lacks a Phase 8.1 reciprocal risk-log artifact in this repo. | High | Carry to Phase 10 monitoring. |

There are 0 open critical findings.

## DEC-0005 Request

Adopt the SCN-9.1 mutation thresholds without numeric change:

| Risk tier | Mutation score | Additional requirement |
|---|---:|---|
| Low | not required | no mutation evidence required |
| Medium | 70% | survivor list reviewed; disposition recorded |
| High | 85% | survivor list reviewed; equivalent-mutant exceptions filed |
| Critical | 90% | zero survivors permitted in domain core except approved equivalent-mutant exceptions |

Accept `SCN-9.5-EQ-001` as the equivalent-mutant exception bundle for
Cosmic Ray type-only Protocol return-annotation mutations in
`astaire/src/domain/claims/ports.py`.

## Decision Request

Adopt Phase 9 sign-off with ambiguity score `0.0307` and confidence
`4.00`. Close SCN-9.7 traceability after validation evidence is
recorded. Carry R-9-04, R-9-05, R-8.2-02, and R-8.2-05 forward to
Phase 10 monitoring.
