// REQUIRES: host-supports-amdgpu-wave
//
// LDS mirror needs barrier-visible writes across all lanes.
//
// RUN: sed -e 's/@W@/%wave_width/g' -e 's/@LAST@/%wave_last/g' -e 's/@BYTES@/%wave_bytes/g' %s \
// RUN:   | wave-opt - --pass-pipeline='builtin.module(wave-set-target-attr{chip=%chip},transform-preload-library{transform-library-paths=%wave_pipelines},transform-interpreter{entry-point=compile_kernels},convert-scf-to-cf,gpu-to-llvm{use-bare-pointers-for-kernels=true},convert-to-llvm,reconcile-unrealized-casts)' \
// RUN:   | mlir-runner \
// RUN:       --shared-libs=%mlir_rocm_runtime \
// RUN:       --shared-libs=%mlir_runner_utils \
// RUN:       --shared-libs=%wave_runtime \
// RUN:       --entry-point-result=void \
// RUN:   | FileCheck %s --check-prefix=W%wave_width

module attributes {gpu.container_module} {

gpu.module @kernels {
  func.func @lds_mirror(%dst: !wave.ptr<#wave.global, i32>)
      attributes {gpu.kernel, wave.kernel, wave.lds_size = @BYTES@ : i64} {
    %last = arith.constant @LAST@ : i32
    %vlast = wave.splat %last : i32 -> !wave.simd<i32, @W@>

    %lane = wave.lane_id : !wave.simd<i32, @W@>
    %lds = wave.lds_base : !wave.ptr<#wave.shared, i32>

    // Write: LDS[lane] = lane.
    %store_ptrs = wave.ptr_add %lds, %lane
        : !wave.ptr<#wave.shared, i32>, !wave.simd<i32, @W@>
        -> !wave.simd<!wave.ptr<#wave.shared, i32>, @W@>
    %store_token = wave.store %lane -> %store_ptrs
        : (!wave.simd<i32, @W@>, !wave.simd<!wave.ptr<#wave.shared, i32>, @W@>)
        -> !wave.mem.token

    %barrier_token = wave.barrier %store_token : (!wave.mem.token) -> !wave.mem.token

    // All-ones lane mask mirrors order.
    %mirror = wave.binary "xori" %lane, %vlast
        : !wave.simd<i32, @W@>, !wave.simd<i32, @W@> -> !wave.simd<i32, @W@>
    %load_ptrs = wave.ptr_add %lds, %mirror
        : !wave.ptr<#wave.shared, i32>, !wave.simd<i32, @W@>
        -> !wave.simd<!wave.ptr<#wave.shared, i32>, @W@>
    %loaded:2 = wave.load %load_ptrs after %barrier_token
        : (!wave.simd<!wave.ptr<#wave.shared, i32>, @W@>, !wave.mem.token)
        -> (!wave.simd<i32, @W@>, !wave.mem.token)

    // Store back into global so the host can verify the result.
    %out_ptrs = wave.ptr_add %dst, %lane
        : !wave.ptr<#wave.global, i32>, !wave.simd<i32, @W@>
        -> !wave.simd<!wave.ptr<#wave.global, i32>, @W@>
    %final_token = wave.store %loaded#0 -> %out_ptrs after %loaded#1
        : (!wave.simd<i32, @W@>, !wave.simd<!wave.ptr<#wave.global, i32>, @W@>, !wave.mem.token)
        -> !wave.mem.token
    return
  }
}

func.func private @wave_memref_to_ptr_global_i32(memref<@W@xi32>)
    -> !wave.ptr<#wave.global, i32> attributes {llvm.emit_c_interface}

func.func private @printMemrefI32(memref<*xi32>)
    attributes {llvm.emit_c_interface}

// W32: [31, 30, 29, 28, 27, 26, 25, 24, 23, 22, 21, 20, 19, 18, 17, 16, 15, 14, 13, 12, 11, 10, 9, 8, 7, 6, 5, 4, 3, 2, 1, 0]
// W64: [63, 62, 61, 60, 59, 58, 57, 56, 55, 54, 53, 52, 51, 50, 49, 48, 47, 46, 45, 44, 43, 42, 41, 40, 39, 38, 37, 36, 35, 34, 33, 32, 31, 30, 29, 28, 27, 26, 25, 24, 23, 22, 21, 20, 19, 18, 17, 16, 15, 14, 13, 12, 11, 10, 9, 8, 7, 6, 5, 4, 3, 2, 1, 0]
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

  gpu.launch_func @kernels::@lds_mirror
      blocks in (%c1, %c1, %c1) threads in (%cw, %c1, %c1)
      args(%p : !wave.ptr<#wave.global, i32>)

  func.call @printMemrefI32(%unranked) : (memref<*xi32>) -> ()
  return
}

}
