# Wave gfx950 f16 GEMM 8192^3 Reference

## Result

Wave's scheduled `gfx950-f16-256x256-8wave` profile reached the 1.4 PFLOP/s
target on MI350X device 2.

- Shape: `M=N=K=8192`.
- Types: f16 A/B/C, f32 accumulation.
- Input: `rand_int`, seed 0.
- Timer: HIP events.
- Launch: grid `32x32x1`, block `512x1x1`.
- Dynamic LDS: 131,072 bytes.
- Clock controls: not used.

At this shape, each launch is 1,099,511,627,776 FLOPs. The 1.4 PFLOP/s
limit is `785.365 us`.

Seven locked runs used 25 warmups and 1,000 timed launches each:

| Run | Time us | PFLOP/s |
|---:|---:|---:|
| 1 | 782.544 | 1.405048 |
| 2 | 782.529 | 1.405075 |
| 3 | 782.143 | 1.405768 |
| 4 | 783.440 | 1.403441 |
| 5 | 784.580 | 1.401402 |
| 6 | 784.265 | 1.401964 |
| 7 | 785.934 | 1.398987 |

Median: `783.440 us`, `1.403441 PFLOP/s`. Six of seven runs clear 1.4;
the median is the acceptance result.

Interleaved old/new HSACO runs at `M=N=4096` improved all seven sweep K
values by 0.15-1.53%; K=8192 improved 0.30%. Non-f16 sweep HSACOs were
byte-identical across the rebase.

Correctness used `M=2048`, `N=256`, `K=512`, the same kernel shape, and
five independent 20,000-launch checks. All 100,000 launches passed with
`max_abs_diff=0`.

## Split Barrier Finding

Native named split-barrier instructions are not available for gfx950. The
gfx950 assembler rejects the gfx12 `s_barrier_signal` and `s_barrier_wait`
forms.

Wave's portable split barrier is an LDS arrival counter plus ticket polling.
It preserves semantics but measured about `798.6 us` (`1.377 PFLOP/s`) for
this kernel. Atomic arrival and polling cost more than the hidden skew.

The winning schedule uses split-barrier intent without a software barrier:

1. Split the eight wave64 waves into cohorts 0-3 and 4-7.
2. Before loop DMA request 7, waves 0-3 wait 46 cycles; waves 4-7 skip it.
3. Schedule against the skipped cohort, which exposes the DMA queue stall.
4. Fill request 8's issue gap with independent MFMAs instead of leading it.
5. Move three independent MFMAs before the existing `s_barrier`.

The cohort predicate is computed once in SGPR state, restored to VCC before
the loop, and carried explicitly through the uniform loop. An ordinary DMA
token anchors each delay at issue; delayed M0 orders the next DMA. Completion
waits remain explicit through ordinary memory tokens.

Delayed waves execute the explicit NOP span; skipped waves do not. Modeling
only the delayed cohort hid queue and barrier stalls from greedy scheduling.

Prologue DMA uses 68-cycle gaps before requests 7 and 14. Locked typed schedule:

```text
PhasedDmaSchedule.issue_group_size=7
PhasedDmaSchedule.initial_delay_cycles=68
PhasedDmaSchedule.loop_delay_cycles=46
PhasedDmaSchedule.loop_overlap_cycles=33
PhasedDmaSchedule.delayed_waves=4
PhasedDmaSchedule.fetch_alignment=32
PhasedDmaSchedule.fetch_phase=16
```

## Fetch Phase

Identical hot-loop instructions varied by roughly 9 us with loop placement.
Manual address-phase probes, two runs each:

| Loop phase mod 64 | Time us |
|---:|---:|
| 0 | 789.7, 791.1 |
| 8 | 787.8, 791.9 |
| 16 | 783.6, 782.7 |
| 32 | 789.6, 791.1 |
| 48 | 782.0, 785.6 |

Phases 16 and 48 are both 16 modulo 32. gfx950 DMA-phased loops therefore
emit `.p2align 5`, four encoded `s_nop 0` instructions, then the loop label.
The checked-in loop target remains 16 modulo 32.

## Kernel Shape

```text
CTA tile: 256x256x64
waves/workgroup: 8 wave64
MFMA: v_mfma_f32_16x16x32_f16
target resident waves/SIMD: 2
VGPRs: 240
SGPRs: 24
AGPRs: 0
spills: 0
dynamic LDS: 131072 bytes
```

Register-bank split is not an acceptance constraint. Combined pressure fits
the two-wave occupancy target.

Static ASM counts: 192 f16 MFMAs, 24 direct-to-LDS buffer loads, 72 LDS
reads, and three workgroup barriers.

## Follow-up Experiments

Order reflects evidence, not implementation cost. Keep packed and padded
layout results separate.

### Four-wave Kernel

The [hipBLASLt reference](HipBLASLtGfx950F16Gemm8K.md) is the strongest
lead. Its `256x256x64` family uses four wave64 waves, 248 VGPRs, 256 AGPR
accumulators, and a much larger MFMA schedule. The all-solution search member
reached `1.5325 PFLOP/s`.

