// RUN: wave-opt --waveamd-reg-alloc='vgpr-limit=8 agpr-limit=0' --waveamd-resource-info %s | FileCheck %s

module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx1100"} {

// CHECK-LABEL: func.func @scratch_spill_wide_tuple_codegen
// CHECK-SAME: waveamdmachine.private_segment_fixed_size = 36 : i64
// CHECK-SAME: waveamdmachine.scratch_spill_bytes = 36 : i64
// CHECK-SAME: waveamdmachine.uses_flat_scratch = true
// CHECK: waveamdmachine.scratch_store_tuple_b32
// CHECK: waveamdmachine.scratch_store_b32
// CHECK: waveamdmachine.scratch_load_b32
// CHECK: waveamdmachine.scratch_load_tuple_b32
// CHECK: waveamdmachine.tuple_to_elements
func.func @scratch_spill_wide_tuple_codegen()
    attributes {wave.kernel, waveamdmachine.target_waves = 4 : i64} {
  %zero = waveamdmachine.imm 0 : !waveamdmachine.imm
  %base = waveamdmachine.uninit : !waveamdmachine.reg<sgpr, 2>
  %off = waveamdmachine.v_workitem_id_x : !waveamdmachine.reg<vgpr, 1, 0>
  %wide = waveamdmachine.uninit : !waveamdmachine.reg<vgpr, 4>
  %b = waveamdmachine.uninit : !waveamdmachine.reg<vgpr, 1>
  %c = waveamdmachine.uninit : !waveamdmachine.reg<vgpr, 1>
  %d = waveamdmachine.uninit : !waveamdmachine.reg<vgpr, 1>
  %e = waveamdmachine.uninit : !waveamdmachine.reg<vgpr, 1>
  %f = waveamdmachine.uninit : !waveamdmachine.reg<vgpr, 1>
  %tmp0 = waveamdmachine.v_add_u32 %c, %d
      : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>)
        -> !waveamdmachine.reg<vgpr, 1>
  %tmp1 = waveamdmachine.v_add_u32 %e, %f
      : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>)
        -> !waveamdmachine.reg<vgpr, 1>
  %tmp = waveamdmachine.v_add_u32 %tmp0, %tmp1
      : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>)
        -> !waveamdmachine.reg<vgpr, 1>
  %tmp_token = waveamdmachine.global_store_b32 %off, %tmp, %base
      : (!waveamdmachine.reg<vgpr, 1, 0>, !waveamdmachine.reg<vgpr, 1>,
         !waveamdmachine.reg<sgpr, 2>) -> !waveamdmachine.mem.token
  %parts:4 = waveamdmachine.tuple_to_elements %wide
      : (!waveamdmachine.reg<vgpr, 4>)
        -> (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>,
            !waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>)
  %use = waveamdmachine.v_add_u32 %parts#0, %b
      : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>)
        -> !waveamdmachine.reg<vgpr, 1>
  %token = waveamdmachine.global_store_b32 %off, %use, %base after %tmp_token
      : (!waveamdmachine.reg<vgpr, 1, 0>, !waveamdmachine.reg<vgpr, 1>,
         !waveamdmachine.reg<sgpr, 2>, !waveamdmachine.mem.token)
        -> !waveamdmachine.mem.token
  waveamdmachine.s_endpgm
  return
}

// CHECK-LABEL: func.func @scratch_spill_prefers_scalar_when_wide_crosses_immediate_limit
// CHECK-SAME: waveamdmachine.private_segment_fixed_size = 4128 : i64
// CHECK-SAME: waveamdmachine.scratch_spill_bytes = 36 : i64
// CHECK-NOT: scratch_store_tuple_b32
// CHECK: waveamdmachine.scratch_store_b32 {{.*}} offset 4092
// CHECK: waveamdmachine.imm 4100
// CHECK: waveamdmachine.scratch_store_b32
// CHECK: waveamdmachine.imm 4104
// CHECK: waveamdmachine.scratch_store_b32
// CHECK: waveamdmachine.imm 4096
// CHECK: waveamdmachine.scratch_store_b32
// CHECK: waveamdmachine.imm 4108
// CHECK: waveamdmachine.scratch_store_b32
// CHECK: waveamdmachine.scratch_load_b32 {{.*}} offset 4092
func.func @scratch_spill_prefers_scalar_when_wide_crosses_immediate_limit()
    attributes {wave.kernel, waveamdmachine.target_waves = 4 : i64,
                waveamdmachine.private_segment_fixed_size = 4092 : i64} {
  %zero = waveamdmachine.imm 0 : !waveamdmachine.imm
  %base = waveamdmachine.uninit : !waveamdmachine.reg<sgpr, 2>
  %off = waveamdmachine.v_workitem_id_x : !waveamdmachine.reg<vgpr, 1, 0>
  %wide = waveamdmachine.uninit : !waveamdmachine.reg<vgpr, 4>
  %b = waveamdmachine.uninit : !waveamdmachine.reg<vgpr, 1>
  %c = waveamdmachine.uninit : !waveamdmachine.reg<vgpr, 1>
  %d = waveamdmachine.uninit : !waveamdmachine.reg<vgpr, 1>
  %e = waveamdmachine.uninit : !waveamdmachine.reg<vgpr, 1>
  %f = waveamdmachine.uninit : !waveamdmachine.reg<vgpr, 1>
  %tmp0 = waveamdmachine.v_add_u32 %c, %d
      : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>)
        -> !waveamdmachine.reg<vgpr, 1>
  %tmp1 = waveamdmachine.v_add_u32 %e, %f
      : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>)
        -> !waveamdmachine.reg<vgpr, 1>
  %tmp = waveamdmachine.v_add_u32 %tmp0, %tmp1
      : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>)
        -> !waveamdmachine.reg<vgpr, 1>
  %tmp_token = waveamdmachine.global_store_b32 %off, %tmp, %base
      : (!waveamdmachine.reg<vgpr, 1, 0>, !waveamdmachine.reg<vgpr, 1>,
         !waveamdmachine.reg<sgpr, 2>) -> !waveamdmachine.mem.token
  %parts:4 = waveamdmachine.tuple_to_elements %wide
      : (!waveamdmachine.reg<vgpr, 4>)
        -> (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>,
            !waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>)
  %use = waveamdmachine.v_add_u32 %parts#0, %b
      : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>)
        -> !waveamdmachine.reg<vgpr, 1>
  %token = waveamdmachine.global_store_b32 %off, %use, %base after %tmp_token
      : (!waveamdmachine.reg<vgpr, 1, 0>, !waveamdmachine.reg<vgpr, 1>,
         !waveamdmachine.reg<sgpr, 2>, !waveamdmachine.mem.token)
        -> !waveamdmachine.mem.token
  waveamdmachine.s_endpgm
  return
}

}
