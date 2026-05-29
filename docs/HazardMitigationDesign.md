# Hazard mitigation: architecture

How `lib/Dialect/Wave/Transforms/WaveAMDHazardWaits.cpp` models and
inserts AMDGPU hazard-mitigation NOPs, why it's shaped the way it is,
and what the comparable upstream and aster designs look like.

## Where the pass sits

The pass runs late in the WaveAMD lowering pipeline, after ABI
lowering, ticket-wait insertion, and register allocation. Ticket
waits must run first because this pass reacts to emitted
`s_waitcnt`s. Register allocation must also run first because its
preparation step can insert `v_mov_b32_tuple`, a VALU op that itself
needs the LGKM-wait mitigation if it becomes the first VALU after an
`s_waitcnt`.

The pass walks every `waveamdmachine` op in a flattened pre-order,
including ops nested inside structured regions (`uniform_loop` body),
and emits mitigation instructions (`s_nop`, `s_delay_alu`) before the
consumers of each modeled hazard.

Three hazards are modeled today:

| Hazard | Producer | Consumer | Gap |
|---|---|---|---|
| VALU after LGKM-clearing wait | `s_waitcnt` with non-default lgkm | any `VALUOp`-trait op | 1 cycle (`s_delay_alu` on gfx11+, `s_nop 0` elsewhere) |
| M0 read after `s_mov_m0` | `s_mov_m0` | any op with a `!m0`-typed operand | 1 instruction |
| VMEM store after MFMA | any `MFMAOp`-trait op | any `VMEMStoreOp`-trait op consuming the MFMA result | 8 instructions |

## Two hazard shapes

The catalog splits hazards into two execution categories because they
behave differently at the SSA level.

**`SsaEdge` (M0, MFMA-store)** -- the producer's *result* feeds a
specific consumer's operand. The mitigation question is "for this
operand, was it produced by this hazard, and how many counted
instructions separate them?". Answered by `findProducer`: backward
def-use walk from the consumer, looking for a producer match.

**`LinearState` (VALU-after-LGKM)** -- the producer is a side-effect
op; every later consumer in program order is affected until the state
clears. No SSA edge connects producer and consumer. Answered by a
pending-counter loop: producer arms the counter, every counted op
decrements (or in this case, the consumer just consumes the flag).

Trying to model linear-state hazards as SSA edges would require
inventing synthetic dependency tokens that every VALU op takes as
input, inflating the IR. Trying to model SSA-edge hazards through a
forward dataflow gives "you need N waits here" but loses the
(producer, consumer) edge that downstream scheduling needs. Keep them
separate.

## The catalog

`HazardKind` is a plain struct with `mitigate` and `update` closures
plus a `category` enum, a `persistInReplay` flag for the loop replay,
and a name for diagnostics. `buildHazardCatalog(const HazardConfig &)`
emits one entry per hazard kind. The driver iterates the catalog at
each op:

```
for (Operation *op : ops) {
  for each kind: state[i] = kind.mitigate(*op, state[i], ...);
  for each kind: state[i] = kind.update(*op, state[i], ...);
}
```

`LinearState` kinds use `state[i]` as a pending counter; `SsaEdge`
kinds ignore it (they query backward on every op).

Constants for the gaps live in `HazardConfig` (`m0PipelineDelay = 1`,
`mfmaResultLatency = 8`) with comments citing upstream
`GCNHazardRecognizer.cpp`. `valuDep1` is the `s_delay_alu` encoding
for "wait one VALU cycle", computed once at pass start.

## Trait-based classification

No denylists of opcodes. Tablegen-declared traits drive every
classification decision:

- `NoMachineInst` -- op produces no hardware instruction (pseudo
  ops: `arg`, `imm`, `token`, `s_waitcnt*`, `s_workgroup_id_*`,
  `v_workitem_id_x`, `tuple_*`, `wait`, `token_join`). Used by gap
  counting to skip ops that don't consume a wait state.
- `VALUOp`, `VMEMLoadOp`, `VMEMStoreOp`, `SMEMLoadOp`,
  `WaitcntOp`, `TokenOp`, `TokenJoinOp` -- pre-existing functional
  classifiers used both here and in other passes.
- `MFMAOp` -- the MFMA producer set for the VMEM-store hazard.

Adding a new MFMA variant requires only tagging it with `MFMAOp`; the
hazard pass sees it automatically.

## Backward SSA walk

`findProducer(value, anchor, isProducer)` resolves an SSA-edge
hazard query. Three paths:

1. **Same-block def.** Walk forward from `value.getDefiningOp()` to
   the consumer counting `NoMachineInst`-free ops. Precise.

