// RUN: wave-opt %s --pass-pipeline='builtin.module(transform-preload-library{transform-library-paths=%wave_pipelines},transform-interpreter{entry-point=compile_kernels})' | FileCheck %s

// CHECK: gpu.binary @kernels
// CHECK-SAME: chip = "gfx1100"
// CHECK-SAME: features = "-wavefrontsize32,+wavefrontsize64"
// CHECK-NOT: gpu.module @kernels

module attributes {gpu.container_module,
                   waveamdmachine.target = "amdgcn-amd-amdhsa--gfx1100",
                   waveamdmachine.wavefront_size = 64 : i64} {
gpu.module @kernels {
  func.func @write_i64_cmp(%dst: !wave.ptr<#wave.global, i32>,
                           %lhs: i64, %rhs: i64)
      attributes {gpu.kernel, wave.kernel} {
    %range = arith.constant 512 : i32
    %buffer = waveamd.make_buffer %dst, %range
        : !wave.ptr<#wave.global, i32>, i32 -> !wave.ptr<#waveamd.buffer, i32>
    %lane = wave.lane_id : !wave.simd<i32, 64>
    %vlhs = wave.splat %lhs : i64 -> !wave.simd<i64, 64>
    %vrhs = wave.splat %rhs : i64 -> !wave.simd<i64, 64>
    %active = wave.cmpi sge %vlhs, %vrhs
        : !wave.simd<i64, 64>, !wave.simd<i64, 64> -> !wave.mask<64>
    %ptrs = wave.ptr_add %buffer, %lane
        : !wave.ptr<#waveamd.buffer, i32>, !wave.simd<i32, 64>
        -> !wave.simd<!wave.ptr<#waveamd.buffer, i32>, 64>
    wave.where %active {
      %tok = wave.store %lane -> %ptrs
          : (!wave.simd<i32, 64>, !wave.simd<!wave.ptr<#waveamd.buffer, i32>, 64>)
          -> !wave.mem.token
      wave.yield
    } : !wave.mask<64>
    return
  }
}
}
