// RUN: wave-opt --waveamd-insert-hazard-waits -split-input-file %s | FileCheck %s
// RUN: wave-opt --waveamd-insert-hazard-waits -split-input-file %s | wave-opt -split-input-file | FileCheck %s

module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx1100"} {

// CHECK-LABEL: func.func @delay_after_lgkm_wait
// CHECK: waveamdmachine.s_waitcnt
// CHECK-NEXT: waveamdmachine.imm 1
// CHECK-NEXT: waveamdmachine.s_delay_alu
// CHECK-NEXT: waveamdmachine.v_add_u32
func.func @delay_after_lgkm_wait(%x: !waveamdmachine.reg<vgpr, 1>, %y: !waveamdmachine.reg<sgpr, 1>) {
  %wait = waveamdmachine.imm 64519 : !waveamdmachine.imm
  waveamdmachine.s_waitcnt %wait : (!waveamdmachine.imm) -> ()
  %sum = waveamdmachine.v_add_u32 %x, %y : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<sgpr, 1>) -> !waveamdmachine.reg<vgpr, 1>
  return
}

// CHECK-LABEL: func.func @delay_before_fpconvert_after_lgkm_wait
// CHECK: waveamdmachine.s_waitcnt
// CHECK-NEXT: waveamdmachine.imm 1
// CHECK-NEXT: waveamdmachine.s_delay_alu
// CHECK-NEXT: waveamdmachine.v_cvt_f16_f32
// CHECK-NEXT: waveamdmachine.v_cvt_f32_f16
func.func @delay_before_fpconvert_after_lgkm_wait(%x: !waveamdmachine.reg<vgpr, 1>) {
  %wait = waveamdmachine.imm 64519 : !waveamdmachine.imm
  waveamdmachine.s_waitcnt %wait : (!waveamdmachine.imm) -> ()
  %h = waveamdmachine.v_cvt_f16_f32 %x
      : (!waveamdmachine.reg<vgpr, 1>) -> !waveamdmachine.reg<vgpr, 1>
  %f = waveamdmachine.v_cvt_f32_f16 %h
      : (!waveamdmachine.reg<vgpr, 1>) -> !waveamdmachine.reg<vgpr, 1>
  return
}

// CHECK-LABEL: func.func @no_delay_after_vmcnt_wait
// CHECK: waveamdmachine.s_waitcnt
// CHECK-NEXT: waveamdmachine.v_add_u32
func.func @no_delay_after_vmcnt_wait(%x: !waveamdmachine.reg<vgpr, 1>, %y: !waveamdmachine.reg<sgpr, 1>) {
  %wait = waveamdmachine.imm 1023 : !waveamdmachine.imm
  waveamdmachine.s_waitcnt %wait : (!waveamdmachine.imm) -> ()
  %sum = waveamdmachine.v_add_u32 %x, %y : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<sgpr, 1>) -> !waveamdmachine.reg<vgpr, 1>
  return
}

// CFG joins merge armed VALU-after-LGKM state from every predecessor.
// Textual block order is irrelevant.
// CHECK-LABEL: func.func @delay_after_lgkm_wait_across_join
// CHECK: cf.cond_br
// CHECK: ^bb{{[0-9]+}}:
// CHECK-NEXT: waveamdmachine.imm 1
// CHECK-NEXT: waveamdmachine.s_delay_alu
// CHECK-NEXT: waveamdmachine.v_add_u32
// CHECK: waveamdmachine.s_waitcnt
func.func @delay_after_lgkm_wait_across_join(%cond: i1,
                                             %x: !waveamdmachine.reg<vgpr, 1>,
                                             %y: !waveamdmachine.reg<sgpr, 1>) {
  cf.cond_br %cond, ^wait, ^join
^join:
  %sum = waveamdmachine.v_add_u32 %x, %y
      : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<sgpr, 1>)
      -> !waveamdmachine.reg<vgpr, 1>
  return
^wait:
  %wait = waveamdmachine.imm 64519 : !waveamdmachine.imm
  waveamdmachine.s_waitcnt %wait : (!waveamdmachine.imm) -> ()
  cf.br ^join
}

// A wait in one sibling arm must not arm the mutually exclusive arm.
// CHECK-LABEL: func.func @no_delay_after_lgkm_wait_in_sibling_arm
// CHECK: cf.cond_br
// CHECK: waveamdmachine.s_waitcnt
// CHECK-NOT: waveamdmachine.s_delay_alu
// CHECK: waveamdmachine.v_add_u32
func.func @no_delay_after_lgkm_wait_in_sibling_arm(
    %cond: i1,
    %x: !waveamdmachine.reg<vgpr, 1>,
    %y: !waveamdmachine.reg<sgpr, 1>) {
  cf.cond_br %cond, ^wait, ^valu
^wait:
  %wait = waveamdmachine.imm 64519 : !waveamdmachine.imm
  waveamdmachine.s_waitcnt %wait : (!waveamdmachine.imm) -> ()
  cf.br ^exit
^valu:
  %sum = waveamdmachine.v_add_u32 %x, %y
      : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<sgpr, 1>)
      -> !waveamdmachine.reg<vgpr, 1>
  cf.br ^exit
^exit:
  return
}

// A `waveamdmachine.uniform_loop` body must also be inspected: a partial
// lgkmcnt wait inside the loop has to insert the same VALU mitigation
// as it would at the top level.
// CHECK-LABEL: func.func @delay_inside_uniform_loop
// CHECK: waveamdmachine.uniform_loop
// CHECK:   waveamdmachine.s_waitcnt
// CHECK-NEXT: waveamdmachine.imm 1
// CHECK-NEXT: waveamdmachine.s_delay_alu
// CHECK-NEXT: waveamdmachine.v_add_u32
func.func @delay_inside_uniform_loop(%x: !waveamdmachine.reg<vgpr, 1>, %y: !waveamdmachine.reg<sgpr, 1>, %ec: !waveamdmachine.reg<scc, 1>) {
  waveamdmachine.uniform_loop if %ec : !waveamdmachine.reg<scc, 1> {
    %wait = waveamdmachine.imm 64519 : !waveamdmachine.imm
    waveamdmachine.s_waitcnt %wait : (!waveamdmachine.imm) -> ()
    %sum = waveamdmachine.v_add_u32 %x, %y : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<sgpr, 1>) -> !waveamdmachine.reg<vgpr, 1>
    waveamdmachine.continue_if %ec : !waveamdmachine.reg<scc, 1>
  }
  return
}

// Parent LGKM state must enter a taken uniform_loop body.
// CHECK-LABEL: func.func @delay_on_uniform_loop_entry_after_lgkm_wait
// CHECK: waveamdmachine.s_waitcnt
// CHECK: waveamdmachine.uniform_loop
// CHECK: waveamdmachine.imm 1
// CHECK-NEXT: waveamdmachine.s_delay_alu
// CHECK-NEXT: waveamdmachine.v_add_u32
func.func @delay_on_uniform_loop_entry_after_lgkm_wait(
    %x: !waveamdmachine.reg<vgpr, 1>,
    %y: !waveamdmachine.reg<sgpr, 1>,
    %ec: !waveamdmachine.reg<scc, 1>) {
  %wait = waveamdmachine.imm 64519 : !waveamdmachine.imm
  waveamdmachine.s_waitcnt %wait : (!waveamdmachine.imm) -> ()
  waveamdmachine.uniform_loop if %ec : !waveamdmachine.reg<scc, 1> {
    %sum = waveamdmachine.v_add_u32 %x, %y
        : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<sgpr, 1>)
        -> !waveamdmachine.reg<vgpr, 1>
    waveamdmachine.continue_if %ec : !waveamdmachine.reg<scc, 1>
  }
  return
}

