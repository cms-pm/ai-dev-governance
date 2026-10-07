# SCN-12.3 — Phase 11 fix salvage: validator evidence (2026-10-07)

Three scratch consumers bootstrapped with
`scripts/bootstrap_project.sh --new <dir> --governance-url <this branch>`
(`protocol.file.allow=always` for the local-path submodule), then validated
with `CONSUMER_ROOT=<dir> scripts/validate_bootstrap.sh`.

| Consumer | Planted violation | Expected | Observed | Log | Acceptance |
|---|---|---|---|---|---|
| healthy | none | exit 0, 13 checks | exit 0, 13 checks | `healthy.log` | SCN-12.3-03 |
| notentacle | `.governance/ai-dev-governance/astaire/` emptied | exit 1, explicit tentacle FAIL | exit 1, `[FAIL] Astaire tentacle missing or uninitialized` | `notentacle.log` | SCN-12.3-01 (R-11-08) |
| nowrapper | `.astaire/astaire` removed | exit 1, no `[PASS]` for the wrapper | exit 1, 3 FAILs, 0 `[PASS] .astaire/astaire present` lines | `nowrapper.log` | SCN-12.3-02 (R-11-09) |

R-11-09 named check 1 only; the same unconditional-PASS shape existed in
checks 2–6 and is fixed by the same `pass_unless_failed` guard.

## Issue #3 (`--root .` resolution)

In the healthy consumer, `.astaire/astaire scan --root .` registered the
consumer's own `governance.yaml` and `docs/releases/bootstrap/*-bundle.md`
(not submodule paths). The generated wrapper no longer `cd`s into the
submodule, so `--root .` resolves to the consumer.
