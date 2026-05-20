---
description: Run the find-gaps skill against the named planning artifact, one question at a time, writing each confirmed answer back into the source artifact.
argument-hint: <artifact path — chunk plan, AC set, or mock-state spec>
---

Load the `find-gaps` skill. The skill's source of truth is
`core/PLANNING_METHODOLOGY.md` §Pool Question Sub-Protocol — Find-Gaps
Loop.

Target artifact: `$ARGUMENTS`.

Steps:

1. Read the target via Astaire (`.astaire/astaire query` or
   `.astaire/astaire context`).
2. Ask one focused question; propose a recommended answer; wait for
   confirmation or correction.
3. Write the confirmed answer back into the target artifact as a new
   AC row, risk row, mock-state entry, or a recommendation to load
   `story-splitting`.
4. Run `.astaire/astaire scan --root .` and
   `.astaire/astaire lint`.
5. Loop until the gate score satisfies the threshold quoted from the
   source-of-truth document.

Stop after each question for human confirmation.
