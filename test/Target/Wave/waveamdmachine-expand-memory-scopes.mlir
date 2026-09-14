// RUN: wave-opt %s --waveamd-expand-materialization-variants -o %t.parallel
// RUN: FileCheck %s --implicit-check-not=waveamdmachine.materialization_variants < %t.parallel
// RUN: wave-opt %s --mlir-disable-threading --waveamd-expand-materialization-variants -o %t.serial
// RUN: diff %t.parallel %t.serial

// CHECK-LABEL: func.func @independent_loops
// CHECK: waveamdmachine.materialization_candidates
// CHECK: waveamdmachine.uniform_loop
// CHECK: waveamdmachine.candidate_yield
// CHECK: waveamdmachine.uniform_loop
// CHECK: waveamdmachine.candidate_yield
// CHECK: waveamdmachine.materialization_candidates
// CHECK: waveamdmachine.uniform_loop
// CHECK: waveamdmachine.candidate_yield
// CHECK: waveamdmachine.uniform_loop
// CHECK: waveamdmachine.candidate_yield
// CHECK: waveamdmachine.uniform_loop
// CHECK: waveamdmachine.candidate_yield
// CHECK-NOT: waveamdmachine.materialization_candidates
// CHECK-NOT: waveamdmachine.candidate_yield
// CHECK: return
func.func @independent_loops(%x: !waveamdmachine.reg<vgpr, 1>, %desc: !waveamdmachine.reg<sgpr, 4>, %zero: !waveamdmachine.imm, %condition: !waveamdmachine.reg<scc, 1>, %initial: !waveamdmachine.mem.token) -> (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.mem.token, !waveamdmachine.mem.token) {
  %first:2 = waveamdmachine.uniform_loop if %condition : !waveamdmachine.reg<scc, 1> carries(%x, %initial : !waveamdmachine.reg<vgpr, 1>, !waveamdmachine.mem.token) {
  ^bb0(%value: !waveamdmachine.reg<vgpr, 1>, %dep: !waveamdmachine.mem.token):
    %a0 = waveamdmachine.v_mov_b32_tuple %x {test.alternative = 0 : i64} : (!waveamdmachine.reg<vgpr, 1>) -> !waveamdmachine.reg<vgpr, 1>
    %a1 = waveamdmachine.v_mov_b32_tuple %x {test.alternative = 1 : i64} : (!waveamdmachine.reg<vgpr, 1>) -> !waveamdmachine.reg<vgpr, 1>
    %choice = waveamdmachine.materialization_variants %a0, %a1 : !waveamdmachine.reg<vgpr, 1>
    %loaded, %token = waveamdmachine.buffer_load_b32 %choice, %desc, %zero after %dep : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<sgpr, 4>, !waveamdmachine.imm, !waveamdmachine.mem.token) -> (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.mem.token)
    waveamdmachine.continue_if %condition : !waveamdmachine.reg<scc, 1> carries(%loaded, %token : !waveamdmachine.reg<vgpr, 1>, !waveamdmachine.mem.token)
  } -> !waveamdmachine.reg<vgpr, 1>, !waveamdmachine.mem.token
  %second:2 = waveamdmachine.uniform_loop if %condition : !waveamdmachine.reg<scc, 1> carries(%x, %initial : !waveamdmachine.reg<vgpr, 1>, !waveamdmachine.mem.token) {
  ^bb0(%value: !waveamdmachine.reg<vgpr, 1>, %dep: !waveamdmachine.mem.token):
    %a0 = waveamdmachine.v_mov_b32_tuple %x {test.alternative = 0 : i64} : (!waveamdmachine.reg<vgpr, 1>) -> !waveamdmachine.reg<vgpr, 1>
    %a1 = waveamdmachine.v_mov_b32_tuple %x {test.alternative = 1 : i64} : (!waveamdmachine.reg<vgpr, 1>) -> !waveamdmachine.reg<vgpr, 1>
    %a2 = waveamdmachine.v_mov_b32_tuple %x {test.alternative = 2 : i64} : (!waveamdmachine.reg<vgpr, 1>) -> !waveamdmachine.reg<vgpr, 1>
    %choice = waveamdmachine.materialization_variants %a0, %a1, %a2 : !waveamdmachine.reg<vgpr, 1>
    %token = waveamdmachine.buffer_store_b32 %choice, %value, %desc, %zero after %dep : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<sgpr, 4>, !waveamdmachine.imm, !waveamdmachine.mem.token) -> !waveamdmachine.mem.token
    waveamdmachine.continue_if %condition : !waveamdmachine.reg<scc, 1> carries(%value, %token : !waveamdmachine.reg<vgpr, 1>, !waveamdmachine.mem.token)
  } -> !waveamdmachine.reg<vgpr, 1>, !waveamdmachine.mem.token
  return %second#0, %first#1, %second#1 : !waveamdmachine.reg<vgpr, 1>, !waveamdmachine.mem.token, !waveamdmachine.mem.token
}