// Uniform_loop exit state must reach the parent continuation.
// CHECK-LABEL: func.func @delay_after_uniform_loop_exit_lgkm_wait
// CHECK: waveamdmachine.uniform_loop
// CHECK: waveamdmachine.s_waitcnt
// CHECK: waveamdmachine.continue_if
// CHECK: }
// CHECK-NEXT: waveamdmachine.imm 1
// CHECK-NEXT: waveamdmachine.s_delay_alu
// CHECK-NEXT: waveamdmachine.v_add_u32
func.func @delay_after_uniform_loop_exit_lgkm_wait(
    %x: !waveamdmachine.reg<vgpr, 1>,
    %y: !waveamdmachine.reg<sgpr, 1>,
    %ec: !waveamdmachine.reg<scc, 1>) {
  waveamdmachine.uniform_loop if %ec : !waveamdmachine.reg<scc, 1> {
    %wait = waveamdmachine.imm 64519 : !waveamdmachine.imm
    waveamdmachine.s_waitcnt %wait : (!waveamdmachine.imm) -> ()
    waveamdmachine.continue_if %ec : !waveamdmachine.reg<scc, 1>
  }
  %sum = waveamdmachine.v_add_u32 %x, %y
      : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<sgpr, 1>)
      -> !waveamdmachine.reg<vgpr, 1>
  return
}

}

// -----

module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx1030"} {

// CHECK-LABEL: func.func @nop_delay_on_gfx10
// CHECK: waveamdmachine.s_waitcnt
// CHECK-NEXT: waveamdmachine.imm 0
// CHECK-NEXT: waveamdmachine.s_nop
// CHECK-NEXT: waveamdmachine.v_add_u32
func.func @nop_delay_on_gfx10(%x: !waveamdmachine.reg<vgpr, 1>, %y: !waveamdmachine.reg<sgpr, 1>) {
  %wait = waveamdmachine.imm 0 : !waveamdmachine.imm
  waveamdmachine.s_waitcnt %wait : (!waveamdmachine.imm) -> ()
  %sum = waveamdmachine.v_add_u32 %x, %y : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<sgpr, 1>) -> !waveamdmachine.reg<vgpr, 1>
  return
}

}

// -----

module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx950"} {

// CHECK-LABEL: func.func @cdna4_mfma_result_store_delay
// CHECK: waveamdmachine.mfma_f32_16x16x32_f16
// CHECK-NEXT: waveamdmachine.imm 7
// CHECK-NEXT: waveamdmachine.s_nop
// CHECK-NEXT: waveamdmachine.global_store_b128
func.func @cdna4_mfma_result_store_delay(
    %a: !waveamdmachine.reg<vgpr, 4>,
    %b: !waveamdmachine.reg<vgpr, 4>,
    %acc: !waveamdmachine.reg<vgpr, 4>,
    %off: !waveamdmachine.reg<vgpr, 1>,
    %base: !waveamdmachine.reg<sgpr, 2>) {
  %r = waveamdmachine.mfma_f32_16x16x32_f16 %a, %b, %acc
      : (!waveamdmachine.reg<vgpr, 4>, !waveamdmachine.reg<vgpr, 4>,
         !waveamdmachine.reg<vgpr, 4>) -> !waveamdmachine.reg<vgpr, 4>
  %tok = waveamdmachine.global_store_b128 %off, %r, %base
      : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 4>,
         !waveamdmachine.reg<sgpr, 2>) -> !waveamdmachine.mem.token
  return
}

// CHECK-LABEL: func.func @m0_delay_before_lds_dma
// CHECK: waveamdmachine.s_mov_m0
// CHECK-NEXT: waveamdmachine.imm 0
// CHECK-NEXT: waveamdmachine.s_nop
// CHECK-NEXT: waveamdmachine.global_load_lds_b128
func.func @m0_delay_before_lds_dma(
    %off: !waveamdmachine.reg<vgpr, 1>,
    %base: !waveamdmachine.reg<sgpr, 2>,
    %dst: !waveamdmachine.reg<sgpr, 1>,
    %dep: !waveamdmachine.mem.token) {
  %m0 = waveamdmachine.s_mov_m0 %dst
      : (!waveamdmachine.reg<sgpr, 1>) -> !waveamdmachine.m0
  %tok = waveamdmachine.global_load_lds_b128 %off, %base, %m0 after %dep
      : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<sgpr, 2>,
         !waveamdmachine.m0, !waveamdmachine.mem.token)
      -> !waveamdmachine.mem.token
  return
}

// CHECK-LABEL: func.func @m0_delay_after_waitcnt
// CHECK: waveamdmachine.s_mov_m0
// CHECK-NEXT: waveamdmachine.imm 0
// CHECK-NEXT: waveamdmachine.s_waitcnt
// CHECK-NEXT: waveamdmachine.imm 0
// CHECK-NEXT: waveamdmachine.s_nop
// CHECK-NEXT: waveamdmachine.global_load_lds_b128
func.func @m0_delay_after_waitcnt(
    %off: !waveamdmachine.reg<vgpr, 1>,
    %base: !waveamdmachine.reg<sgpr, 2>,
    %dst: !waveamdmachine.reg<sgpr, 1>,
    %dep: !waveamdmachine.mem.token) {
  %m0 = waveamdmachine.s_mov_m0 %dst
      : (!waveamdmachine.reg<sgpr, 1>) -> !waveamdmachine.m0
  %wait = waveamdmachine.imm 0 : !waveamdmachine.imm
  waveamdmachine.s_waitcnt %wait : (!waveamdmachine.imm) -> ()
  %tok = waveamdmachine.global_load_lds_b128 %off, %base, %m0 after %dep
      : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<sgpr, 2>,
         !waveamdmachine.m0, !waveamdmachine.mem.token)
      -> !waveamdmachine.mem.token
  return
}

}

// -----

module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx942"} {

// CHECK-LABEL: func.func @cdna3_mfma_result_store_delay
// CHECK: waveamdmachine.mfma_f32_16x16x16_f16
// CHECK-NEXT: waveamdmachine.imm 6
// CHECK-NEXT: waveamdmachine.s_nop
// CHECK-NEXT: waveamdmachine.global_store_b128
func.func @cdna3_mfma_result_store_delay(
    %a: !waveamdmachine.reg<vgpr, 2>,
    %b: !waveamdmachine.reg<vgpr, 2>,
    %acc: !waveamdmachine.reg<vgpr, 4>,
    %off: !waveamdmachine.reg<vgpr, 1>,
    %base: !waveamdmachine.reg<sgpr, 2>) {
  %r = waveamdmachine.mfma_f32_16x16x16_f16 %a, %b, %acc
      : (!waveamdmachine.reg<vgpr, 2>, !waveamdmachine.reg<vgpr, 2>,
         !waveamdmachine.reg<vgpr, 4>) -> !waveamdmachine.reg<vgpr, 4>
  %tok = waveamdmachine.global_store_b128 %off, %r, %base
      : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 4>,
         !waveamdmachine.reg<sgpr, 2>) -> !waveamdmachine.mem.token
  return
}

