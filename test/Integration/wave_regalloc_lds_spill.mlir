// RUN: wave-opt --waveamd-reg-alloc='vgpr-limit=4 agpr-limit=0' --waveamd-resource-info %s | FileCheck %s

module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx950"} {

// CHECK-LABEL: func.func @regalloc_lds_spill
// CHECK-SAME: waveamdmachine.lds_size = 768 : i64
// CHECK-SAME: waveamdmachine.lds_spill_bytes = 768 : i64
// CHECK: waveamdmachine.ds_store_b32
// CHECK: waveamdmachine.ds_load_b32
func.func @regalloc_lds_spill()
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
  %sum0 = waveamdmachine.v_add_u32 %b, %c
      : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>)
        -> !waveamdmachine.reg<vgpr, 1>
  %sum1 = waveamdmachine.v_add_u32 %sum0, %d
      : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>)
        -> !waveamdmachine.reg<vgpr, 1>
  %use = waveamdmachine.v_add_u32 %a, %sum1
      : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>)
        -> !waveamdmachine.reg<vgpr, 1>
  %token = waveamdmachine.global_store_b32 %off, %use, %base
      : (!waveamdmachine.reg<vgpr, 1, 0>, !waveamdmachine.reg<vgpr, 1>,
         !waveamdmachine.reg<sgpr, 2>) -> !waveamdmachine.mem.token
  waveamdmachine.s_endpgm
  return
}

}
