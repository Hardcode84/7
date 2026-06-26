// RUN: wave-opt %s --pass-pipeline='builtin.module(transform-preload-library{transform-library-paths=%wave_pipelines},transform-interpreter{entry-point=waveamd_regalloc_transform_loop})' | FileCheck %s

module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx1100"} {
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
  // CHECK-SAME: !waveamdmachine.reg<vgpr, 4, 2>
  // CHECK-SAME: !waveamdmachine.reg<vgpr, 4, 6>
  // CHECK-SAME: !waveamdmachine.reg<vgpr, 4, 10>
  // CHECK-SAME: waveamdmachine.regalloc_assignments
  // CHECK-SAME: waveamdmachine.regalloc_transform_state =
  // CHECK-SAME: assignments = [{base = 0 : i64, class = "vgpr"
  // CHECK-SAME: {base = 2 : i64, class = "vgpr"
  // CHECK-SAME: {base = 6 : i64, class = "vgpr"
  // CHECK-SAME: {base = 10 : i64, class = "vgpr"
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
  // CHECK-SAME: debug = {alias_edges = 0 : i64, alias_sets = 7 : i64, ops = 3 : i64, values = 7 : i64}
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
