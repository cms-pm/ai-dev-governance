# Codex CodeGraph Adapter

**Source of truth:** `core/CODE_INTELLIGENCE_GOVERNANCE.md`.

## Purpose

Defines Codex-specific conventions for using CodeGraph (CG) as the optional
Tier-2 source-code intelligence surface in strict ADG consumers. This adapter
maps the core Code Intelligence Governance doctrine into `AGENTS.md`, MCP
configuration, and Codex working practice without redefining the policy.

## Scope

- Astaire remains the port of first resort for ADG governance artifacts.
- CodeGraph is limited to the consumer product-code path scope declared by the
  consumer repository.
- Graphify is not an ADG-supported integration surface.
- CG findings are advisory context. Acceptance evidence still binds to
  repository files, tests, validation logs, and the evidence URIs defined in
  `core/EVIDENCE_CONTRACT.md`.

## Codex Integration

Codex consumers that enable CG should apply the template fragments under
`templates/codegraph/`:

- `.mcp.json.fragment` for the wrapper-invoked `codegraph` MCP server.
- `CLAUDE.md.fragment` as the source stanza to adapt into `AGENTS.md` or an
  equivalent Codex instruction file.
- The wrapper's default sanitized source staging for path-scope exclusions.
  Legacy root `.codegraphignore` files are hidden before CodeGraph runs because
  CodeGraph treats them as directory markers, not pattern files.

The MCP server should be invoked through `templates/codegraph/scripts/codegraph-mcp`
or an equivalent consumer-local wrapper that preserves the hardening matrix
from the template. In consumers that declare CG, Codex sessions MUST perform
lightweight CG lookups for source navigation before broad `rg`, `find`,
recursive listing, or multi-file read passes whose purpose is discovery.

## Tool Selection

- Use `mcp__codegraph__search` for symbol, file, and text discovery.
- Use `mcp__codegraph__callers` and `mcp__codegraph__callees` for call paths.
- Use `mcp__codegraph__impact` before changing shared functions.
- Use `mcp__codegraph__context` for compact file or project context.
- Use `mcp__codegraph__explore` for delegated source-navigation exploration.

For refactoring, use `mcp__codegraph__impact` or caller/callee/context queries
before the first production edit and list the affected files in the
implementation note required by
`core/CODE_IMPLEMENTATION_COMPLEXITY_GOVERNANCE.md`.

When CG is absent, stale, or outside declared scope, continue with native
repository tools and record the fallback in the work log.

## Evidence Mapping

Do not cite CG output as validation evidence unless the acceptance item also
has current `codegraphIndexFreshnessURI` and `codegraphImageDigestURI`
evidence. If either URI is missing, CG may guide exploration but must not be
treated as proof of acceptance.

## Explore-Agent Prompt Addendum

<!-- CODEGRAPH_EXPLORE_ADDENDUM_START -->
When CodeGraph is available and inside the declared path scope, begin
source-navigation exploration with `mcp__codegraph__explore` or
`mcp__codegraph__context` before token-heavy native spidering. Treat returned
file snippets as already-read
context for the immediate task: do not re-Read files that CodeGraph returned
unless you need lines outside the returned range, are preparing a direct edit,
or must verify freshness-sensitive evidence. Keep delegated exploration
budgets small and explicit: ask for the narrowest symbol, caller/callee,
impact, or file-context slice that can answer the question, and stop once the
next implementation or review step is clear. For refactoring, run an impact
or caller/callee/context query before the first production edit. If CodeGraph
is unavailable, stale, ambiguous in scope, or blocked by missing evidence,
fall back to native repository tools such as `rg`, `find`, language test
runners, and targeted file reads; record that fallback in the work log before
using CG-derived context as anything more than advisory navigation.
<!-- CODEGRAPH_EXPLORE_ADDENDUM_END -->

## Cross-References

- `core/CODE_INTELLIGENCE_GOVERNANCE.md`
- `core/EVIDENCE_CONTRACT.md`
- `adapters/providers/CODEX_CONTEXT_ADAPTER.md`
- `templates/codegraph/CLAUDE.md.fragment`
- `templates/codegraph/.mcp.json.fragment`
