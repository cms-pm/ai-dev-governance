---
phase: 12
stage_produced: plan
---

# Phase 12 Risk Log — Launch Readiness

Linked to: `docs/planning/pool_questions/phase-12-launch-readiness.md`,
`docs/planning/chunks/phase-12-chunks.md`.

## Open Risks

| ID | Title | Severity | Likelihood | Trigger SCN(s) | Mitigation | Owner | Review Window |
|---|---|---|---|---|---|---|---|
| R-12-01 | **Book citation drift.** The guide's evidence register cites ADG by file *and line range* (e.g. `CHANGELOG.md:28-46`); new CHANGELOG sections shift those lines. | Medium | High | SCN-12.4, SCN-12.7 | SCN-12.7-03 produces a shifted-reference report for the author; citations to tagged versions (v1.2.0) remain stable via tag permalinks. | Accountable Delivery Lead | SCN-12.7 |
| R-12-02 | **Relicensing scope.** Prior tags were published under an "Internal Use Only" licence. | Low | Low | SCN-12.2 | Sole human author verified; explicit relicensing note covers all prior tags. | Accountable Delivery Lead | SCN-12.2 |
| R-12-03 | **Forward-port incompatibility.** Test-card commits were written against Astaire ~v0.4.2; the collection module has since changed. | Medium | Medium | SCN-12.5 | Port by intent, not by cherry-pick; bring tests over first; originals stay in the archive branch. | Accountable Delivery Lead | SCN-12.5 |
| R-12-04 | **Name churn after publication.** The rename is deferred; every artefact polished now gets touched again. | Low | High (by design) | Follow-on | GitHub redirects renamed repos; scope captured in a follow-on issue at SCN-12.7. | Accountable Delivery Lead | Rename follow-on |

## Carry-Forward from deferred Phase 11

Phase 11 (consumer enforcement surface) is deferred, not cancelled.
EXC-0002 expired on 2026-08-09 and was never adopted on `main`; it is
not renewed. R-11-08 and R-11-09 close in SCN-12.3.

| ID | Disposition in Phase 12 |
|---|---|
| R-11-04 | Monitor. Phase 12 scores against the strict-baseline gate; closed phases not reopened. Board decision still pending. |
| R-11-06 | Monitor. Leading candidate for resumed Phase 11 / Phase 13. |
| R-11-07 | Partially mitigated by SCN-12.3 planted-violation runs. |
| R-11-10 | Monitor. Untouched by SCN-12.3. |
| R-11-11 | Monitor at SCN-12.7 lint. Fix belongs in Astaire. |

## Carry-Forward Monitoring (inherited, unchanged)

R-8.2-02, R-8.2-05, R-9-04, R-9-05, R-10-02, R-10-03, R-10-04.
