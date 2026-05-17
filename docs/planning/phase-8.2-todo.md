# Phase 8.2 — Running TO-DO

Source of truth for in-flight Phase 8.2 chunk state. Each SCN-8.2.* chunk
ticks rows down as it progresses. Status uses GitHub-flavored checkbox
syntax.

Linked artifacts: `docs/planning/chunks/phase-8.2-chunks.md`,
`docs/planning/pool_questions/phase-8.2-style-adoption.md`,
`docs/planning/phase-8.2-risks.md`.

## Bootstrap — SCN-8.2.0

- [x] Create `docs/planning/chunks/phase-8.2-chunks.md` — SCN-8.2.0-01
- [x] Create `docs/planning/pool_questions/phase-8.2-style-adoption.md` —
      SCN-8.2.0-02
- [x] Create `docs/planning/phase-8.2-risks.md` — SCN-8.2.0-03
- [x] Create `docs/planning/phase-8.2-todo.md` (this file) — SCN-8.2.0-04
- [x] Append SCN-8.2.* rows to `docs/planning/traceability.md`
- [x] Append Phase 8.2 sign-off row to `docs/planning/signoffs.md`
- [x] Run `.astaire/astaire scan --root .` — SCN-8.2.0-05 (4 docs registered)
- [x] Verify `.astaire/astaire context --tag phase=8 --budget 6000`
      returns full Phase 8.2 surface — SCN-8.2.0-05 (tag parses as int;
      sub-phase carried in title)
- [x] Verify `.astaire/astaire query -t chunk-plan --tag phase=8`
      lists the new chunk plan — SCN-8.2.0-05 (returns 6 chunk plans
      incl. "Phase 8.2 Chunks")
- [x] Verify `.astaire/astaire lint` returns 0/0 — SCN-8.2.0-05
      (after `sync` to refresh signoffs/traceability hashes)

## Evaluation memo — SCN-8.2.1

- [x] Author `docs/planning/evaluations/p10-and-cockpitvm-style-eval.md`
      with scope + ten-rule matrix + LOC-cap memo + YAML gap walk +
      recommendation + Sources footer — SCN-8.2.1-01
- [x] Confirm `grep -niE "nasa|jpl|goddard"` matches only inside Sources
      footer — SCN-8.2.1-01 (memo body neutralized; grep returns zero
      hits anywhere outside the Sources footer at §6; raw-filename and
      pattern-verbatim residuals scrubbed)
- [x] Re-run `.astaire/astaire scan --root .` and `lint` — SCN-8.2.1-01
      (lint 0/0; memo NOT auto-registered — see follow-up below)

## Complexity core amendment — SCN-8.2.2 (critical, board review)

- [ ] Insert §Power of 10 Discipline (Universal) between §Mandatory
      Design Invariants and §Naming Rules — SCN-8.2.2-01
- [ ] Footnote in §Component Size Limits documenting P10 ~60-line
      ancestor — SCN-8.2.2-01
- [ ] Extend §Forbidden Patterns Without Human Exception (recursion,
      unbounded loops, dynamic allocation post-init, unchecked
      returns) — SCN-8.2.2-01
- [ ] Extend §Required Validation Evidence (analyzer floor +
      manifest-declared analyzer) — SCN-8.2.2-01
- [ ] Add row to §Required Pre-Implementation Checklist
      (Return-value and parameter validation) — SCN-8.2.2-01
- [ ] Cross-link to CockpitVM Embedded Style at section end —
      SCN-8.2.2-01
- [ ] Verify `grep -niE "nasa|jpl|goddard"` returns 0 — SCN-8.2.2-01
- [ ] Verify `grep -n "Power of 10"` returns ≥ 1 hit per universal
      rule — SCN-8.2.2-01
- [ ] Verify `grep -n "25 LOC"` still shows the existing cap —
      SCN-8.2.2-01
- [ ] `scripts/validate_governance.sh` exits 0 — SCN-8.2.2-01
- [ ] Re-run `.astaire/astaire scan --root .` — SCN-8.2.2-01

## CockpitVM Embedded Style — SCN-8.2.3 (high, board review)

- [ ] Create `adapters/profiles/CockpitVM_Embedded_Style.md` with all
      eleven section groups — SCN-8.2.3-01
- [ ] Pointer rule (P10 #9) lives here, not in core — SCN-8.2.3-01
- [ ] `grep -niE "nasa|jpl|goddard"` returns 0 — SCN-8.2.3-01
- [ ] `grep -n "raw/"` returns 0 — SCN-8.2.3-01
- [ ] `scripts/validate_governance.sh` exits 0 — SCN-8.2.3-01
- [ ] Re-run `.astaire/astaire scan --root .` — SCN-8.2.3-01

## Embedded profile wiring + validation gate — SCN-8.2.4

- [ ] Extend `adapters/profiles/EMBEDDED_PROFILE.md` to cite CockpitVM
      Embedded Style as required when manifest declares embedded
      profile — SCN-8.2.4-01
- [ ] Add `validation/` consistency rule enforcing the gate —
      SCN-8.2.4-02
- [ ] Add CI agency-string guard for `core/` and `adapters/profiles/` —
      SCN-8.2.4-03
- [ ] Fixture suite covers embedded + non-embedded manifest paths —
      SCN-8.2.4-02
- [ ] `scripts/validate_governance.sh` exits 0 — SCN-8.2.4-01..03

## Board review + sign-off — SCN-8.2.5 (critical, board review)

- [ ] Produce committee review packet under `docs/planning/board/` —
      SCN-8.2.5-01
- [ ] Board review run per
      `core/BOARD_REVIEW_GOVERNANCE_METHODOLOGY.md` — SCN-8.2.5-01
- [ ] Sign-off recorded in `docs/planning/signoffs.md` with immutable
      trace — SCN-8.2.5-01
- [ ] `.astaire/astaire lint` returns 0/0 — SCN-8.2.5-01
- [ ] `.astaire/astaire context --tag phase=8.2 --budget 6000` returns
      closed bundle — SCN-8.2.5-01
- [ ] Update this TO-DO to mark phase closed — SCN-8.2.5-01

## Follow-ups (deferred past Phase 8.2)

- Static-analyzer capability auditing schema in governance manifest
  (Phase 8.3+; flagged by R-8.2-02).
- Wider language style coverage (Rust, Go, Python) — out of scope here.
- Upstream Astaire enhancement: support fractional `phase` tags (e.g.
  `phase=8.2`) so sub-phases are first-class. Discovered during
  SCN-8.2.0; current workaround is integer phase + sub-phase in title.
- Upstream Astaire enhancement: add `docs/planning/evaluations/` to the
  `ai_dev_governance` collection plugin's path-to-type table (suggested
  type: `evaluation`). Discovered during SCN-8.2.1; current workaround
  is file-system discoverability only.
