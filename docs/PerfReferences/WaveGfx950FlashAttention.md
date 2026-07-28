# Wave gfx950 FlashAttention

## Current-tree profile

Shape: `B=2, H=64, N=8192, D=128`, BF16 input/output, random data, eight
waves, eight XCDs.

The current golden is
`test/PerfGolden/Inputs/gfx950-fa-b2-h64-n8192-d128-bf16-8wave.s`:

- SHA-256:
  `00c84ecc0641e0d705ec7b10c5caa59b0f12221e42c0ee29da8a8016b609f9b5`
- 256 VGPR, 24 SGPR, no scratch
- 68,096 bytes dynamic LDS; fixed group segment size remains zero
- 192 BF16 MFMA instructions, 288 LDS reads, 28 DMA-to-LDS loads
- 90 packed FP32 adds replace 180 scalar FP32 adds

Current codegen, assembly, linking, and deterministic PerfGolden checks pass.
Three random seeds pass with maximum absolute error below `1.62e-4`. On an
otherwise idle gfx950, a seven-sample matched A-B-A run measured the current
assembly at 970.8 TFLOP/s versus 860.9 and 864.3 TFLOP/s for the prior
assembly. DMA completion and LDS-read completion use separate workgroup
rendezvous.

Run the checked sweep on gfx950:

```shell
python tools/wave-matmul-calibrate/wave-matmul-perf-sweep.py \
  --kernels=fa --check --csv build/gfx950-fa.csv
```

## Historical branch measurements

These results came from the `my/gemm` branch before the current-tree port.
They were recorded by `0eeabee2` and `f27a7446`; they are experiment evidence,
not current-tree measurements.

The eight-wave `BN=64` baseline passed random checks at 1070-1089 TFLOP/s.
The same local system measured its ROCm forward reference at 1090-1093
TFLOP/s. No tested branch variant reached the 1200 TFLOP/s target.

| Experiment | Allocation | Result | TFLOP/s |
| --- | --- | --- | ---: |
| Eight-wave `BN=32` | 128 VGPR | pass | 1013-1032 |
| Eight-wave `BN=128` | 256 VGPR, 134,144 B LDS | pass | 1024-1038 |
| Four-wave `BM=128` | 128 VGPR | pass | 978-984 |
| Twelve-wave streamed | 160 VGPR | pass | 995-999 |
| Sixteen-wave streamed | 128 VGPR, 16 remats | pass | 991-993 |
| Sixteen-wave QK/PV role split | 128 VGPR, 136,448 B LDS | pass | 395 |
| Eight-wave Q reload | 240 VGPR | pass | 604 |
| FP16 output state | 160 VGPR | pass | 821 |
| Forced target three | 160 VGPR, 3,872 B scratch/thread | pass | 25.1 |

`BN=32` doubles online max/sum, reduction, exponential, and rescale work.
`BN=128` halves softmax and barrier frequency but needs more LDS and still
trails `BN=64`. Role splitting leaves half the waves idle across three
full-workgroup barriers. Reloading or narrowing state cuts residency pressure
but loses more throughput than it recovers.

Rejected scheduling and ISA experiments:

| Experiment | Result | TFLOP/s |
| --- | --- | ---: |
| Independent-frontier loop replay | pass | 904-922 |
| Software split barriers, no priority stagger | pass | 921 |
| Software split barriers, shared counter | pass | 933 |
| Degree-four FP32 `exp2` polynomial | `max_abs_diff=0.0155` | 80.7 |

Priority-staggered software barriers deadlocked because conditional waves
shared one static arrival counter. The polynomial removed exponentials but
spilled 2,236 bytes/thread. gfx950 FP8 MFMA needs an explicit scaled-input
contract; converting BF16 through FP32 inside the loop is not a viable shortcut.

Next useful experiment needs a smaller algorithmic live set, not a tighter
allocator budget: split query/output ownership without idle phases, or define
a block-scaled FP8 attention contract with accuracy coverage.
