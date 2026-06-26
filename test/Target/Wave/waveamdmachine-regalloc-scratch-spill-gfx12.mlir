// RUN: wave-opt --waveamd-reg-alloc='vgpr-limit=4 agpr-limit=0' --waveamd-resource-info %s | FileCheck %s

module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx1200"} {

// CHECK-LABEL: func.func @scratch_spill_gfx1200
// CHECK-SAME: waveamdmachine.private_segment_fixed_size = 8 : i64
// CHECK-SAME: waveamdmachine.scratch_spill_bytes = 8 : i64
// CHECK-SAME: waveamdmachine.uses_flat_scratch = true
// CHECK: %[[SADDR:.*]] = waveamdmachine.s_mov_b32_value
// CHECK: %[[STORE0:.*]] = waveamdmachine.scratch_store_b32 {{.*}}, {{.*}}, %[[SADDR]]
// CHECK: %[[STORE1:.*]] = waveamdmachine.scratch_store_b32 {{.*}}, {{.*}}, {{.*}} offset 4
// CHECK: waveamdmachine.scratch_load_b32 {{.*}} after %[[STORE1]] offset 4
// CHECK: waveamdmachine.scratch_load_b32 {{.*}} after %[[STORE0]]
func.func @scratch_spill_gfx1200()
    attributes {wave.kernel, waveamdmachine.target_waves = 4 : i64} {
  %zero = waveamdmachine.imm 0 : !waveamdmachine.imm
  %base = waveamdmachine.uninit : !waveamdmachine.reg<sgpr, 2>
  %off = waveamdmachine.v_workitem_id_x : !waveamdmachine.reg<vgpr, 1, 0>
  %a = waveamdmachine.uninit : !waveamdmachine.reg<vgpr, 1>
  %b = waveamdmachine.uninit : !waveamdmachine.reg<vgpr, 1>
  %c = waveamdmachine.uninit : !waveamdmachine.reg<vgpr, 1>
  %d = waveamdmachine.uninit : !waveamdmachine.reg<vgpr, 1>
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
