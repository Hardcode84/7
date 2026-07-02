// RUN: wave-opt --waveamd-buffer-rsrc-to-tuples --waveamd-hoist-tuples %s | FileCheck %s

module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx1100"} {

// CHECK-LABEL: func.func @hoist_loop_buffer_rsrc(
// CHECK-SAME:    %[[BASE0:[^:]+]]: !waveamdmachine.reg<sgpr, 2>
// CHECK-SAME:    %[[OFF0:[^:]+]]: !waveamdmachine.reg<sgpr, 1>
// CHECK: %[[INIT_BASE:.*]], %{{.*}} = waveamdmachine.s_add_u64_u32 %[[BASE0]], %[[OFF0]]
// CHECK: %[[INIT_RANGE:.*]] = waveamdmachine.s_mov_b32_tuple
// CHECK: %[[INIT_FLAGS_IMM:.*]] = waveamdmachine.imm 822173696
// CHECK: %[[INIT_FLAGS:.*]] = waveamdmachine.s_mov_b32_tuple %[[INIT_FLAGS_IMM]]
// CHECK: %[[INIT_DESC:.*]] = waveamdmachine.tuple_from_elements %[[INIT_BASE]], %[[INIT_RANGE]], %[[INIT_FLAGS]]
// CHECK: %[[LOOP:.*]]:3 = waveamdmachine.uniform_loop
// CHECK-SAME: carries(%[[OFF0]], {{%.*}}, %[[INIT_DESC]] :
// CHECK: ^bb0(%[[OFF:.*]]: !waveamdmachine.reg<sgpr, 1>, %[[DEP:.*]]: !waveamdmachine.mem.token, %[[DESC_IN:.*]]: !waveamdmachine.reg<sgpr, 4>):
// CHECK: %[[BASE:.*]], %{{.*}} = waveamdmachine.s_add_u64_u32 %[[BASE0]], %[[OFF]]
// CHECK: %[[DESC:.*]] = waveamdmachine.update_tuple %[[DESC_IN]], %[[BASE]] {offsets = [0]}
// CHECK-NEXT: waveamdmachine.buffer_load_lds_b128 {{.*}}, %[[DESC]]
// CHECK: waveamdmachine.continue_if {{.*}} : !waveamdmachine.reg<scc, 1>
// CHECK-SAME: carries({{%.*}}, {{%.*}}, %[[DESC]] :
func.func @hoist_loop_buffer_rsrc(
    %base0: !waveamdmachine.reg<sgpr, 2>,
    %off0: !waveamdmachine.reg<sgpr, 1>,
    %vaddr: !waveamdmachine.reg<vgpr, 1>,
    %m0: !waveamdmachine.m0) attributes {wave.kernel} {
  %tok0 = waveamdmachine.token : !waveamdmachine.mem.token
  %range = waveamdmachine.imm 2147483647 : !waveamdmachine.imm
  %zero = waveamdmachine.imm 0 : !waveamdmachine.imm
  %step = waveamdmachine.imm 16 : !waveamdmachine.imm
  %limit = waveamdmachine.imm 64 : !waveamdmachine.imm
  %loop:2 = waveamdmachine.uniform_loop
      carries(%off0, %tok0 :
              !waveamdmachine.reg<sgpr, 1>,
              !waveamdmachine.mem.token) {
  ^bb0(%off: !waveamdmachine.reg<sgpr, 1>,
       %dep: !waveamdmachine.mem.token):
    %base, %unused = waveamdmachine.s_add_u64_u32 %base0, %off
        : (!waveamdmachine.reg<sgpr, 2>, !waveamdmachine.reg<sgpr, 1>)
          -> (!waveamdmachine.reg<sgpr, 2>, !waveamdmachine.reg<scc, 1>)
    %desc = waveamdmachine.make_buffer_rsrc %base, %range
        : (!waveamdmachine.reg<sgpr, 2>, !waveamdmachine.imm)
          -> !waveamdmachine.reg<sgpr, 4>
    %tok1 = waveamdmachine.buffer_load_lds_b128
        %vaddr, %desc, %zero, %m0 after %dep
        : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<sgpr, 4>,
           !waveamdmachine.imm, !waveamdmachine.m0,
           !waveamdmachine.mem.token) -> !waveamdmachine.mem.token
    %next, %next_scc = waveamdmachine.s_add_i32 %off, %step
        : (!waveamdmachine.reg<sgpr, 1>, !waveamdmachine.imm)
          -> (!waveamdmachine.reg<sgpr, 1>, !waveamdmachine.reg<scc, 1>)
    %cond = waveamdmachine.s_cmp_lt_i32 %next, %limit
        : (!waveamdmachine.reg<sgpr, 1>, !waveamdmachine.imm)
          -> !waveamdmachine.reg<scc, 1>
    waveamdmachine.continue_if %cond : !waveamdmachine.reg<scc, 1>
        carries(%next, %tok1 :
                !waveamdmachine.reg<sgpr, 1>,
                !waveamdmachine.mem.token)
  } -> !waveamdmachine.reg<sgpr, 1>, !waveamdmachine.mem.token
  return
}

