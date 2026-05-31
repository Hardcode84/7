// RUN: wave-opt --waveamd-to-machine %s | FileCheck %s --check-prefix=SELECT
// RUN: wave-opt --waveamd-to-machine %s | wave-opt | FileCheck %s --check-prefix=SELECT
// RUN: wave-opt --waveamd-to-machine --waveamd-abi-lowering --waveamd-insert-ticket-waits --waveamd-reg-alloc --waveamd-insert-hazard-waits %s | FileCheck %s --check-prefix=REGALLOC
// RUN: wave-translate --wave-to-amdgpu-asm %s | FileCheck %s --check-prefix=ASM
// RUN: wave-translate --wave-to-amdgpu-asm %s | llvm-mc -triple=amdgcn-amd-amdhsa -mcpu=gfx1100 -filetype=obj -o /dev/null

module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx1100"} {

// Each lane stores `workitem_id_x + workgroup_id_x` to its own slot.
// SELECT-LABEL: func.func @multi_wave_kernel
// SELECT: waveamdmachine.s_workgroup_id_x : !waveamdmachine.reg<sgpr, 1, 2>
// SELECT: waveamdmachine.v_workitem_id_x : !waveamdmachine.reg<vgpr, 1, 0>
// SELECT: waveamdmachine.v_add_u32

// REGALLOC-LABEL: func.func @multi_wave_kernel
// REGALLOC: waveamdmachine.s_workgroup_id_x : !waveamdmachine.reg<sgpr, 1, 2>
// REGALLOC: waveamdmachine.v_workitem_id_x : !waveamdmachine.reg<vgpr, 1, 0>

// The preloaded workgroup_id/workitem_id values must not emit any
// instruction themselves; the workgroup_id flag in the descriptor is
// what tells the loader to populate s2.
// ASM-LABEL: multi_wave_kernel:
// ASM-NOT: s_workgroup_id_x
// ASM-NOT: v_workitem_id_x
// ASM: s_load_b64 [[OUT:s\[[0-9]+:[0-9]+\]]], s[0:1], 0x0
// ASM: v_add_nc_u32_e32 {{v[0-9]+}}, s2, v0
// ASM: v_lshlrev_b32_e32 [[ADDR:v[0-9]+]], 2, v0
// ASM: global_store_b32 [[ADDR]], {{v[0-9]+}}, [[OUT]]
// ASM: s_endpgm
// ASM:   .amdhsa_system_sgpr_workgroup_id_x 1
// ASM:   .amdhsa_system_sgpr_workgroup_id_y 0
// ASM:   .amdhsa_system_sgpr_workgroup_id_z 0
func.func @multi_wave_kernel(%out: !wave.ptr<i32, #wave.global>) attributes {wave.kernel} {
  %wg = wave.workgroup_id 0
  %vwg = wave.splat %wg : i32 -> !wave.simd<i32, 32>
  %wi_raw = wave.workitem_id 0 : !wave.simd<i32, 32>
  %wi = wave.assume_range %wi_raw, [0, 31] : !wave.simd<i32, 32>
  %sum = wave.addi %wi, %vwg : !wave.simd<i32, 32>, !wave.simd<i32, 32> -> !wave.simd<i32, 32>
  %ptrs = wave.ptr_add %out, %wi : !wave.ptr<i32, #wave.global>, !wave.simd<i32, 32> -> !wave.simd<!wave.ptr<i32, #wave.global>, 32>
  %tok = wave.store %sum -> %ptrs : (!wave.simd<i32, 32>, !wave.simd<!wave.ptr<i32, #wave.global>, 32>) -> !wave.mem.token
  return
}

// A kernel that also reads workgroup_id along y must flip the matching
// descriptor bit so the HSA loader preloads s3.
// ASM-LABEL: multi_axis_kernel:
// ASM:   .amdhsa_system_sgpr_workgroup_id_x 1
// ASM:   .amdhsa_system_sgpr_workgroup_id_y 1
// ASM:   .amdhsa_system_sgpr_workgroup_id_z 0
func.func @multi_axis_kernel(%out: !wave.ptr<i32, #wave.global>) attributes {wave.kernel} {
  %wg_y = wave.workgroup_id 1
  %vwg_y = wave.splat %wg_y : i32 -> !wave.simd<i32, 32>
  %lane = wave.lane_id : !wave.simd<i32, 32>
  %sum = wave.addi %lane, %vwg_y : !wave.simd<i32, 32>, !wave.simd<i32, 32> -> !wave.simd<i32, 32>
  %ptrs = wave.ptr_add %out, %lane : !wave.ptr<i32, #wave.global>, !wave.simd<i32, 32> -> !wave.simd<!wave.ptr<i32, #wave.global>, 32>
  %tok = wave.store %sum -> %ptrs : (!wave.simd<i32, 32>, !wave.simd<!wave.ptr<i32, #wave.global>, 32>) -> !wave.mem.token
  return
}

}
