# AI Dev Governance

`ai-dev-governance` is a reusable governance baseline for AI-assisted software
development. It is meant to be consumed from a downstream project as a
submodule, not copied piecemeal from this repo's authoring branch.

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

## Why Use It

`ai-dev-governance` gives a consuming project a working operating system for
AI-assisted delivery:

- **Astaire-first context routing** so agents start from durable low-token
  memory instead of raw file fan-out
- **RTK-guided shell discipline** so broad exploration, git inspection, and
  validation stay token-efficient
- **graphify structural awareness** so planning, refactoring, and bug-hunting
  can route through codebase topology instead of only prose artifacts
- **strict planning and evidence contracts** so changes are traceable,
  reviewable, and releasable
- **consumer bootstrap automation** so a new or existing repo can be wired into
  the baseline with the provided scripts instead of a manual checklist

The current public consumer release has been validated both locally and through
an external fresh-repo bootstrap smoke test.

## Purpose

This repository provides a strict baseline that teams can reuse across projects via Git submodule, with provider, tooling, and project-specific adapters layered on top.

## Get Started

Recommended consumer entrypoints for the current release:

- stable tag: `v0.6.0`
- dedicated bootstrap branch: `consumer/bootstrap-v0.6.0`

Downstream consumers should use the tag for stable pins and treat the
`consumer/bootstrap-*` branch as the human-readable bootstrap surface that the
release points to.

### New or Existing Project Bootstrap

```bash
git submodule add -b consumer/bootstrap-v0.6.0 https://github.com/cms-pm/ai-dev-governance.git .governance/ai-dev-governance
git submodule update --init --recursive
.governance/ai-dev-governance/scripts/bootstrap_project.sh --retrofit --force
.governance/ai-dev-governance/scripts/validate_bootstrap.sh
```

What this gives the consumer repo:

- repo-local Astaire wrapper at `.astaire/astaire`
- generated `governance.yaml`
- provider-appropriate bootstrap instructions in `AGENTS.md` / `CLAUDE.md`
- bootstrap directories under `docs/`
- recursive tentacle initialization for nested submodules such as Astaire and graphify

For submodule pinning guidance after bootstrap, see
`runbooks/SUBMODULE_CONSUMER_RUNBOOK.md`.

## Integrated Stack

- **Astaire** is the broker of context. It keeps durable memory in SQLite,
  answers cheap questions at L0, and routes deeper work outward only when
  needed.
- **RTK** is the token-discipline layer. Shell-visible exploration, search,
  git, lint, and release work should flow through RTK-backed paths whenever
  possible.
- **graphify** adds structural understanding. It plugs into Astaire as a
  tentacle for codebase topology, routing hints, and graph-derived planning
  context.

Current published tentacle releases used by the consumer baseline:

- `ai-dev-governance` — `v0.6.0`
- `astaire` — `v0.3.0`
- `graphify` — `v1.0.0`

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

1. Add this repository as a submodule from the published consumer bootstrap branch or pin directly to the release tag.
2. Add `governance.yaml` in the consuming repo root using `contracts/governance-manifest.example.yaml`.
3. Enable strict baseline profile.
4. Add `tooling/rtk` when the consuming repo uses `providers/claude` or `providers/codex`.
5. For portable repo-local RTK tracking, use `templates/RTK_LOCAL_WRAPPER_TEMPLATE.sh` with `.rtk/history.db` ignored from version control.
6. If project-specific governance tightening is needed, add an optional local overlay at `docs/governance/amendments/` in the consuming repo.
7. Validate governance with `scripts/validate_governance.sh` from the consumer repo root when possible so optional overlay checks can run too.

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
- Source-repo development lands on `main`
- Consumer-facing releases are published from the dedicated
  `consumer/bootstrap-*` branch and matching tag, not from `main`

See `runbooks/RELEASE_PROCESS.md`, `runbooks/BOARD_REVIEW_OPERATIONS.md`, `runbooks/AUTONOMOUS_DELIVERY_OPERATIONS.md`, `runbooks/SUBMODULE_CONSUMER_RUNBOOK.md`, `runbooks/SUBMODULE_PINNING.md`, and `runbooks/RTK_ADOPTION_RUNBOOK.md`.
