# hipBLASLt gfx950 f16 GEMM 8192^3 Reference

## Scope

Reference for Wave's `>=1.4 PFLOP/s` f16 GEMM target. Match shape, layout,
input distribution, timer, and board state before comparing kernels.

- Shape: `M=N=K=8192`, batch 1.
- Layout: TN (`Alik_Bljk`).
- Types: f16 A/B/C/D, f32 compute.
- Scalars: alpha 1, beta 0.
- Input: `rand_int`.
- Timer: HIP events.
- Device: MI350X, gfx950, PCI ID `0x75a0`, 256 CUs, SPX/NPS1.
- Power cap: 1000 W.

At this shape, 1.4 PFLOP/s requires at most `785.365 us`.

## Source

- rocm-libraries commit: `4e51baa84a5a2a8cff3e2ecb0aa67439ff9f92b0`.
- hipBLASLt version: `100401` (1.4.1).
- ROCm SDK: conda `7.13.0a20260515`.
- assembler/offload bundler: LLVM 23.0.0 from the active conda environment.
- Logic: `gfx950/gfx950/Equality/gfx950_Cijk_Alik_Bljk_HHS_BH_BiasSH_HAS_SAV_UserArgs.yaml`.
- Logic SHA-256: `6f5ab16699a35daf2d74842f8a77bcb79fdcc486f36784f16c135b37e4d0ee4b`.

The local f16 library merged 16 default gfx950 Equality/Origami logic files:
3,352 unique kernels. TN exposed 1,004 legal solutions.

## Results

Normal heuristic, 2,000 cold and 500 timed iterations:

| Layout | PFLOP/s | Time us | Global solution |
|---|---:|---:|---:|
| NN | 1.463 | 751.372 | 1562 |
| NT | 1.445 | 760.865 | 622 |
| TN | 1.494 | 735.797 | 2530 |
| TT | 1.465 | 750.515 | 2226 |

TN sustained, 10,000 cold and 1,000 timed iterations: `1.48771 PFLOP/s`,
`739.065 us`. The selected kernel was global solution 2530:

```text
Custom_Cijk_Alik_Bljk_HHS_BH_MT256x256x64_MI16x16x1_UserArgs_shortname0_gfx950
```

The best kernel from the earlier all-solution search was global solution 2531.
Pinned with the same `rand_int` input, it measured `1.51582 PFLOP/s` at
`725.357 us` over 2,000 cold and 500 timed iterations.

Input distribution changes boost under the same cap. Solution 2531 measured
`1.21808 PFLOP/s` with `hpl` and `1.51582 PFLOP/s` with `rand_int`.
Sustained telemetry showed about 1296 MHz for `hpl` and 1612 MHz for
`rand_int`, both at 1000 W. Input mode is benchmark state, not decoration.

## Benchmark Command

Run from `~/rocm/rocm-libraries` with the active `triton-env` conda
environment and the locally built host/device library:

```bash
BUILD=projects/hipblaslt/build/perf-gfx950
export HIPBLASLT_TENSILE_LIBPATH="$BUILD/Tensile/library/gfx950"
export LD_LIBRARY_PATH="$BUILD/library:$BUILD/deps/install/lib:$LD_LIBRARY_PATH"

"$BUILD/clients/hipblaslt-bench" \
  -m 8192 -n 8192 -k 8192 \
  -r f16_r --compute_type f32_r \
  --transA T --transB N --device 2 \
  --initialization rand_int --use_gpu_timer \
  --cold_iters 10000 --iters 1000 \
  --print_kernel_info
```

Use `--algo_method index --solution_index 2531` to pin the all-search kernel.

## Standalone ASM Oracle

`hipblaslt-gfx950-f16-8192-tn-solution2530-manual.s` is the assembleable,
commented solution-2530 source. It uses the kernel's direct 104-byte ABI; the
calibration runner does not load hipBLASLt.

Build with repository LLVM and conda `hipcc`:

```bash
ASM=docs/PerfReferences/hipblaslt-gfx950-f16-8192-tn-solution2530-manual.s
OUT=build/f16-8k-reference/hipblaslt-solution2530-manual

build/llvm-install/bin/llvm-mc \
  -triple=amdgcn-amd-amdhsa -mcpu=gfx950 -filetype=obj \
  -o "$OUT.o" "$ASM"
build/llvm-install/bin/ld.lld -shared "$OUT.o" -o "$OUT.hsaco"
hipcc -O2 tools/wave-matmul-calibrate/wave-matmul-calibrate-runner.cpp \
  -o build/f16-8k-reference/wave-matmul-calibrate-runner-manual
```

Strict random check. Every output position is compared against the CPU
reference:

```bash
KERNEL=Custom_Cijk_Alik_Bljk_HHS_BH_MT256x256x64_MI16x16x1_UserArgs_shortname0_gfx950
HIP_VISIBLE_DEVICES=2 \
  build/f16-8k-reference/wave-matmul-calibrate-runner-manual \
  --m 256 --n 256 --k 512 \
  --bm 2 --bn 2 --wave-m-tiles 8 --wave-n-tiles 8 --wave-k-tiles 2 \
  --wave-size 64 --input-type f16 --c-type f16 \
  --kernel-abi hipblaslt --rand-int --iters 1 --warmup 0 \
  "$OUT.hsaco" "$KERNEL"
```

