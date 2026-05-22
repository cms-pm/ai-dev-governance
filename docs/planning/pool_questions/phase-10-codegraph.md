---
phase: 10
stage_produced: plan
---

# Phase 10 Pool — CodeGraph Tier-2 Code Intelligence

## Goal

Add a **Tier-2 code-intelligence prescription** to ADG: a container-
isolated, runtime-agnostic, rootless **CodeGraph (CG)** MCP server that
consumer repos wire into their `.mcp.json`. CG presents ambient
`mcp__codegraph__*` tools that Explore agents reach for by default,
eliminating the wasteful glob/grep/Read churn observed during refactors
of large monolithic sources in downstream repos.

Establish a **two-tier doctrine** with disjoint path scopes:
- **Tier 1 — Astaire** owns governance artifacts. Within a consumer
  repo, Astaire's scope is *the ADG submodule path*. CG must never index
  that path.
- **Tier 2 — CodeGraph** owns the consumer's product code via MCP.

ADG ships *prescription only* — Dockerfile, wrapper script, template
fragments, adapter specs, validator, runbook gate, new core policy. ADG
does not run CG itself. Phase 9 precedent (R-8.2-02 / R-9-04) governs
adoption-as-monitored-risk: the CockpitVM pilot is registered as
R-10-04, not gating phase signoff.

## Carry-forward inputs

**From `docs/planning/phase-9-risks.md` (monitor lane):**

- R-8.2-02 (Medium / Medium) — static-analyzer-capability downstream
  adoption pending. Phase 10's CG prescription introduces an analogous
  downstream-adoption pattern (R-10-02); the closure cadence mirror is
  intentional.
- R-8.2-05 (High / Medium) — Phase 8.1 reciprocal entry on `main` still
  outstanding. Phase 10 carries the same standing sprint-critique read.
- R-9-04 (Medium / Low) — manifest-schema downstream adoption pending.
  Phase 10 does not extend the manifest schema at v1 (deferred to Phase
  11 per R-10-02 outcome); same backward-compat discipline inherited if
  it eventually lands.
- R-9-05 (Medium / Medium) — glossary authoring authority drift. The
  Phase 10 three-tier doctrine adds a new bounded context
  (code-intelligence) under `DOMAIN_LANGUAGE_GOVERNANCE.md`; closure
  of the code-intelligence slice is owned by SCN-10.1 / SCN-10.10.

**From the approved architectural plan
(`/Users/cms/.claude/plans/let-s-turn-this-into-soft-sloth.md`):**

The top-level decision now prescribes CG as the ambient code-navigation
surface and removes Graphify from ADG entirely. LSDF-core remains the
documented Plan B for Python-only / no-Docker consumers (reference only — no vendoring). The
SCNs below are the ADG-compliant execution of that plan.

## Scope

Authoring only at the ADG layer:
- One new core policy (`core/CODE_INTELLIGENCE_GOVERNANCE.md`) +
  amendments to `core/EVIDENCE_CONTRACT.md` and
  `core/AUTONOMOUS_DELIVERY_GOVERNANCE.md`.
- Templates under `templates/codegraph/` (Dockerfile, Makefile snippet,
  `.mcp.json.fragment`, `.codegraphignore`, `CLAUDE.md.fragment`,
  `settings.json.fragment`, `PLAN_B_LSDF.md`, wrapper scripts).
- Adapter specs under `adapters/providers/{claude,codex}/CODEGRAPH.md`.
- Consumer-side validator (`scripts/validate_codegraph_wiring.sh`) +
  positive/negative fixtures.
- Runbook gate update in `runbooks/RELEASE_PROCESS.md`.
- Graphify removal from ADG integration surfaces.
- Board sign-off mirroring SCN-9.7.

Out of scope:
- Running CG in this repo. ADG is *not* a CG consumer.
- Extending the governance manifest schema for CG capability. Deferred
  to Phase 11 pending R-10-02 monitor outcome.
- CockpitVM pilot benchmark execution. Registered as R-10-04 monitor
  lane post-SCN-10.10.

---

## Resolved Questions

### Q1 — Tool selection: CodeGraph vs LSDF-core vs Graphify removal

**Resolution.** Adopt CodeGraph as Tier-2; document LSDF-core as Plan B;
remove Graphify from ADG entirely.

