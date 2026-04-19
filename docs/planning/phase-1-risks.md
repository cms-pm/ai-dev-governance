# Phase 1 Risk Log — ai-dev-governance integration

Linked to: `docs/planning/pool_questions/phase-1-integration-pool.md`.

## Open Risks

| ID | Title | Severity | Likelihood | Trigger SCN(s) | Mitigation | Owner | Review Window |
|---|---|---|---|---|---|---|---|
| R-1 | Graphify importer drift across upstream versions | High | Medium | SCN-3.1, SCN-3.3 | Pin schema version per import run; add `graph_schema_version` tag to every imported artifact; smoke-test importer against each graphify refresh before compatibility matrix bump. | Accountable Delivery Lead | Each graphify refresh (monthly) |
| R-2 | Board cadence lead time blocks SCN-3.1 gate | Medium | High | SCN-3.1 | Pre-stage board composition now (parallel track to Phase 1 execution); schedule sprint-critique session the week before Phase 3 kickoff. | Chairperson | Weekly during Phase 1 |
| R-3 | Astaire `v0.3.0` tag dependency outside this repo's control | Medium | Medium | SCN-1.3, SCN-5.1 | SHA bridge pin (`c740232`) for interim; escalate to upstream owner with target date; v0.6.0 release ships on SHA if tag slips beyond that date. | Accountable Delivery Lead | At SCN-5.1 release branch cut |
| R-4 | `restricted` security mode allowlist errors leak sensitive paths | High | Low | SCN-1.5, SCN-1.6 | Enforcement wrapper validates allowlist against a denylist of well-known secret paths (`.env`, `secrets/**`, `*.pem`, `*.key`); fail-closed on pattern match. | Security owner (TBD) | Before SCN-3.4 dogfood run |
| R-5 | L0 routing-hint conventions undocumented before agents rely on them | Medium | Medium | SCN-4.0 | SCN-4.0 blocks SCN-4.1 through SCN-4.3; formalize routing grammar with examples in the adapter doc and a parser fixture in Astaire tests. | Methodology Steward | Phase 4 kickoff |
| R-6 | Top-10% god-node threshold over- or under-promotes skeleton edges | Medium | High | SCN-3.1, SCN-3.3 | SCN-3.1 spike explicitly tunes threshold; evidence bundle includes before/after claim-count; threshold becomes a manifest-declared knob (`graphify.promotionThreshold`) if spike shows corpus sensitivity. | Accountable Delivery Lead | SCN-3.1 exit |
| R-7 | Bidirectional submodule residue if Astaire upstream regresses | Low | Low | SCN-1.3 | Compatibility matrix CI check refuses any Astaire pin that re-introduces `ai-dev-governance` as a submodule of Astaire. | Methodology Steward | Every pin bump |

## Closed Risks

_None yet._

## Rollback Strategy Notes

- **Phase 3 rollback:** unregister `graphify-outputs` collection + drop
  promoted claims tagged `source=graphify` + remove `graphify hook` installation.
  Leaves raw `graphify-out/` on disk untouched.
- **Phase 2 rollback:** disable Astaire hooks in `.claude/settings.json`;
  Astaire DB is not authoritative state for this repo so pruning the `.db`
  file is a clean reset.
- **Phase 1 rollback:** revert commits; submodule pins can be moved back to
  HEAD or removed entirely.
