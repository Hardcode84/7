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

// CHECK-LABEL: func.func @no_delay_after_vmcnt_wait
// CHECK: waveamdmachine.s_waitcnt
// CHECK-NEXT: waveamdmachine.v_add_u32
func.func @no_delay_after_vmcnt_wait(%x: !waveamdmachine.reg<vgpr, 1>, %y: !waveamdmachine.reg<sgpr, 1>) {
  %wait = waveamdmachine.imm 1023 : !waveamdmachine.imm
  waveamdmachine.s_waitcnt %wait : (!waveamdmachine.imm) -> ()
  %sum = waveamdmachine.v_add_u32 %x, %y : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<sgpr, 1>) -> !waveamdmachine.reg<vgpr, 1>
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

// CHECK-LABEL: func.func @mfma_result_store_delay
// CHECK: waveamdmachine.mfma_f32_16x16x32_f16
// CHECK-NEXT: waveamdmachine.imm 7
// CHECK-NEXT: waveamdmachine.s_nop
// CHECK-NEXT: waveamdmachine.global_store_b128
func.func @mfma_result_store_delay(
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

}
