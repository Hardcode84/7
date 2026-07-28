// RUN: wave-opt %s \
// RUN:   | env WAVE_PIPELINES_DIR=%S/../Target/Wave/Inputs/emit-only-pipeline \
// RUN:       wave-translate --wave-to-amdgpu-asm - \
// RUN:   | FileCheck %s --check-prefix=ASM
// RUN: wave-opt %s \
// RUN:   | env WAVE_PIPELINES_DIR=%S/../Target/Wave/Inputs/emit-only-pipeline \
// RUN:       wave-translate --wave-to-amdgpu-asm - \
// RUN:   | llvm-mc -triple=amdgcn-amd-amdhsa -mcpu=gfx1250 \
// RUN:       -filetype=obj -o %t.o
// RUN: llvm-objdump -d --mcpu=gfx1250 %t.o \
// RUN:   | FileCheck %s --check-prefix=DIS

module attributes {
  waveamdmachine.target = "amdgcn-amd-amdhsa--gfx1250"
} {

// ASM-LABEL: explicit_vgpr_window_codegen:
// ASM: global_prefetch_b8 v0, s[0:1] scope:SCOPE_SE
// ASM-NEXT: v_nop
// ASM-NEXT: s_setreg_imm32_b32 hwreg(HW_REG_WAVE_MODE, 25, 1), 1
// ASM: windowed:
// ASM-NEXT: s_nop 0
// ASM-NEXT: s_set_vgpr_msb 0xf9
// ASM: v_fma_f32 v255 /*v1023*/, v44 /*v300*/, v44 /*v556*/, v44 /*v812*/
// ASM: s_set_vgpr_msb 0xf900
// ASM: s_endpgm
// DIS-LABEL: <explicit_vgpr_window_codegen>:
// DIS: s_setreg_imm32_b32 hwreg(HW_REG_WAVE_MODE, 25, 1), 1
// DIS: s_nop 0
// DIS-NEXT: s_set_vgpr_msb 0xf9
// DIS: v_fma_f32 v255 /*v1023*/, v44 /*v300*/, v44 /*v556*/, v44 /*v812*/
// DIS: s_set_vgpr_msb 0xf900
// DIS: s_endpgm
func.func @explicit_vgpr_window_codegen() attributes {wave.kernel} {
  %src0 = waveamdmachine.uninit
      : !waveamdmachine.reg<vgpr, 1, 300>
  %src1 = waveamdmachine.uninit
      : !waveamdmachine.reg<vgpr, 1, 556>
  %src2 = waveamdmachine.uninit
      : !waveamdmachine.reg<vgpr, 1, 812>
  %mode = waveamdmachine.imm 249 : !waveamdmachine.imm
  waveamdmachine.label "windowed"
  waveamdmachine.s_set_vgpr_msb %mode
      : (!waveamdmachine.imm) -> ()
  %result = waveamdmachine.v_fma_f32 %src0, %src1, %src2
      : (!waveamdmachine.reg<vgpr, 1, 300>,
         !waveamdmachine.reg<vgpr, 1, 556>,
         !waveamdmachine.reg<vgpr, 1, 812>)
        -> !waveamdmachine.reg<vgpr, 1, 1023>
  %reset = waveamdmachine.imm 63744 : !waveamdmachine.imm
  waveamdmachine.s_set_vgpr_msb %reset
      : (!waveamdmachine.imm) -> ()
  waveamdmachine.s_endpgm
  return
}

}
