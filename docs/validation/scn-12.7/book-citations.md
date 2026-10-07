# SCN-12.7-03 — Companion-guide citation cross-check (2026-10-07)

Read-only check of the guide's evidence registers against this repository.
No book files were modified.

## Published references

| Reference | Status |
|---|---|
| `https://github.com/cms-pm/ai-dev-governance` (Ch 1, copyright page, landing page) | HTTP 200, public |
| Described as a public, reusable framework | LICENSE is MIT (GitHub detects `MIT`) |
| v1.2.0 cited as a doctrine-only release | Tag present; matrix row and GitHub Release present |
| Pinned releases + compatibility matrix | Every tag ≥ v1.0.0 has a matrix row and a GitHub Release |

## Line-range citations

`core/EVIDENCE_CONTRACT.md` and `core/GATE_DESIGN.md` are unchanged since
`8ab5331` (v1.2.3), so SS-GV-03 (154-177) and SS-GV-06 (54-83) still resolve.

The `CHANGELOG.md` citations shifted because the `[1.3.0]` and `[1.2.2]`
entries were added above them. The content of each range is unchanged.

| Row | Cited (v1.2.3) | On `main` from v1.3.0 | Shift |
|---|---|---|---|
| SS-OL-06 | 23-26 | 70-73 | +47 |
| SS-GV-11 | 28-35 | 75-82 | +47 |
| SS-GV-13 | 37-46 | 84-93 | +47 |
| SS-GV-09 | 99-110 | 155-166 | +56 |
| SS-GV-12 | 138-147 | 194-203 | +56 |

Recommendation: cite tag-pinned permalinks
(`https://github.com/cms-pm/ai-dev-governance/blob/v1.2.3/CHANGELOG.md#L28-L35`).
These never move, so the register needs no further updates as the
CHANGELOG grows.

Rows citing `mcp/CHANGELOG.md` (SS-OL-01/03/04) refer to a different
repository and are out of scope here.
