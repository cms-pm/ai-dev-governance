# Phase 1 — Chunk Plans (Foundations)

Each chunk satisfies `core/PLANNING_METHODOLOGY.md` §Chunk Readiness Gate:
acceptance IDs, validation method, risks/rollback, ownership, risk tier, atomic
PR scope. Evidence paths follow `docs/planning/traceability.md`.

---

## SCN-1.1 — Self-governance manifest

- **Scope.** Add `governance.yaml` at repo root declaring `strict-baseline`,
  `providers/claude`, `tooling/rtk`. Create `docs/governance/exceptions.yaml`
  (empty registry). Configure evidence paths (`docs/planning/`,
  `docs/validation/`, `docs/releases/`).
- **Acceptance IDs.** SCN-1.1-01.
- **Acceptance criteria.**
  - `scripts/validate_governance.sh` run from repo root exits 0.
  - Manifest validates against `contracts/governance-manifest.schema.json`.
  - `adapters` list contains `strict-baseline`, `providers/claude`,
    `tooling/rtk`.
- **Validation method.** Automated — run the validator in CI.
- **Risks.** Manifest field omission blocks future chunks. Mitigation: schema
  validation in CI.
- **Rollback.** Revert the commit; no shared state changes.
- **Owner.** Accountable Delivery Lead.
- **Risk tier.** low.
- **Atomic PR scope.** `SCN-1.1`.

---

## SCN-1.2 — Submodule pinning policy

- **Scope.** Write `runbooks/SUBMODULE_PINNING.md` (pin-at-tag rule, quarterly
  refresh, emergency patch lane, SHA-bridge exception). Seed
  `runbooks/COMPATIBILITY_MATRIX.md` with the shape we will populate in
  SCN-1.3.
- **Acceptance IDs.** SCN-1.2-01.
- **Acceptance criteria.**
  - Runbook covers: when to pin, who approves bumps, how to handle upstream
    tags arriving late, bridge-SHA exception protocol.
  - Compatibility matrix table columns match `contracts/` schema and include
    one header row ready for SCN-1.3 rows.
- **Validation method.** Manual review by Methodology Steward.
- **Risks.** Policy too loose or too tight. Mitigation: peer review before
  merge.
- **Rollback.** Revert; no runtime impact.
- **Owner.** Methodology Steward.
- **Risk tier.** low.
- **Atomic PR scope.** `SCN-1.2`.

---

## SCN-1.3 — Submodule pin and v0.3.0 handshake

- **Scope.** Pin `astaire` to `c740232` and `graphify` to `v1.0.0` via
  `.gitmodules`; add a compatibility matrix row for v0.6.0; open upstream
  request on `cms-pm/astaire` asking for a `v0.3.0` tag capturing the
  submodule-removed + Apache 2.0 state; record the bridge-SHA exception in
  `docs/governance/exceptions.yaml` with a target window.
- **Acceptance IDs.** SCN-1.3-01.
- **Acceptance criteria.**
  - `.gitmodules` entries specify exact refs.
  - `git submodule status` reports the pinned refs after a fresh clone.
  - Compatibility matrix row present and self-consistent.
  - Exception entry is time-bounded with a review date.
  - Upstream issue URL recorded in the matrix row.
- **Validation method.** Automated — clone-and-verify script; manual review of
  exception entry.
- **Risks.** Upstream tag slippage (R-3). Mitigation: SHA bridge + dated
  exception.
- **Rollback.** Revert `.gitmodules` changes; remove exception entry.
- **Owner.** Accountable Delivery Lead.
- **Risk tier.** low.
- **Atomic PR scope.** `SCN-1.3`.

---

## SCN-1.4 — RTK evidence scaffolding

- **Scope.** Add `.rtk/` wrapper using `templates/RTK_LOCAL_WRAPPER_TEMPLATE.sh`
  (once it exists upstream — otherwise adapt the template snippet cited in the
  README); declare the RTK release evidence destination at `docs/releases/rtk/`;
  emit the first bundle (`rtk init --show`, `rtk gain`, `rtk discover`).
- **Acceptance IDs.** SCN-1.4-01.
- **Acceptance criteria.**
  - `.rtk/history.db` is gitignored.
  - First evidence bundle exists at `docs/releases/rtk/v0.6.0-bundle.md` and
    contains the three required command outputs.
  - `rtk gain --history` after running one rewritten command returns at least
    one row.
