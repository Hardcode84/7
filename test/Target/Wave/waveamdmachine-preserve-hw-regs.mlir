// RUN: wave-opt --waveamd-preserve-hw-regs -split-input-file %s | FileCheck %s
// RUN: wave-opt --split-input-file %s --pass-pipeline='builtin.module(waveamd-preserve-hw-regs,transform-preload-library{transform-library-paths=%wave_pipelines},transform-interpreter{entry-point=waveamd_regalloc_transform_loop})' >/dev/null

module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx1100"} {

// CHECK-LABEL: func.func @preserve_scc
// CHECK: %[[SCC:.+]] = waveamdmachine.s_cmp_lt_i32
// CHECK: %[[ONE:.+]] = waveamdmachine.imm 1 : !waveamdmachine.imm
// CHECK: %[[ZERO:.+]] = waveamdmachine.imm 0 : !waveamdmachine.imm
// CHECK: %[[SAVED:.+]] = waveamdmachine.s_cselect_b32 %[[SCC]], %[[ONE]], %[[ZERO]]
// CHECK: %[[SUM:.+]], %[[SUM_SCC:.+]] = waveamdmachine.s_add_i32
// CHECK: %[[RELOAD_ZERO:.+]] = waveamdmachine.imm 0 : !waveamdmachine.imm
// CHECK: %[[RELOADED:.+]] = waveamdmachine.s_cmp_lg_u32 %[[SAVED]], %[[RELOAD_ZERO]]
// CHECK: waveamdmachine.s_cbranch_scc1 %[[RELOADED]]
func.func @preserve_scc(%a: !waveamdmachine.reg<sgpr, 1>,
                        %b: !waveamdmachine.reg<sgpr, 1>) {
  %scc = waveamdmachine.s_cmp_lt_i32 %a, %b
      : (!waveamdmachine.reg<sgpr, 1>, !waveamdmachine.reg<sgpr, 1>)
        -> !waveamdmachine.reg<scc, 1>
  %sum, %sum_scc = waveamdmachine.s_add_i32 %a, %b
      : (!waveamdmachine.reg<sgpr, 1>, !waveamdmachine.reg<sgpr, 1>)
        -> (!waveamdmachine.reg<sgpr, 1>, !waveamdmachine.reg<scc, 1>)
  waveamdmachine.s_cbranch_scc1 %scc : !waveamdmachine.reg<scc, 1>, "taken"
  return
}

}

// -----

module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx1250"} {

// CHECK-LABEL: func.func @preserve_scc_across_cluster_read
// CHECK: %[[SCC:.+]] = waveamdmachine.s_cmp_lt_i32
// CHECK: %[[ONE:.+]] = waveamdmachine.imm 1 : !waveamdmachine.imm
// CHECK: %[[ZERO:.+]] = waveamdmachine.imm 0 : !waveamdmachine.imm
// CHECK: %[[SAVED:.+]] = waveamdmachine.s_cselect_b32 %[[SCC]], %[[ONE]], %[[ZERO]]
// CHECK: %[[LOCAL:.+]], %[[LOCAL_SCC:.+]] = waveamdmachine.s_cluster_workgroup_id_x
// CHECK: %[[RELOAD_ZERO:.+]] = waveamdmachine.imm 0 : !waveamdmachine.imm
// CHECK: %[[RELOADED:.+]] = waveamdmachine.s_cmp_lg_u32 %[[SAVED]], %[[RELOAD_ZERO]]
// CHECK: waveamdmachine.s_cbranch_scc1 %[[RELOADED]]
func.func @preserve_scc_across_cluster_read(
    %a: !waveamdmachine.reg<sgpr, 1>,
    %b: !waveamdmachine.reg<sgpr, 1>) {
  %scc = waveamdmachine.s_cmp_lt_i32 %a, %b
      : (!waveamdmachine.reg<sgpr, 1>, !waveamdmachine.reg<sgpr, 1>)
        -> !waveamdmachine.reg<scc, 1>
  %local, %local_scc = waveamdmachine.s_cluster_workgroup_id_x
      : !waveamdmachine.reg<sgpr, 1>, !waveamdmachine.reg<scc, 1>
  waveamdmachine.s_cbranch_scc1 %scc
      : !waveamdmachine.reg<scc, 1>, "taken"
  return
}

}

// -----

module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx950"} {

