---
phase: 10
stage_produced: plan
---

# Phase 10 — Chunk Plans (CodeGraph Tier-2 Code Intelligence)

Precondition: Phase 9 sign-off landed on `main` at commit `76d5cd9`
(branch `SCN-9.7`); release `ADG v1.0.0` cut at `f3ed5a1`. Phase 10
runs on the same trunk. Carry-forward risks R-8.2-02, R-8.2-05, R-9-04,
R-9-05 remain in monitor lane and are inherited unchanged.

Phase 10 adds a **Tier-2 code-intelligence prescription**: a container-
isolated, runtime-agnostic, rootless **CodeGraph (CG)** MCP server that
consumer repos wire into their `.mcp.json`. ADG ships *prescription
only* — Dockerfile, wrapper script, template fragments, adapter specs,
validator, runbook gate, new core policy. ADG does not run CG itself.

Two-tier doctrine (the new boundary contract):
- **Tier 1 — Astaire** (port of first resort, unchanged). In a consumer
  repo, Astaire's scope is *the ADG submodule path*. CG must never
  index that path.
- **Tier 2 — CodeGraph** owns the consumer's product code via MCP.

The authoritative architectural plan for this phase is
`/Users/cms/.claude/plans/let-s-turn-this-into-soft-sloth.md`. The SCNs
below are the ADG-compliant execution of that plan.

---

## SCN-10.0 — Bootstrap (chunk plan + planning artifacts + Astaire ingest)

- **Scope.** Meta-chunk. Produces every Phase 10 planning artifact:
  - `docs/planning/pool_questions/phase-10-codegraph.md` (Q1..Q5
    resolved; gate score `0.0287` ≤ `0.20`; confidence `4.10` ≥ `4.0`).
  - This chunk plan (`docs/planning/chunks/phase-10-chunks.md`).
  - `docs/planning/phase-10-risks.md` enumerating R-10-01..04 plus
    carry-forward monitoring of R-8.2-02, R-8.2-05, R-9-04, R-9-05.
  - `docs/planning/phase-10-todo.md` — running TO-DO ticked by
    SCN-10.1..SCN-10.10.
  - Traceability rows for SCN-10.0..SCN-10.10 appended to
    `docs/planning/traceability.md`.
  - Phase 10 sign-off row appended to `docs/planning/signoffs.md`
    (status `pending`).
  - `.astaire/astaire scan --root .` + lint 0/0.
- **Acceptance IDs.** SCN-10.0-01 (chunk plan), SCN-10.0-02 (pool Q&A),
  SCN-10.0-03 (risks), SCN-10.0-04 (TO-DO), SCN-10.0-05 (Astaire ingest
  verified), SCN-10.0-06 (signoffs + traceability rows appended).
- **Risk tier.** Low. Authoring only; no policy change.
- **Validation method.** Astaire `scan` + `lint` exit 0;
  `query --tag phase=10` returns the four new artifacts; signoffs row
  present with status `pending`.
- **Atomic PR scope.** Single commit on branch `SCN-10.0`.

## SCN-10.1 — Core policy authoring (new doc + amendments)

- **Scope.** Land one new core policy document and amend two existing
  ones, all in one commit so cross-references resolve atomically:
  - **New:** `core/CODE_INTELLIGENCE_GOVERNANCE.md` (two-tier
    doctrine, bounded-context glossary entries — Tier-1 Astaire,
    Tier-2 CG — under the `DOMAIN_LANGUAGE_GOVERNANCE.md` pattern;
    path-scope contract; freshness rule; evidence URIs
    `codegraphIndexFreshnessURI`, `codegraphImageDigestURI`).
  - **Amend** `core/EVIDENCE_CONTRACT.md` to register the two new
    URIs.
  - **Amend** `core/AUTONOMOUS_DELIVERY_GOVERNANCE.md` §evidence to
    note CG as an *optional* Tier-2 capability declaration (no
    required-presence at v1 — advisory pending first downstream
    adoption per R-10-02).
- **Acceptance IDs.** SCN-10.1-01 (CODE_INTELLIGENCE_GOVERNANCE
  on disk), SCN-10.1-02 (EVIDENCE_CONTRACT URIs), SCN-10.1-03
  (AUTONOMOUS_DELIVERY_GOVERNANCE note), SCN-10.1-04 (Astaire scan +
  lint 0/0).
