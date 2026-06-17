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

Machine: same W7900 / gfx1100. Matmul rows used `--iters=100 --warmup=10
--repeats=3`. FA rows were refreshed with `--iters=1000 --warmup=20`.
Scheduler budget defaults derive hard VGPR/SGPR caps from the target:
`255/101` here. Missing `target_waves` leaves critical occupancy budgets
disabled; explicit multi-wave targets derive them.

Matmul command shape:

```bash
tools/wave-matmul-calibrate/wave-matmul-calibrate.py \
  --chip=gfx1100 --variants=scheduled \
  --m=32 --n=32 --k=32 --bm=1 --bn=2 \
  --iters=100 --warmup=10 --repeats=3
```

Compared with `--no-pressure-aware-schedule`, pressure-aware selection stayed
within the hard cap. Max VGPR was `22, 31, 45, 29, 33`. Final sim cycles
matched: `5137` for `(waves=1, simds=1)` and `5137` for `(waves=2, simds=2)`.

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
  --seq-n=<16-or-32> --iters=1000 --warmup=20 --repeats=<3-or-5>
```

For `seq_n=16`, no `target_waves` is set, so pressure-aware selection enforces
only the hard cap. The aggressive schedule stays under the cap and is selected.

| FA seq_n=16 variant | Sim cycles | HW cycles samples | Median cycles | Median us | Check |
| --- | ---: | --- | ---: | ---: | --- |
| baseline | 26799 | 12846,13581,13526,13576,13498 | 13526 | 7.685 | passed |
| scheduled | 23468 | 12355,12358,12287,12290,12352 | 12352 | 7.018 | passed |

Result: hard-cap-only pressure selection keeps the useful schedule: `-1174`
cycles (`-8.7%`) versus baseline.

For `seq_n=32`, hard-cap selection rejects region 1 and 3 candidates with
`541` and `577` max VGPR (`255` cap), so the old no-pressure regalloc failure
path stays blocked. Safe regions can still be scheduled.

| FA seq_n=32 variant | Sim cycles | HW cycles samples | Median cycles | Median us | Check |
| --- | ---: | --- | ---: | ---: | --- |
| baseline | 190840 | 54842,50581,51628 | 51628 | 29.334 | passed |
| scheduled | 189648 | 50172,51209,51195 | 51195 | 29.088 | passed |

Result: hard-cap pressure still protects regalloc and allows a small measured
win: `-433` cycles (`-0.8%`).

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

## Beam-search compile-time scaling

Inputs were scheduler-only pre-schedule MLIR generated from the matmul and FA
calibrators. Command shape:

```bash
build/bin/wave-opt <presched.mlir> \
  --waveamd-machine-schedule='apply-schedule=1 pressure-aware-selection=1 beam-search=1'
```

`no threading` adds `--mlir-disable-threading`. Times are wall seconds. Small
cases use median of 3 runs; `fa seq32 D16` uses 1 run because it is already the
scaling cliff.

| Revision | Search shape | Case | Threaded | No threading | Output |
| --- | --- | --- | ---: | ---: | --- |
| `48b7639` | serial beam | matmul 32x32x64 | 0.06 | 0.06 | stable |
| `48b7639` | serial beam | FA seq16 D32 u4 | 1.46 | 1.46 | stable |
| `48b7639` | serial beam | FA seq16 D64 u4 | 2.20 | 2.20 | stable |
| `48b7639` | serial beam | FA seq32 D16 u4 | 15.71 | 15.64 | stable |
| `2395026` | outer-guide parallel | matmul 32x32x64 | 0.06 | 0.06 | stable |
| `2395026` | outer-guide parallel | FA seq16 D32 u4 | 1.40 | 1.44 | stable |
| `2395026` | outer-guide parallel | FA seq16 D64 u4 | 2.13 | 2.17 | stable |
| `2395026` | outer-guide parallel | FA seq32 D16 u4 | 15.49 | 15.50 | stable |
| `679b304` | gated inner expansion | matmul 32x32x64 | 0.06 | 0.06 | stable |
| `679b304` | gated inner expansion | FA seq16 D32 u4 | 1.40 | 1.45 | stable |
| `679b304` | gated inner expansion | FA seq16 D64 u4 | 2.12 | 2.17 | stable |
| `679b304` | gated inner expansion | FA seq32 D16 u4 | 15.52 | 15.46 | stable |

`stable` means threaded and `--mlir-disable-threading` output were byte-identical
for that revision and case.

Result: outer-guide parallelism gives a small win on the two FA seq16 cases and
does not perturb output. Current inner expansion threshold is above the default
beam width, so it preserves the outer-guide result. A threshold-8 trial
regressed FA seq16 timing; keep it gated until a wider-beam user exists.
