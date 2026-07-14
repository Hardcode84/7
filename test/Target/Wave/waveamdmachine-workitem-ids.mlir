// RUN: wave-opt --split-input-file --waveamd-to-machine %s \
// RUN:   | FileCheck %s --check-prefix=SELECT
// RUN: wave-opt --split-input-file %s --pass-pipeline='builtin.module(waveamd-to-machine,waveamd-abi-lowering,transform-preload-library{transform-library-paths=%wave_pipelines},transform-interpreter{entry-point=waveamd_regalloc_transform_loop},waveamd-resource-info)' \
// RUN:   | FileCheck %s --check-prefix=REGALLOC

// SELECT-LABEL: func.func @packed_workitem_ids
// SELECT: [[RAW_X:%.*]] = waveamdmachine.v_workitem_id_x {waveamdmachine.workitem_id_axis = 0 : i64} : !waveamdmachine.reg<vgpr, 1, 0>
// SELECT: [[MASK:%.*]] = waveamdmachine.imm 1023
// SELECT: waveamdmachine.v_and_b32 [[RAW_X]], [[MASK]]
// SELECT: [[RAW_Y:%.*]] = waveamdmachine.v_workitem_id_x {waveamdmachine.workitem_id_axis = 1 : i64} : !waveamdmachine.reg<vgpr, 1, 0>
// SELECT: [[Y_OFFSET:%.*]] = waveamdmachine.imm 10
// SELECT: [[WIDTH:%.*]] = waveamdmachine.imm 10
// SELECT: waveamdmachine.v_bfe_u32 [[RAW_Y]], [[Y_OFFSET]], [[WIDTH]]
// SELECT: [[RAW_Z:%.*]] = waveamdmachine.v_workitem_id_x {waveamdmachine.workitem_id_axis = 2 : i64} : !waveamdmachine.reg<vgpr, 1, 0>
// SELECT: [[Z_OFFSET:%.*]] = waveamdmachine.imm 20
// SELECT: [[Z_WIDTH:%.*]] = waveamdmachine.imm 10
// SELECT: waveamdmachine.v_bfe_u32 [[RAW_Z]], [[Z_OFFSET]], [[Z_WIDTH]]
// REGALLOC-LABEL: func.func @packed_workitem_ids
// REGALLOC-SAME: waveamdmachine.vgpr_count = 2 : i64
// REGALLOC: waveamdmachine.v_workitem_id_x {waveamdmachine.workitem_id_axis = 2 : i64} : !waveamdmachine.reg<vgpr, 1, 0>
// REGALLOC: waveamdmachine.v_bfe_u32
// REGALLOC-SAME: -> !waveamdmachine.reg<vgpr, 1,
module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx950"} {
func.func @packed_workitem_ids() attributes {wave.kernel} {
  %x = wave.workitem_id 0 : !wave.simd<i32, 64>
  %y = wave.workitem_id 1 : !wave.simd<i32, 64>
  %z = wave.workitem_id 2 : !wave.simd<i32, 64>
  return
}
}

// -----

// SELECT-LABEL: func.func @unpacked_workitem_ids
// SELECT: waveamdmachine.v_workitem_id_x : !waveamdmachine.reg<vgpr, 1, 0>
// SELECT: waveamdmachine.v_workitem_id_y : !waveamdmachine.reg<vgpr, 1, 1>
// SELECT: waveamdmachine.v_workitem_id_z : !waveamdmachine.reg<vgpr, 1, 2>
// SELECT-NOT: waveamdmachine.v_bfe_u32
// REGALLOC-LABEL: func.func @unpacked_workitem_ids
// REGALLOC-SAME: waveamdmachine.vgpr_count = 3 : i64
// REGALLOC: waveamdmachine.v_workitem_id_x : !waveamdmachine.reg<vgpr, 1, 0>
// REGALLOC: waveamdmachine.v_workitem_id_y : !waveamdmachine.reg<vgpr, 1, 1>
// REGALLOC: waveamdmachine.v_workitem_id_z : !waveamdmachine.reg<vgpr, 1, 2>
module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx908"} {
func.func @unpacked_workitem_ids() attributes {wave.kernel} {
  %x = wave.workitem_id 0 : !wave.simd<i32, 64>
  %y = wave.workitem_id 1 : !wave.simd<i32, 64>
  %z = wave.workitem_id 2 : !wave.simd<i32, 64>
  return
}
}
