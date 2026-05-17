# Code Implementation Complexity Governance

## Purpose

This core policy keeps agentic implementation work from passing local tests
while quietly growing monoliths, ambiguous modules, hidden state ownership, and
high-change-amplification designs.

Keywords `MUST`, `SHOULD`, and `MAY` are normative.

## Core Principle

Every production component MUST have one clear reason to change, a narrow
public surface, and an explicit ownership story for mutable state, resources,
state machines, and task or service execution.

Agents MUST optimize for maintainability symptoms as first-class acceptance
concerns:

- Change amplification: one logical change should touch a small, predictable
  set of files.
- Cognitive load: a maintainer should not need unrelated subsystem context to
  edit a local behavior.
- Unknown unknowns: legal states, wakeups, hidden coupling, and ownership
  boundaries must be explicit in code, tests, and artifacts.

## Applicability

This policy applies to agentic implementation work that creates or modifies
production code in:

- orchestration layers,
- runtime services,
- protocol handlers,
- state machines,
- task loops,
- hardware or external-resource adapters,
- command dispatch,
- persistence, migration, upload, or lifecycle flows.

For documentation-only changes or localized test-only changes, agents MAY
record "not applicable" with a short reason.

## Mandatory Design Invariants

Agents MUST preserve these invariants:

1. One owner per mutable state variable.
2. One owner per hardware handle, connection, queue, mutex, file, or external
   service resource.
3. One owner per protocol parser.
4. One owner per state machine.
5. One owner per task loop, service loop, scheduler callback, or long-running
   execution root.
6. Orchestration files wire components; they do not own component behavior.
7. Public dependency structures describe a role; they do not become broad
   service locators.
8. State transitions are table-driven, SMF-driven, or otherwise explicit enough
   for a reviewer to enumerate legal arcs.
9. Architecture diagrams are updated when task topology, state topology, or
   external-resource ownership changes.
10. Placeholder modules do not count as decomposition until they own real
    behavior and tests.
11. Names reveal ownership, action, and abstraction level.
12. Component placement expresses domain ownership, not historical convenience.

## Power of 10 Discipline (Universal)

This section adds a language-agnostic per-function discipline drawn from
the Power of 10 rules. The clauses here are universal; C/C++-specific
elaborations (pointer use, preprocessor specifics, allocator patterns,
`goto`/`setjmp`) live in the CockpitVM Embedded Style at
`adapters/profiles/CockpitVM_Embedded_Style.md` and apply only when the
governance manifest declares the embedded profile.

Rules 4 (function size) and 6 (smallest scope) are not restated here:
rule 4 is subsumed by §Component Size Limits (which is stricter than the
Power of 10 ~60-line guideline), and rule 6 is subsumed by §Mandatory
Design Invariants #1 and the §Forbidden Patterns clause prohibiting new
file-scope mutable globals in orchestration files. Rule 9 (pointer use)
is C/C++-specific and lives only in the CockpitVM Embedded Style.

Universal clauses:

- **Restricted control flow (Power of 10, rule 1).** Agents MUST NOT
  introduce direct or indirect recursion in production code without a
  human-approved exception. Indirect recursion includes mutual recursion
  across modules.
- **Bounded loops (Power of 10, rule 2).** Agents MUST NOT introduce
  loops without a statically demonstrable upper bound. Equivalent forms
  (e.g. an event-loop body with a short-circuit timeout) satisfy the
  rule when the bound is part of the loop construct, not an external
  invariant.
