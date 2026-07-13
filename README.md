# AI Dev Governance

`ai-dev-governance` is a reusable governance baseline for AI-assisted software
development. It is meant to be consumed from a downstream project as a
submodule, not copied piecemeal from this repo's authoring branch.

## Governance Principles

> **Port-of-first-resort.** Every agent call begins at Astaire's L0. L0 answers
> the majority directly; otherwise it routes — to a deeper Astaire projection
> (L1/L2), to CodeGraph where configured, to RTK-gated shell inspection,
> or further out. Agents never bypass the router; tentacles extend the reach
> without fragmenting the memory.

The principle is authoritative. `core/PLANNING_METHODOLOGY.md` §Context
Management and the `templates/` guidance cross-reference this section rather
than duplicating it.

The Astaire CLI surface MUST be in every agent's working context at all times.
See `runbooks/ASTAIRE_ACCESS.md` for the canonical surface and read-discipline
rule, and `templates/ASTAIRE_CLI_SNIPPET.md` for the consumer-facing variant to
paste into `AGENTS.md` / `CLAUDE.md`.

Phase 9 operational runbooks extend this principle into empirical test
design and domain-language work: `runbooks/MUTATION_TESTING.md`,
`runbooks/GLOSSARY_AUTHORING.md`, and `runbooks/TEST_DESIGN_REVIEW.md`.
They execute the policy in `core/` without replacing it.

## Agent Wiring

Top-level agent directives for this baseline should keep these links
front-and-center:

- `runbooks/ASTAIRE_ACCESS.md` for Astaire-first read discipline
- `templates/ASTAIRE_CLI_SNIPPET.md` for consumer-facing `AGENTS.md` /
  `CLAUDE.md` wiring
- `core/BOARD_REVIEW_GOVERNANCE_METHODOLOGY.md` for board critique and
  test-design review
- `core/PLANNING_METHODOLOGY.md` for phase gating, sign-off, and
  traceability

Phase 10 closeout artifacts should be read as evidence that this wiring
is active end-to-end, not as a substitute for the directives themselves.

## Why Use It

`ai-dev-governance` gives a consuming project a working operating system for
AI-assisted delivery:

- **Astaire-first context routing** so agents start from durable low-token
  memory instead of raw file fan-out
- **RTK-guided shell discipline** so broad exploration, git inspection, and
  validation stay token-efficient
- **Optional CodeGraph structural awareness** so planning, refactoring, and
  bug-hunting can route through declared codebase topology when configured
- **strict planning and evidence contracts** so changes are traceable,
  reviewable, and releasable
- **consumer bootstrap automation** so a new or existing repo can be wired into
  the baseline with the provided scripts instead of a manual checklist

The `v1.1.0` consumer bootstrap line was validated both locally and through a
fresh-repo consumer bootstrap smoke test (see
`docs/releases/v1.1.0/evidence-bundle.md`); each subsequent release carries its
own Astaire evidence bundle under `docs/releases/<version>/`.

## Purpose

This repository provides a strict baseline that teams can reuse across projects via Git submodule, with provider, tooling, and project-specific adapters layered on top.

## Get Started

Recommended consumer entrypoints for the current release:

- stable tag: `v1.2.0` (latest published tag; `main` additionally carries the
  `v1.2.1` changelog entry recorded in `VERSION`, not yet published as a tag)
- dedicated bootstrap branch: `consumer/bootstrap-v1.1.0`

Downstream consumers should use the tag for stable pins and treat the
`consumer/bootstrap-*` branch as the human-readable bootstrap surface for its
release line. All releases after `v1.1.0` — the `v1.1.x` patches and the
`v1.2.x` doctrine minors — are published as annotated tags over the `v1.1.0`
bootstrap line; no newer bootstrap branch has been cut.

### New or Existing Project Bootstrap

```bash
git submodule add -b consumer/bootstrap-v1.1.0 https://github.com/cms-pm/ai-dev-governance.git .governance/ai-dev-governance
git submodule update --init --recursive
.governance/ai-dev-governance/scripts/bootstrap_project.sh --retrofit --force
.governance/ai-dev-governance/scripts/validate_bootstrap.sh
```

What this gives the consumer repo:

- repo-local Astaire wrapper at `.astaire/astaire`
- generated `governance.yaml`
- provider-appropriate bootstrap instructions in `AGENTS.md` / `CLAUDE.md`
- visible optional-CodeGraph decision record at
  `docs/governance/codegraph-contract.md`
- bootstrap directories under `docs/`
- recursive tentacle initialization for nested submodules such as Astaire

For the full bootstrap decision tree (new-project vs retrofit vs manual
submodule add), see `runbooks/PROJECT_BOOTSTRAP.md`. For submodule pinning
guidance after bootstrap, see `runbooks/SUBMODULE_CONSUMER_RUNBOOK.md`.

## Integrated Stack

- **Astaire** is the broker of context. It keeps durable memory in SQLite,
  answers cheap questions at L0, and routes deeper work outward only when
  needed.
