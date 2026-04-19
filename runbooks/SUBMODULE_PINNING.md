# Submodule Pinning Runbook

Scope: governance for tentacle submodules consumed by `ai-dev-governance`
itself (currently `astaire/` and `graphify/`). Consumer-side pinning of
`ai-dev-governance` is covered in `SUBMODULE_CONSUMER_RUNBOOK.md`.

## Pin-at-Tag Rule

- Every tentacle submodule MUST be pinned at a signed or annotated upstream
  tag where one is available (for example, `graphify@v1.0.0`).
- The authoritative pin is the submodule SHA recorded in the superproject
  tree. `.gitmodules` SHOULD also carry a `branch = <tag>` annotation where
  the upstream tag is stable, so `git submodule update --remote` resolves
  against the intended ref.
- The pinned SHA MUST appear in `runbooks/COMPATIBILITY_MATRIX.md` for the
  governance version that first ships that pin.

## SHA-Bridge Exception Protocol

A SHA-bridge exception is required when a tentacle has no upstream tag that
captures the state we depend on. Conditions:

- Bridge SHAs MUST be recorded in `docs/governance/exceptions.yaml` with:
  - `id` (short kebab-case)
  - `reason` (why no tag is available yet)
  - `target` (upstream issue URL or tag request)
  - `expires` (YYYY-MM-DD, no more than one quarter out)
  - `owner` (accountable human)
- Bridge SHAs MUST NOT remain in place across two consecutive governance
  minor versions without renewal.
- When the upstream tag is cut, the exception MUST be closed out in the
  same PR that advances the pin.

## Quarterly Refresh Cadence

- A submodule-pin review MUST run every quarter.
- The review produces a short note in `docs/releases/` summarising: pins
  examined, pins advanced, exceptions renewed or closed, deferred bumps.
- Quarterly review is an accountable human signoff; LLM chat may assist
  but cannot serve as sole approver.

## Emergency Patch Lane

- A pin MAY be advanced outside the quarterly window if an upstream
  patch addresses a security issue, data-loss bug, or governance-breaking
  behaviour.
- Emergency bumps MUST still land as an atomic PR with:
  - SCN ID
  - Compatibility matrix row update
  - Evidence bundle entry
  - Board review where the risk tier requires it
- Emergency bumps MUST NOT skip the compatibility matrix update, even if
  the governance version does not change.

## Compatibility Matrix Shape

`runbooks/COMPATIBILITY_MATRIX.md` is the single source of truth for which
tentacle pins correspond to which governance version. Each row carries:

- Governance version
- Consumer compatibility profile
- Migration required (yes/no, with short rationale)
- Tentacle pins (submodule path → tag or bridge SHA + exception ID)

Rows are append-only. Historical rows MUST NOT be rewritten; correctional
notes belong in a new row.
