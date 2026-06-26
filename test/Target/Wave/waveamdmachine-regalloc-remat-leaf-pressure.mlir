// RUN: wave-opt --waveamd-reg-alloc='mark-overflow=true vgpr-limit=4 agpr-limit=0' \
// RUN:   --waveamd-resource-info %s | FileCheck %s

module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx1100"} {

// CHECK-LABEL: func.func @remat_extends_sgpr_leaf_for_vgpr_relief
// CHECK-SAME: waveamdmachine.regalloc_assignments
// CHECK-NOT: waveamdmachine.regalloc_overflowed
// CHECK: [[ZERO:%.*]] = waveamdmachine.imm 0
// CHECK: [[ONE:%.*]] = waveamdmachine.imm 1
// CHECK: [[LEAF:%.*]] = waveamdmachine.s_mov_b32_value [[ONE]]
// CHECK-NEXT: [[COND:%.*]] = waveamdmachine.s_cmp_lt_i32 [[ZERO]], [[ONE]]
// CHECK-NEXT: waveamdmachine.uniform_loop if [[COND]]
// CHECK-NOT: waveamdmachine.v_add_u32 {{.*}}[[LEAF]]
// CHECK: waveamdmachine.continue_if
// CHECK: [[SEED:%.*]] = waveamdmachine.v_mov_b32_tuple [[ZERO]]
// CHECK-NEXT: [[ROOT:%.*]] = waveamdmachine.v_add_u32 [[SEED]], [[LEAF]]
// CHECK-NEXT: waveamdmachine.v_readfirstlane_b32 [[ROOT]]
func.func @remat_extends_sgpr_leaf_for_vgpr_relief()
    attributes {waveamdmachine.target_waves = 4 : i64} {
  %zero = waveamdmachine.imm 0 : !waveamdmachine.imm
  %one = waveamdmachine.imm 1 : !waveamdmachine.imm
  %sg = waveamdmachine.s_mov_b32_value %one
      : (!waveamdmachine.imm) -> !waveamdmachine.reg<sgpr, 1>
  %seed = waveamdmachine.v_mov_b32_tuple %zero {registers = 1 : i64}
      : (!waveamdmachine.imm) -> !waveamdmachine.reg<vgpr, 1>
  %root = waveamdmachine.v_add_u32 %seed, %sg
      : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<sgpr, 1>)
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

// CHECK-LABEL: func.func @remat_reuses_kernarg_preload_leaf
// CHECK-SAME: waveamdmachine.regalloc_assignments
// CHECK-NOT: waveamdmachine.regalloc_overflowed
// CHECK: [[K_ZERO:%.*]] = waveamdmachine.imm 0
// CHECK: [[K_ONE:%.*]] = waveamdmachine.imm 1
// CHECK: [[ARG:%.*]] = waveamdmachine.kernarg_preload
// CHECK-SAME: !waveamdmachine.reg<sgpr, 1, 2>
// CHECK: [[K_COND:%.*]] = waveamdmachine.s_cmp_lt_i32 [[K_ZERO]], [[K_ONE]]
// CHECK-NEXT: waveamdmachine.uniform_loop if [[K_COND]]
// CHECK-NOT: waveamdmachine.v_add_u32 {{.*}}[[ARG]]
// CHECK: waveamdmachine.continue_if
// CHECK: [[K_SEED:%.*]] = waveamdmachine.v_mov_b32_tuple [[K_ZERO]]
// CHECK-NEXT: [[K_ROOT:%.*]] = waveamdmachine.v_add_u32 [[K_SEED]], [[ARG]]
// CHECK-NEXT: waveamdmachine.v_readfirstlane_b32 [[K_ROOT]]
func.func @remat_reuses_kernarg_preload_leaf()
    attributes {wave.kernel, waveamdmachine.kernarg_preload_length = 1 : i64,
                waveamdmachine.target_waves = 4 : i64} {
  %zero = waveamdmachine.imm 0 : !waveamdmachine.imm
  %one = waveamdmachine.imm 1 : !waveamdmachine.imm
  %arg = waveamdmachine.kernarg_preload {dword_offset = 0 : i64}
      : !waveamdmachine.reg<sgpr, 1, 2>
  %seed = waveamdmachine.v_mov_b32_tuple %zero {registers = 1 : i64}
      : (!waveamdmachine.imm) -> !waveamdmachine.reg<vgpr, 1>
  %root = waveamdmachine.v_add_u32 %seed, %arg
      : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<sgpr, 1, 2>)
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

