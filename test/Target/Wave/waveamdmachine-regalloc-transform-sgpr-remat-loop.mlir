// RUN: wave-opt --split-input-file %s --pass-pipeline='builtin.module(transform-preload-library{transform-library-paths=%wave_pipelines},transform-interpreter{entry-point=waveamd_regalloc_transform_loop})' | FileCheck %s

module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx950"} {
  // CHECK-LABEL: func.func @regalloc_transform_loop_remats_sgpr_address(
  // CHECK-SAME: [[STRIDE:%[^:]+]]: !waveamdmachine.reg<sgpr, 1,
  // CHECK-SAME: {name = "wave.regalloc.remat.dwords", value = {{[1-9][0-9]*}} : i64}
  // CHECK-SAME: {name = "wave.regalloc.sgpr_to_vgpr.dwords", value = 0 : i64}
  // CHECK-SAME: waveamdmachine.regalloc_assignments
  // CHECK-SAME: stage = "linear-scan-success"
  // CHECK-NOT: waveamdmachine.v_mov_b32_tuple
  // CHECK-NOT: waveamdmachine.v_readfirstlane_b32
  // CHECK: waveamdmachine.uniform_loop
  // CHECK-NOT: waveamdmachine.v_mov_b32_tuple
  // CHECK-NOT: waveamdmachine.v_readfirstlane_b32
  // CHECK: [[PROD:%.*]] = waveamdmachine.s_mul_i32 [[STRIDE]]
  // CHECK-SAME: waveamdmachine.regalloc_remat_temp
  // CHECK-NEXT: [[ADDR:%.*]], %{{.*}} = waveamdmachine.s_add_i32 [[PROD]]
  // CHECK-SAME: waveamdmachine.regalloc_remat_temp
  // CHECK-NEXT: [[USE:%.*]], %{{.*}} = waveamdmachine.s_add_i32 [[ADDR]]
  // CHECK-NOT: waveamdmachine.v_mov_b32_tuple
  // CHECK-NOT: waveamdmachine.v_readfirstlane_b32
  // CHECK: return [[STRIDE]], [[USE]]
  func.func @regalloc_transform_loop_remats_sgpr_address(
      %stride: !waveamdmachine.reg<sgpr, 1>)
      -> (!waveamdmachine.reg<sgpr, 1>, !waveamdmachine.reg<sgpr, 1>)
      attributes {waveamdmachine.sgpr_count_max = 3 : i64,
                  waveamdmachine.vgpr_count_max = 4 : i64,
                  waveamdmachine.agpr_count_max = 0 : i64} {
    %zero = waveamdmachine.imm 0 : !waveamdmachine.imm
    %one = waveamdmachine.imm 1 : !waveamdmachine.imm
    %two = waveamdmachine.imm 2 : !waveamdmachine.imm
    %prod = waveamdmachine.s_mul_i32 %stride, %two
        : (!waveamdmachine.reg<sgpr, 1>, !waveamdmachine.imm)
          -> !waveamdmachine.reg<sgpr, 1>
    %addr, %scc0 = waveamdmachine.s_add_i32 %prod, %one
        : (!waveamdmachine.reg<sgpr, 1>, !waveamdmachine.imm)
          -> (!waveamdmachine.reg<sgpr, 1>, !waveamdmachine.reg<scc, 1>)
    %cond = waveamdmachine.s_cmp_lt_i32 %zero, %one
        : (!waveamdmachine.imm, !waveamdmachine.imm)
          -> !waveamdmachine.reg<scc, 1>
    waveamdmachine.uniform_loop if %cond : !waveamdmachine.reg<scc, 1> {
      %a = waveamdmachine.uninit : !waveamdmachine.reg<sgpr, 1>
      %b = waveamdmachine.uninit : !waveamdmachine.reg<sgpr, 1>
      %c = waveamdmachine.uninit : !waveamdmachine.reg<sgpr, 1>
      %ab, %scc1 = waveamdmachine.s_add_i32 %a, %b
          : (!waveamdmachine.reg<sgpr, 1>, !waveamdmachine.reg<sgpr, 1>)
            -> (!waveamdmachine.reg<sgpr, 1>,
                !waveamdmachine.reg<scc, 1>)
      %sum, %scc2 = waveamdmachine.s_add_i32 %ab, %c
          : (!waveamdmachine.reg<sgpr, 1>, !waveamdmachine.reg<sgpr, 1>)
            -> (!waveamdmachine.reg<sgpr, 1>,
                !waveamdmachine.reg<scc, 1>)
      waveamdmachine.continue_if %cond : !waveamdmachine.reg<scc, 1>
    }
    %use, %scc3 = waveamdmachine.s_add_i32 %addr, %one
        : (!waveamdmachine.reg<sgpr, 1>, !waveamdmachine.imm)
          -> (!waveamdmachine.reg<sgpr, 1>, !waveamdmachine.reg<scc, 1>)
    return %stride, %use
        : !waveamdmachine.reg<sgpr, 1>, !waveamdmachine.reg<sgpr, 1>
  }
}
