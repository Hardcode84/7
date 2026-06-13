// RUN: wave-opt --waveamd-reg-alloc='vgpr-limit=4 agpr-limit=0' --waveamd-resource-info %s | FileCheck %s
// RUN: wave-opt --waveamd-reg-alloc='vgpr-limit=4 agpr-limit=0' --waveamd-resource-info --waveamd-insert-ticket-waits %s | FileCheck %s --check-prefix=WAIT

module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx1100"} {

// CHECK-LABEL: func.func @scratch_spill_codegen
// CHECK-SAME: waveamdmachine.agpr_count = 0 : i64
// CHECK-SAME: waveamdmachine.private_segment_fixed_size = 8 : i64
// CHECK-SAME: waveamdmachine.scratch_spill_bytes = 8 : i64
// CHECK-SAME: waveamdmachine.uses_flat_scratch = true
// CHECK-SAME: waveamdmachine.vgpr_count = 4 : i64
// CHECK: %[[SADDR:.+]] = waveamdmachine.s_mov_b32_value
// CHECK: %[[STORE0:.+]] = waveamdmachine.scratch_store_b32 {{.*}}, {{.*}}, %[[SADDR]]
// CHECK: %[[STORE1:.+]] = waveamdmachine.scratch_store_b32 {{.*}}, {{.*}}, {{.*}} offset 4
// CHECK: waveamdmachine.scratch_load_b32 {{.*}} after %[[STORE1]] offset 4
// CHECK: waveamdmachine.scratch_load_b32 {{.*}} after %[[STORE0]]

// WAIT-LABEL: func.func @scratch_spill_codegen
// WAIT: waveamdmachine.s_waitcnt_vscnt vscnt(0)
// WAIT: waveamdmachine.scratch_load_b32 {{.*}} after
// WAIT: waveamdmachine.s_waitcnt vmcnt({{[0-9]+}})
func.func @scratch_spill_codegen()
    attributes {wave.kernel, waveamdmachine.target_waves = 4 : i64} {
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

// CHECK-LABEL: func.func @scratch_spill_existing_machine_private
// CHECK-SAME: waveamdmachine.private_segment_fixed_size = 24 : i64
// CHECK-SAME: waveamdmachine.scratch_spill_bytes = 8 : i64
// CHECK: waveamdmachine.scratch_store_b32 {{.*}} offset 16
// CHECK: waveamdmachine.scratch_store_b32 {{.*}} offset 20
func.func @scratch_spill_existing_machine_private()
    attributes {wave.kernel, waveamdmachine.private_segment_fixed_size = 16 : i64,
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

}
