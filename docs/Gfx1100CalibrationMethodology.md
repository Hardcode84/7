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
