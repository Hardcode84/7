# Wave gfx950 f16 GEMM Four-Wave Experiment

## Result

`gfx950-f16-256x256-4wave` keeps the 256x256x64 CTA tile but assigns one
128x128 output tile to each of four wave64 waves. Opt-in multi-wave
specialization reaches `1.50154 PFLOP/s` on MI350X. Same-session frozen manual
ASM reaches `1.50018 PFLOP/s`. The eight-wave profile remains unchanged.

- Shape: `M=N=K=8192`.
- Types: f16 A/B/C, f32 accumulation.
- Input: `rand_int`, seed 0.
- Launch: grid `32x32x1`, block `256x1x1`.
- Dynamic LDS: 133,120 bytes.
- Clock controls: not used.

Seven specialized compiler runs measured `735.433`, `732.851`, `731.078`,
`732.250`, `732.258`, `731.656`, and `733.425 us`. Median: `732.258 us`, or
`1.50154 PFLOP/s`. Same-session manual ASM median: `732.921 us`, or
`1.50018 PFLOP/s`. Protocol: device 2, `rand_int`, 25 warmups, 500 launches,
no clock controls.

Fresh final validation of the checked-in ASM measured a `733.768 us` median,
or `1.498446 PFLOP/s`, across seven `rand_int` runs. Default random seed 17
measured `757.306 us`, or `1.451872 PFLOP/s`, with the same binary and protocol.

Strict `1024x512x256` checks passed bit-exactly for `rand_int` seed 0 and
default random seed 17.

### HPL inputs

The exact hipBLASLt HPL stream remains power-limited below 1.3 PFLOP/s. On
device 2, the checked-in traversal measured `913.694 us` (`1.20337 PFLOP/s`).
Keeping MFMA source 0 fixed across each column and reversing alternate columns
measured `907.979 us` (`1.21094 PFLOP/s`). Both used 2,000 warmups and 500
timed launches. No clock controls were used.

All eight idle MI350X devices measured `890.003-937.049 us`; the best result
was `1.23540 PFLOP/s`. The 1.3 PFLOP/s threshold is `845.778 us`.

PMC captures found identical MFMA and LDS work for HPL and `rand_int`.
Steady dispatches reported 163.4M versus 168.7M `SQ_WAIT_INST_ANY` wave-cycles,
respectively. HPL does not expose scheduler stall headroom hidden by the random
case.

Rejected exact controls:

- CTA groups 1, 2, 4, 8, 16, and 32 measured `981.905`, `942.824`, `908.861`,
  `907.063`, `929.558`, and `982.988 us`.
- Common power-of-two operand exponent shifts stayed within run variance.
- One `v_nop` per 16 MFMAs regressed to `916.315 us`.
- Reversing independent MFMA runs in one specialized branch was flat at
  `907.666 us`.

#### HPL ATT stall audit

One-CU ATT captures used the exact checked-in HSACO, device 2, and three cold
launches per input. HPL took `955.768-992.609 us`; `rand_int` took
`770.767-782.766 us`. All 230,928 rows per capture resolved. Values below are
median duration or stall cycles per traced wave.

| Class | HPL duration | Random duration | HPL stall | Random stall | HPL duration delta |
|---|---:|---:|---:|---:|---:|
| MFMA | 194,224 | 194,079 | 125,741 | 125,488 | +145 |
| Direct-to-LDS | 86,562 | 32,057 | 76,625 | 21,733 | +54,506 |
| LDS read | 29,940 | 29,761 | 12,758 | 12,718 | +180 |
| Barrier | 20,331 | 8,013 | 18,577 | 6,373 | +12,318 |
| VMEM store | 9,135 | 2,004 | 8,878 | 1,747 | +7,131 |
| Wait | 5,715 | 5,731 | 5,715 | 5,731 | -16 |

MFMA duration changes by 0.07%; explicit waits are flat. HPL's 74,181-cycle
total increase is direct-to-LDS issue backpressure followed by barrier skew
and output-store stalls. Addresses and instruction counts are input-invariant,
so this is data-dependent execution throttling, not cache behavior or a
missing wait.

