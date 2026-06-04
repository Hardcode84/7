// RUN: wave-opt %s --waveamd-machine-schedule | FileCheck %s --check-prefix=NOOP
// RUN: wave-opt %s --waveamd-machine-schedule-report='print-regions=1' 2>&1 | FileCheck %s --check-prefix=REGION
// RUN: wave-opt %s --waveamd-machine-schedule-report='print-deps=1' 2>&1 | FileCheck %s --check-prefix=DEPS
// RUN: wave-opt %s --waveamd-machine-schedule-report='print-score=1' 2>&1 | FileCheck %s --check-prefix=SCORE
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
    %old:2 = waveamdmachine.s_add_i32 %iv, %one : (!waveamdmachine.reg<sgpr, 1>, !waveamdmachine.imm) -> (!waveamdmachine.reg<sgpr, 1>, !waveamdmachine.reg<scc, 1>)
    %next:2 = waveamdmachine.s_add_i32 %iv, %one : (!waveamdmachine.reg<sgpr, 1>, !waveamdmachine.imm) -> (!waveamdmachine.reg<sgpr, 1>, !waveamdmachine.reg<scc, 1>)
    %scc = waveamdmachine.s_cmp_lt_i32 %next#0, %one : (!waveamdmachine.reg<sgpr, 1>, !waveamdmachine.imm) -> !waveamdmachine.reg<scc, 1>
    waveamdmachine.continue_if %scc : !waveamdmachine.reg<scc, 1> carries(%next#0 : !waveamdmachine.reg<sgpr, 1>)
  } -> !waveamdmachine.reg<sgpr, 1>
  waveamdmachine.s_barrier : () -> ()
  %v3 = waveamdmachine.v_add_u32 %v2, %b : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>) -> !waveamdmachine.reg<vgpr, 1>
  return
}

func.func @memory_edges(%off: !waveamdmachine.reg<vgpr, 1>,
                        %base: !waveamdmachine.reg<sgpr, 2>,
                        %value: !waveamdmachine.reg<vgpr, 1>) {
  %tok0 = waveamdmachine.token : !waveamdmachine.mem.token
  %loaded, %tok1 = waveamdmachine.global_load_b32 %off, %base after %tok0
      : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<sgpr, 2>, !waveamdmachine.mem.token)
        -> (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.mem.token)
  %sum = waveamdmachine.v_add_u32 %loaded, %value : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>) -> !waveamdmachine.reg<vgpr, 1>
  %store0 = waveamdmachine.global_store_b32 %off, %sum, %base after %tok1
      : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<sgpr, 2>, !waveamdmachine.mem.token)
        -> !waveamdmachine.mem.token
  %store1 = waveamdmachine.global_store_b32 %off, %value, %base
      : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<sgpr, 2>)
        -> !waveamdmachine.mem.token
  return
}

func.func @vcc_edges(%a: !waveamdmachine.reg<vgpr, 2>,
                     %b: !waveamdmachine.reg<vgpr, 2>,
                     %c: !waveamdmachine.reg<vgpr, 2>) {
  %x, %vcc0 = waveamdmachine.v_add_u64 %a, %b
      : (!waveamdmachine.reg<vgpr, 2>, !waveamdmachine.reg<vgpr, 2>)
        -> (!waveamdmachine.reg<vgpr, 2>, !waveamdmachine.reg<vcc, 1>)
  %y, %vcc1 = waveamdmachine.v_add_u64 %a, %c
      : (!waveamdmachine.reg<vgpr, 2>, !waveamdmachine.reg<vgpr, 2>)
        -> (!waveamdmachine.reg<vgpr, 2>, !waveamdmachine.reg<vcc, 1>)
  return
}

func.func @legacy_vcc_edges(%a: !waveamdmachine.reg<vgpr, 1>,
                            %b: !waveamdmachine.reg<vgpr, 1>,
                            %c: !waveamdmachine.reg<vgpr, 1>) {
  %sum, %vcc0 = waveamdmachine.v_add_u32_vcc %a, %b
      : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>)
        -> (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vcc, 1>)
  %mask, %vcc1 = waveamdmachine.v_cmp_lt_u32_vcc %sum, %c
      : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>)
        -> (!waveamdmachine.reg<sgpr, 1>, !waveamdmachine.reg<vcc, 1>)
  return
}

func.func @s_lshl_b64_scc_edges(%a: !waveamdmachine.reg<sgpr, 2>,
                                %shift: !waveamdmachine.reg<sgpr, 2>,
                                %x: !waveamdmachine.reg<sgpr, 1>,
                                %y: !waveamdmachine.reg<sgpr, 1>) {
  %shifted, %shift_scc = waveamdmachine.s_lshl_b64 %a, %shift
      : (!waveamdmachine.reg<sgpr, 2>, !waveamdmachine.reg<sgpr, 2>)
        -> (!waveamdmachine.reg<sgpr, 2>, !waveamdmachine.reg<scc, 1>)
  %scc = waveamdmachine.s_cmp_lt_i32 %x, %y
      : (!waveamdmachine.reg<sgpr, 1>, !waveamdmachine.reg<sgpr, 1>)
        -> !waveamdmachine.reg<scc, 1>
  return
}

