// RUN: env WAVE_PIPELINES_DIR=%S/Inputs/emit-only-pipeline \
// RUN:   wave-translate --wave-to-amdgpu-asm %s > %t.s
// RUN: FileCheck %s --check-prefix=ASM < %t.s
// RUN: llvm-mc -triple=amdgcn-amd-amdhsa -mcpu=gfx1250 \
// RUN:   -filetype=obj %t.s -o %t.o
// RUN: llvm-objdump -d --mcpu=gfx1250 %t.o \
// RUN:   | FileCheck %s --check-prefix=DIS
// RUN: wave-opt %s | FileCheck %s --check-prefix=ROUND

module attributes {
  waveamdmachine.target = "amdgcn-amd-amdhsa--gfx1250"
} {

// ASM-LABEL: expert_instructions:
// ASM: s_setreg_imm32_b32 hwreg(HW_REG_WAVE_SCHED_MODE, 0, 2), 2
// ASM-NEXT: s_setprio_inc_wg 0x64
// ASM-NEXT: s_wait_alu depctr_va_vdst(3) depctr_vm_vsrc(2)
// ASM-NEXT: s_setreg_imm32_b32 hwreg(HW_REG_WAVE_SCHED_MODE, 0, 2), 0
// ASM-NEXT: s_endpgm
// DIS-LABEL: <expert_instructions>:
// DIS: s_setreg_imm32_b32 hwreg(HW_REG_WAVE_SCHED_MODE, 0, 2), 2
// DIS-NEXT: s_setprio_inc_wg 0x64
// DIS-NEXT: s_wait_alu depctr_va_vdst(3) depctr_vm_vsrc(2)
// DIS-NEXT: s_setreg_imm32_b32 hwreg(HW_REG_WAVE_SCHED_MODE, 0, 2), 0
// DIS-NEXT: s_endpgm
// ROUND-LABEL: func.func @expert_instructions
// ROUND: waveamdmachine.s_setprio_inc_wg 100
func.func @expert_instructions() {
  waveamdmachine.s_set_sched_mode expert2
  waveamdmachine.s_setprio_inc_wg 100
  waveamdmachine.s_wait_alu va_vdst(3) vm_vsrc(2)
  waveamdmachine.s_set_sched_mode normal
  waveamdmachine.s_endpgm
  return
}

}
