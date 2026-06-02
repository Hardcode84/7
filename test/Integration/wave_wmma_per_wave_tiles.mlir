// REQUIRES: host-supports-amdgpu-wmma, wave-python-bindings
//
// Per-wave tiling on gfx11 wmma. Without the regalloc duplicate-init
// split, two accumulator iter_args fed by the same fragment_fill SSA
// value collapse onto one physical VGPR tuple and the second tile's
// mma silently clobbers the first. The matrix below exercises the
// per-wave M, N, and K tiling axes individually and in combination.
//
// 2x2 M/N tiling, single wave per workgroup, K loop runs once:
// RUN: %python %S/../../examples/wave/wmma_matmul_tiled.py --chip=%chip --m=32 --n=32 --k=32 --bm=1 --bn=1 --wave-m-tiles=2 --wave-n-tiles=2 --use-buffer --compare-cpu --seed=3 \
// RUN:   | FileCheck %s --check-prefix=MN22
//
// MN22: CPU comparison passed
//
// Per-wave M tiling only (wmma A-frag stride sanity):
// RUN: %python %S/../../examples/wave/wmma_matmul_tiled.py --chip=%chip --m=32 --n=16 --k=32 --bm=1 --bn=1 --wave-m-tiles=2 --wave-n-tiles=1 --use-buffer --compare-cpu --seed=5 \
// RUN:   | FileCheck %s --check-prefix=M2
//
// M2: CPU comparison passed
//
// Per-wave N tiling only (wmma B-frag stride sanity):
// RUN: %python %S/../../examples/wave/wmma_matmul_tiled.py --chip=%chip --m=16 --n=32 --k=32 --bm=1 --bn=1 --wave-m-tiles=1 --wave-n-tiles=2 --use-buffer --compare-cpu --seed=7 \
// RUN:   | FileCheck %s --check-prefix=N2
//
// N2: CPU comparison passed
//
// f16 C output: CPU reference is rounded to f16 before comparison.
// RUN: %python %S/../../examples/wave/wmma_matmul_tiled.py --chip=%chip --m=16 --n=16 --k=32 --bm=1 --bn=1 --use-buffer --output-type=f16 --compare-cpu --seed=13 \
// RUN:   | FileCheck %s --check-prefix=F16OUT
//
// F16OUT: CPU comparison passed
//
// bf16 A/B input path:
// RUN: %python %S/../../examples/wave/wmma_matmul_tiled.py --chip=%chip --m=32 --n=32 --k=32 --bm=1 --bn=1 --wave-m-tiles=2 --wave-n-tiles=2 --use-buffer --input-type=bf16 --compare-cpu --seed=17 \
// RUN:   | FileCheck %s --check-prefix=BF16
//
// BF16: CPU comparison passed
//
// K=64 with --wave-k-tiles=2 (collapses K loop to a single fragment
// group, exercises the multi-K-step LDS slot layout):
// RUN: %python %S/../../examples/wave/wmma_matmul_tiled.py --chip=%chip --m=32 --n=32 --k=64 --bm=1 --bn=1 --wave-m-tiles=2 --wave-n-tiles=2 --wave-k-tiles=2 --use-buffer --compare-cpu --seed=11 \
// RUN:   | FileCheck %s --check-prefix=K2
//
// K2: CPU comparison passed
//
// Multi-wave workgroup + per-wave 2x2 tiling (4 waves, 16 output
// tiles, K loop runs):
// RUN: %python %S/../../examples/wave/wmma_matmul_tiled.py --chip=%chip --m=64 --n=64 --k=64 --bm=2 --bn=2 --wave-m-tiles=2 --wave-n-tiles=2 --use-buffer --compare-cpu --seed=42 \
// RUN:   | FileCheck %s --check-prefix=WG22
//
// WG22: CPU comparison passed
