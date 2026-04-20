# Phase 2 — Chunk Plans (Astaire as memory palace)

Precondition: Phase 1 gate signed off; `governance.yaml` declares `tooling/rtk`
and the graphify adapter contract is merged (SCN-1.5).

SCN-A/B/C below codify the **Astaire-always imperative**: every agent operating
under `ai-dev-governance` — whether in this repo or in downstream projects
consuming the governance submodule — MUST treat Astaire as the port-of-first-resort
for planning and implementation artifacts, and MUST carry the Astaire CLI surface
in working context at all times. These chunks run before SCN-2.1 so the rule is
enforceable by the time Astaire is extended further.

---

## SCN-A — Astaire CLI surface always in working context

- **Scope.** Add `runbooks/ASTAIRE_ACCESS.md` with the canonical CLI surface
  (subcommands, common flags, query/context examples). Reference it from
  `README.md` §Governance Principles and from `core/PLANNING_METHODOLOGY.md`
  §Context Management so it loads into every agent's startup context.
  Add `templates/ASTAIRE_CLI_SNIPPET.md` so consumer repos can inline the
  surface into their own `AGENTS.md` / `CLAUDE.md` during bootstrap.
- **Acceptance IDs.** SCN-A-01, SCN-A-02.
- **Acceptance criteria.**
  - `runbooks/ASTAIRE_ACCESS.md` exists and lists every top-level subcommand
    (`init`, `startup`, `status`, `scan`, `query`, `context`, `lint`, `export`,
    `prune`, `sync`, `ingest`) with one-line purpose and a minimal example.
  - `README.md` §Governance Principles links to the access runbook.
  - `templates/ASTAIRE_CLI_SNIPPET.md` is ready to paste into a consumer
    `AGENTS.md` / `CLAUDE.md` and validates against `scripts/validate_governance.sh`
    when referenced.
- **Validation method.** Manual review + `scripts/validate_governance.sh`.
- **Risks.** CLI surface drifts from upstream Astaire. Mitigation: runbook
  carries the pinned governance version band it applies to, and SCN-1.3
  bridge-SHA exception process covers upstream bumps.
- **Rollback.** Remove the runbook and template; revert the README/PLANNING
  cross-references.
- **Owner.** Methodology Steward.
- **Risk tier.** low.
- **Atomic PR scope.** `SCN-A`.

---

## SCN-B — Enforce Astaire-before-direct-Read in governance

- **Scope.** Amend `core/PLANNING_METHODOLOGY.md` §Context Management and the
  relevant `adapters/providers/` adapters (Claude, Codex) to make Astaire L0
  the mandatory first read for any `docs/planning/**`, `docs/releases/**`, or
  board artifact. Direct file reads permitted only when (a) Astaire has no
  projection for the target, or (b) the read is in service of an edit. Add a
  consistency rule in `validation/CONSISTENCY_RULES.md` asserting the provider
  adapters carry this clause.
- **Acceptance IDs.** SCN-B-01.
- **Acceptance criteria.**
  - `core/PLANNING_METHODOLOGY.md` §Context Management contains the
    Astaire-first rule with the two narrow exceptions.
  - Each touched provider adapter under `adapters/providers/` contains the
    same rule, adapted to the provider's instruction format.
  - `validation/CONSISTENCY_RULES.md` has a new rule enforcing adapter
    carriage; `scripts/validate_governance.sh` exits non-zero if a strict-
    baseline provider adapter omits it.
- **Validation method.** Automated — consistency rule + validation script.
- **Risks.** Downstream projects already have provider adapters that predate
  this rule. Mitigation: v0.6.0 migration note covers the change; SCN-5.1
  compatibility matrix row flags it.
- **Rollback.** Remove the clause and the consistency rule.
- **Owner.** Methodology Steward.
- **Risk tier.** low.
- **Atomic PR scope.** `SCN-B`.

---

## SCN-C — Consumer-facing Astaire access template

