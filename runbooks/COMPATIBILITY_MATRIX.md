# Compatibility Matrix

| Governance Version | Consumer Compatibility | Migration Required | Tentacle Pins |
|--------------------|------------------------|--------------------|---------------|
| v0.6.0 (planned)   | strict                 | Yes (adds `graphify` manifest object with securityMode/collectionStrategy/allowlist; strict Claude/Codex consumers wire Astaire L0 as port-of-first-resort) | `astaire` @ `v0.2.2` (`a4b28fd`); `graphify` @ `v1.0.0` (`0a31c08`) |
| v0.5.x             | strict                 | Yes (strict Claude/Codex consumers must add `tooling/rtk`, retain RTK evidence, may adopt the repo-local RTK wrapper pattern from v0.5.1 onward, and may use consumer-local overlays from v0.5.2 onward) | — |
| v0.4.x             | strict                 | Yes (adopt chunk-scope CI gate and atomic SCN scope policy) | — |
| v0.3.x             | strict                 | Yes (add `automation`, `boardReview.selection`, and `boardReview.composition` in strict baseline manifests) | — |
| v0.2.x             | strict                 | Yes (add `boardReview` to manifest for strict baseline consumers) | — |
| v0.1.x             | strict                 | No                 | — |

## Rules

- Minor and patch versions are backward compatible unless explicitly declared otherwise.
- Major versions may require manifest and policy migration.
- Strict baseline consumers should keep board review and automation controls enabled from v0.3.x onward, enforce chunk-scope validation from v0.4.x onward, and enable `tooling/rtk` for Claude/Codex workflows from v0.5.x onward.