// CHECK-LABEL: func.func @cdna3_mfma_src_ab_overlap
// CHECK: waveamdmachine.mfma_f32_16x16x16_f16
// CHECK-NEXT: waveamdmachine.imm 6
// CHECK-NEXT: waveamdmachine.s_nop
// CHECK-NEXT: waveamdmachine.mfma_f32_16x16x16_f16
func.func @cdna3_mfma_src_ab_overlap(
    %a: !waveamdmachine.reg<vgpr, 2, 0>,
    %b: !waveamdmachine.reg<vgpr, 2, 4>,
    %acc: !waveamdmachine.reg<vgpr, 4, 8>,
    %next_a: !waveamdmachine.reg<vgpr, 2, 10>,
    %next_b: !waveamdmachine.reg<vgpr, 2, 20>,
    %next_acc: !waveamdmachine.reg<vgpr, 4, 24>) {
  %r = waveamdmachine.mfma_f32_16x16x16_f16 %a, %b, %acc
      : (!waveamdmachine.reg<vgpr, 2, 0>, !waveamdmachine.reg<vgpr, 2, 4>,
         !waveamdmachine.reg<vgpr, 4, 8>) -> !waveamdmachine.reg<vgpr, 4, 8>
  %next = waveamdmachine.mfma_f32_16x16x16_f16 %next_a, %next_b, %next_acc
      : (!waveamdmachine.reg<vgpr, 2, 10>, !waveamdmachine.reg<vgpr, 2, 20>,
         !waveamdmachine.reg<vgpr, 4, 24>) -> !waveamdmachine.reg<vgpr, 4, 32>
  return
}

// CHECK-LABEL: func.func @cdna3_mfma_src_c_overlap
// CHECK: waveamdmachine.mfma_f32_16x16x16_f16
// CHECK-NEXT: waveamdmachine.imm 4
// CHECK-NEXT: waveamdmachine.s_nop
// CHECK-NEXT: waveamdmachine.mfma_f32_16x16x16_f16
func.func @cdna3_mfma_src_c_overlap(
    %a: !waveamdmachine.reg<vgpr, 2, 0>,
    %b: !waveamdmachine.reg<vgpr, 2, 4>,
    %acc: !waveamdmachine.reg<vgpr, 4, 8>,
    %next_a: !waveamdmachine.reg<vgpr, 2, 20>,
    %next_b: !waveamdmachine.reg<vgpr, 2, 24>,
    %next_acc: !waveamdmachine.reg<vgpr, 4, 10>) {
  %r = waveamdmachine.mfma_f32_16x16x16_f16 %a, %b, %acc
      : (!waveamdmachine.reg<vgpr, 2, 0>, !waveamdmachine.reg<vgpr, 2, 4>,
         !waveamdmachine.reg<vgpr, 4, 8>) -> !waveamdmachine.reg<vgpr, 4, 8>
  %next = waveamdmachine.mfma_f32_16x16x16_f16 %next_a, %next_b, %next_acc
      : (!waveamdmachine.reg<vgpr, 2, 20>, !waveamdmachine.reg<vgpr, 2, 24>,
         !waveamdmachine.reg<vgpr, 4, 10>) -> !waveamdmachine.reg<vgpr, 4, 32>
  return
}

}

// -----

module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx950"} {

// CHECK-LABEL: func.func @mfma_result_store_delay_ignores_preloaded
// CHECK: waveamdmachine.mfma_f32_16x16x32_f16
// CHECK: waveamdmachine.v_workitem_id_x
// CHECK: waveamdmachine.v_and_b32
// CHECK: waveamdmachine.v_mul_lo_u32
// CHECK: waveamdmachine.v_lshlrev_b32
// CHECK-NEXT: waveamdmachine.imm 4
// CHECK-NEXT: waveamdmachine.s_nop
// CHECK-NEXT: waveamdmachine.global_store_b128
func.func @mfma_result_store_delay_ignores_preloaded(
    %a: !waveamdmachine.reg<vgpr, 4>,
    %b: !waveamdmachine.reg<vgpr, 4>,
    %acc: !waveamdmachine.reg<vgpr, 4>,
    %base: !waveamdmachine.reg<sgpr, 2>) {
  %r = waveamdmachine.mfma_f32_16x16x32_f16 %a, %b, %acc
      : (!waveamdmachine.reg<vgpr, 4>, !waveamdmachine.reg<vgpr, 4>,
         !waveamdmachine.reg<vgpr, 4>) -> !waveamdmachine.reg<vgpr, 4>
  %wi = waveamdmachine.v_workitem_id_x : !waveamdmachine.reg<vgpr, 1, 0>
  %mask = waveamdmachine.imm 63 : !waveamdmachine.imm
  %lane = waveamdmachine.v_and_b32 %wi, %mask
      : (!waveamdmachine.reg<vgpr, 1, 0>, !waveamdmachine.imm)
      -> !waveamdmachine.reg<vgpr, 1>
  %four = waveamdmachine.imm 4 : !waveamdmachine.imm
  %scaled = waveamdmachine.v_mul_lo_u32 %four, %lane
      : (!waveamdmachine.imm, !waveamdmachine.reg<vgpr, 1>)
      -> !waveamdmachine.reg<vgpr, 1>
  %two = waveamdmachine.imm 2 : !waveamdmachine.imm
  %off = waveamdmachine.v_lshlrev_b32 %scaled, %two
      : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.imm)
      -> !waveamdmachine.reg<vgpr, 1>
  %tok = waveamdmachine.global_store_b128 %off, %r, %base
      : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 4>,
         !waveamdmachine.reg<sgpr, 2>) -> !waveamdmachine.mem.token
  return
}

// CHECK-LABEL: func.func @cdna4_mfma_src_ab_overlap
// CHECK: waveamdmachine.mfma_f32_16x16x32_f16
// CHECK-NEXT: waveamdmachine.imm 7
// CHECK-NEXT: waveamdmachine.s_nop
// CHECK-NEXT: waveamdmachine.mfma_f32_16x16x32_f16
func.func @cdna4_mfma_src_ab_overlap(
    %a: !waveamdmachine.reg<vgpr, 4, 0>,
    %b: !waveamdmachine.reg<vgpr, 4, 4>,
    %acc: !waveamdmachine.reg<vgpr, 4, 8>,
    %next_a: !waveamdmachine.reg<vgpr, 4, 10>,
    %next_b: !waveamdmachine.reg<vgpr, 4, 20>,
    %next_acc: !waveamdmachine.reg<vgpr, 4, 24>) {
  %r = waveamdmachine.mfma_f32_16x16x32_f16 %a, %b, %acc
      : (!waveamdmachine.reg<vgpr, 4, 0>, !waveamdmachine.reg<vgpr, 4, 4>,
         !waveamdmachine.reg<vgpr, 4, 8>) -> !waveamdmachine.reg<vgpr, 4, 8>
  %next = waveamdmachine.mfma_f32_16x16x32_f16 %next_a, %next_b, %next_acc
      : (!waveamdmachine.reg<vgpr, 4, 10>, !waveamdmachine.reg<vgpr, 4, 20>,
         !waveamdmachine.reg<vgpr, 4, 24>) -> !waveamdmachine.reg<vgpr, 4, 32>
  return
}

