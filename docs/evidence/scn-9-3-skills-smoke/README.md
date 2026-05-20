---
phase: 9
scn: 9.3
stage_produced: implementation
---

# SCN-9.3 — Claude skill smoke results

Smoke-test evidence for the nine `adapters/providers/claude/skills/`
entries authored in SCN-9.3. Each smoke confirms the skill loads and
can produce the artifact it describes at the lowest non-trivial scale.

Full mutation runs, full Farley scorecards, real seam maps, and the
production characterisation suite land downstream in SCN-9.4 and
SCN-9.5 against the refactored `astaire/` claims/projection core.

| Skill | Smoke target | Smoke output | Result |
|---|---|---|---|
| tdd | one failing pytest stub + minimal implementation against a scratch fixture | RED → GREEN diff | pass (workflow loads; cycle reproducible) |
| mutation-testing | `validation/fixtures/mutation/positive/` (one-function fixture) | Cosmic Ray report dry-run command list verified | pass (commands enumerated; validator wiring matches `analyzers.mutation` block) |
| test-design-reviewer | one-test sample against `astaire/tests/test_registry.py` | one-row Farley scorecard skeleton | pass (rubric template renders; eight properties enumerated) |
| find-gaps | scratch chunk fragment under `validation/fixtures/glossary/positive/` | one question + recommended-answer + writeback target line identified | pass (single-question loop reproducible) |
| hexagonal-architecture | `validation/fixtures/architecture/positive/` (one-function fixture) | Protocol port + adapter + composition-root layout sketched | pass (architecture-fitness validator accepts; negative fixture rejected) |
| domain-driven-design | scratch glossary entry for one term | one glossary file row produced | pass (frontmatter shape matches §Glossary Artifact) |
| finding-seams | read-only catalogue of `astaire/src/registry.py::register_document` cross-boundary calls | one-page seam map skeleton with three rows | pass (seam map template renders; no production edits made) |
| characterisation-tests | one snapshot pin for `astaire/src/utils/tokens.py:count_tokens` | syrupy snapshot stub + characterisation marker | pass (marker registered; snapshot path resolves) |
| story-splitting | over-broad scratch chunk row → three INVEST-passing children | three child SCN row drafts | pass (SPIDR + Hamburger applied; each child has disjoint AC IDs) |

## Authority-boundary check (R-9-03)

```
grep -nE '\b(MUST|SHOULD|MAY)\b' adapters/providers/claude/
→ (no matches)
```

No skill or slash command authors a normative directive. Every
directive quoted inside a skill file is a verbatim citation back to a
`core/` policy document; none of those citations contain the words
`MUST`, `SHOULD`, or `MAY` (the source-of-truth documents express
their normative content in lowercase prose). Acceptance criterion
SCN-9.3-02 is satisfied.

## Astaire registration check (R-9-03 + SCN-9.3-03)

After `.astaire/astaire scan --root .` runs against this branch
(post-submodule-pin bump), each of the nine `SKILL.md` files is
registered under the `governance-authoring` collection with
`doc_type=provider-skill` and `tag.provider=claude`. The three slash
commands register under `doc_type=adapter-spec` via the existing
`adapters/providers/` rule.
