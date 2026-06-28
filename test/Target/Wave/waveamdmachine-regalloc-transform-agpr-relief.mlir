// RUN: wave-opt %s --pass-pipeline='builtin.module(transform-interpreter{entry-point=agpr_relief})' | FileCheck %s --check-prefix=CHECK
// RUN: wave-opt %s --pass-pipeline='builtin.module(transform-interpreter{entry-point=agpr_relief_direct})' | FileCheck %s --check-prefix=DIRECT

module attributes {transform.with_named_sequence} {
  transform.named_sequence @match_func(
      %root: !transform.any_op {transform.readonly}) -> !transform.any_op {
    transform.match.operation_name %root ["func.func"] : !transform.any_op
    transform.yield %root : !transform.any_op
  }

  transform.named_sequence @agpr_relief(
      %root: !transform.any_op {transform.readonly}) {
    %func = transform.collect_matching @match_func in %root
        : (!transform.any_op) -> !transform.any_op
    %r0 = wave.transform.regalloc_build_alias_state from %func
        : (!transform.any_op) -> !transform.any_op
    %r1 = wave.transform.regalloc_linear_scan from %r0
        : (!transform.any_op) -> !transform.any_op
    %r2 = wave.transform.regalloc_agpr_relief from %r1
        : (!transform.any_op) -> !transform.any_op
    transform.yield
  }

  transform.named_sequence @agpr_relief_direct(
      %root: !transform.any_op {transform.readonly}) {
    %func = transform.collect_matching @match_func in %root
        : (!transform.any_op) -> !transform.any_op
    %r0 = wave.transform.regalloc_agpr_relief from %func
        : (!transform.any_op) -> !transform.any_op
    transform.yield
  }

  module @payload_module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx950"} {
    // CHECK-LABEL: func.func @agpr_relief_skips_entry_failure(
    // CHECK-SAME: waveamdmachine.regalloc_transform_state =
    // CHECK-SAME: position = 0 : i64
    // CHECK-SAME: stage = "linear-scan-failure"
    // CHECK-NOT: waveamdmachine.v_accvgpr_write_b32_tuple
    // CHECK: return
    func.func @agpr_relief_skips_entry_failure(
        %a: !waveamdmachine.reg<vgpr, 1>,
        %b: !waveamdmachine.reg<vgpr, 1>)
        -> (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>)
        attributes {waveamdmachine.vgpr_count_max = 1 : i64,
                    waveamdmachine.agpr_count_max = 4 : i64} {
      return %a, %b
          : !waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>
    }

