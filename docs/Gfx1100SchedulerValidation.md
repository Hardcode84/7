# gfx1100 Scheduler Validation

Kernel: `examples/wave/wmma_matmul_tiled.py`, lowered through
`tools/wave-matmul-calibrate/wave-matmul-calibrate.py`.

Machine: `AMD Radeon Pro W7900 Dual Slot`, `gfx1100`.

Command shape:

```bash
CORE=$(python - <<'PY'
from pathlib import Path
import rocm_sdk_core
print(Path(rocm_sdk_core.__file__).resolve().parents[1] / "_rocm_sdk_core")
PY
)

ROCM_LIB="$CORE/lib" HIPCC="$CONDA_PREFIX/bin/hipcc" \
tools/wave-matmul-calibrate/wave-matmul-calibrate.py \
  --chip=gfx1100 --use-buffer \
  --iters=100 --warmup=20 --repeats=5 \
  --variants=baseline,scheduled \
  --m=<M> --n=<N> --k=<K> --bm=<BM> --bn=<BN>
```

`--repeats` reruns the same HSACO and reports median hardware time.
All rows below passed the CPU output check for both variants.

| Shape | Waves/WG | K | Base sim | Sched sim | Base hw | Sched hw | HW delta |
| --- | ---: | ---: | ---: | ---: | ---: | ---: | ---: |
| 32x32 | 1 | 32 | 5943 | 5178 | 10291 | 10269 | -22 (-0.2%) |
| 64x64 | 1 | 32 | 5944 | 5178 | 10357 | 10350 | -7 (-0.1%) |
| 64x64 | 1 | 64 | 11411 | 9920 | 10435 | 10428 | -7 (-0.1%) |
| 128x128 | 1 | 64 | 11412 | 9920 | 10490 | 10440 | -50 (-0.5%) |
| 256x256 | 1 | 128 | 22348 | 19404 | 11832 | 11809 | -23 (-0.2%) |
| 64x64 | 4 | 64 | 11461 | 9929 | 10783 | 10751 | -32 (-0.3%) |
| 128x128 | 4 | 64 | 11462 | 9929 | 10835 | 10778 | -57 (-0.5%) |
| 128x128 | 4 | 128 | 22397 | 19413 | 11914 | 11833 | -81 (-0.7%) |
| 256x256 | 4 | 64 | 11462 | 9929 | 11306 | 11159 | -147 (-1.3%) |
| 256x256 | 4 | 128 | 22398 | 19413 | 12832 | 12794 | -38 (-0.3%) |
| 256x256 | 4 | 256 | 44269 | 38381 | 15706 | 15339 | -367 (-2.3%) |

Result: scheduled wins 11/11 on the median hardware sample. Small
single-wave shapes are near timer noise. Longer 4-wave K shapes show the
clearest signal.

## Multi-wave scheduler scoring

Command difference:

```bash
ROCM_LIB="$CORE/lib" HIPCC="$CONDA_PREFIX/bin/hipcc" \
tools/wave-matmul-calibrate/wave-matmul-calibrate.py \
  --chip=gfx1100 --use-buffer \
  --iters=100 --warmup=20 --repeats=5 \
  --variants=baseline,scheduled,scheduled_multiwave \
  --m=<M> --n=<N> --k=<K> --bm=2 --bn=2
```

`scheduled` keeps the scheduler default model (`waves=1 simds=1`).
`scheduled_multiwave` scores candidates with `waves=4 simds=4
start_delay=0`. All rows passed the CPU output check.

Final machine MLIR for `scheduled` and `scheduled_multiwave` was byte-identical
for every row below, so selected candidate orders did not change.

| Shape | K | Base sim | Sched sim | Multi-score sim | Base hw | Sched hw | Multi-score hw | Multi vs sched |
| --- | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: |
| 64x64 | 64 | 11461 | 9929 | 9929 | 10722 | 10664 | 10691 | +27 (+0.3%) |
| 128x128 | 64 | 11462 | 9929 | 9929 | 10793 | 10756 | 10754 | -2 (0.0%) |
| 128x128 | 128 | 22397 | 19413 | 19413 | 11769 | 11739 | 11731 | -8 (-0.1%) |
| 256x256 | 64 | 11462 | 9929 | 9929 | 11294 | 11229 | 11226 | -3 (0.0%) |
| 256x256 | 128 | 22398 | 19413 | 19413 | 12628 | 12502 | 12524 | +22 (+0.2%) |
| 256x256 | 256 | 44269 | 38381 | 38381 | 15389 | 15299 | 15270 | -29 (-0.2%) |

`sim` columns use the 4-wave, 4-SIMD report. The 4-wave, 1-SIMD report also
matched between `scheduled` and `scheduled_multiwave`; only absolute totals
changed.

Result: multi-wave candidate scoring is wired and runnable, but it does not
change this matmul schedule. Hardware differences between the two scheduled
variants are within repeat noise.

Limits:

- `Base hw` is unscheduled WaveAMDMachine output, not a CK/FA-CK kernel.
- The model predicts much larger deltas than hardware. Ranking direction
  is useful here; absolute savings are not calibrated.
