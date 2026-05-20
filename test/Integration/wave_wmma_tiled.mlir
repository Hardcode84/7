// REQUIRES: host-supports-amdgpu-wmma
//
// End-to-end check for the tiled WMMA f16xf16xf32 matmul with real
// loads and non-uniform A/B fills.
//
// The Python helper in examples/wave emits a `gpu.module` + host `main`
// for a 16x64 x 32x64 matmul (M=16, N=64, K=32, BM=BN=1). The K
// accumulation runs as a runtime-driven `scf.for` (tagged
// `wave.nonzero_trip`) carrying (acc, a_ptr, b_ptr); the host passes
// `K/16` as a fourth i32 kernel arg and the selector lowers it to a
// post-tested `waveamdmachine.uniform_loop`. Each per-K-step A/B fragment
// always rides through a per-wave LDS slot (the kernel exercises tuple
// `ds_store_b32` / `ds_load_b32` and `s_barrier`), so this test also
// pins down the `wave.lds_size` -> `group_segment_fixed_size`
// propagation for the simple BM=BN=1 shape. The host allocates A
// (16*32 f16), B (64*32 f16) and C (16*64 f32) and fills them with a
// per-axis split so each output element depends on *both* matrices
// (catches "kernel happened to sum K ones" regressions):
//
//   A[i, k] = 1.0 for i in [0, 8) and 2.0 for i in [8, 16).
//   B[k, j] = 1.0 for j in [0, 32) and 2.0 for j in [32, 64).
//
// So C[i, j] = K * a(i) * b(j) takes values K, 2K, 4K -- here
// 32, 64, 128 (since K=32).
//
// The RDNA3 WMMA f32 accumulator splits the 16 output rows across the
// wave halves (lane L<16 holds rows {0,2,4,..,14} of column L%16; lane
// L>=16 holds rows {1,3,..,15}). Within each lane's 8 contiguous
// f32 dwords, rows 0..7 land in slots 0..3 and rows 8..15 land in
// slots 4..7 -- so a single lane writes "<lo>, <lo>, <lo>, <lo>,
// <hi>, <hi>, <hi>, <hi>" where <lo>/<hi> are the products picked up
// from the low/high A halves. For n_tile in {0, 1} (b=1) that is
// "32, 32, 32, 32, 64, 64, 64, 64"; for n_tile in {2, 3} (b=2) it is
// "64, 64, 64, 64, 128, 128, 128, 128".
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
// CHECK: 32, 32, 32, 32, 64, 64, 64, 64
// CHECK: 64, 64, 64, 64, 128, 128, 128, 128
