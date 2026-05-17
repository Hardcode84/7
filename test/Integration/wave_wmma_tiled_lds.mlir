// REQUIRES: host-supports-amdgpu-wmma
//
// End-to-end check for the tiled WMMA f16xf16xf32 matmul with the
// per-K-step A/B fragment staged through LDS (`--use-lds`). The
// transport is a per-wave identity round-trip
// (`global -> simd<vector<8xi32>, 32> -> ds_store_b32` x 8 -> `s_barrier`
// -> `ds_load_b32` x 8 -> `fragment_pack`), so the math is unchanged
// from `wave_wmma_tiled_multi.mlir` and the same per-axis 1.0/2.0 fill
// pins the same C tile values (`K * a(i) * b(j)`, K=48). The kernel
// reports its `group_segment_fixed_size` (BM*BN waves * 2 fragments *
// 1024 B = 4 * 2 * 1024 = 8192) through the standard metadata path.
//
// RUN: %python %S/../../examples/wave/wmma_matmul_tiled.py --m=64 --n=64 --k=48 --bm=2 --bn=2 --use-lds \
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
// CHECK-DAG: 48, 48, 48, 48, 48, 48, 48, 48
// CHECK-DAG: 192, 192, 192, 192, 192, 192, 192, 192
