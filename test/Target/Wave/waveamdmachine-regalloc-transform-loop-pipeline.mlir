// RUN: wave-opt %s \
// RUN:   --pass-pipeline='builtin.module(transform-preload-library{transform-library-paths=%wave_pipelines},transform-interpreter{entry-point=waveamd_regalloc_transform_loop})' \
// RUN:   | FileCheck %s \
// RUN:       --implicit-check-not=waveamdmachine.regalloc_preparation_tracking \
// RUN:       --implicit-check-not=waveamdmachine.regalloc_preparation_valid

module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx950"} {
  // CHECK-LABEL: func.func private @regalloc_transform_loop_decl
  // CHECK-NOT: waveamdmachine.regalloc_transform_state
  func.func private @regalloc_transform_loop_decl(!waveamdmachine.reg<vgpr, 1>)
      -> !waveamdmachine.reg<vgpr, 1>

  // CHECK-LABEL: func.func @regalloc_transform_loop_mwe
  // CHECK-SAME: !waveamdmachine.reg<vgpr, 1, 0>
  // CHECK-SAME: waveamdmachine.metadata = [{name = "wave.regalloc.iterations", value = 1 : i64}
  // CHECK-SAME: {name = "wave.regalloc.agpr.dwords", value = 0 : i64}
  // CHECK-SAME: {name = "wave.regalloc.remat.dwords", value = 0 : i64}
  // CHECK-SAME: {name = "wave.regalloc.sgpr_to_vgpr.dwords", value = 0 : i64}
  // CHECK-SAME: {name = "wave.regalloc.lds.dwords", value = 0 : i64}
  // CHECK-SAME: {name = "wave.regalloc.scratch.dwords", value = 0 : i64}
  // CHECK-SAME: waveamdmachine.regalloc_assignments
  // CHECK-SAME: waveamdmachine.regalloc_transform_state =
  // CHECK-SAME: assignments = [{base = 0 : i64, class = "vgpr"
  // CHECK-SAME: debug = {alias_edges = 0 : i64, alias_sets = 1 : i64, ops = 1 : i64, values = 1 : i64}
  // CHECK-SAME: packed = #wave.regalloc_state<version = 1
  // CHECK-SAME: values = [1, 0, -1, 0, 0, 0, 1, 0, 0, 0, 2, 0, 1]
  // CHECK-SAME: stage = "linear-scan-success"
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
  // CHECK-SAME: packed = #wave.regalloc_state<version = 1
  // CHECK-SAME: alias_members = [0, 4, 5, 6, 1, 2, 3, 7]
  // CHECK-SAME: stage = "linear-scan-success"
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
  // CHECK-SAME: packed = #wave.regalloc_state<version = 1
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

  // CHECK-LABEL: func.func @regalloc_transform_loop_rejects_vmul_literal_input_reuse
  // CHECK-SAME: waveamdmachine.regalloc_assignments
  // CHECK-SAME: stage = "linear-scan-success"
  // CHECK: [[ZERO:%.*]] = waveamdmachine.imm 0
  // CHECK: [[LITERAL:%.*]] = waveamdmachine.imm 384
  // CHECK: [[SEED:%.*]] = waveamdmachine.v_mov_b32_tuple [[ZERO]]
  // CHECK-SAME: -> !waveamdmachine.reg<vgpr, 1, 0>
  // CHECK-NEXT: [[SUM:%.*]] = waveamdmachine.v_add_u32 [[SEED]], [[ZERO]]
  // CHECK-SAME: -> !waveamdmachine.reg<vgpr, 1, 0>
  // CHECK-NEXT: [[MUL:%.*]] = waveamdmachine.v_mul_lo_u32 [[LITERAL]], [[SUM]]
  // CHECK-SAME: -> !waveamdmachine.reg<vgpr, 1, 1>
  // CHECK: return [[MUL]]
  func.func @regalloc_transform_loop_rejects_vmul_literal_input_reuse()
      -> !waveamdmachine.reg<vgpr, 1>
      attributes {waveamdmachine.vgpr_count_max = 2 : i64} {
    %zero = waveamdmachine.imm 0 : !waveamdmachine.imm
    %literal = waveamdmachine.imm 384 : !waveamdmachine.imm
    %seed = waveamdmachine.v_mov_b32_tuple %zero {registers = 1 : i64}
        : (!waveamdmachine.imm) -> !waveamdmachine.reg<vgpr, 1>
    %sum = waveamdmachine.v_add_u32 %seed, %zero
        : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.imm)
          -> !waveamdmachine.reg<vgpr, 1>
    %mul = waveamdmachine.v_mul_lo_u32 %literal, %sum
        : (!waveamdmachine.imm, !waveamdmachine.reg<vgpr, 1>)
          -> !waveamdmachine.reg<vgpr, 1>
    return %mul : !waveamdmachine.reg<vgpr, 1>
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

  // CHECK-LABEL: func.func @regalloc_transform_loop_splits_shared_required_killed_input
  // CHECK-SAME: waveamdmachine.regalloc_assignments
  // CHECK-SAME: stage = "linear-scan-success"
  // CHECK: [[ZERO:%.*]] = waveamdmachine.imm 0
  // CHECK: [[SEED:%.*]] = waveamdmachine.v_mov_b32_tuple [[ZERO]]
  // CHECK-SAME: -> !waveamdmachine.reg<vgpr, 1, [[SEED_REG:[0-9]+]]>
  // CHECK: [[SPLIT:%.*]] = waveamdmachine.v_mov_b32_tuple [[ZERO]]
  // CHECK-SAME: -> !waveamdmachine.reg<vgpr, 1, [[SPLIT_REG:[0-9]+]]>
  // CHECK-NEXT: [[HI0:%.*]], %{{.*}} = waveamdmachine.buffer_load_u8_d16_hi {{.*}}, [[SPLIT]],
  // CHECK-SAME: -> (!waveamdmachine.reg<vgpr, 1, [[SPLIT_REG]]>, !waveamdmachine.mem.token)
  // CHECK-NEXT: [[HI1:%.*]], %{{.*}} = waveamdmachine.buffer_load_u8_d16_hi {{.*}}, [[SEED]],
  // CHECK-SAME: -> (!waveamdmachine.reg<vgpr, 1, [[SEED_REG]]>, !waveamdmachine.mem.token)
  // CHECK: waveamdmachine.v_or_b32 [[HI0]], [[HI1]]
  func.func @regalloc_transform_loop_splits_shared_required_killed_input(
      %off0: !waveamdmachine.reg<vgpr, 1>,
      %off1: !waveamdmachine.reg<vgpr, 1>,
      %desc: !waveamdmachine.reg<sgpr, 4>)
      attributes {waveamdmachine.vgpr_count_max = 6 : i64} {
    %zero = waveamdmachine.imm 0 : !waveamdmachine.imm
    %seed = waveamdmachine.v_mov_b32_tuple %zero {registers = 1 : i64}
        : (!waveamdmachine.imm) -> !waveamdmachine.reg<vgpr, 1>
    %hi0, %tok0 = waveamdmachine.buffer_load_u8_d16_hi
        %off0, %seed, %desc, %zero
        : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>,
           !waveamdmachine.reg<sgpr, 4>, !waveamdmachine.imm)
        -> (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.mem.token)
    %hi1, %tok1 = waveamdmachine.buffer_load_u8_d16_hi
        %off1, %seed, %desc, %zero offset 1
        : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>,
           !waveamdmachine.reg<sgpr, 4>, !waveamdmachine.imm)
        -> (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.mem.token)
    %packed = waveamdmachine.v_or_b32 %hi0, %hi1
        : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>)
        -> !waveamdmachine.reg<vgpr, 1>
    return
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
