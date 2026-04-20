# ai-dev-governance — Agent Bootstrap (Claude)

## Session Start

First action in every session:

```bash
.astaire/astaire startup --root .
```

This runs init → scan → sync → status. Do not read planning or release
artifacts before this completes.

---

## Astaire — port-of-first-resort for governance artifacts

Astaire is the mandatory first read for any `docs/planning/**`,
`docs/releases/**`, or board artifact. Direct file reads (`Read`, `Grep`,
`Glob`) on those paths are only permitted when:

- (a) Astaire has no projection for the target (brand-new files being authored), or
- (b) the read is in immediate service of an `Edit` / `Write` on that file.

**CLI location:** `.astaire/astaire` (repo root). Always invoke with this full
path — the wrapper sets `--db` to `.astaire/memory_palace.db` and routes to
the local `astaire/` subdir. **Never invoke bare `astaire`** — it is not on
PATH and will not use the correct database.

```bash
.astaire/astaire status
.astaire/astaire query -t chunk-plan
.astaire/astaire context --tag phase=<n> --budget 6000
.astaire/astaire scan --root .
.astaire/astaire lint
```

| Subcommand | When to use |
|---|---|
| `startup` | First action every session: `.astaire/astaire startup --root .` |
| `status` | "What does the knowledge base currently know?" |
| `query` | Artifacts by collection, type, tag, or FTS. |
| `context` | Token-budgeted bundle before planning or implementation. |
| `scan` | After writing or editing artifacts, register them. |
| `lint` | Before a release or gate review. |
| `export` | Wiki snapshot for release evidence. |
| `ingest` | Bring external corpus (articles, transcripts) into the store. |

Hyphens inside `--fts` queries are fragile (SQLite FTS5) — prefer phrasal forms.

Full surface: `runbooks/ASTAIRE_ACCESS.md`.

---

## RTK — token compression

RTK rewrites high-volume shell commands transparently via the Claude Code hook.
Use Bash-visible workflows (git, uv run, find, grep) so RTK can compress the
output. Built-in tools (`Read`, `Grep`, `Glob`) bypass RTK and should be
reserved for narrow targeted inspection.

```bash
rtk gain           # token savings analytics
rtk discover       # missed RTK opportunities in session history
```

RTK setup: `rtk init -g` then `rtk init --show`. Release evidence must include
`rtk gain` and `rtk discover` output (see `runbooks/RELEASE_PROCESS.md`).

---

## Planning discipline

Work proceeds in SCN chunks. Before proposing or implementing any SCN:

1. Run `.astaire/astaire context --tag phase=<n> --budget 6000` for the
   target phase.
2. Read the relevant chunk plan from the Astaire projection (not directly
   from `docs/planning/chunks/`).
3. Identify the acceptance IDs and validation method before writing any code.

Key docs: `core/PLANNING_METHODOLOGY.md`, `core/AUTONOMOUS_DELIVERY_GOVERNANCE.md`.

---

## Governance structure

| Path | Purpose |
|---|---|
| `core/` | Normative policies (planning, git, board review, autonomous delivery) |
| `adapters/providers/` | Claude and Codex adapter specs |
| `contracts/` | JSON schemas and example governance manifest |
| `runbooks/` | Operational procedures |
| `templates/` | Copy-paste artifacts for consumer repos |
| `scripts/` | Validation and bootstrap scripts |
| `validation/` | Consistency rules and fixtures |
| `docs/planning/` | Chunk plans and pool questions (read via Astaire) |

Validation: `scripts/validate_governance.sh` (governance source checks),
`scripts/validate_astaire_wiring.sh` (Astaire wiring check for any repo).
