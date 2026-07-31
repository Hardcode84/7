// RUN: wave-opt %s --pass-pipeline='builtin.module(transform-interpreter)' --verify-diagnostics --split-input-file | FileCheck %s

// CHECK-LABEL: func.func @promote_pressure_overage_bundle(
// CHECK-SAME: [[A:%[^:]+]]: !waveamdmachine.reg<vgpr, 1>
// CHECK-SAME: [[B:%[^:]+]]: !waveamdmachine.reg<vgpr, 1>
// CHECK-SAME: [[C:%[^:]+]]: !waveamdmachine.reg<sgpr, 1>
// CHECK-SAME: [[FIXED:%[^:]+]]: !waveamdmachine.reg<sgpr, 2, 0>
// CHECK-SAME: waveamdmachine.metadata = [{name = "wave.regalloc.sgpr_to_vgpr.dwords", value = 2 : i64}]
// CHECK-NOT: waveamdmachine.regalloc_transform_state
// CHECK: return [[A]], [[B]], [[C]], [[FIXED]]
// CHECK-LABEL: func.func @promote_partial_pressure_relief(
// CHECK-SAME: [[PARTIAL:%[^:]+]]: !waveamdmachine.reg<vgpr, 1>
// CHECK-SAME: [[PARTIAL_FIXED:%[^:]+]]: !waveamdmachine.reg<sgpr, 2, 0>
// CHECK-SAME: waveamdmachine.metadata = [{name = "wave.regalloc.sgpr_to_vgpr.dwords", value = 1 : i64}]
// CHECK-NOT: waveamdmachine.regalloc_transform_state
// CHECK: return [[PARTIAL]], [[PARTIAL_FIXED]]
// CHECK-LABEL: func.func @all_canonical_sgpr_alias_is_noop(
// CHECK-SAME: waveamdmachine.regalloc_transform_state =
// CHECK: [[CANONICAL_SRC:%.*]] = waveamdmachine.uninit
// CHECK-NEXT: waveamdmachine.v_mov_b32_tuple [[CANONICAL_SRC]]
// CHECK-SAME: waveamdmachine.regalloc_sgpr_to_vgpr_temp
// CHECK-NOT: waveamdmachine.regalloc_sgpr_to_vgpr_pinned
// CHECK: return
// CHECK-LABEL: func.func @generated_sgpr_temp_is_noop(
// CHECK-SAME: waveamdmachine.regalloc_transform_state =
// CHECK: [[GENERATED:%.*]] = waveamdmachine.uninit {waveamdmachine.regalloc_debug_temp}
// CHECK-NEXT: waveamdmachine.v_mov_b32_tuple [[GENERATED]]
// CHECK-NOT: waveamdmachine.regalloc_sgpr_to_vgpr_pinned
// CHECK: return
module attributes {transform.with_named_sequence} {
  transform.named_sequence @__transform_main(
      %root: !transform.any_op {transform.readonly}) {
    %func = transform.structured.match ops{["func.func"]} in %root
        : (!transform.any_op) -> !transform.any_op
    %result = wave.transform.regalloc_sgpr_to_vgpr_relief from %func
        : (!transform.any_op) -> !transform.any_op
    transform.yield
  }