All-SIMD traces show where the skew lands. At the three loop barriers, HPL
arrival spreads have medians `32`, `20`, and `108` cycles and p95 values
`384`, `920`, and `888`; random medians are `12`, `16`, and `4`. The odd
specialized schedule arrives last at the third barrier in 448 of 504 events.
Barrier release reconverges within four cycles. Split barriers cannot shorten
the critical late-wave path.

Matched hipBLASLt solution 2530 shows the same input dependence, more sharply:
direct-to-LDS duration grows from 34,636 to 116,874 cycles per wave, barrier
duration from 9,152 to 36,018, and store duration from 1,752 to 15,858. Its
total trace duration grows by 123,734 cycles versus Wave's 74,181. HPL
throttling is not unique to the Wave schedule.

Two ATT-directed controls were rejected:

- Redistributing DMA issue groups from `5/8/3` to `6/7/3` changed median HPL
  time from `909.097` to `910.096 us`.
- Removing specialization changed median HPL time from `906.847` to
  `915.213 us`.

Remaining opportunities, in expected-value order:

1. Generate four independent SIMD schedules. Current parity specialization
   still issues each DMA cohort from two SIMDs together.
2. Route only the late B cohort through VGPR loads plus LDS writes, or narrower
   direct-to-LDS requests, to bypass or pace the saturated issue path.
3. Test an alternate coalesced epilogue only after the load path; stores account
   for less than one tenth of the HPL-only trace increase.

Clearing five f16 mantissa bits reached `834.717 us`, but changes the GEMM
inputs and fails the numerical contract. One-level f16 Strassen reduced MFMA
work by 12.5%, but rounded operand sums exceeded the existing per-element
tolerance. Neither is a valid kernel result.

### Full sweep

Fresh `--kernels all` validation rebuilt the complete calibration path and ran
all 30 configurations. Four-wave f16 improved across the main K range:

| K | Prior TFLOP/s | Current TFLOP/s | Delta |
|---:|---:|---:|---:|
| 2048 | 1144.60 | 1149.58 | +0.43% |
| 3072 | 1222.32 | 1238.72 | +1.34% |
| 4096 | 1295.99 | 1307.85 | +0.91% |
| 8192 | 1438.10 | 1447.14 | +0.63% |
| 16384 | 1397.24 | 1411.03 | +0.99% |

Unchanged controls stayed within run variance: eight-wave f16 changed by at
most `-0.84%` and MXFP4 by `-1.37%`. Current MXFP4 throughput spans
`1952.04-3946.08 TFLOP/s` for eight waves and `1800.07-4192.83 TFLOP/s` for
four waves.

The older eight-wave MXFP4 baseline is excluded. Its K=3072 HSACO fails strict
random checking at `(m=4,n=0)`: expected `1803`, got `1667`. That binary
predates the DMA descriptor lifetime edge; its apparent `2.36%` advantage is
not a valid performance result.

All regenerated perf goldens were measured against their checked-in ASM on
device 2. The full sweep covers f16 4/8-wave, MXFP4 4/8-wave, and both v9
goldens. Focused random-input A/B runs covered the remaining drift:

| Golden | Shape | Prior us | Current us |
|---|---|---:|---:|
| f16 16-wave | `4096x4096x8192` | 227.428 | 226.843 |
| A4W4 MXFP | `4096x4096x16384` | 127.891 | 127.865 |
| TLX async GLU | `1024x21568x256` | 59.952 | 59.990 |
| TLX async FA | `B2 H64 N8192 D128` | 5299.393 | 5282.099 |
| TLX persistent causal FA | `B2 H64 N8192 D128` | 4333.515 | 4317.141 |

GEMM and GLU rows used 25 warmups, 200 launches, and nine repeats. FA rows
used 5 warmups, 20 launches, and nine repeats. No clock controls were used.

Five exact-golden compile runs bounded regalloc at `2.5824-2.6101 s`; median
`2.5940 s`. The timing harness selects `waveamd_backend_multi_wave` explicitly
and rejects any assembly mismatch.

