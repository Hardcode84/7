// RUN: wave-opt %s --pass-pipeline='builtin.module(transform-preload-library{transform-library-paths=%wave_pipelines},transform-interpreter{entry-point=waveamd_regalloc_transform_loop})' | FileCheck %s

module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx950"} {
  func.func private @consume_blocker(!waveamdmachine.reg<vgpr, 3, 1>)

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

  // CHECK-LABEL: func.func @agpr_relief_retries_bridged_narrow_overlap()
  // CHECK-SAME: waveamdmachine.metadata = [{name = "wave.regalloc.iterations", value = 3 : i64}
  // CHECK-SAME: {name = "wave.regalloc.agpr.dwords", value = 1 : i64}
  // CHECK-SAME: {name = "wave.regalloc.remat.dwords", value = 0 : i64}
  // CHECK-SAME: waveamdmachine.regalloc_assignments
  // CHECK-SAME: stage = "linear-scan-success"
  // CHECK: [[SOURCE:%.*]] = waveamdmachine.v_rcp_f32
  // CHECK: [[AGPR:%.*]] = waveamdmachine.v_accvgpr_write_b32_tuple [[SOURCE]]
  // CHECK: [[LOAD:%.*]], [[TOK:%.*]] = waveamdmachine.ds_load_b128
  // CHECK-SAME: -> (!waveamdmachine.reg<vgpr, 4, {{[0-9]+}}>, !waveamdmachine.mem.token)
  // CHECK: call @consume_blocker
  // CHECK: waveamdmachine.ds_store_b128 {{%.*}}, [[LOAD]] after [[TOK]]
  // CHECK: [[READ:%.*]] = waveamdmachine.v_accvgpr_read_b32_tuple [[AGPR]]
  // CHECK: return [[READ]]
  func.func @agpr_relief_retries_bridged_narrow_overlap()
      -> !waveamdmachine.reg<vgpr, 1>
      attributes {waveamdmachine.vgpr_count_max = 8 : i64,
                  waveamdmachine.agpr_count_max = 256 : i64,
                  waveamdmachine.target_waves = 1 : i64} {
    %addr = waveamdmachine.uninit
        : !waveamdmachine.reg<vgpr, 1, 0>
    %blocker = waveamdmachine.uninit
        : !waveamdmachine.reg<vgpr, 3, 1>
    %value = waveamdmachine.v_rcp_f32 %addr
        : (!waveamdmachine.reg<vgpr, 1, 0>)
          -> !waveamdmachine.reg<vgpr, 1>
    %dep = waveamdmachine.token : !waveamdmachine.mem.token
    %request, %tok = waveamdmachine.ds_load_b128 %addr after %dep
        : (!waveamdmachine.reg<vgpr, 1, 0>, !waveamdmachine.mem.token)
          -> (!waveamdmachine.reg<vgpr, 4>, !waveamdmachine.mem.token)
    func.call @consume_blocker(%blocker)
        : (!waveamdmachine.reg<vgpr, 3, 1>) -> ()
    %store = waveamdmachine.ds_store_b128 %addr, %request after %tok
        : (!waveamdmachine.reg<vgpr, 1, 0>,
           !waveamdmachine.reg<vgpr, 4>, !waveamdmachine.mem.token)
          -> !waveamdmachine.mem.token
    return %value : !waveamdmachine.reg<vgpr, 1>
  }
}
