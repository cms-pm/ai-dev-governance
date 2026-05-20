---
phase: 9
stage_produced: plan
---

# Phase 9 Pool — TDR Hardening (DDD + Hexagonal + Mutation + Test-Design)

## Goal

Hybridize ADG's TDR (Test-Driven Requirements) philosophy with the
complementary disciplines surveyed in
`/Users/cms/.claude/plans/as-senior-architect-for-cosmic-kite.md`:
ubiquitous-language Domain-Driven Design, hexagonal (ports + adapters)
modularity, empirical test-effectiveness via mutation testing, and Dave
Farley's eight test-design properties as a new board lens. Adopt these as
**first-class governance concepts in `core/`** (portable, language-
agnostic policy), with **runtime ergonomics provided only at the Claude
adapter layer** as Claude Code skills (Python/pytest rewrites of the
`raw/skills-entourage/` corpus). Self-apply the new policies to
`astaire/` as the reference implementation, producing the first mutation
and Farley-scorecard evidence artifacts inside Astaire.

## Carry-forward inputs

**From `docs/planning/phase-8.3-risks.md` (monitor lane):**

- R-8.2-02 (Medium / Medium) — analyzer-capability schema landed at
  SCN-8.3.4; closure still waits on first downstream consumer adoption.
  Phase 9 does not own closure; sprint critique re-checks.
- R-8.2-03 (High / Medium) — opt-in confusion for CockpitVM Embedded
  Style. Phase 9 introduces new opt-in profiles (mutation tier, glossary
  presence) — adoption-confusion risk pattern recurs; new R-9 risk
  inherits the mitigation discipline (triangulation surface).
- R-8.2-05 (High / Medium) — Phase 8.1 reciprocal entry on `main` still
  outstanding. Phase 9 carries the same standing sprint-critique read;
  closure cadence unchanged.
- R-8.3-03 — analyzer-capability schema rejection risk for downstream
  manifests; Phase 9's contract additions (mutation, glossary,
  architecture-fitness) inherit the same backward-compat discipline.

**From the approved architecture plan
(`/Users/cms/.claude/plans/as-senior-architect-for-cosmic-kite.md`):**

The plan recommends a **hybrid** adoption: policy in `core/` (portable),
runtime help in `adapters/providers/claude/skills/` (Claude-only). Phase
9 implements that decision. Skills-as-governance is explicitly rejected
to preserve ADG's portability promise to Codex and future adapters.

## Scope

- **New core policy documents:** `core/MODULARITY_GOVERNANCE.md`,
  `core/DOMAIN_LANGUAGE_GOVERNANCE.md`, `core/MUTATION_EVIDENCE.md`.
- **Amendments** to existing core: `core/AI_ASSISTED_TDR_METHODOLOGY.md`
  (TDR-RGM subsection), `core/PLANNING_METHODOLOGY.md` (find-gaps
  sub-protocol; chunk-splitting aid), `core/BOARD_REVIEW_GOVERNANCE_METHODOLOGY.md`
  (eighth "test design" lens), `core/CODE_IMPLEMENTATION_COMPLEXITY_GOVERNANCE.md`
  (refactor onramp: seam map + characterisation suite), `core/EVIDENCE_CONTRACT.md`
  (new evidence URIs: mutation report, Farley scorecard, glossary
  coverage).
- **Contracts:** extend `contracts/governance-manifest.schema.json` with
  `analyzers.mutation`, `analyzers.domainGlossary`, and
  `analyzers.architectureFitness` blocks. Add `validation/CONSISTENCY_RULES.md`
  §17–§19. New validators under `scripts/validators/`. Astaire
  collection extensions for `domain-glossary`, `mutation-reports`,
  `farley-scorecards`.
- **Claude adapter skills:** Python/pytest-flavored rewrites of `tdd`,
  `mutation-testing` (Cosmic Ray primary, mutmut secondary),
  `test-design-reviewer`, `find-gaps`, `hexagonal-architecture`,
  `domain-driven-design`, `finding-seams`, `characterisation-tests`, and
  `story-splitting` under `adapters/providers/claude/skills/`. Each
  skill points at the relevant core policy as source of truth.
