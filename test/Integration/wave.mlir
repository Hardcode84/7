// REQUIRES: host-supports-amdgpu-wave
//
// Single-file e2e: the GPU kernel lives in a `gpu.module @kernels` carrying
// wave dialect ops; `compile_kernels` emits a HSACO-bearing `gpu.binary`.
//
// RUN: sed -e 's/@W@/%wave_width/g' -e 's/@BYTES@/%wave_bytes/g' %s \
// RUN:   | wave-opt - --pass-pipeline='builtin.module(wave-set-target-attr{chip=%chip},transform-preload-library{transform-library-paths=%wave_pipelines},transform-interpreter{entry-point=compile_kernels},convert-scf-to-cf,gpu-to-llvm{use-bare-pointers-for-kernels=true},convert-to-llvm,reconcile-unrealized-casts)' \
// RUN:   | mlir-runner \
// RUN:       --shared-libs=%mlir_rocm_runtime \
// RUN:       --shared-libs=%mlir_runner_utils \
// RUN:       --shared-libs=%wave_runtime \
// RUN:       --entry-point-result=void \
// RUN:   | FileCheck %s --check-prefix=W%wave_width

module attributes {gpu.container_module} {

gpu.module @kernels {
  // `gpu.kernel` is required by `gpu.launch_func`'s symbol verifier;
  // `wave.kernel` marks funcs consumed by `compile_kernels`.
  func.func @write_lane_ids(%dst: !wave.ptr<#wave.global, i32>)
      attributes {gpu.kernel, wave.kernel} {
    %range = arith.constant @BYTES@ : i32
    %buffer = waveamd.make_buffer %dst, %range
        : !wave.ptr<#wave.global, i32>, i32 -> !wave.ptr<#waveamd.buffer, i32>
    %lane = wave.lane_id : !wave.simd<i32, @W@>
    %ptrs = wave.ptr_add %buffer, %lane
        : !wave.ptr<#waveamd.buffer, i32>, !wave.simd<i32, @W@>
        -> !wave.simd<!wave.ptr<#waveamd.buffer, i32>, @W@>
    %tok = wave.store %lane -> %ptrs
        : (!wave.simd<i32, @W@>, !wave.simd<!wave.ptr<#waveamd.buffer, i32>, @W@>)
        -> !wave.mem.token
    return
  }
}

func.func private @wave_memref_to_ptr_global_i32(memref<@W@xi32>)
    -> !wave.ptr<#wave.global, i32> attributes {llvm.emit_c_interface}

func.func private @printMemrefI32(memref<*xi32>)
    attributes {llvm.emit_c_interface}

// W32: [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31]
// W64: [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31, 32, 33, 34, 35, 36, 37, 38, 39, 40, 41, 42, 43, 44, 45, 46, 47, 48, 49, 50, 51, 52, 53, 54, 55, 56, 57, 58, 59, 60, 61, 62, 63]
func.func @main() {
  %c0 = arith.constant 0 : index
  %c1 = arith.constant 1 : index
  %cw = arith.constant @W@ : index
  %zero = arith.constant 0 : i32

  %storage = memref.alloc() : memref<@W@xi32>
  scf.for %i = %c0 to %cw step %c1 {
    memref.store %zero, %storage[%i] : memref<@W@xi32>
  }

  %unranked = memref.cast %storage : memref<@W@xi32> to memref<*xi32>
  gpu.host_register %unranked : memref<*xi32>

  %p = func.call @wave_memref_to_ptr_global_i32(%storage)
      : (memref<@W@xi32>) -> !wave.ptr<#wave.global, i32>

  gpu.launch_func @kernels::@write_lane_ids
      blocks in (%c1, %c1, %c1) threads in (%cw, %c1, %c1)
      args(%p : !wave.ptr<#wave.global, i32>)

  func.call @printMemrefI32(%unranked) : (memref<*xi32>) -> ()
  return
}

}
