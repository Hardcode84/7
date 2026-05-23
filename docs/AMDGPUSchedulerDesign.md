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
+---------------------+    | - issue-resource map        |
        |                  | - hazard rules              |
        v                  | - structural params         |
+---------------------+    | (SchedModel + HW overrides) |
| Multi-wave issue    |<---+-----------------------------+
| simulator           |
+---------------------+
        |
        +--> cycles            (cost fn for autotune)
        +--> per-wave timeline (cost fn for scheduler)

+---------------------+
| List scheduler pass |--+
| (uses sim as cost)  |  |--> wave.amd.machine.func (reordered)
+---------------------+--+
```

Three artifacts, built in order: **data spine** (static + HW
overrides), **simulator** (the estimator), **scheduler** (uses
simulator as cost function). The simulator stands on its own as
the `wave.transform.estimate_cycles` op surfaced to the autotune
machinery; the scheduler is `wave.transform.schedule`.

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
   pass is real work. File a bead to mechanize before adding the
   fifth arch. A pre-commit diff script keeps the hand-copy honest
   against upstream.

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

## Stage 2: single-wave linear estimator

**Goal.** Given a `wave.amd.machine.func` + arch, return predicted
cycles assuming one wave on one SIMD.

**Deliverable.** `CycleEstimator.cpp` with
`estimateSingleWave(FuncOp, ArchData) -> int64_t`.

**Algorithm.** Walk the func linearly; maintain a next-issue-cycle
cursor and a per-VGPR ready-cycle map. For each op:
- Latency = `LatencyTable[arch][classifier(op)]`.
- Issue cycle = max(cursor, max ready-cycle of operand producers
  + their latency, hazard-rule-required wait).
- Bump cursor to issue cycle + 1 (single-issue SIMD).
- Record `op -> issueCycle`; downstream needs it.

Total cycles = max(issue cycle + own latency) over all ops.

**Validation gate.** Five synthetic kernels: dependent VALU chain,
independent VALU chain, VMEM burst, MFMA chain, mixed. Compare
against `llvm-mca` on the same kernels lowered to ISA. Pass: within
5% across all five. Anything wider signals a misclassified op or
wrong latency entry.

**Risk.** `llvm-mca` rejects handcrafted kernels (needs full func
wrapping + correct waitcnt). Mitigation: generate via the existing
`wave-translate` -> `.s` path; pipe to mca; accept its output as
single-wave ground truth.

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
per-wave ready queues.

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
simulated cycles.

**Algorithm.** Standard DAG list scheduler:
- Build dependence DAG from operand SSA use-def plus
  waitcnt-implied ordering.
- Critical-path heuristic for initial node priority.
- Cost function = `IssueSimulator::simulate()` on the candidate
  ordering.
- For each scheduling region (delimited by `sched_barrier(0)` ops
  in the input): explore reorderings; accept lower cycle count.
  Across regions: never reorder.

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

## Recommended kickoff sequence

Three concrete starting beads:

1. **Commit this design doc.**
2. **`lib/Dialect/WaveAMD/CostModel/ArchData.{h,cpp}`** -- per-arch
   struct + entries for the four target archs.
3. **`lib/Dialect/WaveAMD/CostModel/OpClassifier.{h,cpp}`** --
   first 20 `wave.amd.machine` ops mapped to `SchedClass`.

After those land, Stage 2 (linear estimator) and Stage 3 (microbench
harness) are independent and can proceed in parallel.

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