- **Risk tier.** Medium (touches core policy + evidence contract).
- **Validation method.** Astaire scan + lint 0/0; cross-references
  resolve via `query`; three-tier glossary entries land under the
  `DOMAIN_LANGUAGE_GOVERNANCE.md` pattern (closes R-9-05-adjacent
  latent ambiguity for the code-intelligence bounded context — see
  SCN-10.10 closure for R-10-01).
- **Atomic PR scope.** Single commit on branch `SCN-10.1`.

## SCN-10.2 — Dockerfile + image build

- **Scope.** `templates/codegraph/Dockerfile` (multi-stage,
  `node:20-alpine@sha256:<PIN>`, `npm ci --ignore-scripts`, non-root
  `USER 10001:10001`, `NODE_OPTIONS=--disable-proto=delete`,
  `ENTRYPOINT ["node", ".../codegraph"]`).
  `templates/codegraph/Makefile.snippet` with `codegraph-image`
  target (buildx multi-arch amd64+arm64, BuildKit
  `--provenance=mode=max --sbom=true`; writes
  `.codegraph/image.digest` and `.codegraph/evidence/sbom.spdx.json`).
- **Acceptance IDs.** SCN-10.2-01 (Dockerfile on disk + digest-pinned
  base), SCN-10.2-02 (Makefile snippet on disk), SCN-10.2-03
  (reproducible-digest test with fixed `SOURCE_DATE_EPOCH`),
  SCN-10.2-04 (SBOM emission verified), SCN-10.2-05 (`docker inspect`
  confirms non-root USER + no capability adds).
- **Risk tier.** Medium (supply-chain surface).
- **Validation method.** `docker buildx build` on amd64 and arm64
  produces an image whose digest is reproducible across two
  consecutive builds (with `SOURCE_DATE_EPOCH` fixed); SBOM emitted;
  `docker inspect` confirms `User=10001:10001` and `CapAdd` empty.
- **Atomic PR scope.** Single commit on branch `SCN-10.2`.

## SCN-10.3 — Wrapper script (runtime-agnostic, rootless)

- **Scope.** `templates/codegraph/scripts/codegraph-mcp` (POSIX sh)
  and `codegraph-mcp.cmd` (Windows). Auto-detects podman → docker →
  nerdctl (override `ADG_CONTAINER_RUNTIME`). Reads digest from
  `.codegraph/image.digest`. Applies the full hardening matrix:
  `--read-only`, `--tmpfs /tmp:size=64m,mode=1777`, `--network=none`,
  `--cap-drop=ALL`, `--security-opt=no-new-privileges:true`,
  `--pids-limit=512`, `--memory=2g`, `--cpus=2`,
  `--ulimit nofile=4096:4096`, `--ipc=none`,
  `--user $(id -u):$(id -g)`, source mounted `:ro`, named volume for
  `.codegraph/` (avoids UID-mismatch pain), platform pin per host arch.
- **Acceptance IDs.** SCN-10.3-01 (POSIX wrapper on disk),
  SCN-10.3-02 (Windows wrapper on disk), SCN-10.3-03 (runtime
  auto-detection + override env var), SCN-10.3-04 (hardening matrix
  applied verbatim — every flag listed above), SCN-10.3-05
  (network-isolation proven by deliberate outbound-fetch failing
  fast).
- **Risk tier.** High (defines runtime trust boundary).
- **Validation method.** Wrapper executes on macOS (Docker Desktop),
  Linux (rootless Podman + rootless Docker), Windows (Docker Desktop /
  WSL2). `docker inspect` on a live container confirms every flag in
  the hardening matrix; `--network=none` proven by a deliberate
  outbound-fetch test inside the container failing fast.
- **Atomic PR scope.** Single commit on branch `SCN-10.3`.

## SCN-10.4 — Templates + Plan B

- **Scope.** Remaining `templates/codegraph/` files:
  - `.mcp.json.fragment` (Docker-invoked via wrapper, digest-pinned).
  - `.codegraphignore` (excludes ADG submodule path, `raw/`, `docs/`,
    build artifacts — mirrors the prior generated-ignore precedent).
  - `CLAUDE.md.fragment` (Tier-2 stanza in Astaire idiom; main
    session uses lightweight CG tools, Explore agents use
    `_explore`/`_context`, glob/grep/Read are fallback).
  - `settings.json.fragment` (eight `mcp__codegraph__*` allow
    entries).
  - `PLAN_B_LSDF.md` (one-page Plan B for Python-only / no-Docker
    consumers, reference-only — no vendoring).
