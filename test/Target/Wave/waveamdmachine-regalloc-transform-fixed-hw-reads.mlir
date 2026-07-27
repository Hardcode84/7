// RUN: wave-opt %s --pass-pipeline='builtin.module(transform-interpreter{entry-point=linear_scan},waveamd-resource-info)' | FileCheck %s

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
    // CHECK-LABEL: func.func @overlapping_fixed_workitem_reads
    // CHECK: [[WI0:%.*]] = waveamdmachine.v_workitem_id_x : !waveamdmachine.reg<vgpr, 1, 0>
    // CHECK: [[WI1:%.*]] = waveamdmachine.v_workitem_id_x : !waveamdmachine.reg<vgpr, 1, 0>
    // CHECK: waveamdmachine.v_add_u32 [[WI0]], [[WI1]]
    // CHECK-SAME: -> !waveamdmachine.reg<vgpr, 1, 1>
    func.func @overlapping_fixed_workitem_reads()
        -> !waveamdmachine.reg<vgpr, 1>
        attributes {waveamdmachine.vgpr_count_max = 2 : i64} {
      %wi0 = waveamdmachine.v_workitem_id_x
          : !waveamdmachine.reg<vgpr, 1, 0>
      %wi1 = waveamdmachine.v_workitem_id_x
          : !waveamdmachine.reg<vgpr, 1, 0>
      %sum = waveamdmachine.v_add_u32 %wi0, %wi1
          : (!waveamdmachine.reg<vgpr, 1, 0>,
             !waveamdmachine.reg<vgpr, 1, 0>)
          -> !waveamdmachine.reg<vgpr, 1>
      return %sum : !waveamdmachine.reg<vgpr, 1>
    }

    // CHECK-LABEL: func.func @loop_fixed_workitem_read_reserves_backedge
    // CHECK-SAME: [[CARRY:%[^:]+]]: !waveamdmachine.reg<vgpr, 1, 1>
    // CHECK: waveamdmachine.uniform_loop
    // CHECK: ^bb0([[ITER:%[^:]+]]: !waveamdmachine.reg<vgpr, 1, 1>):
    // CHECK: [[WI:%.*]] = waveamdmachine.v_workitem_id_x
    // CHECK-SAME: !waveamdmachine.reg<vgpr, 1, 0>
    // CHECK: [[SUM:%.*]] = waveamdmachine.v_add_u32 [[WI]], [[ITER]]
    // CHECK-SAME: -> !waveamdmachine.reg<vgpr, 1, 2>
    // CHECK: [[NEXT:%.*]] = waveamdmachine.v_add_u32 [[SUM]], [[ITER]]
    // CHECK-SAME: -> !waveamdmachine.reg<vgpr, 1, 1>
    func.func @loop_fixed_workitem_read_reserves_backedge(
        %cond: !waveamdmachine.reg<scc, 1>,
        %carry: !waveamdmachine.reg<vgpr, 1>)
        -> !waveamdmachine.reg<vgpr, 1>
        attributes {wave.kernel,
                    waveamdmachine.vgpr_count_max = 3 : i64} {
      %loop = waveamdmachine.uniform_loop if %cond
          : !waveamdmachine.reg<scc, 1>
          carries(%carry : !waveamdmachine.reg<vgpr, 1>) {
      ^bb0(%iter: !waveamdmachine.reg<vgpr, 1>):
        %wi = waveamdmachine.v_workitem_id_x
            : !waveamdmachine.reg<vgpr, 1, 0>
        %sum = waveamdmachine.v_add_u32 %wi, %iter
            : (!waveamdmachine.reg<vgpr, 1, 0>,
               !waveamdmachine.reg<vgpr, 1>)
              -> !waveamdmachine.reg<vgpr, 1>
        %next = waveamdmachine.v_add_u32 %sum, %iter
            : (!waveamdmachine.reg<vgpr, 1>,
               !waveamdmachine.reg<vgpr, 1>)
              -> !waveamdmachine.reg<vgpr, 1>
        waveamdmachine.continue_if %cond
            : !waveamdmachine.reg<scc, 1>
            carries(%next : !waveamdmachine.reg<vgpr, 1>)
      } -> !waveamdmachine.reg<vgpr, 1>
      return %loop : !waveamdmachine.reg<vgpr, 1>
    }

    // CHECK-LABEL: func.func @branch_disjoint_entry_workitem_reservation
    // CHECK: [[WI:%.*]] = waveamdmachine.v_workitem_id_x
    // CHECK-SAME: !waveamdmachine.reg<vgpr, 1, 0>
    // CHECK: waveamdmachine.uniform_if
    // CHECK: [[SCRATCH:%.*]] = waveamdmachine.uninit
    // CHECK-SAME: !waveamdmachine.reg<vgpr, 1, 0>
    // CHECK: waveamdmachine.v_cmpx_eq_u32 [[SCRATCH]], [[SCRATCH]]
    // CHECK: otherwise
    // CHECK: waveamdmachine.v_cmpx_eq_u32 [[WI]], [[WI]]
    func.func @branch_disjoint_entry_workitem_reservation()
        attributes {wave.kernel, wave.workgroup_size = array<i32: 64, 1, 1>,
                    waveamdmachine.vgpr_count_max = 1 : i64} {
      %zero = waveamdmachine.imm 0 : !waveamdmachine.imm
      %cond = waveamdmachine.s_cmp_eq_u32 %zero, %zero
          : (!waveamdmachine.imm, !waveamdmachine.imm)
            -> !waveamdmachine.reg<scc, 1>
      %wi = waveamdmachine.v_workitem_id_x
          : !waveamdmachine.reg<vgpr, 1, 0>
      waveamdmachine.uniform_if %cond {
        %scratch = waveamdmachine.uninit : !waveamdmachine.reg<vgpr, 1>
        waveamdmachine.v_cmpx_eq_u32 %scratch, %scratch
            : (!waveamdmachine.reg<vgpr, 1>,
               !waveamdmachine.reg<vgpr, 1>) -> ()
        waveamdmachine.yield
      } otherwise {
        waveamdmachine.v_cmpx_eq_u32 %wi, %wi
            : (!waveamdmachine.reg<vgpr, 1, 0>,
               !waveamdmachine.reg<vgpr, 1, 0>) -> ()
        waveamdmachine.yield
      } : !waveamdmachine.reg<scc, 1>
      waveamdmachine.s_endpgm
      return
    }
  }
}
