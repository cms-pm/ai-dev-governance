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
| Function | 25 LOC | 40 LOC | Longer functions require a cohesion note and review evidence. |
| Public dependency struct | 8 fields | 12 fields | Larger structs must split by role. |
| Command dispatch table | 20 commands | 30 commands | Larger command surfaces require grouping and generated/listed docs. |

Grandfathering:

- Existing over-cap files are migration targets.
- Any agent touching an over-cap file MUST reduce it, move behavior out of it,
  or add an exception request with a retirement plan.
- Agents MUST NOT add new behavior to an over-cap orchestration file unless the
  change is wiring required for extraction.

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
