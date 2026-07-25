// RUN: wave-opt %s --waveamd-machine-schedule='apply-schedule=1' | FileCheck %s --check-prefix=IR
// RUN: wave-opt %s --waveamd-machine-schedule-report='print-candidates=1' 2>&1 >/dev/null | FileCheck %s --check-prefix=REPORT

// IR-LABEL: func.func @disjoint_branch_pressure
// IR: [[SHARED:%.*]] = waveamdmachine.v_add_u32
// IR: waveamdmachine.uniform_if
// IR: [[THEN_M0:%.*]] = waveamdmachine.s_mov_m0
// IR-NEXT: waveamdmachine.v_add_u32 [[SHARED]]
// IR-NEXT: waveamdmachine.global_load_lds_b32
// IR: otherwise
// IR: [[ELSE_M0:%.*]] = waveamdmachine.s_mov_m0
// IR-NEXT: waveamdmachine.v_add_u32 [[SHARED]]
// IR-NEXT: waveamdmachine.global_load_lds_b32
// IR-LABEL: func.func @boundary_touching_ranges
// IR: [[RIGHT_FIRST:%.*]] = waveamdmachine.v_add_u32
// IR: [[RIGHT_MIDDLE:%.*]] = waveamdmachine.v_xor_b32
// IR: waveamdmachine.v_add_u32 [[RIGHT_FIRST]], [[RIGHT_MIDDLE]]
// IR-LABEL: func.func @left_boundary_touching_range
// IR: [[LEFT:%.*]] = waveamdmachine.v_add_u32
// IR: waveamdmachine.sched_barrier
// IR: [[LEFT_FIRST:%.*]] = waveamdmachine.v_xor_b32 [[LEFT]]
// IR: [[LEFT_MIDDLE:%.*]] = waveamdmachine.v_xor_b32
// IR: waveamdmachine.v_add_u32 [[LEFT_FIRST]], [[LEFT_MIDDLE]]

// Seven states x four in-range members per arm.
// REPORT-LABEL: waveamd-machine-schedule-report candidate func=disjoint_branch_pressure region=1 name=greedy
// REPORT-SAME: order=0,4,1,2,3,5,6
// REPORT-SAME: pressure_state_builds=7 pressure_member_visits=28
// REPORT-LABEL: waveamd-machine-schedule-report candidate func=disjoint_branch_pressure region=2 name=greedy
// REPORT-SAME: order=0,4,1,2,3,5,6
// REPORT-SAME: pressure_state_builds=7 pressure_member_visits=28
// REPORT-LABEL: waveamd-machine-schedule-report candidate func=boundary_touching_ranges region=0 name=greedy
// REPORT-SAME: order=0,1,2
// REPORT-SAME: pressure_state_builds=3 pressure_member_visits=9
// REPORT-LABEL: waveamd-machine-schedule-report candidate func=left_boundary_touching_range region=1 name=greedy
// REPORT-SAME: order=0,1,2
// REPORT-SAME: pressure_state_builds=3 pressure_member_visits=12

