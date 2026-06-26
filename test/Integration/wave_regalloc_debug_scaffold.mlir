// RUN: rm -f %t.yaml
// RUN: wave-opt --waveamd-reg-alloc --remarks-filter=waveamdmachine-regalloc \
// RUN:   --remark-policy=all --remark-format=yaml --remarks-output-file=%t.yaml %s | FileCheck %s
// RUN: FileCheck %s --input-file=%t.yaml --check-prefix=REMARK
// RUN: wave-opt --waveamd-reg-alloc --waveamd-resource-info %s \
// RUN:   | env WAVE_PIPELINES_DIR=%S/../Target/Wave/Inputs/emit-only-pipeline wave-translate --wave-to-amdgpu-asm - \
// RUN:   | FileCheck %s --check-prefix=ASM
// RUN: wave-opt --waveamd-reg-alloc --waveamd-resource-info %s \
// RUN:   | env WAVE_PIPELINES_DIR=%S/../Target/Wave/Inputs/emit-only-pipeline wave-translate --wave-to-amdgpu-asm - \
// RUN:   | llvm-mc -triple=amdgcn-amd-amdhsa -mcpu=gfx950 -filetype=obj -o /dev/null

module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx950"} {

// CHECK-LABEL: func.func @regalloc_debug_scaffold
// CHECK: !waveamdmachine.reg<vgpr, 4, {{[0-9]+}}>
// CHECK-NOT: regalloc_debug
// REMARK: Name:            regalloc-summary
// REMARK: Function:        regalloc_debug_scaffold
// REMARK: peak_vgpr:       '4'
// REMARK: tracked_values:  '4'
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