// CHECK-LABEL: func.func @hoist_loop_tuple_from_elements(
// CHECK-SAME:    %[[BASE0:[^:]+]]: !waveamdmachine.reg<sgpr, 2>
// CHECK-SAME:    %[[TAIL0:[^:]+]]: !waveamdmachine.reg<sgpr, 1>
// CHECK-SAME:    %[[TAIL1:[^:]+]]: !waveamdmachine.reg<sgpr, 1>
// CHECK-SAME:    %[[OFF0:[^:]+]]: !waveamdmachine.reg<sgpr, 1>
// CHECK: %[[INIT_BASE:.*]], %{{.*}} = waveamdmachine.s_add_u64_u32 %[[BASE0]], %[[OFF0]]
// CHECK: %[[INIT_TUPLE:.*]] = waveamdmachine.tuple_from_elements %[[INIT_BASE]], %[[TAIL0]], %[[TAIL1]]
// CHECK: %[[LOOP:.*]]:3 = waveamdmachine.uniform_loop
// CHECK-SAME: carries(%[[OFF0]], {{%.*}}, %[[INIT_TUPLE]] :
// CHECK: ^bb0(%[[OFF:.*]]: !waveamdmachine.reg<sgpr, 1>, %[[DEP:.*]]: !waveamdmachine.mem.token, %[[TUPLE_IN:.*]]: !waveamdmachine.reg<sgpr, 4>):
// CHECK: %[[BASE:.*]], %{{.*}} = waveamdmachine.s_add_u64_u32 %[[BASE0]], %[[OFF]]
// CHECK-NEXT: %[[TUPLE:.*]] = waveamdmachine.update_tuple %[[TUPLE_IN]], %[[BASE]] {offsets = [0]}
// CHECK-NEXT: waveamdmachine.buffer_load_lds_b128 {{.*}}, %[[TUPLE]]
// CHECK: waveamdmachine.continue_if {{.*}} : !waveamdmachine.reg<scc, 1>
// CHECK-SAME: carries({{%.*}}, {{%.*}}, %[[TUPLE]] :
func.func @hoist_loop_tuple_from_elements(
    %base0: !waveamdmachine.reg<sgpr, 2>,
    %tail0: !waveamdmachine.reg<sgpr, 1>,
    %tail1: !waveamdmachine.reg<sgpr, 1>,
    %off0: !waveamdmachine.reg<sgpr, 1>,
    %vaddr: !waveamdmachine.reg<vgpr, 1>,
    %m0: !waveamdmachine.m0) attributes {wave.kernel} {
  %tok0 = waveamdmachine.token : !waveamdmachine.mem.token
  %zero = waveamdmachine.imm 0 : !waveamdmachine.imm
  %step = waveamdmachine.imm 16 : !waveamdmachine.imm
  %limit = waveamdmachine.imm 64 : !waveamdmachine.imm
  %loop:2 = waveamdmachine.uniform_loop
      carries(%off0, %tok0 :
              !waveamdmachine.reg<sgpr, 1>,
              !waveamdmachine.mem.token) {
  ^bb0(%off: !waveamdmachine.reg<sgpr, 1>,
       %dep: !waveamdmachine.mem.token):
    %base, %unused = waveamdmachine.s_add_u64_u32 %base0, %off
        : (!waveamdmachine.reg<sgpr, 2>, !waveamdmachine.reg<sgpr, 1>)
          -> (!waveamdmachine.reg<sgpr, 2>, !waveamdmachine.reg<scc, 1>)
    %desc = waveamdmachine.tuple_from_elements %base, %tail0, %tail1
        : (!waveamdmachine.reg<sgpr, 2>, !waveamdmachine.reg<sgpr, 1>,
           !waveamdmachine.reg<sgpr, 1>) -> !waveamdmachine.reg<sgpr, 4>
    %tok1 = waveamdmachine.buffer_load_lds_b128
        %vaddr, %desc, %zero, %m0 after %dep
        : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<sgpr, 4>,
           !waveamdmachine.imm, !waveamdmachine.m0,
           !waveamdmachine.mem.token) -> !waveamdmachine.mem.token
    %next, %next_scc = waveamdmachine.s_add_i32 %off, %step
        : (!waveamdmachine.reg<sgpr, 1>, !waveamdmachine.imm)
          -> (!waveamdmachine.reg<sgpr, 1>, !waveamdmachine.reg<scc, 1>)
    %cond = waveamdmachine.s_cmp_lt_i32 %next, %limit
        : (!waveamdmachine.reg<sgpr, 1>, !waveamdmachine.imm)
          -> !waveamdmachine.reg<scc, 1>
    waveamdmachine.continue_if %cond : !waveamdmachine.reg<scc, 1>
        carries(%next, %tok1 :
                !waveamdmachine.reg<sgpr, 1>,
                !waveamdmachine.mem.token)
  } -> !waveamdmachine.reg<sgpr, 1>, !waveamdmachine.mem.token
  return
}