func.func @m0_edges(%off: !waveamdmachine.reg<vgpr, 1>,
                    %base: !waveamdmachine.reg<sgpr, 2>,
                    %dst0: !waveamdmachine.reg<sgpr, 1>,
                    %dst1: !waveamdmachine.reg<sgpr, 1>,
                    %dep: !waveamdmachine.mem.token) {
  %m0a = waveamdmachine.s_mov_m0 %dst0
      : (!waveamdmachine.reg<sgpr, 1>) -> !waveamdmachine.m0
  %tok = waveamdmachine.global_load_lds_b32 %off, %base, %m0a after %dep
      : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<sgpr, 2>,
         !waveamdmachine.m0, !waveamdmachine.mem.token)
        -> !waveamdmachine.mem.token
  %m0b = waveamdmachine.s_mov_m0 %dst1
      : (!waveamdmachine.reg<sgpr, 1>) -> !waveamdmachine.m0
  return
}

func.func @token_loop_carry_edges(%off: !waveamdmachine.reg<vgpr, 1>,
                                  %base: !waveamdmachine.reg<sgpr, 2>,
                                  %dep: !waveamdmachine.mem.token,
                                  %scc: !waveamdmachine.reg<scc, 1>) {
  %result = waveamdmachine.uniform_loop carries(%dep : !waveamdmachine.mem.token) {
  ^bb0(%tok: !waveamdmachine.mem.token):
    %loaded, %tok1 = waveamdmachine.global_load_b32 %off, %base after %tok
        : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<sgpr, 2>,
           !waveamdmachine.mem.token)
          -> (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.mem.token)
    %next = waveamdmachine.token_join %tok1
        : (!waveamdmachine.mem.token) -> !waveamdmachine.mem.token
    waveamdmachine.continue_if %scc : !waveamdmachine.reg<scc, 1> carries(%next : !waveamdmachine.mem.token)
  } -> !waveamdmachine.mem.token
  waveamdmachine.wait %result : (!waveamdmachine.mem.token) -> ()
  return
}

func.func private @opaque()

func.func @hard_boundaries(%a: !waveamdmachine.reg<vgpr, 1>,
                           %b: !waveamdmachine.reg<vgpr, 1>) {
  %pre = waveamdmachine.v_add_u32 %a, %b : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>) -> !waveamdmachine.reg<vgpr, 1>
  func.call @opaque() : () -> ()
  %mid = waveamdmachine.v_add_u32 %pre, %b : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>) -> !waveamdmachine.reg<vgpr, 1>
  %cycles = waveamdmachine.s_getreg_shader_cycles : !waveamdmachine.reg<sgpr, 1>
  %post = waveamdmachine.v_add_u32 %mid, %b : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>) -> !waveamdmachine.reg<vgpr, 1>
  return
}

func.func @exec_if_regions(%cond: !waveamdmachine.reg<sgpr, 1>,
                           %a: !waveamdmachine.reg<vgpr, 1>,
                           %b: !waveamdmachine.reg<vgpr, 1>) {
  %pre = waveamdmachine.v_add_u32 %a, %b : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>) -> !waveamdmachine.reg<vgpr, 1>
  waveamdmachine.exec_if %cond {
    %then0 = waveamdmachine.v_add_u32 %pre, %b : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>) -> !waveamdmachine.reg<vgpr, 1>
    %then1 = waveamdmachine.v_add_u32 %then0, %b : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>) -> !waveamdmachine.reg<vgpr, 1>
    waveamdmachine.yield
  } otherwise {
    %else0 = waveamdmachine.v_add_u32 %pre, %b : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>) -> !waveamdmachine.reg<vgpr, 1>
    waveamdmachine.yield
  } : !waveamdmachine.reg<sgpr, 1>
  %post = waveamdmachine.v_add_u32 %pre, %b : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>) -> !waveamdmachine.reg<vgpr, 1>
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

// REGION: waveamd-machine-schedule-report region func=regions block=0 region=0 ops=4 first=waveamdmachine.imm last=waveamdmachine.v_add_u32
// REGION: waveamd-machine-schedule-report region func=regions block=0 region=1 ops=1 first=waveamdmachine.v_add_u32 last=waveamdmachine.v_add_u32
// REGION: waveamd-machine-schedule-report region func=regions block=1 region=2 ops=3 first=waveamdmachine.s_add_i32 last=waveamdmachine.s_cmp_lt_i32
// REGION: waveamd-machine-schedule-report region func=regions block=0 region=3 ops=1 first=waveamdmachine.v_add_u32 last=waveamdmachine.v_add_u32
// REGION: waveamd-machine-schedule-report region func=hard_boundaries block=0 region=0 ops=1 first=waveamdmachine.v_add_u32 last=waveamdmachine.v_add_u32
// REGION: waveamd-machine-schedule-report region func=hard_boundaries block=0 region=1 ops=1 first=waveamdmachine.v_add_u32 last=waveamdmachine.v_add_u32
// REGION: waveamd-machine-schedule-report region func=hard_boundaries block=0 region=2 ops=1 first=waveamdmachine.v_add_u32 last=waveamdmachine.v_add_u32
// REGION: waveamd-machine-schedule-report region func=exec_if_regions block=0 region=0 ops=1 first=waveamdmachine.v_add_u32 last=waveamdmachine.v_add_u32
// REGION: waveamd-machine-schedule-report region func=exec_if_regions block=1 region=1 ops=2 first=waveamdmachine.v_add_u32 last=waveamdmachine.v_add_u32
// REGION: waveamd-machine-schedule-report region func=exec_if_regions block=2 region=2 ops=1 first=waveamdmachine.v_add_u32 last=waveamdmachine.v_add_u32
// REGION: waveamd-machine-schedule-report region func=exec_if_regions block=0 region=3 ops=1 first=waveamdmachine.v_add_u32 last=waveamdmachine.v_add_u32

