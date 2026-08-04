// RUN: wave-opt %s --waveamd-machine-schedule | FileCheck %s --check-prefix=NOOP
// RUN: wave-opt %s --waveamd-machine-schedule-report='print-regions=1' 2>&1 | FileCheck %s --check-prefix=REGION
// RUN: wave-opt %s --waveamd-machine-schedule-report='print-deps=1' 2>&1 | FileCheck %s --check-prefix=DEPS
// RUN: wave-opt %s --waveamd-machine-schedule-report='print-score=1' 2>&1 | FileCheck %s --check-prefix=SCORE
// RUN: wave-opt %s --pass-pipeline='builtin.module(transform-interpreter)' | FileCheck %s --check-prefix=APPLY

module attributes {transform.with_named_sequence,
                   waveamdmachine.target = "amdgcn-amd-amdhsa--gfx1100"} {
// NOOP-LABEL: func.func @regions
// NOOP: waveamdmachine.uniform_loop
// NOOP: waveamdmachine.s_barrier
// NOOP: return
// APPLY-LABEL: func.func @regions
// APPLY: waveamdmachine.uniform_loop
func.func @regions(%a: !waveamdmachine.reg<vgpr, 1>,
                   %b: !waveamdmachine.reg<vgpr, 1>,
                   %iv0: !waveamdmachine.reg<sgpr, 1>) {
  %one = waveamdmachine.imm 1 : !waveamdmachine.imm
  %v0 = waveamdmachine.v_add_u32 %a, %b : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>) -> !waveamdmachine.reg<vgpr, 1>
  %v1 = waveamdmachine.v_add_u32 %v0, %b : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>) -> !waveamdmachine.reg<vgpr, 1>
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

func.func @sched_barrier_regions(%a: !waveamdmachine.reg<vgpr, 1>,
                                 %b: !waveamdmachine.reg<vgpr, 1>) {
  %before = waveamdmachine.v_add_u32 %a, %b
      : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>)
        -> !waveamdmachine.reg<vgpr, 1>
  waveamdmachine.sched_barrier
  %after = waveamdmachine.v_add_u32 %a, %b
      : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>)
        -> !waveamdmachine.reg<vgpr, 1>
  return
}

func.func @set_priority_regions(%a: !waveamdmachine.reg<vgpr, 1>,
                                %b: !waveamdmachine.reg<vgpr, 1>) {
  %before = waveamdmachine.v_add_u32 %a, %b
      : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>)
        -> !waveamdmachine.reg<vgpr, 1>
  %two = waveamdmachine.imm 2 : !waveamdmachine.imm
  waveamdmachine.s_setprio %two : (!waveamdmachine.imm) -> ()
  %after = waveamdmachine.v_add_u32 %a, %b
      : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>)
        -> !waveamdmachine.reg<vgpr, 1>
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
  %vcc1 = waveamdmachine.v_cmp_lt_u32_vcc %sum, %c
      : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>)
        -> !waveamdmachine.reg<vcc, 1>
  return
}

func.func @s_lshl_b64_scc_edges(%a: !waveamdmachine.reg<sgpr, 2>,
                                %shift: !waveamdmachine.reg<sgpr, 1>,
                                %x: !waveamdmachine.reg<sgpr, 1>,
                                %y: !waveamdmachine.reg<sgpr, 1>) {
  %shifted, %shift_scc = waveamdmachine.s_lshl_b64 %a, %shift
      : (!waveamdmachine.reg<sgpr, 2>, !waveamdmachine.reg<sgpr, 1>)
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
  waveamdmachine.s_barrier %result : (!waveamdmachine.mem.token) -> ()
  return
}

func.func @tuple_address_loop_carry_edges(
    %init: !waveamdmachine.reg<vgpr, 2>,
    %x: !waveamdmachine.reg<vgpr, 1>,
    %scc: !waveamdmachine.reg<scc, 1>) {
  %result = waveamdmachine.uniform_loop
      carries(%init : !waveamdmachine.reg<vgpr, 2>) {
  ^bb0(%address: !waveamdmachine.reg<vgpr, 2>):
    %parts:2 = waveamdmachine.tuple_to_elements %address
        : (!waveamdmachine.reg<vgpr, 2>)
          -> (!waveamdmachine.reg<vgpr, 1>,
              !waveamdmachine.reg<vgpr, 1>)
    %loaded, %token = waveamdmachine.ds_load_b32 %parts#0
        : (!waveamdmachine.reg<vgpr, 1>)
          -> (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.mem.token)
    %next0 = waveamdmachine.v_add_u32 %parts#0, %x
        : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>)
          -> !waveamdmachine.reg<vgpr, 1>
    %next = waveamdmachine.tuple_from_elements %next0, %parts#1
        : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>)
          -> !waveamdmachine.reg<vgpr, 2>
    waveamdmachine.continue_if %scc : !waveamdmachine.reg<scc, 1>
        carries(%next : !waveamdmachine.reg<vgpr, 2>)
  } -> !waveamdmachine.reg<vgpr, 2>
  return
}

