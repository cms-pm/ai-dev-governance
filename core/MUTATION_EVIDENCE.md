# Mutation Evidence Policy

## Purpose

This core policy defines how mutation-testing evidence is produced,
reviewed, and gated under ADG. It complements
`core/AI_ASSISTED_TDR_METHODOLOGY.md` by raising the empirical bar on
test-suite effectiveness: a passing test suite is necessary but not
sufficient evidence that behavior is objectively validated.

Keywords `MUST`, `SHOULD`, and `MAY` are normative.

## Advisory Marker (Phase 9)

**The tier threshold table in this document is ADVISORY until SCN-9.7
ratification.** The SCN-9.5 baseline run on `astaire/` produces the
data the SCN-9.7 board uses to adopt, revise, or defer the proposed
thresholds (DEC-0005). Until SCN-9.7 sign-off lands,
`scripts/validators/mutation_threshold.py` MUST run in WARN mode only.
After ratification, this advisory marker is removed in the same commit
that flips `validation/CONSISTENCY_RULES.md` §17 to fail-close.

## Core Principle

Mutation testing measures how many small, behavior-changing edits
("mutants") of production code the test suite catches ("kills"). A
surviving mutant is direct evidence that some line of production code
can be silently broken without any test failing. Mutation score is the
percentage of generated mutants the suite kills.

## Definitions

- **Mutant.** An automated modification of production code (e.g.
  flipping a boolean, swapping `<` for `<=`, deleting a return).
- **Killed mutant.** A mutant that causes at least one test to fail.
- **Surviving mutant.** A mutant that does not cause any test to fail.
- **Equivalent mutant.** A mutant whose modified code is functionally
  identical to the original (e.g. `x * 1` swapped to `x`). Equivalent
  mutants are unkillable by construction and MUST be excluded via the
  exception process below, not by lowering the threshold.
- **Mutation score.** `killed / (killed + surviving - equivalent)`.
- **Tier.** The risk-tier label declared for the chunk
  (low/medium/high/critical), per `core/PLANNING_METHODOLOGY.md`.

## Proposed Tier Threshold Table (Advisory)

| Risk tier | Mutation score | Additional requirement |
|---|---|---|
| Low | not required | — |
| Medium | ≥ 70% | survivor list reviewed; disposition recorded |
| High | ≥ 85% | survivor list reviewed; equivalent-mutant exceptions filed |
| Critical | ≥ 90% | zero survivors permitted in domain core; equivalent-mutant exceptions filed |

These numbers are proposed inputs to DEC-0005. The SCN-9.5 baseline run
on `astaire/` claims/projection core provides the empirical data that
informs the final ratified numbers.

## Tool Policy

ADG is tool-agnostic at the core level. Recommended tooling per
language family:

- **Python.** Cosmic Ray (full pass, CI evidence) primary; mutmut
  (developer inner loop) secondary.
- **JavaScript / TypeScript.** Stryker (declared at the adapter
  profile, not in core).
- **Java / Kotlin.** PIT (declared at the adapter profile).
- **Go / Rust / C / C++.** Per-language adapter profile names the tool.

Tool selection MUST be declared in `analyzers.mutation.tool` in the
governance manifest.

## Evidence URI Contract

Each acceptance item under medium-or-higher risk tier MUST emit a
`mutationReportURI` pointing at a human- and machine-readable mutation
report. The report MUST include:

1. Tool name and version.
2. Configuration file path (e.g. `cosmic-ray.toml`).
3. Run timestamp and host environment summary.
4. Target paths (which production modules were mutated).
5. Test command used for kill detection.
6. Aggregate score (killed / total non-equivalent mutants).
7. Per-module breakdown.
8. **Survivor list.** Every surviving mutant with: file:line, mutation
   operator, original snippet, mutated snippet, disposition column
   (kill-pending / equivalent-exception-<id> / accepted-residual-<id>).
9. Pointer to the run log/artifact.

Reports MUST be registered under `docs/evidence/mutation/` (path
overrideable via `analyzers.mutation.reportPath`).

