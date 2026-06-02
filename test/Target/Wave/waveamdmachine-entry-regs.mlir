// RUN: wave-opt --waveamd-to-machine %s | FileCheck %s
// RUN: wave-opt --waveamd-to-machine --waveamd-abi-lowering %s | FileCheck %s

module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx942"} {

// CHECK-LABEL: func.func @kernarg_preload_shifts_system_sgprs
// CHECK: waveamdmachine.s_workgroup_id_x : !waveamdmachine.reg<sgpr, 1, 4>
// CHECK: waveamdmachine.s_workgroup_id_y : !waveamdmachine.reg<sgpr, 1, 5>
// CHECK: waveamdmachine.v_workitem_id_x : !waveamdmachine.reg<vgpr, 1, 0>
func.func @kernarg_preload_shifts_system_sgprs()
    attributes {wave.kernel, waveamdmachine.kernarg_preload_length = 2 : i64} {
  %wg_x = wave.workgroup_id 0
  %wg_y = wave.workgroup_id 1
  %wi = wave.workitem_id 0 : !wave.simd<i32, 64>
  return
}

}