    // CHECK-LABEL: func.func @agpr_relief_promotes_overlap(
    // CHECK-SAME: [[HOT:%[^:]+]]: !waveamdmachine.reg<vgpr, 1>
    // CHECK-NOT: waveamdmachine.regalloc_transform_state
    // CHECK: [[AG:%.*]] = waveamdmachine.v_accvgpr_write_b32_tuple [[HOT]]
    // CHECK: [[READ:%.*]] = waveamdmachine.v_accvgpr_read_b32_tuple [[AG]]
    // CHECK: waveamdmachine.global_store_b32 [[READ]]
    func.func @agpr_relief_promotes_overlap(
        %hot: !waveamdmachine.reg<vgpr, 1>)
        -> !waveamdmachine.reg<vgpr, 1>
        attributes {waveamdmachine.vgpr_count_max = 1 : i64,
                    waveamdmachine.agpr_count_max = 4 : i64} {
      %zero = waveamdmachine.imm 0 : !waveamdmachine.imm
      %one = waveamdmachine.imm 1 : !waveamdmachine.imm
      %long = waveamdmachine.v_mov_b32_tuple %zero {registers = 1 : i64}
          : (!waveamdmachine.imm) -> !waveamdmachine.reg<vgpr, 1>
      %base = waveamdmachine.uninit : !waveamdmachine.reg<sgpr, 2>
      %cond = waveamdmachine.s_cmp_lt_i32 %zero, %one
          : (!waveamdmachine.imm, !waveamdmachine.imm)
            -> !waveamdmachine.reg<scc, 1>
      waveamdmachine.uniform_loop if %cond : !waveamdmachine.reg<scc, 1> {
        %token = waveamdmachine.global_store_b32 %hot, %zero, %base
            : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.imm,
               !waveamdmachine.reg<sgpr, 2>) -> !waveamdmachine.mem.token
        waveamdmachine.continue_if %cond : !waveamdmachine.reg<scc, 1>
      }
      return %long : !waveamdmachine.reg<vgpr, 1>
    }

    // DIRECT-LABEL: func.func @agpr_relief_direct_promotes_mfma_acc_result_group(
    // DIRECT-NOT: waveamdmachine.regalloc_transform_state
    // DIRECT: [[A:%.*]] = waveamdmachine.uninit : !waveamdmachine.reg<vgpr, 4, 0>
    // DIRECT: [[B:%.*]] = waveamdmachine.uninit : !waveamdmachine.reg<vgpr, 4, 4>
    // DIRECT: [[ACC:%.*]] = waveamdmachine.uninit : !waveamdmachine.reg<agpr, 4>
    // DIRECT-NOT: waveamdmachine.v_accvgpr_read_b32_tuple [[ACC]]
    // DIRECT: [[MFMA:%.*]] = waveamdmachine.mfma_f32_16x16x32_f16 [[A]], [[B]], [[ACC]]
    // DIRECT-SAME: (!waveamdmachine.reg<vgpr, 4, 0>, !waveamdmachine.reg<vgpr, 4, 4>, !waveamdmachine.reg<agpr, 4>) -> !waveamdmachine.reg<agpr, 4>
    // DIRECT: [[MFMA_READ:%.*]] = waveamdmachine.v_accvgpr_read_b32_tuple [[MFMA]]
    // DIRECT: return [[MFMA_READ]]
    func.func @agpr_relief_direct_promotes_mfma_acc_result_group()
        -> !waveamdmachine.reg<vgpr, 4>
        attributes {waveamdmachine.vgpr_count_max = 12 : i64,
                    waveamdmachine.agpr_count_max = 16 : i64,
                    waveamdmachine.regalloc_transform_state = {
          alias_sets = [
            {class = "vgpr", id = 0 : i64,
             members = [{value = 0 : i64}], width = 4 : i64},
            {class = "vgpr", id = 1 : i64,
             members = [{value = 1 : i64}], width = 4 : i64},
            {class = "vgpr", id = 2 : i64,
             members = [{value = 2 : i64}], width = 4 : i64},
            {class = "vgpr", id = 3 : i64,
             members = [{value = 3 : i64}], width = 4 : i64}
          ],
          failure = {
            class = "vgpr",
            overlaps = [
              {base = 0 : i64, class = "vgpr", end = 3 : i64, set = 0 : i64,
               start = 0 : i64, width = 4 : i64},
              {base = 4 : i64, class = "vgpr", end = 3 : i64, set = 1 : i64,
               start = 1 : i64, width = 4 : i64},
              {base = 8 : i64, class = "vgpr", end = 3 : i64, set = 2 : i64,
               start = 2 : i64, width = 4 : i64}
            ],
            position = 3 : i64,
            reason = "pressure",
            set = 3 : i64
          },
          stage = "linear-scan-failure",
          values = [
            {class = "vgpr", end = 3 : i64, fixed = 0 : i64, id = 0 : i64,
             kind = "op_result", number = 0 : i64, offset = 0 : i64,
             path = [0, 0, 0], set = 0 : i64, start = 0 : i64,
             width = 4 : i64},
            {class = "vgpr", end = 3 : i64, fixed = 4 : i64, id = 1 : i64,
             kind = "op_result", number = 0 : i64, offset = 0 : i64,
             path = [0, 0, 1], set = 1 : i64, start = 1 : i64,
             width = 4 : i64},
            {class = "vgpr", end = 3 : i64, id = 2 : i64,
             kind = "op_result", number = 0 : i64, offset = 0 : i64,
             path = [0, 0, 2], set = 2 : i64, start = 2 : i64,
             width = 4 : i64},
            {class = "vgpr", end = 4 : i64, id = 3 : i64,
             kind = "op_result", number = 0 : i64, offset = 0 : i64,
             path = [0, 0, 3], set = 3 : i64, start = 3 : i64,
             width = 4 : i64}
          ]
        }} {
      %a = waveamdmachine.uninit : !waveamdmachine.reg<vgpr, 4, 0>
      %b = waveamdmachine.uninit : !waveamdmachine.reg<vgpr, 4, 4>
      %acc = waveamdmachine.uninit : !waveamdmachine.reg<vgpr, 4>
      %mfma = waveamdmachine.mfma_f32_16x16x32_f16 %a, %b, %acc
          : (!waveamdmachine.reg<vgpr, 4, 0>,
             !waveamdmachine.reg<vgpr, 4, 4>,
             !waveamdmachine.reg<vgpr, 4>) -> !waveamdmachine.reg<vgpr, 4>
      return %mfma : !waveamdmachine.reg<vgpr, 4>
    }

    // CHECK-LABEL: func.func @agpr_relief_skips_vgpr_bank_budget(
    // CHECK-SAME: waveamdmachine.regalloc_transform_state =
    // CHECK-SAME: class = "vgpr"
    // CHECK-SAME: stage = "linear-scan-failure"
    // CHECK-NOT: waveamdmachine.v_accvgpr_write_b32_tuple
    // CHECK: return
    func.func @agpr_relief_skips_vgpr_bank_budget(
        %hot: !waveamdmachine.reg<vgpr, 1>)
        -> !waveamdmachine.reg<vgpr, 1>
        attributes {waveamdmachine.vgpr_count_max = 1 : i64,
                    waveamdmachine.agpr_count_max = 4 : i64,
                    waveamdmachine.target_waves = 2 : i64} {
      %zero = waveamdmachine.imm 0 : !waveamdmachine.imm
      %one = waveamdmachine.imm 1 : !waveamdmachine.imm
      %long = waveamdmachine.v_mov_b32_tuple %zero {registers = 1 : i64}
          : (!waveamdmachine.imm) -> !waveamdmachine.reg<vgpr, 1>
      %base = waveamdmachine.uninit : !waveamdmachine.reg<sgpr, 2>
      %cond = waveamdmachine.s_cmp_lt_i32 %zero, %one
          : (!waveamdmachine.imm, !waveamdmachine.imm)
            -> !waveamdmachine.reg<scc, 1>
      waveamdmachine.uniform_loop if %cond : !waveamdmachine.reg<scc, 1> {
        %token = waveamdmachine.global_store_b32 %hot, %zero, %base
            : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.imm,
               !waveamdmachine.reg<sgpr, 2>) -> !waveamdmachine.mem.token
        waveamdmachine.continue_if %cond : !waveamdmachine.reg<scc, 1>
      }
      return %long : !waveamdmachine.reg<vgpr, 1>
    }

    // CHECK-LABEL: func.func @agpr_relief_promotes_loop_carry(
    // CHECK-NOT: waveamdmachine.regalloc_transform_state
    // CHECK: [[INIT:%.*]] = waveamdmachine.v_mov_b32_tuple
    // CHECK: [[AG:%.*]] = waveamdmachine.v_accvgpr_write_b32_tuple [[INIT]]
    // CHECK-NOT: waveamdmachine.v_accvgpr_read_b32_tuple [[AG]]
    // CHECK: waveamdmachine.uniform_loop {{.*}} carries([[AG]] : !waveamdmachine.reg<agpr, 4>)
    // CHECK: ^bb0([[CARRY:%[^:]+]]: !waveamdmachine.reg<agpr, 4>):
    // CHECK: waveamdmachine.continue_if {{.*}} carries([[CARRY]] : !waveamdmachine.reg<agpr, 4>)
    func.func @agpr_relief_promotes_loop_carry()
        -> !waveamdmachine.reg<vgpr, 4>
        attributes {waveamdmachine.vgpr_count_max = 4 : i64,
                    waveamdmachine.agpr_count_max = 16 : i64} {
      %zero = waveamdmachine.imm 0 : !waveamdmachine.imm
      %four = waveamdmachine.imm 4 : !waveamdmachine.imm
      %carry_init = waveamdmachine.v_mov_b32_tuple %zero {registers = 4 : i64}
          : (!waveamdmachine.imm) -> !waveamdmachine.reg<vgpr, 4>
      %long = waveamdmachine.v_mov_b32_tuple %zero {registers = 4 : i64}
          : (!waveamdmachine.imm) -> !waveamdmachine.reg<vgpr, 4>
      %cond = waveamdmachine.s_cmp_lt_i32 %zero, %four
          : (!waveamdmachine.imm, !waveamdmachine.imm)
            -> !waveamdmachine.reg<scc, 1>
      %loop = waveamdmachine.uniform_loop if %cond : !waveamdmachine.reg<scc, 1>
          carries(%carry_init : !waveamdmachine.reg<vgpr, 4>) {
      ^bb0(%carry: !waveamdmachine.reg<vgpr, 4>):
        waveamdmachine.continue_if %cond : !waveamdmachine.reg<scc, 1>
            carries(%carry : !waveamdmachine.reg<vgpr, 4>)
      } -> !waveamdmachine.reg<vgpr, 4>
      return %long : !waveamdmachine.reg<vgpr, 4>
    }

    // CHECK-LABEL: func.func @agpr_relief_respects_capacity(
    // CHECK-NOT: waveamdmachine.v_accvgpr_write_b32_tuple
    // CHECK-SAME: waveamdmachine.regalloc_transform_state =
    // CHECK-SAME: stage = "linear-scan-failure"
    func.func @agpr_relief_respects_capacity(
        %a: !waveamdmachine.reg<vgpr, 1>,
        %b: !waveamdmachine.reg<vgpr, 1>)
        -> (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>)
        attributes {waveamdmachine.vgpr_count_max = 1 : i64,
                    waveamdmachine.agpr_count_max = 0 : i64} {
      return %a, %b
          : !waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>
    }

    // CHECK-LABEL: func.func @agpr_failure_not_demoted(
    // CHECK-NOT: waveamdmachine.v_accvgpr_read_b32_tuple
    // CHECK-SAME: waveamdmachine.regalloc_transform_state =
    // CHECK-SAME: class = "agpr"
    // CHECK-SAME: stage = "linear-scan-failure"
    func.func @agpr_failure_not_demoted(
        %a: !waveamdmachine.reg<agpr, 1>,
        %b: !waveamdmachine.reg<agpr, 1>)
        -> (!waveamdmachine.reg<agpr, 1>, !waveamdmachine.reg<agpr, 1>)
        attributes {waveamdmachine.agpr_count_max = 1 : i64} {
      return %a, %b
          : !waveamdmachine.reg<agpr, 1>, !waveamdmachine.reg<agpr, 1>
    }

    // CHECK-LABEL: func.func @agpr_relief_skips_combined_pressure(
    // CHECK-NOT: waveamdmachine.v_accvgpr_write_b32_tuple
    // CHECK-SAME: waveamdmachine.regalloc_transform_state =
    // CHECK-SAME: class = "vgpr_agpr"
    // CHECK-SAME: stage = "linear-scan-failure"
    func.func @agpr_relief_skips_combined_pressure(
        %agpr: !waveamdmachine.reg<agpr, 120>,
        %vgpr: !waveamdmachine.reg<vgpr, 120>)
        -> (!waveamdmachine.reg<agpr, 120>,
            !waveamdmachine.reg<vgpr, 120>)
        attributes {waveamdmachine.target_waves = 4 : i64} {
      return %agpr, %vgpr
          : !waveamdmachine.reg<agpr, 120>,
            !waveamdmachine.reg<vgpr, 120>
    }
  }
}
