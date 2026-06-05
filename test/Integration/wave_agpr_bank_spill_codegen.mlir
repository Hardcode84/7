// RUN: wave-opt --waveamd-reg-alloc='agpr-bank-spill=true vgpr-limit=16' --waveamd-resource-info %s \
// RUN:   | wave-translate --wave-to-amdgpu-asm - \
// RUN:   | FileCheck %s --check-prefix=ASM
// RUN: wave-opt --waveamd-reg-alloc='agpr-bank-spill=true vgpr-limit=16' --waveamd-resource-info %s \
// RUN:   | wave-translate --wave-to-amdgpu-asm - \
// RUN:   | llvm-mc -triple=amdgcn-amd-amdhsa -mcpu=gfx950 -filetype=obj -o /dev/null

module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx950",
                   waveamdmachine.target_waves = 4 : i64} {

// ASM-LABEL: agpr_bank_spill_codegen:
// ASM: v_mfma_f32_16x16x32_f16 {{a\[[0-9]+:[0-9]+\]}}, {{a\[[0-9]+:[0-9]+\]}}, {{[av]\[[0-9]+:[0-9]+\]}}, {{a\[[0-9]+:[0-9]+\]}}
// ASM-DAG: v_accvgpr_read_b32
// ASM-DAG: v_accvgpr_write_b32
// ASM: global_store_dword
// ASM: global_store_dword
func.func @agpr_bank_spill_codegen() attributes {wave.kernel} {
  %zero = waveamdmachine.imm 0 : !waveamdmachine.imm
  %off = waveamdmachine.uninit : !waveamdmachine.reg<vgpr, 1>
  %base = waveamdmachine.uninit : !waveamdmachine.reg<sgpr, 2>
  %a = waveamdmachine.uninit : !waveamdmachine.reg<vgpr, 4>
  %b = waveamdmachine.uninit : !waveamdmachine.reg<vgpr, 4>
  %acc = waveamdmachine.uninit : !waveamdmachine.reg<vgpr, 4>
  %mfma = waveamdmachine.mfma_f32_16x16x32_f16 %a, %b, %acc
      : (!waveamdmachine.reg<vgpr, 4>, !waveamdmachine.reg<vgpr, 4>,
         !waveamdmachine.reg<vgpr, 4>) -> !waveamdmachine.reg<vgpr, 4>
  %generic0 = waveamdmachine.v_mov_b32_tuple %zero {registers = 4 : i64}
      : (!waveamdmachine.imm) -> !waveamdmachine.reg<vgpr, 4>
  %generic1 = waveamdmachine.v_mov_b32_tuple %zero {registers = 4 : i64}
      : (!waveamdmachine.imm) -> !waveamdmachine.reg<vgpr, 4>
  %generic2 = waveamdmachine.v_mov_b32_tuple %zero {registers = 4 : i64}
      : (!waveamdmachine.imm) -> !waveamdmachine.reg<vgpr, 4>
  %generic3 = waveamdmachine.v_mov_b32_tuple %zero {registers = 4 : i64}
      : (!waveamdmachine.imm) -> !waveamdmachine.reg<vgpr, 4>
  %use_mfma = waveamdmachine.v_mov_b32_tuple %mfma {registers = 4 : i64}
      : (!waveamdmachine.reg<vgpr, 4>) -> !waveamdmachine.reg<vgpr, 4>
  %use_generic0 = waveamdmachine.v_mov_b32_tuple %generic0 {registers = 4 : i64}
      : (!waveamdmachine.reg<vgpr, 4>) -> !waveamdmachine.reg<vgpr, 4>
  %use_generic1 = waveamdmachine.v_mov_b32_tuple %generic1 {registers = 4 : i64}
      : (!waveamdmachine.reg<vgpr, 4>) -> !waveamdmachine.reg<vgpr, 4>
  %use_generic2 = waveamdmachine.v_mov_b32_tuple %generic2 {registers = 4 : i64}
      : (!waveamdmachine.reg<vgpr, 4>) -> !waveamdmachine.reg<vgpr, 4>
  %use_generic3 = waveamdmachine.v_mov_b32_tuple %generic3 {registers = 4 : i64}
      : (!waveamdmachine.reg<vgpr, 4>) -> !waveamdmachine.reg<vgpr, 4>
  %elem:4 = waveamdmachine.tuple_to_elements %use_mfma
      : (!waveamdmachine.reg<vgpr, 4>) -> (!waveamdmachine.reg<vgpr, 1>,
          !waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>,
          !waveamdmachine.reg<vgpr, 1>)
  %generic_elem:4 = waveamdmachine.tuple_to_elements %use_generic0
      : (!waveamdmachine.reg<vgpr, 4>) -> (!waveamdmachine.reg<vgpr, 1>,
          !waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>,
          !waveamdmachine.reg<vgpr, 1>)
  %token = waveamdmachine.global_store_b32 %off, %elem#0, %base
      : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>,
         !waveamdmachine.reg<sgpr, 2>) -> !waveamdmachine.mem.token
  %token2 = waveamdmachine.global_store_b32 %off, %generic_elem#0, %base after %token offset 4
      : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>,
         !waveamdmachine.reg<sgpr, 2>, !waveamdmachine.mem.token)
      -> !waveamdmachine.mem.token
  waveamdmachine.s_endpgm
  return
}