func.func @parallel_loop_carry_edges(
    %init0: !waveamdmachine.reg<vgpr, 1>,
    %init1: !waveamdmachine.reg<vgpr, 1>,
    %scc: !waveamdmachine.reg<scc, 1>) {
  %result:2 = waveamdmachine.uniform_loop
      carries(%init0, %init1 : !waveamdmachine.reg<vgpr, 1>,
              !waveamdmachine.reg<vgpr, 1>) {
  ^bb0(%carry0: !waveamdmachine.reg<vgpr, 1>,
       %carry1: !waveamdmachine.reg<vgpr, 1>):
    %next0 = waveamdmachine.v_add_u32 %carry0, %carry1
        : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>)
          -> !waveamdmachine.reg<vgpr, 1>
    %next1 = waveamdmachine.v_xor_b32 %carry1, %carry0
        : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>)
          -> !waveamdmachine.reg<vgpr, 1>
    waveamdmachine.continue_if %scc : !waveamdmachine.reg<scc, 1>
        carries(%next0, %next1 : !waveamdmachine.reg<vgpr, 1>,
                !waveamdmachine.reg<vgpr, 1>)
  } -> !waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>
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

// REGION: waveamd-machine-schedule-report region func=regions block=0 region=0 ops=4 instruction_ops=3 first=waveamdmachine.imm last=waveamdmachine.v_add_u32
// REGION: waveamd-machine-schedule-report region func=regions block=1 region=1 ops=3 instruction_ops=3 first=waveamdmachine.s_add_i32 last=waveamdmachine.s_cmp_lt_i32
// REGION: waveamd-machine-schedule-report region func=regions block=0 region=2 ops=2 instruction_ops=2 first=waveamdmachine.s_barrier last=waveamdmachine.v_add_u32
// REGION: waveamd-machine-schedule-report region func=sched_barrier_regions block=0 region=0 ops=1 instruction_ops=1 first=waveamdmachine.v_add_u32 last=waveamdmachine.v_add_u32
// REGION: waveamd-machine-schedule-report region func=sched_barrier_regions block=0 region=1 ops=1 instruction_ops=1 first=waveamdmachine.v_add_u32 last=waveamdmachine.v_add_u32
// REGION: waveamd-machine-schedule-report region func=set_priority_regions block=0 region=0 ops=2 instruction_ops=1 first=waveamdmachine.v_add_u32 last=waveamdmachine.imm
// REGION: waveamd-machine-schedule-report region func=set_priority_regions block=0 region=1 ops=1 instruction_ops=1 first=waveamdmachine.s_setprio last=waveamdmachine.s_setprio
// REGION: waveamd-machine-schedule-report region func=set_priority_regions block=0 region=2 ops=1 instruction_ops=1 first=waveamdmachine.v_add_u32 last=waveamdmachine.v_add_u32
// REGION: waveamd-machine-schedule-report region func=exec_if_regions block=0 region=0 ops=1 instruction_ops=1 first=waveamdmachine.v_add_u32 last=waveamdmachine.v_add_u32
// REGION: waveamd-machine-schedule-report region func=exec_if_regions block=1 region=1 ops=2 instruction_ops=2 first=waveamdmachine.v_add_u32 last=waveamdmachine.v_add_u32
// REGION: waveamd-machine-schedule-report region func=exec_if_regions block=2 region=2 ops=1 instruction_ops=1 first=waveamdmachine.v_add_u32 last=waveamdmachine.v_add_u32
// REGION: waveamd-machine-schedule-report region func=exec_if_regions block=0 region=3 ops=1 instruction_ops=1 first=waveamdmachine.v_add_u32 last=waveamdmachine.v_add_u32