// CHECK-LABEL: func.func @skip_loop_variant_range(
// CHECK: waveamdmachine.uniform_loop
// CHECK: waveamdmachine.tuple_from_elements
// CHECK-NOT: waveamdmachine.update_tuple
// CHECK: return
func.func @skip_loop_variant_range(
    %base: !waveamdmachine.reg<sgpr, 2>,
    %range0: !waveamdmachine.reg<sgpr, 1>,
    %vaddr: !waveamdmachine.reg<vgpr, 1>,
    %m0: !waveamdmachine.m0) attributes {wave.kernel} {
  %tok0 = waveamdmachine.token : !waveamdmachine.mem.token
  %zero = waveamdmachine.imm 0 : !waveamdmachine.imm
  %step = waveamdmachine.imm 16 : !waveamdmachine.imm
  %limit = waveamdmachine.imm 128 : !waveamdmachine.imm
  %loop:2 = waveamdmachine.uniform_loop
      carries(%range0, %tok0 :
              !waveamdmachine.reg<sgpr, 1>,
              !waveamdmachine.mem.token) {
  ^bb0(%range: !waveamdmachine.reg<sgpr, 1>,
       %dep: !waveamdmachine.mem.token):
    %desc = waveamdmachine.make_buffer_rsrc %base, %range
        : (!waveamdmachine.reg<sgpr, 2>, !waveamdmachine.reg<sgpr, 1>)
          -> !waveamdmachine.reg<sgpr, 4>
    %tok1 = waveamdmachine.buffer_load_lds_b128
        %vaddr, %desc, %zero, %m0 after %dep
        : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<sgpr, 4>,
           !waveamdmachine.imm, !waveamdmachine.m0,
           !waveamdmachine.mem.token) -> !waveamdmachine.mem.token
    %next, %next_scc = waveamdmachine.s_add_i32 %range, %step
        : (!waveamdmachine.reg<sgpr, 1>, !waveamdmachine.imm)
          -> (!waveamdmachine.reg<sgpr, 1>, !waveamdmachine.reg<scc, 1>)
    %cond = waveamdmachine.s_cmp_lt_i32 %next, %limit
        : (!waveamdmachine.reg<sgpr, 1>, !waveamdmachine.imm)
          -> !waveamdmachine.reg<scc, 1>
    waveamdmachine.continue_if %cond : !waveamdmachine.reg<scc, 1>
        carries(%next, %tok1 :
                !waveamdmachine.reg<sgpr, 1>,
                !waveamdmachine.mem.token)
  } -> !waveamdmachine.reg<sgpr, 1>, !waveamdmachine.mem.token
  return
}

// CHECK-LABEL: func.func @skip_tuple_all_variant(
// CHECK: waveamdmachine.uniform_loop
// CHECK: waveamdmachine.tuple_from_elements
// CHECK-NOT: waveamdmachine.update_tuple
// CHECK: return
func.func @skip_tuple_all_variant(
    %lo0: !waveamdmachine.reg<sgpr, 1>,
    %hi0: !waveamdmachine.reg<sgpr, 1>,
    %cond: !waveamdmachine.reg<scc, 1>) attributes {wave.kernel} {
  %loop:2 = waveamdmachine.uniform_loop
      carries(%lo0, %hi0 :
              !waveamdmachine.reg<sgpr, 1>,
              !waveamdmachine.reg<sgpr, 1>) {
  ^bb0(%lo: !waveamdmachine.reg<sgpr, 1>,
       %hi: !waveamdmachine.reg<sgpr, 1>):
    %tuple = waveamdmachine.tuple_from_elements %lo, %hi
        : (!waveamdmachine.reg<sgpr, 1>, !waveamdmachine.reg<sgpr, 1>)
          -> !waveamdmachine.reg<sgpr, 2>
    waveamdmachine.continue_if %cond : !waveamdmachine.reg<scc, 1>
        carries(%lo, %hi :
                !waveamdmachine.reg<sgpr, 1>,
                !waveamdmachine.reg<sgpr, 1>)
  } -> !waveamdmachine.reg<sgpr, 1>, !waveamdmachine.reg<sgpr, 1>
  return
}

