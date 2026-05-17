# Evaluation Memo — Power of 10 Universal Adoption + CockpitVM Embedded Style

**Phase:** 8.2 | **Chunk:** SCN-8.2.1 | **Owner:** Accountable Delivery Lead
**Status:** draft (pending board review at SCN-8.2.5)

Linked artifacts:

- Pool Q&A: `docs/planning/pool_questions/phase-8.2-style-adoption.md`
- Chunk plan: `docs/planning/chunks/phase-8.2-chunks.md`
- Risk log: `docs/planning/phase-8.2-risks.md`
- TO-DO: `docs/planning/phase-8.2-todo.md`
- Target contract: `core/CODE_IMPLEMENTATION_COMPLEXITY_GOVERNANCE.md`
  (adopted `8b65071`)
- Recommended opt-in style: `adapters/profiles/CockpitVM_Embedded_Style.md`
  (to be created in SCN-8.2.3)

---

## 1. Scope and Non-Goals

### Scope

Evaluate adoption of the *Power of 10* per-function safety-critical
discipline as a universal amendment to the existing complexity core
contract, and adoption of a project-owned C/C++ embedded deterministic
style guide (branded **CockpitVM Embedded Style**) distilled from the
scratch material in `raw/`. The complexity core contract governs
architectural complexity (ownership, naming, placement, size caps,
forbidden patterns, review rubric). Power of 10 operates one level down
at per-function discipline; the embedded style operates one level down
again at language-specific deterministic patterns.

### Non-goals

- Replacing or weakening the existing 25 / 40 LOC function cap.
- Editing the autonomous-delivery state machine, risk-tier matrix, or
  evidence contract.
- Wider language-style coverage (Rust, Go, Python).
- Re-litigating the §Complexity Review Rubric.

---

## 2. Power of 10 Rule-by-Rule Matrix

Each rule has a verdict (**amend** = added to the complexity core as a
universal clause; **subsumed** = already covered by an existing clause;
**embedded-only** = lives only in the CockpitVM Embedded Style),
existing-clause references, and draft clause text for the amendment.

### Rule 1 — Restrict control flow; no recursion; no `goto`/`setjmp`

- **Verdict:** **amend** (universal: no recursion). C/C++-specific
  `goto`/`setjmp` clause goes to embedded-only.
- **Existing clause references:** §Forbidden Patterns Without Human
  Exception (currently silent on recursion).
- **Draft amendment text:**
  > Agents MUST NOT introduce direct or indirect recursion in
  > production code without a human-approved exception. Indirect
  > recursion includes mutual recursion across modules.
  > (Power of 10, rule 1.)

### Rule 2 — All loops have a fixed upper bound

- **Verdict:** **amend** (universal).
- **Existing clause references:** §Forbidden Patterns Without Human
  Exception (currently silent on unbounded loops).
- **Draft amendment text:**
  > Agents MUST NOT introduce loops without a statically demonstrable
  > upper bound. Equivalent forms (e.g. event-loop body with a
  > short-circuit timeout) satisfy the rule when the bound is part of
  > the loop construct, not an external invariant.
  > (Power of 10, rule 2.)

### Rule 3 — No dynamic memory allocation after initialization

- **Verdict:** **amend** (generic universal phrasing) + **embedded-only**
  (allocator-pattern specifics).
- **Existing clause references:** §Mandatory Design Invariants #2 (one
  owner per resource); §Forbidden Patterns (silent on post-init
  allocation).