// CHECK-LABEL: func.func @cdna4_mfma_src_c_exact_no_delay
// CHECK: waveamdmachine.mfma_f32_16x16x32_f16
// CHECK-NEXT: waveamdmachine.mfma_f32_16x16x32_f16
func.func @cdna4_mfma_src_c_exact_no_delay(
    %a: !waveamdmachine.reg<vgpr, 4, 0>,
    %b: !waveamdmachine.reg<vgpr, 4, 4>,
    %acc: !waveamdmachine.reg<vgpr, 4, 8>,
    %next_a: !waveamdmachine.reg<vgpr, 4, 20>,
    %next_b: !waveamdmachine.reg<vgpr, 4, 24>) {
  %r = waveamdmachine.mfma_f32_16x16x32_f16 %a, %b, %acc
      : (!waveamdmachine.reg<vgpr, 4, 0>, !waveamdmachine.reg<vgpr, 4, 4>,
         !waveamdmachine.reg<vgpr, 4, 8>) -> !waveamdmachine.reg<vgpr, 4, 8>
  %next = waveamdmachine.mfma_f32_16x16x32_f16 %next_a, %next_b, %r
      : (!waveamdmachine.reg<vgpr, 4, 20>, !waveamdmachine.reg<vgpr, 4, 24>,
         !waveamdmachine.reg<vgpr, 4, 8>) -> !waveamdmachine.reg<vgpr, 4, 32>
  return
}

// CHECK-LABEL: func.func @cdna4_mfma_src_c_overlap
// CHECK: waveamdmachine.mfma_f32_16x16x32_f16
// CHECK-NEXT: waveamdmachine.imm 5
// CHECK-NEXT: waveamdmachine.s_nop
// CHECK-NEXT: waveamdmachine.mfma_f32_16x16x32_f16
func.func @cdna4_mfma_src_c_overlap(
    %a: !waveamdmachine.reg<vgpr, 4, 0>,
    %b: !waveamdmachine.reg<vgpr, 4, 4>,
    %acc: !waveamdmachine.reg<vgpr, 4, 8>,
    %next_a: !waveamdmachine.reg<vgpr, 4, 20>,
    %next_b: !waveamdmachine.reg<vgpr, 4, 24>,
    %next_acc: !waveamdmachine.reg<vgpr, 4, 10>) {
  %r = waveamdmachine.mfma_f32_16x16x32_f16 %a, %b, %acc
      : (!waveamdmachine.reg<vgpr, 4, 0>, !waveamdmachine.reg<vgpr, 4, 4>,
         !waveamdmachine.reg<vgpr, 4, 8>) -> !waveamdmachine.reg<vgpr, 4, 8>
  %next = waveamdmachine.mfma_f32_16x16x32_f16 %next_a, %next_b, %next_acc
      : (!waveamdmachine.reg<vgpr, 4, 20>, !waveamdmachine.reg<vgpr, 4, 24>,
         !waveamdmachine.reg<vgpr, 4, 10>) -> !waveamdmachine.reg<vgpr, 4, 32>
  return
}

// CHECK-LABEL: func.func @cdna4_mfma_result_valu_read_overlap
// CHECK: waveamdmachine.mfma_f32_16x16x32_f16
// CHECK-NEXT: waveamdmachine.imm 7
// CHECK-NEXT: waveamdmachine.s_nop
// CHECK-NEXT: waveamdmachine.v_add_u32
func.func @cdna4_mfma_result_valu_read_overlap(
    %a: !waveamdmachine.reg<vgpr, 4, 0>,
    %b: !waveamdmachine.reg<vgpr, 4, 4>,
    %acc: !waveamdmachine.reg<vgpr, 4, 8>,
    %overlap: !waveamdmachine.reg<vgpr, 1, 9>,
    %s: !waveamdmachine.reg<sgpr, 1, 0>) {
  %r = waveamdmachine.mfma_f32_16x16x32_f16 %a, %b, %acc
      : (!waveamdmachine.reg<vgpr, 4, 0>, !waveamdmachine.reg<vgpr, 4, 4>,
         !waveamdmachine.reg<vgpr, 4, 8>) -> !waveamdmachine.reg<vgpr, 4, 8>
  %sum = waveamdmachine.v_add_u32 %overlap, %s
      : (!waveamdmachine.reg<vgpr, 1, 9>, !waveamdmachine.reg<sgpr, 1, 0>)
      -> !waveamdmachine.reg<vgpr, 1, 30>
  return
}

// CHECK-LABEL: func.func @cdna4_mfma_result_valu_write_overlap
// CHECK: waveamdmachine.mfma_f32_16x16x32_f16
// CHECK-NEXT: waveamdmachine.imm 7
// CHECK-NEXT: waveamdmachine.s_nop
// CHECK-NEXT: waveamdmachine.v_add_u32
func.func @cdna4_mfma_result_valu_write_overlap(
    %a: !waveamdmachine.reg<vgpr, 4, 0>,
    %b: !waveamdmachine.reg<vgpr, 4, 4>,
    %acc: !waveamdmachine.reg<vgpr, 4, 8>,
    %x: !waveamdmachine.reg<vgpr, 1, 30>,
    %s: !waveamdmachine.reg<sgpr, 1, 0>) {
  %r = waveamdmachine.mfma_f32_16x16x32_f16 %a, %b, %acc
      : (!waveamdmachine.reg<vgpr, 4, 0>, !waveamdmachine.reg<vgpr, 4, 4>,
         !waveamdmachine.reg<vgpr, 4, 8>) -> !waveamdmachine.reg<vgpr, 4, 8>
  %sum = waveamdmachine.v_add_u32 %x, %s
      : (!waveamdmachine.reg<vgpr, 1, 30>, !waveamdmachine.reg<sgpr, 1, 0>)
      -> !waveamdmachine.reg<vgpr, 1, 9>
  return
}

