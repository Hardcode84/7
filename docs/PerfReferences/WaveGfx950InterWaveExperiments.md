# Wave gfx950 Inter-Wave GEMM Experiments

Date: 2026-07-26 to 2026-07-27. Devices: MI350X devices 2 and 3.
Shape: f16 `M=N=K=8192`. Clock controls were not used.

## Matched TLX Closure

Final comparison used device 3, 50 warmups, 500 timed launches, and median
of five runs. Wave used profile `gfx950-f16-256x256-8wave-spatial`.

| Kernel | HPL us | HPL PFLOP/s | Random us | Random PFLOP/s |
|---|---:|---:|---:|---:|
| Ordinary Wave 8-wave | 953.663 | 1.152935 | 795.965 | 1.381357 |
| TLX inter-wave | 929.5 | 1.1829 | 749.3 | 1.4673 |
| Wave spatial inter-wave | 912.111 | 1.205458 | 731.913 | 1.502244 |

Spatial Wave is 1.9% faster than TLX on HPL and 2.4% faster on random
inputs. Against ordinary Wave, throughput improves 4.6% and 8.8%.

Strict random correctness passed at `M=1024,N=512,K=256` and at
`M=N=256,K=8192`, both with `max_abs_diff=0`. The latter executes the
63-iteration steady loop. The checked-in PerfGolden is byte-identical to the
measured HSACO's assembly.

### Required Structure

Each wave reads four top and four bottom A tiles, plus two left and two right B
tiles. Four 16-MFMA quadrants alternate compute and memory stages:

```text
s_setprio 0
s_waitcnt vmcnt(10) lgkmcnt(0)
s_barrier
16 x v_mfma_f32_16x16x32_f16
s_setprio 1
s_barrier
buffer_load_dwordx4 + ds_read_b128
```

Waves 4-7 take a conditional entry barrier. Waves 0-3 take the matching exit
barrier. This offsets cohorts by one stage. Compute barriers consume the DMA
and LDS tokens needed by the next quadrant. Post-MFMA barriers consume only
the compute barrier token, leaving them free of the DMA wait.

The steady loop emits two K64 steps per branch. This K128 body preserves the
236-VGPR, 26-SGPR, zero-spill allocation.

All machinery is expressed in the Wave Python DSL. Compiler support is the
existing token, barrier, priority, and generic scheduling path.

### Causal Experiments

| Variant | HPL us | Random us | Result |
|---|---:|---:|---|
| Spatial quadrants, no cohort shift | - | 827.6 | Reject |
| Cohort shift, one barrier | - | 862.4 | Reject |
| Split compute/memory barriers, no shift | - | 908.4 | Reject |
| Shift + split barriers, K64 | 951.475 | 751.325 | Keep |
| Shift + split barriers, K128 | 937.257 | 756.511 | HPL only |
| DMA wait on compute barrier, K128 | 912.111 | 731.913 | Final |

Phase shift and split barriers are coupled. Either alone regresses. Moving the
DMA dependency from the post-MFMA barrier to the next compute barrier closes
the remaining gap.

### Counters

Single-dispatch `rocprofv3` counter collection perturbs wall time. Counts below
compare the hot dispatch only.

| Counter | Spatial, no shift | Shift + split, K64 | Final K128 | TLX |
|---|---:|---:|---:|---:|
| `SQ_BUSY_CYCLES` | 47,022,966 | 40,048,872 | 38,547,407 | 38,737,773 |
| `SQ_WAIT_INST_ANY` | 367,317,946 | 312,667,239 | 303,571,797 | 321,242,064 |
| `SQ_WAIT_INST_LDS` | 61,722,453 | 60,575,796 | 59,415,323 | 60,142,067 |
| `SQ_LDS_CMD_FIFO_FULL` | 18,623,105 | 504,611 | 488,558 | 255,459 |
| `SQ_WAIT_ANY` | 243,945,554 | 180,043,252 | 181,881,129 | 156,066,502 |
| `SQ_INSTS_BRANCH` | 1,032,192 | 1,048,576 | 532,480 | 565,248 |
| `SQ_INST_CYCLES_SALU` | 23,363,584 | 23,519,232 | 15,745,024 | 11,345,920 |

