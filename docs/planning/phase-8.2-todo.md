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

- [x] Insert §Power of 10 Discipline (Universal) between §Mandatory
      Design Invariants and §Naming Rules — SCN-8.2.2-01
- [x] Footnote in §Component Size Limits documenting P10 ~60-line
      ancestor — SCN-8.2.2-01
- [x] Extend §Forbidden Patterns Without Human Exception (recursion,
      unbounded loops, dynamic allocation post-init, unchecked
      returns) — SCN-8.2.2-01 (rule 8 preprocessor clause added
      alongside the four)
- [x] Extend §Required Validation Evidence (analyzer floor +
      manifest-declared analyzer) — SCN-8.2.2-01
- [x] Add row to §Required Pre-Implementation Checklist
      (Return-value and parameter validation) — SCN-8.2.2-01
- [x] Cross-link to CockpitVM Embedded Style at section end —
      SCN-8.2.2-01 (cross-link lives in §Power of 10 Discipline
      preamble + closing paragraph; pointer/preprocessor/allocator
      elaborations routed to the embedded style)
- [x] Verify `grep -niE "nasa|jpl|goddard"` returns 0 — SCN-8.2.2-01
- [x] Verify `grep -n "Power of 10"` returns ≥ 1 hit per universal
      rule — SCN-8.2.2-01 (rules 1, 2, 3, 5, 7, 8, 10 all present;
      rule 4 cited in §Component Size Limits footnote)
- [x] Verify `grep -n "25 LOC"` still shows the existing cap —
      SCN-8.2.2-01 (line 203)
- [x] `scripts/validate_governance.sh` exits 0 — SCN-8.2.2-01
- [x] Re-run `.astaire/astaire scan --root .` — SCN-8.2.2-01
      (drift surfaced; resolved with `sync`; lint returns 0/0)

## CockpitVM Embedded Style — SCN-8.2.3 (high, board review)

- [x] Create `adapters/profiles/CockpitVM_Embedded_Style.md` with all
      eleven section groups — SCN-8.2.3-01 (preamble + lineage line;
      ABI boundary; allowed C++ features; forbidden C++ features;
      determinism requirements with cross-links to core §Power of 10
      rules 1/2/3/7; required type-safety patterns under
      `cockpit::core::`; pointer-use rule §; verification checklist;
      tooling integration with analyzer capability floor; header /
      implementation organization; Sources footer with Holzmann 2006
      BibTeX entry only)
