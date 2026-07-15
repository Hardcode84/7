// RUN: not wave-opt --waveamd-clear-regalloc-assignments --mlir-print-ir-after-failure %s 2>&1 | FileCheck %s

module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx1100"} {

func.func @reject_inconsistent_returns(%cond: i1)
    -> !waveamdmachine.reg<vgpr, 1, 7>
    attributes {waveamdmachine.regalloc_assignments} {
  cf.cond_br %cond, ^fixed, ^cleared
^fixed:
  %fixed = waveamdmachine.uninit : !waveamdmachine.reg<vgpr, 1, 7>
  return %fixed : !waveamdmachine.reg<vgpr, 1, 7>
^cleared:
  %zero = waveamdmachine.imm 0 : !waveamdmachine.imm
  %cleared = waveamdmachine.v_mov_b32_tuple %zero {registers = 1 : i64}
      : (!waveamdmachine.imm) -> !waveamdmachine.reg<vgpr, 1, 7>
  // CHECK: error: waveamd-clear-regalloc-assignments would make function returns inconsistent after clearing assignments
  return %cleared : !waveamdmachine.reg<vgpr, 1, 7>
}

}

// CHECK: IR Dump After WaveAMDClearRegAllocAssignments Failed
// CHECK: func.func @reject_inconsistent_returns({{.*}}) -> !waveamdmachine.reg<vgpr, 1, 7>
// CHECK-SAME: waveamdmachine.regalloc_assignments
// CHECK: waveamdmachine.v_mov_b32_tuple
// CHECK-SAME: -> !waveamdmachine.reg<vgpr, 1, 7>
