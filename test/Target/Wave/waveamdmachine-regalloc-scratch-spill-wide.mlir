// RUN: wave-opt --waveamd-reg-alloc='vgpr-limit=8 agpr-limit=0' --waveamd-resource-info %s | FileCheck %s

module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx1100"} {

// CHECK-LABEL: func.func @scratch_spill_wide_tuple_codegen
// CHECK-SAME: waveamdmachine.private_segment_fixed_size = 16 : i64
// CHECK-SAME: waveamdmachine.scratch_spill_bytes = 16 : i64
// CHECK-SAME: waveamdmachine.uses_flat_scratch = true
// CHECK: %[[STORE:.*]] = waveamdmachine.scratch_store_tuple_b32
// CHECK: %[[LOAD:.*]], {{.*}} = waveamdmachine.scratch_load_tuple_b32 {{.*}} after %[[STORE]]
// CHECK: waveamdmachine.tuple_to_elements %[[LOAD]]
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

// CHECK-LABEL: func.func @scratch_spill_wide_crosses_immediate_limit
// CHECK-SAME: waveamdmachine.private_segment_fixed_size = 4108 : i64
// CHECK-SAME: waveamdmachine.scratch_spill_bytes = 16 : i64
// CHECK: %[[PARTS:.*]]:4 = waveamdmachine.tuple_to_elements
// CHECK: %[[STORE0:.*]] = waveamdmachine.scratch_store_b32 {{.*}}, %[[PARTS]]#0, {{.*}} offset 4092
// CHECK: %[[IMM4096:.*]] = waveamdmachine.imm 4096
// CHECK: %[[SADDR4096:.*]] = waveamdmachine.s_mov_b32_value %[[IMM4096]]
// CHECK: %[[STORE1:.*]] = waveamdmachine.scratch_store_b32 {{.*}}, %[[PARTS]]#1, %[[SADDR4096]] :
// CHECK: %[[IMM4100:.*]] = waveamdmachine.imm 4100
// CHECK: %[[SADDR4100:.*]] = waveamdmachine.s_mov_b32_value %[[IMM4100]]
// CHECK: %[[STORE2:.*]] = waveamdmachine.scratch_store_b32 {{.*}}, %[[PARTS]]#2, %[[SADDR4100]] :
// CHECK: %[[IMM4104:.*]] = waveamdmachine.imm 4104
// CHECK: %[[SADDR4104:.*]] = waveamdmachine.s_mov_b32_value %[[IMM4104]]
// CHECK: %[[STORE3:.*]] = waveamdmachine.scratch_store_b32 {{.*}}, %[[PARTS]]#3, %[[SADDR4104]] :
// CHECK: %[[JOIN:.*]] = waveamdmachine.token_join %[[STORE0]], %[[STORE1]], %[[STORE2]], %[[STORE3]]
// CHECK: %[[LOAD0:.*]], %[[LTOK0:.*]] = waveamdmachine.scratch_load_b32 {{.*}} after %[[JOIN]] offset 4092
// CHECK: %[[LIMM4096:.*]] = waveamdmachine.imm 4096
// CHECK: %[[LSADDR4096:.*]] = waveamdmachine.s_mov_b32_value %[[LIMM4096]]
// CHECK: %[[LOAD1:.*]], %[[LTOK1:.*]] = waveamdmachine.scratch_load_b32 {{.*}}, %[[LSADDR4096]] after %[[JOIN]] :
// CHECK: %[[LIMM4100:.*]] = waveamdmachine.imm 4100
// CHECK: %[[LSADDR4100:.*]] = waveamdmachine.s_mov_b32_value %[[LIMM4100]]
// CHECK: %[[LOAD2:.*]], %[[LTOK2:.*]] = waveamdmachine.scratch_load_b32 {{.*}}, %[[LSADDR4100]] after %[[JOIN]] :
// CHECK: %[[LIMM4104:.*]] = waveamdmachine.imm 4104
// CHECK: %[[LSADDR4104:.*]] = waveamdmachine.s_mov_b32_value %[[LIMM4104]]
// CHECK: %[[LOAD3:.*]], %[[LTOK3:.*]] = waveamdmachine.scratch_load_b32 {{.*}}, %[[LSADDR4104]] after %[[JOIN]] :
// CHECK: waveamdmachine.tuple_from_elements %[[LOAD0]], %[[LOAD1]], %[[LOAD2]], %[[LOAD3]]
// CHECK: waveamdmachine.token_join %[[LTOK0]], %[[LTOK1]], %[[LTOK2]], %[[LTOK3]]
func.func @scratch_spill_wide_crosses_immediate_limit()
    attributes {wave.kernel, waveamdmachine.target_waves = 4 : i64,
                waveamdmachine.private_segment_fixed_size = 4092 : i64} {
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
