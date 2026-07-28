// RUN: env WAVE_PIPELINES_DIR=%S/Inputs/emit-only-pipeline \
// RUN:   wave-translate --wave-to-amdgpu-asm %s \
// RUN:   | FileCheck %s --check-prefix=ASM
// RUN: env WAVE_PIPELINES_DIR=%S/Inputs/emit-only-pipeline \
// RUN:   wave-translate --wave-to-amdgpu-asm %s \
// RUN:   | llvm-mc -triple=amdgcn-amd-amdhsa -mcpu=gfx1250 \
// RUN:       -filetype=obj -o %t.o
// RUN: llvm-objdump -d --mcpu=gfx1250 %t.o \
// RUN:   | FileCheck %s --check-prefix=DIS

module attributes {
  waveamdmachine.target = "amdgcn-amd-amdhsa--gfx1250"
} {

// ASM-LABEL: vgpr_window:
// ASM: buffered_high:
// ASM: s_set_vgpr_msb 0xf9
// ASM: v_fma_f32 v255 /*v1023*/, v44 /*v300*/, v44 /*v556*/, v44 /*v812*/
// ASM: s_cbranch_scc0 .Lvgpr_window.if_else_0
// ASM: s_set_vgpr_msb 0xf9f9
// ASM: v_fma_f32 v254 /*v1022*/, v44 /*v300*/, v44 /*v556*/, v44 /*v812*/
// ASM: s_branch .Lvgpr_window.if_end_0
// ASM: .Lvgpr_window.if_else_0:
// ASM: s_set_vgpr_msb 0xf9f9
// ASM: v_fma_f32 v253 /*v1021*/, v44 /*v300*/, v44 /*v556*/, v44 /*v812*/
// ASM: .Lvgpr_window.if_end_0:
// ASM: s_set_vgpr_msb 0xf900
// ASM: s_endpgm
// DIS-LABEL: <vgpr_window>:
// DIS: s_set_vgpr_msb 0xf9
// DIS: v_fma_f32 v255 /*v1023*/, v44 /*v300*/, v44 /*v556*/, v44 /*v812*/
// DIS: s_cbranch_scc0
// DIS: s_set_vgpr_msb 0xf9f9
// DIS: v_fma_f32 v254 /*v1022*/, v44 /*v300*/, v44 /*v556*/, v44 /*v812*/
// DIS: s_branch
// DIS: s_set_vgpr_msb 0xf9f9
// DIS: v_fma_f32 v253 /*v1021*/, v44 /*v300*/, v44 /*v556*/, v44 /*v812*/
// DIS: s_set_vgpr_msb 0xf900
// DIS: s_endpgm
func.func @vgpr_window() {
  %src0 = waveamdmachine.uninit
      : !waveamdmachine.reg<vgpr, 1, 300>
  %src1 = waveamdmachine.uninit
      : !waveamdmachine.reg<vgpr, 1, 556>
  %src2 = waveamdmachine.uninit
      : !waveamdmachine.reg<vgpr, 1, 812>
  %zero = waveamdmachine.imm 0 : !waveamdmachine.imm
  %cond = waveamdmachine.s_cmp_eq_u32 %zero, %zero
      : (!waveamdmachine.imm, !waveamdmachine.imm)
        -> !waveamdmachine.reg<scc, 1>
  %mode = waveamdmachine.imm 249 : !waveamdmachine.imm
  waveamdmachine.label "buffered_high"
  waveamdmachine.s_set_vgpr_msb %mode
      : (!waveamdmachine.imm) -> ()
  %result = waveamdmachine.v_fma_f32 %src0, %src1, %src2
      : (!waveamdmachine.reg<vgpr, 1, 300>,
         !waveamdmachine.reg<vgpr, 1, 556>,
         !waveamdmachine.reg<vgpr, 1, 812>)
        -> !waveamdmachine.reg<vgpr, 1, 1023>
  %same_mode = waveamdmachine.imm 63993 : !waveamdmachine.imm
  waveamdmachine.uniform_if %cond {
    waveamdmachine.s_set_vgpr_msb %same_mode
        : (!waveamdmachine.imm) -> ()
    %then = waveamdmachine.v_fma_f32 %src0, %src1, %src2
        : (!waveamdmachine.reg<vgpr, 1, 300>,
           !waveamdmachine.reg<vgpr, 1, 556>,
           !waveamdmachine.reg<vgpr, 1, 812>)
          -> !waveamdmachine.reg<vgpr, 1, 1022>
    waveamdmachine.yield
  } otherwise {
    waveamdmachine.s_set_vgpr_msb %same_mode
        : (!waveamdmachine.imm) -> ()
    %else = waveamdmachine.v_fma_f32 %src0, %src1, %src2
        : (!waveamdmachine.reg<vgpr, 1, 300>,
           !waveamdmachine.reg<vgpr, 1, 556>,
           !waveamdmachine.reg<vgpr, 1, 812>)
          -> !waveamdmachine.reg<vgpr, 1, 1021>
    waveamdmachine.yield
  } : !waveamdmachine.reg<scc, 1>
  %reset = waveamdmachine.imm 63744 : !waveamdmachine.imm
  waveamdmachine.s_set_vgpr_msb %reset
      : (!waveamdmachine.imm) -> ()
  waveamdmachine.s_endpgm
  return
}

}