  func.func @promote_pressure_overage_bundle(
      %a: !waveamdmachine.reg<sgpr, 1>,
      %b: !waveamdmachine.reg<sgpr, 1>,
      %c: !waveamdmachine.reg<sgpr, 1>,
      %fixed: !waveamdmachine.reg<sgpr, 2, 0>)
      -> (!waveamdmachine.reg<sgpr, 1>, !waveamdmachine.reg<sgpr, 1>,
          !waveamdmachine.reg<sgpr, 1>,
          !waveamdmachine.reg<sgpr, 2, 0>)
      attributes {waveamdmachine.regalloc_transform_state = {
        alias_sets = [
          {class = "sgpr", id = 0 : i64,
           members = [{value = 0 : i64}], width = 1 : i64},
          {class = "sgpr", id = 1 : i64,
           members = [{value = 1 : i64}], width = 1 : i64},
          {class = "sgpr", id = 2 : i64,
           members = [{value = 2 : i64}], width = 1 : i64},
          {class = "sgpr", id = 3 : i64,
           members = [{value = 3 : i64}], width = 2 : i64}
        ],
        failure = {
          class = "sgpr",
          limit = 3 : i64,
          overlaps = [
            {base = 0 : i64, class = "sgpr", end = 0 : i64,
             set = 0 : i64, start = 0 : i64, width = 1 : i64},
            {base = 1 : i64, class = "sgpr", end = 0 : i64,
             set = 1 : i64, start = 0 : i64, width = 1 : i64},
            {base = 2 : i64, class = "sgpr", end = 0 : i64,
             set = 2 : i64, start = 0 : i64, width = 1 : i64}
          ],
          position = 0 : i64,
          pressure = 5 : i64,
          reason = "pressure",
          request = 2 : i64,
          set = 3 : i64
        },
        stage = "linear-scan-failure",
        values = [
          {class = "sgpr", end = 0 : i64, id = 0 : i64,
           kind = "block_arg", number = 0 : i64, offset = 0 : i64,
           path = [0, 0], ranges = [{end = 0 : i64, start = 0 : i64}],
           set = 0 : i64, start = 0 : i64, width = 1 : i64},
          {class = "sgpr", end = 0 : i64, id = 1 : i64,
           kind = "block_arg", number = 1 : i64, offset = 0 : i64,
           path = [0, 0], ranges = [{end = 0 : i64, start = 0 : i64}],
           set = 1 : i64, start = 0 : i64, width = 1 : i64},
          {class = "sgpr", end = 0 : i64, id = 2 : i64,
           kind = "block_arg", number = 2 : i64, offset = 0 : i64,
           path = [0, 0], ranges = [{end = 0 : i64, start = 0 : i64}],
           set = 2 : i64, start = 0 : i64, width = 1 : i64},
          {class = "sgpr", end = 0 : i64, fixed = 0 : i64, id = 3 : i64,
           kind = "block_arg", number = 3 : i64, offset = 0 : i64,
           path = [0, 0], ranges = [{end = 0 : i64, start = 0 : i64}],
           set = 3 : i64, start = 0 : i64, width = 2 : i64}
        ]
      }} {
    return %a, %b, %c, %fixed
        : !waveamdmachine.reg<sgpr, 1>, !waveamdmachine.reg<sgpr, 1>,
          !waveamdmachine.reg<sgpr, 1>,
          !waveamdmachine.reg<sgpr, 2, 0>
  }

  func.func @promote_partial_pressure_relief(
      %value: !waveamdmachine.reg<sgpr, 1>,
      %fixed: !waveamdmachine.reg<sgpr, 2, 0>)
      -> (!waveamdmachine.reg<sgpr, 1>,
          !waveamdmachine.reg<sgpr, 2, 0>)
      attributes {waveamdmachine.regalloc_transform_state = {
        alias_sets = [
          {class = "sgpr", id = 0 : i64,
           members = [{value = 0 : i64}], width = 1 : i64},
          {class = "sgpr", id = 1 : i64,
           members = [{value = 1 : i64}], width = 2 : i64}
        ],
        failure = {
          class = "sgpr",
          limit = 2 : i64,
          overlaps = [
            {base = 0 : i64, class = "sgpr", end = 0 : i64,
             set = 0 : i64, start = 0 : i64, width = 1 : i64}
          ],
          position = 0 : i64,
          pressure = 4 : i64,
          reason = "pressure",
          request = 2 : i64,
          set = 1 : i64
        },
        stage = "linear-scan-failure",
        values = [
          {class = "sgpr", end = 0 : i64, id = 0 : i64,
           kind = "block_arg", number = 0 : i64, offset = 0 : i64,
           path = [0, 0], ranges = [{end = 0 : i64, start = 0 : i64}],
           set = 0 : i64, start = 0 : i64, width = 1 : i64},
          {class = "sgpr", end = 0 : i64, fixed = 0 : i64, id = 1 : i64,
           kind = "block_arg", number = 1 : i64, offset = 0 : i64,
           path = [0, 0], ranges = [{end = 0 : i64, start = 0 : i64}],
           set = 1 : i64, start = 0 : i64, width = 2 : i64}
        ]
      }} {
    return %value, %fixed
        : !waveamdmachine.reg<sgpr, 1>, !waveamdmachine.reg<sgpr, 2, 0>
  }

  func.func @all_canonical_sgpr_alias_is_noop() attributes {
    waveamdmachine.regalloc_transform_state = {
      alias_sets = [
        {class = "sgpr", id = 0 : i64,
         members = [{value = 0 : i64}], width = 1 : i64},
        {class = "vgpr", id = 1 : i64,
         members = [{value = 1 : i64}], width = 1 : i64}
      ],
      failure = {
        class = "sgpr",
        limit = 0 : i64,
        overlaps = [],
        position = 0 : i64,
        pressure = 1 : i64,
        reason = "pressure",
        request = 1 : i64,
        set = 0 : i64
      },
      stage = "linear-scan-failure",
      values = [
        {class = "sgpr", end = 1 : i64, id = 0 : i64,
         kind = "op_result", number = 0 : i64, offset = 0 : i64,
         path = [0, 0, 0], ranges = [{end = 1 : i64, start = 0 : i64}],
         set = 0 : i64, start = 0 : i64, width = 1 : i64},
        {class = "vgpr", end = 1 : i64, id = 1 : i64,
         kind = "op_result", number = 0 : i64, offset = 0 : i64,
         path = [0, 0, 1], ranges = [{end = 1 : i64, start = 1 : i64}],
         set = 1 : i64, start = 1 : i64, width = 1 : i64}
      ]
    }
  } {
    %src = waveamdmachine.uninit : !waveamdmachine.reg<sgpr, 1>
    %promoted = waveamdmachine.v_mov_b32_tuple %src
        {waveamdmachine.regalloc_sgpr_to_vgpr_temp}
        : (!waveamdmachine.reg<sgpr, 1>) -> !waveamdmachine.reg<vgpr, 1>
    return
  }

