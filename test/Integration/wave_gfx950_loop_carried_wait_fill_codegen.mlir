// RUN: wave-opt %s --waveamd-machine-schedule='apply-schedule=1' \
// RUN:   --waveamd-insert-ticket-waits --waveamd-insert-hazard-waits \
// RUN:   --waveamd-resource-info \
// RUN:   | env WAVE_PIPELINES_DIR=%S/../Target/Wave/Inputs/emit-only-pipeline \
// RUN:     wave-translate --wave-to-amdgpu-asm - \
// RUN:   | FileCheck %s --check-prefix=ASM
// RUN: wave-opt %s --waveamd-machine-schedule='apply-schedule=1' \
// RUN:   --waveamd-insert-ticket-waits --waveamd-insert-hazard-waits \
// RUN:   --waveamd-resource-info \
// RUN:   | env WAVE_PIPELINES_DIR=%S/../Target/Wave/Inputs/emit-only-pipeline \
// RUN:     wave-translate --wave-to-amdgpu-asm - \
// RUN:   | llvm-mc -triple=amdgcn-amd-amdhsa -mcpu=gfx950 \
// RUN:     -filetype=obj -o /dev/null
// RUN: wave-opt %s --waveamd-machine-schedule='apply-schedule=1' \
// RUN:   2>&1 >/dev/null | FileCheck %s --check-prefix=DIAG

module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx950"} {

// ASM-LABEL: loop_carried_wait_fill_codegen:
// ASM: .Lloop_carried_wait_fill_codegen.loop_head_0:
// ASM-NEXT: s_add_i32 s9, s9, s10
// ASM-NEXT: s_waitcnt vmcnt(0) lgkmcnt(0)
// ASM-NEXT: buffer_load_dwordx4 v0, s[4:7], 0 offen lds
// DIAG: waveamd-machine-schedule region func=loop_carried_wait_fill_codegen index=1
// DIAG-SAME: action=apply reason=loop_wait
// DIAG-SAME: steady_state_fills=1
// DIAG-SAME: steady_state_iterations=4
// DIAG-SAME: steady_state_refinements=2
func.func @loop_carried_wait_fill_codegen() attributes {wave.kernel} {
  %root = waveamdmachine.token : !waveamdmachine.mem.token
  %addr = waveamdmachine.uninit : !waveamdmachine.reg<vgpr, 1, 1>
  %data = waveamdmachine.uninit : !waveamdmachine.reg<vgpr, 1, 2>
  %off = waveamdmachine.uninit : !waveamdmachine.reg<vgpr, 1, 0>
  %desc = waveamdmachine.uninit : !waveamdmachine.reg<sgpr, 4, 4>
  %base = waveamdmachine.uninit : !waveamdmachine.reg<sgpr, 1, 8>
  %iv = waveamdmachine.uninit : !waveamdmachine.reg<sgpr, 1, 9>
  %step = waveamdmachine.uninit : !waveamdmachine.reg<sgpr, 1, 10>
  %zero = waveamdmachine.imm 0 : !waveamdmachine.imm
  %cond = waveamdmachine.s_cmp_lt_i32 %iv, %step
      : (!waveamdmachine.reg<sgpr, 1, 9>,
         !waveamdmachine.reg<sgpr, 1, 10>)
        -> !waveamdmachine.reg<scc, 1>
  %m0 = waveamdmachine.s_mov_m0 %base
      : (!waveamdmachine.reg<sgpr, 1, 8>) -> !waveamdmachine.m0
  %init = waveamdmachine.ds_store_b32 %addr, %data after %root
      : (!waveamdmachine.reg<vgpr, 1, 1>,
         !waveamdmachine.reg<vgpr, 1, 2>, !waveamdmachine.mem.token)
        -> !waveamdmachine.mem.token
  %loop:2 = waveamdmachine.uniform_loop if %cond
      : !waveamdmachine.reg<scc, 1>
      carries(%init, %iv : !waveamdmachine.mem.token,
              !waveamdmachine.reg<sgpr, 1, 9>) {
  ^bb0(%tok: !waveamdmachine.mem.token,
       %iter: !waveamdmachine.reg<sgpr, 1, 9>):
    %dma = waveamdmachine.buffer_load_lds_b128
        %off, %desc, %zero, %m0 after %tok
        : (!waveamdmachine.reg<vgpr, 1, 0>,
           !waveamdmachine.reg<sgpr, 4, 4>, !waveamdmachine.imm,
           !waveamdmachine.m0, !waveamdmachine.mem.token)
          -> !waveamdmachine.mem.token
    %next, %scc = waveamdmachine.s_add_i32 %iter, %step
        : (!waveamdmachine.reg<sgpr, 1, 9>,
           !waveamdmachine.reg<sgpr, 1, 10>)
          -> (!waveamdmachine.reg<sgpr, 1, 9>,
              !waveamdmachine.reg<scc, 1>)
    waveamdmachine.continue_if %scc : !waveamdmachine.reg<scc, 1>
        carries(%dma, %next : !waveamdmachine.mem.token,
                !waveamdmachine.reg<sgpr, 1, 9>)
  } -> !waveamdmachine.mem.token, !waveamdmachine.reg<sgpr, 1, 9>
  waveamdmachine.s_endpgm
  return
}

