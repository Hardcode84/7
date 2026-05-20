# Hazard mitigation: design proposal

Where the WaveAMD hazard pass is today, what reference implementations
do, and where we should take it.

## Current state

`lib/Dialect/Wave/Transforms/WaveAMDHazardWaits.cpp` mitigates three
hazards by flat-walking every waveamdmachine op in pre-order and
maintaining one pending-counter per hazard:

| Hazard | Producer | Consumer | Gap |
|---|---|---|---|
| VALU after LGKM-clearing wait | `s_waitcnt` with non-default lgkm | any VALU op | 1 cycle (`s_delay_alu` or `s_nop 0`) |
| M0 read after `s_mov_m0` | `s_mov_m0` | any op consuming `!m0` | 1 instruction |
| VMEM store after MFMA | any MFMA variant | any VMEM store | 8 instructions |

The walk is augmented by a one-shot loop replay: if the function
contains a `uniform_loop` and the walk ended with `pendingLgkmWait`
set, the entire walk runs a second time with `pendingLgkmWait` seeded
to true.

Pain points (each filed as a bead):

- `countsAsInstruction` is a denylist of "this op emits nothing" that
  has grown in three consecutive commits. Next no-emit op silently
  shortens every gap.
- `isMFMA` hardcodes two MFMA variants; gfx950 has more.
- The `1` and `8` are magic constants with no source citation.
- Loop replay re-fires the M0 and MFMA-store mitigations on the
  second walk, emitting duplicate NOPs when the relevant hazards
  exist inside a loop body.
- The flat-walk-with-counter has no concept of CFG. Cross-block
  hazards (producer in one block, consumer after a join) get
  miscounted. Works today only because the selector emits each
  hazard producer immediately before its consumer.

## How upstream LLVM does it

`llvm/lib/Target/AMDGPU/GCNHazardRecognizer.{h,cpp}`:

- Each hazard family has its own `int check*(MachineInstr *)` method.
  No central table; adding a hazard means adding a method.
- Hazards are classified by trait-style predicates (`isVALU`,
  `isVMEM`, `isMetaInstruction`), not by opcode denylists.
- Cross-block visibility via `getWaitStatesSince(IsHazardFn,
  IsExpiredFn)`: backward walk through predecessors with state
  memoization on a `StateMap` to avoid exponential paths.
- Latency constants live local to each `check*` method as named
  `const int` locals (e.g. `const int VmemSgprWaitStates = 5`).
  Arch variation is gated by `MCSubtargetInfo` feature checks, not
  by per-constant tables. Duplication is accepted as the cost of
  clarity.
- A separate dataflow pass (`AMDGPUWaitSGPRHazards.{h,cpp}`) handles
  gfx12 SGPR RAW hazards with per-block `In`/`Out` state and a
  meet operator; that pass is post-schedule and orthogonal to the
  scheduler-integrated recognizer.

Lesson: **trait-based classification + per-hazard methods + local
constants**. Scales to dozens of hazard kinds without a centralized
table that everyone has to edit.

## How aster does it

`aster/lib/Dialect/AMDGCN/...`:

- Each hazard is a first-class tablegen attribute carrying a static
  `kRequiredInstCounts` table. ~30 hazard kinds declared this way.
- `HazardManager` builds an opcode -> applicable-hazards dense map
  once at pass start, parameterized by ISA.
- A `DenseForwardDataFlowAnalysis` (`HazardAnalysis`) carries the
  set of active hazards with remaining wait counts as the lattice
  element. Merges at CFG joins (`mergeActiveHazards` does an
  elementwise min on counts). Loops handled by the solver's
  fixpoint iteration.
- The transform pass is a thin client: walk every op, query
  solver state, insert `S_NOP` / `V_NOP` batches.

Lesson: **hazards as first-class objects + dataflow analysis**.
Cross-block correctness is free; loops handled by fixpoint; adding
a hazard is one TableGen entry.

## Proposed design for wave

