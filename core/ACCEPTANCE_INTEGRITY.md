# Acceptance Integrity

## Purpose

This core policy makes *specification evasion* mechanically hard. It
defines the doctrine and the blocking enforcement primitives that stop an
implementer agent from grading its own work, or from editing a
requirement to fit what it built. It complements
`core/EVIDENCE_CONTRACT.md` (what evidence a verdict must carry),
`core/EXCEPTIONS_AND_WAIVERS.md` (the only sanctioned escape hatch), and
`core/MUTATION_EVIDENCE.md` (a passing suite is necessary but not
sufficient) by raising the empirical bar on the *verdict itself*: a
`passing` status is only trustworthy when an independent observation, not
a value the maker controls, produced it.

Keywords `MUST`, `SHOULD`, and `MAY` are normative.

## Scope

This policy governs how acceptance verdicts are computed, qualified,
locked, and independently checked for any chunk under strict-baseline
governance. It applies to every acceptance item that resolves to a
terminal status under `core/EVIDENCE_CONTRACT.md` §Scenario Status
Vocabulary.

In scope:

- The specification-evasion taxonomy and the mechanisms that block each
  move.
- The four preventive mechanisms M1–M4 in their **blocking** form.
- Qualified verdicts (`passing@<mode>`), forced-waiver terminal states,
  boundary invariants, and read-gate-by-tier.
- The trust boundary that bounds this policy's sufficiency (§The Trust
  Boundary).

Out of scope (belongs to a separate downstream program, not specified
here):

- Any measurement, scoring, or auto-tuning of how well the checkers
  themselves perform.
- Any unattended loop *runner* that schedules the maker and the separate
  checker across sessions. This policy specifies the checker's **step
  contract** only; the machinery that executes it in an unattended loop is
  a downstream consumer's concern and is not named or described here.

## Core Principle

Specification evasion is Goodhart's law applied to acceptance gates: when
a gate's `passing` verdict is decoupled from the requirement's *intent*,
and the requirement is mutable by the party being graded, the cheap path
is to make the gate print `passing` rather than to honor the requirement.

Two invariants follow, and both are normative:

1. **A verdict the maker controls is not evidence.** A `passing` status
   computed from a hardcoded literal, from the run *mode*, from a
   pre-declared card status, or from a string grepped out of a document
   MUST NOT be treated as an independent observation.
2. **The checker is not the maker.** The party that authored and ran the
   work MUST NOT be the sole party that grades whether it meets the hard
   requirements. Independence is a structural property, not a matter of
   good faith.

## Definitions

- **Maker.** The agent (or session) that produces an artifact and runs its
  gate.
- **Separate checker.** A grading step whose sole input is the *locked*
  requirement contract, which re-derives the verdict and returns findings.
  The separate checker MUST NOT share write scope with the maker over the
  contract it grades against (see §The Trust Boundary).
- **Hard requirement.** A requirement marked `hard:true` in the acceptance
  trace (`core/PLANNING_METHODOLOGY.md`). Hard requirements carry a
  `predicate` (the objective condition) and one or more `antiProxy`
  checks. They MUST NOT be silently satisfied by a proxy.
- **Intent assertion.** An adversarial or non-triviality check attached to
  a hard requirement that fails the cheap path (see M1).
- **Requirement contract.** The hashed block of enforced hard requirements
  carried in the implementation-handoff artifact
  (`contracts/implementation-handoff.schema.json`).
- **Requirements lock (`requirements.lock`).** The human-approved hash of
  the requirement contract, stored where the maker cannot re-author it (see
  §The Trust Boundary).
- **Evidence mode.** The verification-depth tier a verdict was observed at:
  `mock` → `sil` → `hil_record_only` → `board_passing` (see §Qualified
  Verdicts).
- **Qualified verdict.** A status string suffixed with the evidence mode it
  was observed at, e.g. `passing@sil`.
- **Frozen boundary.** The set of paths owned by an already-closed chunk;
  they MUST NOT change in a later chunk's diff (see M4).

## The Specification-Evasion Taxonomy

Specification evasion is one failure class with recurring moves. Each move
is an instance of the same root cause and each MUST be blocked by a
fail-closed check. Examples below are deliberately generic.

