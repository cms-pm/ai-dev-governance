---
phase: 10
stage_produced: plan
---

# Phase 10 — Running TO-DO

Linked to: `docs/planning/chunks/phase-10-chunks.md`,
`docs/planning/pool_questions/phase-10-codegraph.md`,
`docs/planning/phase-10-risks.md`.

Each chunk ticks down its rows on merge. Evidence annotations are
appended in `(parens)` after each box is checked.

## SCN-10.0 — Bootstrap

- [x] Pool-questions doc on disk at
      `docs/planning/pool_questions/phase-10-codegraph.md`
      (Q1..Q5, gate score `0.0287` ≤ `0.20`, conf `4.10` ≥ `4.0`).
- [x] Chunk plan on disk at `docs/planning/chunks/phase-10-chunks.md`.
- [x] Risk log on disk at `docs/planning/phase-10-risks.md`
      (R-10-01..04 + R-8.2-02 / R-8.2-05 / R-9-04 / R-9-05
      carry-forward).
- [x] This TO-DO on disk.
- [x] Traceability rows for SCN-10.0..SCN-10.10 appended to
      `docs/planning/traceability.md` (all `pending`).
- [x] Phase 10 sign-off row appended to `docs/planning/signoffs.md`
      (status `pending`, score `0.0287`, conf `4.10`).
- [x] `.astaire/astaire scan --root .` + lint 0/0; chunk plan, pool
      questions, risks, and TO-DO registered (verify via
      `query -t chunk-plan --tag phase=10` etc.).

## SCN-10.1 — Core policy authoring

- [ ] `core/CODE_INTELLIGENCE_GOVERNANCE.md` on disk (three-tier
      doctrine, bounded-context glossary entries, path-scope contract,
      freshness rule, evidence URIs).
- [ ] `core/EVIDENCE_CONTRACT.md` amended with
      `codegraphIndexFreshnessURI` + `codegraphImageDigestURI`.
- [ ] `core/AUTONOMOUS_DELIVERY_GOVERNANCE.md` §evidence amended with
      Tier-2 optional-capability note (no required-presence at v1).
- [ ] Astaire scan + lint 0/0; cross-references resolve.

## SCN-10.2 — Dockerfile + image build

- [ ] `templates/codegraph/Dockerfile` on disk (multi-stage,
      `node:20-alpine@sha256:<PIN>`, `npm ci --ignore-scripts`,
      non-root `USER 10001:10001`, `NODE_OPTIONS=--disable-proto=delete`,
      `ENTRYPOINT` set).
- [ ] `templates/codegraph/Makefile.snippet` on disk (`codegraph-image`
      target, buildx multi-arch amd64+arm64, `--provenance=mode=max`,
      `--sbom=true`).
- [ ] Two consecutive `make codegraph-image` runs with fixed
      `SOURCE_DATE_EPOCH` produce identical digests.
- [ ] SBOM emitted at `.codegraph/evidence/sbom.spdx.json`.
- [ ] `docker inspect` confirms `User=10001:10001` and `CapAdd` empty.

## SCN-10.3 — Wrapper script (runtime-agnostic, rootless)

- [ ] `templates/codegraph/scripts/codegraph-mcp` (POSIX) on disk.
- [ ] `templates/codegraph/scripts/codegraph-mcp.cmd` (Windows) on disk.
- [ ] Runtime auto-detection (podman → docker → nerdctl) + override via
      `ADG_CONTAINER_RUNTIME`.
- [ ] Hardening matrix applied verbatim: `--read-only`,
      `--tmpfs /tmp:size=64m,mode=1777`, `--network=none`,
      `--cap-drop=ALL`, `--security-opt=no-new-privileges:true`,
      `--pids-limit=512`, `--memory=2g`, `--cpus=2`,
      `--ulimit nofile=4096:4096`, `--ipc=none`, `--user $(id -u):$(id -g)`,
      source bind-mounted `:ro`, named volume for `.codegraph/`.
- [ ] Network isolation proven by deliberate outbound-fetch failing
      fast inside the container.
- [ ] Wrapper executes on macOS, Linux (rootless podman + rootless
      docker), Windows (Docker Desktop / WSL2).

## SCN-10.4 — Templates + Plan B

- [ ] `templates/codegraph/.mcp.json.fragment` on disk (Docker-invoked
      via wrapper, digest-pinned).
- [ ] `templates/codegraph/.codegraphignore` on disk (excludes ADG
      submodule path, `raw/`, `docs/`, build artifacts).