- **Self-application to `astaire/`:** author the ADG ubiquitous-language
  glossary (bounded contexts: governance-authoring, memory-palace,
  validation, adapters); stand up Cosmic Ray + mutmut harness; produce
  initial mutation report and Farley scorecard. Use the run to tune the
  tier thresholds before they become normative.
- **Runbook + templates:** `runbooks/MUTATION_TESTING.md`,
  `runbooks/GLOSSARY_AUTHORING.md`, and template additions under
  `templates/` for consumer-repo adoption. Migration note for
  downstream consumers.
- **Phase 9 board review packet + sign-off** mirroring the SCN-8.2.5 /
  SCN-8.3.5 shape; chair continuity with MTG-0004.

## Non-goals

- Vendoring `raw/skills-entourage/` wholesale or adopting the skills
  plugin runtime as governance. Skills live only at the Claude adapter
  layer.
- Stryker, Jest, Vitest, or any other JS/TS tooling — ADG is Python /
  pytest / uv; non-Python adapters declare equivalents in their own
  profile, not in Phase 9 scope.
- Re-tuning Power of 10 patterns, the 25/40 LOC function caps, or the
  embedded-profile fail-closed gate.
- Refactoring `scripts/` or `validation/` beyond the seams the
  hexagonal pass on `astaire/` exposes.
- Authoring Phase 8.1's reciprocal R-8.2-05 entry (still bidirectional;
  Phase 9 inherits monitor cadence only).
- Setting normative mutation thresholds before the SCN-9.5 baseline run
  produces real-data evidence. Proposed table in `MUTATION_EVIDENCE.md`
  is advisory until SCN-9.7 ratifies (or revises) it.

## Principles adopted

**Policy in core, runtime in adapter.** Every concept Phase 9 imports
from the skills entourage MUST land first as portable core policy with
evidence contracts and gate conditions. Claude skills are runtime
ergonomics that point at the policy; they do not encode normative rules.

**Hybrid TDR.** TDR-RGM extends TDR with a RED-first requirement at
risk-tier ≥ medium. The "behavior is objectively validated" condition is
unchanged; the increment is that validation now includes mutation
evidence and Farley-property review.

**Self-application is the live test.** Every new policy lands on
`astaire/` before it is recommended to consumer repos. The Farley
scorecard, mutation report, and ubiquitous-language glossary on
`astaire/` ARE the reference evidence bundle.

**Thresholds are advisory until data exists.** Mutation-score gates are
proposed in `MUTATION_EVIDENCE.md` at SCN-9.1 but only become normative
after the SCN-9.5 baseline run on `astaire/`. The SCN-9.7 board
sign-off ratifies the final thresholds.

**Schema tightening is additive.** All new manifest blocks
(`analyzers.mutation`, `analyzers.domainGlossary`,
`analyzers.architectureFitness`) are OPTIONAL at v1. Required-presence
is gated by the consumer's declared risk tier, not by schema-level
`required`. Existing consumer manifests MUST continue to validate.

## Questions and Resolutions

Ambiguity scoring per `core/PLANNING_METHODOLOGY.md`:
`score = sum(P * U * M * I) / sum(I)` with `P ∈ [0,1]`,
`U ∈ {0, 0.5, 1.0}`, `M ∈ [0,1]`, `I ∈ [1,5]`. Confidence `c ∈ [1,5]`.

### Q1 — What are the bounded contexts of ADG itself, and where do their boundaries lie?

**Resolution.** Four bounded contexts seed the ADG ubiquitous-language
glossary, with `governance-authoring` further sub-divided at the
sub-glossary level:

1. **governance-authoring** — pool questions, chunks, risks, sign-offs,
   board artifacts. Vocabulary: SCN, phase, chunk, acceptance ID,
   ambiguity score, board finding, opportunity, sprint critique,
   accountability review.
2. **memory-palace (astaire)** — claims, entities, documents,
   collections, projections (L0/L1/L2), FTS, hub score, ingest.
3. **validation** — consistency rules, fixtures, gates, fail-closed,
   analyzer capabilities, exception, waiver.
