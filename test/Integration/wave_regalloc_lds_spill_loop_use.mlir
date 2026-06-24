// RUN: wave-opt --waveamd-reg-alloc='vgpr-limit=5 agpr-limit=0' \
// RUN:   --waveamd-resource-info %s | FileCheck %s

module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx950"} {

// CHECK-LABEL: func.func @regalloc_lds_spill_loop_use
// CHECK-SAME: waveamdmachine.lds_spill_bytes = {{[0-9]+}} : i64
// CHECK: waveamdmachine.uniform_loop
// CHECK: %[[STORE:.+]] = waveamdmachine.ds_store_b32
// CHECK: waveamdmachine.ds_load_b32 {{.*}} after %[[STORE]]
func.func @regalloc_lds_spill_loop_use()
    attributes {wave.kernel, wave.workgroup_size = array<i32: 64, 1, 1>,
                waveamdmachine.target_waves = 4 : i64} {
  %zero = waveamdmachine.imm 0 : !waveamdmachine.imm
  %one = waveamdmachine.imm 1 : !waveamdmachine.imm
  %base = waveamdmachine.uninit : !waveamdmachine.reg<sgpr, 2>
  %off = waveamdmachine.v_workitem_id_x : !waveamdmachine.reg<vgpr, 1, 0>
  %ec = waveamdmachine.s_cmp_lt_i32 %zero, %one
      : (!waveamdmachine.imm, !waveamdmachine.imm)
        -> !waveamdmachine.reg<scc, 1>
  waveamdmachine.uniform_loop if %ec : !waveamdmachine.reg<scc, 1> {
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
    waveamdmachine.continue_if %ec : !waveamdmachine.reg<scc, 1>
  }
  waveamdmachine.s_endpgm
  return
}

}