- CK GEMM / FA-CK attention still need a kernel import or wrapper path
  before they can join this sweep.

## Pressure-aware scheduler check

Machine: same W7900 / gfx1100. Commands used `--iters=100 --warmup=10
--repeats=3`. Scheduler budget defaults came from the target: kernel hard
VGPR/SGPR `255/101`, critical `95/101` when no `target_waves` attr was set.

Matmul command shape:

```bash
tools/wave-matmul-calibrate/wave-matmul-calibrate.py \
  --chip=gfx1100 --variants=scheduled \
  --m=32 --n=32 --k=32 --bm=1 --bn=2 \
  --iters=100 --warmup=10 --repeats=3
```

Compared with `--no-pressure-aware-schedule`, pressure-aware selection picked
the same candidate in every region: `critical_path, critical_path, wmma_feed,
critical_path, critical_path`. Max VGPR was `22, 31, 45, 29, 33`, below the
critical budget. Final sim cycles matched: `5137` for `(waves=1, simds=1)` and
`5137` for `(waves=2, simds=2)`.

| Matmul policy | HW cycles samples | Median cycles | Median us | Check |
| --- | --- | ---: | ---: | --- |
| no pressure | 6937,10464,10362 | 10362 | 5.888 | passed |
| pressure-aware | 10467,10344,10451 | 10451 | 5.938 | passed |

Result: pressure policy is neutral on this matmul shape. The +89-cycle median
delta is timing noise; selected orders and model output are unchanged.

FlashAttention command shape:

```bash
tools/wave-fa-calibrate/wave-fa-calibrate.py \
  --chip=gfx1100 --variants=scheduled \
  --seq-n=<16-or-32> --iters=100 --warmup=10 --repeats=3
```

For `seq_n=16`, no-pressure scheduling selected the aggressive
`critical_path` order: post-lowering sim `1292`, candidate max VGPR `153`.
Pressure-aware scheduling rejected that order because `153 > 95`
(`vgpr_critical_excess=58`) and kept original order: post-lowering sim `48244`,
candidate max VGPR `21`.

| FA seq_n=16 policy | HW cycles samples | Median cycles | Median us | Check |
| --- | --- | ---: | ---: | --- |
| no pressure | 7075,10873,10886 | 10873 | 6.178 | passed |
| pressure-aware | 19012,19047,18987 | 19012 | 10.802 | passed |

Result: occupancy-safe scheduling regresses this small FA kernel by `+8139`
cycles (`+74.9%`) versus the high-pressure order. Reason is deliberate: current
policy protects target-wave occupancy and regalloc headroom before cycle score.

For `seq_n=32`, old no-pressure scheduled lowering failed in
`waveamd-reg-alloc` with "ran out of registers". Pressure-aware baseline and
scheduled variants both lowered and passed.

| FA seq_n=32 variant | Sim cycles | HW cycles samples | Median cycles | Median us | Check |
| --- | ---: | --- | ---: | ---: | --- |
| baseline | 96118 | 28487,28375,28497 | 28487 | 16.186 | passed |
| scheduled | 96118 | 28508,28492,28512 | 28508 | 16.198 | passed |

Result: pressure-aware scheduling fixes the seq_n=32 regalloc failure. It also
keeps the schedule at baseline, so the measured `+21` cycles (`+0.1%`) is noise.

## FlashAttention multi-wave D sweep

Command shape:

```bash
CORE=$(python - <<'PY'
from pathlib import Path
import rocm_sdk_core
print(Path(rocm_sdk_core.__file__).resolve().parents[1] / "_rocm_sdk_core")
PY
)

ROCM_LIB="$CORE/lib" HIPCC="$CONDA_PREFIX/bin/hipcc" \
tools/wave-fa-calibrate/wave-fa-calibrate.py \
  --chip=gfx1100 --variants=baseline,scheduled \
  --block-m=1 --block-n=<BN> --seq-n=<SN> --head-dim=<D> \
  --sim-waves=<waves/WG> --sim-simds=<waves/WG> \
  --iters=100 --warmup=10 --repeats=3
```

All rows passed the CPU output check. Scheduled selected the original order for
both rows; pressure-aware critical-path candidates were too register-heavy.

| Shape | Waves/WG | Sim waves/SIMDs | Base sim | Sched sim | Base hw samples | Sched hw samples | Base hw | Sched hw | HW delta |
| --- | ---: | --- | ---: | ---: | --- | --- | ---: | ---: | ---: |
| block_m=1 block_n=4 seq_n=8 D=64 | 2 | 2/2 | 172912 | 172912 | 57263,42821,43001 | 42742,42777,42721 | 43001 | 42742 | -259 (-0.6%) |
| block_m=1 block_n=2 seq_n=4 D=128 | 4 | 4/4 | 171616 | 171616 | 38098,42236,42357 | 42395,42438,42348 | 42236 | 42395 | +159 (+0.4%) |

Result: the Wave FA builder now covers D64/D128 multi-wave workgroups and
lowers/runs through the same baseline/scheduled path. Scheduling is neutral on
these shapes until the pressure model can find a legal lower-pressure
interleave.