// ASM-LABEL: loop_carried_lds_prefetch_codegen:
// ASM: .Lloop_carried_lds_prefetch_codegen.loop_head_0:
// ASM: s_barrier
// ASM-NEXT: v_add_u32_e32 v5, v3, v4
// ASM-NEXT: ds_read_b32 v3, v0
// ASM: ds_read_b32 v4, v1
// DIAG: waveamd-machine-schedule region func=loop_carried_lds_prefetch_codegen index=1
// DIAG-SAME: action=apply reason=recurrence_model
// DIAG-SAME: recurrence_model_moves={{[1-9][0-9]*}}
func.func @loop_carried_lds_prefetch_codegen() attributes {wave.kernel} {
  %root = waveamdmachine.token : !waveamdmachine.mem.token
  %addr0 = waveamdmachine.uninit : !waveamdmachine.reg<vgpr, 1, 0>
  %addr1 = waveamdmachine.uninit : !waveamdmachine.reg<vgpr, 1, 1>
  %seed = waveamdmachine.uninit : !waveamdmachine.reg<vgpr, 1, 2>
  %iv = waveamdmachine.uninit : !waveamdmachine.reg<sgpr, 1, 8>
  %limit = waveamdmachine.uninit : !waveamdmachine.reg<sgpr, 1, 9>
  %cond = waveamdmachine.s_cmp_lt_i32 %iv, %limit
      : (!waveamdmachine.reg<sgpr, 1, 8>,
         !waveamdmachine.reg<sgpr, 1, 9>)
        -> !waveamdmachine.reg<scc, 1>
  %init0, %init_t0 = waveamdmachine.ds_load_b32 %addr0 after %root
      : (!waveamdmachine.reg<vgpr, 1, 0>, !waveamdmachine.mem.token)
        -> (!waveamdmachine.reg<vgpr, 1, 3>, !waveamdmachine.mem.token)
  %init1, %init_t1 = waveamdmachine.ds_load_b32 %addr1 after %root
      : (!waveamdmachine.reg<vgpr, 1, 1>, !waveamdmachine.mem.token)
        -> (!waveamdmachine.reg<vgpr, 1, 4>, !waveamdmachine.mem.token)
  %init_token = waveamdmachine.token_join %init_t0, %init_t1
      : (!waveamdmachine.mem.token, !waveamdmachine.mem.token)
        -> !waveamdmachine.mem.token
  %loop:3 = waveamdmachine.uniform_loop if %cond
      : !waveamdmachine.reg<scc, 1>
      carries(%init0, %init1, %init_token :
              !waveamdmachine.reg<vgpr, 1, 3>,
              !waveamdmachine.reg<vgpr, 1, 4>,
              !waveamdmachine.mem.token) {
  ^bb0(%tile0: !waveamdmachine.reg<vgpr, 1, 3>,
       %tile1: !waveamdmachine.reg<vgpr, 1, 4>,
       %tok: !waveamdmachine.mem.token):
    %ready = waveamdmachine.s_barrier %tok
        : (!waveamdmachine.mem.token) -> !waveamdmachine.mem.token
    %used = waveamdmachine.v_add_u32 %tile0, %tile1
        : (!waveamdmachine.reg<vgpr, 1, 3>,
           !waveamdmachine.reg<vgpr, 1, 4>)
          -> !waveamdmachine.reg<vgpr, 1, 5>
    %work0 = waveamdmachine.v_add_u32 %used, %seed
        : (!waveamdmachine.reg<vgpr, 1, 5>,
           !waveamdmachine.reg<vgpr, 1, 2>)
          -> !waveamdmachine.reg<vgpr, 1, 6>
    %work1 = waveamdmachine.v_add_u32 %work0, %seed
        : (!waveamdmachine.reg<vgpr, 1, 6>,
           !waveamdmachine.reg<vgpr, 1, 2>)
          -> !waveamdmachine.reg<vgpr, 1, 7>
    %work2 = waveamdmachine.v_add_u32 %work1, %seed
        : (!waveamdmachine.reg<vgpr, 1, 7>,
           !waveamdmachine.reg<vgpr, 1, 2>)
          -> !waveamdmachine.reg<vgpr, 1, 8>
    %work3 = waveamdmachine.v_add_u32 %work2, %seed
        : (!waveamdmachine.reg<vgpr, 1, 8>,
           !waveamdmachine.reg<vgpr, 1, 2>)
          -> !waveamdmachine.reg<vgpr, 1, 9>
    %work4 = waveamdmachine.v_add_u32 %work3, %seed
        : (!waveamdmachine.reg<vgpr, 1, 9>,
           !waveamdmachine.reg<vgpr, 1, 2>)
          -> !waveamdmachine.reg<vgpr, 1, 10>
    %work5 = waveamdmachine.v_add_u32 %work4, %seed
        : (!waveamdmachine.reg<vgpr, 1, 10>,
           !waveamdmachine.reg<vgpr, 1, 2>)
          -> !waveamdmachine.reg<vgpr, 1, 11>
    %next0, %read0 = waveamdmachine.ds_load_b32 %addr0 after %ready
        : (!waveamdmachine.reg<vgpr, 1, 0>, !waveamdmachine.mem.token)
          -> (!waveamdmachine.reg<vgpr, 1, 3>, !waveamdmachine.mem.token)
    %next1, %read1 = waveamdmachine.ds_load_b32 %addr1 after %ready
        : (!waveamdmachine.reg<vgpr, 1, 1>, !waveamdmachine.mem.token)
          -> (!waveamdmachine.reg<vgpr, 1, 4>, !waveamdmachine.mem.token)
    %next_token = waveamdmachine.token_join %read0, %read1
        : (!waveamdmachine.mem.token, !waveamdmachine.mem.token)
          -> !waveamdmachine.mem.token
    waveamdmachine.continue_if %cond : !waveamdmachine.reg<scc, 1>
        carries(%next0, %next1, %next_token :
                !waveamdmachine.reg<vgpr, 1, 3>,
                !waveamdmachine.reg<vgpr, 1, 4>,
                !waveamdmachine.mem.token)
  } -> !waveamdmachine.reg<vgpr, 1, 3>,
       !waveamdmachine.reg<vgpr, 1, 4>, !waveamdmachine.mem.token
  waveamdmachine.s_endpgm
  return
}

}
