---
name: find-gaps
description: One-question-at-a-time adversarial interrogation of a written plan, chunk, or acceptance criteria set. Every confirmed answer is written back into the source artifact (AC, risk row, mock-state spec). Source of truth is core/PLANNING_METHODOLOGY.md §Find-Gaps Loop.
---

# find-gaps — Adversarial interrogation loop

**Source of truth:** `core/PLANNING_METHODOLOGY.md` §Pool Question
Sub-Protocol — Find-Gaps Loop. This skill is the runtime ergonomic
wrapper around that protocol; it adds no normative rules.

## When to load

- Tightening a chunk plan or pool-question set before any code lands.
- A reviewer asks "what AC is missing?" against an existing artifact.
- Sprint critique flagged unstated assumptions in an open SCN.

## Loop shape (one question at a time)

```
1. Read the target artifact (chunk plan / AC / mock-state spec)
   through Astaire (`.astaire/astaire query` or `context`).
2. Ask ONE focused question that, if answered, would change the
   artifact's text. Use the recommended-answer pattern: state the
   question, propose an answer, ask for confirmation or correction.
3. Wait for the human answer.
4. Write the confirmed answer back into the source artifact as:
   - a new acceptance row, OR
   - an updated risk row, OR
   - a new mock-state spec entry, OR
   - a "story is too broad" recommendation to load `story-splitting`.
5. Re-run `.astaire/astaire scan` and `.astaire/astaire lint`.
6. Repeat from step 1 until the gate score in `signoffs.md` is at or
   under the threshold quoted in `core/PLANNING_METHODOLOGY.md`
   §Pool Question Gates.
```

Quoted gate rule from `core/PLANNING_METHODOLOGY.md` §Pool Question
Gates —
> "Ambiguity score <= 0.20 and confidence >= 4.0 before any chunk plan
> is considered final."

## Question categories (drawn from the source-of-truth protocol)

- Missing state: which output, error, or edge has no AC?
- Unstated assumption: which precondition is implicit?
- Unverifiable AC: which AC has no observable evidence path?
- Horizontal slice: which SCN is component-shaped instead of
  vertical-slice-shaped (load `story-splitting` instead)?
- Rollback path: which SCN has no explicit revert plan?

## Writeback discipline

Every answer becomes durable text in the source artifact. Loose chat
context is not evidence — only the artifact change is. Confirm the
writeback with the human before proceeding to the next question.

## Smoke check

Run one find-gaps round against a stub chunk plan under
`validation/fixtures/glossary/positive/` (or a throwaway scratch
artifact). Show the diff: one new AC row in the chunk plan, one new
question + confirmed answer in the transcript. Attach to SCN-9.3
evidence bundle.

## Provenance

Structure adapted from
`raw/skills-entourage/skills/find-gaps/SKILL.md` (text-only original);
ADG version wires writeback into Astaire-registered artifacts and
delegates all normative authority to
`core/PLANNING_METHODOLOGY.md`.
