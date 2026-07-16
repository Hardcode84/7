# Wave gfx950 f16 GEMM Four-Wave Experiment

## Result

`gfx950-f16-256x256-4wave` keeps the 256x256x64 CTA tile but assigns one
128x128 output tile to each of four wave64 waves. Phased LDS-DMA reaches
`1.413956 PFLOP/s` on MI350X. The eight-wave profile remains unchanged.

- Shape: `M=N=K=8192`.
- Types: f16 A/B/C, f32 accumulation.
- Input: `rand_int`, seed 0.
- Launch: grid `32x32x1`, block `256x1x1`.
- Dynamic LDS: 131,072 bytes.
- Clock controls: not used.

Initial qualification used 25 warmups, 500 timed launches, and three repeats:

| Run | Time us | PFLOP/s |
|---:|---:|---:|
| 1 | 777.602 | 1.413977 |
| 2 | 777.614 | 1.413956 |
| 3 | 778.111 | 1.413052 |

Median: `777.614 us`, `1.413956 PFLOP/s`.

The pre-pipeline baseline used 25 warmups and 1,000 timed launches:

Seven runs used 25 warmups and 1,000 timed launches:

| Run | Time us | PFLOP/s |
|---:|---:|---:|
| 1 | 812.641 | 1.353010 |
| 2 | 820.994 | 1.339244 |
| 3 | 813.446 | 1.351671 |
| 4 | 817.748 | 1.344560 |
| 5 | 820.796 | 1.339568 |
| 6 | 819.039 | 1.342441 |
| 7 | 818.454 | 1.343401 |

Median: `818.454 us`, `1.343401 PFLOP/s`. Phased readiness removes `40.840 us`,
or 4.990%, and raises throughput by 5.252%. A same-device five-run eight-wave
check measured `785.121 us`, `1.400436 PFLOP/s` before the scheduler changes.

The `M=N=K=512` runtime check passed with `max_abs_diff=0`.

### Output-store cache

The profile marks all 32 final stores `cs`; gfx950 lowers them to `sc0 nt`.
Matched MI350X HPL medians improved from `913.2385` to `909.8135 us`
(+0.376%). Two balanced random-input comparisons improved by 0.238% and
0.273%. Strict HPL and random checks passed.

Twelve alternating K=2048 pairs measured median `none` at `55.896 us` and
`cs` at `55.882 us`. Full regeneration changed only the normal and specialized
four-wave f16 artifacts; all other perf goldens remained byte-identical.

## hipBLASLt Gap Investigation

Same-session `rand_int` runs on device 2 reproduced the gap without clock
controls:

| Kernel | Workgroups | Time us | PFLOP/s | Wave slower |
|---|---:|---:|---:|---:|
| Wave four-wave | 1,024 | 820.452 | 1.340129 | - |
| hipBLASLt 2530, StreamK 0 | 1,024 | 732.855 | 1.500313 | +11.95% |
| hipBLASLt 2531, StreamK 5 | 256 | 718.835 | 1.529574 | +14.14% |

StreamK persistence saves 14.020 us over solution 2530. It explains 1.95% of
hipBLASLt time, not the 87.597 us gap to the matched 1,024-workgroup control.

One dynamic K64 main-loop body has the same heavy work:

| Item | Wave | hipBLASLt 2530 |
|---|---:|---:|
| f16 MFMA | 128 | 128 |
| direct-to-LDS load | 16 | 16 |
| `ds_read_b128` | 32 | 32 |
| barrier | 1 | 3 |
| wait | 2 | 4 |
| total instructions | 207 | 225 |

Wave issues all 16 DMA operations by MFMA 62, waits at MFMA 68, then exposes
all LDS reads behind one barrier. hipBLASLt barriers after MFMAs 22, 52, and
93. Its DMA and LDS reads remain interleaved through MFMA 125. More barriers
and instructions are faster because each phase keeps ready MFMA work around
the DMA issue and completion points.