// CHECK-LABEL: func.func @remat_does_not_treat_workitem_as_free_leaf
// CHECK-SAME: waveamdmachine.regalloc_assignments
// CHECK-SAME: waveamdmachine.scratch_spill_bytes = 4 : i64
// CHECK-NOT: waveamdmachine.regalloc_overflowed
// CHECK: [[W_ZERO:%.*]] = waveamdmachine.imm 0
// CHECK: [[WI:%.*]] = waveamdmachine.v_workitem_id_x
// CHECK: [[W_SEED:%.*]] = waveamdmachine.v_mov_b32_tuple [[W_ZERO]]
// CHECK-NEXT: [[W_ROOT:%.*]] = waveamdmachine.v_add_u32 [[W_SEED]], [[WI]]
// CHECK: waveamdmachine.scratch_store_b32 {{.*}}, [[W_ROOT]]
// CHECK: waveamdmachine.uniform_loop
// CHECK: waveamdmachine.scratch_load_b32
func.func @remat_does_not_treat_workitem_as_free_leaf()
    attributes {wave.kernel, waveamdmachine.target_waves = 4 : i64} {
  %zero = waveamdmachine.imm 0 : !waveamdmachine.imm
  %one = waveamdmachine.imm 1 : !waveamdmachine.imm
  %wi = waveamdmachine.v_workitem_id_x : !waveamdmachine.reg<vgpr, 1, 0>
  %seed = waveamdmachine.v_mov_b32_tuple %zero {registers = 1 : i64}
      : (!waveamdmachine.imm) -> !waveamdmachine.reg<vgpr, 1>
  %root = waveamdmachine.v_add_u32 %seed, %wi
      : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1, 0>)
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

// CHECK-LABEL: func.func @remat_extends_live_vgpr_leaf
// CHECK-SAME: waveamdmachine.regalloc_assignments
// CHECK-NOT: waveamdmachine.regalloc_overflowed
// CHECK: [[ZERO:%.*]] = waveamdmachine.imm 0
// CHECK: [[ONE:%.*]] = waveamdmachine.imm 1
// CHECK: [[LEAF:%.*]] = waveamdmachine.uninit
// CHECK-NEXT: [[COND:%.*]] = waveamdmachine.s_cmp_lt_i32 [[ZERO]], [[ONE]]
// CHECK-NEXT: waveamdmachine.uniform_loop if [[COND]]
// CHECK: waveamdmachine.v_add_u32 [[LEAF]]
// CHECK: waveamdmachine.continue_if
// CHECK: [[ROOT:%.*]] = waveamdmachine.v_add_u32 [[LEAF]], [[ONE]]
// CHECK-NEXT: waveamdmachine.v_readfirstlane_b32 [[ROOT]]
func.func @remat_extends_live_vgpr_leaf()
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
    %pressure = waveamdmachine.v_add_u32 %v0, %v1
        : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>)
          -> !waveamdmachine.reg<vgpr, 1>
    %use_leaf = waveamdmachine.v_add_u32 %leaf, %pressure
        : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>)
          -> !waveamdmachine.reg<vgpr, 1>
    waveamdmachine.continue_if %cond : !waveamdmachine.reg<scc, 1>
  }
  %use = waveamdmachine.v_readfirstlane_b32 %root
      : (!waveamdmachine.reg<vgpr, 1>) -> !waveamdmachine.reg<sgpr, 1>
  waveamdmachine.s_endpgm
  return
}

// CHECK-LABEL: func.func @remat_does_not_use_fixed_index_as_source
// CHECK-SAME: waveamdmachine.regalloc_assignments
// CHECK-NOT: waveamdmachine.regalloc_overflowed
// CHECK: [[F_ZERO:%.*]] = waveamdmachine.imm 0
// CHECK: [[F_ONE:%.*]] = waveamdmachine.imm 1
// CHECK: [[F_COND:%.*]] = waveamdmachine.s_cmp_lt_i32 [[F_ZERO]], [[F_ONE]]
// CHECK-NEXT: waveamdmachine.uniform_loop if [[F_COND]]
// CHECK: waveamdmachine.continue_if
// CHECK: [[F_CLONE:%.*]] = waveamdmachine.v_mov_b32_tuple [[F_ZERO]]
// CHECK-NEXT: [[F_ROOT:%.*]] = waveamdmachine.v_add_u32 [[F_CLONE]], [[F_ONE]]
// CHECK-NEXT: waveamdmachine.v_readfirstlane_b32 [[F_ROOT]]
func.func @remat_does_not_use_fixed_index_as_source()
    attributes {waveamdmachine.regalloc_assignments,
                waveamdmachine.target_waves = 4 : i64} {
  %zero = waveamdmachine.imm 0 : !waveamdmachine.imm
  %one = waveamdmachine.imm 1 : !waveamdmachine.imm
  %fixed = waveamdmachine.v_mov_b32_tuple %zero {registers = 1 : i64}
      : (!waveamdmachine.imm) -> !waveamdmachine.reg<vgpr, 1, 0>
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
    %pressure0 = waveamdmachine.v_add_u32 %v0, %v1
        : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>)
          -> !waveamdmachine.reg<vgpr, 1>
    %pressure1 = waveamdmachine.v_add_u32 %pressure0, %v2
        : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>)
          -> !waveamdmachine.reg<vgpr, 1>
    waveamdmachine.continue_if %cond : !waveamdmachine.reg<scc, 1>
  }
  %use = waveamdmachine.v_readfirstlane_b32 %root
      : (!waveamdmachine.reg<vgpr, 1>) -> !waveamdmachine.reg<sgpr, 1>
  waveamdmachine.s_endpgm
  return
}

}
