# Static cycle estimation for AMDGPU: what data exists

Notes for building a non-executing kernel-cycle estimator over
WaveAMDMachine IR (or assembled ISA). Goal: rank autotune trials by
predicted cycles without actually running them. This doc is the
reconnaissance summary; it answers "where do the numbers live, and
what does each source actually model" -- not "here is the algorithm".

Sources surveyed:
- Upstream LLVM AMDGPU backend (`llvm/lib/Target/AMDGPU/`).
- AMD public ISA manuals via `github.com/kuhar/amdgpu-isa-manuals`.
- AMD optimization guides on `gpuopen.com` and `rocm.docs.amd.com`.
- ROCm production kernel libraries (Composable Kernel, AITER,
  HipKittens, hipBLASLt, FA-CK, Triton AMD backend).

## TL;DR for the impatient reader

- Per-instruction latency: **bucket-granular for every arch**
  (gfx6 -> gfx1251) in `SISchedule.td` + `GCNProcessors.td`.
  AMD-guide-derived approximations, not silicon-exact.
- Hazards / NOP wait-states: `GCNHazardRecognizer.cpp` for everything,
  `AMDGPUInsertDelayAlu.cpp` for the GFX11+ s_delay_alu shadow,
  `SIInsertWaitcnts.cpp` for vmcnt/lgkmcnt accounting.
- AMD's manuals tabulate MFMA cycles + dependency matrices for
  CDNA3/4, encode RDNA3/4 latencies as INSTID/SKIP codes for
  `s_delay_alu`, and document waitcnt widths everywhere. They do
  **not** publish a general VALU cycle table on any arch.
- `llvm-mca` already supports AMDGPU including gfx1250 via
  `MCA/AMDGPUCustomBehaviour.cpp`. Single-wave cycle estimate
  from assembled `.s` is essentially free.
- Multi-wave-per-SIMD interaction: **LLVM models none of it**.
  Counts coresident waves only as a register-pressure budget.
- AMD documents the issue policy qualitatively (round-robin SIMDs,
  5-cycle dependent latency on RDNA, 4-cycle wave64 issue on
  GCN/CDNA, Wave64 = 2 SIMD cycles on RDNA). No "occupancy ->
  effective IPC" curve is published anywhere.
- Production kernels (CK, HipKittens, AITER, Triton) do active
  inter-wave coordination via `s_setprio` sandwiches around MFMA,
  `sched_group_barrier`-driven hand-rolled schedules, and 8-wave
  intra-block ping-pong (gfx94x only). `iglp_opt(N)` is largely
  deprecated.

## Single-instruction latency

### LLVM SchedModel (the canonical bucket-level source)

`llvm/lib/Target/AMDGPU/SISchedule.td` (562 lines) declares ~30
abstract `SchedWrite` classes (`Write32Bit`, `WriteFloatFMA`,
`WriteDouble`, `WriteTrans32/64`, `Write{2,4,8,16}PassMAI`,
`Write{4,8,16}PassDGEMM`, `WriteXDL{2,4}PassWMMA`, `WriteVMEM`,
`WriteSMEM`, `WriteLDS`, `WriteSALU`, `WriteBranch`, `WriteExport`,
`WriteBarrier`, `WriteSFPU`, `WritePseudoScalarTrans`, ...) and binds
cycle numbers per arch in nine concrete machine models:

| Model | Archs | File:line |
|---|---|---|
| `SIFullSpeedModel` | gfx600/701/hawaii | SISchedule.td:237-253 |
| `SIQuarterSpeedModel` | most gfx7/8/9 (catch-all) | 255-275 |
| `SIDPFullSpeedModel` | gfx90a | 277-299 |
| `SIDPGFX942FullSpeedModel` | gfx942 | 301-333 |
| `SIDPGFX950FullSpeedModel` | gfx950 | 336-384 |
| `GFX10SpeedModel` | RDNA1/2 | 387-424 |
| `GFX11SpeedModel` | RDNA3 (gfx1100) | 426-462 |
| `GFX12SpeedModel` | gfx1200/1201 | 464-495 |
| `GFX1250SpeedModel` | gfx1250/1251 | 511-562 |

