# GFX950 Stream-K GEMM with same-kernel reduction

## Status

`gfx950-f16-256x256-4wave-streamk` is an opt-in f16 profile. The full gfx950
performance sweep includes it once as `f16-streamk`; normal f16 profile
selection is unchanged. Automatic shape-based Stream-K selection remains
disabled.

This port is based on `my/gemm` at
`dc79180b3ebf37568eaae64a662eb1c9094de840`. Source-branch performance below is
review evidence, not a current-tree performance claim.

## Kernel

The profile uses:

- one persistent workgroup per selected worker;
- the four-wave `256x256x64` f16 GEMM body;
- balanced static partitions of flattened `(tile, K iteration)` work;
- reduction-free round-robin traversal for tile-aligned partitions;
- FP32 global scratch for split-tile partials;
- device-scope last-arriver atomics;
- fixed-order reduction by the last arriving workgroup.

No workgroup spins on another workgroup. Whole tiles write the output directly.
Split tiles publish partials, increment one tile counter, and let the last
arrival reduce and store the result.

For:

```text
TM = M / 256
TN = N / 256
T  = TM * TN
I  = K / 64
W  = T * I
P  = persistent worker count
```

worker `p` owns:

```text
q = W / P
r = W % P

begin(p) = p*q + min(p, r)
end(p)   = begin(p) + q + (p < r)
```

Required shape and grid constraints:

```text
M,N > 0
K > 0
M % 256 == 0
N % 256 == 0
K % 64 == 0
1 <= P <= W
W <= INT32_MAX
```

The profile currently supports `batch=1`.

## Aligned and split cases

For `8192x8192x8192` with 256 workers:

```text
T = 1024
I = 128
W = 131072
W / P = 512 = 4 * I
```

Every worker owns four complete tiles. Generated IR omits partition, scratch,
counter, and reduction operations. Worker `p` visits
`p, p + P, p + 2P, p + 3P`.

For `2048x2048x8192` with 128 workers, 64 output tiles are divided across 128
workers. Boundary tiles use same-kernel FP32 reduction.

## Workspace

Reserve two FP32 output tiles per worker:

```text
slot_bytes    = 256 * 256 * 4
scratch_bytes = 2 * P * slot_bytes
counter_bytes = (M / 256) * (N / 256) * 4
```

| Shape | Workers | Scratch | Counters | Total |
|---|---:|---:|---:|---:|
| 8192x8192 | 256 | 134217728 B | 4096 B | 128 MiB + 4 KiB |
| 2048x2048 | 128 | 67108864 B | 256 B | 64 MiB + 256 B |

Scratch needs no initialization. Counters start at zero. Last reducers reset
their counters after output publication. One in-flight kernel sequence owns
one workspace; concurrent streams need disjoint workspaces. Failed or
interrupted launches require counter reinitialization.

## Selection policy

`--kernels=f16-streamk` selects Stream-K directly.
`--streamk-workers=N` sets the persistent grid; the sweep passes 256 when the
option is omitted. The worker count is a benchmark input, not a compiler
heuristic.

No regular f16 alias selects Stream-K. Future automatic selection needs a
workspace budget and a measured comparison of saved tail work against partial
stores, loads, atomics, barriers, and cache-locality loss. Split partitions
with little K work per contributor are poor candidates.

## Reproduction

Rebuild the complete calibration path before measurements:

```bash
cmake --build build \
  --target wave-opt wave-translate WavePythonModules -j "$(nproc)"
```

Aligned HPL comparison point:

```bash
python tools/wave-matmul-calibrate/wave-matmul-perf-sweep.py \
  --kernels=f16-streamk --m=8192 --n=8192 --k-values=8192 \
  --streamk-workers=256 --hpl
```

Underfilled split comparison point:

```bash
python tools/wave-matmul-calibrate/wave-matmul-perf-sweep.py \
  --kernels=f16-streamk --m=2048 --n=2048 --k-values=8192 \
  --streamk-workers=128 --hpl
```

Random-integer K sweep:

```bash
python tools/wave-matmul-calibrate/wave-matmul-perf-sweep.py \
  --kernels=f16-streamk --m=4096 --n=4096 \
  --k-values=512,1024,2048,3072,4096,8192,16384 \
  --streamk-workers=256 --rand-int
```

The sweep rebuilds all three tools unless `--skip-rebuild` is explicit.
Use `--dry-run --skip-rebuild` to inspect the deterministic command matrix.
Use `--check` only for smaller correctness shapes; full performance runs skip
the CPU reference by default.

`test/Integration/wave_gfx950_streamk_f16_runtime.mlir` covers random and HPL
inputs, aligned and split partitions, 1,000-launch workspace reuse, and
completion-counter reset. It uses a timeout so deadlock is a test failure.

## Evidence

Current-tree generated ASM:

| Golden | SHA-256 |
|---|---|
| Stream-K aligned | `443beedd06d87dc6c1b370a31bd79c046d5e49240d270014dccc9df412f7d557` |
| Four-wave control | `db776c0c9ff870de4c67f91f2347c10212ecb5901104d35c25b7f26919aa9ee1` |
| Four-wave specialized | `83f72664ae4e12145fd7afdaa59c88b9a8f8e09ec28121d10d856f1fb65a3a8e` |

The aligned Stream-K golden uses 392 VGPRs, 48 SGPRs, and 136 AGPRs. It has no
scratch or atomic instructions. Output stores are interleaved with the final
MFMA groups.

Source-branch measurements were collected 2026-07-26 on one idle MI350X
(`gfx950`, reported 2200 MHz):

| Input and shape | Stream-K | Four-wave control |
|---|---:|---:|
| HPL 8192x8192x8192, 256 workers | 1218.45 TFLOP/s | 1218.85 TFLOP/s |
| HPL 2048x2048x8192, 128 workers | 623.49 TFLOP/s | 510.34 TFLOP/s |

The source branch also reported a complete random-input 4096 K sweep, zeroed
completion counters, random/HPL correctness, and 31 byte-identical
non-Stream-K sweep HSACOs.

Local port validation ran on an AMD Radeon PRO W7900 (`gfx1100`). Offline
generation and software gates are valid there; gfx950 runtime correctness and
same-hardware alternating A/B measurements are waived. No current-tree
performance claim is accepted from the source-branch numbers.
