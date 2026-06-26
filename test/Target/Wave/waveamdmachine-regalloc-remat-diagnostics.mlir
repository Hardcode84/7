// RUN: rm -f %t.yaml
// RUN: wave-opt --waveamd-reg-alloc='mark-overflow=true vgpr-limit=4 agpr-limit=0' \
// RUN:   --remarks-filter=waveamdmachine-regalloc --remark-policy=all \
// RUN:   --remark-format=yaml --remarks-output-file=%t.yaml %s >/dev/null
// RUN: FileCheck %s --input-file=%t.yaml --check-prefix=REMARK

// REMARK: Name:            regalloc-pressure-failure
// REMARK: Function:        remat_rejects_leaf_extension
// REMARK: remat_reject_reason: added_pressure_not_profitable
// REMARK: remat_root_op:   waveamdmachine.v_add_u32
// REMARK: remat_def_position: '3'
// REMARK: remat_failure_position: '9'
// REMARK: remat_rebuild_position: '14'
// REMARK: remat_first_post_cut_use: '14'
// REMARK: remat_relief_dwords: '1'
// REMARK: remat_added_sgpr_pressure: '0'
// REMARK: remat_added_vgpr_pressure: '1'
// REMARK: remat_added_agpr_pressure: '0'
// REMARK: remat_crosses_loop_unused: '1'
// REMARK: Name:            regalloc-pressure-failure
// REMARK: Function:        remat_rejects_nondominating_rebuild
// REMARK: remat_reject_reason: post_cut_uses_invalid
// REMARK: remat_root_op:   waveamdmachine.v_add_u32
// REMARK: remat_crosses_loop_unused: '1'
// REMARK: Name:            regalloc-pressure-failure
// REMARK: Function:        remat_rejects_fixed_uninit_leaf
// REMARK: remat_reject_reason: added_pressure_not_profitable
// REMARK: remat_root_op:   waveamdmachine.v_add_u32
// REMARK: remat_added_vgpr_pressure: '1'
// REMARK: Name:            regalloc-pressure-failure
// REMARK: Function:        remat_rejects_tuple_with_noncheap_lane
// REMARK: remat_reject_reason: dag_not_rematerializable
// REMARK: remat_root_op:   waveamdmachine.tuple_from_elements
// REMARK: remat_relief_dwords: '2'
// REMARK: remat_crosses_loop_unused: '1'

module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx1100"} {

func.func @remat_rejects_leaf_extension()
    attributes {waveamdmachine.target_waves = 4 : i64} {
  %zero = waveamdmachine.imm 0 : !waveamdmachine.imm
  %one = waveamdmachine.imm 1 : !waveamdmachine.imm
  %leaf = waveamdmachine.uninit : !waveamdmachine.reg<vgpr, 1>
  %root = waveamdmachine.v_add_u32 %leaf, %one
      : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.imm)
        -> !waveamdmachine.reg<vgpr, 1>
  %cond = waveamdmachine.s_cmp_lt_i32 %zero, %one
      : (!waveamdmachine.imm, !waveamdmachine.imm)
        -> !waveamdmachine.reg<scc, 1>
  waveamdmachine.uniform_loop if %cond : !waveamdmachine.reg<scc, 1> {
    %v0 = waveamdmachine.uninit : !waveamdmachine.reg<vgpr, 1>
    %v1 = waveamdmachine.uninit : !waveamdmachine.reg<vgpr, 1>
    %v2 = waveamdmachine.uninit : !waveamdmachine.reg<vgpr, 1>
    %v3 = waveamdmachine.uninit : !waveamdmachine.reg<vgpr, 1>
    %u0 = waveamdmachine.v_add_u32 %v0, %v1
        : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>)
          -> !waveamdmachine.reg<vgpr, 1>
    %u1 = waveamdmachine.v_add_u32 %v2, %v3
        : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>)
          -> !waveamdmachine.reg<vgpr, 1>
    %u2 = waveamdmachine.v_add_u32 %u0, %u1
        : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>)
          -> !waveamdmachine.reg<vgpr, 1>
    waveamdmachine.continue_if %cond : !waveamdmachine.reg<scc, 1>
  }
  %use = waveamdmachine.v_readfirstlane_b32 %root
      : (!waveamdmachine.reg<vgpr, 1>) -> !waveamdmachine.reg<sgpr, 1>
  waveamdmachine.s_endpgm
  return
}

func.func @remat_rejects_nondominating_rebuild()
    attributes {waveamdmachine.target_waves = 4 : i64} {
  %zero = waveamdmachine.imm 0 : !waveamdmachine.imm
  %one = waveamdmachine.imm 1 : !waveamdmachine.imm
  %seed = waveamdmachine.v_mov_b32_tuple %zero {registers = 1 : i64}
      : (!waveamdmachine.imm) -> !waveamdmachine.reg<vgpr, 1>
  %root = waveamdmachine.v_add_u32 %seed, %one
      : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.imm)
        -> !waveamdmachine.reg<vgpr, 1>
  %cond = waveamdmachine.s_cmp_lt_i32 %zero, %one
      : (!waveamdmachine.imm, !waveamdmachine.imm)
        -> !waveamdmachine.reg<scc, 1>
  waveamdmachine.uniform_loop if %cond : !waveamdmachine.reg<scc, 1> {
    %v0 = waveamdmachine.uninit : !waveamdmachine.reg<vgpr, 1>
    %v1 = waveamdmachine.uninit : !waveamdmachine.reg<vgpr, 1>
    %v2 = waveamdmachine.uninit : !waveamdmachine.reg<vgpr, 1>
    %v3 = waveamdmachine.uninit : !waveamdmachine.reg<vgpr, 1>
    %u0 = waveamdmachine.v_add_u32 %v0, %v1
        : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>)
          -> !waveamdmachine.reg<vgpr, 1>
    %u1 = waveamdmachine.v_add_u32 %v2, %v3
        : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>)
          -> !waveamdmachine.reg<vgpr, 1>
    waveamdmachine.continue_if %cond : !waveamdmachine.reg<scc, 1>
  }
  waveamdmachine.uniform_loop if %cond : !waveamdmachine.reg<scc, 1> {
    %inner_use = waveamdmachine.v_add_u32 %root, %one
        : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.imm)
          -> !waveamdmachine.reg<vgpr, 1>
    waveamdmachine.continue_if %cond : !waveamdmachine.reg<scc, 1>
  }
  %outer_use = waveamdmachine.v_readfirstlane_b32 %root
      : (!waveamdmachine.reg<vgpr, 1>) -> !waveamdmachine.reg<sgpr, 1>
  waveamdmachine.s_endpgm
  return
}

