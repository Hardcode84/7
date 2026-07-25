// RUN: wave-opt %s --split-input-file --waveamd-machine-schedule-report='print-candidates=1' 2>&1 | FileCheck %s --check-prefix=DIAG

module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx1100"} {
func.func @matmul_loop_candidate(%off: !waveamdmachine.reg<vgpr, 1>,
                                 %base: !waveamdmachine.reg<sgpr, 2>,
                                 %va: !waveamdmachine.reg<vgpr, 1>,
                                 %vb: !waveamdmachine.reg<vgpr, 1>,
                                 %a_frag: !waveamdmachine.reg<vgpr, 8>,
                                 %b_frag: !waveamdmachine.reg<vgpr, 8>,
                                 %acc: !waveamdmachine.reg<vgpr, 8>,
                                 %iv0: !waveamdmachine.reg<sgpr, 1>) {
  %one = waveamdmachine.imm 1 : !waveamdmachine.imm
  %r:2 = waveamdmachine.uniform_loop carries(%iv0, %acc :
      !waveamdmachine.reg<sgpr, 1>, !waveamdmachine.reg<vgpr, 8>) {
  ^bb0(%iv: !waveamdmachine.reg<sgpr, 1>,
       %acc_iter: !waveamdmachine.reg<vgpr, 8>):
    %tok0 = waveamdmachine.token : !waveamdmachine.mem.token
    %ind = waveamdmachine.v_add_u32 %va, %vb : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>) -> !waveamdmachine.reg<vgpr, 1>
    %loaded, %tok1 = waveamdmachine.global_load_b32 %off, %base after %tok0
        : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<sgpr, 2>, !waveamdmachine.mem.token)
          -> (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.mem.token)
    %wmma = waveamdmachine.wmma_f32_16x16x16_f16 %a_frag, %b_frag, %acc_iter
        : (!waveamdmachine.reg<vgpr, 8>, !waveamdmachine.reg<vgpr, 8>,
           !waveamdmachine.reg<vgpr, 8>) -> !waveamdmachine.reg<vgpr, 8>
    %dep = waveamdmachine.v_add_u32 %loaded, %ind : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>) -> !waveamdmachine.reg<vgpr, 1>
    %next:2 = waveamdmachine.s_add_i32 %iv, %one : (!waveamdmachine.reg<sgpr, 1>, !waveamdmachine.imm) -> (!waveamdmachine.reg<sgpr, 1>, !waveamdmachine.reg<scc, 1>)
    %scc = waveamdmachine.s_cmp_lt_i32 %next#0, %one : (!waveamdmachine.reg<sgpr, 1>, !waveamdmachine.imm) -> !waveamdmachine.reg<scc, 1>
    waveamdmachine.continue_if %scc : !waveamdmachine.reg<scc, 1>
        carries(%next#0, %wmma : !waveamdmachine.reg<sgpr, 1>,
                !waveamdmachine.reg<vgpr, 8>)
  } -> !waveamdmachine.reg<sgpr, 1>, !waveamdmachine.reg<vgpr, 8>
  return
}
}

// DIAG: waveamd-machine-schedule-report candidate func=matmul_loop_candidate region=1 name=original cycles=326 delta=0 issued_ops=6 action=keep reason=original
// DIAG: waveamd-machine-schedule-report candidate func=matmul_loop_candidate region=1 name=greedy cycles=325 delta=-1 issued_ops=6 action=apply reason=vmem_prefetch filled_gaps=1
// DIAG-SAME: vmem_prefetch_moves=1
// DIAG: waveamd-machine-schedule-report selected func=matmul_loop_candidate region=1 name=greedy original_cycles=326 selected_cycles=325 delta=-1 action=apply reason=vmem_prefetch

// -----

module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx950"} {
func.func @issue_window_candidate(%a: !waveamdmachine.reg<vgpr, 4>,
                                  %b: !waveamdmachine.reg<vgpr, 4>,
                                  %acc0: !waveamdmachine.reg<vgpr, 4>,
                                  %acc1: !waveamdmachine.reg<vgpr, 4>,
                                  %s: !waveamdmachine.reg<sgpr, 1>) {
  %one = waveamdmachine.imm 1 : !waveamdmachine.imm
  %m0 = waveamdmachine.mfma_f32_16x16x32_f16 %a, %b, %acc0
      : (!waveamdmachine.reg<vgpr, 4>, !waveamdmachine.reg<vgpr, 4>,
         !waveamdmachine.reg<vgpr, 4>) -> !waveamdmachine.reg<vgpr, 4>
  %m1 = waveamdmachine.mfma_f32_16x16x32_f16 %a, %b, %acc1
      : (!waveamdmachine.reg<vgpr, 4>, !waveamdmachine.reg<vgpr, 4>,
         !waveamdmachine.reg<vgpr, 4>) -> !waveamdmachine.reg<vgpr, 4>
  %next:2 = waveamdmachine.s_add_i32 %s, %one
      : (!waveamdmachine.reg<sgpr, 1>, !waveamdmachine.imm)
        -> (!waveamdmachine.reg<sgpr, 1>, !waveamdmachine.reg<scc, 1>)
  return
}
}

