// RUN: wave-opt %s --pass-pipeline='builtin.module(transform-preload-library{transform-library-paths=%wave_pipelines},transform-interpreter{entry-point=waveamd_regalloc_transform_loop})' | FileCheck %s

module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx950"} {
  // CHECK-LABEL: func.func @regalloc_transform_loop_remat_rebuilds_after_pressure(
  // CHECK-SAME: waveamdmachine.regalloc_assignments
  // CHECK-SAME: waveamdmachine.regalloc_transform_state =
  // CHECK-SAME: stage = "linear-scan-success"
  // CHECK-NOT: scratch_spill_bytes
  // CHECK: waveamdmachine.uniform_loop
  // CHECK: waveamdmachine.v_mov_b32_tuple
  // CHECK-NEXT: waveamdmachine.v_add_u32
  // CHECK: return
  func.func @regalloc_transform_loop_remat_rebuilds_after_pressure()
      -> !waveamdmachine.reg<vgpr, 1>
      attributes {waveamdmachine.vgpr_count_max = 3 : i64,
                  waveamdmachine.agpr_count_max = 0 : i64} {
    %zero = waveamdmachine.imm 0 : !waveamdmachine.imm
    %one = waveamdmachine.imm 1 : !waveamdmachine.imm
    %seed = waveamdmachine.v_mov_b32_tuple %zero {registers = 1 : i64}
        : (!waveamdmachine.imm) -> !waveamdmachine.reg<vgpr, 1>
    %root = waveamdmachine.v_add_u32 %seed, %one
        : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.imm)
          -> !waveamdmachine.reg<vgpr, 1>
    %cond = waveamdmachine.s_cmp_lt_i32 %zero, %one
        : (!waveamdmachine.imm, !waveamdmachine.imm)
          -> !waveamdmachine.reg<scc, 1>
    waveamdmachine.uniform_loop if %cond : !waveamdmachine.reg<scc, 1> {
      %a = waveamdmachine.uninit : !waveamdmachine.reg<vgpr, 1>
      %b = waveamdmachine.uninit : !waveamdmachine.reg<vgpr, 1>
      %sum = waveamdmachine.v_add_u32 %a, %b
          : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>)
            -> !waveamdmachine.reg<vgpr, 1>
      waveamdmachine.continue_if %cond : !waveamdmachine.reg<scc, 1>
    }
    %use0 = waveamdmachine.v_add_u32 %root, %zero
        : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.imm)
          -> !waveamdmachine.reg<vgpr, 1>
    %use1 = waveamdmachine.v_add_u32 %root, %one
        : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.imm)
          -> !waveamdmachine.reg<vgpr, 1>
    return %use1 : !waveamdmachine.reg<vgpr, 1>
  }
}