`rand_int` and generic-random seeds 0 and 17 each passed with
`max_abs_diff=0`. The custom kernel's K=64 special path is incorrect; the
standalone ABI rejects K below 128. K=128, K=512, and target K=8192 use the
validated path.

Target timing uses the same code object and `rand_int` input:

```bash
HIP_VISIBLE_DEVICES=2 \
  build/f16-8k-reference/wave-matmul-calibrate-runner-manual \
  --m 8192 --n 8192 --k 8192 \
  --bm 2 --bn 2 --wave-m-tiles 8 --wave-n-tiles 8 --wave-k-tiles 2 \
  --wave-size 64 --input-type f16 --c-type f16 \
  --kernel-abi hipblaslt --rand-int --no-check \
  --warmup 2000 --iters 500 "$OUT.hsaco" "$KERNEL"
```

Fresh process results were `727.106`, `731.790`, and `732.819 us`. Median:
`731.790 us`, `1.502496 PFLOP/s`. No clock controls were read or changed.
Generic-random seed 0 measured `754.191 us`, `1.457869 PFLOP/s`; input mode
remains part of the performance contract.

Frozen hashes:

- Annotated source: `d32b0401681a80c50027eec5c35bc3fd350d3298a9ce8603658999659396bf81`.
- Assembled object: `2ce2340e3358abedd7fa8caa9dc0f3e60bb6615429d07bca2bd693c0e100ad72`.
- Linked HSACO: `a229f6e6d190f3b5b707ce910ed16903132d38e6f35421534d3941d955514a08`.

All 16,730 encoded instructions match the extracted solution-2530 symbol.
Normalized encoding stream SHA-256:
`f5ef57fa3862db19dace70e923771844006c64c44a9e2894b69567cc251a9208`.

Annotations mark the transferable main-loop pieces: wave-parity issue
stagger, barriers after MFMA indices 21/51/92, partial `vmcnt(13)`, X0/X1
read overlap, and the `0x1040` direct-to-LDS `m0` row advance.

## ISA Artifacts

`hipblaslt-gfx950-f16-8192-tn-heuristic.s` is the complete disassembly of
solution 2530. ELF metadata:

- Tile: `256x256x64`; MI: `16x16x1`.
- Workgroup limit: 256 threads, four wave64 waves.
- LDS: 133,120 bytes.
- VGPRs: 248; SGPRs: 88; no spills.
- StreamK: 0; GSU: 1; workgroup mapping: 32.
- Range: `[0x3731d00, 0x374e6b8)`.
- Static f16 MFMA count: 640.
- ASM SHA-256: `1570128e8f6a084c35b0a4e02e22a05811c7209604c73af9313928f3f680aa1c`.

`hipblaslt-gfx950-f16-8192-tn-all-search-mainloop.s` contains solution 2531's
prologue, StreamK path, mainloop, and tail through summation end:

- Range: `[0x32a2200, 0x32a7084)`.
- Static f16 MFMA count in retained range: 640.
- ASM SHA-256: `960536ce7fdac004a98717808678d26cd1a0822067800130955aca29a6a3e3c0`.

Solution 2531's full range is `[0x32a2200, 0x340add4)`. Its generic activation
epilogue dominates artifact size and is omitted from the checked-in mainloop
reference. The extraction command below can reproduce the full symbol.

Both files are `llvm-objdump` reference disassemblies, not assembler inputs.
They came from HSACO build ID
`be2169bf4e0648e9b497180d8e4d3493bfb20789`. The uncompressed HSACO is not
checked in. Its SHA-256 is
`1bbe1c64232ed3bf89f9d742a8bd328ee7eb7ddee5fd97f9d341493efac460b0`.

## Extraction

The compressed source code object was:

```text
TensileLibrary_HH_HH_HA_Bias_SAV_UA_Type_HH_HPA_Contraction_l_Alik_Bljk_Cijk_Dijk_CU256_ID75a0_gfx950.co
```

Its SHA-256 is
`2706e83de874e5182fdc28d4961433d9ff919f9d994ea05a5568e5fae6d53c94`.
Use conda ROCm tools:

```bash
clang-offload-bundler --unbundle --type=o \
  --targets=hipv4-amdgcn-amd-amdhsa--gfx950 \
  --input="$CODE_OBJECT" --output=hipblaslt-f16-8k-tn.hsaco

llvm-objdump --disassemble --mcpu=gfx950 --no-show-raw-insn \
  --start-address=0x3731d00 --stop-address=0x374e6b8 \
  hipblaslt-f16-8k-tn.hsaco
```

## Wave Target

Wave acceptance uses the same `8192^3`, TN, f16/f32, alpha/beta, `rand_int`,
GPU-event timing, and 1000 W conditions. Record the input generator exactly;
Wave's generic random-float mode is not equivalent to hipBLASLt `rand_int`.
The existing Wave comparison ISA is
`test/PerfGolden/Inputs/gfx950-f16-256x256-16wave.s`.

`test/Integration/wave_hipblaslt_f16_profiles_runtime.mlir` runs the scheduled
4-, 8-, and 16-wave profiles with `rand_int` on hardware. Output checks decode
every accumulator slot to its logical matrix coordinate; tile sorting is not
accepted as correctness.