// DIAG: waveamd-machine-schedule-report candidate func=issue_window_candidate region=0 name=greedy cycles=12 delta=0 issued_ops=3 action=apply reason=compute_resource
// DIAG-SAME: resource_stall_fills=1 pressure_priority_moves=0 order=0,1,3,2
// DIAG: waveamd-machine-schedule-report selected func=issue_window_candidate region=0 name=greedy original_cycles=12 selected_cycles=12 delta=0 action=apply reason=compute_resource

// -----

module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx950"} {
func.func @ds_read_burst_counter(%a: !waveamdmachine.reg<vgpr, 4>,
                                 %b: !waveamdmachine.reg<vgpr, 4>,
                                 %acc: !waveamdmachine.reg<vgpr, 4>,
                                 %addr: !waveamdmachine.reg<vgpr, 1>,
                                 %tok: !waveamdmachine.mem.token) {
  %ld0, %t0 = waveamdmachine.ds_load_b128 %addr after %tok
      : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.mem.token)
        -> (!waveamdmachine.reg<vgpr, 4>, !waveamdmachine.mem.token)
  %ld1, %t1 = waveamdmachine.ds_load_b128 %addr after %t0 offset 4096
      : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.mem.token)
        -> (!waveamdmachine.reg<vgpr, 4>, !waveamdmachine.mem.token)
  %r0 = waveamdmachine.mfma_f32_16x16x32_f16 %ld0, %b, %acc
      : (!waveamdmachine.reg<vgpr, 4>, !waveamdmachine.reg<vgpr, 4>,
         !waveamdmachine.reg<vgpr, 4>) -> !waveamdmachine.reg<vgpr, 4>
  %r1 = waveamdmachine.mfma_f32_16x16x32_f16 %ld1, %a, %r0
      : (!waveamdmachine.reg<vgpr, 4>, !waveamdmachine.reg<vgpr, 4>,
         !waveamdmachine.reg<vgpr, 4>) -> !waveamdmachine.reg<vgpr, 4>
  return
}
}

// DIAG: waveamd-machine-schedule-report candidate func=ds_read_burst_counter region=0 name=original cycles=28 delta=0 issued_ops=4 action=keep reason=original

// -----

module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx950"} {
func.func @cma_dma_place_candidate(%a: !waveamdmachine.reg<vgpr, 4>,
                                   %b: !waveamdmachine.reg<vgpr, 4>,
                                   %acc0: !waveamdmachine.reg<vgpr, 4>,
                                   %acc1: !waveamdmachine.reg<vgpr, 4>,
                                   %v: !waveamdmachine.reg<vgpr, 1>,
                                   %rsrc: !waveamdmachine.reg<sgpr, 4>,
                                   %m0: !waveamdmachine.m0,
                                   %tok: !waveamdmachine.mem.token) {
  %zero = waveamdmachine.imm 0 : !waveamdmachine.imm
  %r0 = waveamdmachine.mfma_f32_16x16x32_f16 %a, %b, %acc0
      : (!waveamdmachine.reg<vgpr, 4>, !waveamdmachine.reg<vgpr, 4>,
         !waveamdmachine.reg<vgpr, 4>) -> !waveamdmachine.reg<vgpr, 4>
  %r1 = waveamdmachine.mfma_f32_16x16x32_f16 %a, %b, %acc1
      : (!waveamdmachine.reg<vgpr, 4>, !waveamdmachine.reg<vgpr, 4>,
         !waveamdmachine.reg<vgpr, 4>) -> !waveamdmachine.reg<vgpr, 4>
  %ld0 = waveamdmachine.buffer_load_lds_b128 %v, %rsrc, %zero, %m0 after %tok
      : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<sgpr, 4>,
         !waveamdmachine.imm, !waveamdmachine.m0, !waveamdmachine.mem.token)
        -> !waveamdmachine.mem.token
  return
}
}

// DIAG: waveamd-machine-schedule-report candidate func=cma_dma_place_candidate region=0 name=greedy cycles=80 delta=-8 issued_ops=3 action=apply reason=better
// DIAG: waveamd-machine-schedule-report selected func=cma_dma_place_candidate region=0 name=greedy original_cycles=88 selected_cycles=80 delta=-8 action=apply reason=better