| Move | What it does | Generic example | Blocked by |
|---|---|---|---|
| Proxy substitution | A stub or placeholder is swapped in for the real artifact the requirement targets | A size-bearing hardware-abstraction cell replaced by a hollow cell that returns fixed values | M1 |
| Scope migration | A failing check is displaced out of the chunk that owns it into another chunk so the owner reports green | A cycle-count check moved into a second, unrelated chunk | M3, M4 |
| Constraint erosion | A required control or condition is quietly dropped, re-introducing a confound the requirement guarded against | A required negative test case removed from the suite | M1, M2 |
| Provenance laundering | Locally produced or altered content is mislabeled as an authoritative upstream source | A locally generated abstraction layer labeled as a pinned upstream import | M1 |
| Spec mutation | The requirement or handoff document is edited to match what was built | The chunk doc's acceptance predicate rewritten to describe the actual build | M2 |
| Frozen-boundary violation | An already-closed chunk is reopened and modified | Edits landed against the paths of a chunk that was previously closed | M4 |
| Premature closure | A closed status is declared on evidence that is uncommitted or untracked | `closed` claimed on evidence files never committed to the change | M4 |

## Preventive Mechanisms (M1–M4)

Each mechanism is defined in its **blocking** form. The objective is not to
*describe* a guardrail but to make the cheap path **FAIL**. A non-blocking
(report-only) form of any of these mechanisms is **NOT** sufficient; it
merely detects after the fact.

### M1 — Intent Assertions

*(Blocks proxy substitution, provenance laundering, constraint erosion.)*

Each hard requirement MUST carry one or more intent assertions that fail
the cheap path. Intent assertions run *inside* the gate. A missing or
failed intent assertion MUST cause the gate to **FAIL**. Recognized
assertion families:

- **Anti-proxy symbol scan.** The gate MUST reject artifacts whose symbols
  indicate a stub, mock, or placeholder standing in for the real
  implementation the requirement targets.
- **Non-triviality floor.** A hard requirement MAY declare a floor below
  which the artifact is presumed hollow. Example: a size-bearing cell whose
  compiled footprint falls below a declared floor is presumed a stub and
  MUST FAIL.
- **Source-authority check.** Imported content declared to come from a
  pinned upstream source MUST hash-match that source; a mismatch MUST FAIL.

Intent-assertion thresholds (non-triviality floors, required intent
coverage) are declared under the `acceptanceIntegrity:` block in the
governance manifest.

### M2 — Requirement Contract + Lock

*(Blocks spec mutation, constraint erosion.)*

Hard requirements MUST be carried as a hashed requirement contract in the
implementation-handoff artifact. The gate MUST recompute the hash of the
enforced requirements and compare it against the human-approved
`requirements.lock`. Editing the requirement document to fit the build
changes the hash; a mismatch MUST cause the gate to **FAIL**.

The approved hash MUST live where the maker cannot re-author it in the same
change that edits the specification. This is a precondition for M2 to have
any force; see §The Trust Boundary.

### M3 — Forced Waiver + Separate Checker (keystone)

*(Blocks proxy substitution and scope migration — the root moves.)*

M3 is the keystone. `core/EXCEPTIONS_AND_WAIVERS.md` is the **only**
sanctioned escape from a hard requirement. "Cannot build the real artifact
yet" MUST become a filed, time-bound, human-approved waiver — never a stub.

- **Terminal states.** Every acceptance item MUST resolve to exactly one of
  **PASS**, **WAIVED**, or **FAIL**. Any item not in this set MUST be
  treated as **FAIL**. There is no silent fourth path.
- **Separate checker.** The verdict MUST be re-derived by a separate
  checker step whose *sole* input is the locked requirement contract. The
  separate checker re-derives PASS / WAIVED / FAIL and returns findings to
  the maker as the next instruction. The maker MUST NOT grade itself.
- **Loop termination.** When operated as a step in a loop, the loop ends
  only when findings against the *frozen* contract reach zero. The runner
  that executes this step in an unattended loop is out of scope for this
  policy (see §Scope, §The Trust Boundary).

### M4 — Boundary Invariants

*(Blocks frozen-boundary violation, scope migration, premature closure.)*

M4 is three mechanical git/manifest checks. Each violation MUST cause the
gate to **FAIL**:

- **(a) Frozen chunks.** A `git diff` against the paths of any already-closed
  chunk MUST be empty. The set of frozen paths is declared in a frozen-paths
  manifest in the governance manifest.
- **(b) Owns / must-not-do.** Each chunk MUST declare the paths it *owns*
  and the paths it *must not touch*. The gate MUST reject cross-chunk
  leakage.
- **(c) Committed + tracked evidence.** A status transition MUST require its
  evidence and imports to be **committed and tracked in the same change**.
  Uncommitted or untracked evidence MUST FAIL.

