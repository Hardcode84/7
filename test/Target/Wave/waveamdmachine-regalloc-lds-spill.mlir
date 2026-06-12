// RUN: wave-opt --waveamd-reg-alloc='vgpr-limit=4 agpr-limit=0' --waveamd-resource-info %s | FileCheck %s
// RUN: wave-opt --waveamd-reg-alloc='vgpr-limit=4 agpr-limit=0' --waveamd-resource-info --waveamd-insert-ticket-waits %s | FileCheck %s --check-prefix=WAIT

module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx950"} {

// CHECK-LABEL: func.func @lds_spill_codegen
// CHECK-SAME: waveamdmachine.agpr_count = 0 : i64
// CHECK-SAME: waveamdmachine.lds_size = 768 : i64
// CHECK-SAME: waveamdmachine.lds_spill_bytes = 768 : i64
// CHECK-SAME: waveamdmachine.vgpr_count = 4 : i64
// CHECK: %[[LANE:.+]] = waveamdmachine.v_workitem_id_x
// CHECK: %[[ADDR0:.+]] = waveamdmachine.v_lshlrev_b32 %[[LANE]]
// CHECK: %[[STORE0:.+]] = waveamdmachine.ds_store_b32 %[[ADDR0]],
// CHECK: %[[ADDR1:.+]] = waveamdmachine.v_lshlrev_b32 %[[LANE]]
// CHECK: %[[STORE1:.+]] = waveamdmachine.ds_store_b32 %[[ADDR1]], {{.*}} offset 512
// CHECK: %[[ADDR2:.+]] = waveamdmachine.v_lshlrev_b32 %[[LANE]]
// CHECK: %[[STORE2:.+]] = waveamdmachine.ds_store_b32 %[[ADDR2]], {{.*}} offset 256
// CHECK: waveamdmachine.ds_load_b32 {{.*}} after %[[STORE1]] offset 512
// CHECK: waveamdmachine.ds_load_b32 {{.*}} after %[[STORE2]] offset 256
// CHECK: waveamdmachine.ds_load_b32 {{.*}} after %[[STORE0]]

// WAIT-LABEL: func.func @lds_spill_codegen
// WAIT: waveamdmachine.ds_load_b32 {{.*}} after
// WAIT: waveamdmachine.s_waitcnt lgkmcnt({{[0-9]+}})
// WAIT: waveamdmachine.s_waitcnt_vscnt vscnt(0)
func.func @lds_spill_codegen()
    attributes {wave.kernel, wave.workgroup_size = array<i32: 64, 1, 1>,
                waveamdmachine.target_waves = 4 : i64} {
  %zero = waveamdmachine.imm 0 : !waveamdmachine.imm
  %base = waveamdmachine.uninit : !waveamdmachine.reg<sgpr, 2>
  %off = waveamdmachine.v_workitem_id_x : !waveamdmachine.reg<vgpr, 1, 0>
  %a = waveamdmachine.v_mov_b32_tuple %zero {registers = 1 : i64}
      : (!waveamdmachine.imm) -> !waveamdmachine.reg<vgpr, 1>
  %b = waveamdmachine.v_mov_b32_tuple %zero {registers = 1 : i64}
      : (!waveamdmachine.imm) -> !waveamdmachine.reg<vgpr, 1>
  %c = waveamdmachine.v_mov_b32_tuple %zero {registers = 1 : i64}
      : (!waveamdmachine.imm) -> !waveamdmachine.reg<vgpr, 1>
  %d = waveamdmachine.v_mov_b32_tuple %zero {registers = 1 : i64}
      : (!waveamdmachine.imm) -> !waveamdmachine.reg<vgpr, 1>
  %kill0 = waveamdmachine.v_add_u32 %b, %c
      : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>)
        -> !waveamdmachine.reg<vgpr, 1>
  %kill1 = waveamdmachine.v_add_u32 %kill0, %d
      : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>)
        -> !waveamdmachine.reg<vgpr, 1>
  %use = waveamdmachine.v_add_u32 %a, %kill1
      : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>)
        -> !waveamdmachine.reg<vgpr, 1>
  %token = waveamdmachine.global_store_b32 %off, %use, %base
      : (!waveamdmachine.reg<vgpr, 1, 0>, !waveamdmachine.reg<vgpr, 1>,
         !waveamdmachine.reg<sgpr, 2>) -> !waveamdmachine.mem.token
  waveamdmachine.s_endpgm
  return
}

