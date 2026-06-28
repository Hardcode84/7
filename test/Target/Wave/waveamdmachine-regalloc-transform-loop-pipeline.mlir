// RUN: wave-opt %s --pass-pipeline='builtin.module(transform-preload-library{transform-library-paths=%wave_pipelines},transform-interpreter{entry-point=waveamd_regalloc_transform_loop})' | FileCheck %s

module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx1100"} {
  // CHECK-LABEL: func.func private @regalloc_transform_loop_decl
  // CHECK-NOT: waveamdmachine.regalloc_transform_state
  func.func private @regalloc_transform_loop_decl(!waveamdmachine.reg<vgpr, 1>)
      -> !waveamdmachine.reg<vgpr, 1>

  // CHECK-LABEL: func.func @regalloc_transform_loop_mwe
  // CHECK-SAME: !waveamdmachine.reg<vgpr, 1, 0>
  // CHECK-SAME: waveamdmachine.regalloc_assignments
  // CHECK-SAME: waveamdmachine.regalloc_transform_state =
  // CHECK-SAME: assignments = [{base = 0 : i64, class = "vgpr"
  // CHECK-SAME: debug = {alias_edges = 0 : i64, alias_sets = 1 : i64, ops = 1 : i64, values = 1 : i64}
  // CHECK-SAME: stage = "linear-scan-success"
  // CHECK-SAME: values = [{class = "vgpr"
  func.func @regalloc_transform_loop_mwe(
      %arg0: !waveamdmachine.reg<vgpr, 1>) -> !waveamdmachine.reg<vgpr, 1> {
    return %arg0 : !waveamdmachine.reg<vgpr, 1>
  }

  // CHECK-LABEL: func.func @regalloc_transform_loop_aliases
  // CHECK-SAME: !waveamdmachine.reg<vgpr, 2, 0>
  // CHECK-SAME: !waveamdmachine.reg<vgpr, 4, 4>
  // CHECK-SAME: !waveamdmachine.reg<vgpr, 4, 8>
  // CHECK-SAME: !waveamdmachine.reg<vgpr, 4, 12>
  // CHECK-SAME: waveamdmachine.regalloc_assignments
  // CHECK-SAME: waveamdmachine.regalloc_transform_state =
  // CHECK-SAME: assignments = [{base = 0 : i64, class = "vgpr"
  // CHECK-SAME: {base = 4 : i64, class = "vgpr"
  // CHECK-SAME: {base = 8 : i64, class = "vgpr"
  // CHECK-SAME: {base = 12 : i64, class = "vgpr"
  // CHECK-SAME: debug = {alias_edges = 5 : i64, alias_sets = 4 : i64, ops = 4 : i64, values = 8 : i64}
  // CHECK-SAME: name = "waveamdmachine.mfma_f32_16x16x32_f16"
  // CHECK-SAME: stage = "linear-scan-success"
  // CHECK-SAME: offset = 1 : i64
  func.func @regalloc_transform_loop_aliases(
      %wide: !waveamdmachine.reg<vgpr, 2>,
      %a: !waveamdmachine.reg<vgpr, 4>,
      %b: !waveamdmachine.reg<vgpr, 4>,
      %acc: !waveamdmachine.reg<vgpr, 4>) {
    %parts:2 = waveamdmachine.tuple_to_elements %wide
        : (!waveamdmachine.reg<vgpr, 2>)
        -> (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>)
    %tuple = waveamdmachine.tuple_from_elements %parts#0, %parts#1
        : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>)
        -> !waveamdmachine.reg<vgpr, 2>
    %m = waveamdmachine.mfma_f32_16x16x32_f16 %a, %b, %acc
        : (!waveamdmachine.reg<vgpr, 4>, !waveamdmachine.reg<vgpr, 4>,
           !waveamdmachine.reg<vgpr, 4>) -> !waveamdmachine.reg<vgpr, 4>
    return
  }

  // CHECK-LABEL: func.func @regalloc_transform_loop_shared_mfma_acc
  // CHECK-SAME: waveamdmachine.regalloc_transform_state =
  // CHECK-SAME: debug = {alias_edges = 2 : i64, alias_sets = 7 : i64, ops = 5 : i64, values = 9 : i64}
  // CHECK-SAME: name = "waveamdmachine.mfma_f32_16x16x32_f16"
  // CHECK-SAME: stage = "linear-scan-success"
  func.func @regalloc_transform_loop_shared_mfma_acc(
      %a0: !waveamdmachine.reg<vgpr, 4>,
      %b0: !waveamdmachine.reg<vgpr, 4>,
      %a1: !waveamdmachine.reg<vgpr, 4>,
      %b1: !waveamdmachine.reg<vgpr, 4>,
      %acc: !waveamdmachine.reg<vgpr, 4>) {
    %mfma0 = waveamdmachine.mfma_f32_16x16x32_f16 %a0, %b0, %acc
        : (!waveamdmachine.reg<vgpr, 4>, !waveamdmachine.reg<vgpr, 4>,
           !waveamdmachine.reg<vgpr, 4>) -> !waveamdmachine.reg<vgpr, 4>
    %mfma1 = waveamdmachine.mfma_f32_16x16x32_f16 %a1, %b1, %acc
        : (!waveamdmachine.reg<vgpr, 4>, !waveamdmachine.reg<vgpr, 4>,
           !waveamdmachine.reg<vgpr, 4>) -> !waveamdmachine.reg<vgpr, 4>
    return
  }

  // CHECK-LABEL: func.func @regalloc_transform_loop_last_use_mfma_acc
  // CHECK-SAME: waveamdmachine.regalloc_assignments
  // CHECK-SAME: waveamdmachine.regalloc_transform_state =
  // CHECK-SAME: debug = {alias_edges = 5 : i64, alias_sets = 4 : i64, ops = 4 : i64, values = 9 : i64}
  // CHECK-SAME: stage = "linear-scan-success"
  func.func @regalloc_transform_loop_last_use_mfma_acc(
      %a: !waveamdmachine.reg<vgpr, 4>,
      %b: !waveamdmachine.reg<vgpr, 4>,
      %acc: !waveamdmachine.reg<vgpr, 4>)
      attributes {waveamdmachine.vgpr_count_max = 16 : i64} {
    %parts:4 = waveamdmachine.tuple_to_elements %acc
        : (!waveamdmachine.reg<vgpr, 4>)
        -> (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>,
            !waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>)
    %mfma = waveamdmachine.mfma_f32_16x16x32_f16 %a, %b, %acc
        : (!waveamdmachine.reg<vgpr, 4>, !waveamdmachine.reg<vgpr, 4>,
           !waveamdmachine.reg<vgpr, 4>) -> !waveamdmachine.reg<vgpr, 4>
    return
  }

  // CHECK-LABEL: func.func @regalloc_transform_loop_reuses_killed_mfma_acc
  // CHECK-SAME: !waveamdmachine.reg<vgpr, 4, 0>
  // CHECK-SAME: !waveamdmachine.reg<vgpr, 4, 4>
  // CHECK-SAME: !waveamdmachine.reg<vgpr, 4, 8>
  // CHECK-SAME: waveamdmachine.regalloc_assignments
  // CHECK-SAME: stage = "linear-scan-success"
  // CHECK: [[MFMA:%.*]] = waveamdmachine.mfma_f32_16x16x32_f16
  // CHECK-SAME: -> !waveamdmachine.reg<vgpr, 4, 8>
  // CHECK: return [[MFMA]]
  func.func @regalloc_transform_loop_reuses_killed_mfma_acc(
      %a: !waveamdmachine.reg<vgpr, 4>,
      %b: !waveamdmachine.reg<vgpr, 4>,
      %acc: !waveamdmachine.reg<vgpr, 4>)
      -> !waveamdmachine.reg<vgpr, 4>
      attributes {waveamdmachine.vgpr_count_max = 12 : i64} {
    %mfma = waveamdmachine.mfma_f32_16x16x32_f16 %a, %b, %acc
        : (!waveamdmachine.reg<vgpr, 4>, !waveamdmachine.reg<vgpr, 4>,
           !waveamdmachine.reg<vgpr, 4>) -> !waveamdmachine.reg<vgpr, 4>
    return %mfma : !waveamdmachine.reg<vgpr, 4>
  }

  // CHECK-LABEL: func.func @regalloc_transform_loop_rejects_wmma_input_reuse
  // CHECK-NOT: waveamdmachine.regalloc_assignments
  // CHECK-SAME: limit = 24 : i64
  // CHECK-SAME: pressure = 32 : i64
  // CHECK-SAME: stage = "linear-scan-failure"
  func.func @regalloc_transform_loop_rejects_wmma_input_reuse(
      %a: !waveamdmachine.reg<vgpr, 8>,
      %b: !waveamdmachine.reg<vgpr, 8>,
      %acc: !waveamdmachine.reg<vgpr, 8>)
      attributes {waveamdmachine.vgpr_count_max = 24 : i64} {
    %wmma = waveamdmachine.wmma_f32_16x16x16_f16 %a, %b, %acc
        : (!waveamdmachine.reg<vgpr, 8>, !waveamdmachine.reg<vgpr, 8>,
           !waveamdmachine.reg<vgpr, 8>) -> !waveamdmachine.reg<vgpr, 8>
    return
  }

  // CHECK-LABEL: func.func @regalloc_transform_loop_reuses_killed_alu_input
  // CHECK-SAME: waveamdmachine.regalloc_assignments
  // CHECK-SAME: stage = "linear-scan-success"
  // CHECK: [[ZERO:%.*]] = waveamdmachine.imm 0
  // CHECK: [[SEED:%.*]] = waveamdmachine.v_mov_b32_tuple [[ZERO]]
  // CHECK-SAME: -> !waveamdmachine.reg<vgpr, 1, 0>
  // CHECK-NEXT: [[SUM:%.*]] = waveamdmachine.v_add_u32 [[SEED]], [[ZERO]]
  // CHECK-SAME: -> !waveamdmachine.reg<vgpr, 1, 0>
  // CHECK: return [[SUM]]
  func.func @regalloc_transform_loop_reuses_killed_alu_input()
      -> !waveamdmachine.reg<vgpr, 1>
      attributes {waveamdmachine.vgpr_count_max = 1 : i64} {
    %zero = waveamdmachine.imm 0 : !waveamdmachine.imm
    %seed = waveamdmachine.v_mov_b32_tuple %zero {registers = 1 : i64}
        : (!waveamdmachine.imm) -> !waveamdmachine.reg<vgpr, 1>
    %sum = waveamdmachine.v_add_u32 %seed, %zero
        : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.imm)
          -> !waveamdmachine.reg<vgpr, 1>
    return %sum : !waveamdmachine.reg<vgpr, 1>
  }

  // CHECK-LABEL: func.func @regalloc_transform_loop_reuses_killed_scc_input
  // CHECK-SAME: waveamdmachine.regalloc_assignments
  // CHECK-SAME: stage = "linear-scan-success"
  // CHECK: [[ONE:%.*]] = waveamdmachine.imm 1
  // CHECK: [[SEED:%.*]] = waveamdmachine.uninit
  // CHECK-SAME: : !waveamdmachine.reg<sgpr, 1, 0>
  // CHECK-NEXT: [[SUM:%.*]], %{{.*}} = waveamdmachine.s_add_i32 [[SEED]], [[ONE]]
  // CHECK-SAME: -> (!waveamdmachine.reg<sgpr, 1, 0>, !waveamdmachine.reg<scc, 1>)
  // CHECK: return [[SUM]]
  func.func @regalloc_transform_loop_reuses_killed_scc_input()
      -> !waveamdmachine.reg<sgpr, 1>
      attributes {waveamdmachine.sgpr_count_max = 1 : i64} {
    %one = waveamdmachine.imm 1 : !waveamdmachine.imm
    %seed = waveamdmachine.uninit : !waveamdmachine.reg<sgpr, 1>
    %sum, %scc = waveamdmachine.s_add_i32 %seed, %one
        : (!waveamdmachine.reg<sgpr, 1>, !waveamdmachine.imm)
          -> (!waveamdmachine.reg<sgpr, 1>, !waveamdmachine.reg<scc, 1>)
    return %sum : !waveamdmachine.reg<sgpr, 1>
  }

  // CHECK-LABEL: func.func @regalloc_transform_loop_reuses_killed_vcc_input
  // CHECK-SAME: waveamdmachine.regalloc_assignments
  // CHECK-SAME: stage = "linear-scan-success"
  // CHECK: [[ZERO:%.*]] = waveamdmachine.imm 0
  // CHECK: [[SEED:%.*]] = waveamdmachine.v_mov_b32_tuple [[ZERO]]
  // CHECK-SAME: -> !waveamdmachine.reg<vgpr, 1, 0>
  // CHECK-NEXT: [[SUM:%.*]], %{{.*}} = waveamdmachine.v_add_u32_vcc [[SEED]], [[ZERO]]
  // CHECK-SAME: -> (!waveamdmachine.reg<vgpr, 1, 0>, !waveamdmachine.reg<vcc, 1>)
  // CHECK: return [[SUM]]
  func.func @regalloc_transform_loop_reuses_killed_vcc_input()
      -> !waveamdmachine.reg<vgpr, 1>
      attributes {waveamdmachine.vgpr_count_max = 1 : i64} {
    %zero = waveamdmachine.imm 0 : !waveamdmachine.imm
    %seed = waveamdmachine.v_mov_b32_tuple %zero {registers = 1 : i64}
        : (!waveamdmachine.imm) -> !waveamdmachine.reg<vgpr, 1>
    %sum, %vcc = waveamdmachine.v_add_u32_vcc %seed, %zero
        : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.imm)
          -> (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vcc, 1>)
    return %sum : !waveamdmachine.reg<vgpr, 1>
  }

  // CHECK-LABEL: func.func @regalloc_transform_loop_failure
  // CHECK-NOT: waveamdmachine.regalloc_assignments
  // CHECK-SAME: waveamdmachine.regalloc_transform_state =
  // CHECK-SAME: assignments = []
  // CHECK-SAME: failure = {budget_mode = "func_attr", class = "vgpr"
  // CHECK-SAME: limit = 1 : i64
  // CHECK-SAME: overlaps = [{base = 0 : i64, class = "vgpr"
  // CHECK-SAME: position = 0 : i64
  // CHECK-SAME: pressure = 2 : i64
  // CHECK-SAME: reason = "pressure"
  // CHECK-SAME: request = 1 : i64
  // CHECK-SAME: set = 1 : i64
  // CHECK-SAME: stage = "linear-scan-failure"
  func.func @regalloc_transform_loop_failure(
      %a: !waveamdmachine.reg<vgpr, 1>,
      %b: !waveamdmachine.reg<vgpr, 1>)
      -> (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>)
      attributes {waveamdmachine.vgpr_count_max = 1 : i64} {
    return %a, %b : !waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>
  }
}
