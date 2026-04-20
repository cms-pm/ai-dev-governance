# AI Dev Governance

`ai-dev-governance` is a reusable governance baseline for AI-assisted software development.

## Governance Principles

> **Port-of-first-resort.** Every agent call begins at Astaire's L0. L0 answers
> the majority directly; otherwise it routes — to a deeper Astaire projection
> (L1/L2), to graphify for structural traversal, to RTK-gated shell inspection,
> or further out. Agents never bypass the router; tentacles extend the reach
> without fragmenting the memory.

The principle is authoritative. `core/PLANNING_METHODOLOGY.md` §Context
Management and the `templates/` guidance cross-reference this section rather
than duplicating it.

The Astaire CLI surface MUST be in every agent's working context at all times.
See `runbooks/ASTAIRE_ACCESS.md` for the canonical surface and read-discipline
rule, and `templates/ASTAIRE_CLI_SNIPPET.md` for the consumer-facing variant to
paste into `AGENTS.md` / `CLAUDE.md`.

## Purpose

This repository provides a strict baseline that teams can reuse across projects via Git submodule, with provider, tooling, and project-specific adapters layered on top.

## Release Branch Model

The consumer-facing release branch is intentionally a tabula rasa baseline.
It keeps the reusable governance product and removes the source repository's
own delivery record.

What stays in the release branch:

- `core/`, `contracts/`, `runbooks/`, `templates/`, `scripts/`, `validation/`
- provider/tooling adapters
- nested tentacle submodules such as `astaire/` and `graphify/`
- versioning, changelog, migration, and compatibility documents

What does not ship in the release branch:

- this repository's own `docs/planning/`
- this repository's own `docs/releases/`
- this repository's own `docs/validation/`
- local dogfood inputs such as `raw/`
- generated graph artifacts such as `graphify-out/`

Use `scripts/prepare_release_branch.sh --apply` when cutting a consumer-facing
release branch from a development branch that still contains source-repo
artifacts.

## Integrated Stack

- **Astaire** is the broker of context. It keeps durable memory in SQLite,
  answers cheap questions at L0, and routes deeper requests instead of sending
  agents straight to raw files.
- **RTK** is the token-discipline layer. Shell-visible inspection, search, git,
  lint, and release workflows should flow through RTK-backed paths when
  possible.
- **graphify** adds structural-operational understanding. It plugs into
  Astaire as an explicit structural tentacle for planning, refactoring, feature
  work, and bug hunting.

## Repository Layout

- `core/`: Mandatory, provider-agnostic governance policies
- `adapters/`: Provider, tooling, and project overlays (cannot weaken core requirements)
- `contracts/`: Machine-validated interfaces (manifest schema and examples)
- `runbooks/`: Release, branch protection, board review, autonomous delivery, and submodule operations
- `validation/`: Consistency rules and sample consumer fixtures
- `scripts/`: Local validation tooling
- `templates/`: Reusable governance report templates

Consuming repositories MAY also maintain an optional local overlay at `docs/governance/amendments/`. That overlay lives outside this repository and is intended for project-specific tightening that should not be upstreamed into the shared baseline.

## Versioning and Compatibility

- SemVer tags: `vMAJOR.MINOR.PATCH`
- Consumers pin to tags, not branches
- Breaking governance changes require:
  - Major version bump
  - Migration notes
  - Updated compatibility matrix

## Consumer Model

1. Add this repository as a submodule.
2. Add `governance.yaml` in the consuming repo root using `contracts/governance-manifest.example.yaml`.
3. Enable strict baseline profile.
4. Add `tooling/rtk` when the consuming repo uses `providers/claude` or `providers/codex`.
5. For portable repo-local RTK tracking, use `templates/RTK_LOCAL_WRAPPER_TEMPLATE.sh` with `.rtk/history.db` ignored from version control.
6. If project-specific governance tightening is needed, add an optional local overlay at `docs/governance/amendments/` in the consuming repo.
7. Validate governance with `scripts/validate_governance.sh` from the consumer repo root when possible so optional overlay checks can run too.

Use recursive submodule init when bootstrapping because tentacles such as
`astaire/` and `graphify/` are nested under this governance repo and therefore
arrive as sub-sub-modules inside the consuming project.

When the consuming repo enables graphify, the intended flow is:

1. Run `scripts/run_graphify.sh` instead of invoking graphify directly.
2. Validate the graph posture with `scripts/validate_graphify.sh`.
3. Import the structural slice into Astaire through `.astaire/astaire graphify-import --root .`.
4. Let agents start from Astaire L0 and follow the emitted `route:` lines rather than reading graph artifacts ad hoc.

## Required Core Policies

- Planning gate and ambiguity reduction: `core/PLANNING_METHODOLOGY.md`
- Test-driven requirements and evidence: `core/AI_ASSISTED_TDR_METHODOLOGY.md`
- Branching and release controls: `core/GIT_BRANCH_STRATEGY.md`
- Autonomous delivery state machine and risk-tier policy: `core/AUTONOMOUS_DELIVERY_GOVERNANCE.md`
- Board review governance, expert-agent selection, and integration lane: `core/BOARD_REVIEW_GOVERNANCE_METHODOLOGY.md`
- Exceptions and waivers: `core/EXCEPTIONS_AND_WAIVERS.md`
- AI-assisted security controls: `core/SECURITY_CONTROLS.md`
- Evidence contract: `core/EVIDENCE_CONTRACT.md`

## Publishing Baseline

- Default branch protected
- CODEOWNERS enforced
- Required CI checks enabled
- Releases cut only from protected `main`

See `runbooks/RELEASE_PROCESS.md`, `runbooks/BOARD_REVIEW_OPERATIONS.md`, `runbooks/AUTONOMOUS_DELIVERY_OPERATIONS.md`, `runbooks/SUBMODULE_CONSUMER_RUNBOOK.md`, `runbooks/SUBMODULE_PINNING.md`, and `runbooks/RTK_ADOPTION_RUNBOOK.md`.
