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
// ASM-NEXT: s_mov_b64 s[2:3], vcc
// ASM-NEXT: v_xor_b32_e32 v10, v2, v3
// ASM-NEXT: v_cndmask_b32_e32 v9, v0, v2, vcc
// ASM-NEXT: v_cndmask_b32_e64 v11, v0, v9, s[2:3]
// ASM-NOT: s_nop
// ASM: s_endpgm
func.func @vcc_hazard_schedule_codegen() attributes {wave.kernel} {
  %a = waveamdmachine.uninit : !waveamdmachine.reg<vgpr, 1, 0>
  %b = waveamdmachine.uninit : !waveamdmachine.reg<vgpr, 1, 1>
  %c = waveamdmachine.uninit : !waveamdmachine.reg<vgpr, 1, 2>
  %d = waveamdmachine.uninit : !waveamdmachine.reg<vgpr, 1, 3>
  %vcc = waveamdmachine.v_cmp_ge_u32_vcc %a, %b
      : (!waveamdmachine.reg<vgpr, 1, 0>, !waveamdmachine.reg<vgpr, 1, 1>)
        -> !waveamdmachine.reg<vcc, 1>
  %mask = waveamdmachine.s_read_vcc_b64 %vcc
      : (!waveamdmachine.reg<vcc, 1>) -> !waveamdmachine.reg<sgpr, 2, 2>
  %pick = waveamdmachine.v_cndmask_b32_vcc %a, %c, %vcc
      : (!waveamdmachine.reg<vgpr, 1, 0>, !waveamdmachine.reg<vgpr, 1, 2>,
         !waveamdmachine.reg<vcc, 1>) -> !waveamdmachine.reg<vgpr, 1, 9>
  %fill = waveamdmachine.v_xor_b32 %c, %d
      : (!waveamdmachine.reg<vgpr, 1, 2>, !waveamdmachine.reg<vgpr, 1, 3>)
        -> !waveamdmachine.reg<vgpr, 1, 10>
  %mask_pick = waveamdmachine.v_cndmask_b32_tuple %a, %pick, %mask
      : (!waveamdmachine.reg<vgpr, 1, 0>, !waveamdmachine.reg<vgpr, 1, 9>,
         !waveamdmachine.reg<sgpr, 2, 2>) -> !waveamdmachine.reg<vgpr, 1, 11>
  waveamdmachine.s_endpgm
  return
}

// ASM-LABEL: direct_sgpr_mask_hazard_schedule_codegen:
// ASM: v_cmp_ge_i32_e64 s[0:1], v0, v1
// ASM-NEXT: v_add_u32_e32 v8, v0, v2
// ASM-NEXT: v_xor_b32_e32 v9, v2, v3
// ASM-NEXT: v_cndmask_b32_e64 v10, v0, v1, s[0:1]
// ASM-NOT: s_nop
// ASM: s_endpgm
func.func @direct_sgpr_mask_hazard_schedule_codegen()
    attributes {wave.kernel} {
  %a = waveamdmachine.uninit : !waveamdmachine.reg<vgpr, 1, 0>
  %b = waveamdmachine.uninit : !waveamdmachine.reg<vgpr, 1, 1>
  %c = waveamdmachine.uninit : !waveamdmachine.reg<vgpr, 1, 2>
  %d = waveamdmachine.uninit : !waveamdmachine.reg<vgpr, 1, 3>
  %mask = waveamdmachine.v_cmp_ge_i32 %a, %b
      : (!waveamdmachine.reg<vgpr, 1, 0>, !waveamdmachine.reg<vgpr, 1, 1>)
        -> !waveamdmachine.reg<sgpr, 2, 0>
  %fill0 = waveamdmachine.v_add_u32 %a, %c
      : (!waveamdmachine.reg<vgpr, 1, 0>, !waveamdmachine.reg<vgpr, 1, 2>)
        -> !waveamdmachine.reg<vgpr, 1, 8>
  %fill1 = waveamdmachine.v_xor_b32 %c, %d
      : (!waveamdmachine.reg<vgpr, 1, 2>, !waveamdmachine.reg<vgpr, 1, 3>)
        -> !waveamdmachine.reg<vgpr, 1, 9>
  %pick = waveamdmachine.v_cndmask_b32_tuple %a, %b, %mask
      : (!waveamdmachine.reg<vgpr, 1, 0>, !waveamdmachine.reg<vgpr, 1, 1>,
         !waveamdmachine.reg<sgpr, 2, 0>)
        -> !waveamdmachine.reg<vgpr, 1, 10>
  waveamdmachine.s_endpgm
  return
}

