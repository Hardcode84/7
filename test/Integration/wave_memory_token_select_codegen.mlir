// RUN: wave-translate --wave-to-amdgpu-asm %s | FileCheck %s --check-prefix=ASM
// RUN: wave-translate --wave-to-amdgpu-asm %s \
// RUN:   | llvm-mc -triple=amdgcn-amd-amdhsa -mcpu=gfx1100 -filetype=obj -o /dev/null

module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx1100"} {

// ASM-LABEL: memory_token_select_codegen:
// ASM: buffer_store_b32
// ASM: buffer_store_b32
// ASM: buffer_load_b32
// ASM: buffer_store_b32
func.func @memory_token_select_codegen(
    %dst: !wave.ptr<#wave.global, i32>, %pred: i1)
    attributes {wave.kernel} {
  %lane = wave.lane_id : !wave.simd<i32, 32>
  %ptrs = wave.ptr_add %dst, %lane
      : !wave.ptr<#wave.global, i32>, !wave.simd<i32, 32>
      -> !wave.simd<!wave.ptr<#wave.global, i32>, 32>
  %first = wave.store %lane -> %ptrs
      : (!wave.simd<i32, 32>, !wave.simd<!wave.ptr<#wave.global, i32>, 32>)
      -> !wave.mem.token
  %second = wave.store %lane -> %ptrs
      : (!wave.simd<i32, 32>, !wave.simd<!wave.ptr<#wave.global, i32>, 32>)
      -> !wave.mem.token
  %selected = wave.select %pred, %first, %second : !wave.mem.token
  %loaded:2 = wave.load %ptrs after %selected
      : (!wave.simd<!wave.ptr<#wave.global, i32>, 32>, !wave.mem.token)
      -> (!wave.simd<i32, 32>, !wave.mem.token)
  %stored = wave.store %loaded#0 -> %ptrs after %loaded#1
      : (!wave.simd<i32, 32>, !wave.simd<!wave.ptr<#wave.global, i32>, 32>,
         !wave.mem.token)
      -> !wave.mem.token
  return
}

}
