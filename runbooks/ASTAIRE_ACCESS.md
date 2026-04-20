# Astaire Access Runbook

**Status:** normative for strict-baseline. Applies to every agent
operating under `ai-dev-governance` in this repo and in downstream
consumer repos.

Astaire is the port-of-first-resort for planning and implementation
artifacts (see `README.md` §Governance Principles). This runbook
defines the CLI surface that MUST be present in every agent's working
context and the read discipline that MUST be applied before any
direct file read.

## The Rule

Before reading any `docs/planning/**`, `docs/releases/**`, board
artifact, or governance core policy, an agent MUST query Astaire
first. Direct file reads are permitted only when:

1. Astaire has no projection for the target (for example, brand-new
   files being authored), or
2. The read is in service of an edit the Edit/Write tool will perform.

Every agent invocation begins at Astaire L0 and routes outward to
tentacles (L1/L2, graphify, RTK) rather than fanning out in parallel.

## Repo-local Invocation

The canonical wrapper is `.astaire/astaire` at the repo root. It sets
`--db` to `./.astaire/memory_palace.db` so the database lives outside
the submodule pin, and it defaults `UV_CACHE_DIR` to
`./.astaire/.uv-cache` so restricted environments do not depend on
write access to `~/.cache/uv`. Downstream consumers drop a matching
wrapper at the same path via `templates/ASTAIRE_CLI_SNIPPET.md`.

```bash
.astaire/astaire --help
```

## CLI Surface

| Subcommand | Purpose | Minimal example |
|---|---|---|
| `init` | Initialize database schema. | `.astaire/astaire init` |
| `startup` | Session-start bundle: init + scan + sync + status. | `.astaire/astaire startup --root .` |
| `status` | Show knowledge base state (document counts, last ingest, hot topics). | `.astaire/astaire status` |
| `scan` | Scan and register collection artifacts into the registry. | `.astaire/astaire scan --root .` |
| `query` | Query documents by collection, doc type, tag, or FTS. | `.astaire/astaire query -t chunk-plan` |
| `context` | Assemble an LLM-ready context bundle within a token budget. | `.astaire/astaire context --tag phase=2 --budget 6000` |
| `lint` | Run health checks (contradictions, drift, missing evidence). | `.astaire/astaire lint` |
| `export` | Export a wiki snapshot for release evidence. | `.astaire/astaire export --out docs/releases/vX.Y.Z/wiki` |
| `prune` | Prune expired claims. | `.astaire/astaire prune` |
| `sync` | Check for document drift against on-disk state. | `.astaire/astaire sync --root .` |
| `ingest` | Ingest a source document into the claim/entity store. | `.astaire/astaire ingest raw/articles/<file>.md` |

Flags shared across subcommands: `--db <path>` (the wrapper sets this),
`-v/--verbose`.

## Read Patterns

- **"What's planned?"** → `query -t chunk-plan` then `context --tag phase=<n>`.
- **"What's the current state of the knowledge base?"** → `status`.
- **"Which artifacts match a keyword?"** → `query --fts "<terms>"`
  (note: hyphens inside FTS terms are fragile — prefer phrases or
  unhyphenated forms).
- **"Assemble context for work in phase N."** → `context --tag phase=<n> --budget <n>`.

## FTS Caveat

`query --fts` is an SQLite FTS5 surface. Tokens containing hyphens
(for example, `SCN-2`) can trigger parser errors. Prefer phrasal
queries or the unhyphenated fragment.

## Version Band

This runbook applies to `ai-dev-governance` v0.6.0 and later. The CLI
surface is captured against the astaire pin recorded in
`runbooks/COMPATIBILITY_MATRIX.md`; changes to that pin trigger a
review of this runbook.
