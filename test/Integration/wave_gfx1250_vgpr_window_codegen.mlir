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

// ASM-LABEL: automatic_vgpr_window_codegen:
// ASM: global_prefetch_b8 v0, s[0:1] scope:SCOPE_SE
// ASM-NEXT: v_nop
// ASM-NEXT: s_setreg_imm32_b32 hwreg(HW_REG_WAVE_MODE, 25, 1), 1
// ASM: windowed:
// ASM-NEXT: s_nop 0
// ASM-NEXT: s_set_vgpr_msb 0xf9
// ASM: v_fma_f32 v255 /*v1023*/, v0 /*v256*/, v0 /*v512*/, v0 /*v768*/
// ASM-NEXT: s_setreg_imm32_b32 hwreg(HW_REG_WAVE_MODE), 0xe7000
// ASM-NEXT: v_fma_f32 v254 /*v1022*/, v0 /*v256*/, v0 /*v512*/, v0 /*v768*/
// ASM: s_endpgm
// DIS-LABEL: <automatic_vgpr_window_codegen>:
// DIS: s_setreg_imm32_b32 hwreg(HW_REG_WAVE_MODE, 25, 1), 1
// DIS: s_nop 0
// DIS-NEXT: s_set_vgpr_msb 0xf9
// DIS: v_fma_f32 v255 /*v1023*/, v0 /*v256*/, v0 /*v512*/, v0 /*v768*/
// DIS-NEXT: s_setreg_imm32_b32 hwreg(HW_REG_WAVE_MODE), 0xe7000
// DIS-NEXT: v_fma_f32 v254 /*v1022*/, v0 /*v256*/, v0 /*v512*/, v0 /*v768*/
// DIS: s_endpgm
func.func @automatic_vgpr_window_codegen() attributes {wave.kernel} {
  %src0 = waveamdmachine.uninit
      : !waveamdmachine.reg<vgpr, 1, 256>
  %src1 = waveamdmachine.uninit
      : !waveamdmachine.reg<vgpr, 1, 512>
  %src2 = waveamdmachine.uninit
      : !waveamdmachine.reg<vgpr, 1, 768>
  waveamdmachine.label "windowed"
  %result = waveamdmachine.v_fma_f32 %src0, %src1, %src2
      : (!waveamdmachine.reg<vgpr, 1, 256>,
         !waveamdmachine.reg<vgpr, 1, 512>,
         !waveamdmachine.reg<vgpr, 1, 768>)
        -> !waveamdmachine.reg<vgpr, 1, 1023>
  waveamdmachine.s_setreg_imm32_b32 value 0 hwreg(1, 0, 32)
  %second = waveamdmachine.v_fma_f32 %src0, %src1, %src2
      : (!waveamdmachine.reg<vgpr, 1, 256>,
         !waveamdmachine.reg<vgpr, 1, 512>,
         !waveamdmachine.reg<vgpr, 1, 768>)
        -> !waveamdmachine.reg<vgpr, 1, 1022>
  waveamdmachine.s_endpgm
  return
}

}
