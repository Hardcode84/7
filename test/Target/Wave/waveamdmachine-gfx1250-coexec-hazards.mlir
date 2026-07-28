// RUN: wave-opt --waveamd-insert-hazard-waits -split-input-file %s | FileCheck %s
// RUN: wave-opt --waveamd-insert-hazard-waits -split-input-file %s \
// RUN:   | wave-opt --waveamd-insert-hazard-waits -split-input-file \
// RUN:   | FileCheck %s

module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx1250"} {

// CHECK-LABEL: func.func @trans_raw
// CHECK: waveamdmachine.v_exp_f32
// CHECK-NEXT: waveamdmachine.v_nop
// CHECK-NEXT: waveamdmachine.v_add_f32
func.func @trans_raw(
    %x: !waveamdmachine.reg<vgpr, 1, 0>,
    %y: !waveamdmachine.reg<vgpr, 1, 1>) {
  %exp = waveamdmachine.v_exp_f32 %x
      : (!waveamdmachine.reg<vgpr, 1, 0>)
      -> !waveamdmachine.reg<vgpr, 1, 2>
  %sum = waveamdmachine.v_add_f32 %exp, %y
      : (!waveamdmachine.reg<vgpr, 1, 2>,
         !waveamdmachine.reg<vgpr, 1, 1>)
      -> !waveamdmachine.reg<vgpr, 1, 3>
  return
}

// CHECK-LABEL: func.func @trans_war
// CHECK: waveamdmachine.v_exp_f32
// CHECK-NEXT: waveamdmachine.v_nop
// CHECK-NEXT: waveamdmachine.v_add_f32
func.func @trans_war(
    %x: !waveamdmachine.reg<vgpr, 1, 0>,
    %y: !waveamdmachine.reg<vgpr, 1, 1>,
    %z: !waveamdmachine.reg<vgpr, 1, 2>) {
  %exp = waveamdmachine.v_exp_f32 %x
      : (!waveamdmachine.reg<vgpr, 1, 0>)
      -> !waveamdmachine.reg<vgpr, 1, 3>
  %sum = waveamdmachine.v_add_f32 %y, %z
      : (!waveamdmachine.reg<vgpr, 1, 1>,
         !waveamdmachine.reg<vgpr, 1, 2>)
      -> !waveamdmachine.reg<vgpr, 1, 0>
  return
}

// CHECK-LABEL: func.func @scalar_does_not_age_trans
// CHECK: waveamdmachine.v_exp_f32
// CHECK-NEXT: waveamdmachine.s_nop
// CHECK-NEXT: waveamdmachine.v_nop
// CHECK-NEXT: waveamdmachine.v_add_f32
func.func @scalar_does_not_age_trans(
    %x: !waveamdmachine.reg<vgpr, 1, 0>,
    %y: !waveamdmachine.reg<vgpr, 1, 1>) {
  %zero = waveamdmachine.imm 0 : !waveamdmachine.imm
  %exp = waveamdmachine.v_exp_f32 %x
      : (!waveamdmachine.reg<vgpr, 1, 0>)
      -> !waveamdmachine.reg<vgpr, 1, 2>
  waveamdmachine.s_nop %zero : (!waveamdmachine.imm) -> ()
  %sum = waveamdmachine.v_add_f32 %exp, %y
      : (!waveamdmachine.reg<vgpr, 1, 2>,
         !waveamdmachine.reg<vgpr, 1, 1>)
      -> !waveamdmachine.reg<vgpr, 1, 3>
  return
}

// CHECK-LABEL: func.func @valu_ages_trans
// CHECK-NOT: waveamdmachine.v_nop
// CHECK: return
func.func @valu_ages_trans(
    %x: !waveamdmachine.reg<vgpr, 1, 0>,
    %y: !waveamdmachine.reg<vgpr, 1, 1>,
    %u: !waveamdmachine.reg<vgpr, 1, 4>,
    %v: !waveamdmachine.reg<vgpr, 1, 5>) {
  %exp = waveamdmachine.v_exp_f32 %x
      : (!waveamdmachine.reg<vgpr, 1, 0>)
      -> !waveamdmachine.reg<vgpr, 1, 2>
  %filler = waveamdmachine.v_add_f32 %u, %v
      : (!waveamdmachine.reg<vgpr, 1, 4>,
         !waveamdmachine.reg<vgpr, 1, 5>)
      -> !waveamdmachine.reg<vgpr, 1, 6>
  %sum = waveamdmachine.v_add_f32 %exp, %y
      : (!waveamdmachine.reg<vgpr, 1, 2>,
         !waveamdmachine.reg<vgpr, 1, 1>)
      -> !waveamdmachine.reg<vgpr, 1, 3>
  return
}

