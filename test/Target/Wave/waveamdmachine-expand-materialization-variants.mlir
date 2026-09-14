// RUN: wave-opt %s --waveamd-expand-materialization-variants='max-candidates=3' | FileCheck %s --check-prefix=CAP --implicit-check-not=waveamdmachine.materialization_variants
// RUN: wave-opt %s --waveamd-expand-materialization-variants='max-candidates=1' | FileCheck %s --check-prefix=ONE --implicit-check-not=waveamdmachine.materialization_variants
// RUN: wave-opt %s --waveamd-expand-materialization-variants | FileCheck %s --implicit-check-not=waveamdmachine.materialization_variants
// RUN: wave-opt %s --waveamd-expand-materialization-variants -o %t.parallel
// RUN: wave-opt %s --mlir-disable-threading --waveamd-expand-materialization-variants -o %t.serial
// RUN: diff %t.parallel %t.serial
// RUN: wave-opt %t.parallel --waveamd-expand-materialization-variants -o %t.twice
// RUN: diff %t.parallel %t.twice

// CAP-LABEL: func.func @product
// CAP: waveamdmachine.materialization_candidates
// CAP: [[A0:%.*]] = waveamdmachine.s_mov_b32_value {{.*}} {test.variant = "a"}
// CAP-NEXT: waveamdmachine.candidate_yield [[A0]], [[A0]]
// CAP: [[B1:%.*]] = waveamdmachine.s_mov_b32_value {{.*}} {test.variant = "b"}
// CAP-NEXT: waveamdmachine.candidate_yield [[B1]], [[B1]]
// CAP: [[A2:%.*]] = waveamdmachine.s_mov_b32_value {{.*}} {test.variant = "a"}
// CAP-NEXT: [[B2:%.*]] = waveamdmachine.s_mov_b32_value {{.*}} {test.variant = "b"}
// CAP-NEXT: waveamdmachine.candidate_yield [[B2]], [[A2]]
// CAP-NOT: waveamdmachine.candidate_yield
// CAP: return
// ONE-LABEL: func.func @product
// ONE: waveamdmachine.materialization_candidates
// ONE: [[A:%.*]] = waveamdmachine.s_mov_b32_value {{.*}} {test.variant = "a"}
// ONE-NEXT: waveamdmachine.candidate_yield [[A]], [[A]]
// ONE-NOT: waveamdmachine.candidate_yield
// ONE: return

// CHECK-LABEL: func.func @product(
// CHECK-SAME: [[X:%[^:]+]]:
// CHECK: [[R:%.*]]:2 = waveamdmachine.materialization_candidates [[X]] : !waveamdmachine.reg<sgpr, 1>
// CHECK: ^bb0([[X0:%[^:]+]]: !waveamdmachine.reg<sgpr, 1>):
// CHECK: [[A0:%.*]] = waveamdmachine.s_mov_b32_value [[X0]] {test.variant = "a"}
// CHECK-NEXT: waveamdmachine.candidate_yield [[A0]], [[A0]]
// CHECK: ^bb0([[X1:%[^:]+]]: !waveamdmachine.reg<sgpr, 1>):
// CHECK: [[A1:%.*]] = waveamdmachine.s_mov_b32_value [[X1]] {test.variant = "a"}
// CHECK-NEXT: [[B1:%.*]] = waveamdmachine.s_mov_b32_value [[X1]] {test.variant = "b"}
// CHECK-NEXT: waveamdmachine.candidate_yield [[A1]], [[B1]]
// CHECK: ^bb0([[X2:%[^:]+]]: !waveamdmachine.reg<sgpr, 1>):
// CHECK: [[A2:%.*]] = waveamdmachine.s_mov_b32_value [[X2]] {test.variant = "a"}
// CHECK-NEXT: [[B2:%.*]] = waveamdmachine.s_mov_b32_value [[X2]] {test.variant = "b"}
// CHECK-NEXT: waveamdmachine.candidate_yield [[B2]], [[A2]]
// CHECK: ^bb0([[X3:%[^:]+]]: !waveamdmachine.reg<sgpr, 1>):
// CHECK: [[B3:%.*]] = waveamdmachine.s_mov_b32_value [[X3]] {test.variant = "b"}
// CHECK-NEXT: waveamdmachine.candidate_yield [[B3]], [[B3]]
// CHECK: return [[R]]#0, [[R]]#1
func.func @product(%x: !waveamdmachine.reg<sgpr, 1>) -> (!waveamdmachine.reg<sgpr, 1>, !waveamdmachine.reg<sgpr, 1>) {
  %a = waveamdmachine.s_mov_b32_value %x {test.variant = "a"} : (!waveamdmachine.reg<sgpr, 1>) -> !waveamdmachine.reg<sgpr, 1>
  %b = waveamdmachine.s_mov_b32_value %x {test.variant = "b"} : (!waveamdmachine.reg<sgpr, 1>) -> !waveamdmachine.reg<sgpr, 1>
  %first = waveamdmachine.materialization_variants %a, %b : !waveamdmachine.reg<sgpr, 1>
  %second = waveamdmachine.materialization_variants %a, %b : !waveamdmachine.reg<sgpr, 1>
  return %first, %second : !waveamdmachine.reg<sgpr, 1>, !waveamdmachine.reg<sgpr, 1>
}

