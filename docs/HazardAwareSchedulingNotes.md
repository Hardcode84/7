# Hazard-aware scheduling notes

Current `waveamd-insert-hazard-waits` dataflow is the correctness
baseline. It tracks LGKM pending state plus SSA-carried M0, MFMA, and
VALU-to-permlane hazards, then inserts mitigation after register allocation.

Scheduler integration should be optional scoring help, not the sole
correctness mechanism. If scheduling cannot prove a hazard is covered,
fallback is to keep the order. Hazard waits then run local repair passes
before final NOP insertion.

## Useful split

- Required SSA hazards are structural: producer, consumer value, hazard
  kind, required gap.
- Actual gap is schedule-dependent: candidate order, fixed region
  prefix/suffix, loop backedge, and inserted virtual mitigation all
  affect it.
- LGKM->VALU is not an SSA hazard. It is pending state from an
  `s_waitcnt` until first later VALU or inserted mitigation.

## Failed sketch

Single backward chain over `Operation *` is insufficient:

- Structured loop values have multiple dynamic sources: entry,
  backedge, and exit-to-parent.
- Loop-carried producers may be later in the static candidate order but
  earlier dynamically.
- Region successor mapping must use `getSuccessorInputs()`, not raw
  result or argument numbers.
- Candidate regions may start mid-block, so "no previous op" is not
  "far enough".
- Per-consumer stateless queries ignore virtual waits inserted for
  earlier operations in the same candidate.

Non-structured CFG is out of scope for scheduler integration. Query code
should report unsupported/fallback status, not try to recover through
`BranchOpInterface`.

## Revisit Shape

Build scheduler-facing pieces around candidate evaluation:

- `HazardProgramInfo`: immutable structural facts for a function.
- `HazardRegionInfo`: per-schedule-region requirements plus bounded
  incoming and loop-backedge history.
- `CandidateScheduleView`: index-based view over one candidate order.
- `HazardCandidateEvaluator`: walks a candidate once, updates mutable
  virtual hazard state, and returns mitigation events/cost.

The evaluator must model inserted mitigation as virtual instructions
because those instructions can satisfy later gaps.

## Test Shape

Before using this in scheduling, add focused tests for:

- MFMA carry consumed by first op in a loop body.
- MFMA loop result consumed immediately after the loop.
- Pass-through external MFMA consumed in the first body op.
- Structured if/merge result consumed after the parent op.
- Loop IV not inheriting iter-arg hazards.
- Zero-iteration and do/while-style loop result paths.
- Unsupported internal CFG block args fail closed.