func.func @remat_rejects_fixed_uninit_leaf()
    attributes {waveamdmachine.regalloc_assignments,
                waveamdmachine.target_waves = 4 : i64} {
  %zero = waveamdmachine.imm 0 : !waveamdmachine.imm
  %one = waveamdmachine.imm 1 : !waveamdmachine.imm
  %fixed = waveamdmachine.uninit : !waveamdmachine.reg<vgpr, 1, 0>
  %root = waveamdmachine.v_add_u32 %fixed, %one
      : (!waveamdmachine.reg<vgpr, 1, 0>, !waveamdmachine.imm)
        -> !waveamdmachine.reg<vgpr, 1>
  %cond = waveamdmachine.s_cmp_lt_i32 %zero, %one
      : (!waveamdmachine.imm, !waveamdmachine.imm)
        -> !waveamdmachine.reg<scc, 1>
  waveamdmachine.uniform_loop if %cond : !waveamdmachine.reg<scc, 1> {
    %v0 = waveamdmachine.uninit : !waveamdmachine.reg<vgpr, 1>
    %v1 = waveamdmachine.uninit : !waveamdmachine.reg<vgpr, 1>
    %v2 = waveamdmachine.uninit : !waveamdmachine.reg<vgpr, 1>
    %v3 = waveamdmachine.uninit : !waveamdmachine.reg<vgpr, 1>
    %s0 = waveamdmachine.v_readfirstlane_b32 %v0
        : (!waveamdmachine.reg<vgpr, 1>) -> !waveamdmachine.reg<sgpr, 1>
    %s1 = waveamdmachine.v_readfirstlane_b32 %v1
        : (!waveamdmachine.reg<vgpr, 1>) -> !waveamdmachine.reg<sgpr, 1>
    %s2 = waveamdmachine.v_readfirstlane_b32 %v2
        : (!waveamdmachine.reg<vgpr, 1>) -> !waveamdmachine.reg<sgpr, 1>
    %s3 = waveamdmachine.v_readfirstlane_b32 %v3
        : (!waveamdmachine.reg<vgpr, 1>) -> !waveamdmachine.reg<sgpr, 1>
    waveamdmachine.continue_if %cond : !waveamdmachine.reg<scc, 1>
  }
  %use = waveamdmachine.v_readfirstlane_b32 %root
      : (!waveamdmachine.reg<vgpr, 1>) -> !waveamdmachine.reg<sgpr, 1>
  waveamdmachine.s_endpgm
  return
}

func.func @remat_rejects_tuple_with_noncheap_lane()
    attributes {waveamdmachine.target_waves = 4 : i64} {
  %zero = waveamdmachine.imm 0 : !waveamdmachine.imm
  %one = waveamdmachine.imm 1 : !waveamdmachine.imm
  %base = waveamdmachine.uninit : !waveamdmachine.reg<sgpr, 2>
  %off = waveamdmachine.v_workitem_id_x
      : !waveamdmachine.reg<vgpr, 1, 0>
  %lo = waveamdmachine.v_mov_b32_tuple %zero {registers = 1 : i64}
      : (!waveamdmachine.imm) -> !waveamdmachine.reg<vgpr, 1>
  %hi = waveamdmachine.uninit : !waveamdmachine.reg<vgpr, 1>
  %tuple = waveamdmachine.tuple_from_elements %lo, %hi
      : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>)
        -> !waveamdmachine.reg<vgpr, 2>
  %cond = waveamdmachine.s_cmp_lt_i32 %zero, %one
      : (!waveamdmachine.imm, !waveamdmachine.imm)
        -> !waveamdmachine.reg<scc, 1>
  waveamdmachine.uniform_loop if %cond : !waveamdmachine.reg<scc, 1> {
    %v0 = waveamdmachine.uninit : !waveamdmachine.reg<vgpr, 1>
    %v1 = waveamdmachine.uninit : !waveamdmachine.reg<vgpr, 1>
    %v2 = waveamdmachine.uninit : !waveamdmachine.reg<vgpr, 1>
    %v3 = waveamdmachine.uninit : !waveamdmachine.reg<vgpr, 1>
    %u0 = waveamdmachine.v_add_u32 %v0, %v1
        : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>)
          -> !waveamdmachine.reg<vgpr, 1>
    %u1 = waveamdmachine.v_add_u32 %v2, %v3
        : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>)
          -> !waveamdmachine.reg<vgpr, 1>
    waveamdmachine.continue_if %cond : !waveamdmachine.reg<scc, 1>
  }
  %token = waveamdmachine.global_store_tuple_b32 %off, %tuple, %base
      : (!waveamdmachine.reg<vgpr, 1, 0>, !waveamdmachine.reg<vgpr, 2>,
         !waveamdmachine.reg<sgpr, 2>) -> !waveamdmachine.mem.token
  waveamdmachine.s_endpgm
  return
}

}