// ASM-LABEL: compute_resource_schedule_codegen:
// ASM: v_mfma_f32_16x16x32_f16 v[8:11], v[0:3], v[4:7], v[8:11]
// ASM-NEXT: s_add_i32 s8, s0, s1
// ASM-NEXT: s_add_i32 s9, s2, s3
// ASM-NEXT: s_add_i32 s10, s4, s5
// ASM-NEXT: v_mfma_f32_16x16x32_f16 v[8:11], v[0:3], v[4:7], v[8:11]
// ASM-NEXT: s_add_i32 s11, s6, s7
// ASM-NOT: s_nop
// ASM: s_endpgm
func.func @compute_resource_schedule_codegen() attributes {wave.kernel} {
  %s0 = waveamdmachine.uninit : !waveamdmachine.reg<sgpr, 1, 0>
  %s1 = waveamdmachine.uninit : !waveamdmachine.reg<sgpr, 1, 1>
  %s2 = waveamdmachine.uninit : !waveamdmachine.reg<sgpr, 1, 2>
  %s3 = waveamdmachine.uninit : !waveamdmachine.reg<sgpr, 1, 3>
  %s4 = waveamdmachine.uninit : !waveamdmachine.reg<sgpr, 1, 4>
  %s5 = waveamdmachine.uninit : !waveamdmachine.reg<sgpr, 1, 5>
  %s6 = waveamdmachine.uninit : !waveamdmachine.reg<sgpr, 1, 6>
  %s7 = waveamdmachine.uninit : !waveamdmachine.reg<sgpr, 1, 7>
  %a = waveamdmachine.uninit : !waveamdmachine.reg<vgpr, 4, 0>
  %b = waveamdmachine.uninit : !waveamdmachine.reg<vgpr, 4, 4>
  %acc = waveamdmachine.uninit : !waveamdmachine.reg<vgpr, 4, 8>
  %x0, %cc0 = waveamdmachine.s_add_i32 %s0, %s1
      : (!waveamdmachine.reg<sgpr, 1, 0>, !waveamdmachine.reg<sgpr, 1, 1>)
        -> (!waveamdmachine.reg<sgpr, 1, 8>, !waveamdmachine.reg<scc, 1>)
  %x1, %cc1 = waveamdmachine.s_add_i32 %s2, %s3
      : (!waveamdmachine.reg<sgpr, 1, 2>, !waveamdmachine.reg<sgpr, 1, 3>)
        -> (!waveamdmachine.reg<sgpr, 1, 9>, !waveamdmachine.reg<scc, 1>)
  %x2, %cc2 = waveamdmachine.s_add_i32 %s4, %s5
      : (!waveamdmachine.reg<sgpr, 1, 4>, !waveamdmachine.reg<sgpr, 1, 5>)
        -> (!waveamdmachine.reg<sgpr, 1, 10>, !waveamdmachine.reg<scc, 1>)
  %x3, %cc3 = waveamdmachine.s_add_i32 %s6, %s7
      : (!waveamdmachine.reg<sgpr, 1, 6>, !waveamdmachine.reg<sgpr, 1, 7>)
        -> (!waveamdmachine.reg<sgpr, 1, 11>, !waveamdmachine.reg<scc, 1>)
  %r0 = waveamdmachine.mfma_f32_16x16x32_f16 %a, %b, %acc
      : (!waveamdmachine.reg<vgpr, 4, 0>, !waveamdmachine.reg<vgpr, 4, 4>,
         !waveamdmachine.reg<vgpr, 4, 8>) -> !waveamdmachine.reg<vgpr, 4, 8>
  %r1 = waveamdmachine.mfma_f32_16x16x32_f16 %a, %b, %r0
      : (!waveamdmachine.reg<vgpr, 4, 0>, !waveamdmachine.reg<vgpr, 4, 4>,
         !waveamdmachine.reg<vgpr, 4, 8>) -> !waveamdmachine.reg<vgpr, 4, 8>
  waveamdmachine.s_endpgm
  return
}