Processor binding: `GCNProcessors.td:23-358`. MFMA/WMMA opcode -> class
fan-out via `InstRW` regex patterns (SISchedule.td:270-273, 314-331,
348-367, 540-545). Individual opcodes carry `SchedRW = [...]` tags in
`VOP1Instructions.td:86,241,271`, `VOP2/3*`, `SMInstructions.td`, etc.

Representative numbers (read off SISchedule.td):
- `WriteVMEM` = 80 cycles pre-GFX10, **320** for GFX10/11/12/1250.
- `WriteSALU` = 1 pre-GFX10, **2** after.
- `WriteFloatFMA` = 5 on GFX10+.
- `WriteTrans32` = 4 (SI), 10 (GFX10/11), 9 (GFX12), 8 (GFX1250).
- `IssueWidth = 1` for every model (line 101).

Self-admission in the file (line 167): "latency numbers are taken from
AMD Accelerated Parallel Processing guide. They may not be accurate."
Treat as upper-bound / bucket approximations, not silicon-cycle-exact.

### Hazards: separate machinery, not in the SchedModel

`GCNHazardRecognizer.cpp` (3873 lines) carries the inter-instruction
wait-state counts the SchedModel does not model:
- VALU-write-VMEM RAW, DPP, NSA-to-VMEM, lds-direct, vcmpx.
- AGPR read-after-MFMA pipeline tables. Example at
  `checkMAIHazards908` line 2503: constants like
  `MFMA32x32WritesAGPRAccVgprReadWaitStates=18`,
  `MFMA16x16WritesAGPRAccVgprReadWaitStates=10`.
- `getMFMAPipelineWaitStates` (line 282) reads latency back from the
  sched model via `TSchedModel.getWriteProcResBegin(SC)->ReleaseAtCycle`.

`AMDGPUInsertDelayAlu.cpp` (GFX11+) at lines 67, 92-121 hardcodes
`VALU_MAX=5`, `SALU_CYCLES_MAX=4`, and the `INSTID_{VALU,TRANS,SALU}_*`
delay-class enumeration. This matches RDNA3/4 manual section 5.7
"ALU Instruction Software Scheduling" (Table 19 in RDNA3, Table 27
in RDNA4).

`SIInsertWaitcnts.cpp` (4027 lines) materializes waits.
`AMDGPUWaitcntUtils.h:22-37` defines counter taxonomy:
`LOAD_CNT, DS_CNT, EXP_CNT, STORE_CNT` (gfx<12); gfx12+ adds
`SAMPLE_CNT, BVH_CNT, KM_CNT, X_CNT, ASYNC_CNT`.

`AMDGPUHazardLatency.{h,cpp}` (77 lines) is a thin
`ScheduleDAGMutation` that bumps latencies on DAG edges; not a
source of numbers.

### AMD ISA manuals (kuhar mirror)

Repo: `github.com/kuhar/amdgpu-isa-manuals`. One directory per arch
(`cdna1`-`cdna4`, `rdna1`-`rdna4`, `rdna3.5`, `vega`, `vega7`); each
holds the AMD ISA Reference Manual as markdown. **No gfx1250 manual.**

What the manuals contain:

| Arch | Cycle tables | Hazards | Software scheduling | Counter widths |
|---|---|---|---|---|
| CDNA3 (gfx942) | MFMA only (Table 28) | §4.5 NOPs + §7.5 MFMA dep matrix | none (explicit NOPs) | VMCNT=6b, LGKMCNT=4b |
| CDNA4 (gfx950) | MFMA + F8F6F4 variants | §4.5 + §7.6 | none | VMCNT=6b, LGKMCNT=4b |
| RDNA3 (gfx1100) | none (passes only) | §7.9 WMMA scheduling | §5.7 S_DELAY_ALU INSTID/SKIP | VMcnt=6, LGKMcnt=6, EXPcnt=3, VScnt |
| RDNA3.5 | same as RDNA3 | §7.9.1 | §5.7 | same |
| RDNA4 (gfx1200) | none | §7.12.1 WMMA + §7.8 VOPD | §5.7-5.8 + §16.5 SOPP | split: KMcnt=5, EXPcnt=3, +`S_WAIT_*` opcodes |