Raw counter medians from steady profiled launches:

| Counter | Wave | hipBLASLt 2530 | hipBLASLt 2531 |
|---|---:|---:|---:|
| `SQ_VALU_MFMA_BUSY_CYCLES` | 1,073,741,824 | 1,075,707,904 | 1,075,707,904 |
| `SQ_ACTIVE_INST_LDS` | 16,777,216 | 16,777,216 | 16,859,136 |
| `SQ_WAIT_INST_LDS` | 17,572,835 | 17,862,961 | 12,894,066 |
| `SQ_LDS_CMD_FIFO_FULL` | 533,876 | 486,036 | 112,144 |
| `SQ_LDS_DATA_FIFO_FULL` | 0 | 0 | 0 |

A separate issue-stall pass measured 230,546,966 `SQ_WAIT_INST_ANY`
wave-cycles for Wave and 150,715,430 for solution 2530, a 53.0% excess.
LDS-specific waits are similar, so the excess is the whole-pipeline dead time
around DMA completion, waits, and convergence.

One-CU ATT traces resolved every row. Dynamic heavy-op hit counts matched:
131,072 MFMA, 16,384 direct-to-LDS loads, and 32,768 LDS reads. Duration and
stall columns below are trace-reported cycle counts.

| ATT class | Wave avg duration | 2530 avg duration | Wave stall | 2530 stall |
|---|---:|---:|---:|---:|
| direct-to-LDS load | 67.63 | 17.62 | 946,120 | 160,925 |
| f16 MFMA | 12.19 | 10.74 | 1,040,546 | 858,392 |
| `ds_read_b128` | 8.18 | 8.25 | 136,781 | 128,658 |
| barrier | 28.78 | 11.84 | 54,791 | 58,785 |
| wait | 21.14 | 6.03 | 47,528 | 24,656 |

Direct-to-LDS issue stall is 5.88x higher in Wave. LDS-read duration matches,
and solution 2530 reaches 85.30% MFMA utilization despite 21.29% reported LDS
bank-conflict time. Wave reaches 65.46% MFMA utilization with no reported bank
conflicts. Bank layout can still improve the final result, but it does not
explain the main gap.

CTA mapping is not the missing 12%. A 300-launch control measured 815.659 us
for group 4, 838.002 us for group 16, and 948.995 us for group 32 with the
same eight-XCD remap. Group 4 remains best.

An issue-group-5 probe added 20 delay cycles with 16 cycles of overlap after
each group. It regressed from 815.659 to 859.681 us. The checked-in profile was
restored. Delay inside the single-ready-token graph cannot expose earlier LDS
work.

`--enable-split-barriers` emits byte-identical ASM for this workgroup. The pass
skips four waves on a four-SIMD CU, and its arrive/wait split would still retain
one full-buffer readiness point. hipBLASLt needs phased data readiness, not an
arrive/wait split.

Implemented topology:

- Partition next-tile A/B DMA and LDS reads into explicit subpanel phases.
- Join only each phase's DMA tokens before its barrier and fragment reads.
- Carry reuse tokens per subpanel; no implicit memory ordering.
- Let the greedy scheduler/model place phases. No post-greedy cycle veto.
- Model direct-to-LDS issue pressure so legal phases spread before FIFO fill.

Each K64 loop iteration consumes two K32 subpanels. A/B K0 reads feed the first
MFMA phase. A/B K1 reads overlap its middle. Thirteen next-tile DMA requests
issue before the readiness barrier; three B1 requests issue after it. Next-tile
K0 reads overlap the second MFMA phase. Bounded steady-state scheduling previews
four loop iterations and smooths LDS-DMA issue at the modeled queue service
rate.

Generated loop barriers follow MFMAs 24 and 49. The third IR barrier drains 13
previous-iteration requests before the late B1 cohort and next-tile reads;
token-only barrier contraction removes its redundant ISA barrier while keeping
wait and token order. hipBLASLt 2530 remains `44.759 us`, or 6.11%, faster than
the initial phased result.

