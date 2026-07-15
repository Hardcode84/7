// RUN: not wave-opt --waveamd-clear-regalloc-assignments --mlir-print-ir-after-failure %s 2>&1 | FileCheck %s

module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx1100"} {

func.func private @fixed_declaration() -> !waveamdmachine.reg<vgpr, 1, 7>

func.func @reject_declaration_call() -> !waveamdmachine.reg<vgpr, 1, 7>
    attributes {waveamdmachine.regalloc_assignments} {
  // CHECK: error: waveamd-clear-regalloc-assignments would make call to `fixed_declaration` type-inconsistent
  %value = func.call @fixed_declaration()
      : () -> !waveamdmachine.reg<vgpr, 1, 7>
  return %value : !waveamdmachine.reg<vgpr, 1, 7>
}

}

// CHECK: IR Dump After WaveAMDClearRegAllocAssignments Failed
// CHECK: func.func @reject_declaration_call() -> !waveamdmachine.reg<vgpr, 1, 7>
// CHECK-SAME: waveamdmachine.regalloc_assignments
// CHECK: call @fixed_declaration() : () -> !waveamdmachine.reg<vgpr, 1, 7>
