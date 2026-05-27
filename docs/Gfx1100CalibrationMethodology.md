# gfx1100 Calibration Methodology

Input:

```bash
tools/wave-microbench/kernels/gfx1100_schedclass_timed.mlir
```

Harness:

```bash
tools/wave-microbench/wave-microbench.py --in-kernel-cycles \
  --kernel <kernel> --inner <N> --iters 5 --warmup 2 --buf-elems 64
```

Measured on `AMD Radeon PRO W7900 Dual Slot` (`gfx1100`, ROCm `6.3.3-74`).
Each kernel reads `HW_REG_SHADER_CYCLES` before and after the loop, stores
the two counter values in `out[0]` / `out[1]`, and uses a 20-bit unwrap:
`dt = (t1 - t0) & 0xfffff`.

Raw slopes from `N = 32, 64, 128, 256`:

| Kernel | Body | Slope cyc/iter |
| --- | --- | ---: |
| `sched_branch_loop_timed` | 1 `v_add`, loop `s_add`/`s_cmp`/branch | 22.000 |
| `sched_salu_chain_timed` | 16 dependent `s_add_i32` | 67.995 |
| `sched_valu_chain_timed` | 16 dependent `v_add_nc_u32` | 80.117 |
| `sched_vmem_store_timed` | 4 ordered `buffer_store_b32` + 4 `v_add` | 741.796 |
| `sched_lds_load_timed` | 4 `ds_load_b32` + dependent VALU consumers | 222.000 |
| `sched_barrier_timed` | 1 no-dependency `s_barrier` + 1 `v_add` | 23.000 |

Subtractions:

```text
V = (valu_slope - branch_slope) / 15 = 3.87 -> Write32Bit = 4
S = (salu_slope - branch_slope + V) / 16 = 3.12 -> WriteSALU = 3
VMEM = (vmem_slope - branch_slope - 3*V) / 4 = 177.0 -> WriteVMEM = 177
LDS = (lds_slope - branch_slope - 3*V) / 4 = 47.1 -> WriteLDS = 47
Branch = branch_slope - V - 2*S = 11.9 -> WriteBranch = 12
```

`sched_barrier_timed` measures a single wave and no memory dependency. That is
not a representative workgroup-convergence barrier, so `WriteBarrier` remains
unoverridden.

## ROCprof / ATT capture

Use The Rock ROCm payload from the active conda env. In this setup the
system `/usr/bin/rocprofv3` is ROCm 6.3.3 and does not expose ATT; the usable
frontend is The Rock's SDK `rocprofv3`.

```bash
CORE=$(python - <<'PY'
from pathlib import Path
import rocm_sdk_core

print(Path(rocm_sdk_core.__file__).resolve().parents[1] / "_rocm_sdk_core")
PY
)

"$CORE/bin/rocprofv3" --version
test -f "$CORE/lib/librocprof-trace-decoder.so"
```

Generate matmul artifacts and keep the temp directory:

```bash
tools/wave-matmul-calibrate/wave-matmul-calibrate.py \
  --m=256 --n=256 --k=16 --bm=1 --bn=1 --use-buffer \
  --iters=1 --warmup=0 --no-check --keep-tmp \
  --variants baseline,scheduled,pingpong \
  --hipcc "$CONDA_PREFIX/bin/hipcc" \
  --rocm-lib "$CORE/lib"
```

The script prints `tmp: /tmp/...`. Set `TMP` to that path:

```bash
TMP=/tmp/tmp4b56n996
```

Run ATT on the baseline kernel:

```bash
OUT=$(mktemp -d /tmp/wave-att.XXXXXX)

LD_LIBRARY_PATH="$CORE/lib${LD_LIBRARY_PATH:+:$LD_LIBRARY_PATH}" \
"$CORE/bin/rocprofv3" \
  --rocm-root "$CORE" \
  --att \
  --att-library-path "$CORE/lib" \
  --output-format json \
  -d "$OUT" \
  -o out \
  --kernel-include-regex wmma_f16_matmul_tiled \
  --att-target-cu 1 \
  --att-shader-engine-mask 0x3f \
  --att-simd-select 0x3 \
  --att-buffer-size 0x6000000 \
  -- "$TMP/wave-matmul-calibrate-runner" \
  --m 256 --n 256 --k 16 --bm 1 --bn 1 \
  --wave-m-tiles 1 --wave-n-tiles 1 --wave-k-tiles 1 \
  --iters 1 --warmup 0 --no-check \
  "$TMP/baseline/baseline.hsaco" wmma_f16_matmul_tiled

find "$OUT" -maxdepth 3 -type f | sort
```

On gfx11, `--att-simd-select 0x3` selects SIMD 3. It is not a SIMD mask.
`--att-shader-engine-mask 0x3f` traces all six shader engines on W7900.

For scheduler output, replace the final HSACO path with
`"$TMP/scheduled/scheduled.hsaco"`. For ping-pong, use
`"$TMP/pingpong/pingpong.hsaco"`.

Useful output files:

- `out_results.json`: run metadata, kernel symbols, ATT filenames, code object
  snapshot filenames.
- `stats_ui_output_agent_*_dispatch_*.csv`: aggregate per-instruction
  `Hitcount`, `Latency`, `Stall`, `Idle`.
- `ui_output_agent_*_dispatch_*/code.json`: decoded instruction rows.
- `ui_output_agent_*_dispatch_*/se*_sm*_sl*_wv*.json`: per-wave instruction
  timestamps and wave-state timeline.

Use the same frontend for PMC-only captures:

```bash
LD_LIBRARY_PATH="$CORE/lib${LD_LIBRARY_PATH:+:$LD_LIBRARY_PATH}" \
"$CORE/bin/rocprofv3" \
  --rocm-root "$CORE" \
  --pmc GRBM_GUI_ACTIVE \
  --kernel-include-regex wmma_f16_matmul_tiled \
  -d "$OUT" -o out \
  -- "$TMP/wave-matmul-calibrate-runner" ... \
  "$TMP/baseline/baseline.hsaco" wmma_f16_matmul_tiled
```

Failure modes:

- `libamdhip64.so.7 => not found`: missing `LD_LIBRARY_PATH="$CORE/lib"`.
- Empty `code.json` / no `se*_wv*.json`: traced CU/SIMD did not see the
  dispatch. Use a larger grid, or trace more shader engines (`0x3f` on W7900).
- `Stitch Incomplete`: decoder matched only part of the trace to disassembly.
  Keep the raw `.att`; importers must tolerate partial decode.
- `rocprofv2 --plugin att` from system ROCm is the old path here. Its installed
  Python wrapper imports the viewer before help/output and currently fails if
  `websockets` is absent. Prefer The Rock `rocprofv3 --att`.
