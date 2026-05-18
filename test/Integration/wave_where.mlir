// REQUIRES: host-supports-amdgpu
//
// `wave.where` integration smoke. The kernel walks one wave (32 lanes)
// across a 32-i32 buffer pre-filled with a sentinel; only lanes whose
// id is strictly below the runtime `limit` write their lane id, the
// rest must keep the sentinel.
//
// RUN: wave-opt %s \
// RUN:   --wave-compile-kernels='chip=%chip' \
// RUN:   --convert-scf-to-cf \
// RUN:   --gpu-to-llvm=use-bare-pointers-for-kernels=true \
// RUN:   --convert-to-llvm \
// RUN:   --reconcile-unrealized-casts \
// RUN:   | mlir-runner \
// RUN:       --shared-libs=%mlir_rocm_runtime \
// RUN:       --shared-libs=%mlir_runner_utils \
// RUN:       --shared-libs=%wave_runtime \
// RUN:       --entry-point-result=void \
// RUN:   | FileCheck %s

module attributes {gpu.container_module} {

gpu.module @kernels {
  func.func @write_under_mask(%dst: !wave.ptr<i32, #wave.global>, %limit: i32)
      attributes {gpu.kernel, wave.kernel} {
    %range = arith.constant 128 : i32
    %buffer = waveamd.make_buffer %dst, %range
        : !wave.ptr<i32, #wave.global>, i32 -> !wave.ptr<i32, #waveamd.buffer>
    %lane = wave.lane_id : !wave.simd<i32, 32>
    %vlimit = wave.splat %limit : i32 -> !wave.simd<i32, 32>
    %active = wave.cmpi ult %lane, %vlimit
        : !wave.simd<i32, 32>, !wave.simd<i32, 32> -> !wave.mask<32>
    %ptrs = wave.ptr_add %buffer, %lane
        : !wave.ptr<i32, #waveamd.buffer>, !wave.simd<i32, 32>
        -> !wave.simd<!wave.ptr<i32, #waveamd.buffer>, 32>
    wave.where %active {
      %tok = wave.store %lane -> %ptrs
          : (!wave.simd<i32, 32>,
             !wave.simd<!wave.ptr<i32, #waveamd.buffer>, 32>)
          -> !wave.mem.token
      wave.yield
    } : !wave.mask<32>
    return
  }
}

func.func private @wave_memref_to_ptr_global_i32(memref<32xi32>)
    -> !wave.ptr<i32, #wave.global> attributes {llvm.emit_c_interface}

func.func private @printMemrefI32(memref<*xi32>)
    attributes {llvm.emit_c_interface}

// CHECK: [0, 1, 2, 3, 4, 5, 6, 7, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1]
func.func @main() {
  %c0 = arith.constant 0 : index
  %c1 = arith.constant 1 : index
  %c32 = arith.constant 32 : index
  %limit = arith.constant 8 : i32
  %sentinel = arith.constant -1 : i32

  %storage = memref.alloc() : memref<32xi32>
  scf.for %i = %c0 to %c32 step %c1 {
    memref.store %sentinel, %storage[%i] : memref<32xi32>
  }

  %unranked = memref.cast %storage : memref<32xi32> to memref<*xi32>
  gpu.host_register %unranked : memref<*xi32>

  %p = func.call @wave_memref_to_ptr_global_i32(%storage)
      : (memref<32xi32>) -> !wave.ptr<i32, #wave.global>

  gpu.launch_func @kernels::@write_under_mask
      blocks in (%c1, %c1, %c1) threads in (%c32, %c1, %c1)
      args(%p : !wave.ptr<i32, #wave.global>, %limit : i32)

  func.call @printMemrefI32(%unranked) : (memref<*xi32>) -> ()
  return
}

}