Unspecialized kernel-side port qualification used device 2, `rand_int`, 25
warmups, and 500 launches. Frozen tile-packed ASM measured `783.708`,
`785.509`, and `779.891 us`; dense column-major ASM measured `777.977`,
`778.575`, and `775.848 us`. Medians: `1.402961` versus `1.413296 PFLOP/s`.

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

## Manual 1.5 PFLOP/s Reproduction

The accepted dense column-major ASM measured `733.370`, `734.536`, and
`733.978 us`: median `733.978 us`, or `1.498017 PFLOP/s`. Same-session
hipBLASLt solution 2530 measured `729.637`, `731.718`, and `729.511 us`:
median `729.637 us`, or `1.506930 PFLOP/s`. Protocol: device 2, `rand_int`, 25
warmups, 500 launches, no clock controls.

Full 8192x8192 output comparisons passed bit-exactly for `rand_int` and random
seeds 0 and 17. Each case checked 67,108,864 f16 values against the validated
dense column-major kernel.

Controlled convergence, one mechanism at a time:

| Variant | Time us | PFLOP/s |
|---|---:|---:|
| Compact padded LDS | 758.346 | 1.449881 |
| Scalar SRD/M0 cadence | 751.801 | 1.462504 |
| Loop-carried LDS read addresses | 747.130 | 1.471647 |
| Early next-buffer M0 base | 743.238 | 1.479353 |
| Odd-SIMD event staggering, packed output | 733.947 | 1.498080 |
| LDS dense-output transpose | 749.273 | 1.467438 |
| Transposed MFMA lanes, direct dense stores | 733.978 | 1.498017 |

LDS read address carry removes address setup from the first MFMA phase. Early
M0 setup fills remaining scalar issue holes. Odd-SIMD staggering shifts DMA,
barrier, and LDS-read pressure without changing token legality.

Dense output needs coalesced lanes. Replacing the LDS transpose with correct
but scattered direct stores regressed to `836-843 us`. The accepted version
swaps MFMA operands in place, transposes destination accumulator tiles, packs
eight adjacent M values, and emits 32 `buffer_store_dwordx4` instructions per
wave. In-place rewriting matters: moving operand uses to another scheduled
MFMA can read a register before its defining LDS load or after reuse.

Physical accumulator tile row 7 is rotated: `a224` holds logical column 7,
`a228` holds column 0, through `a252` holding column 6. The transpose absorbs
that allocation permutation; the epilogue stays regular.

Compiler reproduction uses four mechanisms:

1. Carry DMA buffer bases and source pointers through loop SSA.
2. Model shared LDS issue resources across resident waves.
3. Jointly schedule cloned loop branches with bounded greedy lookahead.
4. Select lane-transposed MFMA output with cross-fragment f16 packing.

No post-greedy schedule veto. Each improvement belongs in IR layout or the
greedy scheduler/model.

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

### Padded LDS A/B

Per-tile LDS padding is not the missing gap. Both hipBLASLt layouts were tested
without changing phased token topology:

| Layout | LDS | M0 step | Median us | PFLOP/s |
|---|---:|---:|---:|---:|
| Wave baseline | 131,072 B | `0x1000` | 777.907 | 1.413423 |
| solution 2530 layout | 133,120 B | `0x1040` | 780.641 | 1.408473 |
| solution 2531 layout | 135,168 B | `0x1080` | 778.682 | 1.412016 |

Each row used 25 warmups, 500 timed launches, three repeats, and `rand_int`
seed 0. Baseline samples were `776.610`, `781.656`, and `777.907 us`.
The 16-byte samples were `780.641`, `777.823`, and `781.113 us`; the 32-byte
samples were `780.487`, `777.432`, and `778.682 us`.

Both padded kernels passed strict positional random-data checking at
`1024x512x256` with `max_abs_diff=0`. Padding reduced allocation to 392 VGPR
address slots and 136 AGPRs, but did not improve execution time. Active profile
stays unpadded.

### Barrier lookahead A/B