## Survivor Triage Protocol

Every surviving mutant MUST be dispositioned in one of three ways:

1. **kill-pending.** A new or strengthened test is added; the next
   mutation pass MUST show this mutant killed. Tracked in the chunk's
   TO-DO or follow-up list.
2. **equivalent-exception-<id>.** The mutant is functionally
   equivalent. The exception record MUST cite the policy clause and
   include a short justification (the equivalence argument). Exceptions
   accumulate in the report's appendix and in
   `core/EXCEPTIONS_AND_WAIVERS.md`-tracked records.
3. **accepted-residual-<id>.** The mutant is non-equivalent but the
   behavior is acknowledged as untested by deliberate scope choice
   (e.g. defensive code path). Requires the same exception record shape
   as #2 plus an expiration date for re-review.

A survivor disposition of "we did not have time" MUST NOT pass review.

## Equivalent-Mutant Exception Process

Equivalent mutants MUST be filed as exceptions, not silenced via
tool-level ignore lists. The exception record MUST include:

- exception ID,
- file:line of the mutant,
- mutation operator,
- equivalence justification (one paragraph),
- reviewer approval (named human).

Exceptions are reviewable artifacts; tool-level ignore lists are not.

## Survivor Density and Domain Core

For chunks under `core/MODULARITY_GOVERNANCE.md` discipline, the domain
core (the I/O-free package(s) the architecture-fitness rule protects)
is the highest-priority mutation target. At critical tier, the
proposed table requires **zero survivors** in the domain core: any
surviving mutant under the protected domain path MUST be
kill-pending or filed as an equivalent-mutant exception before
sign-off.

## TDR Integration

`core/AI_ASSISTED_TDR_METHODOLOGY.md` §TDR-RGM (Red-Green-Mutate)
codifies the RED-first-with-mutation discipline: at risk-tier ≥ medium,
the acceptance test MUST fail before the implementation lands (RED),
pass after it lands (GREEN), and survive mutation analysis at the
declared tier threshold (MUTATE). The MUTATE step's evidence is the
mutation report defined here.

## Risk Tier Coupling

- Low-tier work is not required to produce mutation evidence.
- Medium-tier and higher chunks MUST declare the `analyzers.mutation`
  block in the governance manifest or record an exception under
  `core/EXCEPTIONS_AND_WAIVERS.md`.
- Until SCN-9.7 ratification (see Advisory Marker above), the
  `mutation_threshold.py` validator runs in WARN mode. After
  ratification, `validation/CONSISTENCY_RULES.md` §17 flips to
  fail-close at the tiers above.

## Anti-Patterns

1. Reporting a single aggregate score without a survivor list.
2. Silencing surviving mutants via the tool's per-line ignore syntax
   instead of the exception process.
3. Treating low mutation score as a property of the production code
   rather than a property of the test suite.
4. Re-running mutation analysis after deleting tests until the score
   improves (regression-by-deletion).
5. Mutating non-production code (test helpers, fixtures, generated
   stubs); the report MUST scope to production modules.

## Cross-References

- `core/AI_ASSISTED_TDR_METHODOLOGY.md` §TDR-RGM — RED-first acceptance
  test gate at risk-tier ≥ medium.
- `core/BOARD_REVIEW_GOVERNANCE_METHODOLOGY.md` §Test-Design Lens — the
  test-design lens reviews mutation reports as part of accountability
  reviews.
- `core/EVIDENCE_CONTRACT.md` — `mutationReportURI` per-acceptance
  evidence field.
- `core/MODULARITY_GOVERNANCE.md` — domain core is the highest-priority
  mutation target.
- `validation/CONSISTENCY_RULES.md` §17 — required-presence of the
  `analyzers.mutation` block by risk tier (WARN until SCN-9.7).
- `contracts/governance-manifest.schema.json` — schema for the
  `analyzers.mutation` block.
- `runbooks/MUTATION_TESTING.md` — operating procedure (lands at
  SCN-9.6).
