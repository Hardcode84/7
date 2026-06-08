// RUN: wave-opt --waveamd-reg-alloc %s | FileCheck %s
// RUN: wave-opt --waveamd-reg-alloc --waveamd-resource-info %s \
// RUN:   | wave-translate --wave-to-amdgpu-asm - \
// RUN:   | FileCheck %s --check-prefix=ASM
// RUN: wave-opt --waveamd-reg-alloc --waveamd-resource-info %s \
// RUN:   | wave-translate --wave-to-amdgpu-asm - \
// RUN:   | llvm-mc -triple=amdgcn-amd-amdhsa -mcpu=gfx950 -filetype=obj -o /dev/null

module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx950"} {

// CHECK-LABEL: func.func @regalloc_debug_scaffold
// CHECK-SAME: waveamdmachine.regalloc_debug_intervals =
// CHECK-SAME: waveamdmachine.regalloc_debug_peak_vgpr = 4 : i64
// CHECK: !waveamdmachine.reg<vgpr, 4, {{[0-9]+}}>
// ASM-LABEL: regalloc_debug_scaffold:
// ASM: s_endpgm
func.func @regalloc_debug_scaffold() {
  %zero = waveamdmachine.imm 0 : !waveamdmachine.imm
  %tuple = waveamdmachine.v_mov_b32_tuple %zero {registers = 4 : i64}
      : (!waveamdmachine.imm) -> !waveamdmachine.reg<vgpr, 4>
  %parts:2 = waveamdmachine.tuple_to_elements %tuple
      : (!waveamdmachine.reg<vgpr, 4>)
      -> (!waveamdmachine.reg<vgpr, 2>, !waveamdmachine.reg<vgpr, 2>)
  %again = waveamdmachine.tuple_from_elements %parts#0, %parts#1
      : (!waveamdmachine.reg<vgpr, 2>, !waveamdmachine.reg<vgpr, 2>)
      -> !waveamdmachine.reg<vgpr, 4>
  waveamdmachine.s_endpgm
  return
}

}