The padded `0x1040` M0 cadence remains a separate experiment. Current `0x1000`
layout and phased token topology no longer change together, so a padding A/B can
isolate its contribution.

## Configuration

```text
bm=2
bn=2
wave_m_tiles=8
wave_n_tiles=8
wave_k_tiles=2
target_waves=1
cta_swizzle_xcds=8
cta_group_m=4
coalesced_mfma_output=true
output_store_cache=cs
PhasedDmaSchedule.issue_group_size=7
PhasedDmaSchedule.initial_delay_cycles=0
PhasedDmaSchedule.loop_delay_cycles=0
PhasedDmaSchedule.loop_overlap_cycles=0
PhasedDmaSchedule.delayed_waves=0
PhasedDmaSchedule.fetch_alignment=32
PhasedDmaSchedule.fetch_phase=12
PhasedDmaSchedule.subpanel_pipeline=true
```

The issue group selects the two-buffer f16 DMA pipeline. Four unpadded buffers
need 256 KiB and cannot launch on gfx950. Copying the eight-wave issue delays
regressed to `838.893 us`; K32 with four 32 KiB buffers regressed to
`897.590 us`.

XCD remap is required. A 300-launch sweep measured medians of `889.755`,
`1018.162`, `897.286`, and `817.482 us` for 1, 2, 4, and 8 XCDs. CTA group 4
beat group 8 on device 2: `818.454` versus `822.964 us` in long runs.

## ISA

```text
VGPR address space: 396
VGPRs below AGPR base: 256
AGPRs used: 140
SGPRs: 24
spills: 0
static f16 MFMAs: 384
static direct-to-LDS loads: 48
static LDS reads: 96
static workgroup barriers: 5
```

Combined register pressure fits the one-wave-per-SIMD target. Bank placement
is not an acceptance constraint.

hipBLASLt's four-wave reference still differs structurally: its direct-to-LDS
M0 cadence advances by `0x1040` and allocates 130 KiB LDS. Wave advances by
`0x1000` in an unpadded 128 KiB layout. Reproducing that padded/swizzled LDS
mapping is separate work.

## Artifacts

Current hashes include all generic-backend port slices through AGPR relief.
gfx950 A/B was waived; timings above are not attributed to these hashes.

- Specialized compiler ASM:
  `test/PerfGolden/Inputs/gfx950-f16-256x256-4wave-specialized.s`.
- Specialized ASM SHA-256:
  `83f72664ae4e12145fd7afdaa59c88b9a8f8e09ec28121d10d856f1fb65a3a8e`.
- Specialized ASM lines/bytes: 1,690 / 71,817.
- ASM: `test/PerfGolden/Inputs/gfx950-f16-256x256-4wave.s`.
- Generator/check: `test/PerfGolden/test_gfx950_f16_256x256_4wave.py`.
- ASM SHA-256:
  `db776c0c9ff870de4c67f91f2347c10212ecb5901104d35c25b7f26919aa9ee1`.
- Lines/bytes: 1,313 / 55,446.

## Commands

Generate and check ISA:

```bash
python test/PerfGolden/test_gfx950_f16_256x256_4wave.py \
  --build-dir build --generated-out /tmp/gfx950-f16-256x256-4wave.s
```

Run hardware calibration:

```bash
ROCR_VISIBLE_DEVICES=2 \
python tools/wave-matmul-calibrate/wave-matmul-calibrate.py \
  --chip=gfx950 --build-dir=build \
  --kernel-profile=gfx950-f16-256x256-4wave \
  --m=8192 --n=8192 --k=8192 --variants=scheduled \
  --iters=1000 --warmup=25 --repeats=7 --rand-int --no-check \
  --hipcc="$(command -v hipcc)"
```