// CHECK-LABEL: func.func @cdna4_mfma_result_vmem_write_overlap
// CHECK: waveamdmachine.mfma_f32_16x16x32_f16
// CHECK-NEXT: waveamdmachine.imm 7
// CHECK-NEXT: waveamdmachine.s_nop
// CHECK-NEXT: waveamdmachine.buffer_load_b32
func.func @cdna4_mfma_result_vmem_write_overlap(
    %a: !waveamdmachine.reg<vgpr, 4, 0>,
    %b: !waveamdmachine.reg<vgpr, 4, 4>,
    %acc: !waveamdmachine.reg<vgpr, 4, 8>,
    %off: !waveamdmachine.reg<vgpr, 1, 30>,
    %desc: !waveamdmachine.reg<sgpr, 4, 0>,
    %zero: !waveamdmachine.reg<sgpr, 1, 4>,
    %dep: !waveamdmachine.mem.token) {
  %r = waveamdmachine.mfma_f32_16x16x32_f16 %a, %b, %acc
      : (!waveamdmachine.reg<vgpr, 4, 0>, !waveamdmachine.reg<vgpr, 4, 4>,
         !waveamdmachine.reg<vgpr, 4, 8>) -> !waveamdmachine.reg<vgpr, 4, 8>
  %loaded, %tok = waveamdmachine.buffer_load_b32 %off, %desc, %zero after %dep
      : (!waveamdmachine.reg<vgpr, 1, 30>, !waveamdmachine.reg<sgpr, 4, 0>,
         !waveamdmachine.reg<sgpr, 1, 4>, !waveamdmachine.mem.token)
      -> (!waveamdmachine.reg<vgpr, 1, 9>, !waveamdmachine.mem.token)
  return
}

// CHECK-LABEL: func.func @store_writedata_overwrite_delay
// CHECK: waveamdmachine.global_store_b128
// CHECK-NEXT: waveamdmachine.imm 1
// CHECK-NEXT: waveamdmachine.s_nop
// CHECK-NEXT: waveamdmachine.v_add_u32
func.func @store_writedata_overwrite_delay(
    %off: !waveamdmachine.reg<vgpr, 1, 0>,
    %data: !waveamdmachine.reg<vgpr, 4, 8>,
    %base: !waveamdmachine.reg<sgpr, 2, 0>,
    %x: !waveamdmachine.reg<vgpr, 1, 30>,
    %s: !waveamdmachine.reg<sgpr, 1, 2>) {
  %tok = waveamdmachine.global_store_b128 %off, %data, %base
      : (!waveamdmachine.reg<vgpr, 1, 0>, !waveamdmachine.reg<vgpr, 4, 8>,
         !waveamdmachine.reg<sgpr, 2, 0>) -> !waveamdmachine.mem.token
  %sum = waveamdmachine.v_add_u32 %x, %s
      : (!waveamdmachine.reg<vgpr, 1, 30>, !waveamdmachine.reg<sgpr, 1, 2>)
      -> !waveamdmachine.reg<vgpr, 1, 9>
  return
}

// CHECK-LABEL: func.func @valu_sgpr_to_vmem_delay
// CHECK: waveamdmachine.v_cmp_eq_u32
// CHECK-NEXT: waveamdmachine.imm 4
// CHECK-NEXT: waveamdmachine.s_nop
// CHECK-NEXT: waveamdmachine.buffer_load_b32
func.func @valu_sgpr_to_vmem_delay(
    %x: !waveamdmachine.reg<vgpr, 1, 0>,
    %y: !waveamdmachine.reg<vgpr, 1, 1>,
    %off: !waveamdmachine.reg<vgpr, 1, 2>,
    %desc: !waveamdmachine.reg<sgpr, 4, 0>,
    %dep: !waveamdmachine.mem.token) {
  %soffset = waveamdmachine.v_cmp_eq_u32 %x, %y
      : (!waveamdmachine.reg<vgpr, 1, 0>, !waveamdmachine.reg<vgpr, 1, 1>)
      -> !waveamdmachine.reg<sgpr, 1, 20>
  %loaded, %tok = waveamdmachine.buffer_load_b32 %off, %desc, %soffset after %dep
      : (!waveamdmachine.reg<vgpr, 1, 2>, !waveamdmachine.reg<sgpr, 4, 0>,
         !waveamdmachine.reg<sgpr, 1, 20>, !waveamdmachine.mem.token)
      -> (!waveamdmachine.reg<vgpr, 1, 30>, !waveamdmachine.mem.token)
  return
}

// CHECK-LABEL: func.func @vcc_compare_copied_sgpr_to_vmem_no_delay
// CHECK: waveamdmachine.v_cmp_eq_u32_vcc
// CHECK-NEXT: waveamdmachine.buffer_load_b32
func.func @vcc_compare_copied_sgpr_to_vmem_no_delay(
    %x: !waveamdmachine.reg<vgpr, 1, 0>,
    %y: !waveamdmachine.reg<vgpr, 1, 1>,
    %off: !waveamdmachine.reg<vgpr, 1, 2>,
    %desc: !waveamdmachine.reg<sgpr, 4, 0>,
    %dep: !waveamdmachine.mem.token) {
  %mask, %vcc = waveamdmachine.v_cmp_eq_u32_vcc %x, %y
      : (!waveamdmachine.reg<vgpr, 1, 0>, !waveamdmachine.reg<vgpr, 1, 1>)
      -> (!waveamdmachine.reg<sgpr, 1, 20>, !waveamdmachine.reg<vcc, 1>)
  %loaded, %tok = waveamdmachine.buffer_load_b32 %off, %desc, %mask after %dep
      : (!waveamdmachine.reg<vgpr, 1, 2>, !waveamdmachine.reg<sgpr, 4, 0>,
         !waveamdmachine.reg<sgpr, 1, 20>, !waveamdmachine.mem.token)
      -> (!waveamdmachine.reg<vgpr, 1, 30>, !waveamdmachine.mem.token)
  return
}

// CHECK-LABEL: func.func @valu_sgpr_to_valu_delay
// CHECK: waveamdmachine.v_cmp_eq_u32
// CHECK-NEXT: waveamdmachine.imm 1
// CHECK-NEXT: waveamdmachine.s_nop
// CHECK-NEXT: waveamdmachine.v_add_u32
func.func @valu_sgpr_to_valu_delay(
    %x: !waveamdmachine.reg<vgpr, 1, 0>,
    %y: !waveamdmachine.reg<vgpr, 1, 1>,
    %v: !waveamdmachine.reg<vgpr, 1, 2>) {
  %s = waveamdmachine.v_cmp_eq_u32 %x, %y
      : (!waveamdmachine.reg<vgpr, 1, 0>, !waveamdmachine.reg<vgpr, 1, 1>)
      -> !waveamdmachine.reg<sgpr, 1, 20>
  %sum = waveamdmachine.v_add_u32 %v, %s
      : (!waveamdmachine.reg<vgpr, 1, 2>, !waveamdmachine.reg<sgpr, 1, 20>)
      -> !waveamdmachine.reg<vgpr, 1, 30>
  return
}

// CHECK-LABEL: func.func @vcc_compare_copied_sgpr_to_valu_no_delay
// CHECK: waveamdmachine.v_cmp_eq_u32_vcc
// CHECK-NEXT: waveamdmachine.v_add_u32
func.func @vcc_compare_copied_sgpr_to_valu_no_delay(
    %x: !waveamdmachine.reg<vgpr, 1, 0>,
    %y: !waveamdmachine.reg<vgpr, 1, 1>,
    %v: !waveamdmachine.reg<vgpr, 1, 2>) {
  %mask, %vcc = waveamdmachine.v_cmp_eq_u32_vcc %x, %y
      : (!waveamdmachine.reg<vgpr, 1, 0>, !waveamdmachine.reg<vgpr, 1, 1>)
      -> (!waveamdmachine.reg<sgpr, 1, 20>, !waveamdmachine.reg<vcc, 1>)
  %sum = waveamdmachine.v_add_u32 %v, %mask
      : (!waveamdmachine.reg<vgpr, 1, 2>, !waveamdmachine.reg<sgpr, 1, 20>)
      -> !waveamdmachine.reg<vgpr, 1, 30>
  return
}