Bounded 24-instruction lookahead moved loop barriers from MFMA ordinals
`24,49` to `24,50,98`. Remaining three DMA requests then clustered after the
last barrier. Median regressed from `777.907 us` to `792.656 us`, or from
1.413423 to 1.387048 PFLOP/s. Samples were `793.836`, `791.766`, and
`792.656 us` with the baseline protocol.

Strict positional random-data checking at `1024x512x256` passed with
`max_abs_diff=0`. Delay-to-loop-end also passed correctness but regressed to
`818.306 us`. Barrier delay alone does not reproduce hipBLASLt cadence.

### Bulk LDS-read fence A/B

An explicit workgroup barrier drained all 16 carried LDS reads at loop tail.
It removed eight `lgkmcnt(7)` waits from loop entry, but median regressed to
`789.961 us`, or 1.391856 PFLOP/s. Samples were `789.961`, `811.833`, and
`788.190 us`. Strict random-data checking passed with `max_abs_diff=0`.

Cross-wave synchronization costs more than the removed wait instructions.
A per-wave wait with an SSA completion token was also tested. The token fed
the next iteration's `current_access`, preventing arbitrary scheduler motion.
It removed the entry waits without `s_barrier`, but still regressed to
`787.996 us`, or 1.395326 PFLOP/s. Samples were `789.251`, `787.432`, and
`787.996 us`; strict random-data checking passed with `max_abs_diff=0`.

### hipBLASLt DMA-cohort A/B

Regrouping DMA requests into hipBLASLt's `5/5/3/3` cohorts without moving
the compute cuts placed barriers after MFMA 25 and 49. Median regressed to
`801.810 us`, or 1.371287 PFLOP/s. Samples were `799.705`, `824.065`, and
`801.810 us`; strict random-data checking passed with `max_abs_diff=0`.

Cohort shape alone is not the optimization. hipBLASLt's matching MFMA and LDS
read cadence must be evaluated separately.

### MFMA-cut A/B

Flattening phase-0 compute ranges moved the two generated barriers exactly to
MFMA 22 and 52 without changing the accepted DMA grouping. Median regressed to
`789.534 us`, or 1.392608 PFLOP/s. Samples were `789.534`, `785.515`, and
`789.998 us`; strict random-data checking passed with `max_abs_diff=0`.

Barrier ordinals alone do not reproduce hipBLASLt's overlap. LDS-read cadence
and the third readiness phase remain coupled to those cuts.

Spreading the first eight LDS reads across MFMAs `1,3,...,15` while retaining
the 22/52 cuts recovered part of the loss. Median was `785.355 us`, or
1.400019 PFLOP/s. Samples were `789.518`, `785.355`, and `784.924 us`; strict
random-data checking passed with `max_abs_diff=0`. The accepted 24/49 cadence
remains faster.

Removing greedy's forced no-wait barrier chaining retained the third barrier
at MFMA 98 with `vmcnt(13)`. Median regressed to `793.203 us`, or 1.386167
PFLOP/s. Samples were `794.882`, `793.203`, and `790.698 us`; strict random
checking passed with `max_abs_diff=0`. Matching the no-drain barrier without
matching surrounding DMA placement is insufficient.

The same scheduler-only change on the accepted 24/49 pipeline retained a
third barrier at MFMA 96 with `vmcnt(13)`. Median was `787.393 us`, or
1.396395 PFLOP/s. Samples were `787.393`, `805.263`, and `785.536 us`; strict
random checking passed with `max_abs_diff=0`. Forced barrier chaining remains
enabled because its contraction is faster for the current token topology.

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

The backend emits three encoded NOPs after each 32-byte alignment directive.
Both specialized loop heads therefore start at byte phase 12. This removes the
remaining fetch-sensitive gap without changing loop dependencies or clocks.

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

hipBLASLt solution 2530 advances direct-to-LDS M0 by `0x1040` and allocates
130 KiB LDS. Solution 2531 uses `0x1080` and 132 KiB. Dense Wave uses `0x1040`
and 130 KiB; cache-line padding alone has no measured performance credit.

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
- 1.5-class manual Wave ASM:
  `docs/PerfReferences/wave-gfx950-f16-8192-4wave-cacheline-padded-phased-oracle-lds-read-carry-m0-early-parity-stagger-coalesced-column-major.s`.
