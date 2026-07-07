// RUN: wave-opt %s | FileCheck %s --check-prefix=ROUND
// RUN: wave-translate --wave-to-amdgpu-asm %s | FileCheck %s --check-prefix=ASM
// RUN: wave-translate --wave-to-amdgpu-asm %s | llvm-mc -triple=amdgcn-amd-amdhsa -mcpu=gfx950 -filetype=obj -o /dev/null

module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx950"} {

// ROUND-LABEL: func.func @packed_f16_gfx950
// ROUND: waveamdmachine.v_cvt_pk_rtz_f16_f32
// ROUND: waveamdmachine.v_cvt_pk_f16_f32
// ROUND: waveamdmachine.v_cvt_f32_f16_e32
// ROUND: waveamdmachine.v_cvt_f32_f16_sdwa
// ASM-LABEL: packed_f16_gfx950:
// ASM: v_cvt_pkrtz_f16_f32
// ASM: v_cvt_pk_f16_f32
// ASM: v_cvt_f32_f16_e32
// ASM: v_cvt_f32_f16_sdwa {{.*}} dst_sel:DWORD dst_unused:UNUSED_PAD src0_sel:WORD_1
func.func @packed_f16_gfx950(%out: !wave.ptr<#wave.global, i32>)
    attributes {wave.kernel} {
  %base = waveamdmachine.arg {index = 0 : i64, pointer = true}
      : !waveamdmachine.reg<sgpr, 2>
  %a = waveamdmachine.v_mbcnt_lo : !waveamdmachine.reg<vgpr, 1>
  %zero = waveamdmachine.imm 0 : !waveamdmachine.imm
  %b = waveamdmachine.v_mov_b32_tuple %zero {registers = 1 : i64}
      : (!waveamdmachine.imm) -> !waveamdmachine.reg<vgpr, 1>
  %rtz = waveamdmachine.v_cvt_pk_rtz_f16_f32 %a, %b
      : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>)
        -> !waveamdmachine.reg<vgpr, 1>
  %rne = waveamdmachine.v_cvt_pk_f16_f32 %a, %b
      : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>)
        -> !waveamdmachine.reg<vgpr, 1>
  %sum = waveamdmachine.v_pk_add_f16 %rtz, %rne
      : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>)
        -> !waveamdmachine.reg<vgpr, 1>
  %lo = waveamdmachine.v_cvt_f32_f16_e32 %sum
      : (!waveamdmachine.reg<vgpr, 1>) -> !waveamdmachine.reg<vgpr, 1>
  %hi = waveamdmachine.v_cvt_f32_f16_sdwa %sum
      : (!waveamdmachine.reg<vgpr, 1>) -> !waveamdmachine.reg<vgpr, 1>
  %wide = waveamdmachine.v_add_f32 %lo, %hi
      : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>)
        -> !waveamdmachine.reg<vgpr, 1>
  %store = waveamdmachine.global_store_b32 %a, %wide, %base
      : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>,
         !waveamdmachine.reg<sgpr, 2>) -> !waveamdmachine.mem.token
  waveamdmachine.s_endpgm
  return
}

}