// CHECK-LABEL: func.func @valu_vgpr_to_readfirstlane_delay
// CHECK: waveamdmachine.v_add_u32
// CHECK-NEXT: waveamdmachine.imm 0
// CHECK-NEXT: waveamdmachine.s_nop
// CHECK-NEXT: waveamdmachine.v_readfirstlane_b32
func.func @valu_vgpr_to_readfirstlane_delay(
    %x: !waveamdmachine.reg<vgpr, 1, 0>,
    %s: !waveamdmachine.reg<sgpr, 1, 0>) {
  %sum = waveamdmachine.v_add_u32 %x, %s
      : (!waveamdmachine.reg<vgpr, 1, 0>, !waveamdmachine.reg<sgpr, 1, 0>)
      -> !waveamdmachine.reg<vgpr, 1, 8>
  %first = waveamdmachine.v_readfirstlane_b32 %sum
      : (!waveamdmachine.reg<vgpr, 1, 8>) -> !waveamdmachine.reg<sgpr, 1, 20>
  return
}

// CHECK-LABEL: func.func @cmpx_exec_to_mfma_delay
// CHECK: waveamdmachine.v_cmpx_eq_u32
// CHECK-NEXT: waveamdmachine.imm 3
// CHECK-NEXT: waveamdmachine.s_nop
// CHECK-NEXT: waveamdmachine.mfma_f32_16x16x32_f16
func.func @cmpx_exec_to_mfma_delay(
    %x: !waveamdmachine.reg<vgpr, 1, 0>,
    %y: !waveamdmachine.reg<vgpr, 1, 1>,
    %a: !waveamdmachine.reg<vgpr, 4, 8>,
    %b: !waveamdmachine.reg<vgpr, 4, 12>,
    %acc: !waveamdmachine.reg<vgpr, 4, 16>) {
  waveamdmachine.v_cmpx_eq_u32 %x, %y
      : (!waveamdmachine.reg<vgpr, 1, 0>, !waveamdmachine.reg<vgpr, 1, 1>) -> ()
  %r = waveamdmachine.mfma_f32_16x16x32_f16 %a, %b, %acc
      : (!waveamdmachine.reg<vgpr, 4, 8>, !waveamdmachine.reg<vgpr, 4, 12>,
         !waveamdmachine.reg<vgpr, 4, 16>) -> !waveamdmachine.reg<vgpr, 4, 20>
  return
}

// CHECK-LABEL: func.func @non_exec_compare_does_not_delay_mfma
// CHECK: waveamdmachine.v_cmp_eq_u32_vcc
// CHECK-NEXT: waveamdmachine.mfma_f32_16x16x32_f16
func.func @non_exec_compare_does_not_delay_mfma(
    %x: !waveamdmachine.reg<vgpr, 1, 0>,
    %y: !waveamdmachine.reg<vgpr, 1, 1>,
    %a: !waveamdmachine.reg<vgpr, 4, 8>,
    %b: !waveamdmachine.reg<vgpr, 4, 12>,
    %acc: !waveamdmachine.reg<vgpr, 4, 16>) {
  %mask, %vcc = waveamdmachine.v_cmp_eq_u32_vcc %x, %y
      : (!waveamdmachine.reg<vgpr, 1, 0>, !waveamdmachine.reg<vgpr, 1, 1>)
      -> (!waveamdmachine.reg<sgpr, 1>, !waveamdmachine.reg<vcc, 1>)
  %r = waveamdmachine.mfma_f32_16x16x32_f16 %a, %b, %acc
      : (!waveamdmachine.reg<vgpr, 4, 8>, !waveamdmachine.reg<vgpr, 4, 12>,
         !waveamdmachine.reg<vgpr, 4, 16>) -> !waveamdmachine.reg<vgpr, 4, 20>
  return
}

// One real instruction between `s_mov_m0` and the DMA saturates the
// 1-slot m0 pipeline gap; no `s_nop` needed.
// CHECK-LABEL: func.func @m0_no_delay_when_gap_saturated
// CHECK: waveamdmachine.s_mov_m0
// CHECK-NEXT: waveamdmachine.s_add_i32
// CHECK-NEXT: waveamdmachine.global_load_lds_b128
// CHECK-NOT: waveamdmachine.s_nop
func.func @m0_no_delay_when_gap_saturated(
    %off: !waveamdmachine.reg<vgpr, 1>,
    %base: !waveamdmachine.reg<sgpr, 2>,
    %dst: !waveamdmachine.reg<sgpr, 1>,
    %x: !waveamdmachine.reg<sgpr, 1>,
    %dep: !waveamdmachine.mem.token) {
  %m0 = waveamdmachine.s_mov_m0 %dst
      : (!waveamdmachine.reg<sgpr, 1>) -> !waveamdmachine.m0
  %sum, %scc = waveamdmachine.s_add_i32 %x, %x
      : (!waveamdmachine.reg<sgpr, 1>, !waveamdmachine.reg<sgpr, 1>)
      -> (!waveamdmachine.reg<sgpr, 1>, !waveamdmachine.reg<scc, 1>)
  %tok = waveamdmachine.global_load_lds_b128 %off, %base, %m0 after %dep
      : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<sgpr, 2>,
         !waveamdmachine.m0, !waveamdmachine.mem.token)
      -> !waveamdmachine.mem.token
  return
}

// Pseudo-ops (`imm` etc., trait `NoMachineInst`) between the
// producer and consumer do NOT count toward the gap; the mitigation
// still fires.
// CHECK-LABEL: func.func @m0_delay_with_imm_between
// CHECK: waveamdmachine.s_mov_m0
// CHECK: waveamdmachine.imm
// CHECK-NEXT: waveamdmachine.imm 0
// CHECK-NEXT: waveamdmachine.s_nop
// CHECK-NEXT: waveamdmachine.global_load_lds_b128
func.func @m0_delay_with_imm_between(
    %off: !waveamdmachine.reg<vgpr, 1>,
    %base: !waveamdmachine.reg<sgpr, 2>,
    %dst: !waveamdmachine.reg<sgpr, 1>,
    %dep: !waveamdmachine.mem.token) {
  %m0 = waveamdmachine.s_mov_m0 %dst
      : (!waveamdmachine.reg<sgpr, 1>) -> !waveamdmachine.m0
  %unused = waveamdmachine.imm 42 : !waveamdmachine.imm
  %tok = waveamdmachine.global_load_lds_b128 %off, %base, %m0 after %dep
      : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<sgpr, 2>,
         !waveamdmachine.m0, !waveamdmachine.mem.token)
      -> !waveamdmachine.mem.token
  return
}

