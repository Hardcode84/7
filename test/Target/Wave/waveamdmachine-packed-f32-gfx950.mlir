// RUN: wave-opt %s | FileCheck %s --check-prefix=ROUND
// RUN: wave-translate --wave-to-amdgpu-asm %s | FileCheck %s --check-prefix=ASM
// RUN: wave-translate --wave-to-amdgpu-asm %s | llvm-mc -triple=amdgcn-amd-amdhsa -mcpu=gfx950 -filetype=obj -o /dev/null

module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx950"} {

// ROUND-LABEL: func.func @packed_f32_gfx950
// ROUND: [[ADD:%.*]] = waveamdmachine.v_pk_add_f32
// ROUND: [[MUL:%.*]] = waveamdmachine.v_pk_mul_f32 [[ADD]],
// ROUND: waveamdmachine.v_pk_fma_f32 [[MUL]], [[ADD]],
// ASM-LABEL: packed_f32_gfx950:
// ASM: v_pk_add_f32
// ASM: v_pk_mul_f32
// ASM: v_pk_fma_f32 {{.*}} op_sel:[0,0,1] op_sel_hi:[1,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
func.func @packed_f32_gfx950(%out: !wave.ptr<#wave.global, i32>)
    attributes {wave.kernel} {
  %base = waveamdmachine.arg {index = 0 : i64, pointer = true}
      : !waveamdmachine.reg<sgpr, 2>
  %a = waveamdmachine.v_mbcnt_lo : !waveamdmachine.reg<vgpr, 1>
  %zero = waveamdmachine.imm 0 : !waveamdmachine.imm
  %b = waveamdmachine.v_mov_b32_tuple %zero {registers = 1 : i64}
      : (!waveamdmachine.imm) -> !waveamdmachine.reg<vgpr, 1>
  %lhs = waveamdmachine.tuple_from_elements %a, %b
      : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>)
        -> !waveamdmachine.reg<vgpr, 2>
  %rhs = waveamdmachine.tuple_from_elements %b, %a
      : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>)
        -> !waveamdmachine.reg<vgpr, 2>
  %add = waveamdmachine.v_pk_add_f32 %lhs, %rhs
      : (!waveamdmachine.reg<vgpr, 2>, !waveamdmachine.reg<vgpr, 2>)
        -> !waveamdmachine.reg<vgpr, 2>
  %mul = waveamdmachine.v_pk_mul_f32 %add, %lhs
      : (!waveamdmachine.reg<vgpr, 2>, !waveamdmachine.reg<vgpr, 2>)
        -> !waveamdmachine.reg<vgpr, 2>
  %fma = waveamdmachine.v_pk_fma_f32 %mul, %add, %rhs
      {op_sel = 4, op_sel_hi = 5, neg_lo = 4, neg_hi = 4}
      : (!waveamdmachine.reg<vgpr, 2>, !waveamdmachine.reg<vgpr, 2>,
         !waveamdmachine.reg<vgpr, 2>) -> !waveamdmachine.reg<vgpr, 2>
  %parts:2 = waveamdmachine.tuple_to_elements %fma
      : (!waveamdmachine.reg<vgpr, 2>)
        -> (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>)
  %store = waveamdmachine.global_store_b32 %a, %parts#0, %base
      : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>,
         !waveamdmachine.reg<sgpr, 2>) -> !waveamdmachine.mem.token
  waveamdmachine.s_endpgm
  return
}

}
