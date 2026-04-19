# Phase 5 — Chunk Plans (Release)

Precondition: Phases 1–4 merged with green checks and signed off.

---

## SCN-5.1 — v0.6.0 release

- **Scope.** Cut `v0.6.0` from protected `main`. Update `VERSION`,
  `CHANGELOG.md`, `MIGRATION.md`, `runbooks/COMPATIBILITY_MATRIX.md`. Emit
  release evidence bundle at `docs/releases/v0.6.0/` containing: RTK setup
  verification, `rtk gain`, `rtk discover`, graphify security mode in use,
  Astaire L0 snapshot, Astaire lint health report, compatibility statement.
  Swap astaire submodule pin to `v0.3.0` if the upstream tag has landed;
  otherwise ship on the SHA bridge and renew the exception with a new target
  date.
- **Acceptance IDs.** SCN-5.1-01.
- **Acceptance criteria.**
  - Tag `v0.6.0` exists on protected `main`; CODEOWNERS approvals recorded.
  - All required CI checks green on the release commit.
  - Release evidence bundle contains every field in
    `core/EVIDENCE_CONTRACT.md` §Release Evidence including the new graphify
    and Astaire fields.
  - CHANGELOG entry covers: new submodules, port-of-first-resort motto,
    graphify adapter, security modes, pinning policy.
  - Compatibility matrix row for v0.6.0 is populated.
  - MIGRATION.md documents consumer steps to adopt the new manifest fields.
- **Validation method.** Automated CI gates + manual release-evidence review
  by Chairperson.
- **Risks.** Upstream `astaire v0.3.0` slips past release (R-3). Mitigation:
  exception-renewal path documented; SHA-bridge ship is acceptable with a
  dated follow-up.
- **Rollback.** Tag is immutable; regression fixed forward in a patch release.
  No pre-release rollback needed since protection rules gate tag creation.
- **Owner.** Release manager (Accountable Delivery Lead).
- **Risk tier.** medium.
- **Atomic PR scope.** `SCN-5.1`.