4. **adapters** — provider, profile, runtime, ergonomic, slash command,
   hook, skill (adapter-layer concept, NOT governance concept).

Boundaries: each context owns its terminology and emits events at the
seam. Cross-context references use the canonical noun (e.g. validation
emits a `gate-verdict` event consumed by governance-authoring; both
glossaries point at the same definition). Authoring authority for each
glossary file rests with the context owner declared in the glossary
preamble.

**Rationale.** Four contexts match the existing top-level directory
shape (`core/` + `adapters/` + `validation/` + `astaire/` submodule) and
the existing artifact taxonomy. Going finer (e.g. splitting
`board-review` from `chunk-planning`) creates glossary fragmentation
without changing the seams. Going coarser collapses the validation /
memory-palace distinction that the existing fail-closed gate
architecture already relies on.

`P=0.40`, `U=0.5`, `M=0.20`, `I=5`, weighted impact `0.200`. Confidence `4`.

### Q2 — Is the hexagonal refactor on `astaire/` full-scope or a pilot module?

**Resolution.** **Pilot-first.** SCN-9.4 lands the glossary in full,
identifies the seam map for the entire `astaire/` codebase, and
performs the hexagonal refactor on **one module: the claims/projection
core** (the domain of memory-palace least coupled to I/O). Full-repo
hexagonal refactor is deferred to a Phase 10 SCN, gated by a
characterisation-test suite that SCN-9.5 produces for the remaining
modules.

**Rationale.** Phase 9's primary deliverable is the policy layer plus a
reference implementation; not a full repo refactor. Piloting on the
claims/projection core gives the cleanest evidence the policy works
(domain free of I/O imports, port/adapter declaration validated by the
new fitness rule) without taking on the cost of an
ingest/SQLite/FTS-layer refactor that would dwarf the rest of the
phase. The seam map + characterisation suite produced under SCN-9.5
becomes the entry gate for the Phase 10 follow-on.

`P=0.35`, `U=0.5`, `M=0.20`, `I=4`, weighted impact `0.140`. Confidence `4`.

### Q3 — When do the mutation-score thresholds become normative gates?

**Resolution.** Two-phase. SCN-9.1 lands `MUTATION_EVIDENCE.md` with the
proposed table (medium ≥ 70%, high ≥ 85%, critical ≥ 90% + zero
survivors in domain core) marked **advisory**. SCN-9.5 produces the
first baseline mutation report on `astaire/` claims/projection core
under both Cosmic Ray (gate evidence) and mutmut (inner loop). SCN-9.7
board review ratifies the final thresholds — either as proposed, or
revised based on the SCN-9.5 data — and they become normative at the
sign-off commit. Until SCN-9.7 dates the row in `signoffs.md`,
`validate_governance.sh` MUST NOT fail-close on a missing mutation
report; it MAY warn.

**Rationale.** Locking thresholds before data exists invites either
over-strict gates that produce mass waivers (which destroy the gate's
signal) or under-strict gates that ratify the existing test posture
without improving it. The advisory-then-ratified pattern matches how
Phase 8.2 handled Power of 10 (proposed in evaluation memo → adopted
in board session → enforced in CI). Same playbook here.

`P=0.25`, `U=0.5`, `M=0.15`, `I=3`, weighted impact `0.056`. Confidence `4`.

### Q4 — What is the layout, invocation, and authority boundary of the Claude adapter skills?

**Resolution.** Skills live at `adapters/providers/claude/skills/<skill-name>/SKILL.md`
following the upstream Claude Code skill format (so they can be loaded
on-demand by the agent runtime). Each skill MUST:

