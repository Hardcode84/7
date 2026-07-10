// RUN: wave-opt %s --waveamd-machine-schedule='apply-schedule=1' \
// RUN:   --waveamd-insert-hazard-waits --waveamd-resource-info \
// RUN:   | env WAVE_PIPELINES_DIR=%S/../Target/Wave/Inputs/emit-only-pipeline wave-translate --wave-to-amdgpu-asm - \
// RUN:   | FileCheck %s --check-prefix=ASM
// RUN: wave-opt %s --waveamd-machine-schedule='apply-schedule=1' \
// RUN:   --waveamd-insert-hazard-waits --waveamd-resource-info \
// RUN:   | env WAVE_PIPELINES_DIR=%S/../Target/Wave/Inputs/emit-only-pipeline wave-translate --wave-to-amdgpu-asm - \
// RUN:   | llvm-mc -triple=amdgcn-amd-amdhsa -mcpu=gfx950 -filetype=obj -o /dev/null

module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx950"} {

// ASM-LABEL: trans_hazard_schedule_codegen:
// ASM: v_rcp_f32_e32 v8, v0
// ASM-NEXT: v_xor_b32_e32 v10, v2, v3
// ASM-NEXT: v_mul_f32_e32 v9, v8, v1
// ASM-NOT: s_nop
// ASM: s_endpgm
func.func @trans_hazard_schedule_codegen() attributes {wave.kernel} {
  %a = waveamdmachine.uninit : !waveamdmachine.reg<vgpr, 1, 0>
  %b = waveamdmachine.uninit : !waveamdmachine.reg<vgpr, 1, 1>
  %c = waveamdmachine.uninit : !waveamdmachine.reg<vgpr, 1, 2>
  %d = waveamdmachine.uninit : !waveamdmachine.reg<vgpr, 1, 3>
  %trans = waveamdmachine.v_rcp_f32 %a
      : (!waveamdmachine.reg<vgpr, 1, 0>) -> !waveamdmachine.reg<vgpr, 1, 8>
  %use = waveamdmachine.v_mul_f32 %trans, %b
      : (!waveamdmachine.reg<vgpr, 1, 8>, !waveamdmachine.reg<vgpr, 1, 1>)
        -> !waveamdmachine.reg<vgpr, 1, 9>
  %fill = waveamdmachine.v_xor_b32 %c, %d
      : (!waveamdmachine.reg<vgpr, 1, 2>, !waveamdmachine.reg<vgpr, 1, 3>)
        -> !waveamdmachine.reg<vgpr, 1, 10>
  waveamdmachine.s_endpgm
  return
}

// ASM-LABEL: readfirstlane_hazard_schedule_codegen:
// ASM: v_add_u32_e32 v8, v0, v1
// ASM-NEXT: v_xor_b32_e32 v9, v2, v3
// ASM-NEXT: v_readfirstlane_b32 s0, v8
// ASM-NOT: s_nop
// ASM: s_endpgm
func.func @readfirstlane_hazard_schedule_codegen() attributes {wave.kernel} {
  %a = waveamdmachine.uninit : !waveamdmachine.reg<vgpr, 1, 0>
  %b = waveamdmachine.uninit : !waveamdmachine.reg<vgpr, 1, 1>
  %c = waveamdmachine.uninit : !waveamdmachine.reg<vgpr, 1, 2>
  %d = waveamdmachine.uninit : !waveamdmachine.reg<vgpr, 1, 3>
  %sum = waveamdmachine.v_add_u32 %a, %b
      : (!waveamdmachine.reg<vgpr, 1, 0>, !waveamdmachine.reg<vgpr, 1, 1>)
        -> !waveamdmachine.reg<vgpr, 1, 8>
  %first = waveamdmachine.v_readfirstlane_b32 %sum
      : (!waveamdmachine.reg<vgpr, 1, 8>) -> !waveamdmachine.reg<sgpr, 1, 0>
  %fill = waveamdmachine.v_xor_b32 %c, %d
      : (!waveamdmachine.reg<vgpr, 1, 2>, !waveamdmachine.reg<vgpr, 1, 3>)
        -> !waveamdmachine.reg<vgpr, 1, 9>
  waveamdmachine.s_endpgm
  return
}

// ASM-LABEL: vcc_hazard_schedule_codegen:
// ASM: v_cmp_ge_u32_e64 vcc, v0, v1
// ASM-NEXT: v_add_u32_e32 v8, v0, v2
// ASM-NEXT: v_xor_b32_e32 v10, v2, v3
// ASM-NEXT: v_cndmask_b32_e32 v9, v0, v8, vcc
// ASM-NOT: s_nop
// ASM: s_endpgm
func.func @vcc_hazard_schedule_codegen() attributes {wave.kernel} {
  %a = waveamdmachine.uninit : !waveamdmachine.reg<vgpr, 1, 0>
  %b = waveamdmachine.uninit : !waveamdmachine.reg<vgpr, 1, 1>
  %c = waveamdmachine.uninit : !waveamdmachine.reg<vgpr, 1, 2>
  %d = waveamdmachine.uninit : !waveamdmachine.reg<vgpr, 1, 3>
  %mask, %vcc = waveamdmachine.v_cmp_ge_u32_vcc %a, %b
      : (!waveamdmachine.reg<vgpr, 1, 0>, !waveamdmachine.reg<vgpr, 1, 1>)
        -> (!waveamdmachine.reg<sgpr, 2, 2>, !waveamdmachine.reg<vcc, 1>)
  %sum = waveamdmachine.v_add_u32 %a, %c
      : (!waveamdmachine.reg<vgpr, 1, 0>, !waveamdmachine.reg<vgpr, 1, 2>)
        -> !waveamdmachine.reg<vgpr, 1, 8>
  %pick = waveamdmachine.v_cndmask_b32_vcc %a, %sum, %vcc
      : (!waveamdmachine.reg<vgpr, 1, 0>, !waveamdmachine.reg<vgpr, 1, 8>,
         !waveamdmachine.reg<vcc, 1>) -> !waveamdmachine.reg<vgpr, 1, 9>
  %fill = waveamdmachine.v_xor_b32 %c, %d
      : (!waveamdmachine.reg<vgpr, 1, 2>, !waveamdmachine.reg<vgpr, 1, 3>)
        -> !waveamdmachine.reg<vgpr, 1, 10>
  waveamdmachine.s_endpgm
  return
}

}
