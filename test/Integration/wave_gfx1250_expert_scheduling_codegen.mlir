// RUN: wave-opt --waveamd-insert-ticket-waits %s > %t.mlir
// RUN: FileCheck %s --check-prefix=IR < %t.mlir
// RUN: env WAVE_PIPELINES_DIR=%S/../Target/Wave/Inputs/emit-only-pipeline \
// RUN:   wave-translate --wave-to-amdgpu-asm %t.mlir > %t.s
// RUN: FileCheck %s --check-prefix=ASM < %t.s
// RUN: llvm-mc -triple=amdgcn-amd-amdhsa -mcpu=gfx1250 \
// RUN:   -filetype=obj %t.s -o %t.o
// RUN: llvm-objdump -d --mcpu=gfx1250 %t.o \
// RUN:   | FileCheck %s --check-prefix=DIS

// IR-LABEL: func.func @expert_wait_codegen
// IR: waveamdmachine.s_set_sched_mode expert2
// IR: [[OLD:%.*]] = waveamdmachine.v_exp_f32
// IR-NEXT: waveamdmachine.v_exp_f32
// IR-NEXT: waveamdmachine.s_wait_alu va_vdst(1)
// IR-NEXT: waveamdmachine.global_store_b32

// ASM-LABEL: expert_wait_codegen:
// ASM: s_setreg_imm32_b32 hwreg(HW_REG_WAVE_SCHED_MODE, 0, 2), 2
// ASM: v_exp_f32_e32 v2, v0
// ASM-NEXT: v_exp_f32_e32 v3, v1
// ASM-NEXT: s_wait_alu depctr_va_vdst(1)
// ASM-NEXT: global_store_b32 v0, v2, s[0:1]

// DIS-LABEL: <expert_wait_codegen>:
// DIS: s_setreg_imm32_b32 hwreg(HW_REG_WAVE_SCHED_MODE, 0, 2), 2
// DIS: v_exp_f32_e32 v2, v0
// DIS-NEXT: v_exp_f32_e32 v3, v1
// DIS-NEXT: s_wait_alu depctr_va_vdst(1)
// DIS-NEXT: global_store_b32 v0, v2, s[0:1]

module attributes {
  waveamdmachine.target = "amdgcn-amd-amdhsa--gfx1250"
} {

func.func @expert_wait_codegen() attributes {
    wave.kernel,
    waveamdmachine.expert_scheduling_mode
  } {
  %x = waveamdmachine.uninit : !waveamdmachine.reg<vgpr, 1, 0>
  %y = waveamdmachine.uninit : !waveamdmachine.reg<vgpr, 1, 1>
  %base = waveamdmachine.uninit : !waveamdmachine.reg<sgpr, 2, 0>
  %old = waveamdmachine.v_exp_f32 %x
      : (!waveamdmachine.reg<vgpr, 1, 0>)
        -> !waveamdmachine.reg<vgpr, 1, 2>
  %newer = waveamdmachine.v_exp_f32 %y
      : (!waveamdmachine.reg<vgpr, 1, 1>)
        -> !waveamdmachine.reg<vgpr, 1, 3>
  waveamdmachine.global_store_b32 %x, %old, %base
      : (!waveamdmachine.reg<vgpr, 1, 0>,
         !waveamdmachine.reg<vgpr, 1, 2>,
         !waveamdmachine.reg<sgpr, 2, 0>) -> ()
  waveamdmachine.s_endpgm
  return
}

}
