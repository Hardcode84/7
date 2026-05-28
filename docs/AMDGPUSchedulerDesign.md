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
| (MachineState cold/ |
|  hot lattice per    |
|  program point)     |
+---------------------+
        |
        +--> per-op pressure     (cost fn for scheduler)
        +--> total cycles        (autotune score)
        |
        v
+---------------------+
| RegionProfile +     | (Stage 5: auto-partition into
| ping-pong delay     |  per-FU regions; convolution to
| search              |  find optimal stagger D)
+---------------------+
        |
        +--> peak-util score     (autotune score for
        |                         ping-pong configs)
        +--> stagger insertion   (wave_id-conditional
                                  barrier or s_sleep)

+---------------------+
| Event simulator     |  (Stage 6: cycle-accurate, ATT
| + wave-sim-vs-att   |   calibration target, NOT in
+---------------------+   autotune hot path)

+---------------------+
| List scheduler pass |--+
| (cost = re-run      |  |--> wave.amd.machine.func (reordered)
|  dataflow on        |  |
|  candidate order)   |  |
+---------------------+--+
```

Four artifacts, built in order: **data spine** (static per-arch
parameters + per-FU resource map + HW-calibrated overrides),
**dataflow analysis** (per-program-point cold/hot lattice),
**region profile + multi-wave queries** (auto-partition into
per-FU regions; analytic ping-pong delay; stagger insertion),
**scheduler** (cost = pressure delta from re-running the analysis
on a candidate ordering). The cycle-accurate event simulator is
a Stage 6 calibration tool, not the primary multi-wave model.

Surfaced into the transform-dialect pipeline as
`wave.transform.estimate_cycles` (total),
`wave.transform.pressure_report` (per-region detail),
`wave.transform.pingpong_score` (optimal `D` + predicted peak),
`wave.transform.insert_pingpong_stagger` (writes the staggering
primitive); the scheduler is `wave.transform.schedule`.

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

2. **Generate LLVM SchedModel latency data from `SISchedule.td`.**
   The checked-in latency include lets normal builds work without
   an LLVM source checkout. Pre-commit regenerates and diffs it when
   LLVM sources are present.

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
- `LatencyTable.inc` -- generated per-arch
  `(SchedClass -> latencyCycles)` table from `SISchedule.td`'s
  `GFX11SpeedModel`, `GFX12SpeedModel`, `SIDPGFX942FullSpeedModel`,
  `SIDPGFX950FullSpeedModel`.
- `HazardRules.cpp` -- ported subset of `GCNHazardRecognizer`:
  MFMA RAW/WAR/WAW pipeline, DPP-to-VALU, VMEM-VGPR-RAW,
  lds-direct, vcmpx. Only what's needed for the four target archs.
- `DelayAluTable.cpp` -- `INSTID_VALU_DEP_{1..4}`,
  `TRANS32_DEP_{1..3}`, `SALU_CYCLE_{1..3}`, `FMA_ACCUM_CYCLE_1`
  numbers for GFX11/12.

**Hygiene.** `build_tools/gen_sched_table.py --check`
regenerates the checked-in latency include from `SISchedule.td`
and checks the functional-unit map against upstream bindings.

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

### Loop exit: collapse cold/hot

At a `uniform_loop`'s exit edge, the lattice transitions from
"inside the loop" to "outside it". Inside, cold = iter-1 flavour
and hot = steady-state flavour. Outside, that flavour distinction
no longer applies to *this* loop's iterations -- we just have
"the actual machine state when control exited". The transition
rule:

```
collapsed   = max(loop_body_exit.cold, loop_body_exit.hot)
post_loop.cold = collapsed  (joined with any other forward incoming)
post_loop.hot  = enclosing_loop.hot  (or BOT if no enclosing loop)
```

Two things to notice:

1. `max` covers both trip-count regimes. For T = 1 the back-edge
   is never taken, so `hot` at exit is still BOT from
   initialisation and `collapsed` = `cold`. For T > 1 the
   fix-pointed `hot` dominates `cold` and `collapsed` = `hot`. No
   trip-count branching needed in the lattice plumbing.

2. The downstream `hot` is **not** the just-exited loop's hot --
   it's the enclosing loop's hot (looked up from the lattice at
   the `uniform_loop` op's own program point, not from the
   body-exit state). For top-level loops there is no enclosing
   loop and downstream hot is BOT. For nested loops the inner's
   hot vanishes into the downstream cold while the outer's hot
   keeps flowing through the post-inner-loop code unchanged.

This is implemented via the `visitRegionBranchControlFlowTransfer`
hook on `uniform_loop`: when `regionFrom = body, regionTo =
nullopt` (control exiting the op back to its parent), the
after-state's cold is set to the collapse of before's cold and
hot, and after-state's hot is read from the enclosing-scope
lattice rather than from before.

Total-cycle accounting is decoupled from this collapse: per-iter
cost still uses `cold` for iter 1 and `hot` for steady state via
the structural `C1 + (T-1) * Ss` formula (see "Total cycles
accumulation" below). The collapse only affects per-program-point
pressure queries downstream.

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
collapses to our compact FU set. `gen_sched_table.py --check`
diffs the resource binding per class alongside the generated
latency include.

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
- **Per-FU map drift vs LLVM.** Mitigation: `gen_sched_table.py
  --check` compares the handwritten FU map against upstream
  bindings when LLVM sources are present.
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

## Stage 5: region profile + multi-wave queries

**Goal.** A per-region per-FU "FU-cycle matrix" over the kernel,
plus the small set of analytic queries the autotune loop and
scheduler actually consume. Replaces a cycle-by-cycle multi-wave
simulator -- the autotune use cases (ping-pong delay selection,
block partitioning for overlap, peak-utilisation scoring) don't
need cycle-accurate simulation; they need an integrated per-FU
profile they can convolve.

The cycle-accurate / event-driven simulator still has a role,
but as a Stage 6 calibration target against ATT, not as the
primary cost function. Demoted from "the multi-wave model" to
"the ground-truth oracle for tuning the analytical model".

### RegionProfile

```cpp
struct RegionProfile {
  Operation *begin;   // first op of the region
  Operation *end;     // one-past-last op
  std::array<int, NumFunctionalUnits> fuCycles;  // issue cycles per FU
  int totalIssueCycles;       // sum of fuCycles
  int totalWallCycles;        // including waits, from Stage 2 dataflow
  FunctionalUnit dominantFU;
};
```

`fuCycles[fu]` = sum over ops in the region of `1` if
`funit(op) == fu`. (Multi-cycle ops contribute their latency,
not their issue slot count; the issue slot is `1` per op.) The
fact that `RegionProfile` mixes a static-walk artifact
(`fuCycles`) with a dataflow-derived field (`totalWallCycles`)
is fine -- they're queried at the same boundary.

### Auto-partitioning

Region boundaries are mostly automatic. The detector walks ops
in program order with a sliding window of `W` ops, computes the
window-dominant FU at each step, and emits a boundary when the
dominant FU changes across two consecutive windows with
sufficient margin:

```
W = 16            (tunable; bigger = smoother, fewer regions)
fuzzy_margin = 0.2 (dominant must beat second-best by 20% of cycles)

