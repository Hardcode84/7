// RUN: wave-opt %s --pass-pipeline='builtin.module(transform-preload-library{transform-library-paths=%wave_pipelines},transform-interpreter{entry-point=waveamd_regalloc_transform_loop})' | FileCheck %s

module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx950"} {
  // CHECK-LABEL: func.func @agpr_relief_retries_wider_request(
  // CHECK-SAME: waveamdmachine.metadata = [{name = "wave.regalloc.iterations", value = 3 : i64}
  // CHECK-SAME: {name = "wave.regalloc.agpr.dwords", value = 4 : i64}
  // CHECK-SAME: {name = "wave.regalloc.remat.dwords", value = 8 : i64}
  // CHECK-SAME: waveamdmachine.regalloc_assignments
  // CHECK-SAME: stage = "linear-scan-success"
  // CHECK-NOT: waveamdmachine.v_accvgpr_{{read|write}}_b32_tuple
  // CHECK: [[LOAD:%.*]], [[TOK:%.*]] = waveamdmachine.ds_load_b128
  // CHECK-SAME: -> (!waveamdmachine.reg<agpr, 4, {{[0-9]+}}>, !waveamdmachine.mem.token)
  // CHECK: waveamdmachine.ds_store_b128 {{%.*}}, [[LOAD]] after [[TOK]]
  // CHECK-SAME: !waveamdmachine.reg<agpr, 4, {{[0-9]+}}>
  func.func @agpr_relief_retries_wider_request()
      -> !waveamdmachine.reg<vgpr, 8>
      attributes {waveamdmachine.vgpr_count_max = 12 : i64,
                  waveamdmachine.agpr_count_max = 256 : i64,
                  waveamdmachine.target_waves = 1 : i64} {
    %addr = waveamdmachine.uninit : !waveamdmachine.reg<vgpr, 1, 0>
    %dep = waveamdmachine.token : !waveamdmachine.mem.token
    %load, %tok = waveamdmachine.ds_load_b128 %addr after %dep
        : (!waveamdmachine.reg<vgpr, 1, 0>, !waveamdmachine.mem.token)
          -> (!waveamdmachine.reg<vgpr, 4>, !waveamdmachine.mem.token)
    %request = waveamdmachine.uninit : !waveamdmachine.reg<vgpr, 8>
    %store = waveamdmachine.ds_store_b128 %addr, %load after %tok
        : (!waveamdmachine.reg<vgpr, 1, 0>,
           !waveamdmachine.reg<vgpr, 4>, !waveamdmachine.mem.token)
          -> !waveamdmachine.mem.token
    return %request : !waveamdmachine.reg<vgpr, 8>
  }
}