// CHECK-LABEL: func.func @many_lds_spills
// CHECK-SAME: waveamdmachine.lds_size = 2304 : i64
// CHECK-SAME: waveamdmachine.lds_spill_bytes = 2304 : i64
// CHECK-SAME: waveamdmachine.vgpr_count = 4 : i64
// CHECK: waveamdmachine.ds_store_b32
// CHECK: offset 2048
// CHECK: waveamdmachine.ds_load_b32
func.func @many_lds_spills()
    attributes {wave.kernel, wave.workgroup_size = array<i32: 64, 1, 1>,
                waveamdmachine.target_waves = 4 : i64} {
  %zero = waveamdmachine.imm 0 : !waveamdmachine.imm
  %base = waveamdmachine.uninit : !waveamdmachine.reg<sgpr, 2>
  %off = waveamdmachine.v_workitem_id_x : !waveamdmachine.reg<vgpr, 1, 0>
  %v0 = waveamdmachine.v_mov_b32_tuple %zero {registers = 1 : i64}
      : (!waveamdmachine.imm) -> !waveamdmachine.reg<vgpr, 1>
  %v1 = waveamdmachine.v_mov_b32_tuple %zero {registers = 1 : i64}
      : (!waveamdmachine.imm) -> !waveamdmachine.reg<vgpr, 1>
  %v2 = waveamdmachine.v_mov_b32_tuple %zero {registers = 1 : i64}
      : (!waveamdmachine.imm) -> !waveamdmachine.reg<vgpr, 1>
  %v3 = waveamdmachine.v_mov_b32_tuple %zero {registers = 1 : i64}
      : (!waveamdmachine.imm) -> !waveamdmachine.reg<vgpr, 1>
  %v4 = waveamdmachine.v_mov_b32_tuple %zero {registers = 1 : i64}
      : (!waveamdmachine.imm) -> !waveamdmachine.reg<vgpr, 1>
  %v5 = waveamdmachine.v_mov_b32_tuple %zero {registers = 1 : i64}
      : (!waveamdmachine.imm) -> !waveamdmachine.reg<vgpr, 1>
  %v6 = waveamdmachine.v_mov_b32_tuple %zero {registers = 1 : i64}
      : (!waveamdmachine.imm) -> !waveamdmachine.reg<vgpr, 1>
  %v7 = waveamdmachine.v_mov_b32_tuple %zero {registers = 1 : i64}
      : (!waveamdmachine.imm) -> !waveamdmachine.reg<vgpr, 1>
  %v8 = waveamdmachine.v_mov_b32_tuple %zero {registers = 1 : i64}
      : (!waveamdmachine.imm) -> !waveamdmachine.reg<vgpr, 1>
  %v9 = waveamdmachine.v_mov_b32_tuple %zero {registers = 1 : i64}
      : (!waveamdmachine.imm) -> !waveamdmachine.reg<vgpr, 1>
  %s0 = waveamdmachine.v_add_u32 %v0, %v1
      : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>)
        -> !waveamdmachine.reg<vgpr, 1>
  %s1 = waveamdmachine.v_add_u32 %s0, %v2
      : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>)
        -> !waveamdmachine.reg<vgpr, 1>
  %s2 = waveamdmachine.v_add_u32 %s1, %v3
      : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>)
        -> !waveamdmachine.reg<vgpr, 1>
  %s3 = waveamdmachine.v_add_u32 %s2, %v4
      : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>)
        -> !waveamdmachine.reg<vgpr, 1>
  %s4 = waveamdmachine.v_add_u32 %s3, %v5
      : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>)
        -> !waveamdmachine.reg<vgpr, 1>
  %s5 = waveamdmachine.v_add_u32 %s4, %v6
      : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>)
        -> !waveamdmachine.reg<vgpr, 1>
  %s6 = waveamdmachine.v_add_u32 %s5, %v7
      : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>)
        -> !waveamdmachine.reg<vgpr, 1>
  %s7 = waveamdmachine.v_add_u32 %s6, %v8
      : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>)
        -> !waveamdmachine.reg<vgpr, 1>
  %s8 = waveamdmachine.v_add_u32 %s7, %v9
      : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>)
        -> !waveamdmachine.reg<vgpr, 1>
  %token = waveamdmachine.global_store_b32 %off, %s8, %base
      : (!waveamdmachine.reg<vgpr, 1, 0>, !waveamdmachine.reg<vgpr, 1>,
         !waveamdmachine.reg<sgpr, 2>) -> !waveamdmachine.mem.token
  waveamdmachine.s_endpgm
  return
}

}