Bottom line: per-opcode cycle numbers for VALU/SALU/VMEM/SMEM/LDS are
**not in these manuals on any arch**. What you can mine: MFMA cycles
and dependency matrices for CDNA, S_DELAY_ALU INSTID/SKIP tables for
RDNA, waitcnt counter widths everywhere, wave/SIMD structural params.

### llvm-mca

`llvm/lib/Target/AMDGPU/MCA/AMDGPUCustomBehaviour.{h,cpp}` (368 lines)
teaches llvm-mca about `s_waitcnt` semantics. Test coverage in
`llvm/test/tools/llvm-mca/AMDGPU/` covers gfx9/10/11/12/1250. So
`llvm-mca -mtriple=amdgcn -mcpu=gfx942 < kernel.s` works today and
produces a steady-state cycle estimate at SchedModel-bucket
granularity.

Limitation: MCA is single-wave. It does not model multi-wave issue,
cache latency, or divergence.

## Per-arch wave/SIMD reference

| Arch | SIMDs/CU | Waves/SIMD | Issue cadence | Wave64 cost | VGPR file/SIMD | Source |
|---|---|---|---|---|---|---|
| GCN (gfx6-9) | 4x SIMD16 | 10 | 1 instr / 4 cycles | native, 4-cycle | 256 | RDNA arch deck slide 5 |
| CDNA1 / MI100 (gfx908) | 4x SIMD16 | 10 | 1 / 4 cycles | native | 256 | rocm.docs MI100 µarch |
| CDNA2 / MI200 (gfx90a) | 4x SIMD16 | 8 | 1 / 4 cycles | native | 512 | LLVM `getMaxWavesPerEU`=8 |
| CDNA3 / MI300 (gfx942) | 4x SIMD16 | 8 | 1 / 4 cycles | native | 512 | rocm.docs MI300X workload tuning |
| RDNA1 (gfx10.1) | 2x SIMD32 | 20 | 1 / cycle, 5-cycle dep | 2x issue | 1024 | RDNA arch deck slide 7,11,17 |
| RDNA2 (gfx10.3) | 2x SIMD32 | 16 | same | 2x issue | 1024 | gpuopen "Occupancy explained" |
| RDNA3 (gfx1100) | 2x SIMD32 | 16 | same + VOPD | 2x issue | 1024 (1536 Navi31) | gpuopen + RDNA3 ISA §2 |
| RDNA4 (gfx1200) | 2x SIMD32 | 16 | same + VOPD + split waits | 2x issue | 1024+ | RDNA4 ISA §3 |

CDNA's drop from 10 -> 8 waves/SIMD on gfx90a/940/950 is the cost of
doubling the VGPR file. LLVM corroborates via
`AMDGPUBaseInfo.cpp:1263` `getMaxWavesPerEU`.

VGPR alloc granule (`AMDGPUBaseInfo.cpp:1391` `getVGPRAllocGranule`):
gfx90a=8, GFX10.3+=16/8 (wave32/64), GFX10+=8/4, GFX12 dynamic
(24/12 with `Feature1536VGPRs`).

## Multi-wave-per-SIMD: what's documented vs. modeled

### LLVM models nothing

The single SchedModel describes one wave's instruction throughput.
`IssueWidth = 1` in every model. No round-robin issue. No Wave32/64
multiplier. No "5+ coresident waves saturate the 5-stage VALU pipe"
formula.

What LLVM **counts** as a derived budget:
- Max waves per SIMD (`getMaxWavesPerEU`), EUs per CU (`getEUsPerCU`).
- VGPR/SGPR/LDS budgets and alloc granules.
- Occupancy as a single integer (`MFI.getOccupancy()`, `TargetOccupancy`)
  that the scheduler maximizes by capping VGPR/SGPR critical limits.

Only places LLVM acknowledges other waves on the SIMD:
- `AMDGPUSetWavePriority.cpp` -- emits `S_SETPRIO 3` at function entry,
  `S_SETPRIO 0` after the last VMEM load. Comment: "raise priority at
  start of shader until its last VMEM instructions to allow younger
  waves to issue their VMEM instructions as well." Threshold flag
  `--amdgpu-set-wave-priority-valu-insts-threshold=100`. Entry funcs
  only. Off by default; gated on `--amdgpu-set-wave-priority`.
