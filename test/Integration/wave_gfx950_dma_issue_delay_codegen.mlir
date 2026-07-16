// RUN: wave-opt %s --waveamd-resource-info \
// RUN:   | env WAVE_PIPELINES_DIR=%S/../Target/Wave/Inputs/emit-only-pipeline wave-translate --wave-to-amdgpu-asm - \
// RUN:   | FileCheck %s --check-prefix=ASM
// RUN: wave-opt %s --waveamd-resource-info \
// RUN:   | env WAVE_PIPELINES_DIR=%S/../Target/Wave/Inputs/emit-only-pipeline wave-translate --wave-to-amdgpu-asm - \
// RUN:   | llvm-mc -triple=amdgcn-amd-amdhsa -mcpu=gfx950 -filetype=obj -o /dev/null

module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx950"} {

// ASM-LABEL: gfx950_dma_issue_delay_codegen:
// ASM: s_cbranch_vccnz [[SKIP:.Lgfx950_dma_issue_delay_codegen.dma_issue_delay_0]]
// ASM-NEXT: s_nop 15
// ASM-NEXT: s_nop 15
// ASM-NEXT: s_nop 13
// ASM-NEXT: [[SKIP]]:
// ASM-NEXT: s_endpgm
func.func @gfx950_dma_issue_delay_codegen(
    %dep: !waveamdmachine.mem.token,
    %m0: !waveamdmachine.m0,
    %skip: !waveamdmachine.reg<vcc, 1>) attributes {wave.kernel} {
  %delayed_m0 = waveamdmachine.dma_issue_delay %dep, %m0 unless %skip
      {cycles = 46 : i64, overlap_cycles = 16 : i64}
      : (!waveamdmachine.mem.token, !waveamdmachine.m0,
         !waveamdmachine.reg<vcc, 1>) -> !waveamdmachine.m0
  waveamdmachine.s_endpgm
  return
}

}
