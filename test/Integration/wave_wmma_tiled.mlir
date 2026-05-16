// REQUIRES: host-supports-amdgpu-wmma
//
// End-to-end check for the tiled WMMA f16xf16xf32 matmul with real
// loads.
//
// The Python helper in examples/wave emits a `gpu.module` + host `main`
// for a 16x64 x 32x64 matmul (M=16, N=64, K=32, BM=BN=1). The host
// allocates A (16*32 f16), B (64*32 f16) and C (16*64 f32), fills A
// and B with 1.0 and zeros C, registers all three buffers with the
// HIP runtime, and launches one workgroup per 16x16 output tile (4
// workgroups, 32 lanes each). Each lane uses `wave.load` to read its
// 8-dword A and B slices from global memory and `waveamd.fragment_pack`
// to bind them as WMMA fragments, accumulates four 16x16x16 MMAs, and
// stores the f32 result through `waveamd.fragment_store`.
//
// With the all-ones fill every output element equals K=32 (f32), so the
// host-side `printMemrefF32` produces an uninterrupted run of
// `32, 32, 32, ...` values.
//
// RUN: %python %S/../../examples/wave/wmma_matmul_tiled.py --m=16 --n=64 --k=32 \
// RUN:   | wave-opt --wave-compile-kernels='chip=%chip' \
// RUN:       --convert-scf-to-cf \
// RUN:       --gpu-to-llvm=use-bare-pointers-for-kernels=true \
// RUN:       --convert-to-llvm \
// RUN:       --reconcile-unrealized-casts \
// RUN:   | mlir-runner \
// RUN:       --shared-libs=%mlir_rocm_runtime \
// RUN:       --shared-libs=%mlir_runner_utils \
// RUN:       --shared-libs=%wave_runtime \
// RUN:       --entry-point-result=void \
// RUN:   | FileCheck %s
//
// One 16-wide run of `32`s is enough evidence that the WMMA tiles
// computed the right value at the (otherwise irregularly-wrapped)
// `printMemrefF32` output.
// CHECK: 32, 32, 32, 32, 32, 32, 32, 32, 32, 32, 32, 32, 32, 32, 32, 32
