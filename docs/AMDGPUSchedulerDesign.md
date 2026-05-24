# AMDGPU instruction scheduler and cycle estimator on Wave/AMDMachine: design

Build a multi-wave-aware instruction scheduler + cycle estimator
that operates on `wave.amd.machine` IR, calibrated against live HW
via `rocprofv3` + ATT. Targets RDNA3, RDNA4, CDNA3, CDNA4 only;
older archs are out of scope. Patient zero is the local gfx1100
(RDNA3) machine.

Companion to `docs/AMDGPUStaticCycleEstimation.md` (the survey of
what data exists and where it lives). This doc says what we build
on top.

## Architecture

```
wave.amd.machine.func
        |
        v
+---------------------+    +-----------------------------+
| Per-op classifier   |--->| Per-arch data spine         |
| (op -> SchedClass)  |    | - latency table             |
+---------------------+    | - class -> FU resource map  |
        |                  | - hazard rules              |
        v                  | - structural params         |
+---------------------+    | (SchedModel + HW overrides) |
| Dense dataflow      |<---+-----------------------------+
| analysis            |
| (MachineState       |
|  lattice per        |
|  program point)     |
+---------------------+
        |
        +--> per-op pressure     (cost fn for scheduler)
        +--> total cycles        (autotune score)
        |
        v
+---------------------+
| Multi-wave issue    | (Stage 5: layered on top of the
| simulator           |  per-program-point lattice)
+---------------------+
        |
        +--> per-wave timeline   (ATT calibration target)

+---------------------+
| List scheduler pass |--+
| (cost = re-run      |  |--> wave.amd.machine.func (reordered)
|  dataflow on        |  |
|  candidate order)   |  |
+---------------------+--+
```

Three artifacts, built in order: **data spine** (static per-arch
parameters + per-FU resource map + HW-calibrated overrides),
**dataflow analysis** (per-program-point MachineState lattice),
**scheduler** (cost = pressure delta from re-running the analysis
on a candidate ordering). The dataflow output also feeds the
multi-wave simulator in Stage 5. Surfaced into the
transform-dialect pipeline as `wave.transform.estimate_cycles`
(total) and `wave.transform.pressure_report` (per-region detail);
the scheduler is `wave.transform.schedule`.

## Scope and non-goals

In scope:
- gfx1100 / gfx1101 / gfx1102 (RDNA3), gfx1200 / gfx1201 (RDNA4),
  gfx942 (CDNA3), gfx950 (CDNA4).
- Multi-wave aware: per-SIMD round-robin, per-wave waitcnt model,
  wave-priority biased arbitration, coresident-wave latency hiding.
- Operates on `wave.amd.machine` IR after wave-to-machine, before
  the existing waitcnt-insertion pass.
- Plugs into the transform-dialect pipeline as named ops the
  autotune system can call and score.

Non-goals:
- Cycle-exact silicon model. Ranking accuracy ~1.2-1.5x absolute
  is the bar; tighter is gravy.
- Pre-RDNA archs (GCN, gfx9 except CDNA variants).
- Cache simulation (L1/L2 latency numbers are not published; we
  use a flat WriteVMEM bucket per arch).
- Replacing LLVM's scheduler downstream. Ours fires earlier on
  machine IR; LLVM still owns post-isel scheduling.

## Design decisions

Four branches resolved up front:

1. **Cycle-by-cycle simulator, not an analytical IPC formula.**
   The analytical version is faster and good enough for autotune
   ranking but loses the per-wave timeline needed to compete with
   ATT ground truth. "Best estimator" means simulator.

2. **Hand-copy LLVM SchedModel data per arch initially; TableGen
   emitter later.** Four archs is ~200 lines of data; a TG-emitter
   pass is real work. Mechanise before adding the fifth arch. A
   pre-commit diff script keeps the hand-copy honest against
   upstream.

3. **ATT integration via `rocprofv3 --att`, not raw SQTT decode.**
   rocprofv3 is the ROCm-supported path with a stable output
   format. Raw SQTT is what AMD's internal tools use; undocumented
   and a moving target.

