# Wave gfx950 FlashAttention

## Current-tree profile

Shape: `B=2, H=64, N=8192, D=128`, BF16 input/output, bounded random data,
eight waves, eight XCDs. The perf profile declares `|Q|, |K| <= 1`.

The current golden is
`test/PerfGolden/Inputs/gfx950-fa-b2-h64-n8192-d128-bf16-8wave.s`:

- SHA-256:
  `be83362d9062a894dd0fb66b1bd70377d5077e881b519201d03ea97ea28c19b8`
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

## Target

Shape: `B=2, H=64, N=8192, D=128`, BF16 input/output, random data.
Target is 1200 TFLOP/s with sampled reference checks.

Current eight-wave kernel measures 1070-1089 TFLOP/s. The local ROCm forward
reference measures 1090-1093 TFLOP/s; the generic AITER Triton path measures
584 TFLOP/s. No measured local implementation reaches 1200 TFLOP/s.

## Resident-wave experiments

| Profile | Allocation | Random-data result | TFLOP/s |
| --- | --- | --- | ---: |
| 8-wave baseline, `BN=64` | 240 VGPR, no spill, 8 resident waves | pass | 1070-1089 |
| 8-wave resident, `BN=32` | 128 VGPR, no spill, 16 resident waves | pass | 1013-1032 |
| 4-wave resident, `BM=128` | 128 VGPR, no spill | pass | 978-984 |
| 12-wave streamed | 160 VGPR, no spill | pass | 995-999 |
| 16-wave streamed, `BM=512` | 128 VGPR, 16 remats, no spill | pass | 991-993 |
| 8-wave `BN=64`, FP16 output state | 160 VGPR, no spill, 12 resident waves | pass | 821 |
| 8-wave `BN=64`, FP16 output state | 128 VGPR, 192 B scratch/thread | launch fault | n/a |
| 8-wave paired `BN=32` softmax | 128 VGPR, 5 LDS relief plans | pass | 706 |
| 4-wave FP32 score LDS spill | 160 VGPR, 4 LDS relief plans | pass | 790-793 |

`BN=32` reaches the requested register budget cleanly. Performance drops
because online max/sum, reductions, exponentials, and rescaling run twice as
often. Joint scheduling across two resident workgroups changes its result by
less than run-to-run noise. Priority-staggering either half of the 16 resident
waves loses about 2%.

Packing four FP32 output fragments to FP16 at loop boundaries preserves one
softmax update per 64 keys and passes the full random check
(`max_abs_diff=2.29e-4`). Pack/unpack work drops throughput to 821 TFLOP/s.
Target-four allocation still requires non-rematerializable spills.

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

Artifacts are under `build/fa-resident-20260725/`. Relevant files:

- `baseline-current.hsaco`
- `resident8-bn32-n8192.hsaco`
- `resident8-bn32-hwid-multiwg-n8192.hsaco`
- `resident8-bn64-compressed-target3-n8192.hsaco`
- `resident8-bn64-compressed-n256-codegen.s`

## Rematerialization limit

The target-four budget is 128 dwords per wave. Before K/V fragments and
softmax temporaries, the `BN=64` loop needs:

| State | Dwords |
| --- | ---: |
| FP32 output accumulators | 64 |
| BF16 Q fragments | 32 |
| FP32 score packets | 32 |
| Total | 128 |

Rematerialization already rebuilds cheap address and control DAGs. It cannot
recreate global/LDS loads, MFMA score chains, or MFMA output chains. Forced
target-three/four builds therefore move score/output state to LDS and scratch;
more aggressive remat selection cannot remove that state.

Increasing residency needs a different algorithmic live set. Narrow output
storage was measured and rejected. Reloading Q would trade 32 registers for
large repeated LDS or global traffic; storing a full `BM=256` Q tile needs
64 KiB per workgroup and prevents two-workgroup residency.

## Specialization model

Multi-wave specialization dispatches from the model's class identity:

- one workgroup filling the CU: local wave ordinal;
- multiple workgroups: physical SIMD or wave-slot parity.

A workgroup may occupy a divisor of total modeled resident waves. This lets two
eight-wave workgroups use a target-four, 16-wave model. Local wave ordinal
remains byte-stable for existing full-CU kernels.

The change is target-topology driven. It adds no attention profile checks or
schedule policy. Existing eight-wave FA performance is unchanged.

## Remaining structural options

1. Pair waves by query tile and split QK head-dimension work. Exchange partial
   scores through LDS, run softmax once, then split PV output columns. This can
   reduce Q, score, and output state per wave without duplicating MFMA work.
   LDS score exchange and producer/consumer balance are the main risks.
2. Generalize the V transpose layout to `BN=128`, retain rolling 64-key
   softmax, and double-buffer the 128-key K/V tiles. This targets barrier and
   DMA amortization, not occupancy.
3. Add an explicit FP8/block-scaled attention contract. Faster MFMA alone is
   insufficient; scale production, accuracy bounds, and reference coverage
   must be part of the variant.
4. Split K across workgroups and merge `(max, sum, numerator)` in a second
   kernel. The shape already has ample grid parallelism, so extra global
   traffic makes this a fallback rather than the next experiment.

Packed FP16 exponentials do not halve instruction count on gfx950:
`v_exp_f16` handles one half value and no packed `v_pk_exp_f16` instruction is
available. Balanced reductions and dot-product packed sums were also neutral
or slower in paired runs.