// CHECK-LABEL: func.func @full_va_vdst_wait_keeps_trans_coexec
// CHECK: waveamdmachine.v_exp_f32
// CHECK-NEXT: waveamdmachine.s_wait_alu va_vdst(0)
// CHECK-NEXT: waveamdmachine.v_nop
// CHECK-NEXT: waveamdmachine.v_add_f32
func.func @full_va_vdst_wait_keeps_trans_coexec(
    %x: !waveamdmachine.reg<vgpr, 1, 0>,
    %y: !waveamdmachine.reg<vgpr, 1, 1>) {
  %exp = waveamdmachine.v_exp_f32 %x
      : (!waveamdmachine.reg<vgpr, 1, 0>)
      -> !waveamdmachine.reg<vgpr, 1, 2>
  waveamdmachine.s_wait_alu va_vdst(0)
  %sum = waveamdmachine.v_add_f32 %exp, %y
      : (!waveamdmachine.reg<vgpr, 1, 2>,
         !waveamdmachine.reg<vgpr, 1, 1>)
      -> !waveamdmachine.reg<vgpr, 1, 3>
  return
}

// CHECK-LABEL: func.func @full_va_vdst_wait_clears_valu_delay
// CHECK: waveamdmachine.v_mov_b32_tuple
// CHECK-NEXT: waveamdmachine.s_wait_alu va_vdst(0)
// CHECK-NEXT: waveamdmachine.mfma_f32_16x16x16_f16
func.func @full_va_vdst_wait_clears_valu_delay(
    %b: !waveamdmachine.reg<vgpr, 2, 2>,
    %acc: !waveamdmachine.reg<vgpr, 4, 4>) {
  %zero = waveamdmachine.imm 0 : !waveamdmachine.imm
  %a = waveamdmachine.v_mov_b32_tuple %zero
      : (!waveamdmachine.imm) -> !waveamdmachine.reg<vgpr, 2, 0>
  waveamdmachine.s_wait_alu va_vdst(0)
  %result = waveamdmachine.mfma_f32_16x16x16_f16 %a, %b, %acc
      : (!waveamdmachine.reg<vgpr, 2, 0>,
         !waveamdmachine.reg<vgpr, 2, 2>,
         !waveamdmachine.reg<vgpr, 4, 4>)
      -> !waveamdmachine.reg<vgpr, 4, 8>
  return
}

// CHECK-LABEL: func.func @va_vdst_wait_keeps_valu_sgpr
// CHECK: waveamdmachine.v_readfirstlane_b32
// CHECK-NEXT: waveamdmachine.s_wait_alu va_vdst(0)
// CHECK-NEXT: waveamdmachine.s_nop
// CHECK-NEXT: waveamdmachine.s_nop
// CHECK-NEXT: waveamdmachine.s_nop
// CHECK-NEXT: waveamdmachine.imm 0
// CHECK-NEXT: waveamdmachine.s_nop
// CHECK-NEXT: waveamdmachine.scratch_load_b32
func.func @va_vdst_wait_keeps_valu_sgpr(
    %v: !waveamdmachine.reg<vgpr, 1, 0>) {
  %zero = waveamdmachine.imm 0 : !waveamdmachine.imm
  %lane = waveamdmachine.v_readfirstlane_b32 %v
      : (!waveamdmachine.reg<vgpr, 1, 0>)
      -> !waveamdmachine.reg<sgpr, 1, 20>
  waveamdmachine.s_wait_alu va_vdst(0)
  waveamdmachine.s_nop %zero : (!waveamdmachine.imm) -> ()
  waveamdmachine.s_nop %zero : (!waveamdmachine.imm) -> ()
  waveamdmachine.s_nop %zero : (!waveamdmachine.imm) -> ()
  %value, %token = waveamdmachine.scratch_load_b32 %zero, %lane
      : (!waveamdmachine.imm, !waveamdmachine.reg<sgpr, 1, 20>)
      -> (!waveamdmachine.reg<vgpr, 1, 1>,
          !waveamdmachine.mem.token)
  return
}