for op in func.walk:
  window.push(op); window.pop_if_full()
  curr_dom = argmax(window.fuCycles)
  if curr_dom != last_dom and margin(window) > fuzzy_margin:
    emit_boundary_at(op)
    last_dom = curr_dom
```

Explicit `sched_barrier(0)` ops in the input still emit forced
boundaries -- kernel-author intent overrides auto-detection.
Calibration: re-run the partitioner on the CK / HipKittens
production kernels and check that auto-detected boundaries
match the hand-placed `sched_barrier(0)` boundaries. The
defaults for `W` and `fuzzy_margin` are chosen to reproduce
human placement on the matmul and FA-CK templates.

### Optimal-delay search (ping-pong)

Per-region `fuCycles` casts to a per-cycle FU-activity timeline
by distributing the issues uniformly over the region's wall
cycles (square-wave approximation; sufficient for autotune
scoring, refined to op-exact for ATT calibration). Then for a
candidate delay `D`:

```
combined[t][fu] = wave0_profile[t][fu] + wave1_profile[t - D][fu]
peak[D]         = max over t and fu of
                   combined[t][fu] / fu_bandwidth[fu]
```

`fu_bandwidth[fu]` = per-cycle issue capacity (1 for VALU on
RDNA, 1/`simdIssuePeriod` for CDNA wave64 on the same pipe,
etc., from ArchData).

Candidate `D` values aren't every integer cycle -- only the
alignments where the convolution overlap structure changes,
which means region boundaries of wave 0 vs wave 1. For an N-
region kernel that's O(N) candidates per pair, dozens to
hundreds total. Sub-millisecond per scoring call.

Public API:

```cpp
struct PingpongPick {
  int delay;                // cycles to stagger wave 1 vs wave 0
  double predictedPeakUtil; // peak / bandwidth -- 1.0 = saturated, >1 = bottleneck
  FunctionalUnit bottleneckFU;
};