**Reasoning.** Graphify's non-adoption root cause is invocation shape
(slash-command opt-in vs ambient MCP), output shape (files to Read
vs queryable primitives), and a top-level decision to remove the tool from
the ADG supported surface rather than maintain a narrowed role. CG presents
ambient `mcp__codegraph__*` tools
that Explore agents will reach for by default and returns symbol-graph
primitives directly. Upstream benchmark across 7 codebases: ~35% cost /
~70% tool-call reduction. LSDF-core is Python-only with no MCP/query
API — appropriate as Plan B for consumers that cannot run Docker.

### Q2 — Indexing scope: who indexes what?

**Resolution.** The indexed codebase is the **consumer** of ADG, not
ADG itself. CG indexes consumer product code only and never the ADG
submodule path. Astaire continues to own the ADG submodule path within
the consumer. Graphify is not part of the ADG-supported integration surface.

**Reasoning.** ADG is shipped as a submodule. If CG indexed the ADG
submodule path in a consumer, the agent's first answer on a CG query
would frequently surface ADG policy text instead of consumer code,
flipping the tier hierarchy and re-introducing the Tier-1/Tier-2 scope
overlap that Astaire was built to eliminate. The `.codegraphignore`
template denies the ADG submodule path; the consumer-side validator
enforces it.

### Q3 — Isolation: how does CG run without polluting the agent environment?

**Resolution.** Container-isolated, runtime-agnostic, rootless. ADG
ships a Dockerfile (multi-stage, digest-pinned `node:20-alpine`, non-
root `USER 10001:10001`, `--ignore-scripts` on npm ci) and a POSIX +
Windows wrapper that auto-detects podman → docker → nerdctl (override
`ADG_CONTAINER_RUNTIME`). The MCP transport stays stdio; the wrapper
substitutes `docker run` for `npx codegraph`.

**Reasoning.** Mirrors Anthropic MCP best practices: per-invocation
container, `--read-only` rootfs, `--tmpfs /tmp`, `--network=none`,
`--cap-drop=ALL`, `--security-opt=no-new-privileges`, resource caps
(`--pids-limit`, `--memory`, `--cpus`, `--ulimit nofile`), `--ipc=none`.
Source is bind-mounted `:ro`; index lives in a named volume to avoid
cross-platform UID-mismatch pain. Multi-arch BuildKit (amd64 + arm64)
with `--provenance=mode=max --sbom=true` produces reproducible digests
under fixed `SOURCE_DATE_EPOCH`.

### Q4 — Supply-chain trust model: published registry or build-locally?

**Resolution.** Build-locally. Consumers run `make codegraph-image` and
the resulting digest is committed to `.codegraph/image.digest`. The
wrapper resolves the image by digest only. SBOM lives at
`.codegraph/evidence/sbom.spdx.json`.

**Reasoning.** ADG has no package-distribution surface today and adding
one for a single tool would over-couple the kit to release ops in a
specific registry. Digest-pinning + locally-built reproducibility +
SBOM emission satisfies the chain-of-custody requirement without
introducing a publishing dependency. Closure of registry-publishing as
a future possibility lives in Phase 11 monitor lane (out of scope).

### Q5 — Adoption-as-risk: how does CG land in downstream consumers?

**Resolution.** Monitor-lane adoption mirroring R-8.2-02 / R-9-04.
SCN-10.10 ratifies the doctrine; downstream CG adoption (CockpitVM
expected first), removed-Graphify fallback effects, and the CockpitVM
benchmark all land as R-10-02, R-10-03, R-10-04 respectively under the
Phase 10 → Phase 11 monitor-lane carry-forward.

**Reasoning.** ADG's standing pattern for "prescription lands, evidence
of consumer adoption follows" is exactly this monitor-lane shape. The
release-evidence gate in `RELEASE_PROCESS.md` activates only for
consumers that *declare* CG in their governance.yaml; for non-CG
consumers the gate is silent. This preserves Plan B (LSDF / no-tool)
without coercing adoption.

---

## Gate Score & Confidence

- **Ambiguity score:** `0.0287` ≤ `0.20` (gate-PASS).
- **Confidence:** `4.10` ≥ `4.0` (gate-PASS).

Scoring follows the Phase 9 cadence:
`ambiguity = unresolved_questions / total_questions` (0/5 = 0; plus the
0.0287 penalty for Plan-B latent ambiguity acknowledged in Q1);
confidence on a 1–5 scale weighted by precedent strength (Phase 8.2 /
Phase 9 mirror), reproducibility of the build-locally model, and
prior-art adoption (Anthropic MCP best practices).