// ASM-LABEL: loop_carried_agpr_bank_spill_codegen:
// ASM: v_mfma_f32_16x16x32_f16 {{a\[[0-9]+:[0-9]+\]}}, {{[av]\[[0-9]+:[0-9]+\]}}, {{[av]\[[0-9]+:[0-9]+\]}}, {{a\[[0-9]+:[0-9]+\]}}
// ASM: v_accvgpr_read_b32
// ASM: global_store_dword
func.func @loop_carried_agpr_bank_spill_codegen() attributes {wave.kernel} {
  %zero = waveamdmachine.imm 0 : !waveamdmachine.imm
  %one = waveamdmachine.imm 1 : !waveamdmachine.imm
  %four = waveamdmachine.imm 4 : !waveamdmachine.imm
  %off = waveamdmachine.uninit : !waveamdmachine.reg<vgpr, 1>
  %base = waveamdmachine.uninit : !waveamdmachine.reg<sgpr, 2>
  %a = waveamdmachine.uninit : !waveamdmachine.reg<vgpr, 4>
  %b = waveamdmachine.uninit : !waveamdmachine.reg<vgpr, 4>
  %acc = waveamdmachine.uninit : !waveamdmachine.reg<vgpr, 4>
  %iv = waveamdmachine.s_mov_b32_value %zero
      : (!waveamdmachine.imm) -> !waveamdmachine.reg<sgpr, 1>
  %ec = waveamdmachine.s_cmp_lt_i32 %zero, %four
      : (!waveamdmachine.imm, !waveamdmachine.imm) -> !waveamdmachine.reg<scc, 1>
  %r:2 = waveamdmachine.uniform_loop if %ec : !waveamdmachine.reg<scc, 1>
      carries(%iv, %acc :
              !waveamdmachine.reg<sgpr, 1>,
              !waveamdmachine.reg<vgpr, 4>) {
  ^bb0(%cur_iv: !waveamdmachine.reg<sgpr, 1>,
       %cur_acc: !waveamdmachine.reg<vgpr, 4>):
    %mfma = waveamdmachine.mfma_f32_16x16x32_f16 %a, %b, %cur_acc
        : (!waveamdmachine.reg<vgpr, 4>, !waveamdmachine.reg<vgpr, 4>,
           !waveamdmachine.reg<vgpr, 4>) -> !waveamdmachine.reg<vgpr, 4>
    %generic0 = waveamdmachine.v_mov_b32_tuple %zero {registers = 4 : i64}
        : (!waveamdmachine.imm) -> !waveamdmachine.reg<vgpr, 4>
    %generic1 = waveamdmachine.v_mov_b32_tuple %zero {registers = 4 : i64}
        : (!waveamdmachine.imm) -> !waveamdmachine.reg<vgpr, 4>
    %generic2 = waveamdmachine.v_mov_b32_tuple %zero {registers = 4 : i64}
        : (!waveamdmachine.imm) -> !waveamdmachine.reg<vgpr, 4>
    %generic3 = waveamdmachine.v_mov_b32_tuple %zero {registers = 4 : i64}
        : (!waveamdmachine.imm) -> !waveamdmachine.reg<vgpr, 4>
    %niv, %scc = waveamdmachine.s_add_i32 %cur_iv, %one
        : (!waveamdmachine.reg<sgpr, 1>, !waveamdmachine.imm)
          -> (!waveamdmachine.reg<sgpr, 1>, !waveamdmachine.reg<scc, 1>)
    %bc = waveamdmachine.s_cmp_lt_i32 %niv, %four
        : (!waveamdmachine.reg<sgpr, 1>, !waveamdmachine.imm)
          -> !waveamdmachine.reg<scc, 1>
    %use_generic0 = waveamdmachine.v_mov_b32_tuple %generic0 {registers = 4 : i64}
        : (!waveamdmachine.reg<vgpr, 4>) -> !waveamdmachine.reg<vgpr, 4>
    %use_generic1 = waveamdmachine.v_mov_b32_tuple %generic1 {registers = 4 : i64}
        : (!waveamdmachine.reg<vgpr, 4>) -> !waveamdmachine.reg<vgpr, 4>
    %use_generic2 = waveamdmachine.v_mov_b32_tuple %generic2 {registers = 4 : i64}
        : (!waveamdmachine.reg<vgpr, 4>) -> !waveamdmachine.reg<vgpr, 4>
    %use_generic3 = waveamdmachine.v_mov_b32_tuple %generic3 {registers = 4 : i64}
        : (!waveamdmachine.reg<vgpr, 4>) -> !waveamdmachine.reg<vgpr, 4>
    waveamdmachine.continue_if %bc : !waveamdmachine.reg<scc, 1>
        carries(%niv, %mfma :
                !waveamdmachine.reg<sgpr, 1>,
                !waveamdmachine.reg<vgpr, 4>)
  } -> !waveamdmachine.reg<sgpr, 1>, !waveamdmachine.reg<vgpr, 4>
  %use = waveamdmachine.v_mov_b32_tuple %r#1 {registers = 4 : i64}
      : (!waveamdmachine.reg<vgpr, 4>) -> !waveamdmachine.reg<vgpr, 4>
  %elem:4 = waveamdmachine.tuple_to_elements %use
      : (!waveamdmachine.reg<vgpr, 4>) -> (!waveamdmachine.reg<vgpr, 1>,
          !waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>,
          !waveamdmachine.reg<vgpr, 1>)
  %token = waveamdmachine.global_store_b32 %off, %elem#0, %base
      : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>,
         !waveamdmachine.reg<sgpr, 2>) -> !waveamdmachine.mem.token
  waveamdmachine.s_endpgm
  return
}

}
