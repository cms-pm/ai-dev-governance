# v0.6.0 Release Evidence Bundle

Generated on: 2026-04-20
Release type: consumer-facing governance baseline

## Published Surfaces

- Governance release tag: `v0.6.0`
- Governance GitHub release: `https://github.com/cms-pm/ai-dev-governance/releases/tag/v0.6.0`
- Consumer bootstrap branch: `consumer/bootstrap-v0.6.0`
- Validated source branch: `release/bootstrap-tabula-rasa`
- Final governance release commit: `a23849d`

- Astaire release tag: `v0.3.0`
- Astaire GitHub release: `https://github.com/cms-pm/astaire/releases/tag/v0.3.0`
- Final Astaire release commit: `a17d8b4`

## Validation Summary

Validated locally on the governance release branch after the final Astaire `v0.3.0`
pin and offline-safe wrapper updates:

- `bash scripts/validate_governance.sh` — pass
- `bash scripts/validate_bootstrap.sh` — pass

Validated in a fresh downstream consumer smoke repo:

1. `git init <tmp>`
2. `git submodule add -b consumer/bootstrap-v0.6.0 https://github.com/cms-pm/ai-dev-governance.git .governance/ai-dev-governance`
3. `git submodule update --init --recursive`
4. `.governance/ai-dev-governance/scripts/bootstrap_project.sh --retrofit --force`
5. `.governance/ai-dev-governance/scripts/validate_bootstrap.sh`

Result: pass. See `docs/validation/scn-5.1/consumer-bootstrap-smoke-2026-04-20.md`.

## Release Notes

- The consumer-facing release is intentionally **not** cut from `main`.
- Downstream consumers should use the `v0.6.0` tag or the
  `consumer/bootstrap-v0.6.0` branch.
- The release branch is scrubbed of source-repo-specific planning, validation,
  release, and dogfood graph artifacts.
- Astaire is pinned to `v0.3.0`.
- The Astaire wrapper and bootstrap flow were updated to run Astaire directly
  from source via `uv --no-project --with tiktoken`, avoiding editable-build
  failures in restricted/offline environments.
