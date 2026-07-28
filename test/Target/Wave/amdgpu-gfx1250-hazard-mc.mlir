// RUN: env WAVE_PIPELINES_DIR=%S/Inputs/emit-only-pipeline \
// RUN:   wave-translate --wave-to-amdgpu-asm %s \
// RUN:   | FileCheck %s --check-prefix=ASM \
// RUN:       --implicit-check-not=HW_REG_WAVE_SCHED_MODE
// RUN: env WAVE_PIPELINES_DIR=%S/Inputs/emit-only-pipeline \
// RUN:   wave-translate --wave-to-amdgpu-asm %s \
// RUN:   | llvm-mc -triple=amdgcn-amd-amdhsa -mcpu=gfx1250 \
// RUN:       -filetype=obj -o %t.o
// RUN: llvm-objdump -d --mcpu=gfx1250 %t.o \
// RUN:   | FileCheck %s --check-prefix=DIS \
// RUN:       --implicit-check-not=HW_REG_WAVE_SCHED_MODE

module attributes {
  waveamdmachine.target = "amdgcn-amd-amdhsa--gfx1250"
} {

// ASM-LABEL: hazard_instructions:
// ASM: v_nop
// ASM-NEXT: s_wait_alu depctr_va_vdst(0)
// ASM-NEXT: s_wait_alu depctr_sa_sdst(0) depctr_va_sdst(0)
// ASM-NEXT: s_endpgm
// DIS-LABEL: <hazard_instructions>:
// DIS: v_nop
// DIS-NEXT: s_wait_alu depctr_va_vdst(0)
// DIS-NEXT: s_wait_alu depctr_sa_sdst(0) depctr_va_sdst(0)
// DIS-NEXT: s_endpgm
func.func @hazard_instructions() {
  waveamdmachine.v_nop
  waveamdmachine.s_wait_alu va_vdst(0)
  waveamdmachine.s_wait_alu sa_sdst(0) va_sdst(0)
  waveamdmachine.s_endpgm
  return
}

}