// ASM-LABEL: mfma_result_hazard_schedule_codegen:
// ASM: v_mfma_f32_16x16x32_f16 v[8:11]
// ASM-NEXT: v_mfma_f32_16x16x32_f16 v[12:15]
// ASM-NEXT: v_mfma_f32_16x16x32_f16 v[16:19]
// ASM-NEXT: v_mfma_f32_16x16x32_f16 v[20:23]
// ASM-NEXT: v_mfma_f32_16x16x32_f16 v[24:27]
// ASM-NEXT: v_mfma_f32_16x16x32_f16 v[28:31]
// ASM-NEXT: v_mfma_f32_16x16x32_f16 v[32:35]
// ASM-NEXT: v_mfma_f32_16x16x32_f16 v[36:39]
// ASM-NEXT: v_mfma_f32_16x16x32_f16 v[40:43]
// ASM-NEXT: v_cvt_pk_f16_f32 v44, v8, v9
// ASM-NOT: s_nop
// ASM: s_endpgm
func.func @mfma_result_hazard_schedule_codegen() attributes {wave.kernel} {
  %a = waveamdmachine.uninit : !waveamdmachine.reg<vgpr, 4, 0>
  %b = waveamdmachine.uninit : !waveamdmachine.reg<vgpr, 4, 4>
  %acc0 = waveamdmachine.uninit : !waveamdmachine.reg<vgpr, 4, 8>
  %acc1 = waveamdmachine.uninit : !waveamdmachine.reg<vgpr, 4, 12>
  %acc2 = waveamdmachine.uninit : !waveamdmachine.reg<vgpr, 4, 16>
  %acc3 = waveamdmachine.uninit : !waveamdmachine.reg<vgpr, 4, 20>
  %acc4 = waveamdmachine.uninit : !waveamdmachine.reg<vgpr, 4, 24>
  %acc5 = waveamdmachine.uninit : !waveamdmachine.reg<vgpr, 4, 28>
  %acc6 = waveamdmachine.uninit : !waveamdmachine.reg<vgpr, 4, 32>
  %acc7 = waveamdmachine.uninit : !waveamdmachine.reg<vgpr, 4, 36>
  %acc8 = waveamdmachine.uninit : !waveamdmachine.reg<vgpr, 4, 40>
  %r0 = waveamdmachine.mfma_f32_16x16x32_f16 %a, %b, %acc0
      : (!waveamdmachine.reg<vgpr, 4, 0>, !waveamdmachine.reg<vgpr, 4, 4>,
         !waveamdmachine.reg<vgpr, 4, 8>) -> !waveamdmachine.reg<vgpr, 4, 8>
  %parts:4 = waveamdmachine.tuple_to_elements %r0
      : (!waveamdmachine.reg<vgpr, 4, 8>)
        -> (!waveamdmachine.reg<vgpr, 1, 8>,
            !waveamdmachine.reg<vgpr, 1, 9>,
            !waveamdmachine.reg<vgpr, 1, 10>,
            !waveamdmachine.reg<vgpr, 1, 11>)
  %r1 = waveamdmachine.mfma_f32_16x16x32_f16 %a, %b, %acc1
      : (!waveamdmachine.reg<vgpr, 4, 0>, !waveamdmachine.reg<vgpr, 4, 4>,
         !waveamdmachine.reg<vgpr, 4, 12>) -> !waveamdmachine.reg<vgpr, 4, 12>
  %r2 = waveamdmachine.mfma_f32_16x16x32_f16 %a, %b, %acc2
      : (!waveamdmachine.reg<vgpr, 4, 0>, !waveamdmachine.reg<vgpr, 4, 4>,
         !waveamdmachine.reg<vgpr, 4, 16>) -> !waveamdmachine.reg<vgpr, 4, 16>
  %r3 = waveamdmachine.mfma_f32_16x16x32_f16 %a, %b, %acc3
      : (!waveamdmachine.reg<vgpr, 4, 0>, !waveamdmachine.reg<vgpr, 4, 4>,
         !waveamdmachine.reg<vgpr, 4, 20>) -> !waveamdmachine.reg<vgpr, 4, 20>
  %r4 = waveamdmachine.mfma_f32_16x16x32_f16 %a, %b, %acc4
      : (!waveamdmachine.reg<vgpr, 4, 0>, !waveamdmachine.reg<vgpr, 4, 4>,
         !waveamdmachine.reg<vgpr, 4, 24>) -> !waveamdmachine.reg<vgpr, 4, 24>
  %r5 = waveamdmachine.mfma_f32_16x16x32_f16 %a, %b, %acc5
      : (!waveamdmachine.reg<vgpr, 4, 0>, !waveamdmachine.reg<vgpr, 4, 4>,
         !waveamdmachine.reg<vgpr, 4, 28>) -> !waveamdmachine.reg<vgpr, 4, 28>
  %r6 = waveamdmachine.mfma_f32_16x16x32_f16 %a, %b, %acc6
      : (!waveamdmachine.reg<vgpr, 4, 0>, !waveamdmachine.reg<vgpr, 4, 4>,
         !waveamdmachine.reg<vgpr, 4, 32>) -> !waveamdmachine.reg<vgpr, 4, 32>
  %r7 = waveamdmachine.mfma_f32_16x16x32_f16 %a, %b, %acc7
      : (!waveamdmachine.reg<vgpr, 4, 0>, !waveamdmachine.reg<vgpr, 4, 4>,
         !waveamdmachine.reg<vgpr, 4, 36>) -> !waveamdmachine.reg<vgpr, 4, 36>
  %r8 = waveamdmachine.mfma_f32_16x16x32_f16 %a, %b, %acc8
      : (!waveamdmachine.reg<vgpr, 4, 0>, !waveamdmachine.reg<vgpr, 4, 4>,
         !waveamdmachine.reg<vgpr, 4, 40>) -> !waveamdmachine.reg<vgpr, 4, 40>
  %packed = waveamdmachine.v_cvt_pk_f16_f32 %parts#0, %parts#1
      : (!waveamdmachine.reg<vgpr, 1, 8>, !waveamdmachine.reg<vgpr, 1, 9>)
        -> !waveamdmachine.reg<vgpr, 1, 44>
  waveamdmachine.s_endpgm
  return
}

