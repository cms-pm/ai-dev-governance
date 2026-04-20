# Agent Instructions — bootstrap-retrofit fixture

This fixture represents an existing project after `bootstrap_project.sh
--retrofit --force`. The project had its own pre-existing content above
the managed block; the bootstrap run appended the block without touching
the pre-existing content. This verifies SCN-D-02: files outside the
bootstrap contract are not touched, and the marker-comment update is
in-place idempotent.

## Pre-existing project instructions

This content was already here before retrofit. It is preserved verbatim.

- Use feature branches.
- All PRs require one approval.

<!-- ai-dev-governance:bootstrap:start -->

## Governance tools — When, How, and Where

### Astaire — port-of-first-resort (MANDATORY)

**Where:** `.astaire/astaire` at repo root. This wrapper sets `--db`
to `.astaire/memory_palace.db` and delegates to the pinned submodule.
**Never** invoke bare `astaire` — it is not on PATH and will use the
wrong database.

**When:** Before reading any `docs/planning/**`, `docs/releases/**`,
board artifact, or governance core policy. Direct file reads (`Read`,
`cat`, editor open) are only permitted when:
1. Astaire has no projection for the target (new artifacts being authored), or
2. The read is in immediate service of an `Edit` / `Write` on that file.

**How — session start:**
```bash
.astaire/astaire startup --root .   # init + scan + sync + status
```

**How — routine queries:**
```bash
.astaire/astaire status
.astaire/astaire query -t chunk-plan --tag phase=<n>
.astaire/astaire context --tag phase=<n> --budget 6000
.astaire/astaire query --fts "<terms>"   # avoid hyphens in FTS terms
.astaire/astaire scan --root .           # after writing new artifacts
.astaire/astaire lint                    # before release or gate review
```

| Subcommand | Purpose |
|---|---|
| `startup` | First action every session. |
| `status` | Current knowledge-base state. |
| `query` | Lookup by collection, type, tag, or FTS. |
| `context` | Token-budgeted bundle for planning/implementation. |
| `scan` | Register new or changed artifacts. |
| `lint` | Health check before release. |
| `ingest` | Bring external corpus into the store. |

Full surface: `.governance/ai-dev-governance/runbooks/ASTAIRE_ACCESS.md`

---

### RTK — token compression

RTK rewrites high-volume shell commands transparently via the Claude
Code hook. No changes to your workflow are required.

```bash
rtk gain              # check token savings
rtk discover          # find missed opportunities
```

`@RTK.md` is loaded globally. For repo-local reinforcement see
`.governance/ai-dev-governance/templates/AGENTS_RTK_SNIPPET_TEMPLATE.md`.

---

### Governance context

- Planning artifacts: `docs/planning/**`
- Release evidence: `docs/releases/**`
- Governance manifest: `governance.yaml`
- Amendments/overlays: `docs/governance/amendments/`
- Validation: `scripts/validate_bootstrap.sh` (consumer completeness)
  and `.governance/ai-dev-governance/scripts/validate_governance.sh`

<!-- ai-dev-governance:bootstrap:end -->
