// RUN: wave-opt --waveamd-reg-alloc='vgpr-limit=4 agpr-limit=0' --waveamd-resource-info %s | FileCheck %s

module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx950"} {

// CHECK-LABEL: func.func @multi_wave_lds_spill
// CHECK-SAME: waveamdmachine.lds_spill_bytes = {{[0-9]+}} : i64
// CHECK: %[[WI:.+]] = waveamdmachine.v_workitem_id_x
// CHECK: %[[ADDR:.+]] = waveamdmachine.v_lshlrev_b32 %[[WI]]
// CHECK: %[[FULL:.+]] = waveamdmachine.v_add_u32 %[[ADDR]]
// CHECK: %[[STORE:.+]] = waveamdmachine.ds_store_b32 %[[FULL]]
// CHECK: waveamdmachine.ds_load_b32 {{.*}} after %[[STORE]]
func.func @multi_wave_lds_spill()
    attributes {wave.kernel, wave.workgroup_size = array<i32: 128, 1, 1>,
                wave.waves_per_workgroup = 2 : i64,
                wave.lds_size = 131072 : i64} {
  %zero = waveamdmachine.imm 0 : !waveamdmachine.imm
  %base = waveamdmachine.uninit : !waveamdmachine.reg<sgpr, 2>
  %off = waveamdmachine.v_workitem_id_x : !waveamdmachine.reg<vgpr, 1, 0>
  %a = waveamdmachine.v_mov_b32_tuple %zero
      {registers = 1 : i64, waveamdmachine.regalloc_debug_temp}
      : (!waveamdmachine.imm) -> !waveamdmachine.reg<vgpr, 1>
  %b = waveamdmachine.v_mov_b32_tuple %zero
      {registers = 1 : i64, waveamdmachine.regalloc_debug_temp}
      : (!waveamdmachine.imm) -> !waveamdmachine.reg<vgpr, 1>
  %c = waveamdmachine.v_mov_b32_tuple %zero
      {registers = 1 : i64, waveamdmachine.regalloc_debug_temp}
      : (!waveamdmachine.imm) -> !waveamdmachine.reg<vgpr, 1>
  %d = waveamdmachine.v_mov_b32_tuple %zero
      {registers = 1 : i64, waveamdmachine.regalloc_debug_temp}
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