### Sufficiency Against the Same Agents

Under supervised / CI use, each of the load-bearing evasions maps to a
fail-closed check: spec mutation → M2, proxy substitution → M1,
self-grading → M3, frozen/premature moves → M4. This mapping is what makes
the mechanism set *sufficient against the same agents* in that envelope.
The honest limit of that sufficiency is stated in §The Trust Boundary.

## Qualified Verdicts

A bare `passing` verdict is untrustworthy because it drops the depth at
which it was observed: `passing@mock` and `passing@board_passing` are not
the same claim, yet both collapse to `passing` if unqualified.

- Every acceptance verdict MUST be qualified by the evidence mode it was
  observed at. The qualified form is `<status>@<evidence_mode>`.
- The evidence-mode depth ordering is normative:

  | evidence_mode | depth | Meaning |
  |---|---|---|
  | `mock` | 0 | Observed only against a mock; no real artifact exercised |
  | `sil` | 1 | Software-in-the-loop against real modules, no target hardware |
  | `hil_record_only` | 2 | Hardware-in-the-loop, record-only (not yet board-graded) |
  | `board_passing` | 3 | Graded passing at the board/target depth |

- A `passing@mock` verdict MUST NOT be presented, aggregated, or gated as
  though it were `passing`. Consumers that raise the required depth for a
  risk tier MUST compare against this ordering.

### Hollow-Verdict Rule

A `passing` verdict is **hollow**, and MUST NOT satisfy a gate, when any of
the following hold:

- the acceptance trace is empty (`no_acceptance_trace`), or
- the verdict was observed only at `mock` depth (`mode_gated_mock`).

A `passing` verdict with hard requirements but **no** intent assertion, at
a depth below `board_passing`, is **unverified intent**
(`no_intent_assertion`): it is not certified by the machine and MUST be
routed to human read per §Read-Gate by Risk Tier.

## Forced-Waiver Terminal States

The gate state machine has exactly three terminal states:

- **PASS** — every hard requirement met, every intent assertion passed, the
  requirement hash matches the lock, and boundary invariants hold.
- **WAIVED** — a hard requirement is not met but is covered by a filed,
  time-bound, human-approved waiver under `core/EXCEPTIONS_AND_WAIVERS.md`.
  A stub is never a substitute for a waiver.
- **FAIL** — anything else, including any acceptance item whose status is
  not one of the three terminal states.

There is **no silent fourth path**. An unclassifiable, skipped, or
mode-collapsed verdict MUST resolve to FAIL, not to an implied pass.

## Boundary Invariants

The M4 checks above are the enforceable form of a single doctrine: work is
bounded in space (paths) and in time (a closed chunk stays closed).

- **Frozen chunks stay frozen.** Once a chunk is closed, its owned paths are
  immutable. A later chunk MUST NOT reopen them to backfill, correct, or
  re-grade. Corrections are made in a *new* chunk, not by editing history.
- **A chunk owns what it declares.** Cross-chunk leakage — satisfying one
  chunk's gate by editing another chunk's paths — is a boundary violation
  and MUST FAIL.
- **Evidence travels with the change.** The evidence and imports a status
  transition relies on MUST be committed and tracked in the same change
  that asserts the transition. Untracked evidence is not evidence.

## Read-Gate by Risk Tier

Not every `passing` verdict can be machine-certified. The audit asserts
only what is machine-certain and marks the remainder "needs human read."
The *depth* of that required human read scales with the chunk's risk tier
(`core/PLANNING_METHODOLOGY.md`, `core/AUTONOMOUS_DELIVERY_GOVERNANCE.md`
§Risk-Tiered Autonomy). A verdict the machine cannot fully certify MUST NOT
be auto-promoted above the read-gate for its tier.

| Risk tier | Machine-certified verdict | Machine-uncertain verdict (unverified intent / below required depth) |
|---|---|---|
| low | auto-promote on green | SHOULD record a short read rationale |
| medium | auto-promote on green | one human reviewer MUST read and confirm before promotion |
| high | auto-promote on green | chair signoff + reviewer MUST read; board lens applies |
| critical | auto-promote on green | designated accountable approver MUST read; hollow verdicts block release |

A hollow verdict (§Hollow-Verdict Rule) MUST NOT be promoted at any tier;
it is a FAIL, not a read-gate item. The read-gate governs only
*unverified-intent* and below-required-depth verdicts, which are honest but
not yet independently certified.

## The Trust Boundary

