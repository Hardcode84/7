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