- **Acceptance IDs.** SCN-10.4-01..05 (one per template file).
- **Risk tier.** Low.
- **Validation method.** All fragments parse as valid JSON / sh /
  markdown; `.codegraphignore` denies the ADG submodule path under a
  glob test; Plan B doc references `raw/lsdf-core/` for upstream and
  contains no prescriptive policy text.
- **Atomic PR scope.** Single commit on branch `SCN-10.4`.

## SCN-10.5 — Adapter specs (Claude + Codex)

- **Scope.** `adapters/providers/claude/CODEGRAPH.md` and
  `adapters/providers/codex/CODEGRAPH.md` (combined PR to avoid DRY
  drift on the shared Explore-agent prompt addendum — Phase 9 SCN-9.3
  precedent landed nine skills in one chunk). Each names the source-
  of-truth `core/CODE_INTELLIGENCE_GOVERNANCE.md`; each includes the
  verbatim Explore-agent prompt addendum (forbid re-Read of files CG
  returned; budget guidance; fallback path).
- **Acceptance IDs.** SCN-10.5-01 (claude adapter spec on disk),
  SCN-10.5-02 (codex adapter spec on disk), SCN-10.5-03 (Explore
  addendum byte-identical across both).
- **Risk tier.** Low.
- **Validation method.** Both files cite
  `core/CODE_INTELLIGENCE_GOVERNANCE.md` as source of truth;
  Explore-agent addendum is byte-identical across both (verified by
  `diff` over the addendum block); Astaire scan registers as
  `provider-skill` / adapter docs.
- **Atomic PR scope.** Single commit on branch `SCN-10.5`.

## SCN-10.6 — Graphify removal

- **Scope.** Remove Graphify from ADG entirely: delete the sibling-vendored
  submodule, remove Graphify wrapper/validator/fallback scripts, remove the
  manifest schema/example block and graphify fixtures, and update active
  governance docs to route source-code intelligence to CodeGraph/native tools
  only. Closes R-10-01 (code-intelligence bounded-context glossary ambiguity)
  in concert with the SCN-10.1 doctrine landing.
- **Acceptance IDs.** SCN-10.6-01 (Graphify submodule removed from
  `.gitmodules` and repository index), SCN-10.6-02 (Graphify scripts and
  fixtures removed), SCN-10.6-03 (manifest schema/example no longer declare
  `graphify`), SCN-10.6-04 (active ADG docs no longer instruct consumers to
  install or invoke Graphify).
- **Risk tier.** Medium (removes a previously published optional integration).
- **Validation method.** `git ls-files` has no Graphify integration files;
  governance schema/example reject/omit `graphify`; active README/runbook/core
  references point to Astaire, CodeGraph, RTK, or native tools only.
- **Atomic PR scope.** Single commit on branch `SCN-10.6`.

## SCN-10.7 — Consumer-side validator

- **Scope.** `scripts/validate_codegraph_wiring.sh` (mirrors
  `scripts/validate_astaire_wiring.sh` shape — Bash, `[PASS]/[FAIL]`,
  exit-0 on pass). Designed to run *in the consumer repo*. Asserts:
  - `.mcp.json` includes a `codegraph` server invoked via the wrapper
    (not raw `npx`).
  - `.codegraph/image.digest` exists; image present on host and
    matches digest.
  - `.codegraphignore` denies the ADG submodule path.
  - `.codegraph/` index timestamp ≥ most recent commit touching
    tracked source.
  - SBOM present at `.codegraph/evidence/sbom.spdx.json`.
- **Acceptance IDs.** SCN-10.7-01 (validator on disk),
  SCN-10.7-02 (positive fixture passes), SCN-10.7-03 (one negative
  fixture per required artifact fails with matching error line).
- **Risk tier.** Medium.
- **Validation method.** Run against a fixture consumer repo
  (positive case); run against fixtures missing each required
  artifact in turn (negative cases) and observe correct failure mode
  per artifact.
- **Atomic PR scope.** Single commit on branch `SCN-10.7`.

## SCN-10.8 — Anti-pattern denylist

- **Scope.** Extend `validate_codegraph_wiring.sh` with greps over
  `.mcp.json` and any wrapper override that fail on:
  `--privileged`, `--network=host`, `--pid=host`, `--ipc=host`,
  `--cap-add`, `--security-opt seccomp=unconfined`, docker-socket
  bind mounts (`/var/run/docker.sock`, `/run/docker.sock`),
  `:latest` image refs, raw `npx codegraph` in `.mcp.json`.
