# Claude Context Adapter

## Purpose

Defines recommended context conventions for teams using Claude-style assistants.

## Conventions

- Keep main context files concise and link to governance docs instead of duplicating content.
- Keep provider-specific operational guidance in adapter docs, not in `core/`.
- Preserve auditable human approvals in repository artifacts.
- For strict baseline projects, use shell-first inspection and validation flows so RTK can compress Bash-visible command output before it reaches Claude context.
- When CodeGraph is declared, source-code discovery and refactor impact
  analysis MUST check CodeGraph before broad shell or built-in-tool spidering.

## Astaire Integration (port-of-first-resort)

- Strict baseline Claude consumers MUST treat Astaire as the
  port-of-first-resort for planning and implementation artifacts.
- The Astaire CLI surface (see `runbooks/ASTAIRE_ACCESS.md`) MUST be
  loaded into the agent's working context at session start —
  typically by inlining `templates/ASTAIRE_CLI_SNIPPET.md` into the
  consumer's `CLAUDE.md` or equivalent.
- Before invoking `Read`, `Grep`, or `Glob` on any `docs/planning/**`,
  `docs/releases/**`, board artifact, or governance core policy, the
  agent MUST first query Astaire (for example, via
  `.astaire/astaire query ...` or `.astaire/astaire context ...`).
- Direct native-tool reads are permitted only when Astaire has no
  projection for the target, or when the read is in immediate service
  of an `Edit` / `Write` on that file.
- Release evidence for strict Claude consumers MUST include an
  Astaire L0 snapshot and `.astaire/astaire lint` health report (see
  `core/EVIDENCE_CONTRACT.md`).

## RTK Integration

- Strict baseline consumers using `providers/claude` MUST also declare `tooling/rtk`.
- Install and verify RTK with:
  - `rtk init -g`
  - `rtk init --show`
- Prefer Bash-visible workflows for high-volume reads, searches, listings, git, test, and CI commands because Claude's hook can rewrite them to `rtk ...`.
- Claude built-in tools such as `Read`, `Grep`, and `Glob` are allowed for narrow targeted inspection, but they do not benefit from RTK hook rewriting and SHOULD NOT be the default for broad repo exploration.
- Release evidence for strict Claude consumers MUST include RTK setup verification plus `rtk gain` and `rtk discover` output or a documented no-op result.

## CodeGraph Integration

- Consumers that declare CodeGraph MUST load
  `adapters/providers/claude/CODEGRAPH.md` into `CLAUDE.md` or an equivalent
  agent bootstrap surface alongside the Astaire and RTK snippets.
- Before broad source discovery with `Glob`, `Grep`, `Read`, recursive
  listings, or multi-file reads, agents MUST first use the
  `mcp__codegraph__*` tool that matches the question (`search`, `context`,
  `explore`, `callers`, `callees`, or `impact`).
- Before refactoring production code, agents MUST run a CodeGraph impact,
  caller/callee, context, or explore query and record the affected files in
  the implementation note. If CodeGraph is stale, unavailable, or outside
  declared scope, record the fallback reason before native spidering.

## Specification Adherence

- Gate and acceptance verdicts MUST be **meet-or-waive**: a hard
  requirement is either met on its own evidence or routed through the
  documented waiver process (`core/EXCEPTIONS_AND_WAIVERS.md`). Silently
  reporting a requirement as satisfied without meeting it or recording a
  waiver is prohibited.
- An agent MUST NOT **self-grade**: the identity/session that authors and
  executes an implementation MUST NOT also be the identity/session that
  grades the gate for that same implementation (checker ≠ maker; see
  `core/AUTONOMOUS_DELIVERY_GOVERNANCE.md`).
- An agent MUST NOT edit a requirement, acceptance criterion, or its
  locked requirement-contract hash to make it match what was built.
  Requirements change only through the human-approved process that
  produced them, not to accommodate a build in progress.
- When a hard requirement cannot be met, the agent MUST surface the
  blocker to a human or the waiver process rather than routing around it
  (e.g. substituting a proxy, narrowing scope, or reinterpreting the
  requirement). See `core/ACCEPTANCE_INTEGRITY.md` for the mechanics.

## Required Mapping

- `core/*` policies map directly to project governance docs.
- Adapter-specific preferences must be declared in governance manifest under `adapters`.
- RTK-specific setup, exceptions, and evidence requirements map to `adapters/tooling/RTK_CONTEXT_ADAPTER.md`.
- CodeGraph-specific setup, tool selection, and fallback discipline map to
  `adapters/providers/claude/CODEGRAPH.md`.
