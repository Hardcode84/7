// REQUIRES: host-supports-amdgpu-wmma
//
// End-to-end check for the `waveamd.mma` lowering path: compile the
// `wmma.i32.16x16x16.iu8` kernel below to a HSACO via `--wave-compile-kernels`,
// launch it on the local AMDGPU, and verify the 16x16 output tile.
//
// The kernel fills A and B with `i8` 1s (broadcast via the 0x01010101 i32
// bit pattern) and seeds the accumulator with 0. Each result element is
// therefore `sum_{k=0..15} 1*1 + 0 = 16`. `fragment_unpack` exposes
// the 8-register accumulator as a per-lane vector<8xi32>; the tuple
// `wave.store` through `%out + lane_id * 8` (== `lane_id * 32`
// bytes) writes 8 contiguous i32s per lane, so a 32-lane wavefront
// fills the entire 256-element output contiguously.
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
  func.func @wmma_iu8_matmul_const(%out: !wave.ptr<i32, #wave.global>)
      attributes {gpu.kernel, wave.kernel} {
    %ones_i8x4 = arith.constant 0x01010101 : i32
    %acc_init  = arith.constant 0 : i32
    %base      = arith.constant 0 : i32
    %ptr = wave.ptr_add %out, %base
        : !wave.ptr<i32, #wave.global>, i32 -> !wave.ptr<i32, #wave.global>
    %a   = waveamd.fragment_fill %ones_i8x4
        : i32 -> !waveamd.fragment<0, i8, 16, 16, 32, 4>
    %b   = waveamd.fragment_fill %ones_i8x4
        : i32 -> !waveamd.fragment<1, i8, 16, 16, 32, 4>
    %acc = waveamd.fragment_fill %acc_init
        : i32 -> !waveamd.fragment<2, i32, 16, 16, 32, 8>
    %d = waveamd.mma "wmma.i32.16x16x16.iu8" %a, %b, %acc
        : !waveamd.fragment<0, i8 , 16, 16, 32, 4>,
          !waveamd.fragment<1, i8 , 16, 16, 32, 4>,
          !waveamd.fragment<2, i32, 16, 16, 32, 8>
       -> !waveamd.fragment<2, i32, 16, 16, 32, 8>
    %lane = wave.lane_id : !wave.simd<i32, 32>
    %r = arith.constant 8 : i32
    %r_simd = wave.splat %r : i32 -> !wave.simd<i32, 32>
    %lane_off = wave.muli %lane, %r_simd
        : !wave.simd<i32, 32>, !wave.simd<i32, 32> -> !wave.simd<i32, 32>
    %tuple_ptr = wave.ptr_add %ptr, %lane_off
        : !wave.ptr<i32, #wave.global>, !wave.simd<i32, 32>
        -> !wave.simd<!wave.ptr<i32, #wave.global>, 32>
    %regs = waveamd.fragment_unpack %d
        : !waveamd.fragment<2, i32, 16, 16, 32, 8>
        -> !wave.simd<vector<8xi32>, 32>
    %tok = wave.store %regs -> %tuple_ptr
        : (!wave.simd<vector<8xi32>, 32>,
           !wave.simd<!wave.ptr<i32, #wave.global>, 32>) -> !wave.mem.token
    return
  }
}

func.func private @wave_memref_to_ptr_global_i32(memref<256xi32>)
    -> !wave.ptr<i32, #wave.global> attributes {llvm.emit_c_interface}

func.func private @printMemrefI32(memref<*xi32>)
    attributes {llvm.emit_c_interface}

// The output is 256 i32s all equal to 16. We don't pin the exact wrapping
// of `printMemrefI32`'s output, but a single uninterrupted run of 16 16s
// is enough evidence that the WMMA tile produced the right result.
// CHECK: 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16
func.func @main() {
  %c0   = arith.constant 0 : index
  %c1   = arith.constant 1 : index
  %c32  = arith.constant 32 : index
  %c256 = arith.constant 256 : index
  %zero = arith.constant 0 : i32

  %storage = memref.alloc() : memref<256xi32>
  scf.for %i = %c0 to %c256 step %c1 {
    memref.store %zero, %storage[%i] : memref<256xi32>
  }
  %unranked = memref.cast %storage : memref<256xi32> to memref<*xi32>
  gpu.host_register %unranked : memref<*xi32>

  %p = func.call @wave_memref_to_ptr_global_i32(%storage)
      : (memref<256xi32>) -> !wave.ptr<i32, #wave.global>

  gpu.launch_func @kernels::@wmma_iu8_matmul_const
      blocks in (%c1, %c1, %c1) threads in (%c32, %c1, %c1)
      args(%p : !wave.ptr<i32, #wave.global>)

  func.call @printMemrefI32(%unranked) : (memref<*xi32>) -> ()
  return
}

}
