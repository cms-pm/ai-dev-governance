# Compatibility Matrix

| Governance Version | Consumer Compatibility | Migration Required | Tentacle Pins |
|--------------------|------------------------|--------------------|---------------|
| v0.6.1             | strict                 | Yes (adds `graphify` manifest object with promotion/import knobs, routing grammar, validation script, strict Astaire L0 routing, the consumer bootstrap release branch model, and the shared-venv Astaire wrapper/bootstrap contract) | `astaire` @ `v0.3.1` (`0699b33`); `graphify` @ `v1.0.0` (`0a31c08`) |
| v0.5.x             | strict                 | Yes (strict Claude/Codex consumers must add `tooling/rtk`, retain RTK evidence, may adopt the repo-local RTK wrapper pattern from v0.5.1 onward, and may use consumer-local overlays from v0.5.2 onward) | — |
| v0.4.x             | strict                 | Yes (adopt chunk-scope CI gate and atomic SCN scope policy) | — |
| v0.3.x             | strict                 | Yes (add `automation`, `boardReview.selection`, and `boardReview.composition` in strict baseline manifests) | — |
| v0.2.x             | strict                 | Yes (add `boardReview` to manifest for strict baseline consumers) | — |
| v0.1.x             | strict                 | No                 | — |

## Python Runtime (graphify / Astaire)

| Component | Declared range (pyproject) | Tested range | Notes |
|-----------|----------------------------|--------------|-------|
| graphify  | `>=3.10`                   | 3.11, 3.12   | 3.14 breaks the heavy dep stack (`graspologic` → `gensim`/`numba`/`llvmlite`). Use a dedicated 3.12 venv (`.graphify-venv`) if the repo's primary `.venv` is on 3.13+. |
| Astaire   | `>=3.10`                   | 3.11, 3.12   | Default consumer wrapper reuses the shared `.astaire/.venv` entrypoint and falls back to `uv sync` only during bootstrap; pin interpreter explicitly with `UV_PYTHON=3.12` if the system interpreter is outside the tested range. |

`scripts/run_graphify.sh` preflights the interpreter and fails loudly when it
is outside the tested range — this is a soft guard that can be overridden with
`GRAPHIFY_ALLOW_UNTESTED_PYTHON=1` when you need to experiment on a newer
Python release.

## Rules

- Minor and patch versions are backward compatible unless explicitly declared otherwise.
- Major versions may require manifest and policy migration.
- Strict baseline consumers should keep board review and automation controls enabled from v0.3.x onward, enforce chunk-scope validation from v0.4.x onward, and enable `tooling/rtk` for Claude/Codex workflows from v0.5.x onward.