1. State its core-policy source-of-truth path in the first paragraph
   (e.g. `tdd/SKILL.md` opens with "Implements
   `core/AI_ASSISTED_TDR_METHODOLOGY.md` §TDR-RGM at the Claude
   runtime").
2. Define no normative rules. Phrasing is "the policy requires X; this
   skill helps you do X with pytest/Cosmic Ray/etc."
3. Be invoked either on-demand by the agent's natural-language
   reasoning (skill discovery via the standard mechanism) or by
   project-level slash commands declared under
   `adapters/providers/claude/commands/`. Hooks (under
   `adapters/providers/claude/hooks/`) MAY be used for automatic
   post-edit verification (e.g. running `mutmut` after writing a test)
   but MUST NOT replace the validator chain in `scripts/validate_governance.sh`.

The Codex adapter (out of Phase 9 scope) re-implements the same
policies under `adapters/providers/codex/` in its own idiom — no policy
is duplicated; both adapters reference the same `core/` documents.

**Rationale.** Co-locating the skill files with the Claude adapter
folder preserves the cleanest portability story: deleting
`adapters/providers/claude/` removes Claude support without removing
any governance. The skill-format reuse means existing Claude-Code-native
tooling (skill discovery, on-demand loading) works without modification.
The source-of-truth pointer rule prevents skills from drifting into
shadow policy.

`P=0.30`, `U=0.5`, `M=0.15`, `I=3`, weighted impact `0.068`. Confidence `4`.

### Q5 — Are the new manifest schema fields required or optional at v1?

**Resolution.** **Optional at v1; required by risk tier.** All three new
blocks (`analyzers.mutation`, `analyzers.domainGlossary`,
`analyzers.architectureFitness`) are JSON-Schema `optional`. The
`validation/CONSISTENCY_RULES.md` rules §17–§19 enforce
required-presence as a function of the consumer's declared risk tier
(medium and above: mutation; high and above: glossary +
architecture-fitness). Existing consumer manifests at tier `low` (or
unspecified) MUST continue to validate without modification.

A consumer-facing migration note under `templates/MIGRATION_PHASE_9.md`
explains the tier-vs-presence relationship and provides copy-paste
templates for each block. Downstream-adoption closure (analogous to
R-8.2-02 for the analyzer-capability block) is tracked as a Phase 9
follow-up risk.

**Rationale.** Hard-required schema fields would break every existing
consumer manifest at the schema-validation step and create a flag-day
migration. Tier-gated presence rules match the autonomous-delivery
risk-tier model already in `core/AUTONOMOUS_DELIVERY_GOVERNANCE.md` —
the higher the trust delegation, the stricter the evidence floor. This
also mirrors the SCN-8.3.4 `legacyString`/`structured` discipline.

`P=0.30`, `U=0.5`, `M=0.20`, `I=4`, weighted impact `0.120`. Confidence `4`.

## Ambiguity Gate

| Question | P | U | M | I | P·U·M·I | Confidence |
|---|---:|---:|---:|---:|---:|---:|
| Q1 Bounded contexts for ADG glossary | 0.40 | 0.5 | 0.20 | 5 | 0.200 | 4 |
| Q2 Hexagonal refactor scope on `astaire/` | 0.35 | 0.5 | 0.20 | 4 | 0.140 | 4 |
| Q3 Mutation-threshold ratification cadence | 0.25 | 0.5 | 0.15 | 3 | 0.056 | 4 |
| Q4 Claude adapter skill layout + authority | 0.30 | 0.5 | 0.15 | 3 | 0.068 | 4 |
| Q5 Manifest schema additions required vs optional | 0.30 | 0.5 | 0.20 | 4 | 0.120 | 4 |
| **Totals** | | | | **19** | **0.584** | |

- Weighted impact total: `0.584`
- Sum of `I`: `19`
- **Ambiguity score: `0.584 / 19 = 0.0307`** ≤ `0.20` ✅
- **Average confidence: `(4 + 4 + 4 + 4 + 4) / 5 = 4.0`** ≥ `4.0` ✅

Gate passed. Phase 9 cleared to proceed past bootstrap.

## Linked artifacts (produced under SCN-9.0)

- Chunk plan: `docs/planning/chunks/phase-9-chunks.md`
- Risks: `docs/planning/phase-9-risks.md`
- TO-DO: `docs/planning/phase-9-todo.md`
- Architecture plan reference (read-only authority for SCN-9.1 drafts):
  `/Users/cms/.claude/plans/as-senior-architect-for-cosmic-kite.md`