// CHECK-LABEL: func.func @carry_m0_into_exec_if
// CHECK: %[[M0:.+]], {{%.*}} = waveamdmachine.s_add_m0_i32
// CHECK-NEXT: %[[TOK:.+]] = waveamdmachine.exec_if
// CHECK-NOT: waveamdmachine.s_mov_m0
// CHECK: waveamdmachine.buffer_load_lds_b128 {{.*}}, {{.*}}, {{.*}}, %[[M0]]
func.func @carry_m0_into_exec_if(
    %cond: !waveamdmachine.reg<sgpr, 1>,
    %off: !waveamdmachine.reg<vgpr, 1>,
    %desc: !waveamdmachine.reg<sgpr, 4>,
    %soff: !waveamdmachine.reg<sgpr, 1>,
    %dst: !waveamdmachine.reg<sgpr, 1>,
    %dep: !waveamdmachine.mem.token) {
  %inc = waveamdmachine.imm 8448 : !waveamdmachine.imm
  %m0, %scc = waveamdmachine.s_add_m0_i32 %dst, %inc
      : (!waveamdmachine.reg<sgpr, 1>, !waveamdmachine.imm)
      -> (!waveamdmachine.m0, !waveamdmachine.reg<scc, 1>)
  %tok = waveamdmachine.exec_if %cond {
    %loaded = waveamdmachine.buffer_load_lds_b128
        %off, %desc, %soff, %m0 after %dep
        : (!waveamdmachine.reg<vgpr, 1>,
           !waveamdmachine.reg<sgpr, 4>,
           !waveamdmachine.reg<sgpr, 1>, !waveamdmachine.m0,
           !waveamdmachine.mem.token) -> !waveamdmachine.mem.token
    waveamdmachine.yield %loaded : !waveamdmachine.mem.token
  } : !waveamdmachine.reg<sgpr, 1> -> !waveamdmachine.mem.token
  return
}

// CHECK-LABEL: func.func @reload_m0_after_nested_clobber
// CHECK: %[[OUTER:.+]] = waveamdmachine.s_mov_m0 [[DST0:%.*]]
// CHECK: waveamdmachine.exec_if
// CHECK: waveamdmachine.s_mov_m0 [[DST1:%.*]]
// CHECK: %[[RELOAD:.+]] = waveamdmachine.s_mov_m0 [[DST0]]
// CHECK: waveamdmachine.buffer_load_lds_b128 {{.*}}, {{.*}}, {{.*}}, %[[RELOAD]]
func.func @reload_m0_after_nested_clobber(
    %cond: !waveamdmachine.reg<sgpr, 1>,
    %off: !waveamdmachine.reg<vgpr, 1>,
    %desc: !waveamdmachine.reg<sgpr, 4>,
    %soff: !waveamdmachine.reg<sgpr, 1>,
    %dst0: !waveamdmachine.reg<sgpr, 1>,
    %dst1: !waveamdmachine.reg<sgpr, 1>,
    %dep: !waveamdmachine.mem.token) {
  %m0 = waveamdmachine.s_mov_m0 %dst0
      : (!waveamdmachine.reg<sgpr, 1>) -> !waveamdmachine.m0
  %tok = waveamdmachine.exec_if %cond {
    %clobber = waveamdmachine.s_mov_m0 %dst1
        : (!waveamdmachine.reg<sgpr, 1>) -> !waveamdmachine.m0
    %loaded = waveamdmachine.buffer_load_lds_b128
        %off, %desc, %soff, %m0 after %dep
        : (!waveamdmachine.reg<vgpr, 1>,
           !waveamdmachine.reg<sgpr, 4>,
           !waveamdmachine.reg<sgpr, 1>, !waveamdmachine.m0,
           !waveamdmachine.mem.token) -> !waveamdmachine.mem.token
    waveamdmachine.yield %loaded : !waveamdmachine.mem.token
  } : !waveamdmachine.reg<sgpr, 1> -> !waveamdmachine.mem.token
  return
}