// -----

module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx950"} {
func.func @late_dma_overlap_candidate(%a: !waveamdmachine.reg<vgpr, 4>,
                                      %b: !waveamdmachine.reg<vgpr, 4>,
                                      %acc: !waveamdmachine.reg<vgpr, 4>,
                                      %s: !waveamdmachine.reg<sgpr, 1>,
                                      %v: !waveamdmachine.reg<vgpr, 1>,
                                      %rsrc: !waveamdmachine.reg<sgpr, 4>,
                                      %tok: !waveamdmachine.mem.token) {
  %zero = waveamdmachine.imm 0 : !waveamdmachine.imm
  %r0 = waveamdmachine.mfma_f32_16x16x32_f16 %a, %b, %acc
      : (!waveamdmachine.reg<vgpr, 4>, !waveamdmachine.reg<vgpr, 4>,
         !waveamdmachine.reg<vgpr, 4>) -> !waveamdmachine.reg<vgpr, 4>
  %r1 = waveamdmachine.mfma_f32_16x16x32_f16 %a, %b, %acc
      : (!waveamdmachine.reg<vgpr, 4>, !waveamdmachine.reg<vgpr, 4>,
         !waveamdmachine.reg<vgpr, 4>) -> !waveamdmachine.reg<vgpr, 4>
  %r2 = waveamdmachine.mfma_f32_16x16x32_f16 %a, %b, %acc
      : (!waveamdmachine.reg<vgpr, 4>, !waveamdmachine.reg<vgpr, 4>,
         !waveamdmachine.reg<vgpr, 4>) -> !waveamdmachine.reg<vgpr, 4>
  %r3 = waveamdmachine.mfma_f32_16x16x32_f16 %a, %b, %acc
      : (!waveamdmachine.reg<vgpr, 4>, !waveamdmachine.reg<vgpr, 4>,
         !waveamdmachine.reg<vgpr, 4>) -> !waveamdmachine.reg<vgpr, 4>
  %r4 = waveamdmachine.mfma_f32_16x16x32_f16 %a, %b, %acc
      : (!waveamdmachine.reg<vgpr, 4>, !waveamdmachine.reg<vgpr, 4>,
         !waveamdmachine.reg<vgpr, 4>) -> !waveamdmachine.reg<vgpr, 4>
  %r5 = waveamdmachine.mfma_f32_16x16x32_f16 %a, %b, %acc
      : (!waveamdmachine.reg<vgpr, 4>, !waveamdmachine.reg<vgpr, 4>,
         !waveamdmachine.reg<vgpr, 4>) -> !waveamdmachine.reg<vgpr, 4>
  %r6 = waveamdmachine.mfma_f32_16x16x32_f16 %a, %b, %acc
      : (!waveamdmachine.reg<vgpr, 4>, !waveamdmachine.reg<vgpr, 4>,
         !waveamdmachine.reg<vgpr, 4>) -> !waveamdmachine.reg<vgpr, 4>
  %r7 = waveamdmachine.mfma_f32_16x16x32_f16 %a, %b, %acc
      : (!waveamdmachine.reg<vgpr, 4>, !waveamdmachine.reg<vgpr, 4>,
         !waveamdmachine.reg<vgpr, 4>) -> !waveamdmachine.reg<vgpr, 4>
  %r8 = waveamdmachine.mfma_f32_16x16x32_f16 %a, %b, %acc
      : (!waveamdmachine.reg<vgpr, 4>, !waveamdmachine.reg<vgpr, 4>,
         !waveamdmachine.reg<vgpr, 4>) -> !waveamdmachine.reg<vgpr, 4>
  %r9 = waveamdmachine.mfma_f32_16x16x32_f16 %a, %b, %acc
      : (!waveamdmachine.reg<vgpr, 4>, !waveamdmachine.reg<vgpr, 4>,
         !waveamdmachine.reg<vgpr, 4>) -> !waveamdmachine.reg<vgpr, 4>
  %r10 = waveamdmachine.mfma_f32_16x16x32_f16 %a, %b, %acc
      : (!waveamdmachine.reg<vgpr, 4>, !waveamdmachine.reg<vgpr, 4>,
         !waveamdmachine.reg<vgpr, 4>) -> !waveamdmachine.reg<vgpr, 4>
  %r11 = waveamdmachine.mfma_f32_16x16x32_f16 %a, %b, %acc
      : (!waveamdmachine.reg<vgpr, 4>, !waveamdmachine.reg<vgpr, 4>,
         !waveamdmachine.reg<vgpr, 4>) -> !waveamdmachine.reg<vgpr, 4>
  %r12 = waveamdmachine.mfma_f32_16x16x32_f16 %a, %b, %acc
      : (!waveamdmachine.reg<vgpr, 4>, !waveamdmachine.reg<vgpr, 4>,
         !waveamdmachine.reg<vgpr, 4>) -> !waveamdmachine.reg<vgpr, 4>
  %r13 = waveamdmachine.mfma_f32_16x16x32_f16 %a, %b, %acc
      : (!waveamdmachine.reg<vgpr, 4>, !waveamdmachine.reg<vgpr, 4>,
         !waveamdmachine.reg<vgpr, 4>) -> !waveamdmachine.reg<vgpr, 4>
  %r14 = waveamdmachine.mfma_f32_16x16x32_f16 %a, %b, %acc
      : (!waveamdmachine.reg<vgpr, 4>, !waveamdmachine.reg<vgpr, 4>,
         !waveamdmachine.reg<vgpr, 4>) -> !waveamdmachine.reg<vgpr, 4>
  %r15 = waveamdmachine.mfma_f32_16x16x32_f16 %a, %b, %acc
      : (!waveamdmachine.reg<vgpr, 4>, !waveamdmachine.reg<vgpr, 4>,
         !waveamdmachine.reg<vgpr, 4>) -> !waveamdmachine.reg<vgpr, 4>
  %s0, %scc0 = waveamdmachine.s_and_b32 %s, %zero
      : (!waveamdmachine.reg<sgpr, 1>, !waveamdmachine.imm)
        -> (!waveamdmachine.reg<sgpr, 1>, !waveamdmachine.reg<scc, 1>)
  %s1, %scc1 = waveamdmachine.s_lshl_b32 %s0, %zero
      : (!waveamdmachine.reg<sgpr, 1>, !waveamdmachine.imm)
        -> (!waveamdmachine.reg<sgpr, 1>, !waveamdmachine.reg<scc, 1>)
  %m0 = waveamdmachine.s_mov_m0 %s1 : (!waveamdmachine.reg<sgpr, 1>)
        -> !waveamdmachine.m0
  %v0 = waveamdmachine.v_add_u32 %s1, %v
      : (!waveamdmachine.reg<sgpr, 1>, !waveamdmachine.reg<vgpr, 1>)
        -> !waveamdmachine.reg<vgpr, 1>
  %v1 = waveamdmachine.v_add3_u32 %v0, %v, %v
      : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>,
         !waveamdmachine.reg<vgpr, 1>) -> !waveamdmachine.reg<vgpr, 1>
  %ld0 = waveamdmachine.buffer_load_lds_b128 %v1, %rsrc, %zero, %m0 after %tok
      : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<sgpr, 4>,
         !waveamdmachine.imm, !waveamdmachine.m0, !waveamdmachine.mem.token)
        -> !waveamdmachine.mem.token
  %s2, %scc2 = waveamdmachine.s_add_i32 %s1, %zero
      : (!waveamdmachine.reg<sgpr, 1>, !waveamdmachine.imm)
        -> (!waveamdmachine.reg<sgpr, 1>, !waveamdmachine.reg<scc, 1>)
  %m1 = waveamdmachine.s_mov_m0 %s2 : (!waveamdmachine.reg<sgpr, 1>)
        -> !waveamdmachine.m0
  %v2 = waveamdmachine.v_add_u32 %s2, %v
      : (!waveamdmachine.reg<sgpr, 1>, !waveamdmachine.reg<vgpr, 1>)
        -> !waveamdmachine.reg<vgpr, 1>
  %v3 = waveamdmachine.v_add3_u32 %v2, %v, %v
      : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>,
         !waveamdmachine.reg<vgpr, 1>) -> !waveamdmachine.reg<vgpr, 1>
  %ld1 = waveamdmachine.buffer_load_lds_b128 %v3, %rsrc, %zero, %m1 after %tok
      : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<sgpr, 4>,
         !waveamdmachine.imm, !waveamdmachine.m0, !waveamdmachine.mem.token)
        -> !waveamdmachine.mem.token
  %joined = waveamdmachine.token_join %ld0, %ld1
      : (!waveamdmachine.mem.token, !waveamdmachine.mem.token)
        -> !waveamdmachine.mem.token
  return
}
}

// DIAG-NOT: name=cma_dma_place
// DIAG: waveamd-machine-schedule-report candidate func=late_dma_overlap_candidate region=0 name=greedy cycles=184 delta=0 issued_ops=27 action=apply reason=compute_resource
// DIAG-SAME: resource_stall_fills=2 pressure_priority_moves=0 order=0,1,17,18,2
// DIAG: waveamd-machine-schedule-report selected func=late_dma_overlap_candidate region=0 name=greedy original_cycles=184 selected_cycles=184 delta=0 action=apply reason=compute_resource