- **Validation method.** Manual — inspect bundle + run the history check.
- **Risks.** RTK binary ambiguity (rtk vs reachingforthejack/rtk). Mitigation:
  bundle records `which rtk` and `rtk --version`.
- **Rollback.** Delete the wrapper and bundle; no side effects.
- **Owner.** Accountable Delivery Lead.
- **Risk tier.** low.
- **Atomic PR scope.** `SCN-1.4`.

---

## SCN-1.5 — Graphify contract (manifest schema + adapter doc)

- **Scope.** Extend `contracts/governance-manifest.schema.json` with the
  `graphify` object (`collectionStrategy: split|unified`,
  `securityMode: full|restricted|code-only`, `allowlist: string[]`). Write
  `adapters/tooling/GRAPHIFY_CONTEXT_ADAPTER.md` describing both strategies,
  the three security modes, the required `source_repo` invariant tag, and the
  MCP sidecar option.
- **Acceptance IDs.** SCN-1.5-01.
- **Acceptance criteria.**
  - Schema validates both a `split`+`restricted` and a `unified`+`code-only`
    manifest example.
  - Adapter doc contains: applicability, required setup, operating rules,
    release evidence, non-weakening invariant.
  - `validation/CONSISTENCY_RULES.md` updated to forbid `full` security mode
    without matching exception.
- **Validation method.** Automated — JSON-schema tests; manual review of the
  adapter doc.
- **Risks.** Schema drift against Astaire plugin expectations (R-1).
  Mitigation: Astaire plugin in SCN-2.1 tests against this schema.
- **Rollback.** Revert schema + doc; no runtime impact.
- **Owner.** Methodology Steward.
- **Risk tier.** medium.
- **Atomic PR scope.** `SCN-1.5`.

---

## SCN-1.6 — Security amendment for data-transmitting adapters

- **Scope.** Add a one-paragraph section "Data-transmitting adapters" to
  `core/SECURITY_CONTROLS.md` pointing at the adapter doc. Extend
  `core/EVIDENCE_CONTRACT.md` §Release Evidence to require the graphify
  security mode in use and the allowlist digest. Ship `scripts/run_graphify.sh`
  enforcement wrapper (reads manifest, validates allowlist against a denylist
  of secret patterns, generates `.graphifyignore`, invokes graphify with the
  right flags). Fail closed on denylist match.
- **Acceptance IDs.** SCN-1.6-01.
- **Acceptance criteria.**
  - Running `scripts/run_graphify.sh` with `full` mode and no exception exits
    non-zero with a clear error.
  - Running in `restricted` mode with an allowlist that matches `secrets/**`
    exits non-zero.
  - Running in `code-only` mode invokes graphify with LLM extractors disabled
    (or pre-filters inputs to code extensions only if upstream lacks a direct
    flag).
  - Release evidence fields include `graphify.securityMode` and
    `graphify.allowlistHash`.
- **Validation method.** Automated — unit tests on the wrapper; fixture
  manifests covering pass and fail cases.
- **Risks.** Wrapper false negatives on novel secret paths (R-4). Mitigation:
  conservative denylist; documented extension procedure.
- **Rollback.** Remove the wrapper + revert security/evidence docs.
- **Owner.** Security owner (TBD during board composition — see dossier).
- **Risk tier.** medium. Board review recommended because it touches core
  policy.
- **Atomic PR scope.** `SCN-1.6`.

---

## SCN-1.7 — Port-of-first-resort motto promotion

- **Scope.** Add "Governance Principles" section to `README.md` containing the
  motto. Cross-reference from `core/PLANNING_METHODOLOGY.md` §Context
  Management. Echo the principle in any CLAUDE.md-pattern template guidance
  under `templates/`.
- **Acceptance IDs.** SCN-1.7-01.
- **Acceptance criteria.**
  - Motto text matches the approved wording verbatim.
  - Cross-references resolve (link check passes).
  - No duplication of the motto outside the canonical location in `README.md`.
- **Validation method.** Automated link check + manual diff review.
- **Risks.** Drift between core and template wording over time. Mitigation:
  single-source in README; other docs link rather than duplicate.
- **Rollback.** Revert.
- **Owner.** Methodology Steward.
- **Risk tier.** low.
- **Atomic PR scope.** `SCN-1.7`.
