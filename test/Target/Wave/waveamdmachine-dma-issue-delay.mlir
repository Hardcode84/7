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

}
