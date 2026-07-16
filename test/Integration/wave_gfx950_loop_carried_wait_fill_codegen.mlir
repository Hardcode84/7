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

module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx950"} {

// ASM-LABEL: loop_carried_wait_fill_codegen:
// ASM: .Lloop_carried_wait_fill_codegen.loop_head_0:
// ASM-NEXT: s_add_i32 s9, s9, s10
// ASM-NEXT: s_waitcnt vmcnt(0) lgkmcnt(0)
// ASM-NEXT: buffer_load_dwordx4 v0, s[4:7], 0 offen lds
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
        {waveamdmachine.dma_issue_timing}
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

}