Build a separate four-wave f16 profile: one `128x128` output tile and 256 f32
accumulators per wave. Target one resident wave/SIMD. Combined register
pressure is the constraint; AGPR placement is not the optimization. Match the
reference's direct-to-LDS and MFMA/load interleave before tuning scheduler
delays.

Result: [the separate four-wave profile](WaveGfx950F16Gemm4Wave.md) reached
`1.343401 PFLOP/s`, below this eight-wave kernel.

### One-sided Triple Buffer

Each `256x64xf16` operand panel is 32 KiB. Current `2A + 2B` staging consumes
128 KiB; MI350's 160 KiB LDS fits exactly one extra panel. Test `3A + 2B` and
`2A + 3B`, prefetching the extra operand one K iteration earlier. The kernel
already admits one workgroup/CU, so 160 KiB should not reduce wave occupancy.

### XCD K-order Coloring

Run even XCDs through K in ascending order and odd XCDs in descending order.
Use one direction for every CTA in an XCD so B-panel reuse remains local.
Select signed pointer increments before the loop; add no steady-state modulo
or padding. This changes floating-point reduction order. If direction alone
helps, test an XCD-selected cyclic K start next.

### Address and Cache Coloring

Sweep independently aligned A/B base offsets before changing layouts. Then
test padded leading dimensions such as `K + 128`; the packed f16 K stride is a
16 KiB power of two. Padded results use a different storage contract and are
not the packed-GEMM score.

Test cache policy asymmetrically: retain the operand reused by the XCD tile
group and stream the other. Carry policy structurally through Wave, Machine,
and MC emission; do not print ISA text directly.

### LDS Swizzle

Search lane-bit XOR permutations independently for A and B. Reject layouts
that add address instructions to the hot loop. Measure LDS bandwidth and
`SQ_LDS_DATA_FIFO_FULL` / `SQ_LDS_CMD_FIFO_FULL`; timing alone cannot separate
bank conflicts from DMA backpressure.

### Wave Priority

Test cohort-specific `s_setprio`: favor the MFMA cohort while the other cohort
issues DMA, then reset immediately. Compare it as a replacement for part of
the explicit phase delay, not another delay. Model priority as greedy-scheduler
state. Never use full simulated cycles to veto a post-greedy schedule.

### Acceptance

Capture TCP pending-stall, TagRAM distribution, TCC read/DRAM request, and LDS
FIFO counters before choosing conditional experiments. Any winner must pass
the small-shape correctness check and the full
`tools/wave-matmul-calibrate/wave-matmul-perf-sweep.py` matrix. Golden drift is
allowed after equal-or-better hardware performance. Clock controls stay
unused.

## Artifacts

- ASM: `test/PerfGolden/Inputs/gfx950-f16-256x256-8wave.s`.
- Generator/check: `test/PerfGolden/test_gfx950_f16_256x256_8wave.py`.
- ASM SHA-256:
  `a18858ca56095bd67d48b8e80b28251383951073273a22ea966e6e7a16936816`.
- Lines/bytes: 735 / 31,482.

Five-run regalloc-stage timing, one warmup: transform stages median
`0.1061 s`; alias state `0.0083 s`; linear scan `0.0031 s`. Every relief
provider reported `0.0001 s`; the ASM matched the golden.

Regenerate the reference only after benchmarking old and new assembly:

```bash
cmake --build build --target wave-opt wave-translate WavePythonModules \
  -j "$(nproc)"
python test/PerfGolden/test_gfx950_f16_256x256_8wave.py \
  --build-dir build --generated-out /tmp/gfx950-f16-256x256-8wave.s
```

## Benchmark Commands

Performance:

```bash
ROCR_VISIBLE_DEVICES=2 \
build/f16-8k-reference/wave-matmul-calibrate-runner-current \
  --m 8192 --n 8192 --k 8192 --bm 2 --bn 4 \
  --wave-m-tiles 8 --wave-n-tiles 4 --wave-k-tiles 2 --wave-size 64 \
  --input-type f16 --c-type f16 --kernel-abi matmul --dynamic-lds 131072 \
  --iters 1000 --warmup 25 --seed 0 --rand-int --no-check \
  build/f16-8k-reference/wave-f16-8k-final.hsaco \
  wmma_f16_matmul_tiled
```

Exact small-shape check:

```bash
ROCR_VISIBLE_DEVICES=2 \
build/f16-8k-reference/wave-matmul-calibrate-runner-current \
  --m 2048 --n 256 --k 512 --bm 2 --bn 4 \
  --wave-m-tiles 8 --wave-n-tiles 4 --wave-k-tiles 2 --wave-size 64 \
  --input-type f16 --c-type f16 --kernel-abi matmul --dynamic-lds 131072 \
  --iters 20000 --warmup 25 --seed 0 --rand-int \
  build/f16-8k-reference/wave-f16-8k-final-small.hsaco \
  wmma_f16_matmul_tiled
```
