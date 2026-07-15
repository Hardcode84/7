// RUN: wave-opt --waveamd-clear-regalloc-assignments -split-input-file %s | FileCheck %s

module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx1100"} {

// CHECK-LABEL: func.func @clear_stale_assignments
// CHECK-NOT: waveamdmachine.regalloc_assignments
func.func @clear_stale_assignments()
    attributes {waveamdmachine.regalloc_assignments} {
  %zero = waveamdmachine.imm 0 : !waveamdmachine.imm
  // CHECK: [[VALUE:%.*]] = waveamdmachine.v_mov_b32_tuple
  // CHECK-SAME: -> !waveamdmachine.reg<vgpr, 1>
  %value = waveamdmachine.v_mov_b32_tuple %zero {registers = 1 : i64}
      : (!waveamdmachine.imm) -> !waveamdmachine.reg<vgpr, 1, 7>
  return
}

}

// -----

module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx1100"} {

// CHECK-LABEL: func.func @clear_transform_loop_state
// CHECK-NOT: waveamdmachine.regalloc_transform_state
func.func @clear_transform_loop_state()
    attributes {waveamdmachine.regalloc_transform_state = {stage = "linear-scan-success"}} {
  %zero = waveamdmachine.imm 0 : !waveamdmachine.imm
  // CHECK: [[VALUE:%.*]] = waveamdmachine.v_mov_b32_tuple
  // CHECK-SAME: -> !waveamdmachine.reg<vgpr, 1>
  %value = waveamdmachine.v_mov_b32_tuple %zero {registers = 1 : i64}
      : (!waveamdmachine.imm) -> !waveamdmachine.reg<vgpr, 1, 7>
  return
}

}

// -----

module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx1100"} {

// CHECK-LABEL: func.func @clear_lds_spill_state
// CHECK-SAME: waveamdmachine.lds_spill_bytes = 4 : i64
func.func @clear_lds_spill_state()
    attributes {waveamdmachine.lds_spill_bytes = 4 : i64} {
  %zero = waveamdmachine.imm 0 : !waveamdmachine.imm
  // CHECK: [[VALUE:%.*]] = waveamdmachine.v_mov_b32_tuple
  // CHECK-SAME: -> !waveamdmachine.reg<vgpr, 1>
  %value = waveamdmachine.v_mov_b32_tuple %zero {registers = 1 : i64}
      : (!waveamdmachine.imm) -> !waveamdmachine.reg<vgpr, 1, 7>
  return
}

}

// -----

module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx1100"} {

// CHECK-LABEL: func.func @clear_scratch_spill_state
// CHECK-SAME: waveamdmachine.scratch_spill_bytes = 4 : i64
func.func @clear_scratch_spill_state()
    attributes {waveamdmachine.scratch_spill_bytes = 4 : i64} {
  %zero = waveamdmachine.imm 0 : !waveamdmachine.imm
  // CHECK: [[VALUE:%.*]] = waveamdmachine.v_mov_b32_tuple
  // CHECK-SAME: -> !waveamdmachine.reg<vgpr, 1>
  %value = waveamdmachine.v_mov_b32_tuple %zero {registers = 1 : i64}
      : (!waveamdmachine.imm) -> !waveamdmachine.reg<vgpr, 1, 7>
  return
}

}

// -----

module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx1100"} {

// CHECK-LABEL: func.func @preserve_abi_entries
func.func @preserve_abi_entries()
    attributes {wave.kernel, waveamdmachine.kernarg_preload_length = 2 : i64} {
  // CHECK: [[WG:%.*]] = waveamdmachine.s_workgroup_id_x : !waveamdmachine.reg<sgpr, 1, 2>
  %wg = waveamdmachine.s_workgroup_id_x : !waveamdmachine.reg<sgpr, 1, 2>
  // CHECK: [[WI:%.*]] = waveamdmachine.v_workitem_id_x : !waveamdmachine.reg<vgpr, 1, 0>
  %wi = waveamdmachine.v_workitem_id_x : !waveamdmachine.reg<vgpr, 1, 0>
  // CHECK: [[ARG:%.*]] = waveamdmachine.kernarg_preload {{.*}} : !waveamdmachine.reg<sgpr, 2, 2>
  %arg = waveamdmachine.kernarg_preload {dword_offset = 0 : i64}
      : !waveamdmachine.reg<sgpr, 2, 2>
  // CHECK: [[PINNED:%.*]] = waveamdmachine.uninit : !waveamdmachine.reg<vgpr, 1, 5>
  %pinned = waveamdmachine.uninit : !waveamdmachine.reg<vgpr, 1, 5>
  return
}

}

// -----

module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx1100"} {

// CHECK-LABEL: func.func @preserve_marked_fixed_result
// CHECK-NOT: waveamdmachine.regalloc_fixed_results
func.func @preserve_marked_fixed_result()
    attributes {waveamdmachine.regalloc_assignments} {
  %zero = waveamdmachine.imm 0 : !waveamdmachine.imm
  // CHECK: [[PINNED:%.*]] = waveamdmachine.v_mov_b32_tuple
  // CHECK-SAME: -> !waveamdmachine.reg<vgpr, 1, 5>
  %pinned = waveamdmachine.v_mov_b32_tuple %zero
      {registers = 1 : i64, waveamdmachine.regalloc_fixed_results = array<i64: 0>}
      : (!waveamdmachine.imm) -> !waveamdmachine.reg<vgpr, 1, 5>
  return
}

}

// -----

module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx1100"} {

