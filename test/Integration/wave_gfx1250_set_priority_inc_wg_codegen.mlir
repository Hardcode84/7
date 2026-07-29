// RUN: wave-opt %s \
// RUN:   --pass-pipeline='builtin.module(transform-preload-library{transform-library-paths=%wave_pipelines},transform-interpreter{entry-point=waveamd_backend_unscheduled})' \
// RUN:   > %t.mlir
// RUN: FileCheck %s --check-prefix=IR < %t.mlir
// RUN: env WAVE_PIPELINES_DIR=%S/../Target/Wave/Inputs/emit-only-pipeline \
// RUN:   wave-translate --wave-to-amdgpu-asm %t.mlir > %t.s
// RUN: FileCheck %s --check-prefix=ASM < %t.s
// RUN: llvm-mc -triple=amdgcn-amd-amdhsa -mcpu=gfx1250 \
// RUN:   -filetype=obj %t.s -o %t.o
// RUN: ld.lld -shared %t.o -o %t.hsaco
// RUN: llvm-objdump -d --mcpu=gfx1250 %t.hsaco \
// RUN:   | FileCheck %s --check-prefix=DIS

// IR-LABEL: func.func @gfx1250_set_priority_inc_wg()
// IR: waveamdmachine.s_setprio
// IR: waveamdmachine.s_setprio_inc_wg 100

// ASM-LABEL: gfx1250_set_priority_inc_wg:
// ASM: s_setprio 2
// ASM-NEXT: s_setprio_inc_wg 0x64

// DIS-LABEL: <gfx1250_set_priority_inc_wg>:
// DIS: s_setprio 2
// DIS-NEXT: s_setprio_inc_wg 0x64

module attributes {
  waveamdmachine.target = "amdgcn-amd-amdhsa--gfx1250"
} {

func.func @gfx1250_set_priority_inc_wg() attributes {
    wave.kernel,
    waveamdmachine.expert_scheduling_mode
  } {
  waveamd.set_priority 2
  waveamd.set_priority_inc_wg 100
  return
}

}
