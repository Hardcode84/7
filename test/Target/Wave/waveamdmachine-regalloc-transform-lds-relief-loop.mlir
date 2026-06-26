// RUN: wave-opt %s --pass-pipeline='builtin.module(transform-preload-library{transform-library-paths=%wave_pipelines},transform-interpreter{entry-point=waveamd_regalloc_transform_loop})' | FileCheck %s

module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx950"} {
  // CHECK-LABEL: func.func @regalloc_transform_loop_lds_spills_post_failure_use(
  // CHECK-SAME: waveamdmachine.lds_spill_bytes = 1024 : i64
  // CHECK-SAME: waveamdmachine.regalloc_assignments
  // CHECK-SAME: waveamdmachine.regalloc_transform_state =
  // CHECK-SAME: stage = "linear-scan-success"
  // CHECK: waveamdmachine.ds_store_b32
  // CHECK: waveamdmachine.ds_load_b32
  // CHECK: waveamdmachine.s_endpgm
  func.func @regalloc_transform_loop_lds_spills_post_failure_use()
      attributes {wave.kernel, wave.workgroup_size = array<i32: 64, 1, 1>,
                  waveamdmachine.vgpr_count_max = 4 : i64,
                  waveamdmachine.agpr_count_max = 0 : i64} {
    %base = waveamdmachine.uninit : !waveamdmachine.reg<sgpr, 2>
    %off = waveamdmachine.v_workitem_id_x : !waveamdmachine.reg<vgpr, 1, 0>
    %tok0 = waveamdmachine.token : !waveamdmachine.mem.token
    %spill, %tok1 = waveamdmachine.global_load_tuple_b32 %off, %base after %tok0
        : (!waveamdmachine.reg<vgpr, 1, 0>, !waveamdmachine.reg<sgpr, 2>,
           !waveamdmachine.mem.token)
          -> (!waveamdmachine.reg<vgpr, 2>, !waveamdmachine.mem.token)
    %a, %tok2 = waveamdmachine.global_load_b32 %off, %base after %tok1
        : (!waveamdmachine.reg<vgpr, 1, 0>, !waveamdmachine.reg<sgpr, 2>,
           !waveamdmachine.mem.token)
          -> (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.mem.token)
    %b, %tok3 = waveamdmachine.global_load_b32 %off, %base after %tok2
        : (!waveamdmachine.reg<vgpr, 1, 0>, !waveamdmachine.reg<sgpr, 2>,
           !waveamdmachine.mem.token)
          -> (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.mem.token)
    %sum = waveamdmachine.v_add_u32 %a, %b
        : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>)
          -> !waveamdmachine.reg<vgpr, 1>
    %parts:2 = waveamdmachine.tuple_to_elements %spill
        : (!waveamdmachine.reg<vgpr, 2>)
          -> (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>)
    %use0 = waveamdmachine.v_add_u32 %parts#0, %sum
        : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>)
          -> !waveamdmachine.reg<vgpr, 1>
    %use1 = waveamdmachine.v_add_u32 %use0, %parts#1
        : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>)
          -> !waveamdmachine.reg<vgpr, 1>
    waveamdmachine.s_endpgm
    return
  }
}