- [x] Pointer rule (P10 #9) lives here, not in core — SCN-8.2.3-01
      (verified: `grep -nE "rule 9|Power of 10 #9|pointer-use rule"
      core/CODE_IMPLEMENTATION_COMPLEXITY_GOVERNANCE.md` returns 0)
- [x] `grep -niE "nasa|jpl|goddard"` returns 0 — SCN-8.2.3-01
- [x] `grep -n "raw/"` returns 0 — SCN-8.2.3-01
- [x] `scripts/validate_governance.sh` exits 0 — SCN-8.2.3-01 (all
      17 checks PASS)
- [x] Re-run `.astaire/astaire scan --root .` — SCN-8.2.3-01 (lint
      0/0; new file NOT auto-registered — `adapters/profiles/` is
      absent from the `governance_authoring` collection plugin's
      path-to-type table; see follow-up below, same shape as the
      SCN-8.2.1 evaluations gap)

## Embedded profile wiring + validation gate — SCN-8.2.4

- [x] Extend `adapters/profiles/EMBEDDED_PROFILE.md` to cite CockpitVM
      Embedded Style as required when manifest declares embedded
      profile — SCN-8.2.4-01 (Required Style + Fail-Closed Release Gate
      sections; manifest key `evidence.embeddedVerificationChecklistPath`
      named in §Fail-Closed Release Gate)
- [x] Add `validation/` consistency rule enforcing the gate —
      SCN-8.2.4-02 (`CONSISTENCY_RULES.md` Contract Rules §14;
      `scripts/validate_governance.sh` carries a Python block iterating
      example + prototype + mvp + production manifests and rejects
      embedded-profile manifests missing the key OR non-embedded
      manifests carrying the key)
- [x] Add CI agency-string guard for `core/` and `adapters/profiles/` —
      SCN-8.2.4-03 (`scripts/check_agency_strings.sh` invoked from
      `validate_governance.sh`; Contract Rules §15 declares the gate;
      rg `-i nasa|jpl|goddard` over both paths)
- [x] Fixture suite covers embedded + non-embedded manifest paths —
      SCN-8.2.4-02 (production + mvp + example carry the key with stub
      checklist files; prototype + consumer-astaire stay non-embedded
      and untouched; new `validation/fixtures/embedded-missing-evidence/`
      proves the negative path — shape verified by a dedicated bash
      block in the validator)
- [x] `scripts/validate_governance.sh` exits 0 — SCN-8.2.4-01..03 (all
      checks PASS including the new gate, the negative-fixture proof,
      and the agency-string guard)

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

## Cross-phase coordination + grandfathering — SCN-8.2.6 (high, board review, board-authored)

Board-authored under OPP-8.2-001 from the SCN-8.2.2 review packet Q4.
MUST land before SCN-8.2.5 sign-off.

- [x] Extend `core/CODE_IMPLEMENTATION_COMPLEXITY_GOVERNANCE.md`
      §Grandfathering with new §Cross-Phase In-Flight Coordination
      sub-clause anchored to SHA `5d47359`; name Phase 8.1 cohort
      `chunk-8.1.0-*`..`chunk-8.1.3-*` illustratively — SCN-8.2.6-01
- [x] Add `R-8.2-05` row to `docs/planning/phase-8.2-risks.md` Open
      Risks; add "Cross-Phase Risk References" appendix — SCN-8.2.6-02
- [x] Create
      `docs/planning/board/committee-opportunity-register-phase-8-2-2026-05-17.md`
      with OPP-8.2-001 recording board origin — SCN-8.2.6-03
- [x] Append SCN-8.2.6 rows to `docs/planning/traceability.md` and
      tick this section in `docs/planning/phase-8.2-todo.md` —
      SCN-8.2.6-04
- [x] `grep -n "5d47359" core/CODE_IMPLEMENTATION_COMPLEXITY_GOVERNANCE.md`
      returns ≥ 1 hit — SCN-8.2.6-01 (3 hits: lines 217, 221, 224)
- [x] `grep -n "Cross-Phase In-Flight Coordination" core/CODE_IMPLEMENTATION_COMPLEXITY_GOVERNANCE.md`
      returns exactly 1 hit — SCN-8.2.6-01 (line 215)
- [x] `grep -nE "chunk-8\.1\.[0-3]" core/CODE_IMPLEMENTATION_COMPLEXITY_GOVERNANCE.md`
      returns ≥ 1 hit — SCN-8.2.6-01 (line 226)
- [x] `grep -n "R-8.2-05" docs/planning/phase-8.2-risks.md` returns
      ≥ 1 hit — SCN-8.2.6-02 (open-risks row + appendix row +
      rollback note)
- [x] `grep -n "Cross-Phase Risk References" docs/planning/phase-8.2-risks.md`
      returns exactly 1 hit (the appendix heading) plus 1 cross-
      reference in the SCN-8.2.6 rollback note — SCN-8.2.6-02
- [x] `grep -niE "nasa|jpl|goddard"` against the modified files
      returns 0 — SCN-8.2.6-01..04 (only matches are inside grep-
      command strings within existing acceptance criteria, not
      agency references)
- [x] `scripts/validate_governance.sh` exits 0 — SCN-8.2.6-01..04
      (all 17 checks PASS)
- [x] `.astaire/astaire scan --root . && .astaire/astaire sync &&
      .astaire/astaire lint` returns 0/0 — SCN-8.2.6-01..04
      (opportunity register registered as board-packet; 0 warnings,
      0 errors after sync)

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
- Upstream Astaire enhancement: add `adapters/profiles/` to the
  `governance_authoring` collection plugin's path-to-type table
  (suggested type: `adapter-profile`). The existing
  `EMBEDDED_PROFILE.md` and `STRICT_BASELINE.md` are already on disk
  but unregistered; the new `CockpitVM_Embedded_Style.md` inherits the
  same gap. Discovered during SCN-8.2.3; current workaround is
  file-system discoverability only.