- **No dynamic allocation in the steady state (Power of 10, rule 3).**
  Agents MUST NOT introduce dynamic memory allocation in the steady
  state of production code. "Steady state" means the period after
  initialization completes; allocation during init is permitted when
  the lifetime is bounded by a clearly named owner (per §Mandatory
  Design Invariants #2). Languages with mandatory dynamic allocation
  (e.g. Python, Java) MAY satisfy this rule by documenting an
  allocation budget per execution root.
- **Assertion density (Power of 10, rule 5).** Agents SHOULD include at
  least two assertions per nontrivial function added or touched in
  production code. Assertions document preconditions, postconditions,
  and invariants — not error handling at the boundary. Trivial
  getters/setters and one-line wrappers are exempt. This clause is a
  `SHOULD`, not a `MUST`, and applies only to new or touched code (per
  §Component Size Limits Grandfathering).
- **Return-value and parameter checks (Power of 10, rule 7).** Agents
  MUST check the return value of every non-void function call in
  production code, or MUST explicitly cast to `(void)` with a one-line
  comment stating the rationale. Agents MUST validate parameters at
  every public boundary in production code.
- **Restricted preprocessor and metaprogramming (Power of 10, rule 8).**
  Agents MUST NOT use preprocessor or macro features beyond file
  inclusion, simple object-like definitions, and language-idiomatic
  guards. Token pasting, recursive macros, computed includes, and
  conditional-compilation gates that hide alternative code paths from
  review require a human-approved exception.
- **All warnings + static analysis (Power of 10, rule 10).** Validation
  evidence for production changes MUST include a clean compile under
  all-warnings (language-idiomatic equivalent of `-Wall -Wextra -Werror`
  for C/C++, `RUSTFLAGS="-D warnings"` for Rust, equivalent linter
  strict mode for dynamic languages) and at least one static analyzer
  reporting zero findings on touched files. The analyzer choice MUST be
  declared in the governance manifest. See §Required Validation Evidence
  for the canonical evidence list.

Cross-reference: §Forbidden Patterns Without Human Exception restates
rules 1, 2, 3, 7, and 8 in negative form; §Required Validation Evidence
restates rule 10 alongside the analyzer-capability floor; §Required
Pre-Implementation Checklist carries the rule-7 evidence row. The
embedded elaborations (pointer use, preprocessor specifics, allocator
patterns, `goto`/`setjmp`) live in
`adapters/profiles/CockpitVM_Embedded_Style.md`.

## Naming Rules

Agents MUST apply these rules before creating or moving production components:

- Use descriptive nouns for components that own concepts, such as
  `session_state_machine`, `upload_orchestrator`, or `wifi_station`.
- Use verb-oriented names for functions that perform actions, such as
  `upload_orchestrator_claim_command`, `command_dispatch_route`, or
  `wifi_station_connect`.
- Use predicate names for boolean functions, such as
  `session_owns_resource` or `mqtt_is_connected`.
- Avoid vague suffixes such as `common`, `shared`, `util`, `helper`, `misc`, or
  `manager` unless the module contract defines exactly what is common, shared,
  or managed.
- Do not create parallel names for the same abstraction. If two modules appear
  to own the same cross-cutting concept, such as `vm_common` and `vm_shared`,
  agents MUST stop and propose a consolidation or renaming plan before adding a
  third overlapping module.
- Do not encode temporary implementation placement into durable names.
- Keep file names, public type names, and public function prefixes aligned.

Naming review questions:

- Can a maintainer infer the owner from the name?
- Can a maintainer infer whether the symbol is a state owner, action, adapter,
  predicate, or data shape?
- Is there an existing module with a near-duplicate name or overlapping
  responsibility?
- Would this name still make sense after the next extraction or relocation?

## Component Placement Rules

Agents MUST place code according to domain ownership.

Generic placement invariants:

- Shared runtime or platform code belongs in a shared component tree with a
  clear contract and no product-specific dependencies.
- Product-specific behavior belongs in the product workspace or product-owned
  component tree, not in a generic root merely because the build can compile it.
- Repository-root `src/` directories SHOULD remain entrypoint and composition
  surfaces unless the repository is intentionally single-purpose.
- Moving code for placement alone is not enough. Each move SHOULD clarify
  ownership, reduce include/build coupling, or enable a narrower public API.
- Build graphs, include paths, and tests for all affected workspaces MUST be
  updated in the same change when code moves.

Placement review questions:

- Is this code shared infrastructure or product behavior?
- Which workspace owns its lifecycle, tests, and build flags?
- Does this placement reduce or increase change amplification?
- Does this placement make include paths and public prefixes more coherent?

## Component Size Limits

The following limits apply to new or touched production code unless a
human-approved exception exists.

| Component kind | Warning threshold | Hard cap | Rule |
| --- | ---: | ---: | --- |
| Orchestration entry file | 600 LOC | 800 LOC | Startup, dependency injection, task registration, and lifecycle wiring only. |
| Service or firmware implementation file | 450 LOC | 600 LOC | Must own one reason for change. |
| Header or public API file | 120 LOC | 180 LOC | Public types and API only. No broad global context objects. |
| State-machine implementation | 350 LOC | 450 LOC | One machine, events, guards, actions, and transition table/SMF. |
| Task or service-loop implementation | 220 LOC | 300 LOC | One execution root plus its private helpers. |
| Function | 25 LOC | 40 LOC | Longer functions require a cohesion note and review evidence. See footnote on Power of 10 rule 4. |
| Public dependency struct | 8 fields | 12 fields | Larger structs must split by role. |
| Command dispatch table | 20 commands | 30 commands | Larger command surfaces require grouping and generated/listed docs. |

Grandfathering:

- Existing over-cap files are migration targets.
- Any agent touching an over-cap file MUST reduce it, move behavior out of it,
  or add an exception request with a retirement plan.
- Agents MUST NOT add new behavior to an over-cap orchestration file unless the
  change is wiring required for extraction.

Footnote — Power of 10 rule 4. The function-length cap of 25 / 40 LOC is
stricter than the Power of 10 rule 4 guideline (~60 LOC, "one printed
page"). The stricter cap better serves the change-amplification
invariant declared in §Core Principle. Power of 10 rule 4 is documented
here as the looser ancestor, not as an alternative permitted by
exception.

## Required Pre-Implementation Checklist

Before implementing nontrivial production code, the agent MUST write or update
a brief implementation note containing:

- Component owner: the file/module that owns the behavior.
- Component placement: why the chosen path matches domain ownership.
- Naming check: existing near-duplicate names and why the selected name is
  distinct.
- Mutable state owner: every new or moved mutable state field and its owner.
- Resource owner: every hardware handle, socket, file, queue, mutex, task, or
  external service owner.
- State-machine declaration: name the state machine, or state "no state
  machine".
- Task-loop declaration: name the execution root, wait primitive, wake source,
  priority or scheduling policy, stack/resource budget, and liveness policy.
- Public surface: list new public functions, callbacks, and dependency structs.
- Change-amplification probe: one plausible future change and the files it
  should touch.
- Cognitive-load probe: the context a maintainer must hold to safely edit the
  code.
- Unknown-unknown probe: hidden coupling that might surprise a future
  maintainer and where it is made explicit.
- Return-value and parameter validation: list any non-void call sites in
  the change that intentionally discard their return (each with a `(void)`
  cast and one-line rationale), and list any public boundary functions
  introduced or modified together with the parameter validation they
  perform. (Power of 10, rule 7.)

## Required Validation Evidence

Before closeout, the agent MUST provide:

- Line-count evidence for touched production files.
- Tests or source-shape checks proving new module boundaries.
- Naming and placement review evidence for new or moved components.
- Updated state-machine diagram when states, events, guards, or transitions
  changed.
- Updated task-loop diagram when tasks, priorities, queues, notifications,
  scheduling, or liveness behavior changed.
- Build/test evidence appropriate to risk tier.
- Explicit list of any warning-threshold or hard-cap violations.
- Human-approved exception ID for each hard-cap violation.
- Clean compile under all-warnings (language-idiomatic equivalent of
  `-Wall -Wextra -Werror` for C/C++, `RUSTFLAGS="-D warnings"` for
  Rust, equivalent linter strict mode for dynamic languages) and at
  least one static analyzer reporting zero findings on touched files.
  The analyzer choice MUST be declared in the governance manifest. The
  analyzer's minimum capability is detection of: recursion, unbounded
  loops, dynamic allocation in the steady state, and unchecked non-void
  returns. (Power of 10, rule 10.)

## Forbidden Patterns Without Human Exception

Agents MUST NOT introduce these patterns without an explicit human-approved
exception:

- New enum states without legal-transition documentation.
- New file-scope mutable globals in orchestration files.
- New tasks, service loops, or recurring callbacks without execution metadata.
- New command branches in an orchestration file.
- Broad dependency structs that pass unrelated callbacks together.
- Helper modules that only wrap a name and own no behavior.
- New modules named with vague `common`, `shared`, `util`, `helper`, `misc`, or
  `manager` terms without an explicit module contract and duplicate-name scan.
- Product-specific components added to generic roots when a product-owned tree
  can own them.
- Multiple modules that can mutate the same protocol, session, or resource
  state.
- Silent build-variant warnings classified only from memory instead of a
  durable artifact.
- State names that are declared but never transitioned to.
- Direct or indirect recursion in production code (Power of 10, rule 1).
- Loops without a statically demonstrable upper bound (Power of 10,
  rule 2).
- Dynamic memory allocation in the steady state after initialization
  completes (Power of 10, rule 3).
- Non-void function calls whose return value is neither checked nor
  explicitly discarded with a `(void)` cast and one-line rationale; or
  public boundary functions that omit parameter validation (Power of 10,
  rule 7).
- Preprocessor or macro features beyond file inclusion, simple
  object-like definitions, and language-idiomatic guards — including
  token pasting, recursive macros, computed includes, and
  conditional-compilation gates that hide alternative code paths from
  review (Power of 10, rule 8).

## Complexity Review Rubric

Reviewers SHOULD score each nontrivial implementation from 0 to 3:

| Score | Change amplification | Cognitive load | Unknown unknowns |
| --- | --- | --- | --- |
| 0 | One owner and one test surface. | Local context is enough. | Legal states/resources are explicit. |
| 1 | Two or three predictable files. | One adjacent subsystem needed. | Coupling is documented. |
| 2 | Several files across subsystems. | Reviewer must trace globals/tasks. | Some implicit coupling remains. |
| 3 | Diff crosses unrelated domains. | Reviewer must understand most of the system. | Hidden ownership or illegal states likely. |

Gate interpretation:

- Any score of 3 requires board or human maintainer review.
- Two or more scores of 2 require a refactor plan before feature closeout.
- Scores of 0 or 1 may proceed under normal risk-tier gates.

## Exception Process

Hard-cap and forbidden-pattern exceptions require a short exception record with:

- exception ID,
- owner,
- policy clause reference,
- reason,
- risk accepted,
- expiration date,
- retirement plan,
- reviewer approval.

Exceptions MUST be time-bounded. Permanent exceptions are not allowed for
monolith growth.

## Agent Sequence

Agents MUST use this sequence for applicable work:

1. Inspect current file sizes and module ownership before editing.
2. If the target file is over cap, prefer extraction over addition.
3. Declare state, task, resource, naming, and placement ownership before code
   changes.
4. Keep public APIs narrow and role-specific.
5. Add or update boundary tests while moving behavior.
6. Update diagrams and line-count evidence.
7. Report complexity scores in the final validation note.
