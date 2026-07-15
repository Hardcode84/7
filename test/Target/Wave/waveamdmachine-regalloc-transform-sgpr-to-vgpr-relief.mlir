// RUN: wave-opt --split-input-file %s --pass-pipeline='builtin.module(transform-preload-library{transform-library-paths=%wave_pipelines},transform-interpreter{entry-point=waveamd_regalloc_transform_loop})' | FileCheck %s --check-prefix=LOOP
// RUN: wave-opt --split-input-file %s --pass-pipeline='builtin.module(transform-preload-library{transform-library-paths=%wave_pipelines},transform-interpreter{entry-point=waveamd_regalloc_transform_loop},waveamd-pack-vgpr-zero-moves,waveamd-resource-info)' | FileCheck %s --check-prefix=POST

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

// -----

module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx950"} {
  // LOOP-LABEL: func.func @mixed_canonical_sunk_sgpr_alias(
  // LOOP-SAME: waveamdmachine.metadata = [{name = "wave.regalloc.iterations", value = 2 : i64}
  // LOOP-SAME: {name = "wave.regalloc.sgpr_to_vgpr.dwords", value = 2 : i64}
  // LOOP-NOT: linear-scan-failure
  // LOOP: [[PARTS:%.*]]:2 = waveamdmachine.tuple_to_elements %{{.*}} {waveamdmachine.regalloc_remat_temp}
  // LOOP-NEXT: [[P1:%.*]] = waveamdmachine.v_mov_b32_tuple [[PARTS]]#1
  // LOOP-SAME: waveamdmachine.regalloc_sgpr_to_vgpr_pinned
  // LOOP-NEXT: [[P0:%.*]] = waveamdmachine.v_mov_b32_tuple [[PARTS]]#0
  // LOOP-SAME: waveamdmachine.regalloc_sgpr_to_vgpr_pinned
  // LOOP-NEXT: [[FIXED:%.*]] = waveamdmachine.uninit
  // LOOP: waveamdmachine.v_add_u32 [[P0]], [[P1]]
  // LOOP-NOT: waveamdmachine.regalloc_sgpr_to_vgpr_temp
  // LOOP: waveamdmachine.s_endpgm
  // POST-LABEL: func.func @mixed_canonical_sunk_sgpr_alias(
  // POST-SAME: waveamdmachine.sgpr_count =
  // POST-SAME: waveamdmachine.vgpr_count =
  func.func @mixed_canonical_sunk_sgpr_alias()
      attributes {wave.kernel, wave.workgroup_size = array<i32: 64, 1, 1>,
                  waveamdmachine.sgpr_count_max = 2 : i64,
                  waveamdmachine.vgpr_count_max = 16 : i64,
                  waveamdmachine.agpr_count_max = 0 : i64} {
    %src = waveamdmachine.uninit {waveamdmachine.regalloc_remat_temp}
        : !waveamdmachine.reg<sgpr, 2>
    %parts:2 = waveamdmachine.tuple_to_elements %src
        {waveamdmachine.regalloc_remat_temp}
        : (!waveamdmachine.reg<sgpr, 2>)
          -> (!waveamdmachine.reg<sgpr, 1>, !waveamdmachine.reg<sgpr, 1>)
    %canonical = waveamdmachine.v_mov_b32_tuple %parts#0
        {waveamdmachine.regalloc_remat_temp,
         waveamdmachine.regalloc_sgpr_to_vgpr_temp}
        : (!waveamdmachine.reg<sgpr, 1>) -> !waveamdmachine.reg<vgpr, 1>
    %fixed = waveamdmachine.uninit : !waveamdmachine.reg<sgpr, 2, 0>
    %sunk = waveamdmachine.v_mov_b32_tuple %parts#1
        {waveamdmachine.regalloc_remat_temp,
         waveamdmachine.regalloc_sgpr_to_vgpr_temp}
        : (!waveamdmachine.reg<sgpr, 1>) -> !waveamdmachine.reg<vgpr, 1>
    %duplicate = waveamdmachine.v_mov_b32_tuple %parts#1
        {waveamdmachine.regalloc_remat_temp,
         waveamdmachine.regalloc_sgpr_to_vgpr_temp}
        : (!waveamdmachine.reg<sgpr, 1>) -> !waveamdmachine.reg<vgpr, 1>
    %sum = waveamdmachine.v_add_u32 %canonical, %duplicate
        : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>)
          -> !waveamdmachine.reg<vgpr, 1>
    %fixedV = waveamdmachine.v_mov_b32_tuple %fixed
        : (!waveamdmachine.reg<sgpr, 2, 0>) -> !waveamdmachine.reg<vgpr, 2>
    waveamdmachine.s_endpgm
    return
  }
}

// -----

