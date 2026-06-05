// REQUIRES: host-supports-amdgpu-wave
//
// RUN: sed -e 's/@W@/%wave_width/g' %s \
// RUN:   | wave-opt - --pass-pipeline='builtin.module(wave-set-target-attr{chip=%chip},transform-preload-library{transform-library-paths=%wave_pipelines},transform-interpreter{entry-point=compile_kernels},convert-scf-to-cf,gpu-to-llvm{use-bare-pointers-for-kernels=true},convert-to-llvm,reconcile-unrealized-casts)' \
// RUN:   | mlir-runner \
// RUN:       --shared-libs=%mlir_rocm_runtime \
// RUN:       --shared-libs=%mlir_runner_utils \
// RUN:       --shared-libs=%wave_runtime \
// RUN:       --entry-point-result=void \
// RUN:   | FileCheck %s

module attributes {gpu.container_module} {

gpu.module @kernels {
  func.func @select_values(%dst: !wave.ptr<#wave.global, i32>,
                           %flag: i1)
      attributes {gpu.kernel, wave.kernel} {
    %c8 = arith.constant 8 : i32
    %c16 = arith.constant 16 : i32
    %c100 = arith.constant 100 : i32
    %c200 = arith.constant 200 : i32
    %c300 = arith.constant 300 : i32
    %c400 = arith.constant 400 : i32
    %c999 = arith.constant 999 : i32
    %lane = wave.lane_id : !wave.simd<i32, @W@>
    %v8 = wave.splat %c8 : i32 -> !wave.simd<i32, @W@>
    %v16 = wave.splat %c16 : i32 -> !wave.simd<i32, @W@>
    %v200 = wave.splat %c200 : i32 -> !wave.simd<i32, @W@>
    %lt8 = wave.cmpi ult %lane, %v8
        : !wave.simd<i32, @W@>, !wave.simd<i32, @W@> -> !wave.mask<@W@>
    %lt16 = wave.cmpi ult %lane, %v16
        : !wave.simd<i32, @W@>, !wave.simd<i32, @W@> -> !wave.mask<@W@>

    %hundred = wave.select %flag, %c100, %c999 : i32
    %v100 = wave.splat %hundred : i32 -> !wave.simd<i32, @W@>
    %selected_base = wave.select %lt8, %lane, %v100
        : !wave.mask<@W@>, !wave.simd<i32, @W@>
    %v300 = wave.splat %c300 : i32 -> !wave.simd<i32, @W@>
    %v400 = wave.splat %c400 : i32 -> !wave.simd<i32, @W@>
    %selected_bias = wave.select %lt8, %v300, %v400
        : !wave.mask<@W@>, !wave.simd<i32, @W@>
    %selected = wave.binary addi %selected_base, %selected_bias
        : !wave.simd<i32, @W@>, !wave.simd<i32, @W@> -> !wave.simd<i32, @W@>

    %lane_plus8 = wave.binary addi %lane, %v8
        : !wave.simd<i32, @W@>, !wave.simd<i32, @W@> -> !wave.simd<i32, @W@>
    %lane_plus16 = wave.binary addi %lane, %v16
        : !wave.simd<i32, @W@>, !wave.simd<i32, @W@> -> !wave.simd<i32, @W@>
    %whole = wave.select %flag, %v200, %lane_plus8
        : !wave.simd<i32, @W@>

    %ptr_lane = wave.ptr_add %dst, %lane
        : !wave.ptr<#wave.global, i32>, !wave.simd<i32, @W@>
        -> !wave.simd<!wave.ptr<#wave.global, i32>, @W@>
    %ptr_lane_plus8 = wave.ptr_add %dst, %lane_plus8
        : !wave.ptr<#wave.global, i32>, !wave.simd<i32, @W@>
        -> !wave.simd<!wave.ptr<#wave.global, i32>, @W@>
    %ptr_lane_plus16 = wave.ptr_add %dst, %lane_plus16
        : !wave.ptr<#wave.global, i32>, !wave.simd<i32, @W@>
        -> !wave.simd<!wave.ptr<#wave.global, i32>, @W@>
    %selected_ptr = wave.select %lt8, %ptr_lane, %ptr_lane_plus16
        : !wave.mask<@W@>, !wave.simd<!wave.ptr<#wave.global, i32>, @W@>

    %t0 = wave.where %lt16 {
      %tok = wave.store %selected -> %selected_ptr
          : (!wave.simd<i32, @W@>,
             !wave.simd<!wave.ptr<#wave.global, i32>, @W@>)
          -> !wave.mem.token
      wave.yield %tok : !wave.mem.token
    } : !wave.mask<@W@> -> !wave.mem.token
    %t1 = wave.where %lt16 {
      %tok = wave.store %whole -> %ptr_lane_plus8
          : (!wave.simd<i32, @W@>,
             !wave.simd<!wave.ptr<#wave.global, i32>, @W@>)
          -> !wave.mem.token
      wave.yield %tok : !wave.mem.token
    } : !wave.mask<@W@> -> !wave.mem.token
    %joined = wave.join %t0, %t1 : !wave.mem.token, !wave.mem.token -> !wave.mem.token
    wave.wait %joined : !wave.mem.token
    return
  }
}

func.func private @wave_memref_to_ptr_global_i32(memref<32xi32>)
    -> !wave.ptr<#wave.global, i32> attributes {llvm.emit_c_interface}

func.func private @printMemrefI32(memref<*xi32>)
    attributes {llvm.emit_c_interface}

// CHECK: [300, 301, 302, 303, 304, 305, 306, 307, 200, 200, 200, 200, 200, 200, 200, 200, 200, 200, 200, 200, 200, 200, 200, 200, 500, 500, 500, 500, 500, 500, 500, 500]
func.func @main() {
  %c0 = arith.constant 0 : index
  %c1 = arith.constant 1 : index
  %c32 = arith.constant 32 : index
  %cw = arith.constant @W@ : index
  %zero = arith.constant 0 : i32
  %true = arith.constant true

  %storage = memref.alloc() : memref<32xi32>
  scf.for %i = %c0 to %c32 step %c1 {
    memref.store %zero, %storage[%i] : memref<32xi32>
  }

  %unranked = memref.cast %storage : memref<32xi32> to memref<*xi32>
  gpu.host_register %unranked : memref<*xi32>

  %p = func.call @wave_memref_to_ptr_global_i32(%storage)
      : (memref<32xi32>) -> !wave.ptr<#wave.global, i32>

  gpu.launch_func @kernels::@select_values
      blocks in (%c1, %c1, %c1) threads in (%cw, %c1, %c1)
      args(%p : !wave.ptr<#wave.global, i32>,
           %true : i1)

  func.call @printMemrefI32(%unranked) : (memref<*xi32>) -> ()
  return
}

}
