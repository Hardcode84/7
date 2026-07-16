// RUN: wave-opt %s --waveamd-resource-info \
// RUN:   | env WAVE_PIPELINES_DIR=%S/../Target/Wave/Inputs/emit-only-pipeline wave-translate --wave-to-amdgpu-asm - \
// RUN:   | FileCheck %s --check-prefix=ASM
// RUN: wave-opt %s --waveamd-resource-info \
// RUN:   | env WAVE_PIPELINES_DIR=%S/../Target/Wave/Inputs/emit-only-pipeline wave-translate --wave-to-amdgpu-asm - \
// RUN:   | llvm-mc -triple=amdgcn-amd-amdhsa -mcpu=gfx950 -filetype=obj -o /dev/null

module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx950"} {

// ASM-LABEL: gfx950_loop_fetch_phase_codegen:
// ASM: s_cbranch_scc0
// ASM-NEXT: .p2align 5
// ASM-COUNT-4: s_nop 0
// ASM-NEXT: [[HEAD:.Lgfx950_loop_fetch_phase_codegen.loop_head_0]]:
// ASM-NEXT: s_cbranch_scc1 [[HEAD]]
func.func @gfx950_loop_fetch_phase_codegen(
    %cond: !waveamdmachine.reg<scc, 1>) attributes {wave.kernel} {
  waveamdmachine.uniform_loop if %cond : !waveamdmachine.reg<scc, 1> {
    waveamdmachine.continue_if %cond : !waveamdmachine.reg<scc, 1>
  } {fetch_alignment = 32 : i64, fetch_phase = 16 : i64}
  waveamdmachine.s_endpgm
  return
}

}
