// REQUIRES: host-supports-amdgpu
//
// Single-file e2e: the GPU kernel lives in a `gpu.module @kernels` carrying
// wave dialect ops; `--wave-compile-kernels` drives the wave-to-AMDGPU
// pipeline, assembles, and links to a HSACO entirely in-process, then
// replaces the source `gpu.module` with the corresponding `gpu.binary`. No
// user-visible filesystem intermediates.
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
  // `gpu.kernel` is required by `gpu.launch_func`'s symbol verifier;
  // `wave.kernel` is the marker `--wave-compile-kernels` watches for to
  // pick up the func as a Wave kernel.
  func.func @write_lane_ids(%dst: !wave.ptr<i32, #wave.global>)
      attributes {gpu.kernel, wave.kernel} {
    %range = arith.constant 128 : i32
    %buffer = waveamd.make_buffer %dst, %range
        : !wave.ptr<i32, #wave.global>, i32 -> !wave.ptr<i32, #waveamd.buffer>
    %lane = wave.lane_id : !wave.simd<i32, 32>
    %ptrs = wave.ptr_add %buffer, %lane
        : !wave.ptr<i32, #waveamd.buffer>, !wave.simd<i32, 32>
        -> !wave.simd<!wave.ptr<i32, #waveamd.buffer>, 32>
    %tok = wave.store %lane -> %ptrs
        : (!wave.simd<i32, 32>, !wave.simd<!wave.ptr<i32, #waveamd.buffer>, 32>)
        -> !wave.mem.token
    return
  }
}

func.func private @wave_memref_to_ptr_global_i32(memref<32xi32>)
    -> !wave.ptr<i32, #wave.global> attributes {llvm.emit_c_interface}

func.func private @printMemrefI32(memref<*xi32>)
    attributes {llvm.emit_c_interface}

// CHECK: [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31]
func.func @main() {
  %c0 = arith.constant 0 : index
  %c1 = arith.constant 1 : index
  %c32 = arith.constant 32 : index
  %zero = arith.constant 0 : i32

  %storage = memref.alloc() : memref<32xi32>
  scf.for %i = %c0 to %c32 step %c1 {
    memref.store %zero, %storage[%i] : memref<32xi32>
  }

  %unranked = memref.cast %storage : memref<32xi32> to memref<*xi32>
  gpu.host_register %unranked : memref<*xi32>

  %p = func.call @wave_memref_to_ptr_global_i32(%storage)
      : (memref<32xi32>) -> !wave.ptr<i32, #wave.global>

  gpu.launch_func @kernels::@write_lane_ids
      blocks in (%c1, %c1, %c1) threads in (%c32, %c1, %c1)
      args(%p : !wave.ptr<i32, #wave.global>)

  func.call @printMemrefI32(%unranked) : (memref<*xi32>) -> ()
  return
}

}
