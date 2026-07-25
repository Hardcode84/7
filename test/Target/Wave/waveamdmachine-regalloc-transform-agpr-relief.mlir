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
    // CHECK-SAME: waveamdmachine.regalloc_preparation_tracking
    // CHECK-SAME: waveamdmachine.regalloc_preparation_valid
    // CHECK-NOT: waveamdmachine.regalloc_transform_state
    // CHECK: [[AG:%.*]] = waveamdmachine.v_accvgpr_write_b32_tuple [[HOT]]
    // CHECK: [[READ:%.*]] = waveamdmachine.v_accvgpr_read_b32_tuple [[AG]]
    // CHECK: waveamdmachine.global_store_b32 [[READ]]
    func.func @agpr_relief_promotes_overlap(
        %hot: !waveamdmachine.reg<vgpr, 1>)
        -> !waveamdmachine.reg<vgpr, 1>
        attributes {waveamdmachine.vgpr_count_max = 1 : i64,
                    waveamdmachine.agpr_count_max = 4 : i64,
                    waveamdmachine.regalloc_preparation_tracking,
                    waveamdmachine.regalloc_preparation_valid} {
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

    // DIRECT-LABEL: func.func @agpr_relief_direct_ds_store_operand(
    // DIRECT: [[ZERO:%.*]] = waveamdmachine.imm 0
    // DIRECT: [[AG:%.*]] = waveamdmachine.v_accvgpr_write_b32_tuple [[ZERO]]
    // DIRECT-NOT: waveamdmachine.v_accvgpr_read_b32_tuple [[AG]]
    // DIRECT: waveamdmachine.ds_store_b32 {{%.*}}, [[AG]]
    // DIRECT-SAME: !waveamdmachine.reg<agpr, 1>
    func.func @agpr_relief_direct_ds_store_operand()
        attributes {waveamdmachine.vgpr_count_max = 1 : i64,
                    waveamdmachine.agpr_count_max = 4 : i64,
                    waveamdmachine.regalloc_transform_state = {
          alias_sets = [
            {class = "vgpr", id = 0 : i64,
             members = [{value = 0 : i64}], width = 1 : i64},
            {class = "vgpr", id = 1 : i64,
             members = [{value = 1 : i64}], width = 1 : i64}
          ],
          failure = {
            class = "vgpr",
            overlaps = [
              {base = 0 : i64, class = "vgpr", end = 4 : i64, set = 0 : i64,
               start = 0 : i64, width = 1 : i64},
              {base = 0 : i64, class = "vgpr", end = 4 : i64, set = 1 : i64,
               start = 2 : i64, width = 1 : i64}
            ],
            position = 4 : i64,
            reason = "pressure",
            set = 1 : i64
          },
          stage = "linear-scan-failure",
          values = [
            {class = "vgpr", end = 4 : i64, fixed = 0 : i64, id = 0 : i64,
             kind = "op_result", number = 0 : i64, offset = 0 : i64,
             path = [0, 0, 0], set = 0 : i64, start = 0 : i64,
             width = 1 : i64},
            {class = "vgpr", end = 4 : i64, id = 1 : i64,
             kind = "op_result", number = 0 : i64, offset = 0 : i64,
             path = [0, 0, 2], set = 1 : i64, start = 2 : i64,
             width = 1 : i64}
          ]
        }} {
      %addr = waveamdmachine.uninit : !waveamdmachine.reg<vgpr, 1, 0>
      %zero = waveamdmachine.imm 0 : !waveamdmachine.imm
      %value = waveamdmachine.v_mov_b32_tuple %zero {registers = 1 : i64}
          : (!waveamdmachine.imm) -> !waveamdmachine.reg<vgpr, 1>
      %dep = waveamdmachine.token : !waveamdmachine.mem.token
      %store = waveamdmachine.ds_store_b32 %addr, %value after %dep
          : (!waveamdmachine.reg<vgpr, 1, 0>, !waveamdmachine.reg<vgpr, 1>,
             !waveamdmachine.mem.token) -> !waveamdmachine.mem.token
      return
    }

    // DIRECT-LABEL: func.func @agpr_relief_direct_ds_load_result(
    // DIRECT: [[LOAD:%.*]], {{%.*}} = waveamdmachine.ds_load_b32
    // DIRECT-SAME: -> (!waveamdmachine.reg<agpr, 1>, !waveamdmachine.mem.token)
    // DIRECT: [[READ:%.*]] = waveamdmachine.v_accvgpr_read_b32_tuple [[LOAD]]
    // DIRECT: return [[READ]]
    func.func @agpr_relief_direct_ds_load_result()
        -> !waveamdmachine.reg<vgpr, 1>
        attributes {waveamdmachine.vgpr_count_max = 1 : i64,
                    waveamdmachine.agpr_count_max = 4 : i64,
                    waveamdmachine.regalloc_transform_state = {
          alias_sets = [
            {class = "vgpr", id = 0 : i64,
             members = [{value = 0 : i64}], width = 1 : i64},
            {class = "vgpr", id = 1 : i64,
             members = [{value = 1 : i64}], width = 1 : i64}
          ],
          failure = {
            class = "vgpr",
            overlaps = [
              {base = 0 : i64, class = "vgpr", end = 2 : i64, set = 0 : i64,
               start = 0 : i64, width = 1 : i64},
              {base = 0 : i64, class = "vgpr", end = 3 : i64, set = 1 : i64,
               start = 2 : i64, width = 1 : i64}
            ],
            position = 3 : i64,
            reason = "pressure",
            set = 1 : i64
          },
          stage = "linear-scan-failure",
          values = [
            {class = "vgpr", end = 2 : i64, fixed = 0 : i64, id = 0 : i64,
             kind = "op_result", number = 0 : i64, offset = 0 : i64,
             path = [0, 0, 0], set = 0 : i64, start = 0 : i64,
             width = 1 : i64},
            {class = "vgpr", end = 3 : i64, id = 1 : i64,
             kind = "op_result", number = 0 : i64, offset = 0 : i64,
             path = [0, 0, 2], set = 1 : i64, start = 2 : i64,
             width = 1 : i64}
          ]
        }} {
      %addr = waveamdmachine.uninit : !waveamdmachine.reg<vgpr, 1, 0>
      %dep = waveamdmachine.token : !waveamdmachine.mem.token
      %load, %tok = waveamdmachine.ds_load_b32 %addr after %dep
          : (!waveamdmachine.reg<vgpr, 1, 0>, !waveamdmachine.mem.token)
            -> (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.mem.token)
      return %load : !waveamdmachine.reg<vgpr, 1>
    }

    // DIRECT-LABEL: func.func @agpr_relief_direct_narrow_overlap_progress()
    // DIRECT-NOT: waveamdmachine.regalloc_transform_state
    // DIRECT: [[LOAD:%.*]], [[TOK:%.*]] = waveamdmachine.ds_load_b128
    // DIRECT-SAME: -> (!waveamdmachine.reg<agpr, 4>, !waveamdmachine.mem.token)
    // DIRECT: waveamdmachine.ds_store_b128 {{%.*}}, [[LOAD]] after [[TOK]]
    // DIRECT-SAME: !waveamdmachine.reg<agpr, 4>
    // DIRECT-NOT: waveamdmachine.v_accvgpr_{{read|write}}_b32_tuple
    func.func @agpr_relief_direct_narrow_overlap_progress()
        attributes {waveamdmachine.agpr_count_max = 256 : i64,
                    waveamdmachine.target_waves = 1 : i64,
                    waveamdmachine.regalloc_transform_state = {
          alias_sets = [
            {class = "vgpr", id = 0 : i64,
             members = [{value = 0 : i64}], width = 1 : i64},
            {class = "vgpr", id = 1 : i64,
             members = [{value = 1 : i64}], width = 4 : i64},
            {class = "vgpr", id = 2 : i64,
             members = [{value = 2 : i64}], width = 16 : i64}
          ],
          failure = {
            class = "vgpr",
            overlaps = [
              {base = 240 : i64, class = "vgpr", end = 4 : i64,
               set = 1 : i64, start = 2 : i64, width = 4 : i64}
            ],
            position = 3 : i64,
            reason = "pressure",
            set = 2 : i64
          },
          stage = "linear-scan-failure",
          values = [
            {class = "vgpr", end = 4 : i64, fixed = 0 : i64, id = 0 : i64,
             kind = "op_result", number = 0 : i64, offset = 0 : i64,
             path = [0, 0, 0], set = 0 : i64, start = 0 : i64,
             width = 1 : i64},
            {class = "vgpr", end = 4 : i64, id = 1 : i64,
             kind = "op_result", number = 0 : i64, offset = 0 : i64,
             path = [0, 0, 2], set = 1 : i64, start = 2 : i64,
             width = 4 : i64},
            {class = "vgpr", end = 3 : i64, fixed = 240 : i64, id = 2 : i64,
             kind = "op_result", number = 0 : i64, offset = 0 : i64,
             path = [0, 0, 3], set = 2 : i64, start = 3 : i64,
             width = 16 : i64}
          ]
        }} {
      %addr = waveamdmachine.uninit : !waveamdmachine.reg<vgpr, 1, 0>
      %dep = waveamdmachine.token : !waveamdmachine.mem.token
      %load, %tok = waveamdmachine.ds_load_b128 %addr after %dep
          : (!waveamdmachine.reg<vgpr, 1, 0>, !waveamdmachine.mem.token)
            -> (!waveamdmachine.reg<vgpr, 4>, !waveamdmachine.mem.token)
      %request = waveamdmachine.uninit : !waveamdmachine.reg<vgpr, 16, 240>
      %store = waveamdmachine.ds_store_b128 %addr, %load after %tok
          : (!waveamdmachine.reg<vgpr, 1, 0>,
             !waveamdmachine.reg<vgpr, 4>, !waveamdmachine.mem.token)
            -> !waveamdmachine.mem.token
      return
    }

    // DIRECT-LABEL: func.func @agpr_relief_direct_allows_bridged_narrow_progress()
    // DIRECT-NOT: waveamdmachine.regalloc_transform_state
    // DIRECT: [[ZERO:%.*]] = waveamdmachine.imm 0
    // DIRECT-NOT: waveamdmachine.v_mov_b32_tuple [[ZERO]]
    // DIRECT: [[AGPR:%.*]] = waveamdmachine.v_accvgpr_write_b32_tuple [[ZERO]]
    // DIRECT: [[REQUEST:%.*]] = waveamdmachine.uninit
    // DIRECT: [[READ:%.*]] = waveamdmachine.v_accvgpr_read_b32_tuple [[AGPR]]
    // DIRECT: return [[READ]], [[REQUEST]]
    func.func @agpr_relief_direct_allows_bridged_narrow_progress()
        -> (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 4, 252>)
        attributes {waveamdmachine.agpr_count_max = 256 : i64,
                    waveamdmachine.target_waves = 1 : i64,
                    waveamdmachine.regalloc_transform_state = {
          alias_sets = [
            {class = "vgpr", id = 0 : i64,
             members = [{value = 0 : i64}], width = 1 : i64},
            {class = "vgpr", id = 1 : i64,
             members = [{value = 1 : i64}], width = 4 : i64}
          ],
          failure = {
            class = "vgpr",
            overlaps = [
              {base = 252 : i64, class = "vgpr", end = 3 : i64,
               set = 0 : i64, start = 1 : i64, width = 1 : i64}
            ],
            position = 2 : i64,
            reason = "pressure",
            set = 1 : i64
          },
          stage = "linear-scan-failure",
          values = [
            {class = "vgpr", end = 3 : i64, id = 0 : i64,
             kind = "op_result", number = 0 : i64, offset = 0 : i64,
             path = [0, 0, 1], set = 0 : i64, start = 1 : i64,
             width = 1 : i64},
            {class = "vgpr", end = 3 : i64, fixed = 252 : i64, id = 1 : i64,
             kind = "op_result", number = 0 : i64, offset = 0 : i64,
             path = [0, 0, 2], set = 1 : i64, start = 2 : i64,
             width = 4 : i64}
          ]
        }} {
      %zero = waveamdmachine.imm 0 : !waveamdmachine.imm
      %value = waveamdmachine.v_mov_b32_tuple %zero {registers = 1 : i64}
          : (!waveamdmachine.imm) -> !waveamdmachine.reg<vgpr, 1>
      %request = waveamdmachine.uninit : !waveamdmachine.reg<vgpr, 4, 252>
      return %value, %request
          : !waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 4, 252>
    }

    // DIRECT-LABEL: func.func @agpr_relief_scores_constant_replacements()
    // DIRECT-NOT: waveamdmachine.regalloc_transform_state
    // DIRECT: [[ZERO:%.*]] = waveamdmachine.imm 0
    // DIRECT: [[EVEN_ZERO:%.*]] = waveamdmachine.v_mov_b32_tuple [[ZERO]]
    // DIRECT-NOT: waveamdmachine.v_mov_b32_tuple [[ZERO]]
    // DIRECT: [[AGPR:%.*]] = waveamdmachine.v_accvgpr_write_b32_tuple [[ZERO]]
    // DIRECT: [[LITERAL:%.*]] = waveamdmachine.imm 65
    // DIRECT: [[LITERAL_FILL:%.*]] = waveamdmachine.v_mov_b32_tuple [[LITERAL]]
    // DIRECT: [[ONE:%.*]] = waveamdmachine.imm 1
    // DIRECT: [[ONE_FILL:%.*]] = waveamdmachine.v_mov_b32_tuple [[ONE]]
    // DIRECT: [[REQUEST:%.*]] = waveamdmachine.uninit
    // DIRECT: [[READ:%.*]] = waveamdmachine.v_accvgpr_read_b32_tuple [[AGPR]]
    // DIRECT: return [[EVEN_ZERO]], [[READ]], [[LITERAL_FILL]], [[ONE_FILL]], [[REQUEST]]
    func.func @agpr_relief_scores_constant_replacements()
        -> (!waveamdmachine.reg<vgpr, 2>, !waveamdmachine.reg<vgpr, 2>,
            !waveamdmachine.reg<vgpr, 2>, !waveamdmachine.reg<vgpr, 2>,
            !waveamdmachine.reg<vgpr, 12, 244>)
        attributes {waveamdmachine.agpr_count_max = 256 : i64,
                    waveamdmachine.target_waves = 1 : i64,
                    waveamdmachine.regalloc_transform_state = {
          alias_sets = [
            {class = "vgpr", id = 0 : i64,
             members = [{value = 0 : i64}], width = 2 : i64},
            {class = "vgpr", id = 1 : i64,
             members = [{value = 1 : i64}], width = 2 : i64},
            {class = "vgpr", id = 2 : i64,
             members = [{value = 2 : i64}], width = 2 : i64},
            {class = "vgpr", id = 3 : i64,
             members = [{value = 3 : i64}], width = 2 : i64},
            {class = "vgpr", id = 4 : i64,
             members = [{value = 4 : i64}], width = 12 : i64}
          ],
          failure = {
            class = "vgpr",
            overlaps = [
              {base = 244 : i64, class = "vgpr", end = 8 : i64,
               set = 0 : i64, start = 1 : i64, width = 2 : i64},
              {base = 247 : i64, class = "vgpr", end = 8 : i64,
               set = 1 : i64, start = 2 : i64, width = 2 : i64},
              {base = 250 : i64, class = "vgpr", end = 8 : i64,
               set = 2 : i64, start = 4 : i64, width = 2 : i64},
              {base = 252 : i64, class = "vgpr", end = 8 : i64,
               set = 3 : i64, start = 6 : i64, width = 2 : i64}
            ],
            position = 7 : i64,
            reason = "pressure",
            set = 4 : i64
          },
          stage = "linear-scan-failure",
          values = [
            {class = "vgpr", end = 8 : i64, id = 0 : i64,
             kind = "op_result", number = 0 : i64, offset = 0 : i64,
             path = [0, 0, 1], set = 0 : i64, start = 1 : i64,
             width = 2 : i64},
            {class = "vgpr", end = 8 : i64, id = 1 : i64,
             kind = "op_result", number = 0 : i64, offset = 0 : i64,
             path = [0, 0, 2], set = 1 : i64, start = 2 : i64,
             width = 2 : i64},
            {class = "vgpr", end = 8 : i64, id = 2 : i64,
             kind = "op_result", number = 0 : i64, offset = 0 : i64,
             path = [0, 0, 4], set = 2 : i64, start = 4 : i64,
             width = 2 : i64},
            {class = "vgpr", end = 8 : i64, id = 3 : i64,
             kind = "op_result", number = 0 : i64, offset = 0 : i64,
             path = [0, 0, 6], set = 3 : i64, start = 6 : i64,
             width = 2 : i64},
            {class = "vgpr", end = 8 : i64, fixed = 244 : i64, id = 4 : i64,
             kind = "op_result", number = 0 : i64, offset = 0 : i64,
             path = [0, 0, 7], set = 4 : i64, start = 7 : i64,
             width = 12 : i64}
          ]
        }} {
      %zero = waveamdmachine.imm 0 : !waveamdmachine.imm
      %even_zero = waveamdmachine.v_mov_b32_tuple %zero {registers = 2 : i64}
          : (!waveamdmachine.imm) -> !waveamdmachine.reg<vgpr, 2>
      %odd_zero = waveamdmachine.v_mov_b32_tuple %zero {registers = 2 : i64}
          : (!waveamdmachine.imm) -> !waveamdmachine.reg<vgpr, 2>
      %literal = waveamdmachine.imm 65 : !waveamdmachine.imm
      %literal_fill =
          waveamdmachine.v_mov_b32_tuple %literal {registers = 2 : i64}
          : (!waveamdmachine.imm) -> !waveamdmachine.reg<vgpr, 2>
      %one = waveamdmachine.imm 1 : !waveamdmachine.imm
      %inline = waveamdmachine.v_mov_b32_tuple %one {registers = 2 : i64}
          : (!waveamdmachine.imm) -> !waveamdmachine.reg<vgpr, 2>
      %request = waveamdmachine.uninit : !waveamdmachine.reg<vgpr, 12, 244>
      return %even_zero, %odd_zero, %literal_fill, %inline, %request
          : !waveamdmachine.reg<vgpr, 2>, !waveamdmachine.reg<vgpr, 2>,
            !waveamdmachine.reg<vgpr, 2>, !waveamdmachine.reg<vgpr, 2>,
            !waveamdmachine.reg<vgpr, 12, 244>
    }

    // DIRECT-LABEL: func.func @agpr_relief_prefers_inline_nonzero_replacement()
    // DIRECT-NOT: waveamdmachine.regalloc_transform_state
    // DIRECT: [[LITERAL:%.*]] = waveamdmachine.imm 65
    // DIRECT: [[KEEP:%.*]] = waveamdmachine.v_mov_b32_tuple [[LITERAL]]
    // DIRECT: [[ONE:%.*]] = waveamdmachine.imm 1
    // DIRECT-NOT: waveamdmachine.v_mov_b32_tuple [[ONE]]
    // DIRECT: [[AGPR:%.*]] = waveamdmachine.v_accvgpr_write_b32_tuple [[ONE]]
    // DIRECT: [[REQUEST:%.*]] = waveamdmachine.uninit
    // DIRECT: [[READ:%.*]] = waveamdmachine.v_accvgpr_read_b32_tuple [[AGPR]]
    // DIRECT: return [[KEEP]], [[READ]], [[REQUEST]]
    func.func @agpr_relief_prefers_inline_nonzero_replacement()
        -> (!waveamdmachine.reg<vgpr, 2>, !waveamdmachine.reg<vgpr, 2>,
            !waveamdmachine.reg<vgpr, 4, 252>)
        attributes {waveamdmachine.agpr_count_max = 256 : i64,
                    waveamdmachine.target_waves = 1 : i64,
                    waveamdmachine.regalloc_transform_state = {
          alias_sets = [
            {class = "vgpr", id = 0 : i64,
             members = [{value = 0 : i64}], width = 2 : i64},
            {class = "vgpr", id = 1 : i64,
             members = [{value = 1 : i64}], width = 2 : i64},
            {class = "vgpr", id = 2 : i64,
             members = [{value = 2 : i64}], width = 4 : i64}
          ],
          failure = {
            class = "vgpr",
            overlaps = [
              {base = 252 : i64, class = "vgpr", end = 5 : i64,
               set = 0 : i64, start = 1 : i64, width = 2 : i64},
              {base = 254 : i64, class = "vgpr", end = 5 : i64,
               set = 1 : i64, start = 3 : i64, width = 2 : i64}
            ],
            position = 4 : i64,
            reason = "pressure",
            set = 2 : i64
          },
          stage = "linear-scan-failure",
          values = [
            {class = "vgpr", end = 5 : i64, id = 0 : i64,
             kind = "op_result", number = 0 : i64, offset = 0 : i64,
             path = [0, 0, 1], set = 0 : i64, start = 1 : i64,
             width = 2 : i64},
            {class = "vgpr", end = 5 : i64, id = 1 : i64,
             kind = "op_result", number = 0 : i64, offset = 0 : i64,
             path = [0, 0, 3], set = 1 : i64, start = 3 : i64,
             width = 2 : i64},
            {class = "vgpr", end = 5 : i64, fixed = 252 : i64, id = 2 : i64,
             kind = "op_result", number = 0 : i64, offset = 0 : i64,
             path = [0, 0, 4], set = 2 : i64, start = 4 : i64,
             width = 4 : i64}
          ]
        }} {
      %literal = waveamdmachine.imm 65 : !waveamdmachine.imm
      %materialized =
          waveamdmachine.v_mov_b32_tuple %literal {registers = 2 : i64}
          : (!waveamdmachine.imm) -> !waveamdmachine.reg<vgpr, 2>
      %one = waveamdmachine.imm 1 : !waveamdmachine.imm
      %inline = waveamdmachine.v_mov_b32_tuple %one {registers = 2 : i64}
          : (!waveamdmachine.imm) -> !waveamdmachine.reg<vgpr, 2>
      %request = waveamdmachine.uninit : !waveamdmachine.reg<vgpr, 4, 252>
      return %materialized, %inline, %request
          : !waveamdmachine.reg<vgpr, 2>, !waveamdmachine.reg<vgpr, 2>,
            !waveamdmachine.reg<vgpr, 4, 252>
    }

    // DIRECT-LABEL: func.func @agpr_relief_keeps_loop_bridge_cost(
    // DIRECT-SAME: [[OUTSIDE:%[^:]+]]: !waveamdmachine.reg<vgpr, 1>
    // DIRECT-NOT: waveamdmachine.regalloc_transform_state
    // DIRECT: [[AGPR:%.*]] = waveamdmachine.v_accvgpr_write_b32_tuple [[OUTSIDE]]
    // DIRECT: [[ONE:%.*]] = waveamdmachine.imm 1
    // DIRECT: [[INLINE:%.*]] = waveamdmachine.v_mov_b32_tuple [[ONE]]
    // DIRECT: waveamdmachine.uniform_loop
    // DIRECT: waveamdmachine.global_store_b32 [[INLINE]]
    // DIRECT: [[REQUEST:%.*]] = waveamdmachine.uninit
    // DIRECT: [[READ:%.*]] = waveamdmachine.v_accvgpr_read_b32_tuple [[AGPR]]
    // DIRECT: return [[READ]], [[INLINE]]
    func.func @agpr_relief_keeps_loop_bridge_cost(
        %outside: !waveamdmachine.reg<vgpr, 1>,
        %base: !waveamdmachine.reg<sgpr, 2, 0>,
        %cond: !waveamdmachine.reg<scc, 1>)
        -> (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>)
        attributes {waveamdmachine.agpr_count_max = 256 : i64,
                    waveamdmachine.target_waves = 1 : i64,
                    waveamdmachine.regalloc_transform_state = {
          alias_sets = [
            {class = "vgpr", id = 0 : i64,
             members = [{value = 0 : i64}], width = 1 : i64},
            {class = "sgpr", id = 1 : i64,
             members = [{value = 1 : i64}], width = 2 : i64},
            {class = "vgpr", id = 2 : i64,
             members = [{value = 2 : i64}], width = 1 : i64},
            {class = "vgpr", id = 3 : i64,
             members = [{value = 3 : i64}], width = 2 : i64}
          ],
          failure = {
            class = "vgpr",
            overlaps = [
              {base = 0 : i64, class = "vgpr", end = 6 : i64,
               set = 0 : i64, start = 0 : i64, width = 1 : i64},
              {base = 1 : i64, class = "vgpr", end = 6 : i64,
               set = 2 : i64, start = 1 : i64, width = 1 : i64}
            ],
            position = 4 : i64,
            reason = "pressure",
            set = 3 : i64
          },
          stage = "linear-scan-failure",
          values = [
            {class = "vgpr", end = 6 : i64, id = 0 : i64,
             kind = "block_arg", number = 0 : i64, offset = 0 : i64,
             path = [0, 0], set = 0 : i64, start = 0 : i64,
             width = 1 : i64},
            {class = "sgpr", end = 6 : i64, fixed = 0 : i64, id = 1 : i64,
             kind = "block_arg", number = 1 : i64, offset = 0 : i64,
             path = [0, 0], set = 1 : i64, start = 0 : i64,
             width = 2 : i64},
            {class = "vgpr", end = 6 : i64, id = 2 : i64,
             kind = "op_result", number = 0 : i64, offset = 0 : i64,
             path = [0, 0, 1], set = 2 : i64, start = 1 : i64,
             width = 1 : i64},
            {class = "vgpr", end = 4 : i64, fixed = 2 : i64, id = 3 : i64,
             kind = "op_result", number = 0 : i64, offset = 0 : i64,
             path = [0, 0, 3], set = 3 : i64, start = 4 : i64,
             width = 2 : i64}
          ]
        }} {
      %one = waveamdmachine.imm 1 : !waveamdmachine.imm
      %inline = waveamdmachine.v_mov_b32_tuple %one
          : (!waveamdmachine.imm) -> !waveamdmachine.reg<vgpr, 1>
      waveamdmachine.uniform_loop if %cond : !waveamdmachine.reg<scc, 1> {
        %token = waveamdmachine.global_store_b32 %inline, %one, %base
            : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.imm,
               !waveamdmachine.reg<sgpr, 2, 0>)
              -> !waveamdmachine.mem.token
        waveamdmachine.continue_if %cond : !waveamdmachine.reg<scc, 1>
      }
      %request = waveamdmachine.uninit
          : !waveamdmachine.reg<vgpr, 2, 2>
      return %outside, %inline
          : !waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>
    }

    // DIRECT-LABEL: func.func @agpr_relief_rebanks_tuple_from_elements_replacements(
    // DIRECT: [[ZERO:%.*]] = waveamdmachine.imm 0
    // DIRECT-NOT: waveamdmachine.v_mov_b32_tuple
    // DIRECT: [[AG0:%.*]] = waveamdmachine.v_accvgpr_write_b32_tuple [[ZERO]]
    // DIRECT-NOT: waveamdmachine.v_mov_b32_tuple
    // DIRECT: [[AG1:%.*]] = waveamdmachine.v_accvgpr_write_b32_tuple [[ZERO]]
    // DIRECT-NOT: waveamdmachine.v_mov_b32_tuple
    // DIRECT: [[AG2:%.*]] = waveamdmachine.v_accvgpr_write_b32_tuple [[ZERO]]
    // DIRECT-NOT: waveamdmachine.v_mov_b32_tuple
    // DIRECT: [[AG3:%.*]] = waveamdmachine.v_accvgpr_write_b32_tuple [[ZERO]]
    // DIRECT-NOT: waveamdmachine.v_mov_b32_tuple
    // DIRECT-NOT: waveamdmachine.v_accvgpr_read_b32_tuple [[AG0]]
    // DIRECT: [[TUPLE:%.*]] = waveamdmachine.tuple_from_elements [[AG0]], [[AG1]], [[AG2]], [[AG3]]
    // DIRECT-SAME: (!waveamdmachine.reg<agpr, 1>, !waveamdmachine.reg<agpr, 1>, !waveamdmachine.reg<agpr, 1>, !waveamdmachine.reg<agpr, 1>) -> !waveamdmachine.reg<agpr, 4>
    // DIRECT: [[READ:%.*]] = waveamdmachine.v_accvgpr_read_b32_tuple [[TUPLE]]
    // DIRECT: return [[READ]]
    func.func @agpr_relief_rebanks_tuple_from_elements_replacements()
        -> !waveamdmachine.reg<vgpr, 4>
        attributes {waveamdmachine.vgpr_count_max = 4 : i64,
                    waveamdmachine.agpr_count_max = 16 : i64,
                    waveamdmachine.regalloc_transform_state = {
          alias_sets = [
            {class = "vgpr", id = 0 : i64,
             members = [
               {end = 6 : i64, offset = 0 : i64, start = 1 : i64,
                value = 0 : i64, width = 1 : i64},
               {end = 6 : i64, offset = 1 : i64, start = 2 : i64,
                value = 1 : i64, width = 1 : i64},
               {end = 6 : i64, offset = 2 : i64, start = 3 : i64,
                value = 2 : i64, width = 1 : i64},
               {end = 6 : i64, offset = 3 : i64, start = 4 : i64,
                value = 3 : i64, width = 1 : i64},
               {end = 6 : i64, offset = 0 : i64, start = 5 : i64,
                value = 4 : i64, width = 4 : i64}
             ],
             width = 4 : i64}
          ],
          failure = {
            class = "vgpr",
            overlaps = [
              {base = 0 : i64, class = "vgpr", end = 6 : i64, set = 0 : i64,
               start = 1 : i64, width = 4 : i64}
            ],
            position = 6 : i64,
            reason = "pressure",
            set = 0 : i64
          },
          stage = "linear-scan-failure",
          values = [
            {class = "vgpr", end = 6 : i64, id = 0 : i64,
             kind = "op_result", number = 0 : i64, offset = 0 : i64,
             path = [0, 0, 1], ranges = [{end = 6 : i64, start = 1 : i64}],
             set = 0 : i64, start = 1 : i64, width = 1 : i64},
            {class = "vgpr", end = 6 : i64, id = 1 : i64,
             kind = "op_result", number = 0 : i64, offset = 1 : i64,
             path = [0, 0, 2], ranges = [{end = 6 : i64, start = 2 : i64}],
             set = 0 : i64, start = 2 : i64, width = 1 : i64},
            {class = "vgpr", end = 6 : i64, id = 2 : i64,
             kind = "op_result", number = 0 : i64, offset = 2 : i64,
             path = [0, 0, 3], ranges = [{end = 6 : i64, start = 3 : i64}],
             set = 0 : i64, start = 3 : i64, width = 1 : i64},
            {class = "vgpr", end = 6 : i64, id = 3 : i64,
             kind = "op_result", number = 0 : i64, offset = 3 : i64,
             path = [0, 0, 4], ranges = [{end = 6 : i64, start = 4 : i64}],
             set = 0 : i64, start = 4 : i64, width = 1 : i64},
            {class = "vgpr", end = 6 : i64, id = 4 : i64,
             kind = "op_result", number = 0 : i64, offset = 0 : i64,
             path = [0, 0, 5], ranges = [{end = 6 : i64, start = 5 : i64}],
             set = 0 : i64, start = 5 : i64, width = 4 : i64}
          ]
        }} {
      %zero = waveamdmachine.imm 0 : !waveamdmachine.imm
      %e0 = waveamdmachine.v_mov_b32_tuple %zero {registers = 1 : i64}
          : (!waveamdmachine.imm) -> !waveamdmachine.reg<vgpr, 1>
      %e1 = waveamdmachine.v_mov_b32_tuple %zero {registers = 1 : i64}
          : (!waveamdmachine.imm) -> !waveamdmachine.reg<vgpr, 1>
      %e2 = waveamdmachine.v_mov_b32_tuple %zero {registers = 1 : i64}
          : (!waveamdmachine.imm) -> !waveamdmachine.reg<vgpr, 1>
      %e3 = waveamdmachine.v_mov_b32_tuple %zero {registers = 1 : i64}
          : (!waveamdmachine.imm) -> !waveamdmachine.reg<vgpr, 1>
      %tuple = waveamdmachine.tuple_from_elements %e0, %e1, %e2, %e3
          : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>,
             !waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>)
            -> !waveamdmachine.reg<vgpr, 4>
      return %tuple : !waveamdmachine.reg<vgpr, 4>
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
    // CHECK: [[ZERO:%.*]] = waveamdmachine.imm 0
    // CHECK-NOT: waveamdmachine.v_mov_b32_tuple
    // CHECK: [[AG:%.*]] = waveamdmachine.v_accvgpr_write_b32_tuple [[ZERO]]
    // CHECK: [[INIT:%.*]] = waveamdmachine.v_mov_b32_tuple
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

    // DIRECT-LABEL: func.func @agpr_relief_rejects_split_range_recoloring()
    // DIRECT-SAME: waveamdmachine.regalloc_transform_state =
    // DIRECT-NOT: waveamdmachine.v_accvgpr_write_b32_tuple
    // DIRECT: return
    func.func @agpr_relief_rejects_split_range_recoloring()
        -> !waveamdmachine.reg<vgpr, 1>
        attributes {waveamdmachine.agpr_count_max = 2 : i64,
                    waveamdmachine.regalloc_transform_state = {
          alias_sets = [
            {class = "agpr", id = 0 : i64,
             members = [{value = 0 : i64}], width = 1 : i64},
            {class = "agpr", id = 1 : i64,
             members = [{value = 1 : i64}], width = 1 : i64},
            {class = "vgpr", id = 2 : i64,
             members = [{value = 2 : i64}], width = 1 : i64}
          ],
          failure = {
            class = "vgpr",
            overlaps = [],
            position = 4 : i64,
            reason = "pressure",
            set = 2 : i64
          },
          stage = "linear-scan-failure",
          values = [
            {class = "agpr", end = 5 : i64, id = 0 : i64,
             kind = "op_result", number = 0 : i64, offset = 0 : i64,
             path = [0, 0, 0],
             ranges = [{end = 1 : i64, start = 0 : i64},
                       {end = 5 : i64, start = 4 : i64}],
             set = 0 : i64, start = 0 : i64, width = 1 : i64},
            {class = "agpr", end = 3 : i64, id = 1 : i64,
             kind = "op_result", number = 0 : i64, offset = 0 : i64,
             path = [0, 0, 1],
             ranges = [{end = 3 : i64, start = 0 : i64}],
             set = 1 : i64, start = 0 : i64, width = 1 : i64},
            {class = "vgpr", end = 5 : i64, id = 2 : i64,
             kind = "op_result", number = 0 : i64, offset = 0 : i64,
             path = [0, 0, 2],
             ranges = [{end = 5 : i64, start = 2 : i64}],
             set = 2 : i64, start = 2 : i64, width = 1 : i64}
          ]
        }} {
      %a = waveamdmachine.uninit : !waveamdmachine.reg<agpr, 1>
      %b = waveamdmachine.uninit : !waveamdmachine.reg<agpr, 1>
      %hot = waveamdmachine.uninit : !waveamdmachine.reg<vgpr, 1>
      return %hot : !waveamdmachine.reg<vgpr, 1>
    }
  }

  module @gfx908_payload_module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx908"} {
    // DIRECT-LABEL: func.func @agpr_relief_direct_ds_no_direct_on_gfx908()
    // DIRECT: [[LOAD:%.*]], {{%.*}} = waveamdmachine.ds_load_b32
    // DIRECT-SAME: -> (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.mem.token)
    // DIRECT: [[AG:%.*]] = waveamdmachine.v_accvgpr_write_b32_tuple [[LOAD]]
    // DIRECT: [[READ:%.*]] = waveamdmachine.v_accvgpr_read_b32_tuple [[AG]]
    // DIRECT: waveamdmachine.ds_store_b32 {{%.*}}, [[READ]]
    // DIRECT-SAME: !waveamdmachine.reg<vgpr, 1>
    func.func @agpr_relief_direct_ds_no_direct_on_gfx908()
        attributes {waveamdmachine.vgpr_count_max = 1 : i64,
                    waveamdmachine.agpr_count_max = 4 : i64,
                    waveamdmachine.regalloc_transform_state = {
          alias_sets = [
            {class = "vgpr", id = 0 : i64,
             members = [{value = 0 : i64}], width = 1 : i64},
            {class = "vgpr", id = 1 : i64,
             members = [{value = 1 : i64}], width = 1 : i64}
          ],
          failure = {
            class = "vgpr",
            overlaps = [
              {base = 0 : i64, class = "vgpr", end = 3 : i64, set = 0 : i64,
               start = 0 : i64, width = 1 : i64},
              {base = 0 : i64, class = "vgpr", end = 3 : i64, set = 1 : i64,
               start = 2 : i64, width = 1 : i64}
            ],
            position = 3 : i64,
            reason = "pressure",
            set = 1 : i64
          },
          stage = "linear-scan-failure",
          values = [
            {class = "vgpr", end = 3 : i64, fixed = 0 : i64, id = 0 : i64,
             kind = "op_result", number = 0 : i64, offset = 0 : i64,
             path = [0, 0, 0], set = 0 : i64, start = 0 : i64,
             width = 1 : i64},
            {class = "vgpr", end = 3 : i64, id = 1 : i64,
             kind = "op_result", number = 0 : i64, offset = 0 : i64,
             path = [0, 0, 2], set = 1 : i64, start = 2 : i64,
             width = 1 : i64}
          ]
        }} {
      %addr = waveamdmachine.uninit : !waveamdmachine.reg<vgpr, 1, 0>
      %dep = waveamdmachine.token : !waveamdmachine.mem.token
      %load, %tok = waveamdmachine.ds_load_b32 %addr after %dep
          : (!waveamdmachine.reg<vgpr, 1, 0>, !waveamdmachine.mem.token)
            -> (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.mem.token)
      %store = waveamdmachine.ds_store_b32 %addr, %load after %tok
          : (!waveamdmachine.reg<vgpr, 1, 0>, !waveamdmachine.reg<vgpr, 1>,
             !waveamdmachine.mem.token) -> !waveamdmachine.mem.token
      return
    }
  }
}