  func.func @generated_sgpr_temp_is_noop() attributes {
    waveamdmachine.regalloc_transform_state = {
      alias_sets = [
        {class = "sgpr", id = 0 : i64,
         members = [{value = 0 : i64}], width = 1 : i64},
        {class = "vgpr", id = 1 : i64,
         members = [{value = 1 : i64}], width = 1 : i64}
      ],
      failure = {
        class = "sgpr",
        limit = 0 : i64,
        overlaps = [],
        position = 0 : i64,
        pressure = 1 : i64,
        reason = "pressure",
        request = 1 : i64,
        set = 0 : i64
      },
      stage = "linear-scan-failure",
      values = [
        {class = "sgpr", end = 1 : i64, id = 0 : i64,
         kind = "op_result", number = 0 : i64, offset = 0 : i64,
         path = [0, 0, 0], ranges = [{end = 1 : i64, start = 0 : i64}],
         set = 0 : i64, start = 0 : i64, width = 1 : i64},
        {class = "vgpr", end = 1 : i64, id = 1 : i64,
         kind = "op_result", number = 0 : i64, offset = 0 : i64,
         path = [0, 0, 1], ranges = [{end = 1 : i64, start = 1 : i64}],
         set = 1 : i64, start = 1 : i64, width = 1 : i64}
      ]
    }
  } {
    %src = waveamdmachine.uninit {waveamdmachine.regalloc_debug_temp}
        : !waveamdmachine.reg<sgpr, 1>
    %use = waveamdmachine.v_mov_b32_tuple %src
        : (!waveamdmachine.reg<sgpr, 1>) -> !waveamdmachine.reg<vgpr, 1>
    return
  }
}

// -----

module attributes {transform.with_named_sequence} {
  transform.named_sequence @__transform_main(
      %root: !transform.any_op {transform.readonly}) {
    %func = transform.structured.match ops{["func.func"]} in %root
        : (!transform.any_op) -> !transform.any_op
    // expected-error @below {{failed to run regalloc SGPR to VGPR relief}}
    %result = wave.transform.regalloc_sgpr_to_vgpr_relief from %func
        : (!transform.any_op) -> !transform.any_op
    transform.yield
  }

  // expected-error @below {{regalloc state field `limit` is not an integer}}
  func.func @non_integer_limit() attributes {
    waveamdmachine.regalloc_transform_state = {
      failure = {class = "sgpr", limit = "two", position = 0 : i64,
                 reason = "pressure", set = 0 : i64},
      stage = "linear-scan-failure"
    }
  } {
    return
  }
}

// -----

module attributes {transform.with_named_sequence} {
  transform.named_sequence @__transform_main(
      %root: !transform.any_op {transform.readonly}) {
    %func = transform.structured.match ops{["func.func"]} in %root
        : (!transform.any_op) -> !transform.any_op
    // expected-error @below {{failed to run regalloc SGPR to VGPR relief}}
    %result = wave.transform.regalloc_sgpr_to_vgpr_relief from %func
        : (!transform.any_op) -> !transform.any_op
    transform.yield
  }

  // expected-error @below {{regalloc state integer `pressure` exceeds supported range}}
  func.func @negative_pressure() attributes {
    waveamdmachine.regalloc_transform_state = {
      failure = {class = "sgpr", position = 0 : i64, pressure = -1 : i64,
                 reason = "pressure", set = 0 : i64},
      stage = "linear-scan-failure"
    }
  } {
    return
  }
}

// -----

module attributes {transform.with_named_sequence} {
  transform.named_sequence @__transform_main(
      %root: !transform.any_op {transform.readonly}) {
    %func = transform.structured.match ops{["func.func"]} in %root
        : (!transform.any_op) -> !transform.any_op
    // expected-error @below {{failed to run regalloc SGPR to VGPR relief}}
    %result = wave.transform.regalloc_sgpr_to_vgpr_relief from %func
        : (!transform.any_op) -> !transform.any_op
    transform.yield
  }

  // expected-error @below {{regalloc state integer `request` exceeds supported range}}
  func.func @oversized_request() attributes {
    waveamdmachine.regalloc_transform_state = {
      failure = {class = "sgpr", position = 0 : i64,
                 reason = "pressure", request = 4294967296 : i64,
                 set = 0 : i64},
      stage = "linear-scan-failure"
    }
  } {
    return
  }
}