// ASM-LABEL: valu_to_mfma_hazard_schedule_codegen:
// ASM: v_mov_b32_e32 v0, 0
// ASM-NEXT: v_mov_b32_e32 v1, 0
// ASM-NEXT: v_mov_b32_e32 v2, 0
// ASM-NEXT: v_mov_b32_e32 v3, 0
// ASM-NEXT: v_xor_b32_e32 v14, v12, v13
// ASM-NEXT: v_add_u32_e32 v15, v12, v13
// ASM-NEXT: v_mfma_f32_16x16x32_f16 v[8:11], v[0:3]
// ASM-NOT: s_nop
// ASM: s_endpgm
func.func @valu_to_mfma_hazard_schedule_codegen() attributes {wave.kernel} {
  %zero = waveamdmachine.imm 0 : !waveamdmachine.imm
  %a = waveamdmachine.v_mov_b32_tuple %zero {registers = 4 : i64}
      : (!waveamdmachine.imm) -> !waveamdmachine.reg<vgpr, 4, 0>
  %b = waveamdmachine.uninit : !waveamdmachine.reg<vgpr, 4, 4>
  %acc = waveamdmachine.uninit : !waveamdmachine.reg<vgpr, 4, 8>
  %x = waveamdmachine.uninit : !waveamdmachine.reg<vgpr, 1, 12>
  %y = waveamdmachine.uninit : !waveamdmachine.reg<vgpr, 1, 13>
  %r = waveamdmachine.mfma_f32_16x16x32_f16 %a, %b, %acc
      : (!waveamdmachine.reg<vgpr, 4, 0>, !waveamdmachine.reg<vgpr, 4, 4>,
         !waveamdmachine.reg<vgpr, 4, 8>) -> !waveamdmachine.reg<vgpr, 4, 8>
  %fill0 = waveamdmachine.v_xor_b32 %x, %y
      : (!waveamdmachine.reg<vgpr, 1, 12>, !waveamdmachine.reg<vgpr, 1, 13>)
        -> !waveamdmachine.reg<vgpr, 1, 14>
  %fill1 = waveamdmachine.v_add_u32 %x, %y
      : (!waveamdmachine.reg<vgpr, 1, 12>, !waveamdmachine.reg<vgpr, 1, 13>)
        -> !waveamdmachine.reg<vgpr, 1, 15>
  waveamdmachine.s_endpgm
  return
}

// ASM-LABEL: permlane32_hazard_schedule_codegen:
// ASM: v_mov_b32_e32 v8, v0
// ASM-NEXT: v_mov_b32_e32 v9, v0
// ASM-NEXT: v_xor_b32_e32 v10, v1, v2
// ASM-NEXT: v_add_u32_e32 v11, v1, v2
// ASM-NEXT: v_permlane32_swap_b32_e32 v8, v9
// ASM-NOT: s_nop
// ASM: s_endpgm
func.func @permlane32_hazard_schedule_codegen() attributes {wave.kernel} {
  %src = waveamdmachine.uninit : !waveamdmachine.reg<vgpr, 1, 0>
  %x = waveamdmachine.uninit : !waveamdmachine.reg<vgpr, 1, 1>
  %y = waveamdmachine.uninit : !waveamdmachine.reg<vgpr, 1, 2>
  %pair = waveamdmachine.v_mov_b32_tuple %src {registers = 2 : i64}
      : (!waveamdmachine.reg<vgpr, 1, 0>)
        -> !waveamdmachine.reg<vgpr, 2, 8>
  %swapped = waveamdmachine.v_permlane32_swap_b32_tuple %pair
      : (!waveamdmachine.reg<vgpr, 2, 8>)
        -> !waveamdmachine.reg<vgpr, 2, 8>
  %fill0 = waveamdmachine.v_xor_b32 %x, %y
      : (!waveamdmachine.reg<vgpr, 1, 1>,
         !waveamdmachine.reg<vgpr, 1, 2>)
        -> !waveamdmachine.reg<vgpr, 1, 10>
  %fill1 = waveamdmachine.v_add_u32 %x, %y
      : (!waveamdmachine.reg<vgpr, 1, 1>,
         !waveamdmachine.reg<vgpr, 1, 2>)
        -> !waveamdmachine.reg<vgpr, 1, 11>
  waveamdmachine.s_endpgm
  return
}

}