2. **`BranchOpInterface` predecessors.** For block arguments whose
   block has cf-style predecessors, iterate each predecessor's
   terminator, find the forwarded operand at the matching block-arg
   index, and check if its defining op (in the predecessor's block)
   is a producer. Gap = producer-to-terminator + terminator + entry
   of consumer's block to anchor. Min across predecessors that raise
   the hazard; predecessors that carry a non-producer contribute no
   edge.

3. **`RegionBranchOpInterface` carries.** For block arguments of a
   region-entry block (`uniform_loop` body): the parent op's
   `getEntrySuccessorOperands` gives the loop init; each
   `RegionBranchTerminatorOpInterface` in the region (e.g.
   `continue_if`) that branches back contributes a back-edge source.
   For op results of a region-branch op: terminators whose successor
   is `parent()` (the exit path) contribute the source.

The walk is mutually recursive between `findProducerThroughDef` (op
result of a region-branch op recurses through exit terminators) and
`findProducerThroughBlockArg` (block arg recurses through
BranchOpInterface predecessors and region-branch sources). A
`DenseSet<Value>` visited set keys recursion termination, so a
pass-through carry (where `continue_if` forwards the block argument
unchanged) does not loop.

Multi-hop CFG paths and unknown terminators return `nullopt`; the
consumer gets no mitigation, matching the pre-refactor linear-walk
behavior for those patterns. The flat-walk policy is honest about
what it can't analyse rather than guessing.

The query is **idempotent under the loop replay**: previously
inserted `s_nop`s sit in the IR between producer and consumer and
themselves count as machine instructions, so a second walk sees the
gap saturated and emits nothing.

## Loop replay

`LinearState` kinds with `persistInReplay = true` (today: only
VALU-after-LGKM) get a second walk seeded with their final state
when the function contains a `uniform_loop`. This handles the case
where the loop tail leaves the lgkm flag set and the body's head VALU
needs a mitigation that the first walk (starting at `pending=0`)
missed.

`SsaEdge` kinds set `persistInReplay = false`; their replay seed is
0. The replay walk still re-runs their `mitigate` closure, but it
fires no extra NOPs thanks to the idempotence above.

## Why not a dataflow analysis

Aster uses MLIR's `DenseForwardDataFlowAnalysis` with a lattice
element tracking active hazards. That's a clean way to handle CFG
correctness for free.

We chose the backward query because:

- It produces a **per-edge** result -- the actual `(producer,
  consumer, currentGap, requiredGap)` quadruple. Forward dataflow
  produces a per-program-point result and loses the producer
  attribution.
- A future code-motion pass needs the per-edge data: "this consumer
  reads the MFMA result with gap 3, required gap is 8 -- can we
  move the consumer 5 ops later to absorb the hazard for free?"
  Forward dataflow can't answer that.
- For three hazards, the cost of re-querying per op is negligible
  (no cache needed; revisit if a real hot kernel disagrees).

## Cross-references

- Upstream LLVM: `llvm/lib/Target/AMDGPU/GCNHazardRecognizer.{h,cpp}`
  uses per-instruction-class `check*()` methods with hard-coded
  latency locals and a `getWaitStatesSince()` template for backward
  walks with state memoization. No central catalog.
  `AMDGPUWaitSGPRHazards.{h,cpp}` is a separate post-schedule pass
  for gfx12 SGPR RAW hazards using per-block dataflow.
- Aster: `aster/lib/Dialect/AMDGCN/...` declares ~30 hazard kinds as
  tablegen attributes, builds an opcode-indexed dense map at pass
  start, and runs a forward dataflow over the lattice of active
  hazards.

Wave's approach borrows the **first-class catalog** idea from aster
and the **trait-based classification** idea from upstream LLVM, but
diverges by using a per-consumer backward query (LLVM-style) over an
explicit catalog (aster-style) with separate handling for state-like
hazards.

## Deferred work

**Hazard-aware code motion.** The `SsaEdge` backward query already
yields the `(producer, consumer, currentGap, requiredGap)`
quadruple. A new pass would consume it to sink or hoist unrelated
ops into the gap, falling back to `s_nop` only when no profitable
motion exists. The current pass would become the fallback layer.
Worth picking up once NOP density on real kernels becomes a
measurable cost.

**Tablegen-described catalog.** Aster's full formalism (hazards as
parameterized attributes with subcase tables) only pays off once we
ship ~10+ hazard kinds with multiple subcases each. Three single-case
hazards in C++ closures is fine for now.

**Multi-hop CFG and structured-region traversal.** `findProducer`
handles one `BranchOpInterface` hop and one level of region-branch
traversal. Deeper CFG paths or chains of region-branch ops return
`nullopt` -- conservative, matching the pre-refactor flat-walk
behavior. The shape of an extension is clear (recurse, increase the
visited-set granularity, add cycle detection on Operation* rather
than just Value) but no test case currently demands it.

**State-like hazards across the loop back-edge.** The loop replay is
a one-shot heuristic, not a true dataflow fixpoint. If a future
LinearState hazard has more subtle back-edge semantics than the
current VALU-after-LGKM, the replay will need to grow into a
per-block IN/OUT dataflow. Until then, the heuristic + idempotent
SSA-edge replay covers everything we ship.

## File layout

- `lib/Dialect/Wave/Transforms/WaveAMDHazardWaits.cpp` -- the pass.
- `include/mlir/Dialect/WaveAMDMachine/IR/WaveAMDMachineOps.td` --
  trait declarations (`WaveAMDMachine_NoMachineInst`,
  `WaveAMDMachine_MFMA`) and per-op tagging.
- `include/mlir/Dialect/WaveAMDMachine/IR/WaveAMDMachineTraits.h` --
  C++ trait class templates.
- `test/Target/Wave/waveamdmachine-hazard-waits.mlir` -- lit tests
  covering: same-block VALU-LGKM (gfx11 + gfx10); same-block M0;
  saturation; pseudo-op interleave; chained `s_mov_m0`; cross-block
  via `cf.cond_br` / `cf.br`; loop-replay idempotence; MFMA carried
  through a `uniform_loop` back-edge and consumed inside the body;
  same MFMA consumed after the loop via the exit-to-parent carry;
  pass-through carry with external producer; pass-through carry
  with no producer.