- [ ] `templates/codegraph/CLAUDE.md.fragment` on disk (Tier-2 stanza
      in Astaire idiom).
- [ ] `templates/codegraph/settings.json.fragment` on disk (eight
      `mcp__codegraph__*` allow entries).
- [ ] `templates/codegraph/PLAN_B_LSDF.md` on disk (one-page Plan B,
      reference-only).
- [ ] `.codegraphignore` denies ADG submodule path under a glob test.

## SCN-10.5 — Adapter specs (Claude + Codex)

- [ ] `adapters/providers/claude/CODEGRAPH.md` on disk.
- [ ] `adapters/providers/codex/CODEGRAPH.md` on disk.
- [ ] Both cite `core/CODE_INTELLIGENCE_GOVERNANCE.md` as source of
      truth.
- [ ] Explore-agent prompt addendum byte-identical across both (verified
      by `diff` over the addendum block).
- [ ] Astaire scan registers both as provider-skill / adapter docs.

## SCN-10.6 — Graphify demotion

- [ ] Graphify skill registration under `graphify/skills/` scoped to
      research-corpus use (no code-navigation references).
- [ ] `.graphifyignore` at ADG root denies `scripts/`, `validation/`,
      `astaire/src/`, `adapters/` (explicit handoff to CG).
- [ ] `graphify/README.md` "Usage in ADG context" note on disk.
- [ ] Smoke test: `/graphify` against `raw/` still produces a wiki.
- [ ] R-10-01 closure annotated (in concert with SCN-10.1 doctrine).

## SCN-10.7 — Consumer-side validator

- [ ] `scripts/validate_codegraph_wiring.sh` on disk (mirrors
      `validate_astaire_wiring.sh` shape).
- [ ] Positive fixture under `validation/fixtures/codegraph/positive/`
      passes (exit 0).
- [ ] Negative fixtures (one per required artifact missing) fail with
      the matching error line.
- [ ] Validator invoked from `scripts/validate_governance.sh` only when
      consumer governance.yaml declares CG (per SCN-10.1 evidence URIs).

## SCN-10.8 — Anti-pattern denylist

- [ ] Denylist entries enumerated in `validate_codegraph_wiring.sh`:
      `--privileged`, `--network=host`, `--pid=host`, `--ipc=host`,
      `--cap-add`, `--security-opt seccomp=unconfined`,
      `/var/run/docker.sock`, `/run/docker.sock`, `:latest`,
      raw `npx codegraph`.
- [ ] Paired positive + negative fixture per entry under
      `validation/fixtures/codegraph/negative-<flag>/`.
- [ ] Validator exit code matches expected per fixture.

## SCN-10.9 — Runbook + release-evidence gate

- [ ] `runbooks/RELEASE_PROCESS.md` updated with CG freshness gate
      (image digest + index freshness for consumers that declare CG in
      `governance.yaml`).
- [ ] Pilot evidence-contract section (token/tool-call delta capture
      format) on disk — byte-identical to format R-10-04 expects.
- [ ] Astaire lint 0/0.

## SCN-10.10 — Board review + signoff

- [ ] Phase 10 board packet on disk at
      `docs/planning/board/committee-review-packet-<date>-scn-10-10.md`.
- [ ] Board meeting record on disk at
      `docs/planning/board/committee-virtual-meeting-scn-10-10-phase-signoff-<date>.md`.
- [ ] Eight board lenses applied (incl. test-design per SCN-9.1).
- [ ] Three-tier doctrine ratified.
- [ ] R-10-01 closed in `phase-10-risks.md`.
- [ ] R-10-02 / R-10-03 / R-10-04 handed to monitor lane.
- [ ] `signoffs.md` Phase 10 row flipped to `ratified` with approver
      `cms-pm` and date.
- [ ] `traceability.md` rows for SCN-10.0..SCN-10.10 all show `done`.
- [ ] `.astaire/astaire lint` 0/0.
- [ ] Phase 9 carry-forward risks (R-8.2-02, R-8.2-05, R-9-04, R-9-05)
      disposition recorded.

## Follow-ups (deferred to Phase 11)

- Governance manifest schema extension for CG capability (gated on
  R-10-02 outcome).
- CockpitVM pilot benchmark execution + close-or-rebaseline decision
  (R-10-04).
- Registry-publishing model for the CG image (build-locally remains
  the default; registry is a possible future ergonomics improvement).