- **Draft amendment text:**
  > Agents MUST NOT introduce dynamic memory allocation in the steady
  > state of production code. "Steady state" means the period after
  > initialization completes; allocation during init is permitted when
  > the lifetime is bounded by a clearly named owner (per §Mandatory
  > Design Invariants #2). Languages with mandatory dynamic allocation
  > (e.g. Python, Java) MAY satisfy this rule by documenting an
  > allocation budget per execution root.
  > (Power of 10, rule 3.)
- **Embedded specifics:** placement-new, `cockpit::core::RingBuffer<T,N>`,
  and static-buffer allocators are CockpitVM-style patterns.

### Rule 4 — Function length ≤ ~60 LOC

- **Verdict:** **subsumed** (existing 25/40 LOC cap is stricter).
- **Existing clause references:** §Component Size Limits, row "Function"
  (25 warning / 40 hard cap).
- **Action:** add a footnote to §Component Size Limits documenting the
  Power of 10 ~60-line guideline as the looser ancestor. See §3 below.

### Rule 5 — Assertion density ≥ 2 per function

- **Verdict:** **supplement** (universal `SHOULD`, not `MUST`).
- **Existing clause references:** none.
- **Rationale.** A hard `MUST` would create immediate retroactive churn
  on existing code (R-8.2-01). Phrased as `SHOULD` with scope limited to
  *new or touched* production code, the rule lands cleanly under the
  existing "Grandfathering" treatment.
- **Draft amendment text:**
  > Agents SHOULD include at least two assertions per nontrivial
  > function added or touched in production code. Assertions document
  > preconditions, postconditions, and invariants — not error handling
  > at the boundary. Trivial getters/setters and one-line wrappers are
  > exempt.
  > (Power of 10, rule 5.)

### Rule 6 — Data declared at smallest possible scope

- **Verdict:** **subsumed**.
- **Existing clause references:** §Mandatory Design Invariants #1 (one
  owner per mutable state variable); §Forbidden Patterns (new file-scope
  mutable globals in orchestration files).
- **Action:** none beyond a cross-reference in the SCN-8.2.2 amendment
  preamble citing rule 6 as already covered.

### Rule 7 — Check return values; validate parameters

- **Verdict:** **amend**.
- **Existing clause references:** §Required Pre-Implementation Checklist
  (no row for return-value handling); §Forbidden Patterns (silent on
  unchecked returns).
- **Draft amendment text:**
  > Agents MUST check the return value of every non-void function call
  > in production code, or MUST explicitly cast to `(void)` with a
  > one-line comment stating the rationale. Agents MUST validate
  > parameters at every public boundary in production code.
  > (Power of 10, rule 7.)
- **Checklist row to add:**
  > Return-value and parameter validation: list any non-void call sites
  > that intentionally discard their return, with rationale; list any
  > public boundary functions and the validation they perform.

### Rule 8 — Preprocessor: includes + simple macros only

- **Verdict:** **amend** (generic universal phrasing) + **embedded-only**
  (C/C++ preprocessor specifics).
- **Existing clause references:** §Naming Rules (silent on macros);
  §Forbidden Patterns (silent on token-pasting / conditional compilation).
- **Draft amendment text:**
  > Agents MUST NOT use preprocessor or macro features beyond file
  > inclusion, simple object-like definitions, and language-idiomatic
  > guards. Token pasting, recursive macros, computed includes, and
  > conditional-compilation gates that hide alternative code paths from
  > review require a human-approved exception.
  > (Power of 10, rule 8.)
- **Embedded specifics:** the YAML's preprocessor guidance (header
  organization with `extern "C"` blocks) lives in the CockpitVM
  Embedded Style.

### Rule 9 — Pointer restrictions; no function pointers

- **Verdict:** **embedded-only**.
- **Rationale.** The rule is C/C++-specific. Higher-level languages
  express equivalent guarantees through reference semantics. Placing the
  rule in the universal core would either (a) be a tautology in most
  languages or (b) drag pointer-shaped vocabulary into policies that
  shouldn't speak it.
- **Action:** rule lives only in `adapters/profiles/CockpitVM_Embedded_Style.md`.

### Rule 10 — All warnings enabled + at least one static analyzer

- **Verdict:** **amend**.
- **Existing clause references:** §Required Validation Evidence
  (currently lists build/test evidence appropriate to risk tier; silent
  on analyzer floor).
