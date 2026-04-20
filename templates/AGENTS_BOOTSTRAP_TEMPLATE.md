# Agent Bootstrap Block (consumer template)

Paste the section below — bounded by the marker comments — into the
consumer repo's `AGENTS.md`, `CLAUDE.md`, or equivalent agent-bootstrap
document. Keep it near the top. `bootstrap_project.sh` manages this
block automatically; the marker comments define the managed region.

Do not edit content between the markers by hand unless you accept that
the next bootstrap run will overwrite it.

---

<!-- ai-dev-governance:bootstrap:start -->

## Governance tools — When, How, and Where

### Astaire — port-of-first-resort (MANDATORY)

**Where:** `.astaire/astaire` at repo root. This wrapper sets `--db`
to `.astaire/memory_palace.db`, defaults `UV_CACHE_DIR` to
`.astaire/.uv-cache`, and runs the pinned Astaire submodule directly
from source with `uv`.
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