4. **Scheduler runs pre-waitcnt insertion.** Reorder first, let the
   existing waitcnt-insertion pass cover for newly-exposed
   latency. Waitcnt-aware reordering can in principle find better
   solutions but couples two passes hard. Revisit only if
   measurements show meaningful perf left on the table.

## Stage 1: per-arch data spine

**Goal.** Static per-arch tables and an op-to-SchedClass classifier.

**Deliverable.** New lib `lib/Dialect/WaveAMD/CostModel/`:
- `ArchData.{h,cpp}` -- per-arch struct: `wavesPerSIMD`,
  `simdsPerCU`, `vgprFileSize`, `vgprAllocGranule`,
  `valuPipelineDepth`, `wave64IssueMultiplier`,
  `issuesPerCUPerCycle`, `simdIssuePeriod` (1 for RDNA,
  4 for CDNA wave64).
- `SchedClass.h` -- enum mirroring the LLVM `SchedWrite` classes
  we care about: `Write32Bit`, `WriteFloatFMA`, `WriteDouble`,
  `WriteTrans32`, `Write{2,4,8,16}PassMAI`, `WriteXDL{2,4}PassWMMA`,
  `WriteVMEM`, `WriteSMEM`, `WriteLDS`, `WriteSALU`, `WriteBranch`,
  `WriteExport`, `WriteBarrier`, `WriteSFPU`.
- `OpClassifier.{h,cpp}` -- map every `wave.amd.machine.*` op to a
  SchedClass via op interfaces (`isVMEM()`, `isMFMA()`, ...) plus
  opcode-mnemonic switch fallback.
- `LatencyTable.cpp` -- per-arch `(SchedClass -> latencyCycles)`
  table. Numbers hand-copied from `SISchedule.td`'s
  `GFX11SpeedModel`, `GFX12SpeedModel`, `SIDPGFX942FullSpeedModel`,
  `SIDPGFX950FullSpeedModel`.
- `HazardRules.cpp` -- ported subset of `GCNHazardRecognizer`:
  MFMA RAW/WAR/WAW pipeline, DPP-to-VALU, VMEM-VGPR-RAW,
  lds-direct, vcmpx. Only what's needed for the four target archs.
- `DelayAluTable.cpp` -- `INSTID_VALU_DEP_{1..4}`,
  `TRANS32_DEP_{1..3}`, `SALU_CYCLE_{1..3}`, `FMA_ACCUM_CYCLE_1`
  numbers for GFX11/12.

**Hygiene.** `scripts/check-sched-tables.py` parses
`SISchedule.td` and diffs the numbers against our table. Wire to
`pre-commit`. Prevents silent drift.

**Risk.** Op classifier coverage. Mitigation: assert-fail on
unmapped opcodes during estimator runs in debug builds; collect
gaps from real kernels.

## Stage 2: dense-dataflow pressure analysis

**Goal.** Per-program-point machine-state lattice over the
wave.amd.machine func body. The Stage 8 scheduler reads pressure
from this lattice; the Stage 5 multi-wave simulator consumes it
as input; the autotune machinery still gets a scalar total when
it asks for one.

Single-wave scalar estimators have a fundamental problem on real
kernels: loops are visited once, branches sum instead of max, and
the output gives no actionable signal for what to reorder. Dense
dataflow over relative-cycles state, with cold/hot separation at
loop headers, avoids all three.

### Lattice: cold/hot tuple of relative-cycles state

Each lattice cell carries **two** `MachineState` components -- a
**cold** state (reflects pre-loop / non-backedge incoming control
flow) and a **hot** state (reflects backedge incoming, i.e. the
steady-state shape after the loop has settled). At non-loop
program points the two are equal after convergence. At loop
headers they split: cold = max over pre-loop predecessors, hot =
max over backedge predecessors.

Each `MachineState` is itself in **relative-cycles form**:

