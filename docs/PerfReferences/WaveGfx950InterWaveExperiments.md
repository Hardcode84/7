# Wave gfx950 Inter-Wave GEMM Experiments

Date: 2026-07-26. Device: MI350X device 2. Shape: f16
`M=N=K=8192`. Clock controls were not used.

## Results

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

- `wave-gfx950-f16-8192-8wave-interwave-baseline.s`
- `wave-gfx950-f16-8192-8wave-k128-rejected.s`
- `wave-gfx950-f16-8192-8wave-interwave-stagger-k32-rejected.s`
- `wave-gfx950-f16-8192-8wave-interwave-stagger-k16-rejected.s`
- `wave-gfx950-f16-8192-8wave-interwave-stagger-k16-priority-rejected.s`
- `wave-gfx950-f16-8192-8wave-fixed-descriptor-invalid.s`