The shape: **hazard table (aster-style) + per-edge backward query
(novel) + linear pending-counter fallback for state-like hazards
(matching today's correct path)**. Dataflow analysis is *not* in the
design; the backward walk subsumes it for SSA-edge hazards, and
state-like hazards stay on a linear counter where they already work.

### Two hazard shapes

Wave's hazards split into two categories that want different
machinery.

**SSA-edge hazards.** Producer's *value* feeds a specific
consumer's operand. The hazard fires on that producer-consumer pair
specifically.

- M0 read after `s_mov_m0`: producer's `!m0` result is consumed by
  the DMA op's `m0` operand.
- VMEM store after MFMA: producer's VGPR is consumed by the store's
  data operand.

**Linear-state hazards.** A side-effect at the producer affects
*every* subsequent consumer until cleared. No SSA edge connects them.

- VALU after LGKM-clearing wait: `s_waitcnt` mutates a global flag;
  any later VALU op is affected. No data dependency.

Trying to model linear-state hazards as SSA edges requires inventing
synthetic dependency tokens that every VALU op takes as input, which
inflates the IR for no real gain. Conversely, modeling SSA-edge
hazards through a forward dataflow gives "you need N waits here" but
loses the (producer, consumer) edge that downstream scheduling
needs. Keep them separate.

### Hazard table

```cpp
struct HazardKind {
  StringRef name;
  HazardCategory category;        // SsaEdge | LinearState
  unsigned requiredGap;

  // SsaEdge:
  bool (*isProducer)(Operation &);
  // Returns operand indices on the consumer that bind this hazard.
  SmallVector<unsigned> (*consumerOperands)(Operation &);

  // LinearState:
  bool (*isStateProducer)(Operation &);
  bool (*isStateConsumer)(Operation &);
};
```

Built once per pass invocation, parameterized by `MCSubtargetInfo`.
Subtarget feature gates decide which kinds populate the table.
Constants in `requiredGap` carry an inline comment citing
`GCNHazardRecognizer.cpp` where applicable.

The 13 currently-denylisted "no machine instruction" ops become
tablegen-tagged with a `NoMachineInst` trait; the same trait drives
distance counting in the backward walk.

### Backward query for SSA-edge hazards

For each op in program order, for each `HazardKind` with category
`SsaEdge`:

1. Get the operand indices the kind cares about via
   `consumerOperands(op)`.
2. For each such operand, walk backward from `value.getDefiningOp()`,
   counting machine instructions seen (skipping `NoMachineInst`
   ops). Visited set keyed on `(Value, HazardKind*)` to terminate
   in loops.
3. If the walk reaches an op for which `isProducer` is true, record
   `(producer, currentGap)`.
4. If `currentGap < requiredGap`, insert
   `requiredGap - currentGap` NOPs before the consumer.

Cache the per-edge result. Once computed, distance from a value to
any downstream consumer can extend the prior cache entry
incrementally.

When the backward walk hits a block argument, recurse into
predecessors via `BranchOpInterface` / region branch interfaces.
Combine results across predecessor paths by taking the minimum gap.
That's a localized, on-demand dataflow only for edges that actually
cross a block boundary; most edges don't.

### Linear-state hazards stay linear

The current pending-counter loop in `processOnce` becomes a method
on the `HazardKind` instances with `category == LinearState`. Same
semantics as today: producer arms the counter, every counted op
decrements it, consumer that arrives while the counter is non-zero
gets a mitigation inserted.

The double-emit loop-replay bug (`hazard-loop-replay-double-emit-8qj`)
disappears: the linear state is now per-kind, and the replay path
can save and restore the state of each linear kind around the
second walk without re-firing the SSA-edge kinds (which aren't
walked linearly any more).

### Why this enables a future scheduling pass

The backward-query cache contains, for every SSA-edge hazard
binding, the exact `(producer, consumer, currentGap, requiredGap)`
quadruple. A code-motion pass can consume the same cache to:

- Move the producer down or the consumer up within their block
  (respecting other data dependencies and verifier shape) until
  `currentGap >= requiredGap`.
- Sink unrelated ops between the producer and consumer to fill the
  gap with useful work instead of NOPs.

NOP insertion becomes the fallback for gaps the scheduler cannot
close. The forward-dataflow shape can't do this because it doesn't
preserve which producer caused which wait at which consumer.

## Staging

**Stage 1 (one PR, maybe a long afternoon).** Pure refactor; no
behavior change.

- Add `NoMachineInst` and `MFMAOp` tablegen traits; tag the 13
  no-emit ops and the 2 MFMA ops respectively.
- Move `m0PipelineDelay` / `mfmaResultLatency` into `HazardConfig`
  with cited constants.
- Introduce the `HazardKind` table. Existing M0, MFMA-store, and
  VALU-after-LGKM logic moves into table entries but keeps the
  current linear-counter execution model for all three. This closes
  beads `hazard-trait-noemit-by4`, `hazard-trait-mfma-bkj`,
  `hazard-magic-constants-lq7`, `hazard-id-ops-denylist-7u6`. It
  does NOT close the loop-replay double-emit or CFG-awareness beads.

**Stage 2 (one PR).** Behavior change: SSA-edge hazards move to
backward query with caching.

- Implement the backward-walk + cache for `SsaEdge`-category kinds.
- M0 and MFMA-store kinds switch to `SsaEdge`.
- VALU-after-LGKM stays on the linear-state path.
- Loop replay is removed; linear-state hazards are managed inside
  the loop replay differently if needed (per-kind saved state).
- Closes `hazard-loop-replay-double-emit-8qj`.
- Adds the cross-block test cases that motivate
  `hazard-cfg-awareness-qc2`; closes that bead if the backward walk
  through block arguments handles them. If it doesn't, the bead
  stays open for follow-up.

**Stage 3 (later, only if the cycles matter).** Scheduling.

- New pass consumes the backward-query cache.
- Code motion to absorb gaps before falling back to NOP emission.
- This is where the design pays back the refactor cost.

**Skip.** Tablegen attributes for hazards (aster's level of
formalism). Three hazards is too few to justify it; revisit at
~10 hazard kinds.

## Open questions

- **Block-argument backward walk: how aggressive?** When the walk
  crosses a block boundary, it has to enumerate predecessors. For
  a loop back-edge, the predecessor includes the loop body itself.
  Does the visited set cut this cleanly, or do we need a path-count
  bound? Probably the visited set is enough; verify with a
  loop+M0 test.
- **Cache invalidation strategy.** Once Stage 3 starts moving ops
  around, cached distances become stale. Invalidate per region
  (per block?) on every IR mutation, or recompute lazily on the
  next query. Both fine; pick on implementation.
- **Where does the table live?** Probably a static factory function
  per ISA in `WaveAMDHazardWaits.cpp`: `buildHazardCatalog(const
  MCSubtargetInfo &)`. Could be lifted to a `.td`-described table
  later; not needed now.
- **What about `s_delay_alu` vs `s_nop`?** The VALU-after-LGKM kind
  emits `s_delay_alu` on gfx11+, `s_nop 0` elsewhere. The hazard
  table needs an emission policy per kind, not a fixed `s_nop`.
  Easy to thread through.
- **Will the SsaEdge model survive new hazards?** Need to check the
  next ~3 hazards we expect to add (`hazard-id-ops-denylist-7u6`
  hints at workgroup-id-related ones; gfx12 SGPR RAW hazards may
  arrive eventually) and confirm they fit one of the two categories
  cleanly. If gfx12 SGPR RAW needs a third shape, we add a third
  category; the table is designed for that.

## Beads this proposal addresses

| Bead | Stage that closes it |
|---|---|
| `hazard-trait-noemit-by4` | 1 |
| `hazard-trait-mfma-bkj` | 1 |
| `hazard-magic-constants-lq7` | 1 |
| `hazard-id-ops-denylist-7u6` | 1 |
| `hazard-loop-replay-double-emit-8qj` | 2 |
| `hazard-cfg-awareness-qc2` | 2 (backward walk crosses blocks via predecessors) |
| `hazard-m0-test-gaps-fts` | 2 (add the tests as part of the SsaEdge migration) |
| `dma-inst-offset-dedup-x0m` | unrelated; stays open |