- `--amdgpu-mfma-padding-ratio` (`GCNHazardRecognizer.cpp:53,2473`):
  inserts `s_nop` between neighboring MFMAs only when
  `MFI->getOccupancy() >= 2`. Comment line 2916: "Pad neighboring MFMA
  with noops for better inter-wave performance." Default 0 (off).
  **Only LLVM mechanism explicitly conditioned on multi-wave occupancy.**
- `AMDGPUBarrierLatency.cpp`: 16-cycle synthetic latency on
  `S_BARRIER_SIGNAL -> S_BARRIER_WAIT` DAG edges, 2000-cycle on
  memory -> `ATOMIC_FENCE`. DAG mutation only; no codegen output.
- `AMDGPUIGroupLP.cpp`: header comment mentions "inter-wavefront
  interactions" but pipelines themselves are pure single-wave DAG
  shaping. They reshape one wave's issue order so coresident waves
  stagger naturally.

`AMDGPUCoExecSchedStrategy.{h,cpp}` (gfx1250 only): adds
`InstructionFlavor` (WMMA / SingleCycleVALU / TRANS / MultiCycleVALU /
VMEM / DS / SALU / DMA / Fence / Other) and `HardwareUnitInfo` with
`ProducesCoexecWindow` flag. Still single-wave intra-issue overlap,
not inter-wave.

### AMD's documented issue policy

Cleanest single source: AMD "RDNA Architecture" public deck
(gpuopen.com/download/RDNA_Architecture_public.pdf).

- **GCN/CDNA** (slide 5): each wave assigned to one SIMD16, up to 10
  waves per SIMD16 (8 on gfx90a/942/950), each SIMD16 issues 1
  instruction every 4 cycles. **One wave saturates one SIMD16's VALU.**
  Coresident waves only buy memory latency hiding, not VALU throughput.
- **RDNA** (slide 7): each wave assigned to one SIMD32, 16-20 waves
  per SIMD32, each SIMD32 issues 1 instruction every cycle, **5
  cycles of dependent latency exposed, dependency stalls filled by
  other waves**. Saturation rule: need >=5 coresident waves per
  SIMD32 to fully hide dependent-VALU latency.
- **Wave64 on RDNA** (slide 17): vector instructions execute as
  2x Wave32. When low or high EXEC half is 0, that half skips.
- **VGPR file per SIMD** (slide 11): RDNA1 has 1024 physical
  registers per SIMD32. Divided among waves, up to 256 each.
  Wave64 counts double. RDNA3 grew it to 1536 on Navi31/32.

Round-robin issue: ROCm rocprofiler-compute pipeline-descriptions
page: "On every clock cycle, the scheduler considers waves from one
of the SIMD units for execution, selected in a round-robin fashion
between the SIMDs in the compute unit ... maximum of five issued
IPC, per-SIMD, per-CU." Per-arch waveslot counts: GCN/CDNA-MI100 =
10/SIMD, CDNA2 MI2XX = 8/SIMD. CDNA3 silent in that doc.

Modes register: `MODE.DP_RATE` in RDNA3 ISA (~line 1067) enumerates
double-precision dependent-VALU forwarding distance (1/32, 1/16, 1/8,
1/4, 1/2, full-rate). Not an occupancy curve, despite the name.

**Not documented anywhere AMD-public**: cache-tier memory latency,
occupancy-vs-throughput curves, per-opcode cycle tables for plain
VALU. gpu-side caches' L1/L2/L3 latencies live in third-party
microbenchmarks (Chips & Cheese) only.

## Wave coordination primitives

### s_setprio

`SOPInstructions.td:1762-1769`. Takes `i16imm:$simm16`. Real encodings:
gfx6-10/13 at `0x00f`, gfx11/12 at `0x035`. Lowers
`int_amdgcn_s_setprio`. Immediate is 0-3; the priority->arbitration
mapping is documented in AMD ISA manuals, not in LLVM.

GFX12+ adds `S_SETPRIO_INC_WG` (opcode `0x03e`), gated on
`FeatureSetPrioIncWgInst`. Workgroup-relative increment;
LLVM has no inline documentation of semantics.

