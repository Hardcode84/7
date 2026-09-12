// RUN: not wave-opt %s --waveamd-prepare-regalloc 2>&1 | FileCheck %s --check-prefix=ALLOC
// RUN: not wave-translate %s --wave-to-amdgpu-asm 2>&1 | FileCheck %s --check-prefix=ASM

// ALLOC: must be collapsed before register allocation
// ASM: must be collapsed before register allocation
module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx1100"} {
  func.func @unresolved() attributes {wave.kernel} {
    waveamdmachine.materialization_candidates {
      waveamdmachine.s_barrier : () -> ()
      waveamdmachine.candidate_yield {cycles = 1 : i64}
    }, {
      waveamdmachine.s_barrier : () -> ()
      waveamdmachine.candidate_yield {cycles = 2 : i64}
    }
    waveamdmachine.s_endpgm
    return
  }
}
