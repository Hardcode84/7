# AMDGPU greedy gap-fill scheduler design

## Goal

Maintain `waveamd-machine-schedule` as a greedy gap-fill scheduler backed by
the instruction execution-state model.

Scheduling policy:

- Walk each straight-line `wave.amd.machine` region in original order.
- Issue the original next instruction when it can issue without a modeled
  stall.
- If the original next instruction would stall, move a legal ready instruction
  into the gap when that candidate can issue without stalling.
- Repeat until the original next instruction no longer stalls or no filler is
  available.
- If no filler is available, keep the original next instruction and let the
  wait/hazard passes repair the gap.

Reuse boundary: the scheduler owns dependence construction and the legal ready
frontier. Candidate ranking, instruction timing, stalls, resources, and
register-pressure policy come from the Wave schedule model.

## File Boundary

Mutating scheduler and report pass live in:

```
lib/Dialect/Wave/Transforms/WaveAMDMachineGreedySchedule.cpp
```

The pass surface can stay `waveamd-machine-schedule` so pipelines do not churn.
Default no-op behavior should stay: without `apply-schedule`, the pass validates
target support and returns.

Option compatibility:

- Keep `apply-schedule`.
- Do not cap the mutating pass by region size; every collected supported region
  is scheduled.
- Keep `max-region-ops` only on the non-mutating report pass to bound diagnostic
  work.
- No-op mode still validates target support.

## Reuse

Allowed reuse:

- `InstructionExecutionState` for issue preview, commit, and score timing.
- `ArchData`, `SchedClass`, `classifyOp`, `getLatency`, `funit`, memory counter
  and value latency helpers.
- `waveamdmachine.target` parsing and arch validation helpers.
- WaveAMDMachine traits and op interfaces.
- WaveMachine SSA singleton values for SCC/VCC/M0 ordering.

## Region Model

The new scheduler owns region collection. At this pipeline point, the body is
expected to be structured machine IR. EXEC control is represented by region ops
such as `exec_if`, not by separate flat-region policy.

Region collection is a positive support check. A local-region member must be a
WaveAMDMachine op with no nested regions, no terminator trait, a cost-model
mapping, and one of:

- scheduler-supported no-instruction pseudos;
- scheduler-supported SALU ops;
- scheduler-supported modeled instruction classes.

Everything else is a hard pass failure. Do not maintain a separate negative
list.

A scheduling region is the maximal run of non-terminator ops in one block,
split only by ops with nested regions. Terminators end blocks; they cannot be
middle-of-region separators.

Nested `uniform_loop`, `uniform_if`, and `exec_if` bodies are scanned as nested
blocks. Region ops themselves are not part of an outer region.

Barriers are not region separators. Scheduling across barriers is intentional.
A barrier only constrains motion through the explicit SSA/token/resource edges
it participates in; do not infer an extra scheduling fence from the opcode.
Empty-token barriers are movable and must not encode phase intent at this
stage. If ordering matters, encode it with explicit tokens.

Memory ordering stays explicit:

- SSA def-use edges are dependencies.
- `!waveamdmachine.mem.token` def-use edges are memory-order dependencies.
- No implicit memory alias/order edges.
- Memory ops without token edges are reorderable by this scheduler.

Memory stalls are modeled separately from ordering. A token edge makes the
consumer ready only after the producer is scheduled; the token's ready cycle
models when the memory effect has completed enough for a wait/barrier/token
consumer. A memory op whose token is immediately consumed by a wait/barrier is
a modeled stall, and an independent ready op may fill that gap.

Singleton resources are explicit SSA values in WaveMachine IR:

- SCC, VCC, and M0 producers/consumers are schedulable.
- A singleton live range is the SSA value's def-use range: the op producing the
  SCC/VCC/M0 value through its last use.
- The scheduler verifies the input has no overlapping live SSA ranges for the
  same singleton before scheduling a region.
- Dead singleton results still count as writes for writer-before-next-writer
  edges.
- Motion is legal while it preserves those singleton live ranges. An op that
  reads or writes SCC/VCC/M0 must not cross another live SSA range for the same
  singleton.
- The graph should derive the minimum edges from the explicit SSA values:
  producer-to-consumer, reader-before-next-writer, writer-before-next-writer.
  Do not treat every singleton-related op as a hard boundary.

Do not use dominance alone. Use a ready frontier from the dependency graph.

Loop-carried values are not ready-frontier predecessors. Body block arguments
are live-ins for that nested region; values carried by a loop terminator are
live-outs. Record recurrence edges for diagnostics and scoring, but exclude
them from `pending` counts so a loop body cannot deadlock its own schedule.