// CHECK-LABEL: func.func @clear_result_signature()
// CHECK-SAME: -> !waveamdmachine.reg<vgpr, 1>
func.func @clear_result_signature() -> !waveamdmachine.reg<vgpr, 1, 7>
    attributes {waveamdmachine.regalloc_assignments} {
  %zero = waveamdmachine.imm 0 : !waveamdmachine.imm
  // CHECK: [[VALUE:%.*]] = waveamdmachine.v_mov_b32_tuple
  // CHECK-SAME: -> !waveamdmachine.reg<vgpr, 1>
  %value = waveamdmachine.v_mov_b32_tuple %zero {registers = 1 : i64}
      : (!waveamdmachine.imm) -> !waveamdmachine.reg<vgpr, 1, 7>
  // CHECK: return [[VALUE]] : !waveamdmachine.reg<vgpr, 1>
  return %value : !waveamdmachine.reg<vgpr, 1, 7>
}

}

// -----

module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx1100"} {

// CHECK-LABEL: func.func @clear_consistent_returns(
// CHECK-SAME: %[[COND:.*]]: i1) -> !waveamdmachine.reg<vgpr, 1>
func.func @clear_consistent_returns(%cond: i1)
    -> !waveamdmachine.reg<vgpr, 1, 7>
    attributes {waveamdmachine.regalloc_assignments} {
  cf.cond_br %cond, ^left, ^right
^left:
  %left_zero = waveamdmachine.imm 0 : !waveamdmachine.imm
  %left = waveamdmachine.v_mov_b32_tuple %left_zero {registers = 1 : i64}
      : (!waveamdmachine.imm) -> !waveamdmachine.reg<vgpr, 1, 7>
  // CHECK: return {{.*}} : !waveamdmachine.reg<vgpr, 1>
  return %left : !waveamdmachine.reg<vgpr, 1, 7>
^right:
  %right_zero = waveamdmachine.imm 0 : !waveamdmachine.imm
  %right = waveamdmachine.v_mov_b32_tuple %right_zero {registers = 1 : i64}
      : (!waveamdmachine.imm) -> !waveamdmachine.reg<vgpr, 1, 7>
  // CHECK: return {{.*}} : !waveamdmachine.reg<vgpr, 1>
  return %right : !waveamdmachine.reg<vgpr, 1, 7>
}

}

// -----

module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx1100"} {

// CHECK-LABEL: func.func private @preserve_declaration(
// CHECK-SAME: !waveamdmachine.reg<vgpr, 1, 4>) -> !waveamdmachine.reg<vgpr, 1, 7>
// CHECK-NOT: waveamdmachine.regalloc_assignments
func.func private @preserve_declaration(!waveamdmachine.reg<vgpr, 1, 4>)
    -> !waveamdmachine.reg<vgpr, 1, 7>
    attributes {waveamdmachine.regalloc_assignments}

}

// -----

module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx1100"} {

// CHECK-LABEL: func.func @preserve_entry_signature(
// CHECK-SAME: !waveamdmachine.reg<vgpr, 1, 4>) -> !waveamdmachine.reg<vgpr, 1, 4>
func.func @preserve_entry_signature(%arg: !waveamdmachine.reg<vgpr, 1, 4>)
    -> !waveamdmachine.reg<vgpr, 1, 4>
    attributes {waveamdmachine.regalloc_assignments} {
  // CHECK: return {{.*}} : !waveamdmachine.reg<vgpr, 1, 4>
  return %arg : !waveamdmachine.reg<vgpr, 1, 4>
}

// CHECK-LABEL: func.func @preserve_fixed_result()
// CHECK-SAME: -> !waveamdmachine.reg<vgpr, 1, 5>
func.func @preserve_fixed_result() -> !waveamdmachine.reg<vgpr, 1, 5>
    attributes {waveamdmachine.regalloc_assignments} {
  %fixed = waveamdmachine.uninit : !waveamdmachine.reg<vgpr, 1, 5>
  // CHECK: return {{.*}} : !waveamdmachine.reg<vgpr, 1, 5>
  return %fixed : !waveamdmachine.reg<vgpr, 1, 5>
}

}

// -----

module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx1100"} {

// CHECK-LABEL: func.func private @clear_callee()
// CHECK-SAME: -> !waveamdmachine.reg<vgpr, 1>
func.func private @clear_callee() -> !waveamdmachine.reg<vgpr, 1, 7>
    attributes {waveamdmachine.regalloc_assignments} {
  %zero = waveamdmachine.imm 0 : !waveamdmachine.imm
  %value = waveamdmachine.v_mov_b32_tuple %zero {registers = 1 : i64}
      : (!waveamdmachine.imm) -> !waveamdmachine.reg<vgpr, 1, 7>
  return %value : !waveamdmachine.reg<vgpr, 1, 7>
}

// CHECK-LABEL: func.func @clear_direct_call()
// CHECK-SAME: -> !waveamdmachine.reg<vgpr, 1>
func.func @clear_direct_call() -> !waveamdmachine.reg<vgpr, 1, 7>
    attributes {waveamdmachine.regalloc_assignments} {
  // CHECK: [[CALL:%.*]] = call @clear_callee() : () -> !waveamdmachine.reg<vgpr, 1>
  %value = func.call @clear_callee()
      : () -> !waveamdmachine.reg<vgpr, 1, 7>
  // CHECK: return [[CALL]] : !waveamdmachine.reg<vgpr, 1>
  return %value : !waveamdmachine.reg<vgpr, 1, 7>
}

}
