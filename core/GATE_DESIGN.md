# Gate Design

## Purpose

This core policy defines how acceptance gates and oracles MUST be designed
so that a strict, un-gameable verification protocol (immutable oracle, frozen
kernel, author != grader, no threshold-shopping) produces verdicts that are
trustworthy without being needlessly brittle. It complements
`core/MUTATION_EVIDENCE.md` (test-suite effectiveness) and
`core/ACCEPTANCE_INTEGRITY.md` (specification-evasion resistance) by
addressing a third failure class: a gate that is honest and adversarially
sound can still be **mis-designed statistically**, producing a verdict that
does not track the claim it exists to certify.

Keywords MUST, SHOULD, and MAY are normative.

## Scope

This policy governs the design of acceptance gates and oracles at
authoring time, before freeze. It does not license loosening a frozen
gate after work has started: frozen gates stay frozen, recorded FAIL
verdicts stand, and nothing here retroactively re-grades a closed
verdict. See `core/AUTONOMOUS_DELIVERY_GOVERNANCE.md` for the
boundary-invariant rule against reopening closed chunks.

## Failure Modes This Policy Designs Against

1. **Ratio-statistic floor saturation.** A ratio check of the form
   `after / before <= threshold` implicitly assumes `before` sits far from
   the metric's irreducible floor. When a run starts close to the floor,
   the ratio can fail to move even though the underlying mechanism holds
   with margin, penalizing a good starting point rather than measuring
   the claim.
2. **Absolute tolerances tighter than measurement noise.** A tolerance set
   without reference to the reproduction's own seed variance or fidelity
   offset tests the toolchain's noise floor, not the claim.
3. **Conjunctive collapse.** A verdict computed as `PASS = AND(all checks)`
   lets the single weakest, least load-bearing check overrule every
   passing mechanism check in the headline result.
4. **Trajectory statistics standing in for capability.** A statistic that
   measures how fast or how far a run moved (a ratio, a delta, a percent
   change) co-varies with the starting point and can silently substitute
   for the actual capability claim, which is usually a separation or an
   endpoint comparison.
5. **Threshold cliffs with no margin reporting.** A boolean pass/fail
   erases the difference between a narrow miss and a wide miss, at
   exactly the point where the gate's own honesty contract forbids the
   author from re-running toward the line.

## Rules

Every acceptance gate or oracle authored under this policy MUST:

1. **Tier checks and support a first-class PARTIAL verdict.** Each check
   within a gate MUST be tagged `load_bearing` (certifies the mechanism or
   claim under test) or `refinement` (a secondary or cosmetic check). The
   gate's verdict vocabulary MUST include `PASS` / `PARTIAL` (all
   load-bearing checks pass; at least one refinement check does not) /
   `FAIL`, pre-registered before freeze — not invented after the fact once
   a real run produces an inconvenient boolean.
2. **State the floor assumption for every ratio check.** For each check
   expressed as a ratio or relative-change statistic, the design record
   MUST state the assumed distance from the metric's floor, and MUST
   supply a floor-aware form (e.g. `(after - floor) / (before - floor)`,
   with `floor` estimated from a pre-registered probe) or a separation
   form (comparing against the contrast class the check exists to
   distinguish) whenever floor saturation cannot be ruled out at design
   time.
3. **Set tolerances against measured noise, not convenience.** Before
   freeze, the author MUST run a cheap prototype, record the seed-to-seed
   variance and any expected fidelity offset, and place each threshold at
   least `2 sigma` from both the expected-pass and expected-fail
   populations. A threshold that sits inside the measured noise band MUST
   NOT be frozen as-is.
4. **Report margins, not just verdicts.** Gate output MUST include, per
   check: the observed statistic, the threshold, and the signed distance
   between them. A near-miss and a wide miss MUST be distinguishable from
   the gate's own output without re-running or re-deriving anything from
   raw artifacts.
5. **Dry-run before freezing.** Every gate MUST be exercised against at
   least one synthetic "clearly good" and one synthetic "clearly bad"
   artifact before its thresholds are frozen. If the "clearly good"
   artifact does not PASS with margin, the statistic — not the artifact
   under test — is the first suspect, and MUST be fixed before freeze.
6. **Keep post-freeze discipline asymmetric.** Once a gate's thresholds
   are frozen (the SHA recorded per `core/ACCEPTANCE_INTEGRITY.md`'s
   boundary-invariant discipline), they MUST NOT move in either
   direction. All judgment about statistic design is spent before freeze;
   none is available after.

## What This Policy Does Not License

- Re-grading a closed gate's recorded verdict under a revised statistic.
  Frozen verdicts stand; the correct move on discovering a mis-designed
  check is to log the divergence, keep the recorded verdict, and apply
  the lesson to the next gate authored under this policy.
- Loosening a frozen gate, including one later judged mis-designed.
- Treating `PARTIAL` as equivalent to `PASS` in any downstream consumer.
  A downstream gate or eligibility rule that consumes an upstream
  verdict MUST state explicitly which tier (`PASS`-only, or
  `PASS`-or-`PARTIAL`) it requires.

## Cross-References

- `core/ACCEPTANCE_INTEGRITY.md` — the boundary-invariant rule against
  reopening closed/frozen gates; the `PASS` / `WAIVED` / `FAIL` terminal
  states this policy's `PARTIAL` verdict composes with.
- `core/MUTATION_EVIDENCE.md` — test-suite effectiveness evidence; a
  parallel empirical-rigor policy for the test layer rather than the
  gate-design layer.
- `core/HARNESS_METRICS.md` — the metrics feedback system a gate's
  verdicts, margins, and PARTIAL outcomes feed into.
- `core/PLANNING_METHODOLOGY.md` — risk-tier declaration a gate's
  thresholds and required-margin discipline scale with.