PingpongPick findOptimalPingpongDelay(ArrayRef<RegionProfile> regions,
                                      const ArchData &arch);
```

Generalises to N waves at arbitrary offsets via the same
convolution shape; the 2-wave specialisation is the
common-case entry point.

### Stagger insertion

Once `D` is picked, a transform-dialect op writes the staggering
primitive into the IR:

```mlir
wave.transform.insert_pingpong_stagger %target [delay = %d]
    : (!transform.any_op, !transform.param<i64>) -> ()
```

Mechanism choice:
- **Barrier-conditional** (preferred when `D` snaps to a region
  boundary). Emits a `wave_id`-predicated `s_barrier` so
  one wave-group passes through while the other stalls. Matches
  the production CK / HipKittens 8-wave pattern.
- **`s_sleep N`** (when `D` falls between barrier boundaries).
  Hard cycle delay, exact `D`; can loop for `D > 32K` cycles.

For exact-`D` requests the op picks barrier-conditional if a
region boundary is within `simdIssuePeriod` cycles of `D`, else
falls back to `s_sleep`.

### Autotune wiring

Two new transform-dialect ops feed the autotune body sequence:

```mlir
%d, %peak = wave.transform.pingpong_score from %mod waves = 2
    : (!transform.any_op) -> (!transform.param<i64>, !transform.param<i64>)

wave.transform.insert_pingpong_stagger %mod delay = %d
    : (!transform.any_op, !transform.param<i64>) -> ()

%cycles = wave.transform.estimate_cycles from %mod
    : (!transform.any_op) -> !transform.param<i64>