- **RTK** is the token-discipline layer. Shell-visible exploration, search,
  git, lint, and release work should flow through RTK-backed paths whenever
  possible.
- **CodeGraph** is the optional source-code intelligence lane for consumers
  that declare and validate a local code graph.

Current published tentacle releases used by the consumer baseline:

- `ai-dev-governance` — `v1.2.0` (latest published tag)
- `astaire` — `v0.5.0` (pinned at `ed16f6d`; see
  `runbooks/COMPATIBILITY_MATRIX.md`)

## Repository Layout

- `core/`: Mandatory, provider-agnostic governance policies — 16 documents,
  enumerated in full under "Required Core Policies" below
- `adapters/`: Provider, tooling, and profile overlays (cannot weaken core
  requirements)
  - `adapters/profiles/`: `STRICT_BASELINE.md`, `EMBEDDED_PROFILE.md`
    (fail-closed embedded verification evidence), and a worked
    project-specific embedded style overlay
  - `adapters/providers/`: `CLAUDE_CONTEXT_ADAPTER.md` and
    `CODEX_CONTEXT_ADAPTER.md` carry the Astaire port-of-first-resort clause
    and RTK install guidance for each provider. The per-provider `claude/`
    and `codex/` subtrees each ship a `CODEGRAPH.md` source-intelligence
    adapter; `claude/` additionally ships slash commands (`farley-review`,
    `find-gaps`, `mutate`) and skills (characterisation-tests,
    domain-driven-design, find-gaps, finding-seams, hexagonal-architecture,
    mutation-testing, story-splitting, tdd, test-design-reviewer)
  - `adapters/tooling/`: `RTK_CONTEXT_ADAPTER.md` (RTK manifest mapping and
    token discipline) and `HIL_SIL_PREDICATE_ROUTER.md`
    (Hardware-/Software-in-the-Loop scenario predicate routing)
- `contracts/`: Machine-validated interfaces —
  `governance-manifest.schema.json` with its canonical
  `governance-manifest.example.yaml`, the board artifact schemas
  (`board-member-profile`, `board-composition`, `board-finding`,
  `board-decision`), `implementation-handoff.schema.json`,
  `harness-metrics-row.schema.json` (per-row harness-metrics emit contract,
  new in v1.2.1), and `embedded-verification-checklist.example.md`
- `runbooks/`: Operational procedures — 16 documents, enumerated in full
  under "Runbooks" below