// CHECK-LABEL: func.func @effects
// CHECK: waveamdmachine.materialization_candidates
// CHECK: waveamdmachine.s_barrier
// CHECK: waveamdmachine.candidate_yield
// CHECK: waveamdmachine.s_barrier
// CHECK: waveamdmachine.candidate_yield
// CHECK: waveamdmachine.s_endpgm
// CHECK-NEXT: return
func.func @effects() {
  %a = waveamdmachine.token : !waveamdmachine.mem.token
  %b = waveamdmachine.token : !waveamdmachine.mem.token
  %r = waveamdmachine.materialization_variants %a, %b : !waveamdmachine.mem.token
  waveamdmachine.s_barrier %r : (!waveamdmachine.mem.token) -> ()
  waveamdmachine.s_endpgm
  return
}

// CHECK-LABEL: func.func @cross_block(
// CHECK: [[FIRST:%.*]] = waveamdmachine.materialization_candidates
// CHECK: cf.br
// CHECK: waveamdmachine.materialization_candidates [[FIRST]]
func.func @cross_block(%x: !waveamdmachine.reg<sgpr, 1>) -> !waveamdmachine.reg<sgpr, 1> {
  %r = waveamdmachine.materialization_variants %x, %x : !waveamdmachine.reg<sgpr, 1>
  cf.br ^next
^next:
  %s = waveamdmachine.materialization_variants %r, %r : !waveamdmachine.reg<sgpr, 1>
  return %s : !waveamdmachine.reg<sgpr, 1>
}

// CHECK-LABEL: func.func @no_choices
// CHECK-NEXT: return
func.func @no_choices() {
  return
}

// CHECK-LABEL: func.func @nested_capture
// CHECK: waveamdmachine.materialization_candidates
// CHECK: waveamdmachine.uniform_if
// CHECK: waveamdmachine.candidate_yield
// CHECK: waveamdmachine.uniform_if
// CHECK: waveamdmachine.candidate_yield
// CHECK: waveamdmachine.uniform_if
// CHECK: waveamdmachine.candidate_yield
// CHECK: waveamdmachine.uniform_if
// CHECK: waveamdmachine.candidate_yield
// CHECK: return
func.func @nested_capture(%x: !waveamdmachine.reg<sgpr, 1>, %condition: !waveamdmachine.reg<scc, 1>) -> !waveamdmachine.reg<sgpr, 1> {
  %a = waveamdmachine.s_mov_b32_value %x {test.variant = "a"} : (!waveamdmachine.reg<sgpr, 1>) -> !waveamdmachine.reg<sgpr, 1>
  %b = waveamdmachine.s_mov_b32_value %x {test.variant = "b"} : (!waveamdmachine.reg<sgpr, 1>) -> !waveamdmachine.reg<sgpr, 1>
  %outer = waveamdmachine.materialization_variants %a, %b : !waveamdmachine.reg<sgpr, 1>
  %r = waveamdmachine.uniform_if %condition {
    %inner = waveamdmachine.materialization_variants %outer, %a : !waveamdmachine.reg<sgpr, 1>
    waveamdmachine.yield %inner : !waveamdmachine.reg<sgpr, 1>
  } otherwise {
    waveamdmachine.yield %outer : !waveamdmachine.reg<sgpr, 1>
  } : !waveamdmachine.reg<scc, 1> -> !waveamdmachine.reg<sgpr, 1>
  return %r : !waveamdmachine.reg<sgpr, 1>
}

// CHECK-LABEL: func.func @ternary
// CHECK: waveamdmachine.materialization_candidates
// CHECK: test.variant = "a"
// CHECK-NEXT: waveamdmachine.candidate_yield
// CHECK: test.variant = "b"
// CHECK-NEXT: waveamdmachine.candidate_yield
// CHECK: test.variant = "c"
// CHECK-NEXT: waveamdmachine.candidate_yield
func.func @ternary(%x: !waveamdmachine.reg<sgpr, 1>) -> !waveamdmachine.reg<sgpr, 1> {
  %a = waveamdmachine.s_mov_b32_value %x {test.variant = "a"} : (!waveamdmachine.reg<sgpr, 1>) -> !waveamdmachine.reg<sgpr, 1>
  %b = waveamdmachine.s_mov_b32_value %x {test.variant = "b"} : (!waveamdmachine.reg<sgpr, 1>) -> !waveamdmachine.reg<sgpr, 1>
  %c = waveamdmachine.s_mov_b32_value %x {test.variant = "c"} : (!waveamdmachine.reg<sgpr, 1>) -> !waveamdmachine.reg<sgpr, 1>
  %r = waveamdmachine.materialization_variants %a, %b, %c : !waveamdmachine.reg<sgpr, 1>
  return %r : !waveamdmachine.reg<sgpr, 1>
}