### sched_barrier and sched_group_barrier

Builtins documented at `IntrinsicsAMDGPU.td:354-366,379-382`:
- `sched_barrier(mask)` -- a barrier the LLVM scheduler cannot cross.
  Mask 0 = nothing crosses.
- `sched_group_barrier(mask, size, sync_id)` -- groups `size`
  instructions of `mask` type and pairs with same-`sync_id`
  siblings; the scheduler emits them adjacent.

Mask values (from `AMDGPUIGroupLP.h:68` `SchedGroupMask`):

| Mask | Name |
|---|---|
| 0x001 | ALU (any) |
| 0x002 | VALU |
| 0x004 | SALU |
| 0x008 | MFMA |
| 0x010 | VMEM (any) |
| 0x020 | VMEM_READ |
| 0x040 | VMEM_WRITE |
| 0x080 | DS (any) |
| 0x100 | DS_READ |
| 0x200 | DS_WRITE |
| 0x400 | TRANS |
| 0x800 | LDSDMA |

### iglp_opt strategies

Builtin `__builtin_amdgcn_iglp_opt(strategy_id)`. Strategy IDs in
`AMDGPUIGroupLP.h:22-27`:

| ID | Name | Pipeline |
|---|---|---|
| 0 | `MFMASmallGemmOpt` | `MFMACount*3` repeats of `{DS:2, MFMA:1}` |
| 1 | `MFMASmallGemmSingleWaveOpt` | 3-phase, V_PERM/DS_WRITE-aware, gfx94x |
| 2 | `MFMAExpInterleaveOpt` | 3-phase TRANS/V_CVT/MFMA interleave for attention |
| 3 | `MFMAExpSimpleInterleaveOpt` | `{TRANS:1, MFMA:1}` x `MFMACount*3` |

`sched_barrier` / `sched_group_barrier` ops are mutually exclusive
with `iglp_opt`; the former wins where both are present.

### s_sleep, s_sethalt, named barriers

LLVM emits none of these automatically. Available via builtins:
- `__builtin_amdgcn_s_sleep(N)` -- wave sleeps N cycles.
- `__builtin_amdgcn_s_sleep_var` (gfx12+, opcode `0x058`).
- `__builtin_amdgcn_s_sethalt`, `_s_wakeup`.
- GFX12 named barriers: `s_barrier_signal/wait/init/leave/join/imm`.
  Lowering at `AMDGPUInstructionSelector.cpp:2446-2470,7097-7269`.
  `SIProgramInfo.h:86` tracks `num_named_barriers` per kernel.
- `__builtin_amdgcn_s_wakeup_barrier` -- one wave wakes others stuck
  on a barrier.

## Production wave-coordination patterns

### "Ping-pong" disambiguation

Three distinct techniques travel under this label:

1. **LDS double-buffer ping-pong** (`cur ^= 1`). Intra-wave LDS
   buffering. Every CK V1+ pipeline has it. Not multi-wave.
2. **Triton block ping-pong** -- TWO workgroups per CU alternate
   MFMA vs mem clusters. Implementation:
   `triton/third_party/amd/lib/TritonAMDGPUTransforms/BlockPingpong.cpp`.
   Uses `amdgpu.cond_barrier` op (asymmetric barrier) plus
   `s_setprio` flips. Env knob: `TRITON_HIP_USE_BLOCK_PINGPONG=1`.
3. **Intra-block 8-wave ping-pong** (CK `eight_waves`, HipKittens,
   FA-CK v3, AITER MLA). TWO coresident wave-groups inside one
   workgroup, offset by one conditional-barrier phase, symmetric
   work. **The canonical CDNA3/4 pattern.**

### 8-wave pattern mechanics

```cpp
warp_m = warpid() / WARPS_COL;
if (warp_m == 1) s_barrier();   // group 0 sails through, group 1 stalls.
// ... main loop body ...
s_barrier();                     // groups meet, permanent phase offset baked in.
```

Both groups do MFMA + memory; the conditional barrier installs a
one-phase shift so while group A is in its MFMA cluster, group B is
in its VMEM/LDS cluster. Symmetric, **not NVIDIA-style
producer/consumer** -- AMD has no register-redistribution mechanism.