// CHECK-LABEL: func.func @reload_m0_in_loop
// CHECK: %[[OUTER:.+]] = waveamdmachine.s_mov_m0 [[DST:%.*]]
// CHECK: waveamdmachine.uniform_loop
// CHECK: %[[RELOAD:.+]] = waveamdmachine.s_mov_m0 [[DST]]
// CHECK: waveamdmachine.global_load_lds_b128 {{.*}}, {{.*}}, %[[RELOAD]]
func.func @reload_m0_in_loop(
    %cond: !waveamdmachine.reg<scc, 1>,
    %off: !waveamdmachine.reg<vgpr, 1>,
    %base: !waveamdmachine.reg<sgpr, 2>,
    %dst: !waveamdmachine.reg<sgpr, 1>,
    %dep: !waveamdmachine.mem.token) {
  %m0 = waveamdmachine.s_mov_m0 %dst
      : (!waveamdmachine.reg<sgpr, 1>) -> !waveamdmachine.m0
  %tok = waveamdmachine.uniform_loop if %cond
      : !waveamdmachine.reg<scc, 1>
      carries(%dep : !waveamdmachine.mem.token) {
  ^bb0(%iter: !waveamdmachine.mem.token):
    %loaded = waveamdmachine.global_load_lds_b128
        %off, %base, %m0 after %iter
        : (!waveamdmachine.reg<vgpr, 1>,
           !waveamdmachine.reg<sgpr, 2>, !waveamdmachine.m0,
           !waveamdmachine.mem.token) -> !waveamdmachine.mem.token
    waveamdmachine.continue_if %cond : !waveamdmachine.reg<scc, 1>
        carries(%loaded : !waveamdmachine.mem.token)
  } -> !waveamdmachine.mem.token
  return
}

}

// -----

module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx1100"} {

// CHECK-LABEL: func.func @preserve_nested_scc_capture
// CHECK: %[[OUTER:.+]] = waveamdmachine.s_cmp_lt_i32
// CHECK: %[[OUTER_SAVE:.+]] = waveamdmachine.s_cselect_b32 %[[OUTER]]
// CHECK: %[[INNER:.+]] = waveamdmachine.s_cmp_lt_i32
// CHECK: %[[INNER_SAVE:.+]] = waveamdmachine.s_cselect_b32 %[[INNER]]
// CHECK: %[[OUTER_RELOAD:.+]] = waveamdmachine.s_cmp_lg_u32 %[[OUTER_SAVE]]
// CHECK: waveamdmachine.uniform_loop if %[[OUTER_RELOAD]]
// CHECK: ^bb0
// CHECK: waveamdmachine.s_lshl_b32
// CHECK: %[[INNER_RELOAD:.+]] = waveamdmachine.s_cmp_lg_u32 %[[INNER_SAVE]]
// CHECK-NEXT: waveamdmachine.uniform_loop if %[[INNER_RELOAD]]
func.func @preserve_nested_scc_capture(%n: !waveamdmachine.reg<sgpr, 1>,
                                       %m: !waveamdmachine.reg<sgpr, 1>) {
  %zero = waveamdmachine.imm 0 : !waveamdmachine.imm
  %one = waveamdmachine.imm 1 : !waveamdmachine.imm
  %five = waveamdmachine.imm 5 : !waveamdmachine.imm
  %lo = waveamdmachine.s_mov_b32_value %zero
      : (!waveamdmachine.imm) -> !waveamdmachine.reg<sgpr, 1>
  %outer = waveamdmachine.s_cmp_lt_i32 %lo, %n
      : (!waveamdmachine.reg<sgpr, 1>, !waveamdmachine.reg<sgpr, 1>)
        -> !waveamdmachine.reg<scc, 1>
  %inner_lo = waveamdmachine.s_mov_b32_value %one
      : (!waveamdmachine.imm) -> !waveamdmachine.reg<sgpr, 1>
  %inner = waveamdmachine.s_cmp_lt_i32 %inner_lo, %m
      : (!waveamdmachine.reg<sgpr, 1>, !waveamdmachine.reg<sgpr, 1>)
        -> !waveamdmachine.reg<scc, 1>
  %r = waveamdmachine.uniform_loop if %outer : !waveamdmachine.reg<scc, 1>
      carries(%lo : !waveamdmachine.reg<sgpr, 1>) {
  ^bb0(%i: !waveamdmachine.reg<sgpr, 1>):
    %shift, %shift_scc = waveamdmachine.s_lshl_b32 %i, %five
        : (!waveamdmachine.reg<sgpr, 1>, !waveamdmachine.imm)
        -> (!waveamdmachine.reg<sgpr, 1>, !waveamdmachine.reg<scc, 1>)
    %inner_r = waveamdmachine.uniform_loop if %inner
        : !waveamdmachine.reg<scc, 1>
        carries(%inner_lo : !waveamdmachine.reg<sgpr, 1>) {
    ^bb0(%j: !waveamdmachine.reg<sgpr, 1>):
      %next_j, %next_j_scc = waveamdmachine.s_add_i32 %j, %one
          : (!waveamdmachine.reg<sgpr, 1>, !waveamdmachine.imm)
          -> (!waveamdmachine.reg<sgpr, 1>, !waveamdmachine.reg<scc, 1>)
      %inner_back = waveamdmachine.s_cmp_lt_i32 %next_j, %m
          : (!waveamdmachine.reg<sgpr, 1>, !waveamdmachine.reg<sgpr, 1>)
          -> !waveamdmachine.reg<scc, 1>
      waveamdmachine.continue_if %inner_back
          : !waveamdmachine.reg<scc, 1>
          carries(%next_j : !waveamdmachine.reg<sgpr, 1>)
    } -> !waveamdmachine.reg<sgpr, 1>
    %next_i, %next_i_scc = waveamdmachine.s_add_i32 %i, %one
        : (!waveamdmachine.reg<sgpr, 1>, !waveamdmachine.imm)
        -> (!waveamdmachine.reg<sgpr, 1>, !waveamdmachine.reg<scc, 1>)
    %outer_back = waveamdmachine.s_cmp_lt_i32 %next_i, %n
        : (!waveamdmachine.reg<sgpr, 1>, !waveamdmachine.reg<sgpr, 1>)
        -> !waveamdmachine.reg<scc, 1>
    waveamdmachine.continue_if %outer_back : !waveamdmachine.reg<scc, 1>
        carries(%next_i : !waveamdmachine.reg<sgpr, 1>)
  } -> !waveamdmachine.reg<sgpr, 1>
  return
}

}

