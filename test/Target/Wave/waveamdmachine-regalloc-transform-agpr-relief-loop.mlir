// RUN: not wave-opt %s --pass-pipeline='builtin.module(transform-preload-library{transform-library-paths=%wave_pipelines},transform-interpreter{entry-point=waveamd_regalloc_transform_loop})' 2>&1 | FileCheck %s

module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx950"} {
  // CHECK: regalloc stalled in @regalloc_transform_loop_entry_failure_not_agpr_relief:
  // CHECK-SAME: class=vgpr reason=pressure set=1 position=0
  // CHECK-SAME: pressure=2 request=1 limit=1
  func.func @regalloc_transform_loop_entry_failure_not_agpr_relief(
      %a: !waveamdmachine.reg<vgpr, 1>,
      %b: !waveamdmachine.reg<vgpr, 1>)
      -> (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>)
      attributes {waveamdmachine.vgpr_count_max = 1 : i64,
                  waveamdmachine.agpr_count_max = 4 : i64} {
    return %a, %b
        : !waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>
  }
}