- **Draft amendment text:**
  > Validation evidence for production changes MUST include: clean
  > compile under all-warnings (language-idiomatic equivalent of
  > `-Wall -Wextra -Werror` for C/C++, `RUSTFLAGS="-D warnings"` for
  > Rust, equivalent linter strict mode for dynamic languages); and at
  > least one static analyzer reporting zero findings on touched files.
  > The analyzer choice MUST be declared in the governance manifest.
  > The analyzer's minimum capability is detection of: recursion,
  > unbounded loops, dynamic allocation in the steady state, and
  > unchecked non-void returns.
  > (Power of 10, rule 10.)

### Matrix summary

| Rule | Verdict | Lands in |
|---|---|---|
| 1 | amend | core §Forbidden Patterns + embedded `goto`/`setjmp` |
| 2 | amend | core §Forbidden Patterns |
| 3 | amend (generic) | core §Forbidden Patterns + embedded allocator patterns |
| 4 | subsumed | core §Component Size Limits footnote |
| 5 | supplement | core §Power of 10 Discipline (Universal) — SHOULD |
| 6 | subsumed | cross-reference in core preamble |
| 7 | amend | core §Forbidden Patterns + §Required Pre-Implementation Checklist |
| 8 | amend (generic) | core §Forbidden Patterns + embedded preprocessor specifics |
| 9 | embedded-only | `adapters/profiles/CockpitVM_Embedded_Style.md` |
| 10 | amend | core §Required Validation Evidence |

**Five rules amended universally** (1, 2, 3, 7, 8, 10 + supplement 5),
**two subsumed** (4, 6), **one embedded-only** (9). Rule 5 ships as a
`SHOULD`.

---

## 3. LOC-Cap Resolution Memo