- Manual Wave ASM SHA-256:
  `c2766f867d726c0f364dcc05939952af3c5ef89507b15ec34d5c51f738884605`.
- Manual Wave ASM lines/bytes: 1,831 / 78,559.
- Rejected 16-byte padding ASM:
  `docs/PerfReferences/wave-gfx950-f16-8192-4wave-padded-16b.s`, SHA-256
  `efecefe116bea7aa6b98c8f30ebb76468146339018964f757499a95d59525ee2`.
- Rejected 32-byte padding ASM:
  `docs/PerfReferences/wave-gfx950-f16-8192-4wave-padded-32b.s`, SHA-256
  `3053965c40c4fb7fb31f2576d9ce0dd546e13e5fb894c7a9d60514772b7cc48e`.
- Rejected 24-instruction barrier-lookahead ASM:
  `docs/PerfReferences/wave-gfx950-f16-8192-4wave-barrier-lookahead24-rejected.s`,
  SHA-256
  `e0e85e5b5d207241b53ec8f7f3acd1ee5521d9b5232cd941cc69544db2f979fd`.
- Rejected bulk-read workgroup-barrier ASM:
  `docs/PerfReferences/wave-gfx950-f16-8192-4wave-bulk-barrier-rejected.s`,
  SHA-256
  `d6c9579e9de99d4e43687ed37d94934c6d70ba227fb5c2a466eb4dc730826090`.
- Rejected loop-carried token-wait ASM:
  `docs/PerfReferences/wave-gfx950-f16-8192-4wave-token-wait-rejected.s`,
  SHA-256
  `5c328477496eae83c01b6ab3cbf7b734de9b290766ef7902910ad24455b0e60f`.
- Rejected `5/5/3/3` DMA-cohort ASM:
  `docs/PerfReferences/wave-gfx950-f16-8192-4wave-cohorts-5-5-3-3-rejected.s`,
  SHA-256
  `e20e541af442f103763ca2fa0e4e8444f2290137f23fad0df26b3f9c59f034cd`.
- Rejected 22/52 MFMA-cut ASM:
  `docs/PerfReferences/wave-gfx950-f16-8192-4wave-cuts-22-52-rejected.s`,
  SHA-256
  `bd9e2d3f1feabd584647083a27c4264bdddf3bf9b72a4f9c138ae3200ea86e97`.
- Rejected 22/52 cut plus hipBLASLt-style LDS-read cadence ASM:
  `docs/PerfReferences/wave-gfx950-f16-8192-4wave-cuts-reads-rejected.s`,
  SHA-256
  `a484dd4ff3306c2905af1f78dfd18688f5c919f41af16e6bc7c57cd72e8a11b1`.
- Rejected 22/52/98 three-barrier ASM:
  `docs/PerfReferences/wave-gfx950-f16-8192-4wave-three-barrier-rejected.s`,
  SHA-256
  `f2c0a78cb69b5f70356977cf6441c6b27262df4decd328a45d1ee654daffe369`.
- Rejected scheduler-only no-barrier-chaining ASM:
  `docs/PerfReferences/wave-gfx950-f16-8192-4wave-no-barrier-chaining-rejected.s`,
  SHA-256
  `1d42d534a8c2194c0cee76c9329ec1209a01ef581d8355759d5a46fd6dfef14e`.

## Commands

Generate and check ISA:

```bash
python test/PerfGolden/test_gfx950_f16_256x256_4wave_specialized.py \
  --build-dir build \
  --generated-out /tmp/gfx950-f16-256x256-4wave-specialized.s
```

Run hardware calibration:

```bash
ROCR_VISIBLE_DEVICES=2 \
python tools/wave-matmul-calibrate/wave-matmul-calibrate.py \
  --chip=gfx950 --build-dir=build \
  --kernel-profile=gfx950-f16-256x256-4wave \
  --m=8192 --n=8192 --k=8192 --variants=scheduled \
  --multi-wave-specialize \
  --iters=500 --warmup=25 --repeats=7 --rand-int --no-check \
  --hipcc="$(command -v hipcc)"
```
