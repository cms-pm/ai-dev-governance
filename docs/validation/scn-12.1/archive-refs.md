# SCN-12.1 — Stranded-work archive refs (2026-10-07)

Push-only rescue. No consumer working tree, index, branch or stash was modified.

| Remote | Ref | SHA | Source | Content |
|---|---|---|---|---|
| cms-pm/astaire | `archive/test-card-2026-05` | `813551c317c38bac04c68e5960ba449400bfda23` | consumer nested `.governance/ai-dev-governance/astaire` | `53acf88` test-card doc type; `e1da012` frontmatter-aware scan; `813551c` golden-snapshot ignore (intended v0.4.3, never released) |
| cms-pm/astaire | `archive/dev-agent-sessions-2026-04` | `82256aab4d39caaed1dd4b6f49da3033eb7db7dd` | standalone Astaire checkout, branch `dev` | `c6eece4` methodology wiring; `82256aa` agent-sessions collection plugin |
| cms-pm/ai-dev-governance | `archive/cockpit-v0.7.5-test-card` | `92a7564d777ff53879ffbf85671444b7057cd79a` | consumer nested `.governance/ai-dev-governance` | test-card read patterns, untagged v0.7.5 bump, Astaire pins to the commits above |
| cms-pm/ai-dev-governance | `archive/SCN-11.0` | `4adae7b0d4f3c0a18ceb21d57a2c2570d1ce8d4a` | local branch `SCN-11.0` | Phase 11 bootstrap, R-11-08 fix, EXC-0002, divergent v1.2.2 commit |
| cms-pm/ai-dev-governance | `archive/SCN-8.3.1` | `1120e70d0b4c299278d749e7b129c9e0edd2eb2d` | local branch `SCN-8.3.1` | R-8.2-05 closure-request packet (content already on `main`) |
| cms-pm/ai-dev-governance | `archive/cockpit-chunk-8.1.3-frontmatter-scan` | `63b784d2df4a6762c36c0191e801fd04606c498f` | consumer nested `.governance/ai-dev-governance`, branch `chunk-8.1.3-frontmatter-aware-scan` | `a37bb54` test-card read patterns in `runbooks/ASTAIRE_ACCESS.md`; `c0ab78b` untagged v0.7.5; `63b784d` Astaire pin |
| cms-pm/ai-dev-governance | `archive/cockpit-scenario-status-vocabulary` | `c7702a92671ad185791115762cb118494f64c5a0` | same, branch `evidence/scenario-status-vocabulary` | local rebase; content already on `main` |
| cms-pm/ai-dev-governance | `archive/cockpit-hil-sil-predicate-router` | `45ec3bf85dcae7a09beefe265215566a42b6e38c` | same, branch `adapters/hil-sil-predicate-router` | local rebase; content already on `main` |
| cms-pm/ai-dev-governance | `archive/cockpit-scenario-ledger-runbook` | `2a0390f828d13417c6eaf3921e8c8ca83c78071b` | same, branch `astaire/scenario-ledger-collection` | local rebase; content already on `main` |

Already upstream (verified by content, no action): Scenario Status Vocabulary
(`core/EVIDENCE_CONTRACT.md`), `adapters/tooling/HIL_SIL_PREDICATE_ROUTER.md`
(byte-identical), `runbooks/SCENARIO_LEDGER_RUNBOOK.md`,
`docs/planning/cross-phase/r-8.2-05-closure-request.md`.

Inspected, no action: the consumer's `scripts/validate_codegraph_wiring.sh` is a
5-line wrapper delegating to ADG's validator; untracked `graphify/` inside the
nested ADG is a separate third-party checkout; untracked `artifacts/` are
generated evidence.

Post-push check: `git log --branches --not --remotes` is empty in the ADG and
Astaire checkouts. Every commit that the consumer's nested ADG submodule lists
under `--branches --not --remotes` (8 commits) now resolves in
`cms-pm/ai-dev-governance`. Its nested Astaire's 3 commits resolve in
`cms-pm/astaire`. No governance-related stashes exist in any of these
repositories.

The second pass (rows 6–9) was added after a branch-level recheck. The first
pass had covered the stranded commits but not every local branch holding them.
