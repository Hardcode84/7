// RUN: wave-translate --wave-to-amdgpu-asm %s | FileCheck %s
// RUN: wave-translate --wave-to-amdgpu-asm %s \
// RUN:   | llvm-mc -triple=amdgcn-amd-amdhsa -mcpu=gfx1100 -filetype=obj -o /dev/null

module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx1100"} {

// CHECK-LABEL: sched_barrier_codegen:
// CHECK-NEXT: ; wave backend: WaveAMDMachine MLIR pipeline finalized
// CHECK-NEXT: s_endpgm
func.func @sched_barrier_codegen() attributes {wave.kernel} {
  wave.sched_barrier
  return
}

}
