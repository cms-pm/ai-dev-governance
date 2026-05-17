# Phase 8.2 Risk Log — P10 Universal Adoption + CockpitVM Embedded Style

Linked to: `docs/planning/pool_questions/phase-8.2-style-adoption.md`,
`docs/planning/chunks/phase-8.2-chunks.md`.

## Open Risks

| ID | Title | Severity | Likelihood | Trigger SCN(s) | Mitigation | Owner | Review Window |
|---|---|---|---|---|---|---|---|
| R-8.2-01 | Assertion-density and return-value-check clauses applied retroactively to legacy code create churn | Medium | Medium | SCN-8.2.2 | Amendment text scopes new validation-evidence clauses to *touched* production code (consistent with the existing "Grandfathering" subsection in §Component Size Limits). Memo records the boundary explicitly. | Accountable Delivery Lead | At SCN-8.2.2 board review |
| R-8.2-02 | Static-analyzer floor under-specified — consumers declare an analyzer that doesn't detect the four newly forbidden patterns | Medium | Medium | SCN-8.2.2, SCN-8.2.4 | Capability floor (recursion + unbounded loops + dynamic-allocation-post-init + unchecked returns) is normative in the amendment. SCN-8.2.4 validation rule checks for analyzer declaration presence; capability auditing deferred to Phase 8.3+ but flagged in `phase-8.2-todo.md` as a follow-up. | Accountable Delivery Lead | At first downstream consumer adoption |
| R-8.2-03 | Opt-in confusion — consumers apply CockpitVM Embedded Style to non-embedded projects, or fail to apply it where embedded profile is declared | High | Medium | SCN-8.2.3, SCN-8.2.4 | Three-signal triangulation per pool Q3: preamble "extends, does not replace" language preserved; fail-closed gate only fires when manifest declares embedded profile; memo recommendation section explicitly labels the style as opt-in. Fixture suite in SCN-8.2.4 covers both the embedded and non-embedded manifest paths. | Accountable Delivery Lead | At SCN-8.2.4 fixture review |
| R-8.2-04 | CockpitVM rebrand lineage becomes opaque to auditors who need to verify provenance against upstream publications | Medium | Low | SCN-8.2.1, SCN-8.2.3 | Evaluation memo Sources footer carries publication-only citations; Astaire query `query -t evaluation --tag phase=8.2` is the discovery surface. CockpitVM Embedded Style MAY carry a one-line lineage pointer to the memo by path (phrasing decided in SCN-8.2.3) without naming agencies. | Accountable Delivery Lead | At SCN-8.2.5 board review |
| R-8.2-05 | Phase 8.1 in-flight cohort enters Power of 10 acceptance bar on next post-adoption touch without coordinated awareness | High | Medium | SCN-8.2.2, SCN-8.2.6 | New §Cross-Phase In-Flight Coordination clause in `core/CODE_IMPLEMENTATION_COMPLEXITY_GOVERNANCE.md` anchors the bar-shift to SCN-8.2.2 adoption SHA `5d47359` and grandfathers code on branches whose merge base predates that SHA until next touch. Phase 8.1 branches `chunk-8.1.0-*`..`chunk-8.1.3-*` named illustratively. Closure criterion: (a) Phase 8.1 risk log contains a reciprocal entry citing R-8.2-05 and SHA `5d47359`; AND (b) each Phase 8.1 chunk branch merges to main carrying either a clean analyzer pass on touched files or an explicit `core/EXCEPTIONS_AND_WAIVERS.md` entry. | Accountable Delivery Lead | Every Phase 8.2 sprint critique until closed |

## Closed Risks

(none — phase newly opened)

## Rollback Strategy Notes

- **SCN-8.2.2 rollback.** Revert the amendment commit. The complexity core
  returns to its `8b65071` baseline; no transitive dependents to unwind
  because the amendment is additive.
- **SCN-8.2.3 rollback.** Revert the file-creation commit. The CockpitVM
  Embedded Style disappears from the repo; the embedded profile reverts to
  its pre-Phase-8.2 state in the same commit if SCN-8.2.4 has not yet
  landed.
- **SCN-8.2.4 rollback.** Revert the validation rule + CI guard + profile
  extension in one commit. Fixture manifests revert to passing without the
  fail-closed gate.
- **Whole-phase rollback.** If the board review at SCN-8.2.5 rejects the
  package, revert SCN-8.2.4 → SCN-8.2.3 → SCN-8.2.2 in that order;
  SCN-8.2.1 memo and SCN-8.2.0 planning artifacts MAY remain as the audit
  record of the attempted adoption.
- **SCN-8.2.6 rollback.** Revert the chunk's single commit. The
  §Cross-Phase In-Flight Coordination clause is excised cleanly; R-8.2-05
  and the Cross-Phase Risk References appendix disappear with it. No
  transitive dependents.

## Cross-Phase Risk References

This appendix tracks Phase 8.2 risks that require reciprocal entries
in another phase's risk log. The protocol: every cross-phase risk MUST
list the dependent phase, the closure criterion that depends on the
other phase's action, and the discovery cadence at which the reciprocal
entry's presence is verified.

| Risk | Dependent Phase | Reciprocal Entry Requirement | Discovery Cadence |
|---|---|---|---|
| R-8.2-05 | Phase 8.1 | Phase 8.1 risk log MUST contain an entry citing R-8.2-05 and SHA `5d47359`, with mitigation acknowledging the Power of 10 acceptance bar on next post-adoption touch. | Every Phase 8.2 sprint critique. Verified by reading `docs/planning/phase-8.1-risks.md` once it lands on `main`; absence of the reciprocal entry keeps R-8.2-05 open. |

Future phases MUST follow this pattern when authoring risks whose
mitigation depends on action by another phase's owners. The appendix is
the cross-reference index; the per-row mitigation column is the
operational handle.
