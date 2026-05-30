// REQUIRES: host-supports-amdgpu-wmma
//
// Packed f16 e2e: lit hardware gate is gfx11/gfx12; target asm tests cover gfx1100.
// Backend support: gfx11 for packed f32->f16 RTZ, gfx9/gfx11 for packed f16 add/mul/fma.
//
// RUN: wave-opt %s --pass-pipeline='builtin.module(wave-set-target-attr{chip=%chip},transform-preload-library{transform-library-paths=%wave_pipelines},transform-interpreter{entry-point=compile_kernels},convert-scf-to-cf,gpu-to-llvm{use-bare-pointers-for-kernels=true},convert-to-llvm,reconcile-unrealized-casts)' \
// RUN:   | mlir-runner \
// RUN:       --shared-libs=%mlir_rocm_runtime \
// RUN:       --shared-libs=%mlir_runner_utils \
// RUN:       --shared-libs=%wave_runtime \
// RUN:       --entry-point-result=void \
// RUN:   | FileCheck %s

module attributes {gpu.container_module} {

gpu.module @kernels {
  func.func @packed_f16_math(%dst: !wave.ptr<f32, #wave.global>)
      attributes {gpu.kernel, wave.kernel} {
    %c1f = arith.constant 1.000000e+00 : f32
    %c2f = arith.constant 2.000000e+00 : f32
    %c3f = arith.constant 3.000000e+00 : f32
    %c4f = arith.constant 4.000000e+00 : f32
    %c5f = arith.constant 5.000000e+00 : f32
    %c6f = arith.constant 6.000000e+00 : f32

    %v1 = wave.splat %c1f : f32 -> !wave.simd<f32, 32>
    %v2 = wave.splat %c2f : f32 -> !wave.simd<f32, 32>
    %v3 = wave.splat %c3f : f32 -> !wave.simd<f32, 32>
    %v4 = wave.splat %c4f : f32 -> !wave.simd<f32, 32>
    %v5 = wave.splat %c5f : f32 -> !wave.simd<f32, 32>
    %v6 = wave.splat %c6f : f32 -> !wave.simd<f32, 32>

    %src32 = wave.pack %v1, %v2
        : !wave.simd<f32, 32>, !wave.simd<f32, 32>
        -> !wave.simd<vector<2xf32>, 32>
    %addend32 = wave.pack %v3, %v4
        : !wave.simd<f32, 32>, !wave.simd<f32, 32>
        -> !wave.simd<vector<2xf32>, 32>
    %mul32 = wave.pack %v2, %v3
        : !wave.simd<f32, 32>, !wave.simd<f32, 32>
        -> !wave.simd<vector<2xf32>, 32>
    %acc32 = wave.pack %v5, %v6
        : !wave.simd<f32, 32>, !wave.simd<f32, 32>
        -> !wave.simd<vector<2xf32>, 32>

    %src = wave.cast fpconvert %src32 policy {rounding = #wave.cast_rounding<rtz>}
        : !wave.simd<vector<2xf32>, 32> -> !wave.simd<vector<2xf16>, 32>
    %addend = wave.cast fpconvert %addend32 policy {rounding = #wave.cast_rounding<rtz>}
        : !wave.simd<vector<2xf32>, 32> -> !wave.simd<vector<2xf16>, 32>
    %mulv = wave.cast fpconvert %mul32 policy {rounding = #wave.cast_rounding<rtz>}
        : !wave.simd<vector<2xf32>, 32> -> !wave.simd<vector<2xf16>, 32>
    %acc = wave.cast fpconvert %acc32 policy {rounding = #wave.cast_rounding<rtz>}
        : !wave.simd<vector<2xf32>, 32> -> !wave.simd<vector<2xf16>, 32>

    %add = wave.fadd %src, %addend
        : !wave.simd<vector<2xf16>, 32>, !wave.simd<vector<2xf16>, 32>
        -> !wave.simd<vector<2xf16>, 32>
    %mul = wave.fmul %add, %mulv
        : !wave.simd<vector<2xf16>, 32>, !wave.simd<vector<2xf16>, 32>
        -> !wave.simd<vector<2xf16>, 32>
    %fma = wave.fma %mul, %src, %acc
        : !wave.simd<vector<2xf16>, 32>, !wave.simd<vector<2xf16>, 32>,
          !wave.simd<vector<2xf16>, 32> -> !wave.simd<vector<2xf16>, 32>

    %lo_h = wave.extract %fma[0]
        : !wave.simd<vector<2xf16>, 32> -> !wave.simd<f16, 32>
    %hi_h = wave.extract %fma[1]
        : !wave.simd<vector<2xf16>, 32> -> !wave.simd<f16, 32>
    %lo = wave.cast fpconvert %lo_h
        : !wave.simd<f16, 32> -> !wave.simd<f32, 32>
    %hi = wave.cast fpconvert %hi_h
        : !wave.simd<f16, 32> -> !wave.simd<f32, 32>

    %c32i = arith.constant 32 : i32
    %v32 = wave.splat %c32i : i32 -> !wave.simd<i32, 32>
    %lane = wave.lane_id : !wave.simd<i32, 32>
    %hi_lane = wave.addi %lane, %v32
        : !wave.simd<i32, 32>, !wave.simd<i32, 32> -> !wave.simd<i32, 32>

    %lo_ptrs = wave.ptr_add %dst, %lane
        : !wave.ptr<f32, #wave.global>, !wave.simd<i32, 32>
        -> !wave.simd<!wave.ptr<f32, #wave.global>, 32>
    %hi_ptrs = wave.ptr_add %dst, %hi_lane
        : !wave.ptr<f32, #wave.global>, !wave.simd<i32, 32>
        -> !wave.simd<!wave.ptr<f32, #wave.global>, 32>

    %lo_tok = wave.store %lo -> %lo_ptrs
        : (!wave.simd<f32, 32>, !wave.simd<!wave.ptr<f32, #wave.global>, 32>)
        -> !wave.mem.token
    %hi_tok = wave.store %hi -> %hi_ptrs after %lo_tok
        : (!wave.simd<f32, 32>, !wave.simd<!wave.ptr<f32, #wave.global>, 32>,
           !wave.mem.token)
        -> !wave.mem.token
    return
  }
}

func.func private @wave_memref_to_ptr_global_f32(memref<64xf32>)
    -> !wave.ptr<f32, #wave.global> attributes {llvm.emit_c_interface}

func.func private @printMemrefF32(memref<*xf32>)
    attributes {llvm.emit_c_interface}

// CHECK: 13, 13, 13, 13, 13, 13, 13, 13
// CHECK: 42, 42, 42, 42, 42, 42, 42, 42
func.func @main() {
  %c0 = arith.constant 0 : index
  %c1 = arith.constant 1 : index
  %c32 = arith.constant 32 : index
  %c64 = arith.constant 64 : index
  %zero = arith.constant 0.000000e+00 : f32

  %storage = memref.alloc() : memref<64xf32>
  scf.for %i = %c0 to %c64 step %c1 {
    memref.store %zero, %storage[%i] : memref<64xf32>
  }

  %unranked = memref.cast %storage : memref<64xf32> to memref<*xf32>
  gpu.host_register %unranked : memref<*xf32>

  %p = func.call @wave_memref_to_ptr_global_f32(%storage)
      : (memref<64xf32>) -> !wave.ptr<f32, #wave.global>

  gpu.launch_func @kernels::@packed_f16_math
      blocks in (%c1, %c1, %c1) threads in (%c32, %c1, %c1)
      args(%p : !wave.ptr<f32, #wave.global>)

  func.call @printMemrefF32(%unranked) : (memref<*xf32>) -> ()
  return
}

}