// DEPS: waveamd-machine-schedule-report deps func=regions region=0 nodes=4
// DEPS: waveamd-machine-schedule-report edge region=0 kind=ssa 2->3 src=waveamdmachine.v_add_u32 dst=waveamdmachine.v_add_u32
// DEPS: waveamd-machine-schedule-report deps func=regions region=2 nodes=3
// DEPS: waveamd-machine-schedule-report edge region=2 kind=ssa 1->2 src=waveamdmachine.s_add_i32 dst=waveamdmachine.s_cmp_lt_i32
// DEPS: waveamd-machine-schedule-report edge region=2 kind=loop_carry recurrence 1->0 src=waveamdmachine.s_add_i32 dst=waveamdmachine.s_add_i32
// DEPS: waveamd-machine-schedule-report edge region=2 kind=flag 0->1 src=waveamdmachine.s_add_i32 dst=waveamdmachine.s_add_i32
// DEPS: waveamd-machine-schedule-report edge region=2 kind=flag 1->2 src=waveamdmachine.s_add_i32 dst=waveamdmachine.s_cmp_lt_i32
// DEPS: waveamd-machine-schedule-report deps func=memory_edges region=0 nodes=5 edges=4
// DEPS: waveamd-machine-schedule-report edge region=0 kind=mem_token 0->1 src=waveamdmachine.token dst=waveamdmachine.global_load_b32
// DEPS: waveamd-machine-schedule-report edge region=0 kind=ssa 1->2 src=waveamdmachine.global_load_b32 dst=waveamdmachine.v_add_u32
// DEPS: waveamd-machine-schedule-report edge region=0 kind=mem_token 1->3 src=waveamdmachine.global_load_b32 dst=waveamdmachine.global_store_b32
// DEPS-NOT: kind=memory_order
// DEPS: waveamd-machine-schedule-report deps func=vcc_edges region=0 nodes=2 edges=1
// DEPS: waveamd-machine-schedule-report edge region=0 kind=flag 0->1 src=waveamdmachine.v_add_u64 dst=waveamdmachine.v_add_u64
// DEPS: waveamd-machine-schedule-report deps func=legacy_vcc_edges region=0 nodes=2 edges=2
// DEPS: waveamd-machine-schedule-report edge region=0 kind=ssa 0->1 src=waveamdmachine.v_add_u32_vcc dst=waveamdmachine.v_cmp_lt_u32_vcc
// DEPS: waveamd-machine-schedule-report edge region=0 kind=flag 0->1 src=waveamdmachine.v_add_u32_vcc dst=waveamdmachine.v_cmp_lt_u32_vcc
// DEPS: waveamd-machine-schedule-report deps func=s_lshl_b64_scc_edges region=0 nodes=2 edges=1
// DEPS: waveamd-machine-schedule-report edge region=0 kind=flag 0->1 src=waveamdmachine.s_lshl_b64 dst=waveamdmachine.s_cmp_lt_i32
// DEPS: waveamd-machine-schedule-report deps func=m0_edges region=0 nodes=3
// DEPS: waveamd-machine-schedule-report edge region=0 kind=ssa 0->1 src=waveamdmachine.s_mov_m0 dst=waveamdmachine.global_load_lds_b32
// DEPS: waveamd-machine-schedule-report edge region=0 kind=flag 1->2 src=waveamdmachine.global_load_lds_b32 dst=waveamdmachine.s_mov_m0
// DEPS: waveamd-machine-schedule-report deps func=token_loop_carry_edges region=0 nodes=2 edges=2
// DEPS: waveamd-machine-schedule-report edge region=0 kind=mem_token 0->1 src=waveamdmachine.global_load_b32 dst=waveamdmachine.token_join
// DEPS: waveamd-machine-schedule-report edge region=0 kind=loop_carry recurrence 1->0 src=waveamdmachine.token_join dst=waveamdmachine.global_load_b32

// SCORE: waveamd-machine-schedule-report score func=regions region=0 order=original cycles=
// SCORE-SAME: issued_ops=2
// SCORE: waveamd-machine-schedule-report score func=memory_edges region=0 order=original cycles=
// SCORE-SAME: issued_ops=4