## Greedy State

The scheduler needs an incremental preview state. It should mirror the
simulator closely enough to answer one question: "would this op stall if issued
now?"

State:

```
readyAt[value]          // cycle when SSA value can be consumed
memoryReadyAt[token]    // cycle when token consumer can proceed
waitCounterReady[kind]  // coarse VMEM/LGKM/export/store wait readiness
fuReady[fu]             // next available FU issue cycle
issueReady              // next wave issue cycle
cuIssueCounts[cycle]    // CU issue cap use
cmaIssueCounts[cycle]   // CMA issue cap use
memoryIssueReady[kind]  // resource-specific memory issue queues
valueHazards[value]     // cheap SSA-visible hazards
```

Preview result:

```
IssuePreview {
  operandWaitCycles
  memoryWaitCycles
  fuWaitCycles
  issueWaitCycles
  cuIssueWaitCycles
  cmaIssueWaitCycles
  hazardWaitInsts
  issueCycle
  readyCycle
  nextIssueCycle
}
```

The simulator remains authoritative for final selection. Preview is a greedy
decision aid, not the final cost model.

Preview covers architectural stalls and memory stalls:

- operand value not ready, including fixed producer latency such as MFMA result
  latency;
- functional-unit, issue, CU, CMA, and memory issue resource availability;
- memory token/wait readiness, including immediate wait/barrier token
  consumers.

## Algorithm

Per region:

```
pending = dependency predecessor counts
ready = nodes with pending == 0
scheduled = empty bitset
state = empty issue state

while scheduled.size != region.size:
  if ready is empty:
    fail dependency-cycle diagnostic

  next = first unscheduled node in original order

  if next is ready:
    nextPreview = preview(state, next)
    if !stalls(nextPreview):
      schedule(next, nextPreview)
      continue

    filler = first zero-stall ready real-machine-inst op by original order
             that is not next
    if filler exists:
      schedule(filler, preview(state, filler))
      continue

    schedule(next, nextPreview)
    continue

  schedule(first ready node by original order)
```

After `schedule(node)`:

- append node to the output order;
- commit result ready cycles;
- commit memory/token ready cycles;
- commit FU/issue/CU/CMA and memory issue resource state for real machine
  instructions;
- advance cheap hazard state for real machine instructions;
- seed new cheap hazards from producer ops;
- remove node from `ready`;
- decrement successor predecessor counts;
- append newly ready successors.

The original next op is retried after each filler. Multi-slot gaps are filled
one real instruction at a time.

## Stall Predicate

An op stalls if any preview component requires waiting beyond the current issue
point:

```
stalls =
  operandWaitCycles != 0 ||
  memoryWaitCycles != 0 ||
  fuWaitCycles != 0 ||
  issueWaitCycles != 0 ||
  cuIssueWaitCycles != 0 ||
  cmaIssueWaitCycles != 0 ||
  hazardWaitInsts != 0
```

Initial filler rule: accept only zero-stall real machine instructions. No-inst
ops may be scheduled in original order, but they do not satisfy instruction-gap
hazards. A pseudo between `s_mov_m0` and an M0 consumer must not count as the
M0 pipeline gap.

Partial fillers are not part of this scheduler. A filler either issues with
zero modeled stall or it is not a filler.

No-machine-inst ops have no FU/CU/CMA/LDS issue use, do not advance
`issueReady`, and do not decrement cheap hazard counters. Forwarding pseudos
propagate operand `readyAt`, `memoryReadyAt`, and cheap hazards to their
results.

## Cheap Hazards

Model cheap hazards in preview/commit state. Do not encode them as artificial
dependencies unless the ordering is already a real SSA/resource dependency.

Initial hazards:

| Hazard | Producer | Consumer | Gap |
|---|---|---|---|
| M0 write pipeline gap | `M0WriteHazardOpInterface` | `!waveamdmachine.m0` operand | 1 real instruction |

M0 is the first must-have case. `s_mov_m0` and `s_add_m0_i32` already expose
`M0WriteHazardOpInterface`. `waveamd-insert-hazard-waits` already tracks
`m0PipelineDelay = 1`; the scheduler should try to fill that slot before the
hazard-wait pass emits `s_nop`.

State:

```
struct ValueHazards {
  unsigned m0 = 0;
};
DenseMap<Value, ValueHazards> hazards;
```

Transfer:

- Real machine instruction decrements active counters by one.
- No-machine-inst op does not decrement counters.
- No-machine-inst forwarding op conservatively propagates operand hazards to
  results.
- `M0WriteHazardOpInterface` seeds `m0 = 1`.

Consumer check:

```
wait = 0
for operand in op.operands:
  if operand is !waveamdmachine.m0:
    wait = max(wait, hazards[operand].m0)
```

Example:

```
s_mov_m0
global_load_lds ..., m0   // one real instruction needed before this
```

If a ready independent instruction exists, move it between the producer and
consumer. If not, keep the order and let the hazard-wait pass insert
mitigation.

## Hazards Out of Scope

Not this scheduler's job:

- Physical-register overlap hazards.
- WMMA/MFMA coexecution hazards needing allocated register spans.
- SETREG/GETREG hazards not represented structurally in Wave machine IR.
- VMEM-to-scalar-write hazards requiring physical register details.
- LGKM-to-VALU after inserted waitcnt. Waitcnt ops do not exist at this
  scheduler stage.
- Cache, bank, and alias effects.

These may still affect final ISA. They are not cheap pre-RA legality facts.

## Apply Rule

The mutating pass builds one greedy gap-fill order per region. If the order
differs from original, it applies the order. Event-simulator scoring is
available in the report pass; it is not a mutating-pass gate.

## Diagnostics

Keep diagnostics simple and scheduler-local:

```
waveamd-machine-schedule region func=foo index=3 ops=42
  action=apply reason=greedy filled_gaps=8 unfilled_gaps=2
  operand_gaps=3 resource_gaps=4 cheap_hazard_gaps=1
  m0_gaps=1 memory_token_gaps=1 barrier_memory_gaps=0
```

Verbose move trace:

```
gap-fill stalled=17 filler=23 reason=m0 wait=1
gap-fill stalled=41 filler=44 reason=cma_issue wait=2
gap-fill stalled=62 unfilled reason=operand wait=37
```

Do not attach move diagnostics to IR.

Summary actions:

- `apply`: greedy order used.
- `keep`: original order used because greedy is the same.
- `fail`: pass failure.

Summary reasons:

- `same_order`
- `greedy`
- `m0_hazard`
- `barrier_memory`
- `dependency_cycle`
- `missing_target`
- `malformed_target`
- `unsupported_arch`
- `unsupported_op`
- `unsupported_option`

`waveamd-machine-schedule-report` prints original/greedy candidate orders,
scores, stats, and the selected order. Rejected-filler traces are not part of
the current report contract.

Cheap hazard constants live in one helper shared by this scheduler and
`waveamd-insert-hazard-waits`.

## Prior Art

This is list scheduling with an original-order bias and an incremental
issue/readiness preview state.

LLVM `MachineScheduler` uses ready/pending queues, target schedule models, and
hazard/resource checks.

AMDGPU coexec scheduling, layered on `GCNSchedStrategy`, adds an
effective-stall candidate comparison:

```
effective = max(ready stall, structural stall, latency stall)
```

Coexec is useful prior art, but not enough to copy directly. Borrow current
cycle stall comparison and hardware-unit occupancy ideas; do not import gfx1250
flavor tables, top-down-only policy, or WMMA physical-overlap details. Normal
pre-RA coexec scheduling does not get the full `GCNHazardRecognizer` path;
AMDGPU still relies on waitcnt and post-RA hazard passes for many target
hazards. Wave can model the cheap M0 case earlier because the IR carries a
typed `!waveamdmachine.m0` value and producer interface.

GCC Haifa/DFA scheduling is the older version of the same split: legality graph
plus target resource automaton. Keep that separation.

## Validation Plan

Focused lit tests:

- M0 producer followed immediately by consumer, independent real op available:
  filler moves into the gap.
- Same shape with only no-inst pseudos available: no pseudo gap fill.
- No-machine-inst forwarding op propagates `readyAt`, `memoryReadyAt`, and M0
  hazard state without decrementing instruction-gap hazards.
- `s_add_m0_i32` has same M0 behavior as `s_mov_m0`.
- No legal filler: order stays, hazard waits still emit mitigation.
- Filler blocked by mem-token edge: no move.
- Filler blocked by SSA edge: no move.
- Memory op followed immediately by wait/barrier token consumer: independent
  ready op fills the memory-token stall.
- SCC/VCC/M0-related filler whose singleton range stays intact: move allowed.
- SCC/VCC/M0-related filler that would cross another same-resource live range:
  no move.
- Barrier between two independent ops: scheduling across the barrier is allowed.
- Empty-token barrier is movable and does not encode phase ordering.
- Barrier with explicit token dependency: token edge still blocks illegal move.
- Memory-value stall: independent ready op fills the latency gap.
- MFMA result latency is modeled as operand readiness, not as a cheap hazard.
- Pipe/resource stall: independent ready op fills the issue gap.
- Greedy order simulates worse than original: keep original.
- Missing/malformed target and bad model options still diagnose.
- Op outside the scheduler-supported list is a hard pass failure.
- Dependency graph cycle is a hard pass failure.
- Loop-carried scalar and mem-token values do not enter ready predecessor
  counts.