// CAP-LABEL: func.func @chained
// CAP: waveamdmachine.materialization_candidates
// CAP: ^bb0([[X0:%[^:]+]]: !waveamdmachine.reg<sgpr, 1>, [[Y0:%[^:]+]]: !waveamdmachine.reg<sgpr, 1>, [[Z0:%[^:]+]]:
// CAP-NEXT: waveamdmachine.candidate_yield [[X0]]
// CAP: ^bb0([[X1:%[^:]+]]: !waveamdmachine.reg<sgpr, 1>, [[Y1:%[^:]+]]: !waveamdmachine.reg<sgpr, 1>, [[Z1:%[^:]+]]:
// CAP-NEXT: waveamdmachine.candidate_yield [[Z1]]
// CAP: ^bb0([[X2:%[^:]+]]: !waveamdmachine.reg<sgpr, 1>, [[Y2:%[^:]+]]: !waveamdmachine.reg<sgpr, 1>, [[Z2:%[^:]+]]:
// CAP-NEXT: waveamdmachine.candidate_yield [[Y2]]
// CAP-NOT: waveamdmachine.candidate_yield
// CAP: return
func.func @chained(%x: !waveamdmachine.reg<sgpr, 1>, %y: !waveamdmachine.reg<sgpr, 1>, %z: !waveamdmachine.reg<sgpr, 1>) -> !waveamdmachine.reg<sgpr, 1> {
  %a = waveamdmachine.materialization_variants %x, %y : !waveamdmachine.reg<sgpr, 1>
  %b = waveamdmachine.materialization_variants %a, %z : !waveamdmachine.reg<sgpr, 1>
  return %b : !waveamdmachine.reg<sgpr, 1>
}

// CHECK-LABEL: func.func @couple_effect_results_through_pure_ops
// CHECK: waveamdmachine.materialization_candidates
// CHECK: waveamdmachine.buffer_load_b32
// CHECK-NOT: waveamdmachine.buffer_load_b32
// CHECK: waveamdmachine.candidate_yield
// CHECK: waveamdmachine.buffer_load_b32
// CHECK-NOT: waveamdmachine.buffer_load_b32
// CHECK: waveamdmachine.candidate_yield
// CHECK-NOT: waveamdmachine.candidate_yield
// CHECK: return
func.func @couple_effect_results_through_pure_ops(
    %off0: !waveamdmachine.reg<vgpr, 1>,
    %off1: !waveamdmachine.reg<vgpr, 1>,
    %desc: !waveamdmachine.reg<sgpr, 4>, %zero: !waveamdmachine.imm,
    %dep: !waveamdmachine.mem.token)
    -> (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.mem.token) {
  %value0, %token0 = waveamdmachine.buffer_load_b32
      %off0, %desc, %zero after %dep
      : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<sgpr, 4>,
         !waveamdmachine.imm, !waveamdmachine.mem.token)
      -> (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.mem.token)
  %value1, %token1 = waveamdmachine.buffer_load_b32
      %off1, %desc, %zero after %dep
      : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<sgpr, 4>,
         !waveamdmachine.imm, !waveamdmachine.mem.token)
      -> (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.mem.token)
  %moved0 = waveamdmachine.v_mov_b32_tuple %value0
      : (!waveamdmachine.reg<vgpr, 1>) -> !waveamdmachine.reg<vgpr, 1>
  %moved1 = waveamdmachine.v_mov_b32_tuple %value1
      : (!waveamdmachine.reg<vgpr, 1>) -> !waveamdmachine.reg<vgpr, 1>
  %value = waveamdmachine.materialization_variants %moved0, %moved1
      : !waveamdmachine.reg<vgpr, 1>
  %token = waveamdmachine.materialization_variants %token0, %token1
      : !waveamdmachine.mem.token
  return %value, %token
      : !waveamdmachine.reg<vgpr, 1>, !waveamdmachine.mem.token
}