// Two consecutive `s_mov_m0`s. The DMA reads the second's result;
// the first counts as a machine instruction between the second
// producer and the consumer, but that machine instruction (the
// first `s_mov_m0`) is the only thing between the *second*
// producer's def and the consumer, contributing exactly 0 to that
// gap. Mitigation still fires.
// CHECK-LABEL: func.func @m0_delay_after_chained_mov
// CHECK: waveamdmachine.s_mov_m0
// CHECK: waveamdmachine.s_mov_m0
// CHECK-NEXT: waveamdmachine.imm 0
// CHECK-NEXT: waveamdmachine.s_nop
// CHECK-NEXT: waveamdmachine.global_load_lds_b128
func.func @m0_delay_after_chained_mov(
    %off: !waveamdmachine.reg<vgpr, 1>,
    %base: !waveamdmachine.reg<sgpr, 2>,
    %dst1: !waveamdmachine.reg<sgpr, 1>,
    %dst2: !waveamdmachine.reg<sgpr, 1>,
    %dep: !waveamdmachine.mem.token) {
  %m0_a = waveamdmachine.s_mov_m0 %dst1
      : (!waveamdmachine.reg<sgpr, 1>) -> !waveamdmachine.m0
  %m0_b = waveamdmachine.s_mov_m0 %dst2
      : (!waveamdmachine.reg<sgpr, 1>) -> !waveamdmachine.m0
  %tok = waveamdmachine.global_load_lds_b128 %off, %base, %m0_b after %dep
      : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<sgpr, 2>,
         !waveamdmachine.m0, !waveamdmachine.mem.token)
      -> !waveamdmachine.mem.token
  return
}

// MFMA producer in one branch of a `cf.cond_br`, VMEM store in the
// join. Dataflow remaps the MFMA hazard to the join block argument.
// The `cf.br` terminator counts as one instruction, leaving 7 wait
// states: one `s_nop` with immediate 6.
// CHECK-LABEL: func.func @mfma_store_delay_across_cond_br
// CHECK: cf.cond_br
// CHECK: waveamdmachine.mfma_f32_16x16x32_f16
// CHECK-NEXT: cf.br
// CHECK: waveamdmachine.mfma_f32_16x16x32_f16
// CHECK-NEXT: cf.br
// CHECK: ^bb{{[0-9]+}}(%{{[0-9]+}}: !waveamdmachine.reg<vgpr, 4>)
// CHECK-NEXT: waveamdmachine.imm 6
// CHECK-NEXT: waveamdmachine.s_nop
// CHECK-NEXT: waveamdmachine.global_store_b128
func.func @mfma_store_delay_across_cond_br(
    %cond: i1,
    %a: !waveamdmachine.reg<vgpr, 4>,
    %b: !waveamdmachine.reg<vgpr, 4>,
    %acc: !waveamdmachine.reg<vgpr, 4>,
    %off: !waveamdmachine.reg<vgpr, 1>,
    %base: !waveamdmachine.reg<sgpr, 2>) {
  cf.cond_br %cond, ^then, ^else
^then:
  %r_a = waveamdmachine.mfma_f32_16x16x32_f16 %a, %b, %acc
      : (!waveamdmachine.reg<vgpr, 4>, !waveamdmachine.reg<vgpr, 4>,
         !waveamdmachine.reg<vgpr, 4>) -> !waveamdmachine.reg<vgpr, 4>
  cf.br ^join(%r_a : !waveamdmachine.reg<vgpr, 4>)
^else:
  %r_b = waveamdmachine.mfma_f32_16x16x32_f16 %a, %b, %acc
      : (!waveamdmachine.reg<vgpr, 4>, !waveamdmachine.reg<vgpr, 4>,
         !waveamdmachine.reg<vgpr, 4>) -> !waveamdmachine.reg<vgpr, 4>
  cf.br ^join(%r_b : !waveamdmachine.reg<vgpr, 4>)
^join(%r: !waveamdmachine.reg<vgpr, 4>):
  %tok = waveamdmachine.global_store_b128 %off, %r, %base
      : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 4>,
         !waveamdmachine.reg<sgpr, 2>) -> !waveamdmachine.mem.token
  return
}

}

// -----

// MFMA result carried across a `uniform_loop` back-edge and read by
// a VMEM store inside the body on the next iteration. The SSA-edge
// walk follows the block argument back through
// `RegionBranchOpInterface`: entry source (loop init) doesn't carry
// the producer, but the `continue_if` back-edge does, resolving to
// the MFMA in the previous iteration. Gap = 0 (mfma->continue_if) +
// 1 (continue_if) + 0 (entry-to-store) = 1; mitigation = 7 NOPs.
module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx950"} {

// CHECK-LABEL: func.func @mfma_carry_consumed_in_body
// CHECK: waveamdmachine.uniform_loop
// CHECK: ^bb0(%[[ACC:.+]]: !waveamdmachine.reg<vgpr, 4>):
// CHECK-NEXT: waveamdmachine.imm 6
// CHECK-NEXT: waveamdmachine.s_nop
// CHECK-NEXT: waveamdmachine.global_store_b128 %{{.+}}, %[[ACC]],
// CHECK: waveamdmachine.mfma_f32_16x16x32_f16
// CHECK: waveamdmachine.continue_if
func.func @mfma_carry_consumed_in_body(
    %ec: !waveamdmachine.reg<scc, 1>,
    %a: !waveamdmachine.reg<vgpr, 4>,
    %b: !waveamdmachine.reg<vgpr, 4>,
    %acc_init: !waveamdmachine.reg<vgpr, 4>,
    %off: !waveamdmachine.reg<vgpr, 1>,
    %base: !waveamdmachine.reg<sgpr, 2>) {
  %unused = waveamdmachine.uniform_loop if %ec : !waveamdmachine.reg<scc, 1>
      carries(%acc_init : !waveamdmachine.reg<vgpr, 4>) {
  ^bb0(%acc: !waveamdmachine.reg<vgpr, 4>):
    %tok = waveamdmachine.global_store_b128 %off, %acc, %base
        : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 4>,
           !waveamdmachine.reg<sgpr, 2>) -> !waveamdmachine.mem.token
    %new = waveamdmachine.mfma_f32_16x16x32_f16 %a, %b, %acc
        : (!waveamdmachine.reg<vgpr, 4>, !waveamdmachine.reg<vgpr, 4>,
           !waveamdmachine.reg<vgpr, 4>) -> !waveamdmachine.reg<vgpr, 4>
    waveamdmachine.continue_if %ec : !waveamdmachine.reg<scc, 1>
        carries(%new : !waveamdmachine.reg<vgpr, 4>)
  } -> !waveamdmachine.reg<vgpr, 4>
  return
}