Canonical files:
- `ROCm/composable_kernel:include/ck_tile/ops/gemm/pipeline/gemm_pipeline_ag_bg_cr_eight_waves_base.hpp`
- `ROCm/composable_kernel:include/ck_tile/ops/gemm/pipeline/gemm_pipeline_ag_bg_cr_comp_async_eight_waves.hpp`
- `ROCm/composable_kernel:include/ck_tile/ops/fmha/pipeline/block_fmha_fwd_v3_pipeline.hpp`
  (FA-CK v3 attention, with per-group `s_setprio`)
- `HazyResearch/HipKittens:kernels/gemm/fp8fp32/FP8_8wave/8_wave.cu`
- `HazyResearch/HipKittens:kernels/gemm/mxfp8/MXFP8_8wave/8_wave.cu`
- `ROCm/aiter:csrc/kernels/mla/hk/mi3xx_v32_fwd_decode_*.cuh`

### s_setprio production idiom

Universal across CK, AITER, HipKittens:

```cpp
sched_barrier(0); s_setprio(N); sched_barrier(0);
// MFMA chunk
sched_barrier(0); s_setprio(0); sched_barrier(0);
```

The `sched_barrier(0)` sandwich pins the priority change against LLVM
reordering. Always raised **before MFMA**, dropped after. Never
raised before a VMEM burst -- direct **opposite of LLVM's automatic
`AMDGPUSetWavePriority`**, which raises at function entry and drops
at last VMEM load.

Priority level by workload:
- gfx942 BF16 / FP8 MFMA: `s_setprio(1)`.
- gfx950 scaled MFMAs (longer pipe): `s_setprio(2)`.
- AITER MLA decode: `s_setprio(2/3)`.
- FA-CK v3 ping-pong groups: group 0 = `s_setprio(0)`,
  group 1 = `s_setprio(1)` -- the only place per-group priorities
  differ.

Files: `composable_kernel/include/ck/tensor_operation/gpu/block/blockwise_gemm_pipeline_xdlops_v1.hpp`,
`v2.hpp`, `v2_b_scale.hpp`, `wmmaops_v1.hpp`.

### sched_group_barrier production rotation

CK V3 (`blockwise_gemm_pipeline_xdlops_v3.hpp`) and V4 ship
hand-rolled schedules. Repeated pattern:

```
sched_group_barrier(0x008, 1, 0)   // MFMA x 1
sched_group_barrier(0x100, N, 0)   // DS_READ x N
sched_group_barrier(0x008, 1, 0)   // MFMA x 1
sched_group_barrier(0x200, N, 0)   // DS_WRITE x N
sched_group_barrier(0x008, 1, 0)   // MFMA x 1
sched_group_barrier(0x020, 1, 0)   // VMEM_READ x 1
```

MFMA spaced every other group, with one of {DS_R, DS_W, VMEM_R} between,
bookended by `sched_barrier(0)` so LLVM cannot bleed instructions
across the unit.

### iglp_opt is largely dead

`__builtin_amdgcn_iglp_opt(N)` is only emitted from CK V2 behind
`CK_EXPERIMENTAL_PIPELINE_V2_IGLP_OPT` (`composable_kernel/include/ck/ck.hpp`).
**Absent from CK V3/V4, FA-CK v3, AITER, HipKittens.** State of the
art moved to hand-rolled `sched_group_barrier`. The estimator can
deprioritize iglp pattern matching.

### Staggering primitives, actual usage

- **Conditional `s_barrier`** is the dominant mechanism. Works
  because `s_barrier` is workgroup-wide -- one group hitting it
  before the other stalls naturally until the lagging group catches
  up.
- **Triton's `amdgpu.cond_barrier`** is an explicit asymmetric-barrier
  op for the same effect.
- **`s_sleep` NOT used for staggering** anywhere in CK / AITER /
  HipKittens production. It exists but is not in the playbook.
- **Software-pipeline prefetch** (CK V3 `LocalPrefetch` before the hot
  loop) is orthogonal -- intra-wave, not inter-wave.

### Arch portability gotchas

