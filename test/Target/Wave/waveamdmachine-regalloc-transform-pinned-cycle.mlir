// RUN: not wave-opt %s --pass-pipeline='builtin.module(transform-preload-library{transform-library-paths=%wave_pipelines},transform-interpreter{entry-point=waveamd_regalloc_transform_loop})' 2>&1 | FileCheck %s

// CHECK: regalloc stalled in @regalloc_transform_loop_stops_pinned_promotion_cycle:
// CHECK-SAME: class=vgpr reason=pressure set=3 position=1
// CHECK-SAME: pressure=3 request=1 limit=2

module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx950"} {
  func.func @regalloc_transform_loop_stops_pinned_promotion_cycle(
      %long: !waveamdmachine.reg<vgpr, 1>,
      %dies: !waveamdmachine.reg<vgpr, 1>,
      %sg: !waveamdmachine.reg<sgpr, 1>)
      -> (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>)
      attributes {waveamdmachine.vgpr_count_max = 2 : i64,
                  waveamdmachine.agpr_count_max = 0 : i64} {
    %zero = waveamdmachine.imm 0 : !waveamdmachine.imm
    %promoted = waveamdmachine.v_mov_b32_tuple %sg
        {waveamdmachine.regalloc_sgpr_to_vgpr_pinned,
         waveamdmachine.regalloc_sgpr_to_vgpr_temp}
        : (!waveamdmachine.reg<sgpr, 1>) -> !waveamdmachine.reg<vgpr, 1>
    %root = waveamdmachine.v_add_u32 %promoted, %zero
        : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.imm)
          -> !waveamdmachine.reg<vgpr, 1>
    %drop = waveamdmachine.v_add_u32 %dies, %zero
        : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.imm)
          -> !waveamdmachine.reg<vgpr, 1>
    %use = waveamdmachine.v_add_u32 %root, %zero
        : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.imm)
          -> !waveamdmachine.reg<vgpr, 1>
    return %long, %use
        : !waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>
  }
}