// Pass-through carry: the value is set up by an MFMA OUTSIDE the
// loop and `continue_if` forwards the block argument unchanged on
// every iteration. The visited set in the SSA-edge walk has to bail
// on the back-edge (else: infinite recursion); the entry path
// resolves through the parent-op carry to the external MFMA, and
// mitigation lands inside the body for the first-iteration hazard.
// CHECK-LABEL: func.func @mfma_carry_passthrough_with_external_producer
// CHECK: waveamdmachine.mfma_f32_16x16x32_f16
// CHECK: waveamdmachine.uniform_loop
// CHECK: ^bb0(%[[ACC:.+]]: !waveamdmachine.reg<vgpr, 4>):
// CHECK-NEXT: waveamdmachine.imm 6
// CHECK-NEXT: waveamdmachine.s_nop
// CHECK-NEXT: waveamdmachine.global_store_b128 %{{.+}}, %[[ACC]],
// CHECK: waveamdmachine.continue_if %{{.+}} : !waveamdmachine.reg<scc, 1> carries(%[[ACC]]
func.func @mfma_carry_passthrough_with_external_producer(
    %ec: !waveamdmachine.reg<scc, 1>,
    %a: !waveamdmachine.reg<vgpr, 4>,
    %b: !waveamdmachine.reg<vgpr, 4>,
    %acc0: !waveamdmachine.reg<vgpr, 4>,
    %off: !waveamdmachine.reg<vgpr, 1>,
    %base: !waveamdmachine.reg<sgpr, 2>) {
  %init = waveamdmachine.mfma_f32_16x16x32_f16 %a, %b, %acc0
      : (!waveamdmachine.reg<vgpr, 4>, !waveamdmachine.reg<vgpr, 4>,
         !waveamdmachine.reg<vgpr, 4>) -> !waveamdmachine.reg<vgpr, 4>
  %unused2 = waveamdmachine.uniform_loop if %ec : !waveamdmachine.reg<scc, 1>
      carries(%init : !waveamdmachine.reg<vgpr, 4>) {
  ^bb0(%acc: !waveamdmachine.reg<vgpr, 4>):
    %tok = waveamdmachine.global_store_b128 %off, %acc, %base
        : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 4>,
           !waveamdmachine.reg<sgpr, 2>) -> !waveamdmachine.mem.token
    waveamdmachine.continue_if %ec : !waveamdmachine.reg<scc, 1>
        carries(%acc : !waveamdmachine.reg<vgpr, 4>)
  } -> !waveamdmachine.reg<vgpr, 4>
  return
}

// Pass-through carry with NO producer anywhere upstream. The visited
// set still has to bail on the back-edge; the entry path finds no
// matching MFMA. Both paths return null, no mitigation emitted.
// CHECK-LABEL: func.func @passthrough_no_producer
// CHECK: waveamdmachine.uniform_loop
// CHECK: ^bb0(
// CHECK-NEXT: waveamdmachine.global_store_b128
// CHECK-NOT: waveamdmachine.s_nop
// CHECK: waveamdmachine.continue_if
func.func @passthrough_no_producer(
    %ec: !waveamdmachine.reg<scc, 1>,
    %acc0: !waveamdmachine.reg<vgpr, 4>,
    %off: !waveamdmachine.reg<vgpr, 1>,
    %base: !waveamdmachine.reg<sgpr, 2>) {
  %unused3 = waveamdmachine.uniform_loop if %ec : !waveamdmachine.reg<scc, 1>
      carries(%acc0 : !waveamdmachine.reg<vgpr, 4>) {
  ^bb0(%acc: !waveamdmachine.reg<vgpr, 4>):
    %tok = waveamdmachine.global_store_b128 %off, %acc, %base
        : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 4>,
           !waveamdmachine.reg<sgpr, 2>) -> !waveamdmachine.mem.token
    waveamdmachine.continue_if %ec : !waveamdmachine.reg<scc, 1>
        carries(%acc : !waveamdmachine.reg<vgpr, 4>)
  } -> !waveamdmachine.reg<vgpr, 4>
  return
}

// MFMA result returned through the loop's exit-to-parent edge and
// consumed by a VMEM store after the loop. The SSA-edge walk
// follows the op result back through the `continue_if` exit
// successor, resolving to the MFMA inside the body.
// CHECK-LABEL: func.func @mfma_carry_consumed_after_loop
// CHECK: %[[RES:.+]] = waveamdmachine.uniform_loop
// CHECK: waveamdmachine.imm 6
// CHECK-NEXT: waveamdmachine.s_nop
// CHECK-NEXT: waveamdmachine.global_store_b128 %{{.+}}, %[[RES]],
func.func @mfma_carry_consumed_after_loop(
    %ec: !waveamdmachine.reg<scc, 1>,
    %a: !waveamdmachine.reg<vgpr, 4>,
    %b: !waveamdmachine.reg<vgpr, 4>,
    %acc_init: !waveamdmachine.reg<vgpr, 4>,
    %off: !waveamdmachine.reg<vgpr, 1>,
    %base: !waveamdmachine.reg<sgpr, 2>) {
  %result = waveamdmachine.uniform_loop if %ec : !waveamdmachine.reg<scc, 1>
      carries(%acc_init : !waveamdmachine.reg<vgpr, 4>) {
  ^bb0(%acc: !waveamdmachine.reg<vgpr, 4>):
    %new = waveamdmachine.mfma_f32_16x16x32_f16 %a, %b, %acc
        : (!waveamdmachine.reg<vgpr, 4>, !waveamdmachine.reg<vgpr, 4>,
           !waveamdmachine.reg<vgpr, 4>) -> !waveamdmachine.reg<vgpr, 4>
    waveamdmachine.continue_if %ec : !waveamdmachine.reg<scc, 1>
        carries(%new : !waveamdmachine.reg<vgpr, 4>)
  } -> !waveamdmachine.reg<vgpr, 4>
  %tok = waveamdmachine.global_store_b128 %off, %result, %base
      : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 4>,
         !waveamdmachine.reg<sgpr, 2>) -> !waveamdmachine.mem.token
  return
}

}

// -----

// SSA-edge M0 mitigation inside uniform_loop must stay idempotent
// while linear LGKM state persists across the back-edge.
module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx950"} {

// CHECK-LABEL: func.func @m0_delay_inside_uniform_loop_no_dup
// CHECK: waveamdmachine.uniform_loop
// CHECK:   waveamdmachine.s_mov_m0
// CHECK-NEXT: waveamdmachine.imm 0
// CHECK-NEXT: waveamdmachine.s_nop
// CHECK-NEXT: waveamdmachine.global_load_lds_b128
// CHECK-NOT: waveamdmachine.s_nop
// CHECK: waveamdmachine.s_waitcnt
// CHECK: waveamdmachine.continue_if
func.func @m0_delay_inside_uniform_loop_no_dup(
    %ec: !waveamdmachine.reg<scc, 1>,
    %off: !waveamdmachine.reg<vgpr, 1>,
    %base: !waveamdmachine.reg<sgpr, 2>,
    %dst: !waveamdmachine.reg<sgpr, 1>,
    %dep: !waveamdmachine.mem.token) {
  waveamdmachine.uniform_loop if %ec : !waveamdmachine.reg<scc, 1> {
    %m0 = waveamdmachine.s_mov_m0 %dst
        : (!waveamdmachine.reg<sgpr, 1>) -> !waveamdmachine.m0
    %tok = waveamdmachine.global_load_lds_b128 %off, %base, %m0 after %dep
        : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<sgpr, 2>,
           !waveamdmachine.m0, !waveamdmachine.mem.token)
        -> !waveamdmachine.mem.token
    %wait = waveamdmachine.imm 0 : !waveamdmachine.imm
    waveamdmachine.s_waitcnt %wait : (!waveamdmachine.imm) -> ()
    waveamdmachine.continue_if %ec : !waveamdmachine.reg<scc, 1>
  }
  return
}

}
