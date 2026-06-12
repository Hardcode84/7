// RUN: wave-opt --waveamd-resource-info %s | FileCheck %s

module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx950"} {

// CHECK-LABEL: func.func @scratch_resource_info
// CHECK-SAME: waveamdmachine.private_segment_fixed_size = 24 : i64
// CHECK-SAME: waveamdmachine.scratch_spill_bytes = 8 : i64
func.func @scratch_resource_info() attributes {
    wave.kernel,
    wave.private_segment_fixed_size = 16 : i64,
    waveamdmachine.scratch_spill_bytes = 8 : i64
  } {
  %off = waveamdmachine.v_workitem_id_x
      : !waveamdmachine.reg<vgpr, 1, 0>
  waveamdmachine.s_endpgm
  return
}

}