// -----

module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx1100"} {

// CHECK-LABEL: func.func @preserve_vcc
// CHECK: %[[SUM0:.+]], %[[VCC0:.+]] = waveamdmachine.v_add_u64
// CHECK: %[[SAVED:.+]] = waveamdmachine.s_read_vcc_b32 %[[VCC0]]
// CHECK: %[[SUM1:.+]], %[[VCC1:.+]] = waveamdmachine.v_add_u64
// CHECK: %[[RELOADED:.+]] = waveamdmachine.s_mov_vcc_b32 %[[SAVED]]
// CHECK: return %[[RELOADED]]
func.func @preserve_vcc(%a: !waveamdmachine.reg<vgpr, 2>,
                        %b: !waveamdmachine.reg<vgpr, 2>,
                        %c: !waveamdmachine.reg<vgpr, 2>)
    -> !waveamdmachine.reg<vcc, 1> {
  %sum0, %vcc0 = waveamdmachine.v_add_u64 %a, %b
      : (!waveamdmachine.reg<vgpr, 2>, !waveamdmachine.reg<vgpr, 2>)
        -> (!waveamdmachine.reg<vgpr, 2>, !waveamdmachine.reg<vcc, 1>)
  %sum1, %vcc1 = waveamdmachine.v_add_u64 %a, %c
      : (!waveamdmachine.reg<vgpr, 2>, !waveamdmachine.reg<vgpr, 2>)
        -> (!waveamdmachine.reg<vgpr, 2>, !waveamdmachine.reg<vcc, 1>)
  return %vcc0 : !waveamdmachine.reg<vcc, 1>
}

}

// -----

module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx1100"} {

// CHECK-LABEL: func.func @preserve_m0
// CHECK: %[[M0A:.+]] = waveamdmachine.s_mov_m0 [[DST0:%.*]]
// CHECK: %[[M0B:.+]] = waveamdmachine.s_mov_m0 [[DST1:%.*]]
// CHECK: %[[RELOADED:.+]] = waveamdmachine.s_mov_m0 [[DST0]]
// CHECK: %[[TOK:.+]] = waveamdmachine.global_load_lds_b32 {{.*}}, {{.*}}, %[[RELOADED]]
func.func @preserve_m0(%off: !waveamdmachine.reg<vgpr, 1>,
                       %base: !waveamdmachine.reg<sgpr, 2>,
                       %dst0: !waveamdmachine.reg<sgpr, 1>,
                       %dst1: !waveamdmachine.reg<sgpr, 1>,
                       %dep: !waveamdmachine.mem.token) {
  %m0a = waveamdmachine.s_mov_m0 %dst0
      : (!waveamdmachine.reg<sgpr, 1>) -> !waveamdmachine.m0
  %m0b = waveamdmachine.s_mov_m0 %dst1
      : (!waveamdmachine.reg<sgpr, 1>) -> !waveamdmachine.m0
  %tok = waveamdmachine.global_load_lds_b32 %off, %base, %m0a after %dep
      : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<sgpr, 2>,
         !waveamdmachine.m0, !waveamdmachine.mem.token)
        -> !waveamdmachine.mem.token
  return
}

}