- **Scope.** Ship `templates/ASTAIRE_CLI_SNIPPET.md` (produced under SCN-A)
  with embedding instructions for consumer repos. Extend
  `runbooks/SUBMODULE_CONSUMER_RUNBOOK.md` with a "Wire Astaire access" step
  pointing at the template. Add `scripts/validate_astaire_wiring.sh` — a
  provider-aware script that inspects any repo (consumer or governance source)
  for a correctly wired Astaire session surface. The governance repo is
  **consumer-zero**: it MUST pass the script before SCN-C is considered done.
  For Claude consumers the expected bootstrap file is `CLAUDE.md`; for Codex
  consumers `AGENTS.md`; detected from `governance.yaml` adapters when present,
  falling back to "at least one of the two" when no manifest exists at the root.
- **Acceptance IDs.** SCN-C-01, SCN-C-02, SCN-C-03.
- **Acceptance criteria.**
  - SCN-C-01: Template contains copy-pasteable CLI surface + the Astaire-first
    rule from SCN-B, scoped to the consumer's repo-local wrapper path.
    `runbooks/SUBMODULE_CONSUMER_RUNBOOK.md` has an "Astaire access" section
    with pin-aware instructions. Consumer validation fixture under
    `validation/fixtures/consumer-astaire/` demonstrates the snippet referenced.
  - SCN-C-02: `scripts/validate_astaire_wiring.sh` exists and is executable.
    It checks: (a) `.astaire/astaire` wrapper is executable; (b) the correct
    bootstrap file(s) — `CLAUDE.md` for `providers/claude`,
    `AGENTS.md` for `providers/codex`, at least one when no manifest — contain
    the `.astaire/astaire` invocation marker; (c) `.gitignore` excludes
    `memory_palace.db`. Exits non-zero on any failure with a [FAIL] line naming
    the fix. `validate_governance.sh` lists the script as a required file.
  - SCN-C-03: Running `scripts/validate_astaire_wiring.sh` from the governance
    repo root exits zero. The governance repo `CLAUDE.md` carries the Astaire
    CLI snippet (adapted: wrapper path identical, "full surface" link points to
    `runbooks/ASTAIRE_ACCESS.md` directly rather than the consumer submodule
    path). This is the canonical live fixture; the static fixture under
    `validation/fixtures/consumer-astaire/AGENTS.md` remains as a Codex-path
    reference example.
- **Validation method.** Automated — `scripts/validate_astaire_wiring.sh` run
  from the governance repo root exits zero; CI can run it for any consumer
  that sources the script from the submodule.
- **Risks.** Consumer ignores the snippet (R-C1). Mitigation: strict-baseline
  profile rejects consumers whose provider adapters lack the SCN-B rule; the
  script provides a runnable gate. Bootstrap file absent on fresh clone (R-C2):
  script exits non-zero immediately and names the missing file and the fix.
  Provider detection wrong when no governance.yaml (R-C3): fallback accepts
  either CLAUDE.md or AGENTS.md so the script never false-fails a valid setup.
- **Rollback.** Remove `scripts/validate_astaire_wiring.sh`, `CLAUDE.md`, and
  the consumer runbook section. Static fixture under `validation/` is inert.
- **Owner.** Methodology Steward.
- **Risk tier.** low.
- **Atomic PR scope.** `SCN-C`.

---

## SCN-D — Project bootstrap directives (new-project + retrofit)

