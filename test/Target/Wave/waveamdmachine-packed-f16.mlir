// RUN: wave-opt %s | FileCheck %s --check-prefix=ROUND
// RUN: wave-opt %s | wave-opt | FileCheck %s --check-prefix=ROUND
// RUN: wave-translate --wave-to-amdgpu-asm %s | FileCheck %s --check-prefix=ASM
// RUN: wave-translate --wave-to-amdgpu-asm %s | llvm-mc -triple=amdgcn-amd-amdhsa -mcpu=gfx1100 -filetype=obj -o /dev/null

module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx1100"} {

// ROUND-LABEL: func.func @packed_f16_roundtrip
// ROUND: [[PK:%.*]] = waveamdmachine.v_cvt_pk_rtz_f16_f32
// ROUND: [[ADD:%.*]] = waveamdmachine.v_pk_add_f16 [[PK]],
// ROUND: [[MUL:%.*]] = waveamdmachine.v_pk_mul_f16 [[ADD]], [[PK]] {clamp = true, op_sel = 1 : i64, op_sel_hi = 2 : i64}
// ROUND: waveamdmachine.v_pk_fma_f16 [[MUL]], [[ADD]], [[PK]] {op_sel = 5 : i64, op_sel_hi = 3 : i64}
// ASM-LABEL: packed_f16_roundtrip:
// ASM: v_cvt_pk_rtz_f16_f32_e32 [[PK:v[0-9]+]], [[A:v[0-9]+]], [[B:v[0-9]+]]
// ASM: v_pk_add_f16 [[ADD:v[0-9]+]], [[PK]], [[A]]
// ASM: v_pk_mul_f16 [[MUL:v[0-9]+]], [[ADD]], [[PK]] op_sel:[1,0] op_sel_hi:[0,1] clamp
// ASM: v_pk_fma_f16 {{v[0-9]+}}, [[MUL]], [[ADD]], [[PK]] op_sel:[1,0,1] op_sel_hi:[1,1,0]
func.func @packed_f16_roundtrip(%out: !wave.ptr<i32, #wave.global>)
    attributes {wave.kernel} {
  %base = waveamdmachine.arg {index = 0 : i64, pointer = true}
      : !waveamdmachine.reg<sgpr, 2>
  %a = waveamdmachine.v_mbcnt_lo : !waveamdmachine.reg<vgpr, 1>
  %zero = waveamdmachine.imm 0 : !waveamdmachine.imm
  %b = waveamdmachine.v_mov_b32_tuple %zero {registers = 1 : i64}
      : (!waveamdmachine.imm) -> !waveamdmachine.reg<vgpr, 1>
  %pk = waveamdmachine.v_cvt_pk_rtz_f16_f32 %a, %b
      : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>)
        -> !waveamdmachine.reg<vgpr, 1>
  %add = waveamdmachine.v_pk_add_f16 %pk, %a
      : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>)
        -> !waveamdmachine.reg<vgpr, 1>
  %mul = waveamdmachine.v_pk_mul_f16 %add, %pk
      {clamp = true, op_sel = 1 : i64, op_sel_hi = 2 : i64}
      : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>)
        -> !waveamdmachine.reg<vgpr, 1>
  %fma = waveamdmachine.v_pk_fma_f16 %mul, %add, %pk
      {op_sel = 5 : i64, op_sel_hi = 3 : i64}
      : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>,
         !waveamdmachine.reg<vgpr, 1>) -> !waveamdmachine.reg<vgpr, 1>
  %store = waveamdmachine.global_store_b32 %a, %fma, %base
      : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>,
         !waveamdmachine.reg<sgpr, 2>) -> !waveamdmachine.mem.token
  waveamdmachine.s_endpgm
  return
}

}
