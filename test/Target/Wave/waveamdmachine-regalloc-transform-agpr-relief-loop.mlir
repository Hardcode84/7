// RUN: wave-opt %s --pass-pipeline='builtin.module(transform-preload-library{transform-library-paths=%wave_pipelines},transform-interpreter{entry-point=waveamd_regalloc_transform_loop})' | FileCheck %s

module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx950"} {
  // CHECK-LABEL: func.func @regalloc_transform_loop_entry_failure_not_agpr_relief(
  // CHECK-SAME: waveamdmachine.regalloc_transform_state =
  // CHECK-SAME: position = 0 : i64
  // CHECK-SAME: stage = "linear-scan-failure"
  // CHECK-NOT: waveamdmachine.v_accvgpr_write_b32_tuple
  // CHECK-NOT: waveamdmachine.v_accvgpr_read_b32_tuple
  // CHECK: return
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