// CHECK-LABEL: func.func @va_sdst_wait_clears_valu_sgpr
// CHECK: waveamdmachine.v_readfirstlane_b32
// CHECK-NEXT: waveamdmachine.s_wait_alu va_sdst(0)
// CHECK-NEXT: waveamdmachine.scratch_load_b32
func.func @va_sdst_wait_clears_valu_sgpr(
    %v: !waveamdmachine.reg<vgpr, 1, 0>) {
  %zero = waveamdmachine.imm 0 : !waveamdmachine.imm
  %lane = waveamdmachine.v_readfirstlane_b32 %v
      : (!waveamdmachine.reg<vgpr, 1, 0>)
      -> !waveamdmachine.reg<sgpr, 1, 20>
  waveamdmachine.s_wait_alu va_sdst(0)
  %value, %token = waveamdmachine.scratch_load_b32 %zero, %lane
      : (!waveamdmachine.imm, !waveamdmachine.reg<sgpr, 1, 20>)
      -> (!waveamdmachine.reg<vgpr, 1, 1>,
          !waveamdmachine.mem.token)
  return
}

// CHECK-LABEL: func.func @partial_va_vdst_wait_keeps_valu_delay
// CHECK: waveamdmachine.v_mov_b32_tuple
// CHECK-NEXT: waveamdmachine.s_wait_alu va_vdst(1)
// CHECK-NEXT: waveamdmachine.imm 0
// CHECK-NEXT: waveamdmachine.s_nop
// CHECK-NEXT: waveamdmachine.mfma_f32_16x16x16_f16
func.func @partial_va_vdst_wait_keeps_valu_delay(
    %b: !waveamdmachine.reg<vgpr, 2, 2>,
    %acc: !waveamdmachine.reg<vgpr, 4, 4>) {
  %zero = waveamdmachine.imm 0 : !waveamdmachine.imm
  %a = waveamdmachine.v_mov_b32_tuple %zero
      : (!waveamdmachine.imm) -> !waveamdmachine.reg<vgpr, 2, 0>
  waveamdmachine.s_wait_alu va_vdst(1)
  %result = waveamdmachine.mfma_f32_16x16x16_f16 %a, %b, %acc
      : (!waveamdmachine.reg<vgpr, 2, 0>,
         !waveamdmachine.reg<vgpr, 2, 2>,
         !waveamdmachine.reg<vgpr, 4, 4>)
      -> !waveamdmachine.reg<vgpr, 4, 8>
  return
}

// CHECK-LABEL: func.func @trans_hazard_survives_join
// CHECK: cf.cond_br
// CHECK: ^bb{{[0-9]+}}:
// CHECK-NEXT: waveamdmachine.v_nop
// CHECK-NEXT: waveamdmachine.v_add_f32
// CHECK: waveamdmachine.v_exp_f32
// CHECK-NEXT: cf.br
func.func @trans_hazard_survives_join(
    %cond: i1,
    %x: !waveamdmachine.reg<vgpr, 1, 0>,
    %y: !waveamdmachine.reg<vgpr, 1, 1>,
    %reused: !waveamdmachine.reg<vgpr, 1, 2>) {
  cf.cond_br %cond, ^trans, ^join
^join:
  %sum = waveamdmachine.v_add_f32 %reused, %y
      : (!waveamdmachine.reg<vgpr, 1, 2>,
         !waveamdmachine.reg<vgpr, 1, 1>)
      -> !waveamdmachine.reg<vgpr, 1, 3>
  return
^trans:
  %exp = waveamdmachine.v_exp_f32 %x
      : (!waveamdmachine.reg<vgpr, 1, 0>)
      -> !waveamdmachine.reg<vgpr, 1, 2>
  cf.br ^join
}

