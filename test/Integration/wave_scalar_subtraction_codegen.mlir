// RUN: wave-opt %s --waveamd-form-fused-int | FileCheck %s --check-prefix=IR
// RUN: wave-translate %s --wave-to-amdgpu-asm -o %t.s
// RUN: FileCheck %s --check-prefix=ASM < %t.s
// RUN: llvm-mc --triple=amdgcn-amd-amdhsa --mcpu=gfx1100 --filetype=obj %t.s -o /dev/null

// IR-LABEL: func.func @scalar_subtraction
// IR-NOT: waveamdmachine.s_xor_b32
// IR: waveamdmachine.s_sub_i32
// ASM-LABEL: scalar_subtraction:
// ASM-NOT: s_xor_b32
// ASM: s_load_b32 [[RHS:s[0-9]+]], s[0:1], 0xc
// ASM-NOT: s_mul_i32 [[RHS]],
// ASM: s_sub_i32 {{s[0-9]+}}, {{s[0-9]+}}, [[RHS]]
// ASM: global_store_b32
module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx1100"} {
func.func @scalar_subtraction(%out: !wave.ptr<#wave.global, i32>, %a: i32, %b: i32) attributes {wave.kernel} {
  %lane = waveamdmachine.v_workitem_id_x : !waveamdmachine.reg<vgpr, 1>
  %zero = waveamdmachine.imm 0 : !waveamdmachine.imm
  %one = waveamdmachine.imm 1 : !waveamdmachine.imm
  %two = waveamdmachine.imm 2 : !waveamdmachine.imm
  %seven = waveamdmachine.imm 7 : !waveamdmachine.imm
  %nine = waveamdmachine.imm 9 : !waveamdmachine.imm
  %mask = waveamdmachine.imm -1 : !waveamdmachine.imm
  %aoff = waveamdmachine.imm 8 : !waveamdmachine.imm
  %boff = waveamdmachine.imm 12 : !waveamdmachine.imm
  %base = waveamdmachine.s_load_b64 %zero, "s[0:1]" : (!waveamdmachine.imm) -> !waveamdmachine.reg<sgpr, 2>
  %lhs = waveamdmachine.s_load_b32 %aoff, "s[0:1]" : (!waveamdmachine.imm) -> !waveamdmachine.reg<sgpr, 1>
  %rhs = waveamdmachine.s_load_b32 %boff, "s[0:1]" : (!waveamdmachine.imm) -> !waveamdmachine.reg<sgpr, 1>
  %inv, %xs = waveamdmachine.s_xor_b32 %rhs, %mask : (!waveamdmachine.reg<sgpr, 1>, !waveamdmachine.imm) -> (!waveamdmachine.reg<sgpr, 1>, !waveamdmachine.reg<scc, 1>)
  %neg, %ns = waveamdmachine.s_add_i32 %inv, %one : (!waveamdmachine.reg<sgpr, 1>, !waveamdmachine.imm) -> (!waveamdmachine.reg<sgpr, 1>, !waveamdmachine.reg<scc, 1>)
  %other = waveamdmachine.s_mul_i32 %lhs, %seven : (!waveamdmachine.reg<sgpr, 1>, !waveamdmachine.imm) -> !waveamdmachine.reg<sgpr, 1>
  // Without fusion, this multiply reuses rhs storage before the final add.
  %reuse = waveamdmachine.s_mul_i32 %lhs, %nine : (!waveamdmachine.reg<sgpr, 1>, !waveamdmachine.imm) -> !waveamdmachine.reg<sgpr, 1>
  %diff, %ds = waveamdmachine.s_add_i32 %lhs, %neg : (!waveamdmachine.reg<sgpr, 1>, !waveamdmachine.reg<sgpr, 1>) -> (!waveamdmachine.reg<sgpr, 1>, !waveamdmachine.reg<scc, 1>)
  %sum, %ss = waveamdmachine.s_add_i32 %diff, %other : (!waveamdmachine.reg<sgpr, 1>, !waveamdmachine.reg<sgpr, 1>) -> (!waveamdmachine.reg<sgpr, 1>, !waveamdmachine.reg<scc, 1>)
  %total, %ts = waveamdmachine.s_add_i32 %sum, %reuse : (!waveamdmachine.reg<sgpr, 1>, !waveamdmachine.reg<sgpr, 1>) -> (!waveamdmachine.reg<sgpr, 1>, !waveamdmachine.reg<scc, 1>)
  %value = waveamdmachine.v_mov_b32_tuple %total : (!waveamdmachine.reg<sgpr, 1>) -> !waveamdmachine.reg<vgpr, 1>
  %off = waveamdmachine.v_lshlrev_b32 %lane, %two : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.imm) -> !waveamdmachine.reg<vgpr, 1>
  %token = waveamdmachine.token : !waveamdmachine.mem.token
  %done = waveamdmachine.global_store_b32 %off, %value, %base after %token : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<sgpr, 2>, !waveamdmachine.mem.token) -> !waveamdmachine.mem.token
  waveamdmachine.s_endpgm
  return
}
}
