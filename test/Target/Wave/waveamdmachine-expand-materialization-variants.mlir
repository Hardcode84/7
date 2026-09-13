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
// CAP: [[A1:%.*]] = waveamdmachine.s_mov_b32_value {{.*}} {test.variant = "a"}
// CAP-NEXT: [[B1:%.*]] = waveamdmachine.s_mov_b32_value {{.*}} {test.variant = "b"}
// CAP-NEXT: waveamdmachine.candidate_yield [[A1]], [[B1]]
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
