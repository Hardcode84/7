// RUN: wave-opt %s --pass-pipeline='builtin.module(transform-preload-library{transform-library-paths=%wave_pipelines},transform-interpreter{entry-point=waveamd_regalloc_transform_loop})' | FileCheck %s

module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx950"} {
  func.func private @fixed_declaration() -> !waveamdmachine.reg<vgpr, 1, 7>

  // CHECK-LABEL: func.func @remat_sharing_first()
  // CHECK-SAME: waveamdmachine.metadata = [{name = "wave.regalloc.iterations", value = 2 : i64}
  // CHECK-SAME: waveamdmachine.regalloc_assignments
  // CHECK-SAME: stage = "linear-scan-success"
  // CHECK-NOT: scratch_spill_bytes
  // CHECK: waveamdmachine.uniform_loop
  // CHECK: [[FIRST_SHARED:%.*]] = waveamdmachine.v_and_b32
  // CHECK-NEXT: [[FIRST_ROOT0:%.*]] = waveamdmachine.v_xor_b32 [[FIRST_SHARED]]
  // CHECK-NEXT: waveamdmachine.v_add_u32 [[FIRST_ROOT0]]
  // CHECK-NEXT: [[FIRST_ROOT1:%.*]] = waveamdmachine.v_xor_b32 [[FIRST_SHARED]]
  // CHECK-NEXT: waveamdmachine.v_add_u32 [[FIRST_ROOT1]]
  // CHECK-NOT: waveamdmachine.v_and_b32
  func.func @remat_sharing_first()
      attributes {waveamdmachine.vgpr_count_max = 3 : i64,
                  waveamdmachine.agpr_count_max = 0 : i64} {
    %zero = waveamdmachine.imm 0 : !waveamdmachine.imm
    %one = waveamdmachine.imm 1 : !waveamdmachine.imm
    %two = waveamdmachine.imm 2 : !waveamdmachine.imm
    %tid = waveamdmachine.v_workitem_id_x
        : !waveamdmachine.reg<vgpr, 1, 0>
    %shared = waveamdmachine.v_and_b32 %tid, %one
        : (!waveamdmachine.reg<vgpr, 1, 0>, !waveamdmachine.imm)
          -> !waveamdmachine.reg<vgpr, 1>
    %root0 = waveamdmachine.v_xor_b32 %shared, %one
        : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.imm)
          -> !waveamdmachine.reg<vgpr, 1>
    %root1 = waveamdmachine.v_xor_b32 %shared, %two
        : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.imm)
          -> !waveamdmachine.reg<vgpr, 1>
    %cond = waveamdmachine.s_cmp_lt_i32 %zero, %one
        : (!waveamdmachine.imm, !waveamdmachine.imm)
          -> !waveamdmachine.reg<scc, 1>
    waveamdmachine.uniform_loop if %cond : !waveamdmachine.reg<scc, 1> {
      %a = waveamdmachine.uninit {waveamdmachine.regalloc_remat_temp}
          : !waveamdmachine.reg<vgpr, 1>
      %b = waveamdmachine.uninit {waveamdmachine.regalloc_remat_temp}
          : !waveamdmachine.reg<vgpr, 1>
      %pressure = waveamdmachine.v_add_u32 %a, %b
          : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>)
            -> !waveamdmachine.reg<vgpr, 1>
      %use0 = waveamdmachine.v_add_u32 %root0, %one
          : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.imm)
            -> !waveamdmachine.reg<vgpr, 1>
      %use1 = waveamdmachine.v_add_u32 %root1, %two
          : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.imm)
            -> !waveamdmachine.reg<vgpr, 1>
      %keep = waveamdmachine.v_add_u32 %use0, %use1
          : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>)
            -> !waveamdmachine.reg<vgpr, 1>
      waveamdmachine.continue_if %cond : !waveamdmachine.reg<scc, 1>
    }
    return
  }

  // Fixed declaration keeps module-wide assignment rollback illegal.
  // CHECK-LABEL: func.func @fixed_call_boundary()
  // CHECK-SAME: -> !waveamdmachine.reg<vgpr, 1, 7>
  // CHECK-SAME: waveamdmachine.metadata = [{name = "wave.regalloc.iterations", value = 2 : i64}
  // CHECK: [[FIXED:%.*]] = call @fixed_declaration()
  // CHECK-SAME: -> !waveamdmachine.reg<vgpr, 1, 7>
  // CHECK: return [[FIXED]] : !waveamdmachine.reg<vgpr, 1, 7>
  func.func @fixed_call_boundary() -> !waveamdmachine.reg<vgpr, 1, 7> {
    %value = func.call @fixed_declaration()
        : () -> !waveamdmachine.reg<vgpr, 1, 7>
    return %value : !waveamdmachine.reg<vgpr, 1, 7>
  }

  // CHECK-LABEL: func.func @remat_sharing_second()
  // CHECK-SAME: waveamdmachine.metadata = [{name = "wave.regalloc.iterations", value = 2 : i64}
  // CHECK-SAME: waveamdmachine.regalloc_assignments
  // CHECK-SAME: stage = "linear-scan-success"
  // CHECK-NOT: scratch_spill_bytes
  // CHECK: waveamdmachine.uniform_loop
  // CHECK: [[SECOND_SHARED:%.*]] = waveamdmachine.v_and_b32
  // CHECK-NEXT: [[SECOND_ROOT0:%.*]] = waveamdmachine.v_xor_b32 [[SECOND_SHARED]]
  // CHECK-NEXT: waveamdmachine.v_add_u32 [[SECOND_ROOT0]]
  // CHECK-NEXT: [[SECOND_ROOT1:%.*]] = waveamdmachine.v_xor_b32 [[SECOND_SHARED]]
  // CHECK-NEXT: waveamdmachine.v_add_u32 [[SECOND_ROOT1]]
  // CHECK-NOT: waveamdmachine.v_and_b32
  func.func @remat_sharing_second()
      attributes {waveamdmachine.vgpr_count_max = 3 : i64,
                  waveamdmachine.agpr_count_max = 0 : i64} {
    %zero = waveamdmachine.imm 0 : !waveamdmachine.imm
    %one = waveamdmachine.imm 1 : !waveamdmachine.imm
    %two = waveamdmachine.imm 2 : !waveamdmachine.imm
    %tid = waveamdmachine.v_workitem_id_x
        : !waveamdmachine.reg<vgpr, 1, 0>
    %shared = waveamdmachine.v_and_b32 %tid, %one
        : (!waveamdmachine.reg<vgpr, 1, 0>, !waveamdmachine.imm)
          -> !waveamdmachine.reg<vgpr, 1>
    %root0 = waveamdmachine.v_xor_b32 %shared, %one
        : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.imm)
          -> !waveamdmachine.reg<vgpr, 1>
    %root1 = waveamdmachine.v_xor_b32 %shared, %two
        : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.imm)
          -> !waveamdmachine.reg<vgpr, 1>
    %cond = waveamdmachine.s_cmp_lt_i32 %zero, %one
        : (!waveamdmachine.imm, !waveamdmachine.imm)
          -> !waveamdmachine.reg<scc, 1>
    waveamdmachine.uniform_loop if %cond : !waveamdmachine.reg<scc, 1> {
      %a = waveamdmachine.uninit {waveamdmachine.regalloc_remat_temp}
          : !waveamdmachine.reg<vgpr, 1>
      %b = waveamdmachine.uninit {waveamdmachine.regalloc_remat_temp}
          : !waveamdmachine.reg<vgpr, 1>
      %pressure = waveamdmachine.v_add_u32 %a, %b
          : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>)
            -> !waveamdmachine.reg<vgpr, 1>
      %use0 = waveamdmachine.v_add_u32 %root0, %one
          : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.imm)
            -> !waveamdmachine.reg<vgpr, 1>
      %use1 = waveamdmachine.v_add_u32 %root1, %two
          : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.imm)
            -> !waveamdmachine.reg<vgpr, 1>
      %keep = waveamdmachine.v_add_u32 %use0, %use1
          : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>)
            -> !waveamdmachine.reg<vgpr, 1>
      waveamdmachine.continue_if %cond : !waveamdmachine.reg<scc, 1>
    }
    return
  }
}
