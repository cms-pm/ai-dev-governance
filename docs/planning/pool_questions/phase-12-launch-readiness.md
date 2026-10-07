---
phase: 12
stage_produced: plan
---

# Phase 12 Pool — Launch Readiness

## Goal

Make ADG and its Astaire tentacle launch-ready for the public early release
of *AI-Assisted Embedded Development*, which cites
`https://github.com/cms-pm/ai-dev-governance` as a public framework, and
recover governance work that was stranded on a single workstation.

## Scope

- ADG: license, community files, release/record hygiene, issue triage,
  README positioning, Phase 11 fix salvage, patch release.
- Astaire: test-card collection forward-port, missing GitHub Releases.
- Rescue of ADG/Astaire commits that existed only inside a consumer's
  nested submodules or on local branches.

Out of scope: renaming ADG (follow-on), consumer housekeeping, Phase 11
consumer-enforcement scope, book manuscript edits.

## Resolved Questions

Q1–Q6 were resolved by the accountable human (cms-pm) on 2026-10-07.
Q7–Q8 are agent-proposed and are confirmed or overturned at sign-off.

### Q1 — Licence

`LICENSE` read "Internal Use Only… proprietary and confidential" on a
public repo. **Resolution: MIT**, applied to all prior tags. Sole human
author verified via `git shortlog -sne --all` (AI-agent commits carry no
copyright). Astaire stays Apache-2.0.

### Q2 — Phase 11 (`SCN-11.0`, unmerged; EXC-0002 expired 2026-08-09)

**Resolution: salvage fixes only.** Cherry-pick R-11-08 (`06b1558`), fix
R-11-09, keep the v1.2.1 evidence bundle (`a074761`). Branch preserved as
`archive/SCN-11.0`; its divergent `chore(release): ADG v1.2.2` commit is
not merged. Phase 11 is deferred, not cancelled.

### Q3 — Consumer scope

**Resolution: rescue only.** No housekeeping in the consumer. Only
ADG/Astaire commits stranded inside it are pushed to the governing repos.
Consumer index, branches and stashes are not touched.

### Q4 — Stranded Astaire test-card commits (`53acf88`, `e1da012`, `813551c`)

**Resolution: preserve and forward-port.** Originals pushed unchanged to
`cms-pm/astaire@archive/test-card-2026-05` (hashes preserved); a new PR
ports them onto v0.6.2 and ships as Astaire v0.6.3.

### Q5 — Unpushed Astaire `dev` (agent-sessions plugin)

**Resolution: archive only** (`archive/dev-agent-sessions-2026-04`);
evaluation tracked as a post-launch issue.

### Q6 — Rename

**Resolution: deferred** to a separate follow-on after this phase.

### Q7 — Release number (agent-proposed)

**Proposal: v1.2.4.** The archived Phase 11 plan reserves `v1.3.0` for its
consumer-branch work; ADG's v1.2.x line already carries additive changes
as patches (v1.2.1 `harnessMetrics`).

### Q8 — Vendor-named GitHub topic (agent-proposed)

**Proposal:** drop `claude-code` from the suggested topic set. The book's
R-TOOL-AGNOSTIC rule positions ADG as tool-agnostic; provider adapters
remain documented as adapters.

## Gate Score & Confidence

Scored against the declared `strict-baseline` gate (≤ `0.10` / ≥ `4.5`),
per R-11-04's disposition that new phases do not inherit the looser gate.

- **Ambiguity score:** `0.0500` ≤ `0.10` (gate-PASS). 0/8 unresolved; a
  `0.05` penalty for the two agent-proposed resolutions (Q7, Q8) pending
  human confirmation.
- **Confidence:** `4.5` ≥ `4.5` (gate-PASS, at threshold). Low technical
  novelty; the main uncertainty is Q4's forward-port onto a collection
  module that moved from v0.4.x to v0.6.2.
