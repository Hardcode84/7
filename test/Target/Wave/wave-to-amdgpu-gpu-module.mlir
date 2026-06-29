// RUN: wave-translate --wave-to-amdgpu-asm %s | FileCheck %s --check-prefix=ASM
// RUN: wave-translate --wave-to-amdgpu-asm %s | llvm-mc -triple=amdgcn-amd-amdhsa -mcpu=gfx1100 -filetype=obj -o /dev/null

module attributes {gpu.container_module, waveamdmachine.target = "amdgcn-amd-amdhsa--gfx1100"} {
  gpu.module @kernels {
    // ASM-LABEL: nested_write_lane_id:
    // ASM: buffer_store_b32
    func.func @nested_write_lane_id(%dst: !wave.ptr<#wave.global, i32>)
        attributes {gpu.kernel, wave.kernel} {
      %range = arith.constant 128 : i32
      %buffer = waveamd.make_buffer %dst, %range
          : !wave.ptr<#wave.global, i32>, i32 -> !wave.ptr<#waveamd.buffer, i32>
      %lane = wave.lane_id : !wave.simd<i32, 32>
      %ptrs = wave.ptr_add %buffer, %lane
          : !wave.ptr<#waveamd.buffer, i32>, !wave.simd<i32, 32>
          -> !wave.simd<!wave.ptr<#waveamd.buffer, i32>, 32>
      %tok = wave.store %lane -> %ptrs
          : (!wave.simd<i32, 32>,
             !wave.simd<!wave.ptr<#waveamd.buffer, i32>, 32>) -> !wave.mem.token
      return
    }
  }
}