```cpp
struct MachineState {
  // Per-functional-unit "cycles until free" from this program
  // point. Bounded by max-latency over FU classes (a small
  // constant), so the lattice domain is finite and fixed-point
  // iteration terminates without ad-hoc widening.
  // FU set: VALU pipe, SALU pipe, VMEM, LGKM (SMEM+LDS),
  // MFMA/XDL pipe, TRANS pipe, branch pipe, export pipe.
  std::array<int, NumFU> fuPending;

  // Per-waitcnt-counter in-flight depth (loadcnt, dscnt, expcnt,
  // storecnt + GFX12 split variants). Also bounded.
  std::array<int, NumWaitCounters> inflight;

  // Per-Value "cycles until ready" map (live values only).
  DenseMap<Value, int> valPending;
};

struct PressureLattice {
  MachineState cold;
  MachineState hot;
};
```

Why relative cycles rather than absolute "cycle since function
entry": absolute counts grow unboundedly per loop iteration, so
no fixed point exists on the raw lattice -- you can't use a
classical dataflow solver without bolting on structural
loop-walking. Relative pendings are bounded above by max-latency,
so the lattice is finite and the MLIR dataflow solver iterates to
fixed point naturally. Total cycles (the autotune scalar) gets
accumulated separately during the walk, not inside the lattice.

### Transfer function

For each wave.amd.machine op `o`, apply identically to **both**
cold and hot components of the lattice:

```
fu = funit(arch, class(o))
W  = max(fuPending[fu],
         max-over-operand-pending,
         hazard-required-wait)
// time advances by W; decrement all pendings by W (clamp at 0).
fuPending  -= W   (saturating)
valPending -= W   (saturating; drop entries at 0)
inflight  unchanged (counter waits handled by s_waitcnt below)
// op issues:
fuPending[fu]            = 1            // FU occupied for 1 issue cycle
valPending[results(o)]   = latency(o)   // results ready after `latency`
inflight[counter(o)]    += 1 for memory ops
```

Per-op total-cycle contribution = `W + 1` (issue wait plus the
one cycle the FU is held). Accumulated in a side-channel
(per-block running sum + a per-fn total), not stored in the
lattice itself.

`s_waitcnt N` (the explicit wait pseudo) decrements the matching
counter to at most `N`, and advances time by however many cycles
are needed for the actual wait to drain.

### Joins at CFG edges

Joins are **edge-typed**:

- **Forward / non-backedge** (`pred` not in backedge set):
  `after.cold.meet(before.cold)` and `after.hot.meet(before.hot)`.
  Both components flow through normally; element-wise max on
  each.
- **Backedge** (`pred` is the source of an identified backedge to
  `block`): only `after.hot.meet(before.hot)`. Cold does **not**
  propagate around backedges -- the cold component represents
  "what arrives the first time we reach this point", which by
  definition excludes loop-carried contributions.

At non-loop program points, cold and hot converge to the same
value (both join from the same set of incoming edges). At loop
headers, they stay separate: cold captures the warm-up state from
pre-loop, hot captures the steady-state from backedge accumulation
after enough fixed-point iterations.

### Why cold/hot is worth the 2x lattice cost

