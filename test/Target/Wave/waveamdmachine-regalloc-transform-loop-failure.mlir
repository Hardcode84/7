// RUN: not wave-opt %s --pass-pipeline='builtin.module(transform-preload-library{transform-library-paths=%wave_pipelines},transform-interpreter{entry-point=waveamd_regalloc_transform_loop debug-payload-root-tag=wmma})' 2>&1 | FileCheck %s --check-prefix=WMMA
// RUN: not wave-opt %s --pass-pipeline='builtin.module(transform-preload-library{transform-library-paths=%wave_pipelines},transform-interpreter{entry-point=waveamd_regalloc_transform_loop debug-payload-root-tag=pressure})' 2>&1 | FileCheck %s --check-prefix=PRESSURE

module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx950"} {
  // WMMA: regalloc stalled in @regalloc_transform_loop_rejects_wmma_input_reuse:
  // WMMA-SAME: class=vgpr reason=pressure set=3 position=0
  // WMMA-SAME: pressure=32 request=8 limit=24
  func.func @regalloc_transform_loop_rejects_wmma_input_reuse(
      %a: !waveamdmachine.reg<vgpr, 8>,
      %b: !waveamdmachine.reg<vgpr, 8>,
      %acc: !waveamdmachine.reg<vgpr, 8>)
      attributes {transform.target_tag = "wmma",
                  waveamdmachine.vgpr_count_max = 24 : i64} {
    %wmma = waveamdmachine.wmma_f32_16x16x16_f16 %a, %b, %acc
        : (!waveamdmachine.reg<vgpr, 8>, !waveamdmachine.reg<vgpr, 8>,
           !waveamdmachine.reg<vgpr, 8>) -> !waveamdmachine.reg<vgpr, 8>
    return
  }

  // PRESSURE: regalloc stalled in @regalloc_transform_loop_failure:
  // PRESSURE-SAME: class=vgpr reason=pressure set=1 position=0
  // PRESSURE-SAME: pressure=2 request=1 limit=1
  func.func @regalloc_transform_loop_failure(
      %a: !waveamdmachine.reg<vgpr, 1>,
      %b: !waveamdmachine.reg<vgpr, 1>)
      -> (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>)
      attributes {transform.target_tag = "pressure",
                  waveamdmachine.vgpr_count_max = 1 : i64} {
    return %a, %b : !waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>
  }
}