- 8-wave ping-pong is **gfx94x-specific**. Depends on CDNA3/4's
  two-waves-per-SIMD scheduling. Doesn't carry to gfx1100 (RDNA's
  16-waves-per-SIMD makes the two-group split irrelevant).
- IGLP strategy 1 (`MFMASmallGemmSingleWaveOpt`) is gfx94x-specific
  via V_PERM packing.
- Triton block-pingpong pass enables on RDNA but tile-size heuristics
  target gfx94x; gfx1100 performance unverified.
- Priority level depends on MFMA pipe length: `s_setprio(1)` on
  gfx942 BF16, `s_setprio(2)` on gfx950 scaled MFMA.

## Recommendations for the estimator

### Architecture options

Three layered approaches, in increasing build cost:

1. **Wrap `llvm-mca`.** Pipe the assembled `.s` from `wave-translate`
   into MCA via its library API. Single-wave cycle estimate at
   SchedModel granularity, free. Limit: no multi-wave, no cache.
   Expose as a `wave.transform.estimate_cycles` op.
2. **MIR-level analysis pass over WaveAMDMachine IR.** Walk ops,
   sum `SchedWrite` class latencies from the same TableGen data
   MCA uses, apply hazard rules from `GCNHazardRecognizer`. Lets
   the estimator model multi-wave effects MCA can't.
3. **Cycle simulator.** Per-SIMD state, multiple wave PCs,
   round-robin issue. Most accurate, most build cost. Pays off
   if (1) and (2) prove insufficient for ranking.

Recommended: start at (1) for a baseline; if it ranks autotune
trials well, ship. If accuracy is insufficient, layer (2) on top.

### Multi-wave correction formula

Once the single-wave estimate is in hand, the inter-wave correction
is roughly:

- **GCN/CDNA**: `simd_ipc = min(1/4_per_cycle, sum_of_wave_demand)`.
  One wave saturates one SIMD16's VALU at 4-cycle wave64 issue.
  Coresident waves only buy memory latency hiding.
- **RDNA**: `simd_ipc = min(1_per_cycle, sum_of_wave_demand_with_5cycle_dep_latency)`.
  Saturation needs >=5 coresident waves for dependency-chained
  instruction streams; fewer if there's per-wave ILP.
- **Wave64 on RDNA**: cost = 2x Wave32 in SIMD cycles.
- **Memory latency hiding**: pessimistic upper bound
  `mem_latency / (coresident_waves * avg_compute_cycles_between_loads)`.
  Latency from `SISchedule.td`'s `WriteVMEM` (bucket
  approximation; AMD does not publish cache-tier numbers).

### Signals to read from the IR

Production kernels embed scheduling intent the estimator can consume
directly:

| Signal | What to model |
|---|---|
| `s_setprio N` pairs around a region | Region wants to win arbitration vs coresident waves. If `coresident > 0`, charge other waves a preemption-out-of-issue cost. |
| `sched_group_barrier(mask, size, sync_id)` | Authoritative pipeline declaration. Read these and skip own DAG analysis for that region. |
| Conditional `s_barrier` after `warp_id` predicate | Wave-group split detected. Model two coresident groups with a one-barrier-segment phase offset. |
| `amdgpu.cond_barrier` (Triton MLIR) | Same as above, pre-lowered. |
| `s_sleep N` | Charge N cycles directly. |
| `iglp_opt(N)` | Match strategy N to its canned pipeline (rare in modern code). |
| `s_barrier_signal/wait` pair (GFX12) | Model independent work between signal and wait as overlapping with barrier wait. |
| `--amdgpu-mfma-padding-ratio` value + occupancy >= 2 | Mirror to predict when LLVM inserts filler nops between MFMAs. |

### Accuracy expectations

A model built from these inputs will be wrong in absolute terms
(probably 1.5-3x on real kernels, more on memory-bound ones) but
should rank autotune trials correctly -- which is what the autotune
use case actually needs.

## What is **not** available

- Per-opcode cycle tables for plain VALU on any arch. LLVM has
  bucket-level (~30 classes); AMD manuals have none.
- Cache-tier memory latencies (L1/L2/L3). Third-party microbenchmarks
  only (Chips & Cheese).
