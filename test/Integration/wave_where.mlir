// REQUIRES: host-supports-amdgpu-wave
//
// Masked store leaves inactive lanes at sentinel.
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
  func.func @write_under_mask(%dst: !wave.ptr<#wave.global, i32>, %limit: i32)
      attributes {gpu.kernel, wave.kernel} {
    %range = arith.constant @BYTES@ : i32
    %buffer = waveamd.make_buffer %dst, %range
        : !wave.ptr<#wave.global, i32>, i32 -> !wave.ptr<#waveamd.buffer, i32>
    %lane = wave.lane_id : !wave.simd<i32, @W@>
    %vlimit = wave.splat %limit : i32 -> !wave.simd<i32, @W@>
    %active = wave.cmpi ult %lane, %vlimit
        : !wave.simd<i32, @W@>, !wave.simd<i32, @W@> -> !wave.mask<@W@>
    %ptrs = wave.ptr_add %buffer, %lane
        : !wave.ptr<#waveamd.buffer, i32>, !wave.simd<i32, @W@>
        -> !wave.simd<!wave.ptr<#waveamd.buffer, i32>, @W@>
    wave.where %active {
      %tok = wave.store %lane -> %ptrs
          : (!wave.simd<i32, @W@>,
             !wave.simd<!wave.ptr<#waveamd.buffer, i32>, @W@>)
          -> !wave.mem.token
      wave.yield
    } : !wave.mask<@W@>
    return
  }
}

func.func private @wave_memref_to_ptr_global_i32(memref<@W@xi32>)
    -> !wave.ptr<#wave.global, i32> attributes {llvm.emit_c_interface}

func.func private @printMemrefI32(memref<*xi32>)
    attributes {llvm.emit_c_interface}

// W32: [0, 1, 2, 3, 4, 5, 6, 7, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1]
// W64: [0, 1, 2, 3, 4, 5, 6, 7, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1]
func.func @main() {
  %c0 = arith.constant 0 : index
  %c1 = arith.constant 1 : index
  %cw = arith.constant @W@ : index
  %limit = arith.constant 8 : i32
  %sentinel = arith.constant -1 : i32

  %storage = memref.alloc() : memref<@W@xi32>
  scf.for %i = %c0 to %cw step %c1 {
    memref.store %sentinel, %storage[%i] : memref<@W@xi32>
  }

  %unranked = memref.cast %storage : memref<@W@xi32> to memref<*xi32>
  gpu.host_register %unranked : memref<*xi32>

  %p = func.call @wave_memref_to_ptr_global_i32(%storage)
      : (memref<@W@xi32>) -> !wave.ptr<#wave.global, i32>

  gpu.launch_func @kernels::@write_under_mask
      blocks in (%c1, %c1, %c1) threads in (%cw, %c1, %c1)
      args(%p : !wave.ptr<#wave.global, i32>, %limit : i32)

  func.call @printMemrefI32(%unranked) : (memref<*xi32>) -> ()
  return
}

}
