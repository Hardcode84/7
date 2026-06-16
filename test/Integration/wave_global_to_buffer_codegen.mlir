// RUN: wave-translate --wave-to-amdgpu-asm %s | FileCheck %s --check-prefix=ASM
// RUN: wave-translate --wave-to-amdgpu-asm %s | llvm-mc -triple=amdgcn-amd-amdhsa -mcpu=gfx1100 -filetype=obj -o /dev/null

module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx1100"} {

// ASM-LABEL: global_to_buffer_uniform_root:
// ASM: s_lshl_b32
// ASM: s_add_u32
// ASM: buffer_store_b32
func.func @global_to_buffer_uniform_root(%out: !wave.ptr<#wave.global, i32>,
                                         %raw: i32)
    attributes {wave.kernel} {
  %lane = wave.lane_id : !wave.simd<i32, 32>
  %base = wave.ptr_add %out, %raw
      : !wave.ptr<#wave.global, i32>, i32 -> !wave.ptr<#wave.global, i32>
  %ptr = wave.ptr_add %base, %lane
      : !wave.ptr<#wave.global, i32>, !wave.simd<i32, 32>
      -> !wave.simd<!wave.ptr<#wave.global, i32>, 32>
  %tok = wave.store %lane -> %ptr
      : (!wave.simd<i32, 32>, !wave.simd<!wave.ptr<#wave.global, i32>, 32>)
      -> !wave.mem.token
  return
}

// ASM-LABEL: global_to_buffer_bounded_offset:
// ASM: buffer_store_b32
func.func @global_to_buffer_bounded_offset(%out: !wave.ptr<#wave.global, i32>,
                                           %raw: i32)
    attributes {wave.kernel} {
  %u = wave.assume %raw as "x" [#wave.pred<"x >= 0">, #wave.pred<"x <= 1023">] : i32
  %idx = wave.splat %u : i32 -> !wave.simd<i32, 32>
  %lane = wave.lane_id : !wave.simd<i32, 32>
  %ptr = wave.ptr_add %out, %idx
      : !wave.ptr<#wave.global, i32>, !wave.simd<i32, 32>
      -> !wave.simd<!wave.ptr<#wave.global, i32>, 32>
  %tok = wave.store %lane -> %ptr
      : (!wave.simd<i32, 32>, !wave.simd<!wave.ptr<#wave.global, i32>, 32>)
      -> !wave.mem.token
  return
}

}