- **Scope.** A single opinionated spin-up path that leaves a new or
  retrofitted consumer project with: ai-dev-governance, astaire, and
  graphify submodules pinned per `COMPATIBILITY_MATRIX.md`; RTK and
  Astaire repo-local wrappers; initialized local databases; Astaire
  post-commit hook; `AGENTS.md`/`CLAUDE.md` carrying the Astaire CLI
  snippet and the "When and How" block; strict-baseline `governance.yaml`;
  first L0 projection; and an evidence bundle. Deliverables:
  - `runbooks/PROJECT_BOOTSTRAP.md` — runbook covering new-project and
    retrofit paths with a decision tree.
  - `scripts/bootstrap_project.sh` — **pure bash**, idempotent, modes
    `--new`, `--retrofit`, `--verify`. `--new` creates the full
    directory structure (`core/` overlay stubs, `adapters/` stubs,
    `docs/planning/**`, `docs/releases/`, `docs/governance/`). Retrofit
    default is **dry-run with diff report**; `--force` required to
    write. `AGENTS.md` updates use marker-comment blocks so repeat runs
    update in place.
  - `templates/AGENTS_BOOTSTRAP_TEMPLATE.md` — the "When and How" block
    inlined into consumer `AGENTS.md`/`CLAUDE.md`.
  - `scripts/validate_bootstrap.sh` — consumer-side completeness check.
  - New rule in `validation/CONSISTENCY_RULES.md`: strict-baseline
    consumers MUST pass `validate_bootstrap.sh` before SCN work begins.
  - Board scaffolding is **opt-in** via `--with-board`; strict-baseline
    emits a warning when board scaffolding is skipped.
- **Acceptance IDs.** SCN-D-01, SCN-D-02, SCN-D-03, SCN-D-04.
- **Acceptance criteria.**
  - SCN-D-01: `bootstrap_project.sh --new <dir>` produces a directory
    that passes `validate_bootstrap.sh` on first run.
  - SCN-D-02: `bootstrap_project.sh --retrofit` defaults to dry-run and
    emits a diff report; only `--force` writes changes. Files outside
    the bootstrap contract are never touched.
  - SCN-D-03: First agent session in a bootstrapped repo has the Astaire
    CLI surface and the "When and How" block loaded in context, verified
    by a fixture prompt snapshot under `validation/fixtures/`.
  - SCN-D-04: Bootstrap evidence bundle at
    `docs/releases/bootstrap/<ISO-date>-bundle.md` enumerates every
    wire-up check with pass/fail and timestamps.
- **Validation method.** Automated — `validate_bootstrap.sh` plus fixture
  snapshot test; manual spot-check of a retrofitted fixture under
  `validation/fixtures/bootstrap-retrofit/`.
- **Risks.**
  - R-D1: Retrofit clobbers user files. Mitigation: dry-run default,
    explicit `--force`, marker-comment block updates.
  - R-D2: Pinned tentacle versions drift from what bootstrap expects.
    Mitigation: script reads `COMPATIBILITY_MATRIX.md` at runtime and
    refuses to run on unpinned tentacles.
  - R-D3: Consumer `AGENTS.md` conflicts with the bootstrap block.
    Mitigation: marker comments bound the managed region; content
    outside markers is preserved.
  - R-D4: Board scaffolding adds noise for small projects. Mitigation:
    opt-in flag; warning surfaced under strict-baseline.
- **Rollback.** Remove `scripts/bootstrap_project.sh`,
  `scripts/validate_bootstrap.sh`, `runbooks/PROJECT_BOOTSTRAP.md`,
  `templates/AGENTS_BOOTSTRAP_TEMPLATE.md`, and the new consistency rule.
  Existing consumer projects retain their generated files; nothing in
  `ai-dev-governance` depends on bootstrap outputs being present.
- **Owner.** Methodology Steward.
- **Risk tier.** medium (consumer-facing orchestrator; can modify files
  in a foreign repo under `--force`).
- **Atomic PR scope.** `SCN-D`.

---

## SCN-2.1 — `governance-authoring` Astaire collection plugin

- **Scope.** Upstream PR to `cms-pm/astaire` adding
  `src/collections/governance_authoring.py`. Doc types: `core-policy`,
  `adapter-spec`, `contract-schema`, `template`, `runbook`,
  `compatibility-entry`, `changelog-entry`. Tag keys: `policy_area`, `version`,
  `status`. Scan rules cover `core/**`, `adapters/**`, `contracts/**`,
  `templates/**`, `runbooks/**`. Plugin honors `collectionStrategy` from this
  repo's `governance.yaml` (both `split` and `unified` shapes).
