// RUN: wave-opt %s --pass-pipeline='builtin.module(transform-interpreter{entry-point=scratch_relief})' | FileCheck %s --check-prefix=DIRECT
// RUN: wave-opt %s --pass-pipeline='builtin.module(transform-preload-library{transform-library-paths=%wave_pipelines},transform-interpreter{entry-point=waveamd_regalloc_transform_loop})' | FileCheck %s --check-prefix=LOOP

module attributes {transform.with_named_sequence} {
  transform.named_sequence @match_func(
      %root: !transform.any_op {transform.readonly}) -> !transform.any_op {
    transform.match.operation_name %root ["func.func"] : !transform.any_op
    transform.yield %root : !transform.any_op
  }

  transform.named_sequence @scratch_relief(
      %root: !transform.any_op {transform.readonly}) {
    %func = transform.collect_matching @match_func in %root
        : (!transform.any_op) -> !transform.any_op
    %r0 = wave.transform.regalloc_build_alias_state from %func
        : (!transform.any_op) -> !transform.any_op
    %r1 = wave.transform.regalloc_linear_scan from %r0
        : (!transform.any_op) -> !transform.any_op
    %r2 = wave.transform.regalloc_agpr_relief from %r1
        : (!transform.any_op) -> !transform.any_op
    %r3 = wave.transform.regalloc_remat_relief from %r2
        : (!transform.any_op) -> !transform.any_op
    %r4 = wave.transform.regalloc_lds_relief from %r3
        : (!transform.any_op) -> !transform.any_op
    %r5 = wave.transform.regalloc_scratch_relief from %r4
        : (!transform.any_op) -> !transform.any_op
    transform.yield
  }

  module @payload_module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx950"} {
    // DIRECT-LABEL: func.func @scratch_relief_spills_after_lds_declines(
    // DIRECT-SAME: waveamdmachine.lds_size = 1048576 : i64
    // DIRECT-SAME: waveamdmachine.private_segment_fixed_size = 4 : i64
    // DIRECT-SAME: waveamdmachine.scratch_spill_bytes = 4 : i64
    // DIRECT-SAME: waveamdmachine.uses_flat_scratch = true
    // DIRECT-SAME: waveamdmachine.vgpr_spill_count = 1 : i64
    // DIRECT-NOT: waveamdmachine.regalloc_transform_state
    // DIRECT: [[SPILL:%.*]], [[SPILLTOK:%.*]] = waveamdmachine.global_load_b32
    // DIRECT: [[SADDR:%.*]] = waveamdmachine.s_mov_b32_value
    // DIRECT: [[STORE:%.*]] = waveamdmachine.scratch_store_b32 {{.*}}, [[SPILL]], [[SADDR]] after [[SPILLTOK]]
    // DIRECT: [[RELOAD:%.*]], {{%.*}} = waveamdmachine.scratch_load_b32 {{.*}} after [[STORE]]
    // DIRECT: waveamdmachine.v_add_u32 [[RELOAD]],
    func.func @scratch_relief_spills_after_lds_declines()
        attributes {wave.kernel, wave.workgroup_size = array<i32: 64, 1, 1>,
                    waveamdmachine.lds_size = 1048576 : i64,
                    waveamdmachine.vgpr_count_max = 3 : i64,
                    waveamdmachine.agpr_count_max = 0 : i64} {
      %base = waveamdmachine.uninit : !waveamdmachine.reg<sgpr, 2>
      %off = waveamdmachine.v_workitem_id_x : !waveamdmachine.reg<vgpr, 1, 0>
      %tok0 = waveamdmachine.token : !waveamdmachine.mem.token
      %spill, %tok1 = waveamdmachine.global_load_b32 %off, %base after %tok0
          : (!waveamdmachine.reg<vgpr, 1, 0>, !waveamdmachine.reg<sgpr, 2>,
             !waveamdmachine.mem.token)
            -> (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.mem.token)
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
      %use = waveamdmachine.v_add_u32 %spill, %sum
          : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>)
            -> !waveamdmachine.reg<vgpr, 1>
      waveamdmachine.s_endpgm
      return
    }

    // DIRECT-LABEL: func.func @scratch_relief_existing_machine_private(
    // DIRECT-SAME: waveamdmachine.private_segment_fixed_size = 24 : i64
    // DIRECT-SAME: waveamdmachine.scratch_spill_bytes = 8 : i64
    // DIRECT: waveamdmachine.scratch_store_tuple_b32 {{.*}} offset 16
    // DIRECT: waveamdmachine.scratch_load_tuple_b32 {{.*}} offset 16
    func.func @scratch_relief_existing_machine_private()
        attributes {wave.kernel, wave.workgroup_size = array<i32: 64, 1, 1>,
                    waveamdmachine.lds_size = 1048576 : i64,
                    waveamdmachine.private_segment_fixed_size = 16 : i64,
                    waveamdmachine.vgpr_count_max = 4 : i64,
                    waveamdmachine.agpr_count_max = 0 : i64} {
      %base = waveamdmachine.uninit : !waveamdmachine.reg<sgpr, 2>
      %off = waveamdmachine.v_workitem_id_x : !waveamdmachine.reg<vgpr, 1, 0>
      %tok0 = waveamdmachine.token : !waveamdmachine.mem.token
      %spill, %tok1 = waveamdmachine.global_load_tuple_b32 %off, %base after %tok0
          : (!waveamdmachine.reg<vgpr, 1, 0>, !waveamdmachine.reg<sgpr, 2>,
             !waveamdmachine.mem.token)
            -> (!waveamdmachine.reg<vgpr, 2>, !waveamdmachine.mem.token)
      %a = waveamdmachine.uninit : !waveamdmachine.reg<vgpr, 1>
      %b = waveamdmachine.uninit : !waveamdmachine.reg<vgpr, 1>
      %sum = waveamdmachine.v_or_b32 %a, %b
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

    // LOOP-LABEL: func.func @scratch_relief_loop_restarts_to_success(
    // LOOP-SAME: waveamdmachine.regalloc_assignments
    // LOOP-SAME: waveamdmachine.regalloc_transform_state =
    // LOOP-SAME: stage = "linear-scan-success"
    // LOOP-SAME: waveamdmachine.scratch_spill_bytes = 4 : i64
    // LOOP: waveamdmachine.scratch_store_b32
    // LOOP: waveamdmachine.scratch_load_b32
    func.func @scratch_relief_loop_restarts_to_success()
        attributes {wave.kernel, wave.workgroup_size = array<i32: 64, 1, 1>,
                    waveamdmachine.lds_size = 1048576 : i64,
                    waveamdmachine.vgpr_count_max = 3 : i64,
                    waveamdmachine.agpr_count_max = 0 : i64} {
      %base = waveamdmachine.uninit : !waveamdmachine.reg<sgpr, 2>
      %off = waveamdmachine.v_workitem_id_x : !waveamdmachine.reg<vgpr, 1, 0>
      %tok0 = waveamdmachine.token : !waveamdmachine.mem.token
      %spill, %tok1 = waveamdmachine.global_load_b32 %off, %base after %tok0
          : (!waveamdmachine.reg<vgpr, 1, 0>, !waveamdmachine.reg<sgpr, 2>,
             !waveamdmachine.mem.token)
            -> (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.mem.token)
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
      %use = waveamdmachine.v_add_u32 %spill, %sum
          : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>)
            -> !waveamdmachine.reg<vgpr, 1>
      waveamdmachine.s_endpgm
      return
    }
  }
}
