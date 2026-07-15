// RUN: wave-opt %s --waveamd-clear-regalloc-transform-state | FileCheck %s

// CHECK-LABEL: func.func @clear_state(
// CHECK-SAME: !waveamdmachine.reg<vgpr, 1, 4>
// CHECK-SAME: attributes {waveamdmachine.regalloc_assignments}
// CHECK-NOT: waveamdmachine.regalloc_transform_state
func.func @clear_state(%arg0: !waveamdmachine.reg<vgpr, 1, 4>)
    attributes {
      waveamdmachine.regalloc_assignments,
      waveamdmachine.regalloc_transform_state = {
        packed = #wave.regalloc_state<
            version = 1,
            ops = [],
            op_paths = [],
            values = [],
            value_paths = [],
            value_ranges = [],
            alias_sets = [],
            alias_members = []>,
        stage = "linear-scan-success"
      }
    } {
  return
}
