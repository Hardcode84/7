// REQUIRES: host-supports-amdgpu-wmma
//
// End-to-end check for the tiled WMMA f16xf16xf32 matmul with the A
// and B kernel inputs wrapped in `waveamd.make_buffer` (`--use-buffer`).
// Every per-K-step fragment load lowers to a tuple
// `buffer_load_b32`, which the AMDGPU printer expands into eight
// consecutive `buffer_load_dword ..., 0 offen offset:i*4` instructions
// before each fragment rides through the per-wave LDS slot. The C
// fragment store stays on the global path.
//
// The kernel math is unchanged from `wave_wmma_tiled_multi.mlir`, so
// the same per-axis 1.0/2.0 fill pins the same C tile values
// (`K * a(i) * b(j)`, K=48 -> 48 and 192 in the two checked quadrants).
//
// RUN: %python %S/../../examples/wave/wmma_matmul_tiled.py --m=64 --n=64 --k=48 --bm=2 --bn=2 --use-buffer \
// RUN:   | wave-opt --pass-pipeline='builtin.module(wave-set-target-attr{chip=%chip},transform-preload-library{transform-library-paths=%wave_pipelines},transform-interpreter{entry-point=compile_kernels},convert-scf-to-cf,gpu-to-llvm{use-bare-pointers-for-kernels=true},convert-to-llvm,reconcile-unrealized-casts)' \
// RUN:   | mlir-runner \
// RUN:       --shared-libs=%mlir_rocm_runtime \
// RUN:       --shared-libs=%mlir_runner_utils \
// RUN:       --shared-libs=%wave_runtime \
// RUN:       --entry-point-result=void \
// RUN:   | FileCheck %s
//
// CHECK-DAG: 48, 48, 48, 48, 48, 48, 48, 48
// CHECK-DAG: 192, 192, 192, 192, 192, 192, 192, 192