- **Acceptance IDs.** SCN-10.8-01 (denylist enumerated in validator),
  SCN-10.8-02 (paired positive + negative fixture per entry under
  `validation/fixtures/codegraph/`), SCN-10.8-03 (validator exit code
  matches expected per fixture).
- **Risk tier.** Medium (normative — defines what is forbidden).
- **Validation method.** Each denylist entry has a paired positive +
  negative fixture; validator exit code matches expected per fixture.
- **Atomic PR scope.** Single commit on branch `SCN-10.8`.

## SCN-10.9 — Runbook + release-evidence gate

- **Scope.** Update `runbooks/RELEASE_PROCESS.md` to add CG freshness
  gate: any consumer that declares CG in its `governance.yaml` (per
  SCN-10.1 evidence URIs) must emit `image.digest` and index freshness
  in release evidence. Define the CockpitVM pilot evidence *contract*
  (token/tool-call delta capture format) without requiring the
  evidence itself — R-10-04 monitor lane handles delivery.
- **Acceptance IDs.** SCN-10.9-01 (RELEASE_PROCESS diff references
  SCN-10.1 URIs), SCN-10.9-02 (pilot evidence-contract section
  byte-identical to format R-10-04 expects), SCN-10.9-03 (Astaire
  lint 0/0).
- **Risk tier.** Low.
- **Validation method.** Runbook diff cleanly references SCN-10.1
  evidence URIs; evidence-contract section is byte-identical to the
  format R-10-04 expects; Astaire lint 0/0.
- **Atomic PR scope.** Single commit on branch `SCN-10.9`.

## SCN-10.10 — Board review + signoff

- **Scope.** Phase 10 board packet, board meeting with eight lenses
  (incl. test-design per SCN-9.1), ratify the two-tier doctrine,
  close R-10-01, hand R-10-02 (downstream CG adoption), R-10-03
  (removed Graphify fallback), R-10-04 (CockpitVM pilot)
  to monitor lane, flip signoff row to `ratified` with approver
  `cms-pm` and date, append the closing TODO ticks. Mirrors SCN-9.7
  sign-off pattern.
- **Acceptance IDs.** SCN-10.10-01 (board packet on disk),
  SCN-10.10-02 (board meeting record on disk),
  SCN-10.10-03 (signoff row flipped to `ratified`),
  SCN-10.10-04 (traceability rows for SCN-10.0..10.10 all `done`),
  SCN-10.10-05 (R-10-01 closed; R-10-02/03/04 in monitor lane).
- **Risk tier.** High.
- **Validation method.** Board packet present; signoff row ratified;
  traceability rows for SCN-10.0..10.10 all show `done`;
  `.astaire/astaire lint` 0/0; Phase 9 carry-forward risks
  re-evaluated (R-8.2-02, R-8.2-05, R-9-04, R-9-05 disposition
  recorded).
- **Atomic PR scope.** Single commit on branch `SCN-10.10`.

---

## Sequencing DAG

```
SCN-10.0 (bootstrap)
    |
SCN-10.1 (core policy — gate for everything)
    |
    +--> SCN-10.2 (Dockerfile) --> SCN-10.3 (wrapper, pins to image)
    |                                   |
    |                                   v
    +--> SCN-10.4 (templates + Plan B; consumes Dockerfile + wrapper)
    |          |
    |          +--> SCN-10.5 (adapter specs)
    |          |
    |          +--> SCN-10.7 (validator harness) --> SCN-10.8 (denylist)
    |
    +--> SCN-10.6 (Graphify removal; independent after 10.1)

10.5, 10.6, 10.8 --> SCN-10.9 (runbook) --> SCN-10.10 (signoff)
```

Parallelizable lanes after SCN-10.1: `{10.2 → 10.3 → 10.4}` and `{10.6}`.

## Cross-phase coordination

Phase 9 risks R-8.2-02, R-8.2-05, R-9-04, R-9-05 remain in monitor lane.
Sprint critique each iteration re-checks downstream-consumer adoption
for the Phase 9 analyzer-capability blocks (R-8.2-02 / R-9-04), the
Phase 8.1 reciprocal entry on `main` (R-8.2-05), and the glossary
authoring authority (R-9-05). R-9-05's code-intelligence slice closes
at SCN-10.1 when the three-tier glossary lands; the broader R-9-05
remains under Phase 9 ownership.