module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx950"} {
  // LOOP-LABEL: func.func @mixed_sunk_sgpr_alias_with_gap(
  // LOOP-SAME: waveamdmachine.metadata = [{name = "wave.regalloc.iterations", value = 2 : i64}
  // LOOP-SAME: {name = "wave.regalloc.sgpr_to_vgpr.dwords", value = 2 : i64}
  // LOOP-NOT: linear-scan-failure
  // LOOP-COUNT-2: waveamdmachine.regalloc_sgpr_to_vgpr_pinned
  // POST-LABEL: func.func @mixed_sunk_sgpr_alias_with_gap(
  // POST-SAME: waveamdmachine.sgpr_count =
  // POST-SAME: waveamdmachine.vgpr_count =
  func.func @mixed_sunk_sgpr_alias_with_gap()
      attributes {wave.kernel, wave.workgroup_size = array<i32: 64, 1, 1>,
                  waveamdmachine.sgpr_count_max = 2 : i64,
                  waveamdmachine.vgpr_count_max = 16 : i64,
                  waveamdmachine.agpr_count_max = 0 : i64} {
    %src = waveamdmachine.uninit {waveamdmachine.regalloc_remat_temp}
        : !waveamdmachine.reg<sgpr, 2>
    %parts:2 = waveamdmachine.tuple_to_elements %src
        {waveamdmachine.regalloc_remat_temp}
        : (!waveamdmachine.reg<sgpr, 2>)
          -> (!waveamdmachine.reg<sgpr, 1>, !waveamdmachine.reg<sgpr, 1>)
    %gap = waveamdmachine.imm 0 : !waveamdmachine.imm
    %first = waveamdmachine.v_mov_b32_tuple %parts#0
        {waveamdmachine.regalloc_remat_temp,
         waveamdmachine.regalloc_sgpr_to_vgpr_temp}
        : (!waveamdmachine.reg<sgpr, 1>) -> !waveamdmachine.reg<vgpr, 1>
    %fixed = waveamdmachine.uninit : !waveamdmachine.reg<sgpr, 2, 0>
    %second = waveamdmachine.v_mov_b32_tuple %parts#1
        {waveamdmachine.regalloc_remat_temp,
         waveamdmachine.regalloc_sgpr_to_vgpr_temp}
        : (!waveamdmachine.reg<sgpr, 1>) -> !waveamdmachine.reg<vgpr, 1>
    %fixedV = waveamdmachine.v_mov_b32_tuple %fixed
        : (!waveamdmachine.reg<sgpr, 2, 0>) -> !waveamdmachine.reg<vgpr, 2>
    waveamdmachine.s_endpgm
    return
  }
}

// -----

module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx950"} {
  // LOOP-LABEL: func.func @sgpr_pressure_overage_promotes_bundle(
  // LOOP-SAME: waveamdmachine.metadata = [{name = "wave.regalloc.iterations", value = 2 : i64}
  // LOOP-SAME: {name = "wave.regalloc.sgpr_to_vgpr.dwords", value = 2 : i64}
  // LOOP-NOT: linear-scan-failure
  // POST-LABEL: func.func @sgpr_pressure_overage_promotes_bundle(
  // POST-SAME: waveamdmachine.sgpr_count =
  // POST-SAME: waveamdmachine.vgpr_count =
  func.func @sgpr_pressure_overage_promotes_bundle()
      attributes {wave.kernel, wave.workgroup_size = array<i32: 64, 1, 1>,
                  waveamdmachine.sgpr_count_max = 4 : i64,
                  waveamdmachine.vgpr_count_max = 16 : i64,
                  waveamdmachine.agpr_count_max = 0 : i64} {
    %fixed = waveamdmachine.uninit
        : !waveamdmachine.reg<sgpr, 2, 0>
    %a = waveamdmachine.uninit {waveamdmachine.regalloc_remat_temp}
        : !waveamdmachine.reg<sgpr, 1>
    %b = waveamdmachine.uninit {waveamdmachine.regalloc_remat_temp}
        : !waveamdmachine.reg<sgpr, 1>
    %blocked = waveamdmachine.uninit {waveamdmachine.regalloc_remat_temp}
        : !waveamdmachine.reg<sgpr, 2>
    %blockedV = waveamdmachine.v_mov_b32_tuple %blocked
        {waveamdmachine.regalloc_sgpr_to_vgpr_temp}
        : (!waveamdmachine.reg<sgpr, 2>) -> !waveamdmachine.reg<vgpr, 2>
    %fixedV = waveamdmachine.v_mov_b32_tuple %fixed
        : (!waveamdmachine.reg<sgpr, 2, 0>) -> !waveamdmachine.reg<vgpr, 2>
    %aV = waveamdmachine.v_mov_b32_tuple %a
        : (!waveamdmachine.reg<sgpr, 1>) -> !waveamdmachine.reg<vgpr, 1>
    %bV = waveamdmachine.v_mov_b32_tuple %b
        : (!waveamdmachine.reg<sgpr, 1>) -> !waveamdmachine.reg<vgpr, 1>
    waveamdmachine.s_endpgm
    return
  }
}
