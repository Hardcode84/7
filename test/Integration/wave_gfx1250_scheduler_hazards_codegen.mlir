// RUN: wave-opt --waveamd-insert-hazard-waits %s > %t.mlir
// RUN: FileCheck %s --check-prefix=IR < %t.mlir
// RUN: env WAVE_PIPELINES_DIR=%S/../Target/Wave/Inputs/emit-only-pipeline \
// RUN:   wave-translate --wave-to-amdgpu-asm %t.mlir > %t.s
// RUN: FileCheck %s --check-prefix=ASM \
// RUN:   --implicit-check-not=HW_REG_WAVE_SCHED_MODE < %t.s
// RUN: llvm-mc -triple=amdgcn-amd-amdhsa -mcpu=gfx1250 \
// RUN:   -filetype=obj %t.s -o %t.o
// RUN: llvm-objdump -d --mcpu=gfx1250 %t.o \
// RUN:   | FileCheck %s --check-prefix=DIS \
// RUN:       --implicit-check-not=HW_REG_WAVE_SCHED_MODE

// IR-LABEL: func.func @gfx1250_trans_hazard
// IR: waveamdmachine.v_exp_f32
// IR-NEXT: waveamdmachine.v_nop
// IR-NEXT: waveamdmachine.v_add_f32
// IR-LABEL: func.func @gfx1250_scratch_forwarding
// IR: waveamdmachine.s_mov_b32 "s102"
// IR-NEXT: waveamdmachine.s_wait_alu sa_sdst(0) va_sdst(0)
// IR-NEXT: waveamdmachine.scratch_load_b32

// ASM-LABEL: gfx1250_trans_hazard:
// ASM: v_exp_f32_e32 v2, v0
// ASM-NEXT: v_nop
// ASM-NEXT: v_add_f32_e32 v3, v2, v1
// ASM-LABEL: gfx1250_scratch_forwarding:
// ASM: s_mov_b32 s102, 0
// ASM-NEXT: s_wait_alu depctr_sa_sdst(0) depctr_va_sdst(0)
// ASM-NEXT: scratch_load_b32

// DIS-LABEL: <gfx1250_trans_hazard>:
// DIS: v_exp_f32_e32 v2, v0
// DIS-NEXT: v_nop
// DIS-NEXT: v_add_f32_e32 v3, v2, v1
// DIS-LABEL: <gfx1250_scratch_forwarding>:
// DIS: s_mov_b32 s102, 0
// DIS-NEXT: s_wait_alu depctr_sa_sdst(0) depctr_va_sdst(0)
// DIS-NEXT: scratch_load_b32

module attributes {
  waveamdmachine.target = "amdgcn-amd-amdhsa--gfx1250"
} {

func.func @gfx1250_trans_hazard(
    %x: !waveamdmachine.reg<vgpr, 1, 0>,
    %y: !waveamdmachine.reg<vgpr, 1, 1>) {
  %exp = waveamdmachine.v_exp_f32 %x
      : (!waveamdmachine.reg<vgpr, 1, 0>)
      -> !waveamdmachine.reg<vgpr, 1, 2>
  %sum = waveamdmachine.v_add_f32 %exp, %y
      : (!waveamdmachine.reg<vgpr, 1, 2>,
         !waveamdmachine.reg<vgpr, 1, 1>)
      -> !waveamdmachine.reg<vgpr, 1, 3>
  waveamdmachine.s_endpgm
  return
}

func.func @gfx1250_scratch_forwarding() {
  %zero = waveamdmachine.imm 0 : !waveamdmachine.imm
  %saddr = waveamdmachine.uninit
      : !waveamdmachine.reg<sgpr, 1, 13>
  waveamdmachine.s_mov_b32 "s102", %zero
      : (!waveamdmachine.imm) -> ()
  %value, %token = waveamdmachine.scratch_load_b32 %zero, %saddr
      : (!waveamdmachine.imm, !waveamdmachine.reg<sgpr, 1, 13>)
      -> (!waveamdmachine.reg<vgpr, 1, 0>,
          !waveamdmachine.mem.token)
  waveamdmachine.s_endpgm
  return
}

}
