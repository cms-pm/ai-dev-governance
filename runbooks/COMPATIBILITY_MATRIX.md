# Compatibility Matrix

| Governance Version | Consumer Compatibility | Migration Required | Tentacle Pins |
|--------------------|------------------------|--------------------|---------------|
| v1.1.0             | strict                 | Yes (adds optional CodeGraph Tier-2 code-intelligence prescription, removes Graphify from the supported ADG integration surface, and adds declared-CG release evidence gates without requiring CG for non-declared consumers) | `astaire` @ `v0.5.0` (`ed16f6d`) |
| v1.0.0             | strict                 | Yes (ratifies Phase 9 empirical governance: mutation testing thresholds and release evidence, glossary/domain-language coverage, test design review, architecture fitness declarations, implementation handoffs, and Astaire-first release consumption) | `astaire` @ `v0.5.0` (`ed16f6d`) |
| v0.7.4             | strict                 | Yes (adds code implementation complexity governance for production-code changes, including ownership, naming/placement, line-count, state/task, complexity-rubric, and exception evidence) | `astaire` @ `v0.4.2` (`d6a49fc`) |
| v0.7.3             | strict                 | No (patch over v0.7.2 — bumps the bundled Astaire submodule to v0.4.2 to fix legacy `source.source_type` taxonomy migration when existing rows still reference `source` through foreign keys) | `astaire` @ `v0.4.2` (`d6a49fc`) |
| v0.7.2             | strict                 | No (patch over v0.7.0 — bumps the bundled Astaire submodule to v0.4.1 to fix a `KeyError: 'doc_type'` crash in `astaire scan` when the new scenario-ledger or scenario-predicate plugins register documents) | `astaire` @ `v0.4.1` (`6524ea1`) |
| v0.7.0             | strict                 | Yes (adds Scenario Status Vocabulary in `core/EVIDENCE_CONTRACT.md`, the HiL/SiL Predicate Router adapter at `adapters/tooling/HIL_SIL_PREDICATE_ROUTER.md`, and the Scenario Ledger Runbook at `runbooks/SCENARIO_LEDGER_RUNBOOK.md`; bumps Astaire pin to v0.4.0 to consume the new scenario-predicate and scenario-ledger collection plugins) | `astaire` @ `v0.4.0` (`d244699`) |
| v0.6.1             | strict                 | Yes (adds the consumer bootstrap release branch model and the shared-venv Astaire wrapper/bootstrap contract) | `astaire` @ `v0.3.1` (`0699b33`) |
| v0.5.x             | strict                 | Yes (strict Claude/Codex consumers must add `tooling/rtk`, retain RTK evidence, may adopt the repo-local RTK wrapper pattern from v0.5.1 onward, and may use consumer-local overlays from v0.5.2 onward) | — |
| v0.4.x             | strict                 | Yes (adopt chunk-scope CI gate and atomic SCN scope policy) | — |
| v0.3.x             | strict                 | Yes (add `automation`, `boardReview.selection`, and `boardReview.composition` in strict baseline manifests) | — |
| v0.2.x             | strict                 | Yes (add `boardReview` to manifest for strict baseline consumers) | — |
| v0.1.x             | strict                 | No                 | — |

## Python Runtime

| Component | Declared range (pyproject) | Tested range | Notes |
|-----------|----------------------------|--------------|-------|
| Astaire   | `>=3.10`                   | 3.11, 3.12   | Default consumer wrapper reuses the shared `.astaire/.venv` entrypoint and falls back to `uv sync` only during bootstrap; pin interpreter explicitly with `UV_PYTHON=3.12` if the system interpreter is outside the tested range. |

## Rules

- Minor and patch versions are backward compatible unless explicitly declared otherwise.
- Major versions may require manifest and policy migration.
- Strict baseline consumers should keep board review and automation controls enabled from v0.3.x onward, enforce chunk-scope validation from v0.4.x onward, enable `tooling/rtk` for Claude/Codex workflows from v0.5.x onward, adopt the Scenario Status Vocabulary plus scenario-ledger emission from v0.7.0 onward, collect implementation complexity evidence for production-code changes from v0.7.4 onward, adopt Phase 9 empirical governance evidence from v1.0.0 onward, and remove Graphify integration in favor of Astaire plus optional CodeGraph from v1.1.0 onward.
