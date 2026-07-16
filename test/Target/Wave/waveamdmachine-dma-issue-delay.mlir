// RUN: wave-translate --wave-to-amdgpu-asm %s | FileCheck %s
// RUN: wave-translate --wave-to-amdgpu-asm %s | llvm-mc -triple=amdgcn-amd-amdhsa -mcpu=gfx950 -filetype=obj -o /dev/null

module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx950"} {

// CHECK-LABEL: dma_issue_delay:
// CHECK: s_cbranch_vccnz [[SKIP:.Ldma_issue_delay.dma_issue_delay_0]]
// CHECK-NEXT: s_nop 15
// CHECK-NEXT: s_nop 15
// CHECK-NEXT: s_nop 13
// CHECK-NEXT: [[SKIP]]:
func.func @dma_issue_delay(%dep: !waveamdmachine.mem.token,
                           %m0: !waveamdmachine.m0,
                           %skip: !waveamdmachine.reg<vcc, 1>)
    attributes {wave.kernel} {
  %delayed_m0 = waveamdmachine.dma_issue_delay %dep, %m0 unless %skip
      {cycles = 46 : i64, overlap_cycles = 16 : i64}
      : (!waveamdmachine.mem.token, !waveamdmachine.m0,
         !waveamdmachine.reg<vcc, 1>) -> !waveamdmachine.m0
  return
}

// CHECK-LABEL: dma_issue_delay_unconditional:
// CHECK: s_nop 15
// CHECK-NEXT: s_nop 0
func.func @dma_issue_delay_unconditional(%dep: !waveamdmachine.mem.token,
                                         %m0: !waveamdmachine.m0)
    attributes {wave.kernel} {
  %delayed_m0 = waveamdmachine.dma_issue_delay %dep, %m0
      {cycles = 17 : i64}
      : (!waveamdmachine.mem.token, !waveamdmachine.m0)
        -> !waveamdmachine.m0
  return
}

// CHECK-LABEL: explicit_loop_fetch_phase:
// CHECK: s_cbranch_scc0
// CHECK-NEXT: .p2align 5
// CHECK-COUNT-4: s_nop 0
// CHECK-NEXT: [[PHASED_HEAD:.Lexplicit_loop_fetch_phase.loop_head_0]]:
// CHECK: s_cbranch_scc1 [[PHASED_HEAD]]
func.func @explicit_loop_fetch_phase(
    %cond: !waveamdmachine.reg<scc, 1>) attributes {wave.kernel} {
  waveamdmachine.uniform_loop if %cond : !waveamdmachine.reg<scc, 1> {
    waveamdmachine.continue_if %cond : !waveamdmachine.reg<scc, 1>
  } {fetch_alignment = 32 : i64, fetch_phase = 16 : i64}
  return
}

// CHECK-LABEL: unannotated_dma_loop:
// CHECK: s_cbranch_scc0
// CHECK-NOT: .p2align
// CHECK-NOT: s_nop
// CHECK-NEXT: [[PLAIN_HEAD:.Lunannotated_dma_loop.loop_head_0]]:
// CHECK: s_nop 3
func.func @unannotated_dma_loop(
    %dep: !waveamdmachine.mem.token,
    %m0_source: !waveamdmachine.reg<sgpr, 1>,
    %cond: !waveamdmachine.reg<scc, 1>) attributes {wave.kernel} {
  %m0 = waveamdmachine.s_mov_m0 %m0_source
      : (!waveamdmachine.reg<sgpr, 1>) -> !waveamdmachine.m0
  waveamdmachine.uniform_loop if %cond : !waveamdmachine.reg<scc, 1> {
    %delayed_m0 = waveamdmachine.dma_issue_delay %dep, %m0
        {cycles = 4 : i64}
        : (!waveamdmachine.mem.token, !waveamdmachine.m0)
          -> !waveamdmachine.m0
    waveamdmachine.continue_if %cond : !waveamdmachine.reg<scc, 1>
  }
  return
}

// CHECK-LABEL: restore_vcc_wave64:
// CHECK: s_mov_b32 vcc_lo,
// CHECK-NEXT: s_mov_b32 vcc_hi, 0
func.func @restore_vcc_wave64(%flag: !waveamdmachine.reg<sgpr, 1>)
    attributes {wave.kernel} {
  %restored = waveamdmachine.s_mov_vcc_b32 %flag
      : (!waveamdmachine.reg<sgpr, 1>) -> !waveamdmachine.reg<vcc, 1>
  return
}

}
