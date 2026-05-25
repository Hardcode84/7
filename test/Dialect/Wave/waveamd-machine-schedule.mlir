// RUN: wave-opt %s --waveamd-machine-schedule | FileCheck %s --check-prefix=NOOP
// RUN: wave-opt %s --waveamd-machine-schedule='print-regions=1' 2>&1 | FileCheck %s --check-prefix=REGION
// RUN: wave-opt %s --pass-pipeline='builtin.module(transform-interpreter)' | FileCheck %s --check-prefix=APPLY

module attributes {transform.with_named_sequence,
                   waveamdmachine.target = "amdgcn-amd-amdhsa--gfx1100"} {
// NOOP-LABEL: func.func @regions
// NOOP: waveamdmachine.s_waitcnt
// NOOP: waveamdmachine.uniform_loop
// NOOP: waveamdmachine.s_barrier
// NOOP: return
// APPLY-LABEL: func.func @regions
// APPLY: waveamdmachine.uniform_loop
func.func @regions(%a: !waveamdmachine.reg<vgpr, 1>,
                   %b: !waveamdmachine.reg<vgpr, 1>,
                   %iv0: !waveamdmachine.reg<sgpr, 1>) {
  %one = waveamdmachine.imm 1 : !waveamdmachine.imm
  %wait = waveamdmachine.imm 0 : !waveamdmachine.imm
  %v0 = waveamdmachine.v_add_u32 %a, %b : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>) -> !waveamdmachine.reg<vgpr, 1>
  %v1 = waveamdmachine.v_add_u32 %v0, %b : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>) -> !waveamdmachine.reg<vgpr, 1>
  waveamdmachine.s_waitcnt %wait : (!waveamdmachine.imm) -> ()
  %v2 = waveamdmachine.v_add_u32 %v1, %b : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>) -> !waveamdmachine.reg<vgpr, 1>
  %r = waveamdmachine.uniform_loop carries(%iv0 : !waveamdmachine.reg<sgpr, 1>) {
  ^bb0(%iv: !waveamdmachine.reg<sgpr, 1>):
    %next:2 = waveamdmachine.s_add_i32 %iv, %one : (!waveamdmachine.reg<sgpr, 1>, !waveamdmachine.imm) -> (!waveamdmachine.reg<sgpr, 1>, !waveamdmachine.reg<scc, 1>)
    %scc = waveamdmachine.s_cmp_lt_i32 %next#0, %one : (!waveamdmachine.reg<sgpr, 1>, !waveamdmachine.imm) -> !waveamdmachine.reg<scc, 1>
    waveamdmachine.continue_if %scc : !waveamdmachine.reg<scc, 1> carries(%next#0 : !waveamdmachine.reg<sgpr, 1>)
  } -> !waveamdmachine.reg<sgpr, 1>
  waveamdmachine.s_barrier : () -> ()
  %v3 = waveamdmachine.v_add_u32 %v2, %b : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>) -> !waveamdmachine.reg<vgpr, 1>
  return
}

transform.named_sequence @body(
    %mod: !transform.any_op {transform.consumed},
    %trial: !transform.param<i64> {transform.readonly}) {
  %scheduled = transform.apply_registered_pass "waveamd-machine-schedule" to %mod
      : (!transform.any_op) -> !transform.any_op
  transform.yield
}

transform.named_sequence @score(
    %mod: !transform.any_op {transform.readonly},
    %trial: !transform.param<i64> {transform.readonly})
    -> !transform.param<i64> {
  transform.yield %trial : !transform.param<i64>
}

transform.named_sequence @__transform_main(%root: !transform.any_op {transform.consumed}) {
  %winner, %score = wave.transform.tune %root body = @body score = @score {
    variables = {trial = #wave.tune_enum<[1]>}
  } : (!transform.any_op) -> (!transform.any_op, !transform.param<i64>)
  transform.yield
}
}

// REGION: waveamd-machine-schedule region func=regions block=0 region=0 ops=4 first=waveamdmachine.imm last=waveamdmachine.v_add_u32
// REGION: waveamd-machine-schedule region func=regions block=0 region=1 ops=1 first=waveamdmachine.v_add_u32 last=waveamdmachine.v_add_u32
// REGION: waveamd-machine-schedule region func=regions block=1 region=2 ops=2 first=waveamdmachine.s_add_i32 last=waveamdmachine.s_cmp_lt_i32
// REGION: waveamd-machine-schedule region func=regions block=0 region=3 ops=1 first=waveamdmachine.v_add_u32 last=waveamdmachine.v_add_u32