- **Acceptance IDs.** SCN-2.1-01.
- **Acceptance criteria.**
  - `uv run astaire scan --root <ai-dev-governance>` registers at least one
    document per doc type.
  - `uv run astaire query -c governance-authoring -t core-policy` returns the
    `core/` policy files.
  - Plugin unit tests pass in Astaire's test suite.
- **Validation method.** Automated — Astaire unit tests + integration scan
  against this repo.
- **Risks.** Collection naming collision with future Astaire collections
  (R-1). Mitigation: single registered name documented in adapter.
- **Rollback.** Revert upstream PR; scan would no longer register this repo.
- **Owner.** Accountable Delivery Lead.
- **Risk tier.** medium (upstream change to a published tool).
- **Atomic PR scope.** `SCN-2.1` (upstream repo).

---

## SCN-2.2 — Repo-local Astaire hooks

- **Scope.** Add `.claude/settings.json` with `UserPromptSubmit` →
  `uv run astaire startup --root "$(git rev-parse --show-toplevel)"` and
  `PostToolUse: Bash(git commit*)` → `uv run astaire scan --root ...`.
- **Acceptance IDs.** SCN-2.2-01.
- **Acceptance criteria.**
  - Hook fires on prompt submission and writes a log line confirming
    `.astaire/astaire startup` ran.
  - Post-commit scan picks up a new planning artifact within one session.
  - Timeouts set to 10000ms so hooks never block agent flow.
- **Validation method.** Manual — trigger a session, inspect hook log; commit
  a test file and verify registration.
- **Risks.** Hook failure blocks prompts. Mitigation: `2>/dev/null || true`
  suffix so failures are non-fatal.
- **Rollback.** Delete hooks from `.claude/settings.json`.
- **Owner.** Accountable Delivery Lead.
- **Risk tier.** low.
- **Atomic PR scope.** `SCN-2.2`.

---

## SCN-2.3 — `raw/` corpus scaffolding and first ingest

- **Scope.** Create `raw/articles/`, `raw/papers/`, `raw/transcripts/`,
  `raw/notes/` with README describing conventions. Run first
  `uv run astaire ingest` against a curated subset of core methodology docs so
  L0 has non-empty content. Commit the resulting `db/memory_palace.db` (or a
  doc explaining where it lives — see risk note).
- **Acceptance IDs.** SCN-2.3-01.
- **Acceptance criteria.**
  - `raw/` tree exists with README.
  - `uv run astaire status` after first ingest reports non-zero claims and
    entities.
  - L0 summary contains references to `core/` policy names.
- **Validation method.** Manual review of L0 output.
- **Risks.** Whether to commit the binary SQLite DB is an open convention.
  Mitigation: default to not committing; document regeneration steps in a new
  `runbooks/ASTAIRE_BOOTSTRAP.md`.
- **Rollback.** Remove `raw/` and regenerate DB elsewhere.
- **Owner.** Methodology Steward.
- **Risk tier.** low.
- **Atomic PR scope.** `SCN-2.3`.

---

## SCN-2.4 — Release-evidence integration

- **Scope.** Update `runbooks/RELEASE_PROCESS.md` and `core/EVIDENCE_CONTRACT.md`
  (if SCN-1.6 has not already added this field) to require an L0 snapshot and
  `.astaire/astaire lint` health report in each release bundle. Add a release script
  target that emits both.
- **Acceptance IDs.** SCN-2.4-01.
- **Acceptance criteria.**
  - `docs/releases/v0.6.0/l0-snapshot.md` present and matches live L0 at
    release tag cut.
  - `docs/releases/v0.6.0/health-report.md` present with zero blocking lint
    findings.
- **Validation method.** Automated — release script emits both; CI check on
  tagged releases.
- **Risks.** Evidence drift between L0 at release cut and post-cut changes.
  Mitigation: snapshot is immutable; any post-cut changes require a new release.
- **Rollback.** Revert runbook updates; release evidence fields become
  documentation-only until re-added.
- **Owner.** Release manager (held by Accountable Delivery Lead until a named
  role emerges).
- **Risk tier.** low.
- **Atomic PR scope.** `SCN-2.4`.
