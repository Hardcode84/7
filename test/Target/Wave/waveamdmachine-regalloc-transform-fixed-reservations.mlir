// RUN: wave-opt %s --pass-pipeline='builtin.module(transform-interpreter{entry-point=linear_scan})' | FileCheck %s

module attributes {transform.with_named_sequence} {
  transform.named_sequence @match_func(
      %root: !transform.any_op {transform.readonly}) -> !transform.any_op {
    transform.match.operation_name %root ["func.func"] : !transform.any_op
    transform.yield %root : !transform.any_op
  }

  transform.named_sequence @linear_scan(
      %root: !transform.any_op {transform.readonly}) {
    %func = transform.collect_matching @match_func in %root
        : (!transform.any_op) -> !transform.any_op
    %r0 = wave.transform.regalloc_build_alias_state from %func
        : (!transform.any_op) -> !transform.any_op
    %r1 = wave.transform.regalloc_linear_scan from %r0
        : (!transform.any_op) -> !transform.any_op
    transform.yield
  }

  module @payload_module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx1100"} {
    // CHECK-LABEL: func.func @nonfixed_avoids_later_fixed(
    // CHECK-SAME: [[LIVE:%[^:]+]]: !waveamdmachine.reg<vgpr, 1, 1>
    // CHECK-SAME: waveamdmachine.regalloc_assignments
    // CHECK-SAME: assignments = [{base = 1 : i64, class = "vgpr"
    // CHECK-SAME: {base = 0 : i64, class = "vgpr"
    // CHECK-SAME: stage = "linear-scan-success"
    // CHECK: [[FIXED:%.*]] = waveamdmachine.uninit : !waveamdmachine.reg<vgpr, 1, 0>
    // CHECK: return [[LIVE]], [[FIXED]]
    func.func @nonfixed_avoids_later_fixed(
        %live: !waveamdmachine.reg<vgpr, 1>)
        -> (!waveamdmachine.reg<vgpr, 1>,
            !waveamdmachine.reg<vgpr, 1, 0>) {
      %zero = waveamdmachine.imm 0 : !waveamdmachine.imm
      %fixed = waveamdmachine.uninit : !waveamdmachine.reg<vgpr, 1, 0>
      return %live, %fixed
          : !waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1, 0>
    }

    // CHECK-LABEL: func.func @fixed_reservation_failure(
    // CHECK-NOT: waveamdmachine.regalloc_assignments
    // CHECK-SAME: assignments = []
    // CHECK-SAME: failure = {budget_mode = "func_attr", class = "vgpr"
    // CHECK-SAME: limit = 1 : i64
    // CHECK-SAME: overlaps = [{base = 0 : i64, class = "vgpr", end = 2 : i64, set = 1 : i64, start = 1 : i64
    // CHECK-SAME: pressure = 2 : i64
    // CHECK-SAME: reason = "pressure"
    // CHECK-SAME: request = 1 : i64
    // CHECK-SAME: stage = "linear-scan-failure"
    func.func @fixed_reservation_failure(
        %live: !waveamdmachine.reg<vgpr, 1>)
        -> (!waveamdmachine.reg<vgpr, 1>,
            !waveamdmachine.reg<vgpr, 1, 0>)
        attributes {waveamdmachine.vgpr_count_max = 1 : i64} {
      %zero = waveamdmachine.imm 0 : !waveamdmachine.imm
      %fixed = waveamdmachine.uninit : !waveamdmachine.reg<vgpr, 1, 0>
      return %live, %fixed
          : !waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1, 0>
    }

    // CHECK-LABEL: func.func @nonfixed_reuses_expired_fixed
    // CHECK-SAME: waveamdmachine.regalloc_assignments
    // CHECK-SAME: stage = "linear-scan-success"
    // CHECK: [[FIXED:%.*]] = waveamdmachine.uninit : !waveamdmachine.reg<vgpr, 1, 0>
    // CHECK: waveamdmachine.v_mov_b32_tuple [[FIXED]] {registers = 1 : i64} : (!waveamdmachine.reg<vgpr, 1, 0>) -> !waveamdmachine.reg<vgpr, 1, 1>
    // CHECK: [[FRESH:%.*]] = waveamdmachine.uninit : !waveamdmachine.reg<vgpr, 1, 0>
    // CHECK: return [[FRESH]]
    func.func @nonfixed_reuses_expired_fixed()
        -> !waveamdmachine.reg<vgpr, 1> {
      %fixed = waveamdmachine.uninit : !waveamdmachine.reg<vgpr, 1, 0>
      %copy = waveamdmachine.v_mov_b32_tuple %fixed {registers = 1 : i64}
          : (!waveamdmachine.reg<vgpr, 1, 0>) -> !waveamdmachine.reg<vgpr, 1>
      %fresh = waveamdmachine.uninit : !waveamdmachine.reg<vgpr, 1>
      return %fresh : !waveamdmachine.reg<vgpr, 1>
    }

