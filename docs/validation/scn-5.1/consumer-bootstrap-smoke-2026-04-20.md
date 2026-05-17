# SCN-5.1 Consumer Bootstrap Smoke — 2026-04-20

## Goal

Prove that the published consumer bootstrap branch can be incorporated into a
fresh repo and successfully bootstrap a downstream project.

## Published Inputs

- Governance branch: `consumer/bootstrap-v0.6.0`
- Governance tag: `v0.6.0`
- Astaire tag in nested submodule: `v0.3.0`

## Smoke Procedure

```bash
git init <tmp>
git submodule add -b consumer/bootstrap-v0.6.0 https://github.com/cms-pm/ai-dev-governance.git .governance/ai-dev-governance
git submodule update --init --recursive
.governance/ai-dev-governance/scripts/bootstrap_project.sh --retrofit --force
.governance/ai-dev-governance/scripts/validate_bootstrap.sh
```

## Observed Result

- Bootstrap script completed successfully.
- Consumer repo gained:
  - `.astaire/astaire`
  - `.gitignore` Astaire entries
  - `governance.yaml`
  - provider-appropriate bootstrap file (`CLAUDE.md`)
  - `docs/planning/pool_questions/`
  - `docs/releases/`
  - `docs/governance/amendments/`
- Astaire startup ran successfully during retrofit and initialized
  `.astaire/memory_palace.db`.
- `validate_bootstrap.sh` passed in the fresh consumer repo.

## Important Fixes Confirmed By This Smoke

- Offline-safe Astaire wrapper path (`uv --no-project --with tiktoken`)
- Retrofit path now chooses the provider-correct bootstrap file
- Retrofit path now initializes Astaire before telling the user to validate

## Status

Pass
