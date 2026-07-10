// RUN: wave-opt %s --waveamd-scalar-mask-preschedule | FileCheck %s

module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx950"} {
  // CHECK-LABEL: func.func @sinks_vcc_compare_masks
  // CHECK: [[CMP0:%.*]], %{{.*}} = waveamdmachine.v_cmp_ne_u32_vcc %arg0, %arg2
  // CHECK-NEXT: [[IF0:%.*]] = waveamdmachine.exec_if [[CMP0]]
  // CHECK: [[CMP1:%.*]], %{{.*}} = waveamdmachine.v_cmp_ne_u32_vcc %arg1, %arg2
  // CHECK-NEXT: [[IF1:%.*]] = waveamdmachine.exec_if [[CMP1]]
  // CHECK: waveamdmachine.v_or_b32 [[IF0]], [[IF1]]
  func.func @sinks_vcc_compare_masks(
      %a0: !waveamdmachine.reg<vgpr, 1>,
      %a1: !waveamdmachine.reg<vgpr, 1>,
      %zero: !waveamdmachine.reg<vgpr, 1>,
      %desc: !waveamdmachine.reg<sgpr, 4>,
      %off: !waveamdmachine.reg<vgpr, 1>) {
    %imm0 = waveamdmachine.imm 0 : !waveamdmachine.imm
    %mask0, %vcc0 = waveamdmachine.v_cmp_ne_u32_vcc %a0, %zero
        : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>)
        -> (!waveamdmachine.reg<sgpr, 2>, !waveamdmachine.reg<vcc, 1>)
    %mask1, %vcc1 = waveamdmachine.v_cmp_ne_u32_vcc %a1, %zero
        : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>)
        -> (!waveamdmachine.reg<sgpr, 2>, !waveamdmachine.reg<vcc, 1>)
    %load0 = waveamdmachine.exec_if %mask0 {
      %loaded, %token = waveamdmachine.buffer_load_b16 %off, %desc, %imm0
          : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<sgpr, 4>,
             !waveamdmachine.imm)
          -> (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.mem.token)
      waveamdmachine.yield %loaded : !waveamdmachine.reg<vgpr, 1>
    } : !waveamdmachine.reg<sgpr, 2> -> !waveamdmachine.reg<vgpr, 1>
    %load1 = waveamdmachine.exec_if %mask1 {
      %loaded, %token = waveamdmachine.buffer_load_b16 %off, %desc, %imm0
          : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<sgpr, 4>,
             !waveamdmachine.imm)
          -> (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.mem.token)
      waveamdmachine.yield %loaded : !waveamdmachine.reg<vgpr, 1>
    } : !waveamdmachine.reg<sgpr, 2> -> !waveamdmachine.reg<vgpr, 1>
    %combined = waveamdmachine.v_or_b32 %load0, %load1
        : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>)
        -> !waveamdmachine.reg<vgpr, 1>
    return
  }

  // CHECK-LABEL: func.func @sinks_scc_compare_mask
  // CHECK: [[SUM:%.*]], %{{.*}} = waveamdmachine.s_add_i32 %arg0, %arg1
  // CHECK-NEXT: [[CMP:%.*]] = waveamdmachine.s_cmp_eq_u32 %arg0, %arg1
  // CHECK-NEXT: [[PICK:%.*]] = waveamdmachine.s_cselect_b32 [[CMP]], [[SUM]], %arg0
  // CHECK: return [[PICK]]
  func.func @sinks_scc_compare_mask(
      %a: !waveamdmachine.reg<sgpr, 1>,
      %b: !waveamdmachine.reg<sgpr, 1>) -> !waveamdmachine.reg<sgpr, 1> {
    %cmp = waveamdmachine.s_cmp_eq_u32 %a, %b
        : (!waveamdmachine.reg<sgpr, 1>, !waveamdmachine.reg<sgpr, 1>)
        -> !waveamdmachine.reg<scc, 1>
    %sum, %scc = waveamdmachine.s_add_i32 %a, %b
        : (!waveamdmachine.reg<sgpr, 1>, !waveamdmachine.reg<sgpr, 1>)
        -> (!waveamdmachine.reg<sgpr, 1>, !waveamdmachine.reg<scc, 1>)
    %pick = waveamdmachine.s_cselect_b32 %cmp, %sum, %a
        : (!waveamdmachine.reg<scc, 1>, !waveamdmachine.reg<sgpr, 1>,
           !waveamdmachine.reg<sgpr, 1>) -> !waveamdmachine.reg<sgpr, 1>
    return %pick : !waveamdmachine.reg<sgpr, 1>
  }

  // CHECK-LABEL: func.func @keeps_scc_reload_local
  // CHECK: [[BOOL:%.*]] = waveamdmachine.s_cselect_b32 %arg0, %arg1, %arg2
  // CHECK-NEXT: [[RELOAD:%.*]] = waveamdmachine.s_cmp_lg_u32 [[BOOL]], %arg2
  // CHECK-NEXT: [[SUM:%.*]], %{{.*}} = waveamdmachine.s_add_i32 %arg1, %arg2
  // CHECK-NEXT: [[PICK:%.*]] = waveamdmachine.s_cselect_b32 [[RELOAD]], [[SUM]], %arg1
  // CHECK: return [[PICK]]
  func.func @keeps_scc_reload_local(
      %scc: !waveamdmachine.reg<scc, 1>,
      %a: !waveamdmachine.reg<sgpr, 1>,
      %b: !waveamdmachine.reg<sgpr, 1>) -> !waveamdmachine.reg<sgpr, 1> {
    %bool = waveamdmachine.s_cselect_b32 %scc, %a, %b
        : (!waveamdmachine.reg<scc, 1>, !waveamdmachine.reg<sgpr, 1>,
           !waveamdmachine.reg<sgpr, 1>) -> !waveamdmachine.reg<sgpr, 1>
    %reload = waveamdmachine.s_cmp_lg_u32 %bool, %b
        : (!waveamdmachine.reg<sgpr, 1>, !waveamdmachine.reg<sgpr, 1>)
        -> !waveamdmachine.reg<scc, 1>
    %sum, %sum_scc = waveamdmachine.s_add_i32 %a, %b
        : (!waveamdmachine.reg<sgpr, 1>, !waveamdmachine.reg<sgpr, 1>)
        -> (!waveamdmachine.reg<sgpr, 1>, !waveamdmachine.reg<scc, 1>)
    %pick = waveamdmachine.s_cselect_b32 %reload, %sum, %a
        : (!waveamdmachine.reg<scc, 1>, !waveamdmachine.reg<sgpr, 1>,
           !waveamdmachine.reg<sgpr, 1>) -> !waveamdmachine.reg<sgpr, 1>
    return %pick : !waveamdmachine.reg<sgpr, 1>
  }
}
