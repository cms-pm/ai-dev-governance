# SCN-10.11 CodeGraph MCP Direct Shape Smoke

- Generated: 2026-05-25T21:30:52Z
- Corpus: `raw/codegraph` copied to an isolated temp tree
- Runtime: strict Docker only through `templates/codegraph/scripts/codegraph-mcp`
- MCP server command source: `templates/codegraph/.mcp.json.fragment`
- Image digest: `sha256:8755b3e13adb17159e0154e750f0af56d2159ffb7847818c6871c2c3ddc3ded1`
- Evidence JSON: `docs/validation/scn-10.11/mcp-direct-shape.json`
- Index log: `docs/validation/scn-10.11/mcp-direct-shape-index.log`

## Result

PASS. The smoke initialized a digest-pinned Docker CodeGraph index for the
larger CodeGraph corpus, loaded the published MCP fragment command/env, started
`serve --mcp --no-watch`, and exercised the MCP JSON-RPC stdio surface
directly without npm, local node, SDK, or host fallback.

## Representative Native-Tool Churn Covered

- Index health: `codegraph_status` instead of manual `.codegraph` inspection.
- Project layout: `codegraph_files` instead of recursive `find` / `ls` tree walking.
- Function/type definition lookup: `codegraph_search` + `codegraph_node` instead of `rg` plus targeted reads.
- Compact task context: `codegraph_context` instead of recursive grep plus multi-file reads.
- Refactor blast radius: `codegraph_callers`, `codegraph_callees`, and `codegraph_impact` instead of manual caller/callee reconstruction.
- Seam/refactor survey: `codegraph_explore` instead of broad related-file read loops.

## Tool Calls

`codegraph_status, codegraph_files, codegraph_search, codegraph_node, codegraph_context, codegraph_callers, codegraph_callees, codegraph_impact, codegraph_explore`

## ADG Compliance Yardstick

The call matrix tracks the Code Intelligence Governance and provider skill
guidance that CodeGraph-declared consumers should query CG before token-heavy
native spidering for seams, refactors, function definitions, impact analysis,
and compact task context. This test is intentionally opt-in because it requires
a local Docker runtime and the pinned image digest.