    // CHECK-LABEL: func.func @wide_sgpr_aligns_after_single
    // CHECK-SAME: !waveamdmachine.reg<sgpr, 1, 0>
    // CHECK-SAME: !waveamdmachine.reg<sgpr, 2, 2>
    func.func @wide_sgpr_aligns_after_single()
        -> (!waveamdmachine.reg<sgpr, 1>, !waveamdmachine.reg<sgpr, 2>) {
      %one = waveamdmachine.uninit : !waveamdmachine.reg<sgpr, 1>
      %wide = waveamdmachine.uninit : !waveamdmachine.reg<sgpr, 2>
      return %one, %wide
          : !waveamdmachine.reg<sgpr, 1>, !waveamdmachine.reg<sgpr, 2>
    }

    // CHECK-LABEL: func.func @implicit_sload_base_reserves_sgprs
    // CHECK-SAME: wave.kernel
    // CHECK-SAME: waveamdmachine.regalloc_assignments
    // CHECK-SAME: assignments = [{base = 2 : i64, class = "sgpr"
    // CHECK-SAME: {base = 0 : i64, class = "sgpr"
    // CHECK-SAME: stage = "linear-scan-success"
    // CHECK: waveamdmachine.s_load_b64 {{.*}}, "s[0:1]" : (!waveamdmachine.imm) -> !waveamdmachine.reg<sgpr, 2, 2>
    // CHECK: waveamdmachine.uninit : !waveamdmachine.reg<sgpr, 1, 0>
    func.func @implicit_sload_base_reserves_sgprs()
        -> !waveamdmachine.reg<sgpr, 1> attributes {wave.kernel} {
      %zero = waveamdmachine.imm 0 : !waveamdmachine.imm
      %loaded = waveamdmachine.s_load_b64 %zero, "s[0:1]"
          : (!waveamdmachine.imm) -> !waveamdmachine.reg<sgpr, 2>
      %parts:2 = waveamdmachine.tuple_to_elements %loaded
          : (!waveamdmachine.reg<sgpr, 2>)
            -> (!waveamdmachine.reg<sgpr, 1>, !waveamdmachine.reg<sgpr, 1>)
      %fresh = waveamdmachine.uninit : !waveamdmachine.reg<sgpr, 1>
      return %fresh : !waveamdmachine.reg<sgpr, 1>
    }

    // CHECK-LABEL: func.func @implicit_sload_avoids_future_workgroup_id
    // CHECK-SAME: wave.kernel
    // CHECK: waveamdmachine.s_load_b64 {{.*}}, "s[0:1]" : (!waveamdmachine.imm) -> !waveamdmachine.reg<sgpr, 2, 4>
    // CHECK: waveamdmachine.s_workgroup_id_x : !waveamdmachine.reg<sgpr, 1, 2>
    func.func @implicit_sload_avoids_future_workgroup_id()
        -> (!waveamdmachine.reg<sgpr, 2>, !waveamdmachine.reg<sgpr, 1, 2>)
        attributes {wave.kernel} {
      %zero = waveamdmachine.imm 0 : !waveamdmachine.imm
      %loaded = waveamdmachine.s_load_b64 %zero, "s[0:1]"
          : (!waveamdmachine.imm) -> !waveamdmachine.reg<sgpr, 2>
      %workgroup = waveamdmachine.s_workgroup_id_x
          : !waveamdmachine.reg<sgpr, 1, 2>
      return %loaded, %workgroup
          : !waveamdmachine.reg<sgpr, 2>,
            !waveamdmachine.reg<sgpr, 1, 2>
    }
  }
}