// CHECK-LABEL: func.func @trans_hazard_survives_backedge
// CHECK: cf.br
// CHECK: ^bb{{[0-9]+}}:
// CHECK-NEXT: waveamdmachine.v_nop
// CHECK-NEXT: waveamdmachine.v_add_f32
// CHECK: waveamdmachine.v_exp_f32
// CHECK-NEXT: cf.br
func.func @trans_hazard_survives_backedge(
    %cond: i1,
    %x: !waveamdmachine.reg<vgpr, 1, 0>,
    %y: !waveamdmachine.reg<vgpr, 1, 1>,
    %reused: !waveamdmachine.reg<vgpr, 1, 2>) {
  cf.br ^loop
^loop:
  %sum = waveamdmachine.v_add_f32 %reused, %y
      : (!waveamdmachine.reg<vgpr, 1, 2>,
         !waveamdmachine.reg<vgpr, 1, 1>)
      -> !waveamdmachine.reg<vgpr, 1, 3>
  cf.cond_br %cond, ^exit, ^trans
^trans:
  %exp = waveamdmachine.v_exp_f32 %x
      : (!waveamdmachine.reg<vgpr, 1, 0>)
      -> !waveamdmachine.reg<vgpr, 1, 2>
  cf.br ^loop
^exit:
  return
}

}

// -----

module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx1250"} {

// CHECK-LABEL: func.func @wmma_to_wmma_raw
// CHECK: waveamdmachine.wmma_f32_16x16x32_f16
// CHECK-NEXT: waveamdmachine.v_nop
// CHECK-NEXT: waveamdmachine.v_nop
// CHECK-NEXT: waveamdmachine.v_nop
// CHECK-NEXT: waveamdmachine.v_nop
// CHECK-NEXT: waveamdmachine.v_nop
// CHECK-NEXT: waveamdmachine.wmma_f32_16x16x32_f16
func.func @wmma_to_wmma_raw(
    %a: !waveamdmachine.reg<vgpr, 8, 0>,
    %b: !waveamdmachine.reg<vgpr, 8, 8>,
    %acc: !waveamdmachine.reg<vgpr, 8, 16>,
    %next_b: !waveamdmachine.reg<vgpr, 8, 32>,
    %next_acc: !waveamdmachine.reg<vgpr, 8, 40>) {
  %first = waveamdmachine.wmma_f32_16x16x32_f16 %a, %b, %acc
      : (!waveamdmachine.reg<vgpr, 8, 0>,
         !waveamdmachine.reg<vgpr, 8, 8>,
         !waveamdmachine.reg<vgpr, 8, 16>)
      -> !waveamdmachine.reg<vgpr, 8, 24>
  %second = waveamdmachine.wmma_f32_16x16x32_f16
      %first, %next_b, %next_acc
      : (!waveamdmachine.reg<vgpr, 8, 24>,
         !waveamdmachine.reg<vgpr, 8, 32>,
         !waveamdmachine.reg<vgpr, 8, 40>)
      -> !waveamdmachine.reg<vgpr, 8, 48>
  return
}