// CHECK-LABEL: func.func @skip_tuple_body_arg_update(
// CHECK: waveamdmachine.uniform_loop
// CHECK: waveamdmachine.tuple_from_elements
// CHECK-NOT: waveamdmachine.update_tuple
// CHECK: return
func.func @skip_tuple_body_arg_update(
    %lo0: !waveamdmachine.reg<sgpr, 1>,
    %tail: !waveamdmachine.reg<sgpr, 1>,
    %cond: !waveamdmachine.reg<scc, 1>) attributes {wave.kernel} {
  %loop = waveamdmachine.uniform_loop
      carries(%lo0 : !waveamdmachine.reg<sgpr, 1>) {
  ^bb0(%lo: !waveamdmachine.reg<sgpr, 1>):
    %tuple = waveamdmachine.tuple_from_elements %lo, %tail
        : (!waveamdmachine.reg<sgpr, 1>, !waveamdmachine.reg<sgpr, 1>)
          -> !waveamdmachine.reg<sgpr, 2>
    waveamdmachine.continue_if %cond : !waveamdmachine.reg<scc, 1>
        carries(%lo : !waveamdmachine.reg<sgpr, 1>)
  } -> !waveamdmachine.reg<sgpr, 1>
  return
}

// CHECK-LABEL: func.func @hoist_vgpr_tuple_from_elements(
// CHECK: %[[INIT_LO:.*]] = waveamdmachine.v_add_u32
// CHECK: %[[INIT_TUPLE:.*]] = waveamdmachine.tuple_from_elements %[[INIT_LO]]
// CHECK: %[[LOOP:.*]]:2 = waveamdmachine.uniform_loop
// CHECK-SAME: carries({{%.*}}, %[[INIT_TUPLE]] :
// CHECK: ^bb0(%[[OFF:.*]]: !waveamdmachine.reg<sgpr, 1>, %[[TUPLE_IN:.*]]: !waveamdmachine.reg<vgpr, 2>):
// CHECK: %[[LO:.*]] = waveamdmachine.v_add_u32
// CHECK-NEXT: %[[TUPLE:.*]] = waveamdmachine.update_tuple %[[TUPLE_IN]], %[[LO]] {offsets = [0]}
// CHECK: waveamdmachine.continue_if
// CHECK-SAME: carries({{%.*}}, %[[TUPLE]] :
func.func @hoist_vgpr_tuple_from_elements(
    %vbase: !waveamdmachine.reg<vgpr, 1>,
    %tail: !waveamdmachine.reg<vgpr, 1>,
    %off0: !waveamdmachine.reg<sgpr, 1>,
    %cond: !waveamdmachine.reg<scc, 1>) attributes {wave.kernel} {
  %one = waveamdmachine.imm 1 : !waveamdmachine.imm
  %loop = waveamdmachine.uniform_loop
      carries(%off0 : !waveamdmachine.reg<sgpr, 1>) {
  ^bb0(%off: !waveamdmachine.reg<sgpr, 1>):
    %lo = waveamdmachine.v_add_u32 %vbase, %off
        : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<sgpr, 1>)
          -> !waveamdmachine.reg<vgpr, 1>
    %tuple = waveamdmachine.tuple_from_elements %lo, %tail
        : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>)
          -> !waveamdmachine.reg<vgpr, 2>
    %next, %next_scc = waveamdmachine.s_add_i32 %off, %one
        : (!waveamdmachine.reg<sgpr, 1>, !waveamdmachine.imm)
          -> (!waveamdmachine.reg<sgpr, 1>, !waveamdmachine.reg<scc, 1>)
    waveamdmachine.continue_if %cond : !waveamdmachine.reg<scc, 1>
        carries(%next : !waveamdmachine.reg<sgpr, 1>)
  } -> !waveamdmachine.reg<sgpr, 1>
  return
}

}
