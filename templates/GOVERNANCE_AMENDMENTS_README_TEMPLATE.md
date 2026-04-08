# Governance Amendments README Template

Use this file at `docs/governance/amendments/README.md` in a consuming repository when project-local governance tightening is needed.

## Purpose

This folder is the optional consumer-local governance overlay. It exists so project-specific constraints, focus overlays, or temporary interpretation layers can live in the product repository without modifying the shared `ai-dev-governance` submodule.

## Load Order

1. `governance.yaml`
2. pinned `ai-dev-governance` release
3. this local `docs/governance/amendments/` overlay

## Rules

- Content here MAY further constrain local execution, review focus, or artifact expectations.
- Content here MUST NOT weaken the shared baseline.
- Content here MUST NOT be treated as upstream `ai-dev-governance` behavior unless separately proposed and accepted upstream.
- If an amendment becomes broadly reusable, upstream it instead of treating this folder as a permanent fork.

## Active Amendments

- `<amendment-path>`

## Retirement / Supersession

- Archive or supersede amendments explicitly.
- Do not silently rewrite amendment history once a board or release packet has cited it.
