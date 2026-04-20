# Phase 1 Risk Log — ai-dev-governance integration

Linked to: `docs/planning/pool_questions/phase-1-integration-pool.md`.

## Open Risks

| ID | Title | Severity | Likelihood | Trigger SCN(s) | Mitigation | Owner | Review Window |
|---|---|---|---|---|---|---|---|
| R-1 | Graphify importer drift across upstream versions | High | Medium | SCN-3.1, SCN-3.3 | Pin schema version per import run; add `graph_schema_version` tag to every imported artifact; smoke-test importer against each graphify refresh before compatibility matrix bump. `inferredEdgeThreshold` validation must also be re-run on each graphify version bump since confidence score calibration may shift. | Accountable Delivery Lead | Each graphify refresh (monthly) |
| R-3 | Astaire `v0.3.0` tag dependency outside this repo's control | Medium | Medium | SCN-1.3, SCN-5.1 | SHA bridge pin (`c740232`) for interim; escalate to upstream owner with target date; v0.6.0 release ships on SHA if tag slips beyond that date. | Accountable Delivery Lead | At SCN-5.1 release branch cut |
| R-4 | `restricted` security mode allowlist errors leak sensitive paths | High | Low | SCN-1.5, SCN-1.6 | Enforcement wrapper validates allowlist against a denylist of well-known secret paths (`.env`, `secrets/**`, `*.pem`, `*.key`); fail-closed on pattern match. | Security owner (TBD) | Before SCN-3.4 dogfood run |
| R-5 | L0 routing-hint conventions undocumented before agents rely on them | Medium | Medium | SCN-4.0 | SCN-4.0 blocks SCN-4.1 through SCN-4.3; formalize routing grammar with examples in the adapter doc and a parser fixture in Astaire tests. | Methodology Steward | Phase 4 kickoff |
| R-7 | Bidirectional submodule residue if Astaire upstream regresses | Low | Low | SCN-1.3 | Compatibility matrix CI check refuses any Astaire pin that re-introduces `ai-dev-governance` as a submodule of Astaire. | Methodology Steward | Every pin bump |
| R-8 | Stale `pinnedNodes` ghost nodes inflate L0 after node deletion or rename | Medium | Medium | SCN-3.3, SCN-3.4 | `scripts/validate_graphify.sh` must lint `pinnedNodes` entries against the current graph and warn on any entry that matches zero nodes. Consumers must re-run validate after any graphify update. | Methodology Steward | Each graph refresh |
| R-9 | `inferredEdgeThreshold` misconfigured at low values re-introduces high false-contradiction rate | Medium | Low | SCN-3.3 | Knob is opt-in (default null). Release evidence must log the configured value. Documentation warns teams to validate their threshold against their graph before enabling. Recommend floor of 0.85 in the adapter guidance. | Accountable Delivery Lead | At opt-in adoption by each consumer |
| R-10 | `crossRepoAuthority` namespace patterns become stale as repo structure evolves, silently routing to merge fallback | Medium | Medium | SCN-3.3 | `scripts/validate_graphify.sh` must warn on namespace patterns that match zero nodes in the current graph. Patterns with wildcard `*` repo (merge fallback) exempt from this check. | Accountable Delivery Lead | Each graph refresh |
| R-11 | `annotateApprovalStatus` produces misleading `unapproved` annotations when contract registry is stale | Low | Medium | SCN-3.3 | Knob is opt-in (default off). Documentation requires teams to pair it with a registry-freshness check in CI. Stale registry (older than 30 days) should trigger a warning in `validate_graphify.sh`. | Methodology Steward | At opt-in adoption by each consumer |

## Closed Risks

| ID | Title | Closed Date | Closure Reason |
|---|---|---|---|
| R-2 | Board cadence lead time blocks SCN-3.1 gate | 2026-04-20 | SCN-3.1 board gate completed. All 7 decisions adopted. Board composition was pre-staged in Phase 1; sprint-critique ran on schedule. |
| R-6 | Top-10% god-node threshold over- or under-promotes skeleton edges | 2026-04-20 | SCN-3.1 spike adopted `p90` threshold with floor 3 / ceiling 100. `autoTune` knob added as dynamic guard. Manifest knob `graphify.promotionThreshold` authorized. Evidence: ADR at `docs/planning/pool_questions/phase-3-graphify-spike.md`. |

## Rollback Strategy Notes

- **Phase 3 rollback:** unregister `graphify-outputs` collection + drop
  promoted claims tagged `source=graphify` + remove `graphify hook` installation.
  Leaves raw `graphify-out/` on disk untouched.
- **Phase 2 rollback:** disable Astaire hooks in `.claude/settings.json`;
  Astaire DB is not authoritative state for this repo so pruning the `.db`
  file is a clean reset.
- **Phase 1 rollback:** revert commits; submodule pins can be moved back to
  HEAD or removed entirely.