// CHECK-LABEL: func.func @remove_complete_effect_chains
// CHECK: waveamdmachine.materialization_candidates
// CHECK-COUNT-2: waveamdmachine.buffer_store_b32
// CHECK: waveamdmachine.candidate_yield
// CHECK-COUNT-2: waveamdmachine.buffer_store_b32
// CHECK: waveamdmachine.candidate_yield
// CHECK-NOT: waveamdmachine.candidate_yield
// CHECK: return
func.func @remove_complete_effect_chains(
    %off0: !waveamdmachine.reg<vgpr, 1>,
    %off1: !waveamdmachine.reg<vgpr, 1>,
    %value: !waveamdmachine.reg<vgpr, 1>,
    %desc: !waveamdmachine.reg<sgpr, 4>, %zero: !waveamdmachine.imm,
    %dep: !waveamdmachine.mem.token) -> !waveamdmachine.mem.token {
  %first0 = waveamdmachine.buffer_store_b32
      %off0, %value, %desc, %zero after %dep
      : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>,
         !waveamdmachine.reg<sgpr, 4>, !waveamdmachine.imm,
         !waveamdmachine.mem.token) -> !waveamdmachine.mem.token
  %last0 = waveamdmachine.buffer_store_b32
      %off0, %value, %desc, %zero after %first0
      : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>,
         !waveamdmachine.reg<sgpr, 4>, !waveamdmachine.imm,
         !waveamdmachine.mem.token) -> !waveamdmachine.mem.token
  %first1 = waveamdmachine.buffer_store_b32
      %off1, %value, %desc, %zero after %dep
      : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>,
         !waveamdmachine.reg<sgpr, 4>, !waveamdmachine.imm,
         !waveamdmachine.mem.token) -> !waveamdmachine.mem.token
  %last1 = waveamdmachine.buffer_store_b32
      %off1, %value, %desc, %zero after %first1
      : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>,
         !waveamdmachine.reg<sgpr, 4>, !waveamdmachine.imm,
         !waveamdmachine.mem.token) -> !waveamdmachine.mem.token
  %token = waveamdmachine.materialization_variants %last0, %last1
      : !waveamdmachine.mem.token
  return %token : !waveamdmachine.mem.token
}

// CHECK-LABEL: func.func @loop_carried_shared_dependency
// CHECK: waveamdmachine.materialization_candidates
// CHECK: waveamdmachine.uniform_loop
// CHECK: waveamdmachine.buffer_load_b32 {{.*}} {test.variant = "computed"}
// CHECK-NOT: waveamdmachine.buffer_load_b32
// CHECK: waveamdmachine.candidate_yield
// CHECK: waveamdmachine.uniform_loop
// CHECK: waveamdmachine.buffer_load_b32 {{.*}} {test.variant = "carried"}
// CHECK-NOT: waveamdmachine.buffer_load_b32
// CHECK: waveamdmachine.candidate_yield
// CHECK: return
func.func @loop_carried_shared_dependency(
    %initial_offset: !waveamdmachine.reg<vgpr, 1>,
    %increment: !waveamdmachine.reg<vgpr, 1>,
    %desc: !waveamdmachine.reg<sgpr, 4>, %zero: !waveamdmachine.imm,
    %condition: !waveamdmachine.reg<scc, 1>,
    %dependency: !waveamdmachine.mem.token) -> !waveamdmachine.mem.token {
  %result:2 = waveamdmachine.uniform_loop if %condition
      : !waveamdmachine.reg<scc, 1>
      carries(%initial_offset, %dependency
              : !waveamdmachine.reg<vgpr, 1>,
                !waveamdmachine.mem.token) {
  ^bb0(%carried_offset: !waveamdmachine.reg<vgpr, 1>,
       %carried_dependency: !waveamdmachine.mem.token):
    %computed_offset = waveamdmachine.v_add_u32
        %carried_offset, %increment
        : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>)
        -> !waveamdmachine.reg<vgpr, 1>
    %computed_value, %computed_token = waveamdmachine.buffer_load_b32
        %computed_offset, %desc, %zero after %carried_dependency
        {test.variant = "computed"}
        : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<sgpr, 4>,
           !waveamdmachine.imm, !waveamdmachine.mem.token)
        -> (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.mem.token)
    %carried_value, %carried_token = waveamdmachine.buffer_load_b32
        %carried_offset, %desc, %zero after %carried_dependency
        {test.variant = "carried"}
        : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<sgpr, 4>,
           !waveamdmachine.imm, !waveamdmachine.mem.token)
        -> (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.mem.token)
    %selected = waveamdmachine.materialization_variants
        %computed_token, %carried_token : !waveamdmachine.mem.token
    waveamdmachine.continue_if %condition
        : !waveamdmachine.reg<scc, 1>
        carries(%computed_offset, %selected
                : !waveamdmachine.reg<vgpr, 1>,
                  !waveamdmachine.mem.token)
  } -> !waveamdmachine.reg<vgpr, 1>, !waveamdmachine.mem.token
  return %result#1 : !waveamdmachine.mem.token
}