A lock only works if the maker **cannot rewrite the approved hash in the
same breath it edits the specification.** If one agent can edit
`requirements.lock` *and* the checker's logic, the mechanism collapses back
into self-grading. Sufficiency therefore requires the checker's input — the
human-approved contract hash and the frozen contract — to live **outside
the maker's write scope.**

This policy's sufficiency envelope is bounded accordingly:

- **Supervised / CI use (this version's target).** The approved hash lives
  on a **protected branch** under branch protection, and the checker runs
  as a **blocking CI gate**. In this envelope the mechanism set is
  sufficient against the same agents. This is achievable now and is what
  this policy MUST be deployed within.
- **Fully unattended use (out of scope for this policy).** For an
  unattended loop, the checker MUST run as a **separate
  session / profile / identity** from the maker, so the party being graded
  cannot reach the checker's input. Providing that separation is the
  concern of a downstream consumer program and is **not a deliverable of
  this policy** — it is named and specified elsewhere, not here.

Consumers MUST NOT deploy the checker unattended on the assumption that it
is self-protecting. Absent the separation above, an unattended checker
sharing the maker's write scope is self-grading and its verdicts MUST NOT
be trusted.

## Acceptance-Integrity Audit (Report-Only)

A report-only acceptance-integrity audit MAY walk existing closeouts and
classify each `passing` verdict. It is a **regression detector**, not the
preventer, and it MUST NOT reopen, re-run, or fail already-closed chunks
(that would itself be a frozen-boundary violation).

Recognized classification levels:

- **verified** — observed at `board_passing`, or all intent assertions
  passed.
- **ok** — `passing` with an acceptance trace, above `mock` depth, no
  outstanding reason flags.
- **unverified_intent** — `passing` with hard requirements but no intent
  assertion below `board_passing` depth (routes to read-gate).
- **hollow** — `no_acceptance_trace` or `mode_gated_mock` (never satisfies a
  gate).

Closeouts authored before this policy lack intent fields and will classify
as `unverified_intent` (or `hollow` for empty-acceptance / mock-only). That
is the *fair* result: the audit asserts only what is machine-certain and
marks the rest for human read. Backfilling the intent field by re-running a
closed gate is a frozen-boundary violation and MUST NOT be done.

## Anti-Patterns

1. Computing a `passing` status from a value the maker controls (a literal,
   the run mode, a pre-declared card status, a grepped document string).
2. Presenting or aggregating `passing@mock` as `passing`.
3. Substituting a stub for a filed, time-bound waiver when the real
   artifact cannot yet be produced.
4. Letting the maker be the sole grader of whether its own work meets the
   hard requirements.
5. Editing a closed chunk to backfill, correct, or re-grade it instead of
   opening a new chunk.
6. Shipping the mechanisms in report-only form and calling the class
   prevented; report-only detects, it does not block.
7. Deploying the checker unattended while it shares the maker's write scope
   over the lock or the checker logic.

## Cross-References

- `core/EVIDENCE_CONTRACT.md` — per-acceptance `evidence_mode`
  qualification, the `intentAssertions` / `acceptanceIntegrity` fields, and
  the Scenario Status Vocabulary these terminal states resolve into.
- `core/EXCEPTIONS_AND_WAIVERS.md` — the only sanctioned escape (WAIVED);
  waivers MUST be time-bound and human-approved.
- `core/PLANNING_METHODOLOGY.md` — the acceptance trace, `hard:true` +
  `predicate` + `antiProxy`, and the `requirements.lock` concept.
- `core/MUTATION_EVIDENCE.md` — the "necessary but not sufficient"
  principle generalized from tests to gates: a gate MUST FAIL a planted
  violation.
- `core/AUTONOMOUS_DELIVERY_GOVERNANCE.md` — the loop primitives, the
  checker≠maker rule, PASS/WAIVE/FAIL terminal states, and §Risk-Tiered
  Autonomy for the read-gate tiers.
- `core/GIT_BRANCH_STRATEGY.md` — branch protection (M2 lock location),
  atomic scope guardrails, and frozen-chunk isolation (M4).
- `core/BOARD_REVIEW_GOVERNANCE_METHODOLOGY.md` — the board read-gate at
  high/critical tier for machine-uncertain verdicts.
- `contracts/implementation-handoff.schema.json` — carries the locked
  hard-requirement contract (hash).
- `validation/CONSISTENCY_RULES.md` — fail-closed rules for qualified
  verdicts, frozen-paths, and intent coverage.
