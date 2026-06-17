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