// DEPS: waveamd-machine-schedule-report deps func=regions region=0 nodes=4
// DEPS: waveamd-machine-schedule-report edge region=0 kind=ssa 1->2 src=waveamdmachine.v_add_u32 dst=waveamdmachine.v_add_u32
// DEPS: waveamd-machine-schedule-report edge region=0 kind=ssa 2->3 src=waveamdmachine.v_add_u32 dst=waveamdmachine.v_add_u32
// DEPS: waveamd-machine-schedule-report deps func=regions region=1 nodes=3
// DEPS: waveamd-machine-schedule-report edge region=1 kind=loop_carry 0->1 src=waveamdmachine.s_add_i32 dst=waveamdmachine.s_add_i32
// DEPS: waveamd-machine-schedule-report edge region=1 kind=singleton 0->2 src=waveamdmachine.s_add_i32 dst=waveamdmachine.s_cmp_lt_i32
// DEPS: waveamd-machine-schedule-report edge region=1 kind=loop_carry recurrence 1->0 src=waveamdmachine.s_add_i32 dst=waveamdmachine.s_add_i32
// DEPS: waveamd-machine-schedule-report edge region=1 kind=loop_carry recurrence 1->1 src=waveamdmachine.s_add_i32 dst=waveamdmachine.s_add_i32
// DEPS: waveamd-machine-schedule-report edge region=1 kind=ssa 1->2 src=waveamdmachine.s_add_i32 dst=waveamdmachine.s_cmp_lt_i32
// DEPS: waveamd-machine-schedule-report edge region=1 kind=singleton 1->2 src=waveamdmachine.s_add_i32 dst=waveamdmachine.s_cmp_lt_i32
// DEPS: waveamd-machine-schedule-report deps func=memory_edges region=0 nodes=5 edges=4
// DEPS: waveamd-machine-schedule-report edge region=0 kind=mem_token 0->1 src=waveamdmachine.token dst=waveamdmachine.global_load_b32
// DEPS: waveamd-machine-schedule-report edge region=0 kind=ssa 1->2 src=waveamdmachine.global_load_b32 dst=waveamdmachine.v_add_u32
// DEPS: waveamd-machine-schedule-report edge region=0 kind=mem_token 1->3 src=waveamdmachine.global_load_b32 dst=waveamdmachine.global_store_b32
// DEPS: waveamd-machine-schedule-report edge region=0 kind=ssa 2->3 src=waveamdmachine.v_add_u32 dst=waveamdmachine.global_store_b32
// DEPS-NOT: kind=memory_order
// DEPS: waveamd-machine-schedule-report deps func=vcc_edges region=0 nodes=2 edges=1
// DEPS: waveamd-machine-schedule-report edge region=0 kind=singleton 0->1 src=waveamdmachine.v_add_u64 dst=waveamdmachine.v_add_u64
// DEPS: waveamd-machine-schedule-report deps func=legacy_vcc_edges region=0 nodes=2 edges=2
// DEPS: waveamd-machine-schedule-report edge region=0 kind=ssa 0->1 src=waveamdmachine.v_add_u32_vcc dst=waveamdmachine.v_cmp_lt_u32_vcc
// DEPS: waveamd-machine-schedule-report edge region=0 kind=singleton 0->1 src=waveamdmachine.v_add_u32_vcc dst=waveamdmachine.v_cmp_lt_u32_vcc
// DEPS: waveamd-machine-schedule-report deps func=s_lshl_b64_scc_edges region=0 nodes=2 edges=1
// DEPS: waveamd-machine-schedule-report edge region=0 kind=singleton 0->1 src=waveamdmachine.s_lshl_b64 dst=waveamdmachine.s_cmp_lt_i32
// DEPS: waveamd-machine-schedule-report deps func=m0_edges region=0 nodes=3
// DEPS: waveamd-machine-schedule-report edge region=0 kind=ssa 0->1 src=waveamdmachine.s_mov_m0 dst=waveamdmachine.global_load_lds_b32
// DEPS: waveamd-machine-schedule-report edge region=0 kind=singleton 0->2 src=waveamdmachine.s_mov_m0 dst=waveamdmachine.s_mov_m0
// DEPS: waveamd-machine-schedule-report edge region=0 kind=singleton 1->2 src=waveamdmachine.global_load_lds_b32 dst=waveamdmachine.s_mov_m0
// DEPS: waveamd-machine-schedule-report deps func=token_loop_carry_edges region=0 nodes=2 edges=2
// DEPS: waveamd-machine-schedule-report edge region=0 kind=mem_token 0->1 src=waveamdmachine.global_load_b32 dst=waveamdmachine.token_join
// DEPS: waveamd-machine-schedule-report edge region=0 kind=loop_carry recurrence 1->0 src=waveamdmachine.token_join dst=waveamdmachine.global_load_b32
// DEPS: waveamd-machine-schedule-report deps func=tuple_address_loop_carry_edges region=0 nodes=4
// DEPS: waveamd-machine-schedule-report edge region=0 kind=loop_carry 1->3 src=waveamdmachine.ds_load_b32 dst=waveamdmachine.tuple_from_elements
// DEPS: waveamd-machine-schedule-report edge region=0 kind=loop_carry recurrence 3->0 src=waveamdmachine.tuple_from_elements dst=waveamdmachine.tuple_to_elements
// DEPS: waveamd-machine-schedule-report deps func=parallel_loop_carry_edges region=0 nodes=2
// DEPS: waveamd-machine-schedule-report edge region=0 kind=loop_carry 1->0 src=waveamdmachine.v_xor_b32 dst=waveamdmachine.v_add_u32
// DEPS-NOT: kind=loop_carry 0->1

// SCORE: waveamd-machine-schedule-report score func=regions region=0 order=original cycles=
// SCORE-SAME: issued_ops=3
// SCORE: waveamd-machine-schedule-report score func=set_priority_regions region=1 order=original cycles=1 issued_ops=1
// SCORE: waveamd-machine-schedule-report score func=memory_edges region=0 order=original cycles=
// SCORE-SAME: issued_ops=4
