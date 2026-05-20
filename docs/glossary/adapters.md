---
phase: 9
stage_produced: implementation
context: adapters
authoring_authority: Accountable Delivery Lead (per-provider authority MAY be delegated)
created: 2026-05-19
last_review: 2026-05-19
---

# Adapters — Bounded-Context Glossary

The vocabulary of `adapters/providers/` and `adapters/tooling/`: the
runtime-ergonomics layer that surfaces ADG governance inside specific
agent runtimes (Claude Code, Codex, RTK, …). Per Q4 of the Phase 9
pool, **adapters define no normative rules** — they only point at
`core/` policies.

Per `core/DOMAIN_LANGUAGE_GOVERNANCE.md` §Per-Context Authoring
Authority, the Accountable Delivery Lead holds default authority;
per-provider authority MAY be delegated in the relevant adapter
specification document.

## Terms

### Provider

- **Definition.** An LLM-agent runtime that ADG ships first-class
  ergonomics for, declared under `adapters/providers/<name>/`; current
  set is `claude` and `codex`.
- **Owning context.** adapters
- **Canonical references.**
  - `adapters/providers/`
- **Synonyms (deprecated).** none.

### Profile

- **Definition.** A named manifest configuration (e.g.
  `strict-baseline`, `embedded-style`) bundling default rule
  dispositions, required-presence floors, and tier coupling settings;
  declared in `governance.yaml:profile`.
- **Owning context.** adapters
- **Canonical references.**
  - `core/AUTONOMOUS_DELIVERY_GOVERNANCE.md` §Profiles
  - `governance.yaml`
- **Synonyms (deprecated).** none.

### Runtime

- **Definition.** The execution environment in which a Provider's
  adapter operates (e.g. Claude Code CLI, Codex CLI, terminal hooks);
  scope of "runtime ergonomics" is anything observable from the
  provider's session.
- **Owning context.** adapters
- **Canonical references.**
  - `adapters/providers/claude/`
  - `adapters/providers/codex/`
- **Synonyms (deprecated).** none.

### Skill

- **Definition.** A self-contained capability module under
  `adapters/providers/claude/skills/<name>/SKILL.md` that points at a
  `core/` policy as source of truth and helps the runtime execute it;
  an adapter-layer concept that MUST NOT encode normative rules.
- **Owning context.** adapters
- **Canonical references.**
  - `adapters/providers/claude/skills/`
  - Phase 9 pool Q4 resolution
- **Synonyms (deprecated).** none.
- **Notes.** Homograph: `skill` in upstream Claude Code documentation
  may carry a more permissive meaning; ADG's adapter-layer scope
  forbids skill-authored normative rules and the SCN-9.3 acceptance
  enforces the boundary by grep.

### Slash Command

- **Definition.** A short-form invocation under
  `adapters/providers/claude/commands/<name>.md` that wraps a skill
  load plus a templated prompt; runtime-only and policy-free.
- **Owning context.** adapters
- **Canonical references.**
  - `adapters/providers/claude/commands/`
- **Synonyms (deprecated).** none.

### Hook

- **Definition.** A provider-runtime event handler under
  `adapters/providers/claude/hooks/` that MAY trigger post-edit
  verification or telemetry but MUST NOT replace the validator chain.
- **Owning context.** adapters
- **Canonical references.**
  - Phase 9 pool Q4 resolution
- **Synonyms (deprecated).** none.

### Ergonomic

- **Definition.** Adapter-layer surface area whose only purpose is to
  reduce friction for a specific Provider's runtime; ergonomics are
  removable without removing governance.
- **Owning context.** adapters
- **Canonical references.**
  - Phase 9 pool Q4 rationale
- **Synonyms (deprecated).** none.

### Source-of-Truth Pointer

- **Definition.** The opening paragraph (or equivalent) of an adapter
  artifact (`SKILL.md`, hook definition, command template) naming the
  exact `core/` document and section it implements at the runtime
  layer.
- **Owning context.** adapters
- **Canonical references.**
  - Phase 9 pool Q4 resolution
  - SCN-9.3 acceptance criteria
- **Synonyms (deprecated).** none.

## Deprecations

(none at v1)