## Earlier Experiments

Timings use 25 warmups. Baseline and K128 report median of five 500-launch
runs. Staggered variants report median of three 250-launch runs.

| Variant | HPL us | HPL PFLOP/s | Random us | Random PFLOP/s | Result |
|---|---:|---:|---:|---:|---|
| Current 8-wave | 952.880 | 1.153883 | 794.785 | 1.383408 | Baseline |
| K128 outer unroll | 950.007 | 1.157372 | 799.629 | 1.375027 | Reject |
| 32-MFMA cohort phase | 1321.286 | 0.832153 | 1226.058 | 0.896786 | Reject |
| 16-MFMA cohort phase | 1676.001 | 0.656033 | 1636.083 | 0.672039 | Reject |
| 16-MFMA phase + priority | 1672.526 | 0.657396 | 1630.638 | 0.674283 | Reject |
| Fixed DMA descriptor | - | - | - | - | Incorrect |

K128 improves HPL by 0.30% and regresses random by 0.61%. No measured
variant clears the no-regression bar.

## Cohort Ring

Waves 0-3 skip the entry barrier. Waves 4-7 execute it. Each loop phase ends
with a workgroup barrier; waves 0-3 execute the matching exit barrier.

The 16-MFMA form releases 4, 8, 4, then 8 future LDS fragments as current
fragments die. Uniform six-read phases exceed the 256-VGPR occupancy budget.
DMA-to-LDS tokens must drain at every phase: draining only at wraparound fails
strict random correctness. The correct form spends most of the loop in VMEM
waits and barriers.

One 32-MFMA phase per K slice needs only the wraparound drain. It passed ten
launches for four random seeds, but remains 27.9% slower on HPL and 35.2%
slower on random inputs.

`s_setprio 1` around each memory cluster, reset to zero before the barrier,
adds eight static instructions. It recovers 0.2-0.3% from the rejected
16-MFMA form.

## K128

Unrolling two K64 bodies under one loop branch passes strict random
correctness. Static body size grows from 192 to 256 MFMAs and allocation grows
from 240 to 256 VGPRs. The random-input regression rejects it.

## Descriptor Carry

Forcing DMA buffers to retain one descriptor and advance K through scalar
`soffset` reduces SGPRs from 24 to 20. A cold launch can pass, but the second
launch fails strict random correctness. DMA descriptor-base carries and their
issue-token lifetime cannot be replaced by the current offset-stride path.

No performance result was recorded for invalid ISA. A future invariant form
needs a structural per-request address and an explicit lifetime proof; do not
remove the descriptor carry.

## Static ISA

| Variant | VGPR | SGPR | MFMA | DMA-to-LDS | LDS reads | Barriers | `s_setprio` |
|---|---:|---:|---:|---:|---:|---:|---:|
| Baseline | 240 | 24 | 192 | 24 | 72 | 3 | 0 |
| K128 | 256 | 24 | 256 | 32 | 96 | 4 | 0 |
| 32-MFMA | 240 | 28 | 192 | 24 | 72 | 7 | 0 |
| 16-MFMA | 256 | 28 | 192 | 24 | 72 | 9 | 0 |
| 16-MFMA + priority | 256 | 28 | 192 | 24 | 72 | 9 | 8 |
| Fixed descriptor | 240 | 20 | 192 | 24 | 72 | 3 | 0 |

## Artifacts

- `wave-gfx950-f16-8192-8wave-spatial-pingpong.s`
- `tlx-gfx950-f16-8192-interwave-reference.s`
- `wave-gfx950-f16-8192-8wave-interwave-baseline.s`
- `wave-gfx950-f16-8192-8wave-k128-rejected.s`
- `wave-gfx950-f16-8192-8wave-interwave-stagger-k32-rejected.s`
- `wave-gfx950-f16-8192-8wave-interwave-stagger-k16-rejected.s`
- `wave-gfx950-f16-8192-8wave-interwave-stagger-k16-priority-rejected.s`
- `wave-gfx950-f16-8192-8wave-fixed-descriptor-invalid.s`