- Old policy options diagnose as unsupported.
- Summary diagnostics cover `apply`, `keep`, and `fail` reasons.

Integration checks:

- Run narrow scheduler lit tests.
- Run scheduler through ticket-wait, regalloc, and hazard-wait pipeline on the
  small M0 and memory-stall cases.
- Run PerfGolden helpers before updating checked-in ASM. Drift is locally
  actionable only when the helper prints `ASM DRIFT DETECTED` and writes the
  generated ASM file.
- Refresh with `python build_tools/regenerate_perf_goldens.py --build-dir build`.
  Acceptance requires the script's post-refresh
  `build/bin/llvm-lit -sv build/test --filter=PerfGolden` run to pass.
  `--skip-lit` is staging only.
- gfx950 helpers use `--skip-hw`; they validate deterministic gfx950 codegen and
  checked-in ASM text, not hardware performance.
- If gfx950 hardware is available, measure old and new ASM on the same machine
  before calling drift a perf win or no-regression.
- If gfx950 hardware is unavailable, checked-in ASM may still be refreshed with
  this review note:
  `gfx950 HW perf not run: local hardware cannot execute gfx950 kernels;
  accepted as compile-only PerfGolden ASM drift.`
  Do not claim runtime perf status until a gfx950 run exists.

## gfx950 ASM Drift Review

Use subagents for gfx950 PerfGolden drift when local gfx950 hardware is
unavailable. Run at least two independent reviews before accepting refreshed
ASM:

- Scheduler-legality review: every changed hunk must trace to a changed region
  with scheduler diagnostics: action, reason, order/stats, and report-mode
  scores when available.
- ASM-invariant review: inspect regenerated `.s`, not just diff size.

Expected drift:

- local reordering around modeled stalls;
- waitcnt counter relaxation/tightening tied to moved memory operations;
- M0 `s_nop` removal when filled by a real instruction;
- physical register renumbering without resource metadata changes.

Red flags:

- changed CFG, memory offsets, MFMA opcode or `op_sel`, store set, target
  metadata, ABI/resource declarations, or kernel shape;
- explicit SSA/token/singleton violation;
- new or removed barrier without a producer/consumer explanation;
- new hot-loop `vmcnt(0)` right before a barrier or consumer;
- missing wait before a value/token consumer;
- no-inst pseudo counted as a hazard filler;
- new `s_delay_alu`, `s_setprio`, long nop run, or nop crossing a
  wait/barrier/MFMA boundary without scheduler justification;
- new spill/scratch use;
- scheduler diagnostics show `keep` / `same_order` for the changed region.

gfx950 pattern checks:

- `buffer_load_* ... lds` producers stay ordered before `ds_read*` and MFMA
  consumers by matching `s_waitcnt` and `s_barrier`.
- Plain `buffer_load_*` to VGPR followed by `ds_write*` has a covering `vmcnt`
  wait before the LDS write.
- MXFP4 scale reads such as `ds_read_b64_tr_b8` are covered by `lgkmcnt` before
  `v_mfma_scale_*`.
- Nonzero `vmcnt`/`lgkmcnt` waits are acceptable only when remaining
  outstanding operations are unrelated to the next LDS/MFMA consumer.
- Compare `.amdhsa_next_free_vgpr`, `.amdhsa_next_free_sgpr`,
  `.amdhsa_accum_offset`, group/private segment sizes,
  `enable_private_segment`, `reserve_vcc`, and denorm modes. Scheduler-only
  drift should not silently change them.
- Rerun after refresh produces no further ASM diff.

## Failure Modes

- **Local greedy hurts global schedule.** Report-mode score and hardware review
  must catch it; the mutating pass does not score-gate apply.
- **Hazard drift.** Share constants with hazard insertion.
- **No-inst false fill.** Only real machine instructions decrement cheap
  hazard counters.
- **Memory surprise.** Explicit token edges only; test this.
- **IR outside scheduler support.** Hard error. Do not silently keep or split.
- **Dependency cycle.** Hard error with graph edge kind in diagnostics.
- **Compile-time growth.** Search current ready set first; add original-distance
  cap only if needed.

## Maintenance

- Keep scheduler policy and instruction timing separate.
- Add a focused lit case for every new stall kind or dependency edge.
- Run PerfGolden diagnostics and gfx950 drift review before changing broad
  scheduling policy.
