# Wave gfx950 f16 GEMM Four-Wave Experiment

## Result

`gfx950-f16-256x256-4wave` keeps the 256x256x64 CTA tile but assigns one
128x128 output tile to each of four wave64 waves. It reached
`1.343401 PFLOP/s` on MI350X device 2. The locked eight-wave kernel remains
faster. Post-rebase validation measured `821.162 us`, `1.338970 PFLOP/s`.

- Shape: `M=N=K=8192`.
- Types: f16 A/B/C, f32 accumulation.
- Input: `rand_int`, seed 0.
- Launch: grid `32x32x1`, block `256x1x1`.
- Dynamic LDS: 131,072 bytes.
- Clock controls: not used.

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

Median: `818.454 us`, `1.343401 PFLOP/s`. A same-device five-run eight-wave
check measured `785.121 us`, `1.400436 PFLOP/s`. Four-wave is `33.333 us`,
or 4.246%, slower.

The `M=N=K=512` runtime check passed with `max_abs_diff=0`.

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
PhasedDmaSchedule.issue_group_size=7
PhasedDmaSchedule.initial_delay_cycles=0
PhasedDmaSchedule.loop_delay_cycles=0
PhasedDmaSchedule.loop_overlap_cycles=0
PhasedDmaSchedule.delayed_waves=0
PhasedDmaSchedule.fetch_alignment=4
PhasedDmaSchedule.fetch_phase=0
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
VGPR address space: 412
VGPRs below AGPR base: 256
AGPRs used: 156
SGPRs: 24
spills: 0
static f16 MFMAs: 384
static direct-to-LDS loads: 48
static LDS reads: 96
static workgroup barriers: 3
```

Combined register pressure fits the one-wave-per-SIMD target. Bank placement
is not an acceptance constraint.

hipBLASLt's four-wave reference still differs structurally: its direct-to-LDS
M0 cadence advances by `0x1080` and allocates 130 KiB LDS. Wave advances by
`0x1000` in an unpadded 128 KiB layout. Reproducing that padded/swizzled LDS
mapping is separate work; delay tuning around the current layout did not close
the gap.

## Artifacts

- ASM: `test/PerfGolden/Inputs/gfx950-f16-256x256-4wave.s`.
- Generator/check: `test/PerfGolden/test_gfx950_f16_256x256_4wave.py`.
- ASM SHA-256:
  `2b0c5e0545c4218d285f8642b2f9486fa3789d4206f737faedd79d552a984a8d`.
- Lines/bytes: 1,236 / 55,840.

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
