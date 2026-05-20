---
phase: 9
stage_produced: plan
---

# Phase 9 Risk Log — TDR Hardening (DDD + Hexagonal + Mutation + Test-Design)

Linked to: `docs/planning/pool_questions/phase-9-tdr-hardening.md`,
`docs/planning/chunks/phase-9-chunks.md`.

## Open Risks

| ID | Title | Severity | Likelihood | Trigger SCN(s) | Mitigation | Owner | Review Window |
|---|---|---|---|---|---|---|---|
| R-9-01 | Hexagonal refactor of `astaire/` claims/projection core regresses existing pytest suite or breaks the `governance_authoring` plugin used by this repo | High | Medium | SCN-9.4 | Pilot-only scope per Q2 resolution. Existing pytest suite MUST stay green at every intermediate commit. Architecture-fitness rule (`architecture_fitness.py`) gates the seam between domain and adapters. Rollback = revert the claims/projection refactor commit; glossary + seam map remain on disk as inert documentation. | Accountable Delivery Lead | At SCN-9.4 review and every Phase 9 sprint critique through SCN-9.7 |
| R-9-02 | SCN-9.5 mutation baseline produces poor data (sparse test corpus, unkillable mutants from infrastructure code) — proposed tier thresholds become misleading | Medium | Medium | SCN-9.5, SCN-9.7 | Advisory-until-ratified pattern per Q3 resolution. If SCN-9.5 baseline shows the proposed thresholds are unattainable for `astaire/` claims/projection core, the SCN-9.5 threshold-ratification proposal recommends revised numbers backed by survivor analysis. SCN-9.7 board MAY adopt-as-proposed, revise, or defer ratification to Phase 10 — the gate stays advisory in the deferral case. `validate_governance.sh` MUST NOT fail-close on mutation evidence until SCN-9.7 sign-off lands. | Accountable Delivery Lead | At SCN-9.5 review and SCN-9.7 board |
| R-9-03 | Claude skills accidentally encode normative rules (MUST/SHOULD/MAY) instead of pointing at core policy — adapter-layer shadow governance emerges | Medium | Medium | SCN-9.3, SCN-9.6 | SCN-9.3 acceptance criterion: `grep -nE '\\b(MUST\|SHOULD\|MAY)\\b' adapters/providers/claude/skills/` returns only quoted references back to `core/` documents. Each `SKILL.md` opens with the source-of-truth pointer. Reviewed at SCN-9.3 and again at SCN-9.7 sign-off as part of the policy-vs-adapter audit. | Accountable Delivery Lead | At SCN-9.3 review and SCN-9.7 audit |
| R-9-04 | Manifest schema additions (mutation, glossary, architecture-fitness) reject existing downstream consumer manifests despite the optional-at-v1 contract | Medium | Low | SCN-9.2, SCN-9.6, first downstream adoption | All three blocks declared `optional` in `governance-manifest.schema.json` per Q5 resolution. Tier-gated presence is enforced at the `validation/CONSISTENCY_RULES.md` §17–§19 layer, not in the schema. Migration note (SCN-9.6) provides copy-paste templates and explains tier-vs-presence semantics. First downstream consumer adoption is the live test. Closure cadence mirrors R-8.2-02. | Accountable Delivery Lead | At first downstream consumer adoption of any of the three new blocks |
| R-9-05 | Glossary authoring authority drift — bounded contexts disagree on canonical term definitions, or new code lands without naming-correspondence enforcement | Medium | Medium | SCN-9.4, SCN-9.6, every consumer adoption | `core/DOMAIN_LANGUAGE_GOVERNANCE.md` names per-context authoring authority in the file preamble. The `glossary_coverage.py` validator (SCN-9.2) checks that types/functions/test names in the bounded-context directory map to glossary terms. Disputes escalate to board review (the test-design lens MAY annex glossary findings). | Accountable Delivery Lead | At SCN-9.4 review and quarterly thereafter |

## Carried-forward from Phase 8.2 / 8.3 (monitor lane)

| ID | Carried-forward reason | Phase 9 monitor action |
|---|---|---|
| R-8.2-02 | Static-analyzer capability schema landed at SCN-8.3.4; closure waits on first downstream consumer adoption. Phase 9 adds three more analyzer blocks (mutation, glossary, architecture-fitness) under the same backward-compat discipline. | Sprint critique re-checks downstream-consumer adoption for both the SCN-8.3.4 analyzer-capability block and the new SCN-9.2 blocks. |
| R-8.2-05 | Cross-phase R-8.2-05 (Phase 8.1 reciprocal entry on `main`) remained open at Phase 8.3 sign-off. | Standing sprint-critique read of `phase-8.1-risks.md` on `main` each iteration; closure cadence unchanged. Carries to Phase 10 if open at SCN-9.7. |
| R-8.3-03 | Schema-rejection risk pattern for downstream consumers; Phase 9 inherits the same mitigation under Q5 (optional-at-v1, tier-gated presence). | Co-monitored with R-9-04 at first downstream adoption of the SCN-9.2 blocks. |

## Closed Risks

(none — phase newly opened)

## Rollback Strategy Notes

- **SCN-9.0 rollback.** Delete the four bootstrap artifacts; remove the
  Phase 9 row from `signoffs.md` and `traceability.md`. No transitive
  dependents.
- **SCN-9.1 rollback.** Revert the policy authoring commit. All five
  amended core docs return to pre-SCN-9.1 text; the three new docs are
  deleted. Astaire registrations drop on next scan.
- **SCN-9.2 rollback.** Revert the schema delta, §17–§19 rule text,
  validator wiring, and submodule pin bump. Existing manifests
  continue to validate under the pre-SCN-9.2 schema. The submodule
  retains the upstream commits; only registration coverage reverts.
- **SCN-9.3 rollback.** Delete `adapters/providers/claude/skills/` and
  any added slash-command files under `adapters/providers/claude/commands/`.
  Adapter-only rollback; no governance or `astaire/` impact.
- **SCN-9.4 rollback.** Revert the claims/projection refactor commit.
  Glossary files and seam map remain on disk as inert documentation.
  Existing pytest suite returns to pre-refactor structure; the
  architecture-fitness rule de-activates because the protected
  directory no longer exists.
- **SCN-9.5 rollback.** Delete the mutation report, Farley scorecard,
  characterisation suite, and threshold-ratification proposal. Cosmic
  Ray + mutmut configuration files remain (no behavioural impact).
  Astaire registrations drop on next scan.
- **SCN-9.6 rollback.** Revert the runbook + template + README updates.
  Migration note is removed; templates revert to their previous shape.
- **SCN-9.7 rollback.** Sign-off rollback follows the established
  pattern in `core/PLANNING_METHODOLOGY.md` §Sign-off and Auditability
  (revert the signoff row + traceability flip + TO-DO ticks + advisory
  marker re-introduction + §17 fail-close revert together).
