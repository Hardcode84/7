// RUN: wave-translate --wave-to-amdgpu-asm %s | FileCheck %s --check-prefix=ASM
// RUN: wave-translate --wave-to-amdgpu-asm %s | llvm-mc -triple=amdgcn-amd-amdhsa -mcpu=gfx1100 -filetype=obj -o /dev/null

module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx1100"} {

// ASM-LABEL: alloc_codegen:
// ASM: ds_store_b32
// ASM: s_barrier
// ASM: ds_load_b32
// ASM: s_barrier
// ASM: ds_store_b32
// ASM: s_barrier
// ASM: ds_load_b32
// ASM: buffer_store_b32
// ASM: .amdhsa_group_segment_fixed_size 128
func.func @alloc_codegen(%dst: !wave.ptr<#wave.global, i32>)
    attributes {wave.kernel} {
  %lane = wave.lane_id : !wave.simd<i32, 32>
  %a = wave.alloc() {align = 16 : i64, bytesize = 128 : i64}
      : !wave.ptr<#wave.shared, i32>
  %ap = wave.ptr_add %a, %lane
      : !wave.ptr<#wave.shared, i32>, !wave.simd<i32, 32>
      -> !wave.simd<!wave.ptr<#wave.shared, i32>, 32>
  %tok0 = wave.store %lane -> %ap
      : (!wave.simd<i32, 32>, !wave.simd<!wave.ptr<#wave.shared, i32>, 32>)
      -> !wave.mem.token
  %bar = wave.barrier %tok0 : (!wave.mem.token) -> !wave.mem.token
  %loaded:2 = wave.load %ap after %bar
      : (!wave.simd<!wave.ptr<#wave.shared, i32>, 32>, !wave.mem.token)
      -> (!wave.simd<i32, 32>, !wave.mem.token)
  %done = wave.barrier %loaded#1 : (!wave.mem.token) -> !wave.mem.token
  %released = wave.alloc_release %a after %done
      : (!wave.ptr<#wave.shared, i32>, !wave.mem.token) -> !wave.mem.token
  %b = wave.alloc() {align = 16 : i64, bytesize = 128 : i64}
      : !wave.ptr<#wave.shared, i32>
  %bp = wave.ptr_add %b, %lane
      : !wave.ptr<#wave.shared, i32>, !wave.simd<i32, 32>
      -> !wave.simd<!wave.ptr<#wave.shared, i32>, 32>
  %tok1 = wave.store %loaded#0 -> %bp after %released
      : (!wave.simd<i32, 32>, !wave.simd<!wave.ptr<#wave.shared, i32>, 32>,
         !wave.mem.token)
      -> !wave.mem.token
  %bar1 = wave.barrier %tok1 : (!wave.mem.token) -> !wave.mem.token
  %reloaded:2 = wave.load %bp after %bar1
      : (!wave.simd<!wave.ptr<#wave.shared, i32>, 32>, !wave.mem.token)
      -> (!wave.simd<i32, 32>, !wave.mem.token)
  %gp = wave.ptr_add %dst, %lane
      : !wave.ptr<#wave.global, i32>, !wave.simd<i32, 32>
      -> !wave.simd<!wave.ptr<#wave.global, i32>, 32>
  %tok2 = wave.store %reloaded#0 -> %gp after %reloaded#1
      : (!wave.simd<i32, 32>, !wave.simd<!wave.ptr<#wave.global, i32>, 32>,
         !wave.mem.token)
      -> !wave.mem.token
  return
}

}
