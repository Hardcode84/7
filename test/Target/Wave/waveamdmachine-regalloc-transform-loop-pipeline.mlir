// RUN: wave-opt %s --pass-pipeline='builtin.module(transform-preload-library{transform-library-paths=%wave_pipelines},transform-interpreter{entry-point=waveamd_regalloc_transform_loop})' | FileCheck %s

module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx1100"} {
  // CHECK-LABEL: func.func @regalloc_transform_loop_mwe
  // CHECK-SAME: waveamdmachine.regalloc_transform_state = {iteration = 0 : i64, stage = "outer-loop"}
  func.func @regalloc_transform_loop_mwe(
      %arg0: !waveamdmachine.reg<vgpr, 1>) -> !waveamdmachine.reg<vgpr, 1> {
    return %arg0 : !waveamdmachine.reg<vgpr, 1>
  }
}
