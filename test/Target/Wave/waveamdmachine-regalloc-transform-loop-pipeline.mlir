// RUN: wave-opt %s --pass-pipeline='builtin.module(transform-preload-library{transform-library-paths=%wave_pipelines},transform-interpreter{entry-point=waveamd_regalloc_transform_loop})' | FileCheck %s

module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx1100"} {
  // CHECK-LABEL: func.func @regalloc_transform_loop_mwe
  // CHECK-SAME: waveamdmachine.regalloc_transform_state =
  // CHECK-SAME: debug = {alias_edges = 0 : i64, alias_sets = 1 : i64, ops = 1 : i64, values = 1 : i64}
  // CHECK-SAME: stage = "alias-state"
  // CHECK-SAME: values = [{class = "vgpr"
  func.func @regalloc_transform_loop_mwe(
      %arg0: !waveamdmachine.reg<vgpr, 1>) -> !waveamdmachine.reg<vgpr, 1> {
    return %arg0 : !waveamdmachine.reg<vgpr, 1>
  }

  // CHECK-LABEL: func.func @regalloc_transform_loop_aliases
  // CHECK-SAME: waveamdmachine.regalloc_transform_state =
  // CHECK-SAME: debug = {alias_edges = 5 : i64, alias_sets = 4 : i64, ops = 4 : i64, values = 8 : i64}
  // CHECK-SAME: name = "waveamdmachine.mfma_f32_16x16x32_f16"
  // CHECK-SAME: stage = "alias-state"
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
}
