// RUN: wave-opt %s --pass-pipeline='builtin.module(wave-set-target-attr{chip=gfx1100},transform-preload-library{transform-library-paths=%wave_pipelines},transform-interpreter{entry-point=compile_kernels})' | FileCheck %s

// CHECK: module attributes
// CHECK-SAME: waveamdmachine.target = "amdgcn-amd-amdhsa--gfx1100"
// CHECK: gpu.binary @kernels
// CHECK-SAME: chip = "gfx1100"
// CHECK-NOT: gpu.module @kernels

module attributes {gpu.container_module} {
gpu.module @kernels {
  func.func @write_lane_id(%dst: !wave.ptr<#wave.global, i32>)
      attributes {gpu.kernel, wave.kernel} {
    %range = arith.constant 128 : i32
    %buffer = waveamd.make_buffer %dst, %range
        : !wave.ptr<#wave.global, i32>, i32 -> !wave.ptr<#waveamd.buffer, i32>
    %lane = wave.lane_id : !wave.simd<i32, 32>
    %ptrs = wave.ptr_add %buffer, %lane
        : !wave.ptr<#waveamd.buffer, i32>, !wave.simd<i32, 32>
        -> !wave.simd<!wave.ptr<#waveamd.buffer, i32>, 32>
    %tok = wave.store %lane -> %ptrs
        : (!wave.simd<i32, 32>, !wave.simd<!wave.ptr<#waveamd.buffer, i32>, 32>)
        -> !wave.mem.token
    return
  }
}
}
