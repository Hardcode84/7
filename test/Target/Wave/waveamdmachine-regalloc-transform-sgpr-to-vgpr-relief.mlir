// RUN: wave-opt %s --pass-pipeline='builtin.module(transform-preload-library{transform-library-paths=%wave_pipelines},transform-interpreter{entry-point=waveamd_regalloc_transform_loop})' | FileCheck %s --check-prefix=LOOP
// RUN: wave-opt %s --pass-pipeline='builtin.module(transform-preload-library{transform-library-paths=%wave_pipelines},transform-interpreter{entry-point=waveamd_regalloc_transform_loop},waveamd-pack-vgpr-zero-moves,waveamd-resource-info)' | FileCheck %s --check-prefix=POST

module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx950"} {
  // LOOP-LABEL: func.func @target_addressable_sgpr_promotes_to_vgpr(
  // LOOP-SAME: !waveamdmachine.reg<vgpr, 104
  // LOOP-SAME: waveamdmachine.metadata = [{name = "wave.regalloc.iterations", value = 2 : i64}
  // LOOP-SAME: {name = "wave.regalloc.sgpr_to_vgpr.dwords", value = 104 : i64}
  // LOOP-SAME: waveamdmachine.regalloc_assignments
  // LOOP-SAME: stage = "linear-scan-success"
  // LOOP-NOT: linear-scan-failure
  // POST-LABEL: func.func @target_addressable_sgpr_promotes_to_vgpr(
  // POST-SAME: !waveamdmachine.reg<vgpr, 104
  // POST-SAME: waveamdmachine.sgpr_count =
  // POST-SAME: waveamdmachine.vgpr_count =
  func.func @target_addressable_sgpr_promotes_to_vgpr(
      %v: !waveamdmachine.reg<vgpr, 1>,
      %cond: !waveamdmachine.reg<scc, 1>,
      %s: !waveamdmachine.reg<sgpr, 104>)
      -> (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>,
          !waveamdmachine.reg<sgpr, 104>) {
    %loop:2 = waveamdmachine.uniform_loop if %cond
        : !waveamdmachine.reg<scc, 1>
        carries(%v, %v : !waveamdmachine.reg<vgpr, 1>,
                !waveamdmachine.reg<vgpr, 1>) {
    ^bb0(%acc0: !waveamdmachine.reg<vgpr, 1>,
         %acc1: !waveamdmachine.reg<vgpr, 1>):
      waveamdmachine.continue_if %cond : !waveamdmachine.reg<scc, 1>
          carries(%acc0, %acc1 : !waveamdmachine.reg<vgpr, 1>,
                  !waveamdmachine.reg<vgpr, 1>)
    } -> !waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>
    return %loop#0, %loop#1, %s
        : !waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>,
          !waveamdmachine.reg<sgpr, 104>
  }
}
