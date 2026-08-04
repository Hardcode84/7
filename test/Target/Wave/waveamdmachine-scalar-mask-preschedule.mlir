// RUN: wave-opt %s --waveamd-scalar-mask-preschedule | FileCheck %s
// RUN: wave-opt %s --waveamd-scalar-mask-postschedule | FileCheck %s --check-prefix=POST
// RUN: wave-opt %s --waveamd-scalar-mask-preschedule > %t.pre-once
// RUN: wave-opt %t.pre-once --waveamd-scalar-mask-preschedule > %t.pre-twice
// RUN: diff %t.pre-once %t.pre-twice
// RUN: wave-opt %s --waveamd-scalar-mask-postschedule > %t.post-once
// RUN: wave-opt %t.post-once --waveamd-scalar-mask-postschedule > %t.post-twice
// RUN: diff %t.post-once %t.post-twice

module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx950"} {
  // CHECK-LABEL: func.func @sinks_vcc_compare_masks
  // CHECK: [[VCC0:%.*]] = waveamdmachine.v_cmp_ne_u32_vcc %arg0, %arg2
  // CHECK-NEXT: [[IF0:%.*]] = waveamdmachine.exec_if [[VCC0]]
  // CHECK: } {mask_width = 64 : i64} : !waveamdmachine.reg<vcc, 1>
  // CHECK: [[VCC1:%.*]] = waveamdmachine.v_cmp_ne_u32_vcc %arg1, %arg2
  // CHECK-NEXT: [[IF1:%.*]] = waveamdmachine.exec_if [[VCC1]]
  // CHECK: } {mask_width = 64 : i64} : !waveamdmachine.reg<vcc, 1>
  // CHECK: waveamdmachine.v_or_b32 [[IF0]], [[IF1]]
  func.func @sinks_vcc_compare_masks(
      %a0: !waveamdmachine.reg<vgpr, 1>,
      %a1: !waveamdmachine.reg<vgpr, 1>,
      %zero: !waveamdmachine.reg<vgpr, 1>,
      %desc: !waveamdmachine.reg<sgpr, 4>,
      %off: !waveamdmachine.reg<vgpr, 1>) {
    %imm0 = waveamdmachine.imm 0 : !waveamdmachine.imm
    %vcc0 = waveamdmachine.v_cmp_ne_u32_vcc %a0, %zero
        : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>)
        -> !waveamdmachine.reg<vcc, 1>
    %mask0 = waveamdmachine.s_read_vcc_b64 %vcc0
        : (!waveamdmachine.reg<vcc, 1>) -> !waveamdmachine.reg<sgpr, 2>
    %vcc1 = waveamdmachine.v_cmp_ne_u32_vcc %a1, %zero
        : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>)
        -> !waveamdmachine.reg<vcc, 1>
    %mask1 = waveamdmachine.s_read_vcc_b64 %vcc1
        : (!waveamdmachine.reg<vcc, 1>) -> !waveamdmachine.reg<sgpr, 2>
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

  // CHECK-LABEL: func.func @direct_vcc_exec_mask
  // CHECK: [[VCC:%.*]] = waveamdmachine.v_cmp_ne_u32_vcc %arg0, %arg1
  // CHECK-NEXT: waveamdmachine.exec_if [[VCC]]
  // CHECK: } {mask_width = 64 : i64} : !waveamdmachine.reg<vcc, 1>
  func.func @direct_vcc_exec_mask(
      %a: !waveamdmachine.reg<vgpr, 1>,
      %zero: !waveamdmachine.reg<vgpr, 1>) {
    %vcc = waveamdmachine.v_cmp_ne_u32_vcc %a, %zero
        : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>)
        -> !waveamdmachine.reg<vcc, 1>
    %mask = waveamdmachine.s_read_vcc_b64 %vcc
        : (!waveamdmachine.reg<vcc, 1>) -> !waveamdmachine.reg<sgpr, 2>
    waveamdmachine.exec_if %mask {
      waveamdmachine.yield
    } : !waveamdmachine.reg<sgpr, 2>
    return
  }

  // CHECK-LABEL: func.func @makes_dead_vcc_compare_results_direct
  // CHECK: [[EQ:%.*]] = waveamdmachine.v_cmp_eq_u32 %arg0, %arg1
  // CHECK: [[NE:%.*]] = waveamdmachine.v_cmp_ne_u32 %arg0, %arg1
  // CHECK: [[ULT:%.*]] = waveamdmachine.v_cmp_lt_u32 %arg0, %arg1
  // CHECK: [[ULE:%.*]] = waveamdmachine.v_cmp_le_u32 %arg0, %arg1
  // CHECK: [[UGT:%.*]] = waveamdmachine.v_cmp_gt_u32 %arg0, %arg1
  // CHECK: [[UGE:%.*]] = waveamdmachine.v_cmp_ge_u32 %arg0, %arg1
  // CHECK: [[SLT:%.*]] = waveamdmachine.v_cmp_lt_i32 %arg0, %arg1
  // CHECK: [[SLE:%.*]] = waveamdmachine.v_cmp_le_i32 %arg0, %arg1
  // CHECK: [[SGT:%.*]] = waveamdmachine.v_cmp_gt_i32 %arg0, %arg1
  // CHECK: [[SGE:%.*]] = waveamdmachine.v_cmp_ge_i32 %arg0, %arg1
  func.func @makes_dead_vcc_compare_results_direct(
      %a: !waveamdmachine.reg<vgpr, 1>,
      %b: !waveamdmachine.reg<vgpr, 1>) {
    %eq_vcc = waveamdmachine.v_cmp_eq_u32_vcc %a, %b
        : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>)
        -> !waveamdmachine.reg<vcc, 1>
    %eq = waveamdmachine.s_read_vcc_b64 %eq_vcc
        : (!waveamdmachine.reg<vcc, 1>) -> !waveamdmachine.reg<sgpr, 2>
    %ne_vcc = waveamdmachine.v_cmp_ne_u32_vcc %a, %b
        : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>)
        -> !waveamdmachine.reg<vcc, 1>
    %ne = waveamdmachine.s_read_vcc_b64 %ne_vcc
        : (!waveamdmachine.reg<vcc, 1>) -> !waveamdmachine.reg<sgpr, 2>
    %ult_vcc = waveamdmachine.v_cmp_lt_u32_vcc %a, %b
        : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>)
        -> !waveamdmachine.reg<vcc, 1>
    %ult = waveamdmachine.s_read_vcc_b64 %ult_vcc
        : (!waveamdmachine.reg<vcc, 1>) -> !waveamdmachine.reg<sgpr, 2>
    %ule_vcc = waveamdmachine.v_cmp_le_u32_vcc %a, %b
        : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>)
        -> !waveamdmachine.reg<vcc, 1>
    %ule = waveamdmachine.s_read_vcc_b64 %ule_vcc
        : (!waveamdmachine.reg<vcc, 1>) -> !waveamdmachine.reg<sgpr, 2>
    %ugt_vcc = waveamdmachine.v_cmp_gt_u32_vcc %a, %b
        : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>)
        -> !waveamdmachine.reg<vcc, 1>
    %ugt = waveamdmachine.s_read_vcc_b64 %ugt_vcc
        : (!waveamdmachine.reg<vcc, 1>) -> !waveamdmachine.reg<sgpr, 2>
    %uge_vcc = waveamdmachine.v_cmp_ge_u32_vcc %a, %b
        : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>)
        -> !waveamdmachine.reg<vcc, 1>
    %uge = waveamdmachine.s_read_vcc_b64 %uge_vcc
        : (!waveamdmachine.reg<vcc, 1>) -> !waveamdmachine.reg<sgpr, 2>
    %slt_vcc = waveamdmachine.v_cmp_lt_i32_vcc %a, %b
        : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>)
        -> !waveamdmachine.reg<vcc, 1>
    %slt = waveamdmachine.s_read_vcc_b64 %slt_vcc
        : (!waveamdmachine.reg<vcc, 1>) -> !waveamdmachine.reg<sgpr, 2>
    %sle_vcc = waveamdmachine.v_cmp_le_i32_vcc %a, %b
        : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>)
        -> !waveamdmachine.reg<vcc, 1>
    %sle = waveamdmachine.s_read_vcc_b64 %sle_vcc
        : (!waveamdmachine.reg<vcc, 1>) -> !waveamdmachine.reg<sgpr, 2>
    %sgt_vcc = waveamdmachine.v_cmp_gt_i32_vcc %a, %b
        : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>)
        -> !waveamdmachine.reg<vcc, 1>
    %sgt = waveamdmachine.s_read_vcc_b64 %sgt_vcc
        : (!waveamdmachine.reg<vcc, 1>) -> !waveamdmachine.reg<sgpr, 2>
    %sge_vcc = waveamdmachine.v_cmp_ge_i32_vcc %a, %b
        : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>)
        -> !waveamdmachine.reg<vcc, 1>
    %sge = waveamdmachine.s_read_vcc_b64 %sge_vcc
        : (!waveamdmachine.reg<vcc, 1>) -> !waveamdmachine.reg<sgpr, 2>
    return
  }

  // CHECK-LABEL: func.func @keeps_mask_across_live_vcc
  // CHECK: [[MASK:%.*]] = waveamdmachine.v_cmp_ne_u32
  // CHECK-NEXT: [[SUM:%.*]], [[LIVE_VCC:%.*]] = waveamdmachine.v_add_u32_vcc
  // CHECK-NEXT: waveamdmachine.exec_if [[MASK]]
  // CHECK: } : !waveamdmachine.reg<sgpr, 2>
  // CHECK-NEXT: waveamdmachine.v_cndmask_b32_vcc %arg0, [[SUM]], [[LIVE_VCC]]
  func.func @keeps_mask_across_live_vcc(
      %a: !waveamdmachine.reg<vgpr, 1>,
      %b: !waveamdmachine.reg<vgpr, 1>,
      %zero: !waveamdmachine.reg<vgpr, 1>) {
    %compare_vcc = waveamdmachine.v_cmp_ne_u32_vcc %a, %zero
        : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>)
        -> !waveamdmachine.reg<vcc, 1>
    %mask = waveamdmachine.s_read_vcc_b64 %compare_vcc
        : (!waveamdmachine.reg<vcc, 1>) -> !waveamdmachine.reg<sgpr, 2>
    %sum, %live_vcc = waveamdmachine.v_add_u32_vcc %a, %b
        : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>)
        -> (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vcc, 1>)
    waveamdmachine.exec_if %mask {
      waveamdmachine.yield
    } : !waveamdmachine.reg<sgpr, 2>
    %pick = waveamdmachine.v_cndmask_b32_vcc %a, %sum, %live_vcc
        : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>,
           !waveamdmachine.reg<vcc, 1>) -> !waveamdmachine.reg<vgpr, 1>
    return
  }

  // CHECK-LABEL: func.func @keeps_reused_exec_mask
  // CHECK: [[MASK:%.*]] = waveamdmachine.v_cmp_ne_u32
  // CHECK: waveamdmachine.exec_if [[MASK]]
  // CHECK: waveamdmachine.exec_if [[MASK]]
  // CHECK-NOT: mask_width
  func.func @keeps_reused_exec_mask(
      %a: !waveamdmachine.reg<vgpr, 1>,
      %zero: !waveamdmachine.reg<vgpr, 1>) {
    %vcc = waveamdmachine.v_cmp_ne_u32_vcc %a, %zero
        : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>)
        -> !waveamdmachine.reg<vcc, 1>
    %mask = waveamdmachine.s_read_vcc_b64 %vcc
        : (!waveamdmachine.reg<vcc, 1>) -> !waveamdmachine.reg<sgpr, 2>
    waveamdmachine.exec_if %mask {
      waveamdmachine.yield
    } : !waveamdmachine.reg<sgpr, 2>
    waveamdmachine.exec_if %mask {
      waveamdmachine.yield
    } : !waveamdmachine.reg<sgpr, 2>
    return
  }

  // CHECK-LABEL: func.func @keeps_else_mask_across_vcc_write
  // CHECK: [[MASK:%.*]] = waveamdmachine.v_cmp_ne_u32
  // CHECK-NEXT: waveamdmachine.exec_if [[MASK]]
  // CHECK: waveamdmachine.v_add_u32_vcc
  // CHECK-NOT: mask_width
  func.func @keeps_else_mask_across_vcc_write(
      %a: !waveamdmachine.reg<vgpr, 1>,
      %zero: !waveamdmachine.reg<vgpr, 1>) {
    %vcc0 = waveamdmachine.v_cmp_ne_u32_vcc %a, %zero
        : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>)
        -> !waveamdmachine.reg<vcc, 1>
    %mask = waveamdmachine.s_read_vcc_b64 %vcc0
        : (!waveamdmachine.reg<vcc, 1>) -> !waveamdmachine.reg<sgpr, 2>
    waveamdmachine.exec_if %mask {
      %sum, %vcc1 = waveamdmachine.v_add_u32_vcc %a, %zero
          : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>)
          -> (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vcc, 1>)
      waveamdmachine.yield
    } otherwise {
      waveamdmachine.yield
    } : !waveamdmachine.reg<sgpr, 2>
    return
  }

  // CHECK-LABEL: func.func @direct_vcc_scalar_i64_cmp
  // CHECK: [[VCC:%.*]] = waveamdmachine.v_cmp_ne_u32_vcc
  // CHECK-NEXT: [[CMP:%.*]] = waveamdmachine.s_cmp_eq_u64 [[VCC]], %arg2
  // CHECK-NEXT: waveamdmachine.s_cselect_b32 [[CMP]]
  func.func @direct_vcc_scalar_i64_cmp(
      %a: !waveamdmachine.reg<vgpr, 1>,
      %zero: !waveamdmachine.reg<vgpr, 1>,
      %expected: !waveamdmachine.reg<sgpr, 2>,
      %one: !waveamdmachine.reg<sgpr, 1>,
      %zero_scalar: !waveamdmachine.reg<sgpr, 1>) {
    %vcc = waveamdmachine.v_cmp_ne_u32_vcc %a, %zero
        : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>)
        -> !waveamdmachine.reg<vcc, 1>
    %mask = waveamdmachine.s_read_vcc_b64 %vcc
        : (!waveamdmachine.reg<vcc, 1>) -> !waveamdmachine.reg<sgpr, 2>
    %cmp = waveamdmachine.s_cmp_eq_u64 %mask, %expected
        : (!waveamdmachine.reg<sgpr, 2>, !waveamdmachine.reg<sgpr, 2>)
        -> !waveamdmachine.reg<scc, 1>
    %pick = waveamdmachine.s_cselect_b32 %cmp, %one, %zero_scalar
        : (!waveamdmachine.reg<scc, 1>, !waveamdmachine.reg<sgpr, 1>,
           !waveamdmachine.reg<sgpr, 1>) -> !waveamdmachine.reg<sgpr, 1>
    return
  }

  // CHECK-LABEL: func.func @keeps_vcc_and_copied_mask
  // CHECK: [[VCC:%.*]] = waveamdmachine.v_cmp_ne_u32_vcc
  // CHECK-NEXT: [[MASK:%.*]] = waveamdmachine.s_read_vcc_b64 [[VCC]]
  // CHECK-NEXT: waveamdmachine.v_cndmask_b32_vcc {{.*}}, {{.*}}, [[VCC]]
  // CHECK-NEXT: waveamdmachine.s_cmp_eq_u64 [[MASK]],
  func.func @keeps_vcc_and_copied_mask(
      %a: !waveamdmachine.reg<vgpr, 1>,
      %b: !waveamdmachine.reg<vgpr, 1>,
      %expected: !waveamdmachine.reg<sgpr, 2>) {
    %vcc = waveamdmachine.v_cmp_ne_u32_vcc %a, %b
        : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>)
          -> !waveamdmachine.reg<vcc, 1>
    %mask = waveamdmachine.s_read_vcc_b64 %vcc
        : (!waveamdmachine.reg<vcc, 1>) -> !waveamdmachine.reg<sgpr, 2>
    %pick = waveamdmachine.v_cndmask_b32_vcc %a, %b, %vcc
        : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>,
           !waveamdmachine.reg<vcc, 1>) -> !waveamdmachine.reg<vgpr, 1>
    %cmp = waveamdmachine.s_cmp_eq_u64 %mask, %expected
        : (!waveamdmachine.reg<sgpr, 2>, !waveamdmachine.reg<sgpr, 2>)
          -> !waveamdmachine.reg<scc, 1>
    return
  }

  // CHECK-LABEL: func.func @keeps_scalar_i64_mask_across_live_vcc
  // CHECK: [[MASK:%.*]] = waveamdmachine.v_cmp_ne_u32
  // CHECK-NEXT: [[SUM:%.*]], [[LIVE_VCC:%.*]] = waveamdmachine.v_add_u32_vcc
  // CHECK-NEXT: [[CMP:%.*]] = waveamdmachine.s_cmp_eq_u64 [[MASK]], %arg3
  // CHECK-NEXT: waveamdmachine.s_cselect_b32 [[CMP]]
  // CHECK-NEXT: waveamdmachine.v_cndmask_b32_vcc %arg0, [[SUM]], [[LIVE_VCC]]
  func.func @keeps_scalar_i64_mask_across_live_vcc(
      %a: !waveamdmachine.reg<vgpr, 1>,
      %b: !waveamdmachine.reg<vgpr, 1>,
      %zero: !waveamdmachine.reg<vgpr, 1>,
      %expected: !waveamdmachine.reg<sgpr, 2>,
      %one: !waveamdmachine.reg<sgpr, 1>,
      %zero_scalar: !waveamdmachine.reg<sgpr, 1>) {
    %compare_vcc = waveamdmachine.v_cmp_ne_u32_vcc %a, %zero
        : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>)
        -> !waveamdmachine.reg<vcc, 1>
    %mask = waveamdmachine.s_read_vcc_b64 %compare_vcc
        : (!waveamdmachine.reg<vcc, 1>) -> !waveamdmachine.reg<sgpr, 2>
    %sum, %live_vcc = waveamdmachine.v_add_u32_vcc %a, %b
        : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>)
        -> (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vcc, 1>)
    %cmp = waveamdmachine.s_cmp_eq_u64 %mask, %expected
        : (!waveamdmachine.reg<sgpr, 2>, !waveamdmachine.reg<sgpr, 2>)
        -> !waveamdmachine.reg<scc, 1>
    %pick = waveamdmachine.s_cselect_b32 %cmp, %one, %zero_scalar
        : (!waveamdmachine.reg<scc, 1>, !waveamdmachine.reg<sgpr, 1>,
           !waveamdmachine.reg<sgpr, 1>) -> !waveamdmachine.reg<sgpr, 1>
    %selected =
        waveamdmachine.v_cndmask_b32_vcc %a, %sum, %live_vcc
        : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>,
           !waveamdmachine.reg<vcc, 1>) -> !waveamdmachine.reg<vgpr, 1>
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

  // POST-LABEL: func.func @postschedule_sinks_dma_function
  // POST: [[SUM:%.*]], %{{.*}} = waveamdmachine.s_add_i32
  // POST-NEXT: [[CMP:%.*]] = waveamdmachine.s_cmp_eq_u32
  // POST-NEXT: waveamdmachine.s_cselect_b32 [[CMP]], [[SUM]],
  // POST-NEXT: [[VCC:%.*]] = waveamdmachine.v_cmp_ne_u32_vcc
  // POST-NEXT: waveamdmachine.exec_if [[VCC]]
  // POST: } {mask_width = 64 : i64} : !waveamdmachine.reg<vcc, 1>
  func.func @postschedule_sinks_dma_function(
      %a: !waveamdmachine.reg<sgpr, 1>,
      %b: !waveamdmachine.reg<sgpr, 1>,
      %va: !waveamdmachine.reg<vgpr, 1>,
      %vzero: !waveamdmachine.reg<vgpr, 1>,
      %dep: !waveamdmachine.mem.token,
      %m0: !waveamdmachine.m0) {
    %vcc = waveamdmachine.v_cmp_ne_u32_vcc %va, %vzero
        : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>)
        -> !waveamdmachine.reg<vcc, 1>
    %mask = waveamdmachine.s_read_vcc_b64 %vcc
        : (!waveamdmachine.reg<vcc, 1>) -> !waveamdmachine.reg<sgpr, 2>
    %cmp = waveamdmachine.s_cmp_eq_u32 %a, %b
        : (!waveamdmachine.reg<sgpr, 1>, !waveamdmachine.reg<sgpr, 1>)
        -> !waveamdmachine.reg<scc, 1>
    %sum, %sum_scc = waveamdmachine.s_add_i32 %a, %b
        : (!waveamdmachine.reg<sgpr, 1>, !waveamdmachine.reg<sgpr, 1>)
        -> (!waveamdmachine.reg<sgpr, 1>, !waveamdmachine.reg<scc, 1>)
    %pick = waveamdmachine.s_cselect_b32 %cmp, %sum, %a
        : (!waveamdmachine.reg<scc, 1>, !waveamdmachine.reg<sgpr, 1>,
           !waveamdmachine.reg<sgpr, 1>) -> !waveamdmachine.reg<sgpr, 1>
    waveamdmachine.exec_if %mask {
      waveamdmachine.yield
    } : !waveamdmachine.reg<sgpr, 2>
    %delayed = waveamdmachine.dma_issue_delay %dep, %m0 {cycles = 1 : i64}
        : (!waveamdmachine.mem.token, !waveamdmachine.m0)
          -> !waveamdmachine.m0
    return
  }

  // POST-LABEL: func.func @postschedule_leaves_unrelated_function
  // POST: [[CMP:%.*]] = waveamdmachine.s_cmp_eq_u32
  // POST-NEXT: [[SUM:%.*]], %{{.*}} = waveamdmachine.s_add_i32
  // POST-NEXT: waveamdmachine.s_cselect_b32 [[CMP]], [[SUM]],
  func.func @postschedule_leaves_unrelated_function(
      %a: !waveamdmachine.reg<sgpr, 1>,
      %b: !waveamdmachine.reg<sgpr, 1>) {
    %cmp = waveamdmachine.s_cmp_eq_u32 %a, %b
        : (!waveamdmachine.reg<sgpr, 1>, !waveamdmachine.reg<sgpr, 1>)
        -> !waveamdmachine.reg<scc, 1>
    %sum, %sum_scc = waveamdmachine.s_add_i32 %a, %b
        : (!waveamdmachine.reg<sgpr, 1>, !waveamdmachine.reg<sgpr, 1>)
        -> (!waveamdmachine.reg<sgpr, 1>, !waveamdmachine.reg<scc, 1>)
    %pick = waveamdmachine.s_cselect_b32 %cmp, %sum, %a
        : (!waveamdmachine.reg<scc, 1>, !waveamdmachine.reg<sgpr, 1>,
           !waveamdmachine.reg<sgpr, 1>) -> !waveamdmachine.reg<sgpr, 1>
    return
  }

  // CHECK-LABEL: func.func @keeps_noncompare_vcc_copy_before_clobber
  // CHECK: [[SUM:%.*]], [[SOURCE_VCC:%.*]] = waveamdmachine.v_add_u32_vcc
  // CHECK-NEXT: [[SAVED:%.*]] = waveamdmachine.s_read_vcc_b64 [[SOURCE_VCC]]
  // CHECK-NEXT: [[LATER:%.*]], %{{.*}} = waveamdmachine.v_add_u32_vcc
  // CHECK-NEXT: waveamdmachine.v_cndmask_b32_tuple {{.*}}, [[LATER]], [[SAVED]]
  // POST-LABEL: func.func @keeps_noncompare_vcc_copy_before_clobber
  // POST: [[POST_SUM:%.*]], [[POST_SOURCE_VCC:%.*]] = waveamdmachine.v_add_u32_vcc
  // POST-NEXT: [[POST_SAVED:%.*]] = waveamdmachine.s_read_vcc_b64 [[POST_SOURCE_VCC]]
  // POST-NEXT: [[POST_LATER:%.*]], %{{.*}} = waveamdmachine.v_add_u32_vcc
  // POST-NEXT: waveamdmachine.v_cndmask_b32_tuple {{.*}}, [[POST_LATER]], [[POST_SAVED]]
  func.func @keeps_noncompare_vcc_copy_before_clobber(
      %a: !waveamdmachine.reg<vgpr, 1>,
      %b: !waveamdmachine.reg<vgpr, 1>,
      %dep: !waveamdmachine.mem.token,
      %m0: !waveamdmachine.m0) {
    %sum, %source_vcc = waveamdmachine.v_add_u32_vcc %a, %b
        : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>)
        -> (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vcc, 1>)
    %saved = waveamdmachine.s_read_vcc_b64 %source_vcc
        : (!waveamdmachine.reg<vcc, 1>) -> !waveamdmachine.reg<sgpr, 2>
    %later, %later_vcc = waveamdmachine.v_add_u32_vcc %sum, %b
        : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>)
        -> (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vcc, 1>)
    %pick = waveamdmachine.v_cndmask_b32_tuple %a, %later, %saved
        : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>,
           !waveamdmachine.reg<sgpr, 2>) -> !waveamdmachine.reg<vgpr, 1>
    %delayed = waveamdmachine.dma_issue_delay %dep, %m0 {cycles = 1 : i64}
        : (!waveamdmachine.mem.token, !waveamdmachine.m0)
          -> !waveamdmachine.m0
    return
  }
}
