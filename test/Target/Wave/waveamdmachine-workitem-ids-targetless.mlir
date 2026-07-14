// RUN: wave-opt --waveamd-to-machine %s | FileCheck %s

// CHECK-LABEL: func.func @targetless_workitem_z
// CHECK: [[RAW:%.*]] = waveamdmachine.v_workitem_id_x {waveamdmachine.workitem_id_axis = 2 : i64} : !waveamdmachine.reg<vgpr, 1, 0>
// CHECK: [[OFFSET:%.*]] = waveamdmachine.imm 20
// CHECK: [[WIDTH:%.*]] = waveamdmachine.imm 10
// CHECK: waveamdmachine.v_bfe_u32 [[RAW]], [[OFFSET]], [[WIDTH]]
module {
func.func @targetless_workitem_z() attributes {wave.kernel} {
  %z = wave.workitem_id 2 : !wave.simd<i32, 32>
  return
}
}
