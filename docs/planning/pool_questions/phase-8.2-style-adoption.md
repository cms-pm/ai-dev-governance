# Phase 8.2 Pool — P10 Universal Adoption + CockpitVM Embedded Style

## Goal

Amend the complexity core contract (adopted `8b65071`) with a
language-agnostic Power of 10 discipline, and add an authoritative
project-owned C/C++ embedded style guide branded **CockpitVM Embedded
Style**. The scratch YAML and PDF inputs remain in `raw/` (gitignored);
all external agency / institutional names are stripped from policy bodies.

## Scope

- Universal Power of 10 amendment to
  `core/CODE_IMPLEMENTATION_COMPLEXITY_GOVERNANCE.md`.
- New authoritative C/C++ style guide at
  `adapters/profiles/CockpitVM_Embedded_Style.md`.
- Opt-in wiring in `adapters/profiles/EMBEDDED_PROFILE.md` + validation
  rule + CI guard against agency-string regressions.

## Non-goals

- Wider language-style coverage (Rust, Go, Python).
- Re-tuning the existing 25 / 40 LOC function cap.
- Editing the autonomous-delivery state machine or risk-tier matrix.

## Principles adopted

**Stricter cap stands.** The existing 25 / 40 LOC function cap is
preserved; the Power of 10 ~60-line guideline is documented as the looser
ancestor.

**Body text is agency-free.** No external agency or institutional name
appears in `core/`, `adapters/`, or `validation/` policy bodies. Minimal
publication citations (author + year + venue) are confined to the
evaluation memo Sources footer.

**Raw is scratch.** `raw/` stays gitignored; committed artifacts cite the
CockpitVM Embedded Style, never `raw/` paths.

## Questions and Resolutions

Ambiguity scoring follows `core/PLANNING_METHODOLOGY.md`:

`score = sum(P * U * M * I) / sum(I)` with `P ∈ [0,1]`, `U ∈ {0, 0.5, 1.0}`,
`M ∈ [0,1]`, `I ∈ [1,5]`. Confidence `c ∈ [1,5]` per the standard rubric.

### Q1 — How is the LOC-cap conflict between existing 25 / 40 and P10's ~60 resolved?

**Resolution.** The existing 25 (warning) / 40 (hard cap) limits stay.
SCN-8.2.2 adds a footnote to §Component Size Limits documenting Power of
10's ~60-line guideline as the looser ancestor, with a one-line rationale
("stricter caps better serve the change-amplification invariant").

**Rationale.** The existing cap is empirically calibrated to this repo's
review pattern; relaxing it would weaken the change-amplification probe.
Documenting the ancestor relationship preserves the audit trail without
re-litigating the cap.

`P=0.10`, `U=0.0`, `M=0.10`, `I=4`, weighted impact `0.040`. Confidence `5`.

### Q2 — What is the minimum static-analyzer capability required for the new validation-evidence clause?

**Resolution.** The amended §Required Validation Evidence clause requires
clean compile under all-warnings + at least one static analyzer reporting
zero findings on touched files. The analyzer choice is declared in the
governance manifest (free-form string today; schema tightening deferred to
Phase 8.3+). Minimum capability: must detect at least the four newly
forbidden patterns (recursion, unbounded loops, dynamic allocation
post-init, unchecked return values) on the languages the project uses.

**Rationale.** Listing specific analyzers in the core would bind the policy
to tool availability and licensing. A capability floor plus manifest
declaration keeps the policy portable and auditable.

`P=0.25`, `U=0.5`, `M=0.15`, `I=4`, weighted impact `0.075`. Confidence `4`.

### Q3 — How do consumers discover that the embedded profile is opt-in, not default?

**Resolution.** Three reinforcing signals:
(a) `adapters/profiles/EMBEDDED_PROFILE.md` preamble already states
"extends, does not replace"; SCN-8.2.4 preserves that language verbatim
and adds an "Opt-in declaration" subsection naming the manifest key.
(b) The fail-closed gate added in SCN-8.2.4 only fires when the manifest
declares the embedded profile; the validator's fixture suite includes
a non-embedded-profile manifest case that MUST pass.
(c) The evaluation memo recommendation section explicitly labels the
CockpitVM Embedded Style as "opt-in via embedded profile" in its first
paragraph.

**Rationale.** Opt-in confusion is the highest-likelihood Phase 8.2 risk
(R-8.2-03). Triangulating signals across preamble, fixture, and memo
removes the single point of failure.

`P=0.40`, `U=0.5`, `M=0.20`, `I=5`, weighted impact `0.200`. Confidence `4`.

### Q4 — How is the CockpitVM rebrand lineage discoverable for auditors who need to verify provenance?

**Resolution.** The evaluation memo (`docs/planning/evaluations/p10-
and-cockpitvm-style-eval.md`) is the canonical lineage artifact. Its
Sources footer lists the publication-only citations (e.g., "Holzmann, G.
J. *The Power of 10: Rules for Developing Safety-Critical Code.* IEEE
Computer, June 2006"). Auditors querying lineage land on the memo via
`.astaire/astaire query -t evaluation --tag phase=8.2`. The CockpitVM
Embedded Style file itself MAY carry a one-line "Lineage" pointer at the
top — phrasing TBC in SCN-8.2.3 — that references the memo by path
without naming the upstream agencies.

**Rationale.** Provenance must be retrievable but not embedded in policy
prose. Astaire is the discovery surface; the memo is the citation
surface; the style guide stays agency-free.

`P=0.30`, `U=0.5`, `M=0.15`, `I=4`, weighted impact `0.090`. Confidence `4`.

## Ambiguity Gate

| Question | P | U | M | I | P·U·M·I | Confidence |
|---|---:|---:|---:|---:|---:|---:|
| Q1 LOC cap conflict | 0.10 | 0.0 | 0.10 | 4 | 0.000 | 5 |
| Q2 Analyzer floor | 0.25 | 0.5 | 0.15 | 4 | 0.075 | 4 |
| Q3 Opt-in discoverability | 0.40 | 0.5 | 0.20 | 5 | 0.200 | 4 |
| Q4 Rebrand lineage | 0.30 | 0.5 | 0.15 | 4 | 0.090 | 4 |
| **Totals** | | | | **17** | **0.365** | |

- Weighted impact total: `0.365`
- Sum of `I`: `17`
- **Ambiguity score: `0.365 / 17 = 0.0215`** ≤ `0.20` ✅
- **Average confidence: `(5 + 4 + 4 + 4) / 4 = 4.25`** ≥ `4.0` ✅

Gate passed. Phase 8.2 cleared to proceed past SCN-8.2.0 bootstrap.

## Linked artifacts

- Chunk plan: `docs/planning/chunks/phase-8.2-chunks.md`
- Risks: `docs/planning/phase-8.2-risks.md`
- TO-DO: `docs/planning/phase-8.2-todo.md`
- Memo (created by SCN-8.2.1):
  `docs/planning/evaluations/p10-and-cockpitvm-style-eval.md`