module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx950"} {
func.func @disjoint_branch_pressure(
    %shared_seed: !waveamdmachine.reg<vgpr, 1>,
    %cond: !waveamdmachine.reg<scc, 1>,
    %base: !waveamdmachine.reg<sgpr, 1>,
    %off: !waveamdmachine.reg<vgpr, 1>,
    %ptr: !waveamdmachine.reg<sgpr, 2>,
    %dep: !waveamdmachine.mem.token,
    %inc0: !waveamdmachine.reg<vgpr, 1>,
    %inc1: !waveamdmachine.reg<vgpr, 1>,
    %keep0: !waveamdmachine.reg<sgpr, 1>,
    %keep1: !waveamdmachine.reg<sgpr, 1>)
    attributes {waveamdmachine.target_waves = 8 : i64} {
  %zero = waveamdmachine.imm 0 : !waveamdmachine.imm
  %shared = waveamdmachine.v_add_u32 %shared_seed, %inc0
      : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>)
        -> !waveamdmachine.reg<vgpr, 1>
  %wide = waveamdmachine.v_mov_b32_tuple %zero {registers = 55 : i64}
      : (!waveamdmachine.imm) -> !waveamdmachine.reg<vgpr, 55>
  waveamdmachine.uniform_if %cond {
    %m0 = waveamdmachine.s_mov_m0 %base
        : (!waveamdmachine.reg<sgpr, 1>) -> !waveamdmachine.m0
    %tok = waveamdmachine.global_load_lds_b32 %off, %ptr, %m0 after %dep
        : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<sgpr, 2>,
           !waveamdmachine.m0, !waveamdmachine.mem.token)
          -> !waveamdmachine.mem.token
    %raised = waveamdmachine.v_add_u32 %inc0, %inc1
        : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>)
          -> !waveamdmachine.reg<vgpr, 1>
    %neutral = waveamdmachine.s_cmp_eq_u32 %keep0, %keep1
        : (!waveamdmachine.reg<sgpr, 1>, !waveamdmachine.reg<sgpr, 1>)
          -> !waveamdmachine.reg<scc, 1>
    %consume = waveamdmachine.v_add_u32 %shared, %inc0
        : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>)
          -> !waveamdmachine.reg<vgpr, 1>
    %use0 = waveamdmachine.v_xor_b32 %raised, %inc0
        : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>)
          -> !waveamdmachine.reg<vgpr, 1>
    %use1 = waveamdmachine.v_xor_b32 %use0, %inc1
        : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>)
          -> !waveamdmachine.reg<vgpr, 1>
    %looped = waveamdmachine.uniform_loop if %neutral
        : !waveamdmachine.reg<scc, 1>
        carries(%wide : !waveamdmachine.reg<vgpr, 55>) {
    ^bb0(%carry: !waveamdmachine.reg<vgpr, 55>):
      waveamdmachine.continue_if %neutral : !waveamdmachine.reg<scc, 1>
          carries(%carry : !waveamdmachine.reg<vgpr, 55>)
    } -> !waveamdmachine.reg<vgpr, 55>
    waveamdmachine.yield
  } otherwise {
    %m0 = waveamdmachine.s_mov_m0 %base
        : (!waveamdmachine.reg<sgpr, 1>) -> !waveamdmachine.m0
    %tok = waveamdmachine.global_load_lds_b32 %off, %ptr, %m0 after %dep
        : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<sgpr, 2>,
           !waveamdmachine.m0, !waveamdmachine.mem.token)
          -> !waveamdmachine.mem.token
    %raised = waveamdmachine.v_add_u32 %inc0, %inc1
        : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>)
          -> !waveamdmachine.reg<vgpr, 1>
    %neutral = waveamdmachine.s_cmp_eq_u32 %keep0, %keep1
        : (!waveamdmachine.reg<sgpr, 1>, !waveamdmachine.reg<sgpr, 1>)
          -> !waveamdmachine.reg<scc, 1>
    %consume = waveamdmachine.v_add_u32 %shared, %inc0
        : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>)
          -> !waveamdmachine.reg<vgpr, 1>
    %use0 = waveamdmachine.v_xor_b32 %raised, %inc0
        : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>)
          -> !waveamdmachine.reg<vgpr, 1>
    %use1 = waveamdmachine.v_xor_b32 %use0, %inc1
        : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>)
          -> !waveamdmachine.reg<vgpr, 1>
    %looped = waveamdmachine.uniform_loop if %neutral
        : !waveamdmachine.reg<scc, 1>
        carries(%wide : !waveamdmachine.reg<vgpr, 55>) {
    ^bb0(%carry: !waveamdmachine.reg<vgpr, 55>):
      waveamdmachine.continue_if %neutral : !waveamdmachine.reg<scc, 1>
          carries(%carry : !waveamdmachine.reg<vgpr, 55>)
    } -> !waveamdmachine.reg<vgpr, 55>
    waveamdmachine.yield
  } : !waveamdmachine.reg<scc, 1>
  return
}

func.func @boundary_touching_ranges(
    %entry: !waveamdmachine.reg<vgpr, 1>,
    %a: !waveamdmachine.reg<vgpr, 1>,
    %b: !waveamdmachine.reg<vgpr, 1>)
    -> !waveamdmachine.reg<vgpr, 1> {
  %first = waveamdmachine.v_add_u32 %entry, %a
      : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>)
        -> !waveamdmachine.reg<vgpr, 1>
  %middle = waveamdmachine.v_xor_b32 %a, %b
      : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>)
        -> !waveamdmachine.reg<vgpr, 1>
  %last = waveamdmachine.v_add_u32 %first, %middle
      : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>)
        -> !waveamdmachine.reg<vgpr, 1>
  return %last : !waveamdmachine.reg<vgpr, 1>
}

func.func @left_boundary_touching_range(
    %a: !waveamdmachine.reg<vgpr, 1>,
    %b: !waveamdmachine.reg<vgpr, 1>)
    -> !waveamdmachine.reg<vgpr, 1> {
  %left = waveamdmachine.v_add_u32 %a, %b
      : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>)
        -> !waveamdmachine.reg<vgpr, 1>
  waveamdmachine.sched_barrier
  %first = waveamdmachine.v_xor_b32 %left, %a
      : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>)
        -> !waveamdmachine.reg<vgpr, 1>
  %middle = waveamdmachine.v_xor_b32 %a, %b
      : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>)
        -> !waveamdmachine.reg<vgpr, 1>
  %last = waveamdmachine.v_add_u32 %first, %middle
      : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>)
        -> !waveamdmachine.reg<vgpr, 1>
  return %last : !waveamdmachine.reg<vgpr, 1>
}
}