// CHECK-LABEL: func.func @data_loops
// CHECK: waveamdmachine.materialization_candidates
// CHECK: [[FIRST:%.*]]:2 = waveamdmachine.uniform_loop
// CHECK: waveamdmachine.uniform_loop {{.*}} carries([[FIRST]]#0,
// CHECK: waveamdmachine.candidate_yield
// CHECK: [[FIRST:%.*]]:2 = waveamdmachine.uniform_loop
// CHECK: waveamdmachine.uniform_loop {{.*}} carries([[FIRST]]#0,
// CHECK: waveamdmachine.candidate_yield
// CHECK: [[FIRST:%.*]]:2 = waveamdmachine.uniform_loop
// CHECK: waveamdmachine.uniform_loop {{.*}} carries([[FIRST]]#0,
// CHECK: waveamdmachine.candidate_yield
// CHECK: [[FIRST:%.*]]:2 = waveamdmachine.uniform_loop
// CHECK: waveamdmachine.uniform_loop {{.*}} carries([[FIRST]]#0,
// CHECK: waveamdmachine.candidate_yield
// CHECK: [[FIRST:%.*]]:2 = waveamdmachine.uniform_loop
// CHECK: waveamdmachine.uniform_loop {{.*}} carries([[FIRST]]#0,
// CHECK: waveamdmachine.candidate_yield
// CHECK: [[FIRST:%.*]]:2 = waveamdmachine.uniform_loop
// CHECK: waveamdmachine.uniform_loop {{.*}} carries([[FIRST]]#0,
// CHECK: waveamdmachine.candidate_yield
// CHECK-NOT: waveamdmachine.materialization_candidates
// CHECK-NOT: waveamdmachine.candidate_yield
// CHECK: return
func.func @data_loops(%x: !waveamdmachine.reg<vgpr, 1>, %desc: !waveamdmachine.reg<sgpr, 4>, %zero: !waveamdmachine.imm, %condition: !waveamdmachine.reg<scc, 1>, %initial: !waveamdmachine.mem.token) -> (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.mem.token, !waveamdmachine.mem.token) {
  %first:2 = waveamdmachine.uniform_loop if %condition : !waveamdmachine.reg<scc, 1> carries(%x, %initial : !waveamdmachine.reg<vgpr, 1>, !waveamdmachine.mem.token) {
  ^bb0(%value: !waveamdmachine.reg<vgpr, 1>, %dep: !waveamdmachine.mem.token):
    %a0 = waveamdmachine.v_mov_b32_tuple %x {test.alternative = 0 : i64} : (!waveamdmachine.reg<vgpr, 1>) -> !waveamdmachine.reg<vgpr, 1>
    %a1 = waveamdmachine.v_mov_b32_tuple %x {test.alternative = 1 : i64} : (!waveamdmachine.reg<vgpr, 1>) -> !waveamdmachine.reg<vgpr, 1>
    %choice = waveamdmachine.materialization_variants %a0, %a1 : !waveamdmachine.reg<vgpr, 1>
    %loaded, %token = waveamdmachine.buffer_load_b32 %choice, %desc, %zero after %dep : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<sgpr, 4>, !waveamdmachine.imm, !waveamdmachine.mem.token) -> (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.mem.token)
    waveamdmachine.continue_if %condition : !waveamdmachine.reg<scc, 1> carries(%loaded, %token : !waveamdmachine.reg<vgpr, 1>, !waveamdmachine.mem.token)
  } -> !waveamdmachine.reg<vgpr, 1>, !waveamdmachine.mem.token
  %second:2 = waveamdmachine.uniform_loop if %condition : !waveamdmachine.reg<scc, 1> carries(%first#0, %initial : !waveamdmachine.reg<vgpr, 1>, !waveamdmachine.mem.token) {
  ^bb0(%value: !waveamdmachine.reg<vgpr, 1>, %dep: !waveamdmachine.mem.token):
    %a0 = waveamdmachine.v_mov_b32_tuple %x {test.alternative = 0 : i64} : (!waveamdmachine.reg<vgpr, 1>) -> !waveamdmachine.reg<vgpr, 1>
    %a1 = waveamdmachine.v_mov_b32_tuple %x {test.alternative = 1 : i64} : (!waveamdmachine.reg<vgpr, 1>) -> !waveamdmachine.reg<vgpr, 1>
    %a2 = waveamdmachine.v_mov_b32_tuple %x {test.alternative = 2 : i64} : (!waveamdmachine.reg<vgpr, 1>) -> !waveamdmachine.reg<vgpr, 1>
    %choice = waveamdmachine.materialization_variants %a0, %a1, %a2 : !waveamdmachine.reg<vgpr, 1>
    %token = waveamdmachine.buffer_store_b32 %choice, %value, %desc, %zero after %dep : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<sgpr, 4>, !waveamdmachine.imm, !waveamdmachine.mem.token) -> !waveamdmachine.mem.token
    waveamdmachine.continue_if %condition : !waveamdmachine.reg<scc, 1> carries(%value, %token : !waveamdmachine.reg<vgpr, 1>, !waveamdmachine.mem.token)
  } -> !waveamdmachine.reg<vgpr, 1>, !waveamdmachine.mem.token
  return %second#0, %first#1, %second#1 : !waveamdmachine.reg<vgpr, 1>, !waveamdmachine.mem.token, !waveamdmachine.mem.token
}