- `validation/`: `CONSISTENCY_RULES.md` (cross-document and contract rules),
  `architecture-fitness.yaml` (this repo's own forbidden-import rules), and
  `fixtures/` with positive/negative consumer manifests (`prototype`, `mvp`,
  `production`, `consumer-astaire`, `embedded-missing-evidence`) plus
  per-gate fixture suites (`analyzer-capability`, `architecture`,
  `bootstrap-new`, `bootstrap-retrofit`, `codegraph`, `glossary`,
  `mutation`, `validators`)
- `scripts/`: Bootstrap and validation tooling — `bootstrap_project.sh`,
  `validate_bootstrap.sh`, `validate_governance.sh`,
  `validate_astaire_wiring.sh`, `validate_chunk_scope.sh`,
  `validate_codegraph_wiring.sh`, `emit_release_evidence.sh`, the
  `validators/` Python analyzer-gate validators (governance gates, mutation
  threshold, glossary coverage, architecture fitness), and `validation/`
  (CodeGraph MCP shape-smoke harness)
- `templates/`: Reusable consumer-facing templates — board review artifacts
  (selection dossier, member profile, composition approval, review packet,
  meeting, opportunity register), agent wiring
  (`AGENTS_BOOTSTRAP_TEMPLATE.md`, `AGENTS_RTK_SNIPPET_TEMPLATE.md`,
  `ASTAIRE_CLI_SNIPPET.md`, `RTK_INSTRUCTIONS_TEMPLATE.md`,
  `RTK_LOCAL_WRAPPER_TEMPLATE.sh`), CodeGraph consumer wiring
  (`CODEGRAPH_CONTRACT_TEMPLATE.md` and the `codegraph/` wrapper scripts,
  Dockerfile, and config fragments), governance evidence scaffolding
  (`exceptions.template.yaml`, `signoffs.template.md`,
  `traceability.template.md`, `GOVERNANCE_AMENDMENTS_README_TEMPLATE.md`),
  and Phase 9 adoption aids (`ANALYZERS_PHASE_9_TEMPLATE.yaml`,
  `DOMAIN_GLOSSARY_CONTEXT_TEMPLATE.md`, `MIGRATION_PHASE_9.md`)

Legacy flat-layout policy files remain at the repository root for
compatibility; canonical content lives in `core/` (see `MIGRATION.md`).

Consuming repositories MAY also maintain an optional local overlay at `docs/governance/amendments/`. That overlay lives outside this repository and is intended for project-specific tightening that should not be upstreamed into the shared baseline.

## Versioning and Compatibility

- SemVer tags: `vMAJOR.MINOR.PATCH`
- Consumers pin to tags, not branches
- Breaking governance changes require:
  - Major version bump
  - Migration notes
  - Updated compatibility matrix
- Version-by-version compatibility and tentacle pins:
  `runbooks/COMPATIBILITY_MATRIX.md`
- Consumer migration steps per release: `MIGRATION.md`

## Consumer Model

1. Add this repository as a submodule from the published consumer bootstrap branch or pin directly to the release tag.
2. Add `governance.yaml` in the consuming repo root using `contracts/governance-manifest.example.yaml`.
3. Enable strict baseline profile.
4. Add `tooling/rtk` when the consuming repo uses `providers/claude` or `providers/codex`.
5. For portable repo-local RTK tracking, use `templates/RTK_LOCAL_WRAPPER_TEMPLATE.sh` with `.rtk/history.db` ignored from version control.
6. If project-specific governance tightening is needed, add an optional local overlay at `docs/governance/amendments/` in the consuming repo.
7. Validate governance with `scripts/validate_governance.sh` from the consumer repo root when possible so optional overlay checks can run too, and validate bootstrap completeness with `scripts/validate_bootstrap.sh`.

## Required Core Policies

- Planning gate and ambiguity reduction: `core/PLANNING_METHODOLOGY.md`
- Test-driven requirements and evidence: `core/AI_ASSISTED_TDR_METHODOLOGY.md`
- Branching and release controls: `core/GIT_BRANCH_STRATEGY.md`
- Autonomous delivery state machine and risk-tier policy: `core/AUTONOMOUS_DELIVERY_GOVERNANCE.md`
- Code implementation complexity controls: `core/CODE_IMPLEMENTATION_COMPLEXITY_GOVERNANCE.md`
- Code-intelligence tier model, evidence, and freshness rules: `core/CODE_INTELLIGENCE_GOVERNANCE.md`
- Ubiquitous-language authoring and glossary coverage: `core/DOMAIN_LANGUAGE_GOVERNANCE.md`
- Ports-and-adapters modularity discipline: `core/MODULARITY_GOVERNANCE.md`
- Mutation-testing evidence production and gating: `core/MUTATION_EVIDENCE.md`
- Board review governance, expert-agent selection, and integration lane: `core/BOARD_REVIEW_GOVERNANCE_METHODOLOGY.md`
- Exceptions and waivers: `core/EXCEPTIONS_AND_WAIVERS.md`
- AI-assisted security controls: `core/SECURITY_CONTROLS.md`
- Evidence contract: `core/EVIDENCE_CONTRACT.md`
- Specification-evasion resistance, M1-M4 blocking mechanisms, and boundary invariants: `core/ACCEPTANCE_INTEGRITY.md`
- Gate/oracle design: tiered checks, PARTIAL verdicts, and margin reporting: `core/GATE_DESIGN.md`
- Harness metrics feedback loop and no-silent-zero rule: `core/HARNESS_METRICS.md`

## Runbooks

- Astaire read discipline and CLI surface: `runbooks/ASTAIRE_ACCESS.md`
- Astaire tentacle bootstrap: `runbooks/ASTAIRE_BOOTSTRAP.md`
- Autonomous delivery operations: `runbooks/AUTONOMOUS_DELIVERY_OPERATIONS.md`
- Board review operations: `runbooks/BOARD_REVIEW_OPERATIONS.md`
- Branch protection baseline: `runbooks/BRANCH_PROTECTION_BASELINE.md`
- Compatibility matrix: `runbooks/COMPATIBILITY_MATRIX.md`
- Glossary authoring: `runbooks/GLOSSARY_AUTHORING.md`
- Mutation testing operations: `runbooks/MUTATION_TESTING.md`
- New-project and retrofit bootstrap: `runbooks/PROJECT_BOOTSTRAP.md`
- Publish workflow: `runbooks/PUBLISH_WORKFLOW.md`
- Release process and checklist: `runbooks/RELEASE_PROCESS.md`
- RTK adoption: `runbooks/RTK_ADOPTION_RUNBOOK.md`
- Scenario ledger operations: `runbooks/SCENARIO_LEDGER_RUNBOOK.md`
- Consumer submodule operations: `runbooks/SUBMODULE_CONSUMER_RUNBOOK.md`
- Tentacle submodule pinning: `runbooks/SUBMODULE_PINNING.md`
- Test design review: `runbooks/TEST_DESIGN_REVIEW.md`

## Publishing Baseline

- Default branch protected
- CODEOWNERS enforced
- Required CI checks enabled (`.github/workflows/governance-consistency.yml`
  runs `scripts/validate_governance.sh` on every pull request and push to
  `main`)
- Source-repo development lands on `main`; releases are cut as annotated
  SemVer tags per `runbooks/RELEASE_PROCESS.md`
- `consumer/bootstrap-*` branches are the human-readable bootstrap surfaces
  cut per bootstrap line (most recent: `consumer/bootstrap-v1.1.0`);
  consumers pin release tags for stable consumption