```

`pingpong_score` runs `partitionRegions` + `findOptimalPingpongDelay`
on the target and returns `(optimal_delay, predicted_peak * 1000)`.
The autotune body inserts the stagger and then sanity-verifies
total cycles via the existing `estimate_cycles` op.

### Validation gate

Apply the pipeline to a CK-style matmul on gfx1100 (the
patient-zero box). Expected: `pingpong_score` returns a delay
that brackets one MFMA-dominated region with one VMEM-dominated
region; after stagger insertion + lowering, ATT (from Stage 6)
shows the predicted ping-pong overlap pattern on real HW. Pass:
within 20% of optimal on the predicted-peak-util metric across
3 representative kernels.

### What's left for the cycle-accurate simulator

The event-driven simulator from earlier drafts of this doc
becomes a Stage 6 tool: takes the same input IR, runs an actual
event simulation, produces per-wave per-cycle timelines. Two
uses:
- **Calibrate** `RegionProfile`'s approximations (square-wave
  vs op-exact, multiplier accuracy for symmetric kernels).
- **Validate** that `insert_pingpong_stagger`'s choice actually
  produces the predicted overlap when arbitration / `s_setprio`
  interactions are in play.

It does not run inside the autotune loop -- too slow, and the
analytical approach is sufficient for scoring.

## Stage 6: ATT integration + cycle-accurate simulator

**Goal.** Ground-truth per-wave timeline from `rocprofv3 --att`;
use it to tune both Stage 5's analytical model and the
cycle-accurate event-driven simulator (this stage's other
deliverable).

**Background.** Advanced Thread Tracer records per-wave
instruction-level issue cycles -- the only public AMD tool with
per-wave timing granularity.

Run commands and current The Rock setup notes live in
`docs/Gfx1100CalibrationMethodology.md`.

**Two deliverables, one stage:**

1. **`tools/wave-att-import.py`** -- ingests `rocprofv3 --att`
   output, produces per-wave issue traces aligned to op order.
2. **Event-driven simulator** -- takes the post-Stage-2 IR plus
   `wavesPerSIMD`, runs a priority-queue event sim with
   per-SIMD round-robin + per-wave waitcnt counters +
   `s_setprio`-biased arbitration. Output: per-wave per-cycle
   issue timeline. Used to:
   - Cross-check Stage 5's analytical `RegionProfile` /
     ping-pong predictions.
   - Calibrate the analytical model's approximations
     (square-wave timeline distribution, priority bias weights,
     memory latency mean/jitter).
   - Spot multi-wave effects the analytical model misses
     (asymmetric contention windows, `s_setprio` re-ordering).

   The simulator is NOT in the autotune hot path. It runs
   offline, in `wave-sim-vs-att`, to validate and tune.

**`wave-sim-vs-att`** runs the simulator and the ATT capture on
the same kernel; prints a per-cycle diff (who-issued-what, sim
vs att, color-coded delta). Where the diff is large, ATT wins;
the analytical model's parameters get adjusted to close the gap.

**Tune against ATT.**
- Round-robin policy details: which SIMD wins ties, exact
  priority bias weights.
- Memory latency distribution: replace constant `WriteVMEM`
  with mean + jitter sampled from ATT.
- Wait-counter timing is separate from `SchedWrite` latency:
  tune `wave-sim-report --*-counter-latency` and ATT import
  `--counter-latency CLASS=N` before touching LLVM-derived tables.
- `s_setprio` effect magnitude.
- Hazard rule coverage: ATT will show inserted NOPs we missed.
- `fuzzy_margin` / window size `W` for Stage 5's auto-
  partitioner (calibrate so detected regions match human-placed
  `sched_barrier(0)` boundaries on CK / HipKittens templates).

**Risk.** ATT captures cycle counts, not wall time -- overhead
doesn't distort the recorded cycles meaningfully (sampling-mode
caveat aside). Mitigation: larger kernels, longer captures,
sanity check sample density.

## Stage 7: priority and sched_group_barrier semantics

**Goal.** Simulator respects scheduling intent embedded in the IR.

**Deliverables.** Both Stage 5's region analysis and Stage 6's
event simulator respect the scheduling-intent ops embedded in
the IR, in order of importance:
- `s_setprio` / `__builtin_amdgcn_s_setprio` -- per-wave
  priority change at the issuing PC. Stage 5: tag the enclosing
  region as high-priority for bandwidth accounting. Stage 6:
  bias the SIMD's wave-pick weights.
- `sched_group_barrier(mask, size, sync_id)` -- next `size` ops
  of class `mask` form a non-interleavable scheduling unit;
  pair with same-`sync_id` siblings.
- `sched_barrier(mask)` -- reordering boundary; forces a region
  split in the auto-partitioner; in the simulator, flushes the
  ready queue across it.
- Conditional `s_barrier` after a `warp_id`-based predicate --
  wave-group split detection. Already the primitive
  `insert_pingpong_stagger` emits when `D` snaps to a region
  boundary.
- `s_sleep N` -- wave PC advances but no issue for N cycles.
  Emitted by `insert_pingpong_stagger` when `D` doesn't align
  to a region boundary.
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
`LatencyTable`, the `gen_sched_table.py --check` hook). Stage
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