// CHECK-LABEL: func.func @token_loops
// CHECK: waveamdmachine.materialization_candidates
// CHECK: [[FIRST:%.*]]:2 = waveamdmachine.uniform_loop
// CHECK: waveamdmachine.uniform_loop {{.*}} carries({{.*}}, [[FIRST]]#1 :
// CHECK: waveamdmachine.candidate_yield
// CHECK: [[FIRST:%.*]]:2 = waveamdmachine.uniform_loop
// CHECK: waveamdmachine.uniform_loop {{.*}} carries({{.*}}, [[FIRST]]#1 :
// CHECK: waveamdmachine.candidate_yield
// CHECK: [[FIRST:%.*]]:2 = waveamdmachine.uniform_loop
// CHECK: waveamdmachine.uniform_loop {{.*}} carries({{.*}}, [[FIRST]]#1 :
// CHECK: waveamdmachine.candidate_yield
// CHECK: [[FIRST:%.*]]:2 = waveamdmachine.uniform_loop
// CHECK: waveamdmachine.uniform_loop {{.*}} carries({{.*}}, [[FIRST]]#1 :
// CHECK: waveamdmachine.candidate_yield
// CHECK: [[FIRST:%.*]]:2 = waveamdmachine.uniform_loop
// CHECK: waveamdmachine.uniform_loop {{.*}} carries({{.*}}, [[FIRST]]#1 :
// CHECK: waveamdmachine.candidate_yield
// CHECK: [[FIRST:%.*]]:2 = waveamdmachine.uniform_loop
// CHECK: waveamdmachine.uniform_loop {{.*}} carries({{.*}}, [[FIRST]]#1 :
// CHECK: waveamdmachine.candidate_yield
// CHECK-NOT: waveamdmachine.materialization_candidates
// CHECK-NOT: waveamdmachine.candidate_yield
// CHECK: return
func.func @token_loops(%x: !waveamdmachine.reg<vgpr, 1>, %desc: !waveamdmachine.reg<sgpr, 4>, %zero: !waveamdmachine.imm, %condition: !waveamdmachine.reg<scc, 1>, %initial: !waveamdmachine.mem.token) -> (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.mem.token, !waveamdmachine.mem.token) {
  %first:2 = waveamdmachine.uniform_loop if %condition : !waveamdmachine.reg<scc, 1> carries(%x, %initial : !waveamdmachine.reg<vgpr, 1>, !waveamdmachine.mem.token) {
  ^bb0(%value: !waveamdmachine.reg<vgpr, 1>, %dep: !waveamdmachine.mem.token):
    %a0 = waveamdmachine.v_mov_b32_tuple %x {test.alternative = 0 : i64} : (!waveamdmachine.reg<vgpr, 1>) -> !waveamdmachine.reg<vgpr, 1>
    %a1 = waveamdmachine.v_mov_b32_tuple %x {test.alternative = 1 : i64} : (!waveamdmachine.reg<vgpr, 1>) -> !waveamdmachine.reg<vgpr, 1>
    %choice = waveamdmachine.materialization_variants %a0, %a1 : !waveamdmachine.reg<vgpr, 1>
    %loaded, %token = waveamdmachine.buffer_load_b32 %choice, %desc, %zero after %dep : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<sgpr, 4>, !waveamdmachine.imm, !waveamdmachine.mem.token) -> (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.mem.token)
    waveamdmachine.continue_if %condition : !waveamdmachine.reg<scc, 1> carries(%loaded, %token : !waveamdmachine.reg<vgpr, 1>, !waveamdmachine.mem.token)
  } -> !waveamdmachine.reg<vgpr, 1>, !waveamdmachine.mem.token
  %second:2 = waveamdmachine.uniform_loop if %condition : !waveamdmachine.reg<scc, 1> carries(%x, %first#1 : !waveamdmachine.reg<vgpr, 1>, !waveamdmachine.mem.token) {
  ^bb0(%value: !waveamdmachine.reg<vgpr, 1>, %dep: !waveamdmachine.mem.token):
    %a0 = waveamdmachine.v_mov_b32_tuple %x {test.alternative = 0 : i64} : (!waveamdmachine.reg<vgpr, 1>) -> !waveamdmachine.reg<vgpr, 1>
    %a1 = waveamdmachine.v_mov_b32_tuple %x {test.alternative = 1 : i64} : (!waveamdmachine.reg<vgpr, 1>) -> !waveamdmachine.reg<vgpr, 1>
    %a2 = waveamdmachine.v_mov_b32_tuple %x {test.alternative = 2 : i64} : (!waveamdmachine.reg<vgpr, 1>) -> !waveamdmachine.reg<vgpr, 1>
    %choice = waveamdmachine.materialization_variants %a0, %a1, %a2 : !waveamdmachine.reg<vgpr, 1>
    %token = waveamdmachine.buffer_store_b32 %choice, %value, %desc, %zero after %dep : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<sgpr, 4>, !waveamdmachine.imm, !waveamdmachine.mem.token) -> !waveamdmachine.mem.token
    waveamdmachine.continue_if %condition : !waveamdmachine.reg<scc, 1> carries(%value, %token : !waveamdmachine.reg<vgpr, 1>, !waveamdmachine.mem.token)
  } -> !waveamdmachine.reg<vgpr, 1>, !waveamdmachine.mem.token
  return %second#0, %first#1, %second#1 : !waveamdmachine.reg<vgpr, 1>, !waveamdmachine.mem.token, !waveamdmachine.mem.token
}
