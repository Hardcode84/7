// RUN: wave-opt --waveamd-to-machine %s \
// RUN:   | wave-translate --wave-to-amdgpu-asm - \
// RUN:   | FileCheck %s --check-prefix=ASM
// RUN: wave-opt --waveamd-to-machine %s \
// RUN:   | wave-translate --wave-to-amdgpu-asm - \
// RUN:   | llvm-mc -triple=amdgcn-amd-amdhsa -mcpu=gfx1100 -filetype=obj -o /dev/null

module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx1100"} {

// ASM-LABEL: buffer_base_offset_codegen:
// ASM: s_lshl_b32 [[OFF:s[0-9]+]], {{s[0-9]+}}, 10
// ASM: s_add_u32 {{s[0-9]+}}, {{s[0-9]+}}, [[OFF]]
// ASM: s_addc_u32 {{s[0-9]+}}, {{s[0-9]+}}, 0
// ASM: buffer_store_b32
func.func @buffer_base_offset_codegen(%out: !wave.ptr<#wave.global, i32>)
    attributes {wave.kernel} {
  %range = arith.constant 1024 : i32
  %wg_raw = wave.workgroup_id 0
  %wg = wave.assume %wg_raw as "x" [#wave.pred<"x >= 0">, #wave.pred<"x <= 1023">] : i32
  %tile = wave.index_expr <"256*wg"> ["wg"](%wg) : (i32) -> index
  %base = wave.ptr_add %out, %tile
      : !wave.ptr<#wave.global, i32>, index -> !wave.ptr<#wave.global, i32>
  %buffer = waveamd.make_buffer %base, %range
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
