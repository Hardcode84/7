# Wave gfx950 FlashAttention

## Current-tree profile

Shape: `B=2, H=64, N=8192, D=128`, BF16 input/output, bounded random data,
eight waves, eight XCDs. The perf profile declares `|Q|, |K| <= 1`.

The current golden is
`test/PerfGolden/Inputs/gfx950-fa-b2-h64-n8192-d128-bf16-8wave.s`:

- SHA-256:
  `2866fc967b574febc7d7e78a45bc5f751abc6b4d0dad7c8be192dd03d48f4891`
- 256 VGPR, 28 SGPR, no scratch
- 136,192 bytes dynamic LDS; fixed group segment size remains zero
- 384 BF16 MFMA instructions, 576 LDS reads, 48 DMA-to-LDS loads
- 384 exponentials, 32 packed FP32 multiplies, no online-max instructions

`qk_max_abs=1` uses the analytic fixed reference
`log2(e) * sqrt(128)`. The declared bound keeps every shifted probability in
BF16 normal range, so numerator and denominator share one constant scale.
Omitting the bound keeps adaptive online-max and rescale handling.

The eight-wave kernel uses a four-stage shared K/V ring. A conditional entry
barrier keeps the two four-wave cohorts one barrier event apart; a
complementary exit barrier restores convergence. All eight waves cooperatively
fill each tile. Explicit token edges make the trailing cohort publish previous
V at the next phase's first barrier and next K at the preceding phase's third
barrier.

Packed reduction branches cannot span scheduling barriers. Ordinary root
pairing remains enabled; unrestricted branch pairing spills 2,640 bytes per
thread here. Regeneration replaces the branch golden's eight `v_pk_add_f32`
instructions with sixteen scalar adds; every other opcode count is unchanged.
Both checked-in TLX FA goldens remain byte-identical.

Current-tree IR generation, gfx950 object assembly, HSACO linking, and
deterministic golden checks pass.

The source branch's gfx950 runs passed fifty `N=256` random checks with maximum
absolute error below `0.00135` and nine production-shape checks below
`0.000183`. Focused runs measured 1111.1-1115.6 TFLOP/s, 1113.9 median; the
final full-sweep row measured 1110.2-1112.4 TFLOP/s, 1111.1 median. A 45-row
rerun produced byte-identical HSACOs. Current host is gfx1100, so current-tree
gfx950 correctness and throughput remain unmeasured locally.

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
| Remove post-schedule packed peephole | pass | 1108.9-1109.9 |
| Degree-four FP32 `exp2` polynomial | pass, `max_abs_diff=0.0155` | 80.7 |

Priority-staggered software barriers deadlocked because conditional waves
shared one static arrival counter. Hardware arrival accounting balances the
stagger at exit. The packed MFMA peephole measured 1113.2-1115.7 TFLOP/s,
versus 1108.9-1109.9 without it. The polynomial spilled 2,236 bytes/thread.
gfx950 FP8 MFMA needs an explicit scaled-input contract.

Next useful experiment needs a smaller algorithmic live set, not a tighter
allocator budget: split query/output ownership without idle phases, or define
a block-scaled FP8 attention contract with accuracy coverage.
