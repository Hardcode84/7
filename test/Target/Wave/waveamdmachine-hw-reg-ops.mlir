// RUN: wave-opt --split-input-file %s | FileCheck %s

module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx1100"} {

// CHECK-LABEL: func.func @hardware_resource_ops
// CHECK: %[[ONE:.+]] = waveamdmachine.imm 1 : !waveamdmachine.imm
// CHECK: %[[ZERO:.+]] = waveamdmachine.imm 0 : !waveamdmachine.imm
// CHECK: %[[SCC:.+]] = waveamdmachine.s_cmp_lt_i32
// CHECK: %[[SEL:.+]] = waveamdmachine.s_cselect_b32 %[[SCC]], %[[ONE]], %[[ZERO]] : (!waveamdmachine.reg<scc, 1>, !waveamdmachine.imm, !waveamdmachine.imm) -> !waveamdmachine.reg<sgpr, 1>
// CHECK: %[[SUM:.+]], %[[VCC:.+]] = waveamdmachine.v_add_u64
// CHECK: %[[SAVED:.+]] = waveamdmachine.s_read_vcc_b32 %[[VCC]] : (!waveamdmachine.reg<vcc, 1>) -> !waveamdmachine.reg<sgpr, 1>
// CHECK: %[[RESTORED:.+]] = waveamdmachine.s_mov_vcc_b32 %[[SAVED]] : (!waveamdmachine.reg<sgpr, 1>) -> !waveamdmachine.reg<vcc, 1>
// CHECK: return %[[SEL]], %[[RESTORED]]
func.func @hardware_resource_ops(%a: !waveamdmachine.reg<sgpr, 1>,
                                 %b: !waveamdmachine.reg<sgpr, 1>,
                                 %x: !waveamdmachine.reg<vgpr, 2>,
                                 %y: !waveamdmachine.reg<vgpr, 2>)
    -> (!waveamdmachine.reg<sgpr, 1>, !waveamdmachine.reg<vcc, 1>) {
  %one = waveamdmachine.imm 1 : !waveamdmachine.imm
  %zero = waveamdmachine.imm 0 : !waveamdmachine.imm
  %scc = waveamdmachine.s_cmp_lt_i32 %a, %b
      : (!waveamdmachine.reg<sgpr, 1>, !waveamdmachine.reg<sgpr, 1>)
        -> !waveamdmachine.reg<scc, 1>
  %sel = waveamdmachine.s_cselect_b32 %scc, %one, %zero
      : (!waveamdmachine.reg<scc, 1>, !waveamdmachine.imm,
         !waveamdmachine.imm) -> !waveamdmachine.reg<sgpr, 1>
  %sum, %vcc = waveamdmachine.v_add_u64 %x, %y
      : (!waveamdmachine.reg<vgpr, 2>, !waveamdmachine.reg<vgpr, 2>)
        -> (!waveamdmachine.reg<vgpr, 2>, !waveamdmachine.reg<vcc, 1>)
  %saved = waveamdmachine.s_read_vcc_b32 %vcc
      : (!waveamdmachine.reg<vcc, 1>) -> !waveamdmachine.reg<sgpr, 1>
  %restored = waveamdmachine.s_mov_vcc_b32 %saved
      : (!waveamdmachine.reg<sgpr, 1>) -> !waveamdmachine.reg<vcc, 1>
  return %sel, %restored
      : !waveamdmachine.reg<sgpr, 1>, !waveamdmachine.reg<vcc, 1>
}

}