Naive single-component max-join at a loop header conflates pre-
loop influence with steady-state. If a scalar burst right before
the loop leaves VALU pending = 10 but per-iter steady-state VALU
pending is 2, the max says "10 forever" -- which is correct as an
upper bound but useless for the scheduler (it'll think the loop
body is VALU-bound when it isn't).

Cold/hot separation gives both views at every program point. The
scheduler reads `state.hot` for "in-loop steady-state pressure"
queries; the autotune total uses `state.cold` for first-iter cost
and `state.hot` for subsequent iters.

The construction also generalises beyond structured `uniform_loop`
-- if any future pass introduces unstructured CFG with raw
`s_cbranch_*` loops, we just need a dominator-tree pass to
identify backedges and the same lattice plumbing keeps working.

### Backedge identification

For the current IR shape (structured `uniform_loop` +
`continue_if`), backedges are syntactic: the `continue_if`
inside a `uniform_loop` body is the back-edge to the loop's entry
block. No DT pass required at this stage; the lattice asks "is
the predecessor block the parent `uniform_loop`'s body terminator?"

When unstructured loops appear (not yet, but the design
accommodates), drop in a `DominanceInfo`-based backedge set
computed once per function.

### Total cycles accumulation

The lattice gives per-program-point pressure, not per-fn total
cycles. Total is computed during the analysis run as a side
effect of the transfer:

- **Straight-line block**: total += sum of `(W + 1)` per op.
- **Loop with trip count T**:
  - Iter-1 cost C1 = walk body using `cold` as entry state.
  - Steady cost Ss = walk body using `hot` as entry state
    (after fixed-point convergence).
  - Total = C1 + (T - 1) * Ss.
- **Loop with unknown T**: heuristic T = 4; tag result with
  `wave.estimated_unknown_trip_count = true` so autotune scoring
  downweights kernels with unbounded loops.
- **CFG branch (`scf.if`-style nested regions)**: total advances
  by max of the branches' contributions (worst-case path).

Trip-count extraction: `MLIRInferIntRangeInterface` on the
`continue_if` predicate (the project already pulls in the deps);
fallback to `waveamdmachine.trip_count` attribute on the
`uniform_loop` op when upstream sets one (e.g.,
`wavemeta-specialize` after K is concretised).

### Per-FU resource map

New entry in the data spine: `SchedClass -> FunctionalUnit`.
Lifted from `SISchedule.td`'s `HWWriteRes<class, [resources],
cycles>`; the LLVM resource enum (`HWVALU`, `HWSALU`, `HWVMEM`,
`HWLGKM`, `HWXDL`, `HWTransVALU`, `HWBranch`, `HWExport`)
collapses to our compact FU set. `check-sched-tables.py` (Stage
1's pre-commit hook) extended to diff the resource binding per
class alongside the existing latency diff.

### Implementation notes

- `mlir::dataflow::AbstractDenseDataFlowAnalysis` as the driver.
  `MachineState::meet` does the element-wise max; the framework
  iterates to fixed point.
- `visitBlockTransfer` is overridden to inspect the predecessor
  and dispatch cold vs. hot per edge.
- Loop-aware total-cycle accumulation is a small post-pass over
  `uniform_loop` ops: query the lattice at the loop body's
  entry / exit, compute C1 / Ss, multiply, sum.

### Validation gate

Six synthetic kernels: dependent VALU chain, independent VALU
chain (probes per-FU parallelism), VMEM burst (probes inflight
saturation), MFMA chain, fixed-trip-count loop (probes cold/hot
separation + trip-count multiplication), mixed. Compared against
`llvm-mca` on the same assembled ISA. Pass:
- Total cycles within 5% on all six.
- Per-FU pending vector within 10% of mca's
  `Resource pressure per iteration` block.

### Risks

- **Trip-count failure.** Unknown trip counts force the heuristic
  path. Mitigation: tag the result with
  `wave.estimated_unknown_trip_count = true`; downstream
  consumers (autotune scoring, scheduler) can downweight or
  refuse to score.
- **Per-FU map drift vs LLVM.** Same SISchedule.td hand-copy
  problem as latencies, same mitigation (extend
  `check-sched-tables.py`). A future TableGen emitter folds both
  diff paths into one generator.
- **Irreducible CFG.** Not currently produced by any wave-to-
  machine path; the cold/hot model still works in principle but
  needs DT-based backedge detection rather than the trivial
  `uniform_loop`-structural lookup. Filed as a future concern.

## Stage 3: HW microbenchmark harness

**Goal.** Closed-loop generate-compile-run-measure on patient zero.

**Deliverable.** Tool `wave-microbench`:
- Input: a `wave.amd.machine.func` (or a small DSL describing one).
- Wraps the kernel in a HIP host launcher that runs it N times in
  a timed loop.
- Compiles via `wave-translate` + `hipcc`.
- Runs under `rocprofv3 --basenames on --hsa-trace`; extracts
  `GRBM_GUI_ACTIVE` cycle counter.
- Returns `(predictedCycles, measuredCycles, deltaPct)`.

**Calibration kernel set** (first to land):
- One dependent VALU per iter (probes pipeline depth).
- N independent VALUs per iter (probes per-SIMD issue width).
- One global load + VALU + waitcnt (probes VMEM latency bucket).
- One LDS read + waitcnt (probes LDS latency bucket).
- MFMA chain at varying tile sizes (probes per-pass MFMA cycles).
- Same kernels with `s_setprio` raised/lowered (probes priority
  effect on coresident waves).

**Risk.** rocprofv3 cycle counters are CU-aggregated, not
per-SIMD. Mitigation for Stage 3: workgroup-size that fills exactly
one CU; divide by wave count. For per-wave timing, defer to Stage 6
ATT.

**Risk.** Thermal / frequency variance on consumer gfx11.
Mitigation: `rocm-smi --setperfdeterminism`; multiple runs;
report min and median.

## Stage 4: gfx11 single-wave calibration

**Goal.** Override layer on top of the LLVM-derived latency table,
populated from microbench measurements.

**Deliverable.**
- `data/calibration/gfx1100.json` -- per-SchedClass empirical
  latency plus metadata (date, ROCm version, driver, machine ID).
- `LatencyTable.cpp` reads the calibration file at construction;
  overrides apply on top of LLVM defaults; absent entries fall
  back to LLVM.
- `wave-calibrate-report` -- prints the per-class delta table
  (LLVM number / measured / delta%) so wrong-LLVM cells are
  visible at a glance.

**Risk.** Measurements include framework overhead. Mitigation:
loop-relative measurement -- run the same body N and 2N times,
subtract.

## Stage 5: multi-wave issue simulator

**Goal.** Cycle-by-cycle simulator with per-SIMD round-robin and
per-wave ready queues. Builds on Stage 2's per-program-point
`MachineState` lattice -- the simulator runs N copies of the
single-wave state (one per coresident wave), arbitrates between
them per SIMD cycle, and shares the data spine + per-FU resource
map.

**Deliverable.** `IssueSimulator.cpp`:
```cpp
struct SimConfig {
  ArchData arch;
  int wavesPerSIMD;       // from regalloc / occupancy.
  int activeSIMDs;        // usually arch.simdsPerCU.
  WavePriority initialPrio;
};
int64_t simulate(ArrayRef<WaveTrace> waves, SimConfig);
```

`WaveTrace` is the linear op list with SchedClass + operand deps
pre-computed by Stage 1's classifier.

**Simulator state.**
- Per-SIMD: round-robin pointer over its coresident waves.
- Per-wave: PC, ready-cycle-per-VGPR map, waitcnt counters
  (`loadcnt`, `dscnt`, `expcnt`, `storecnt` plus GFX12-split
  variants), current priority.
- Per-CU: issued-this-cycle counter capped at
  `arch.issuesPerCUPerCycle`.

**Main loop.**
```
for cycle in 0..:
  for simd in round_robin(simds):
    if cycle % arch.simdIssuePeriod != 0: continue
    wave = pick_wave(simd, priority_biased_round_robin)
    op = wave's next op if (waitcnt + operand deps satisfied)
    if op: issue(op); update waitcnts; schedule completion event;
           charge per-class latency; advance wave.PC
  process_completion_events(cycle)
  if all_waves_done: break
return cycle
```

**Memory latency model.** When a VMEM op issues, schedule a
load-complete event at `cycle + WriteVMEM_latency`. The event
decrements `loadcnt` for that wave. Latency from the data spine;
calibrated by Stage 3's VMEM kernel.

**Wave-priority handling.** Higher prio biases the per-SIMD wave
pick weights; does not exclude lower-prio waves. Initial weight
ratio: 2x per priority level. Refined against ATT data in Stage 6.

**Validation gate.** Run multi-wave kernels at occupancy 1, 2, 4
waves/SIMD on gfx11; compare measured vs predicted. Pass:
**ranking is monotone correct** across occupancy levels
(predicted cycles(occ=1) > cycles(occ=2) > cycles(occ=4) matches
measurement even if absolute numbers drift). Tighter is better;
ranking is the bar.

## Stage 6: ATT integration

**Goal.** Ground-truth per-wave timeline from `rocprofv3 --att`;
use it to tune the simulator.

**Background.** Advanced Thread Tracer records per-wave
instruction-level issue cycles. It's the only public AMD tool with
per-wave timing granularity.

**Deliverable.**
- `tools/wave-att-import.py` -- ingests `rocprofv3 --att` output,
  produces per-wave issue traces aligned to our `WaveTrace`
  op order.
- `wave-sim-vs-att` -- runs the simulator on the same kernel and
  prints a per-cycle diff: who-issued-what, sim vs att,
  color-coded delta.

**Tune against ATT.**
- Round-robin policy details: which SIMD wins ties, exact
  priority bias weights.
- Memory latency distribution: replace constant WriteVMEM with
  mean + jitter sampled from ATT.
- Wave-priority effect magnitude.
- Hazard rule coverage: ATT will show inserted NOPs we missed.

**Risk.** ATT captures cycle counts, not wall time -- overhead
doesn't distort the recorded cycles meaningfully (sampling-mode
caveat aside). Mitigation: larger kernels, longer captures, sanity
check sample density.

## Stage 7: priority and sched_group_barrier semantics

**Goal.** Simulator respects scheduling intent embedded in the IR.

**Deliverables.** Simulator handles, in order of importance:
- `s_setprio` / `__builtin_amdgcn_s_setprio` -- per-wave priority
  change at the issuing PC. Bias the SIMD's wave-pick weights.
- `sched_group_barrier(mask, size, sync_id)` -- next `size` ops
  of class `mask` form a non-interleavable scheduling unit; pair
  with same-`sync_id` siblings.
- `sched_barrier(mask)` -- reordering boundary; flush the ready
  queue across it.
- Conditional `s_barrier` after a `warp_id`-based predicate --
  wave-group split detection. Model the two groups with a
  one-barrier-segment phase offset (this is the 8-wave ping-pong
  pattern; see `docs/AMDGPUStaticCycleEstimation.md`).
- `s_sleep N` -- wave PC advances but no issue for N cycles.
- `iglp_opt(N)` -- pattern-match the four LLVM strategies;
  optional, since modern code uses hand-rolled
  `sched_group_barrier`.

## Stage 8: list scheduler pass

**Goal.** Reorder ops in `wave.amd.machine.func` to minimize
predicted cycles + smooth per-FU pressure.

**Algorithm.** Standard DAG list scheduler:
- Build dependence DAG from operand SSA use-def plus
  waitcnt-implied ordering.
- Critical-path heuristic for initial node priority.
- Cost function = re-run Stage 2's dense dataflow on the
  candidate ordering and read the per-region pressure +
  total-cycle delta. The lattice tells the scheduler which FU
  is the bottleneck across a region, so it can prefer
  reorderings that pull non-bottleneck ops into the busy zone.
- For each scheduling region (delimited by `sched_barrier(0)`
  ops in the input): explore reorderings; accept lower cycle
  count. Across regions: never reorder.

The CK / HipKittens / AITER convention of bookending intent with
`sched_barrier(0)` is exactly the region delimiter we need. Where
the input has none, we don't fabricate them -- everything is a
single region.

**Heuristics to evaluate.**
- Plain list-sched with critical path.
- IGroupLP-style pipeline-cloning (steal the
  `PipelineSolver` shape from `AMDGPUIGroupLP.cpp`).
- Genetic / beam search for small kernels (autotune via
  `wave.transform.tune`).

**Deliverable.** `wave-amd-machine-schedule` pass; output is the
reordered func. Plug into the transform-dialect pipeline.

**Risk.** Correctness around `s_setprio` / waitcnt pairs --
reordering across them is unsafe. Mitigation: mark these as
explicit DAG scheduling barriers; emit `sched_barrier(0)` around
them if not already present.

## Stage 9: extend to other archs

Per new arch:
- Add `ArchData` entry.
- Add `LatencyTable` entries from the corresponding
  `SISchedule.td` model.
- Add arch-specific hazard rules. CDNA's MFMA RAW/WAR matrix is
  considerably larger than RDNA's WMMA rules.
- Repeat Stage 3 microbench calibration on target HW.
- Repeat Stage 6 ATT calibration.
- CDNA wave-cost model: wave64 is the native unit (not 2x like
  RDNA); `wave64IssueMultiplier` = 1, `simdIssuePeriod` = 4.
- CDNA gfx942: 8-waves-per-SIMD ceiling. The 8-wave intra-block
  ping-pong pattern (warp_id-based conditional barrier) becomes
  worth detecting and modeling explicitly.

**Risk.** No local gfx942 / gfx950 / gfx1200 box. Mitigation: use
AMD developer cloud; gate CDNA calibration behind HW access. The
data spine for those archs lands without calibration first; HW
overrides arrive later.

## Stage 10: production kernel validation

End-to-end runs on real kernels:
- CK GEMM (gfx94x variants once HW available, gfx11 WMMA path).
- FA-CK attention.
- A Wave matmul kernel from the existing test suite.

Per kernel: simulated cycles vs measured cycles vs LLVM-scheduled
output cycles. Goal: our scheduler's output runs faster than LLVM's
default on at least half the tile sizes for matmul on gfx11. If
we lose on simple cases that's acceptable; the win has to come on
cases where multi-wave behavior is the bottleneck (memory-bound or
heavy MFMA stalls).

## Build order

Stage 1 lands first (`ArchData`, `SchedClass`, `OpClassifier`,
`LatencyTable`, the pre-commit `check-sched-tables` hook). Stage
2 is built incrementally: per-FU map first (data-spine
extension), then the cold/hot dataflow driver on straight-line
code, then loop-aware total-cycle accumulation + trip-count
extraction, then the transform-dialect ops that surface the
result to autotune.

Stage 3 (HW microbench harness) is independent of Stage 2 and
can run in parallel; it feeds Stage 4 (calibration overrides on
the data spine).

## Open questions

- VOPD dual-issue on RDNA3+. The data spine treats it as a single
  issue slot; if real kernels hit VOPD opportunities the simulator
  will over-estimate. Revisit after Stage 4.
- WriteVMEM as a single bucket vs L1-hit / L2-hit / dram-tier
  split. AMD does not publish the latencies; ATT may let us
  reverse them empirically. Filed for after Stage 6.
- Wave-priority arbitration weights. Phase 5 uses a 2x-per-level
  guess; Phase 6 ATT calibration replaces it. The form of the
  bias (linear, exponential, saturating) is itself a question.
- Static occupancy estimation from VGPR/SGPR/LDS usage at
  `wave.amd.machine` IR level (before regalloc-final). Affects
  `wavesPerSIMD` the simulator runs at. May need a separate pass
  that estimates occupancy and feeds it forward.

## References

Companion doc with the underlying data survey:
`docs/AMDGPUStaticCycleEstimation.md`.

Upstream code to mine for hazard rules and TableGen data:
- `llvm/lib/Target/AMDGPU/SISchedule.td`
- `llvm/lib/Target/AMDGPU/GCNHazardRecognizer.cpp`
- `llvm/lib/Target/AMDGPU/AMDGPUInsertDelayAlu.cpp`
- `llvm/lib/Target/AMDGPU/AMDGPUIGroupLP.cpp` (for the pipeline
  solver shape worth borrowing in Stage 8)
- `llvm/lib/Target/AMDGPU/MCA/AMDGPUCustomBehaviour.cpp`
  (for waitcnt semantics in mca)

Production scheduling intent to mimic:
- `ROCm/composable_kernel`: `sched_barrier(0)` sandwiching idiom,
  hand-rolled `sched_group_barrier` rotation in V3/V4 pipelines.
- `HazyResearch/HipKittens`: 8-wave intra-block ping-pong on
  gfx94x; `s_setprio(2)` for gfx950 scaled MFMAs.
- `triton-lang/triton`:
  `third_party/amd/lib/TritonAMDGPUTransforms/BlockPingpong.cpp`
  for asymmetric-barrier detection and `s_setprio` flipping
  around dot clusters.