// CHECK-LABEL: func.func @four_valus_leave_one_wmma_slot
// CHECK: waveamdmachine.wmma_f32_16x16x32_f16
// CHECK: waveamdmachine.v_add_f32
// CHECK: waveamdmachine.v_add_f32
// CHECK: waveamdmachine.v_add_f32
// CHECK: waveamdmachine.v_add_f32
// CHECK-NEXT: waveamdmachine.v_nop
// CHECK-NEXT: waveamdmachine.wmma_f32_16x16x32_f16
func.func @four_valus_leave_one_wmma_slot(
    %a: !waveamdmachine.reg<vgpr, 8, 0>,
    %b: !waveamdmachine.reg<vgpr, 8, 8>,
    %acc: !waveamdmachine.reg<vgpr, 8, 16>,
    %next_b: !waveamdmachine.reg<vgpr, 8, 32>,
    %next_acc: !waveamdmachine.reg<vgpr, 8, 40>,
    %x: !waveamdmachine.reg<vgpr, 1, 100>,
    %y: !waveamdmachine.reg<vgpr, 1, 101>) {
  %first = waveamdmachine.wmma_f32_16x16x32_f16 %a, %b, %acc
      : (!waveamdmachine.reg<vgpr, 8, 0>,
         !waveamdmachine.reg<vgpr, 8, 8>,
         !waveamdmachine.reg<vgpr, 8, 16>)
      -> !waveamdmachine.reg<vgpr, 8, 24>
  %v0 = waveamdmachine.v_add_f32 %x, %y
      : (!waveamdmachine.reg<vgpr, 1, 100>,
         !waveamdmachine.reg<vgpr, 1, 101>)
      -> !waveamdmachine.reg<vgpr, 1, 102>
  %v1 = waveamdmachine.v_add_f32 %v0, %y
      : (!waveamdmachine.reg<vgpr, 1, 102>,
         !waveamdmachine.reg<vgpr, 1, 101>)
      -> !waveamdmachine.reg<vgpr, 1, 103>
  %v2 = waveamdmachine.v_add_f32 %v1, %y
      : (!waveamdmachine.reg<vgpr, 1, 103>,
         !waveamdmachine.reg<vgpr, 1, 101>)
      -> !waveamdmachine.reg<vgpr, 1, 104>
  %v3 = waveamdmachine.v_add_f32 %v2, %y
      : (!waveamdmachine.reg<vgpr, 1, 104>,
         !waveamdmachine.reg<vgpr, 1, 101>)
      -> !waveamdmachine.reg<vgpr, 1, 105>
  %second = waveamdmachine.wmma_f32_16x16x32_f16
      %first, %next_b, %next_acc
      : (!waveamdmachine.reg<vgpr, 8, 24>,
         !waveamdmachine.reg<vgpr, 8, 32>,
         !waveamdmachine.reg<vgpr, 8, 40>)
      -> !waveamdmachine.reg<vgpr, 8, 48>
  return
}

// CHECK-LABEL: func.func @wmma_to_valu_raw
// CHECK: waveamdmachine.wmma_f32_16x16x32_f16
// CHECK-NEXT: waveamdmachine.v_nop
// CHECK-NEXT: waveamdmachine.v_nop
// CHECK-NEXT: waveamdmachine.v_nop
// CHECK-NEXT: waveamdmachine.v_nop
// CHECK-NEXT: waveamdmachine.v_mov_b32_tuple
func.func @wmma_to_valu_raw(
    %a: !waveamdmachine.reg<vgpr, 8, 0>,
    %b: !waveamdmachine.reg<vgpr, 8, 8>,
    %acc: !waveamdmachine.reg<vgpr, 8, 16>) {
  %first = waveamdmachine.wmma_f32_16x16x32_f16 %a, %b, %acc
      : (!waveamdmachine.reg<vgpr, 8, 0>,
         !waveamdmachine.reg<vgpr, 8, 8>,
         !waveamdmachine.reg<vgpr, 8, 16>)
      -> !waveamdmachine.reg<vgpr, 8, 24>
  %copy = waveamdmachine.v_mov_b32_tuple %first
      : (!waveamdmachine.reg<vgpr, 8, 24>)
      -> !waveamdmachine.reg<vgpr, 8, 32>
  return
}

// CHECK-LABEL: func.func @wmma_to_valu_war
// CHECK: waveamdmachine.wmma_f32_16x16x32_f16
// CHECK-NEXT: waveamdmachine.v_nop
// CHECK-NEXT: waveamdmachine.v_nop
// CHECK-NEXT: waveamdmachine.v_nop
// CHECK-NEXT: waveamdmachine.v_nop
// CHECK-NEXT: waveamdmachine.v_mov_b32_tuple
func.func @wmma_to_valu_war(
    %a: !waveamdmachine.reg<vgpr, 8, 0>,
    %b: !waveamdmachine.reg<vgpr, 8, 8>,
    %acc: !waveamdmachine.reg<vgpr, 8, 16>,
    %other: !waveamdmachine.reg<vgpr, 8, 32>) {
  %first = waveamdmachine.wmma_f32_16x16x32_f16 %a, %b, %acc
      : (!waveamdmachine.reg<vgpr, 8, 0>,
         !waveamdmachine.reg<vgpr, 8, 8>,
         !waveamdmachine.reg<vgpr, 8, 16>)
      -> !waveamdmachine.reg<vgpr, 8, 24>
  %copy = waveamdmachine.v_mov_b32_tuple %other
      : (!waveamdmachine.reg<vgpr, 8, 32>)
      -> !waveamdmachine.reg<vgpr, 8, 0>
  return
}

}
