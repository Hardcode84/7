// RUN: wave-opt %s --pass-pipeline='builtin.module(transform-preload-library{transform-library-paths=%wave_pipelines},transform-interpreter{entry-point=waveamd_backend})' | FileCheck %s

module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx950", wavemeta.params = {}} {
  func.func @load_source_dialects(%ptr: !wave.ptr<#wave.global, i32>,
                                  %range: i32) {
    %lane = wave.lane_id : !wave.simd<i32, 64>
    %buffer = waveamd.make_buffer %ptr, %range
        : !wave.ptr<#wave.global, i32>, i32 -> !wave.ptr<#waveamd.buffer, i32>
    return
  }

  // CHECK-LABEL: func.func @vcc_gap_survives_regalloc
  // CHECK: {{^ *}}%{{.*}}, %{{.*}} = waveamdmachine.v_cmp_ge_u32_vcc
  // CHECK-NEXT: {{^ *}}%{{.*}} = waveamdmachine.v_add_u32
  // CHECK-NEXT: {{^ *}}%{{.*}} = waveamdmachine.v_xor_b32
  // CHECK-NEXT: {{^ *}}%{{.*}} = waveamdmachine.v_cndmask_b32_vcc
  func.func @vcc_gap_survives_regalloc(
      %a: !waveamdmachine.reg<vgpr, 1>,
      %b: !waveamdmachine.reg<vgpr, 1>,
      %limit: !waveamdmachine.reg<vgpr, 1>)
      -> (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>)
      attributes {waveamdmachine.schedule_input} {
    %mask, %vcc = waveamdmachine.v_cmp_ge_u32_vcc %a, %limit
        : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>)
          -> (!waveamdmachine.reg<sgpr, 2>, !waveamdmachine.reg<vcc, 1>)
    %sum = waveamdmachine.v_add_u32 %a, %b
        : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>)
          -> !waveamdmachine.reg<vgpr, 1>
    %flipped = waveamdmachine.v_xor_b32 %a, %b
        : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>)
          -> !waveamdmachine.reg<vgpr, 1>
    %pick = waveamdmachine.v_cndmask_b32_vcc %a, %sum, %vcc
        : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>,
           !waveamdmachine.reg<vcc, 1>) -> !waveamdmachine.reg<vgpr, 1>
    return %pick, %flipped
        : !waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>
  }
}
