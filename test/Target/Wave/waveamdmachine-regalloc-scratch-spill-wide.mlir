// RUN: wave-opt --waveamd-reg-alloc='vgpr-limit=8 agpr-limit=0' --waveamd-resource-info %s | FileCheck %s

module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx1100"} {

// CHECK-LABEL: func.func @scratch_spill_wide_tuple_codegen
// CHECK-SAME: waveamdmachine.private_segment_fixed_size = 16 : i64
// CHECK-SAME: waveamdmachine.scratch_spill_bytes = 16 : i64
// CHECK-SAME: waveamdmachine.uses_flat_scratch = true
// CHECK: %[[PARTS:.*]]:4 = waveamdmachine.tuple_to_elements {{.*}} {waveamdmachine.regalloc_debug_temp}
// CHECK: %[[STORE0:.*]] = waveamdmachine.scratch_store_b32 {{.*}}, %[[PARTS]]#0
// CHECK: %[[STORE1:.*]] = waveamdmachine.scratch_store_b32 {{.*}}, %[[PARTS]]#1, {{.*}} after %[[STORE0]] offset 4
// CHECK: %[[STORE2:.*]] = waveamdmachine.scratch_store_b32 {{.*}}, %[[PARTS]]#2, {{.*}} after %[[STORE1]] offset 8
// CHECK: %[[STORE3:.*]] = waveamdmachine.scratch_store_b32 {{.*}}, %[[PARTS]]#3, {{.*}} after %[[STORE2]] offset 12
// CHECK: %[[LOAD0:.*]], {{.*}} = waveamdmachine.scratch_load_b32 {{.*}} after %[[STORE3]]
// CHECK: %[[LOAD1:.*]], {{.*}} = waveamdmachine.scratch_load_b32 {{.*}} after %[[STORE3]] offset 4
// CHECK: %[[LOAD2:.*]], {{.*}} = waveamdmachine.scratch_load_b32 {{.*}} after %[[STORE3]] offset 8
// CHECK: %[[LOAD3:.*]], {{.*}} = waveamdmachine.scratch_load_b32 {{.*}} after %[[STORE3]] offset 12
// CHECK: waveamdmachine.tuple_from_elements %[[LOAD0]], %[[LOAD1]], %[[LOAD2]], %[[LOAD3]] {waveamdmachine.regalloc_debug_temp}
func.func @scratch_spill_wide_tuple_codegen()
    attributes {wave.kernel, waveamdmachine.target_waves = 4 : i64} {
  %zero = waveamdmachine.imm 0 : !waveamdmachine.imm
  %base = waveamdmachine.uninit : !waveamdmachine.reg<sgpr, 2>
  %off = waveamdmachine.v_workitem_id_x : !waveamdmachine.reg<vgpr, 1, 0>
  %wide = waveamdmachine.v_mov_b32_tuple %zero {registers = 4 : i64}
      : (!waveamdmachine.imm) -> !waveamdmachine.reg<vgpr, 4>
  %b = waveamdmachine.v_mov_b32_tuple %zero {registers = 1 : i64}
      : (!waveamdmachine.imm) -> !waveamdmachine.reg<vgpr, 1>
  %c = waveamdmachine.v_mov_b32_tuple %zero {registers = 1 : i64}
      : (!waveamdmachine.imm) -> !waveamdmachine.reg<vgpr, 1>
  %d = waveamdmachine.v_mov_b32_tuple %zero {registers = 1 : i64}
      : (!waveamdmachine.imm) -> !waveamdmachine.reg<vgpr, 1>
  %e = waveamdmachine.v_mov_b32_tuple %zero {registers = 1 : i64}
      : (!waveamdmachine.imm) -> !waveamdmachine.reg<vgpr, 1>
  %f = waveamdmachine.v_mov_b32_tuple %zero {registers = 1 : i64}
      : (!waveamdmachine.imm) -> !waveamdmachine.reg<vgpr, 1>
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
