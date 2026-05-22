// REQUIRES: host-supports-amdgpu
//
// End-to-end LDS echo: every lane writes its lane id into LDS, the
// workgroup-wide `wave.barrier` lowers to `s_waitcnt lgkmcnt(0)` +
// `s_barrier`, and then each lane reads back from a "mirror" slot
// (`31 - lane`) so the result observably depends on cross-lane
// visibility. If the barrier / `group_segment_fixed_size` wiring is
// wrong the kernel either deadlocks, faults, or returns stale data.
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
  func.func @lds_mirror(%dst: !wave.ptr<i32, #wave.global>)
      attributes {gpu.kernel, wave.kernel, wave.lds_size = 128 : i64} {
    %c31 = arith.constant 31 : i32
    %v31 = wave.splat %c31 : i32 -> !wave.simd<i32, 32>

    %lane = wave.lane_id : !wave.simd<i32, 32>
    %lds = wave.lds_base : !wave.ptr<i32, #wave.shared>

    // Write: LDS[lane] = lane.
    %store_ptrs = wave.ptr_add %lds, %lane
        : !wave.ptr<i32, #wave.shared>, !wave.simd<i32, 32>
        -> !wave.simd<!wave.ptr<i32, #wave.shared>, 32>
    %store_token = wave.store %lane -> %store_ptrs
        : (!wave.simd<i32, 32>, !wave.simd<!wave.ptr<i32, #wave.shared>, 32>)
        -> !wave.mem.token

    %barrier_token = wave.barrier %store_token : (!wave.mem.token) -> !wave.mem.token

    // Read: value = LDS[31 - lane]. The xori-with-31 pattern is the
    // cheapest way to express the mirror permutation without needing
    // a SUB op.
    %mirror = wave.binary "xori" %lane, %v31
        : !wave.simd<i32, 32>, !wave.simd<i32, 32> -> !wave.simd<i32, 32>
    %load_ptrs = wave.ptr_add %lds, %mirror
        : !wave.ptr<i32, #wave.shared>, !wave.simd<i32, 32>
        -> !wave.simd<!wave.ptr<i32, #wave.shared>, 32>
    %loaded:2 = wave.load %load_ptrs after %barrier_token
        : (!wave.simd<!wave.ptr<i32, #wave.shared>, 32>, !wave.mem.token)
        -> (!wave.simd<i32, 32>, !wave.mem.token)

    // Store back into global so the host can verify the result.
    %out_ptrs = wave.ptr_add %dst, %lane
        : !wave.ptr<i32, #wave.global>, !wave.simd<i32, 32>
        -> !wave.simd<!wave.ptr<i32, #wave.global>, 32>
    %final_token = wave.store %loaded#0 -> %out_ptrs after %loaded#1
        : (!wave.simd<i32, 32>, !wave.simd<!wave.ptr<i32, #wave.global>, 32>, !wave.mem.token)
        -> !wave.mem.token
    return
  }
}

func.func private @wave_memref_to_ptr_global_i32(memref<32xi32>)
    -> !wave.ptr<i32, #wave.global> attributes {llvm.emit_c_interface}

func.func private @printMemrefI32(memref<*xi32>)
    attributes {llvm.emit_c_interface}

// CHECK: [31, 30, 29, 28, 27, 26, 25, 24, 23, 22, 21, 20, 19, 18, 17, 16, 15, 14, 13, 12, 11, 10, 9, 8, 7, 6, 5, 4, 3, 2, 1, 0]
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

  gpu.launch_func @kernels::@lds_mirror
      blocks in (%c1, %c1, %c1) threads in (%c32, %c1, %c1)
      args(%p : !wave.ptr<i32, #wave.global>)

  func.call @printMemrefI32(%unranked) : (memref<*xi32>) -> ()
  return
}

}