- Occupancy -> effective IPC curves. Mentioned qualitatively in AMD
  guides, never tabulated.
- gfx1250 ISA manual in the kuhar mirror. LLVM has SchedModel and
  hazard recognizer coverage; AMD's manual itself is not yet
  publicly mirrored.
- LLVM-side modeling of wave-priority semantics. `s_setprio` levels
  are bare magic numbers in LLVM; the priority -> arbitration map
  is in AMD docs only.
- LLVM-side modeling of any multi-wave interaction beyond
  occupancy-as-budget.

## References

LLVM (`llvm/lib/Target/AMDGPU/`):
- `SISchedule.td` -- abstract SchedWrite classes + per-arch models.
- `GCNProcessors.td` -- arch -> model binding.
- `GCNHazardRecognizer.cpp` -- NOP wait-states, MFMA pipeline,
  `--amdgpu-mfma-padding-ratio`.
- `AMDGPUInsertDelayAlu.cpp` -- GFX11+ s_delay_alu shadow latencies.
- `SIInsertWaitcnts.cpp` + `AMDGPUWaitcntUtils.h` -- counter taxonomy.
- `MCA/AMDGPUCustomBehaviour.cpp` -- llvm-mca AMDGPU plugin.
- `AMDGPUSetWavePriority.cpp` -- only automatic inter-wave codegen.
- `AMDGPUIGroupLP.cpp` + `.h` -- iglp_opt + sched_group_barrier impl.
- `AMDGPUBarrierLatency.cpp` -- barrier signal/wait DAG latency.
- `AMDGPUCoExecSchedStrategy.cpp` -- gfx1250 single-wave coexec model.
- `Utils/AMDGPUBaseInfo.cpp` -- occupancy / wave-count / alloc-granule
  computations.
- `IntrinsicsAMDGPU.td` -- builtin signatures + mask definitions.
- `SOPInstructions.td` -- s_setprio, s_sleep, s_barrier_* encodings.

AMD documents:
- AMD RDNA Architecture deck: `gpuopen.com/download/RDNA_Architecture_public.pdf`
- gpuopen "Occupancy explained": `gpuopen.com/learn/occupancy-explained/`
- ROCm rocprofiler-compute pipeline-descriptions:
  `rocm.docs.amd.com/projects/rocprofiler-compute/en/latest/conceptual/pipeline-descriptions.html`
- ROCm MI300X workload tuning:
  `rocm.docs.amd.com/en/docs-6.1.2/how-to/tuning-guides/mi300x/workload.html`
- ROCm MI100 microarchitecture:
  `rocm.docs.amd.com/en/docs-6.2.1/conceptual/gpu-arch/mi100.html`
- AMD lab note "Register pressure in CDNA2":
  `gpuopen.com/learn/amd-lab-notes/amd-lab-notes-register-pressure-readme/`
- AMD Matrix Instruction Calculator:
  `github.com/ROCm/amd_matrix_instruction_calculator`
- FP8 GEMM Optimization on CDNA4 (ROCm Blogs):
  `rocm.blogs.amd.com/software-tools-optimization/cdna4-gemm-kernels/README.html`
- AITER (ROCm Blogs):
  `rocm.blogs.amd.com/software-tools-optimization/aiter-ai-tensor-engine/README.html`
- ISA manuals mirror: `github.com/kuhar/amdgpu-isa-manuals`

Production kernel libraries:
- Composable Kernel: `github.com/ROCm/composable_kernel`
- AITER: `github.com/ROCm/aiter`
- HipKittens: `github.com/HazyResearch/HipKittens`
  (paper: arXiv 2511.08083)
- hipBLASLt: `github.com/ROCm/hipBLASLt`
- FlashAttention ROCm: `github.com/ROCm/flash-attention`
- Triton AMD backend: `github.com/triton-lang/triton`
  (`third_party/amd/lib/TritonAMDGPUTransforms/BlockPingpong.cpp`)
- Triton block-pingpong PR: `github.com/triton-lang/triton/pull/5018`

Third-party (treat with care, not AMD primary):
- Chips & Cheese CDNA3 / RDNA3 microbenchmarks.
- CUTLASS Ping-Pong GEMM (PyTorch blog): for NVIDIA contrast.