The existing complexity core sets function size at 25 (warning) / 40
(hard cap). Power of 10 rule 4 sets it at roughly 60 lines ("one printed
page"). The conflict is resolved in favor of the stricter cap.

**Decision.** Existing 25 / 40 LOC stays. The §Component Size Limits
section gains a footnote:

> The function-length cap of 25 / 40 LOC is stricter than the Power of
> 10 rule 4 guideline (~60 LOC, "one printed page"). The stricter cap
> better serves the change-amplification invariant declared in §Core
> Principle. Power of 10 rule 4 is documented here as the looser
> ancestor, not as an alternative permitted by exception.

**Rationale.** The existing cap is empirically calibrated to this
project's review pattern; relaxing it would weaken the
change-amplification probe required by §Required Pre-Implementation
Checklist. Documenting the ancestor relationship preserves the audit
trail without re-litigating the cap. Confidence on this resolution per
the pool Q&A: 5/5.

---

## 4. CockpitVM Embedded Style — Gap Walk

The scratch YAML in `raw/` (gitignored; filename intentionally omitted to
keep body text agency-free) contains eleven section groups. The authoritative CockpitVM Embedded
Style at `adapters/profiles/CockpitVM_Embedded_Style.md` (created in
SCN-8.2.3) internalizes them as follows. Every group's body text is
rewritten in CockpitVM-owned vocabulary; **all external agency /
institutional names are stripped from body text.** Only the evaluation
memo Sources footer (this file's §6) carries publication-only citations.

| YAML section group | Disposition in CockpitVM Embedded Style |
|---|---|
| Preamble + meta | Replaced with CockpitVM preamble: scope, `MUST`/`SHOULD`/`MAY` keyword discipline declared normative, lineage pointer to this memo. |
| ABI boundary strategy | Carried in full: `extern "C"`-equivalent public linkage; POD-only types across module boundaries; opaque-handle pattern; static placement-new pattern. CockpitVM identifiers throughout. |
| Allowed C++ language features | Carried in full: strong typing, const correctness, references, scoped enums, templates, inline, CRTP, `constexpr`, namespaces, classes-without-virtuals, RAII-for-static-resources, non-virtual destructors. |
| Forbidden C++ language features | Carried in full: virtual functions, virtual destructors, RTTI, exceptions, dynamic allocation, STL containers (with `std::array` exception), multiple inheritance, excessive operator overloading. Each entry retains its rationale and alternative. |
| Determinism requirements | Carried in full with cross-links to core §Power of 10 Discipline rules 2 (loop bounds), 3 (no post-init allocation), 7 (timeouts/parameter validation). WCET sub-rule lives here. |
| Required type-safety patterns | `Result<T,E>`, `Span<T>`, `RingBuffer<T,N>` are renamed into the `cockpit::core::` namespace; code snippets use CockpitVM identifiers; no external project identifiers in body. |
| Pointer-use rule (P10 #9) | Lands here as the canonical home: no more than one level of dereference; no function pointers; alternatives are CRTP and tagged-union dispatch. |
| Verification checklist | Carried in full as the fail-closed gate fixture (consumed by SCN-8.2.4): compile-time (no vtables, no exception tables, no RTTI), link-time (no `malloc`/`new` symbols, no unwind symbols, stack within bounds), runtime (WCET evidence, stack high-water mark, error-path coverage). |
| Tooling integration | Carried with the analyzer floor wording aligned to core §Required Validation Evidence (rule 10 amendment). Build-flag list (`-fno-exceptions -fno-rtti -fno-threadsafe-statics -fstack-usage`) reproduced verbatim. |
| Header / implementation organization | Carried in full with CockpitVM-owned filenames in the examples (e.g. `cockpit_public_api.h`). |
| Summary / formula | Replaced with a CockpitVM-owned closing summary; no agency banner. |

**Agency-string invariant.** When SCN-8.2.3 lands, a case-insensitive
regex covering the upstream agency, lab, and standard-series identifiers
MUST return zero hits on `adapters/profiles/CockpitVM_Embedded_Style.md`.
The exact pattern is encoded in the CI guard introduced by SCN-8.2.4
(see that chunk for the canonical pattern); this memo intentionally does
not reproduce the pattern verbatim so that the memo body itself remains
free of agency tokens.

---

## 5. Recommendation

**Adopt** the Power of 10 universal discipline as an additive amendment
to `core/CODE_IMPLEMENTATION_COMPLEXITY_GOVERNANCE.md` per the matrix in
§2, the LOC-cap resolution in §3, and the gap walk in §4. **Adopt** the
CockpitVM Embedded Style as an opt-in companion artifact wired through
`adapters/profiles/EMBEDDED_PROFILE.md`. The CockpitVM Embedded Style is
**opt-in via the embedded profile**: consumers who do not declare the
embedded profile in their governance manifest do not pick up the new
embedded-specific gates.

Risk-tier mapping:

- SCN-8.2.2 (core amendment): **critical** — board review mandatory.
- SCN-8.2.3 (new authoritative style): **high** — board review mandatory.
- SCN-8.2.4 (wiring + validation + CI guard): **medium**.
- SCN-8.2.5 (sign-off): **critical** — board review mandatory.

Risk owners and mitigations are recorded in `docs/planning/phase-8.2-risks.md`.

Pool Q&A gate (per `core/PLANNING_METHODOLOGY.md` §Ambiguity Model):
**ambiguity 0.0215 ≤ 0.20** and **average confidence 4.25 ≥ 4.0** —
both gates cleared. The phase is authorized to proceed past SCN-8.2.0.

---

## 6. Sources

- Holzmann, G. J. *The Power of 10: Rules for Developing Safety-Critical Code.*
  IEEE Computer, vol. 39, no. 6, pp. 95–97, June 2006.
- Holzmann, G. J. *The Power of Ten — Rules for Developing Safety Critical Code.*
  Technical report, 2006. Wikipedia summary:
  https://en.wikipedia.org/wiki/The_Power_of_10:_Rules_for_Developing_Safety-Critical_Code
