// RUN: wave-opt %s --pass-pipeline='builtin.module(func.func(waveamd-cleanup-materialization-variants))' -o %t.parallel
// RUN: FileCheck %s < %t.parallel
// RUN: wave-opt %s --mlir-disable-threading --pass-pipeline='builtin.module(func.func(waveamdmachine.materialization_candidates(remove-dead-values,cse,canonicalize)))' -o %t.serial
// RUN: diff %t.parallel %t.serial

module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx1100"} {
// CHECK-LABEL: func.func @siblings
func.func @siblings(%x: !waveamdmachine.reg<sgpr, 1>, %c: !waveamdmachine.reg<scc, 1>) -> (!waveamdmachine.reg<sgpr, 1>, !waveamdmachine.reg<sgpr, 1>) {
// CHECK: waveamdmachine.materialization_candidates {{.*}} -> !waveamdmachine.reg<sgpr, 1>, !waveamdmachine.reg<sgpr, 1> {
  %r0:2 = waveamdmachine.materialization_candidates %x, %x, %c : !waveamdmachine.reg<sgpr, 1>, !waveamdmachine.reg<sgpr, 1>, !waveamdmachine.reg<scc, 1> -> !waveamdmachine.reg<sgpr, 1>, !waveamdmachine.reg<sgpr, 1> {
// CHECK: ^bb0(%{{.*}}: !waveamdmachine.reg<sgpr, 1>, %{{.*}}: !waveamdmachine.reg<sgpr, 1>, %{{.*}}: !waveamdmachine.reg<scc, 1>):
// CHECK: [[IF:%.*]] = waveamdmachine.uniform_if
// CHECK: } : !waveamdmachine.reg<scc, 1> -> !waveamdmachine.reg<sgpr, 1>
// CHECK: waveamdmachine.candidate_yield [[IF]],
  ^bb0(%a: !waveamdmachine.reg<sgpr, 1>, %b: !waveamdmachine.reg<sgpr, 1>, %cond: !waveamdmachine.reg<scc, 1>):
    %pair:2 = waveamdmachine.uniform_if %cond {
      %sum, %flag = waveamdmachine.s_add_i32 %a, %a : (!waveamdmachine.reg<sgpr, 1>, !waveamdmachine.reg<sgpr, 1>) -> (!waveamdmachine.reg<sgpr, 1>, !waveamdmachine.reg<scc, 1>)
      waveamdmachine.yield %sum, %sum : !waveamdmachine.reg<sgpr, 1>, !waveamdmachine.reg<sgpr, 1>
    } otherwise {
      %sum, %flag = waveamdmachine.s_add_i32 %b, %b : (!waveamdmachine.reg<sgpr, 1>, !waveamdmachine.reg<sgpr, 1>) -> (!waveamdmachine.reg<sgpr, 1>, !waveamdmachine.reg<scc, 1>)
      waveamdmachine.yield %sum, %sum : !waveamdmachine.reg<sgpr, 1>, !waveamdmachine.reg<sgpr, 1>
    } : !waveamdmachine.reg<scc, 1> -> !waveamdmachine.reg<sgpr, 1>, !waveamdmachine.reg<sgpr, 1>
    waveamdmachine.candidate_yield %pair#0, %pair#1 : !waveamdmachine.reg<sgpr, 1>, !waveamdmachine.reg<sgpr, 1>
  }, {
// CHECK: ^bb0(%{{.*}}: !waveamdmachine.reg<sgpr, 1>, %{{.*}}: !waveamdmachine.reg<sgpr, 1>, %{{.*}}: !waveamdmachine.reg<scc, 1>):
// CHECK: [[IF:%.*]] = waveamdmachine.uniform_if
// CHECK: } : !waveamdmachine.reg<scc, 1> -> !waveamdmachine.reg<sgpr, 1>
// CHECK: waveamdmachine.candidate_yield [[IF]],
  ^bb0(%a: !waveamdmachine.reg<sgpr, 1>, %b: !waveamdmachine.reg<sgpr, 1>, %cond: !waveamdmachine.reg<scc, 1>):
    %pair:2 = waveamdmachine.uniform_if %cond {
      %sum, %flag = waveamdmachine.s_add_i32 %a, %a : (!waveamdmachine.reg<sgpr, 1>, !waveamdmachine.reg<sgpr, 1>) -> (!waveamdmachine.reg<sgpr, 1>, !waveamdmachine.reg<scc, 1>)
      waveamdmachine.yield %sum, %sum : !waveamdmachine.reg<sgpr, 1>, !waveamdmachine.reg<sgpr, 1>
    } otherwise {
      %sum, %flag = waveamdmachine.s_add_i32 %b, %b : (!waveamdmachine.reg<sgpr, 1>, !waveamdmachine.reg<sgpr, 1>) -> (!waveamdmachine.reg<sgpr, 1>, !waveamdmachine.reg<scc, 1>)
      waveamdmachine.yield %sum, %sum : !waveamdmachine.reg<sgpr, 1>, !waveamdmachine.reg<sgpr, 1>
    } : !waveamdmachine.reg<scc, 1> -> !waveamdmachine.reg<sgpr, 1>, !waveamdmachine.reg<sgpr, 1>
    waveamdmachine.candidate_yield %pair#0, %pair#1 : !waveamdmachine.reg<sgpr, 1>, !waveamdmachine.reg<sgpr, 1>
  }
// CHECK: waveamdmachine.materialization_candidates {{.*}} -> !waveamdmachine.reg<sgpr, 1>, !waveamdmachine.reg<sgpr, 1> {
  %r1:2 = waveamdmachine.materialization_candidates %x, %x, %c : !waveamdmachine.reg<sgpr, 1>, !waveamdmachine.reg<sgpr, 1>, !waveamdmachine.reg<scc, 1> -> !waveamdmachine.reg<sgpr, 1>, !waveamdmachine.reg<sgpr, 1> {
// CHECK: ^bb0(%{{.*}}: !waveamdmachine.reg<sgpr, 1>, %{{.*}}: !waveamdmachine.reg<sgpr, 1>, %{{.*}}: !waveamdmachine.reg<scc, 1>):
// CHECK: [[IF:%.*]] = waveamdmachine.uniform_if
// CHECK: } : !waveamdmachine.reg<scc, 1> -> !waveamdmachine.reg<sgpr, 1>
// CHECK: waveamdmachine.candidate_yield [[IF]],
  ^bb0(%a: !waveamdmachine.reg<sgpr, 1>, %b: !waveamdmachine.reg<sgpr, 1>, %cond: !waveamdmachine.reg<scc, 1>):
    %pair:2 = waveamdmachine.uniform_if %cond {
      %sum, %flag = waveamdmachine.s_add_i32 %a, %a : (!waveamdmachine.reg<sgpr, 1>, !waveamdmachine.reg<sgpr, 1>) -> (!waveamdmachine.reg<sgpr, 1>, !waveamdmachine.reg<scc, 1>)
      waveamdmachine.yield %sum, %sum : !waveamdmachine.reg<sgpr, 1>, !waveamdmachine.reg<sgpr, 1>
    } otherwise {
      %sum, %flag = waveamdmachine.s_add_i32 %b, %b : (!waveamdmachine.reg<sgpr, 1>, !waveamdmachine.reg<sgpr, 1>) -> (!waveamdmachine.reg<sgpr, 1>, !waveamdmachine.reg<scc, 1>)
      waveamdmachine.yield %sum, %sum : !waveamdmachine.reg<sgpr, 1>, !waveamdmachine.reg<sgpr, 1>
    } : !waveamdmachine.reg<scc, 1> -> !waveamdmachine.reg<sgpr, 1>, !waveamdmachine.reg<sgpr, 1>
    waveamdmachine.candidate_yield %pair#0, %pair#1 : !waveamdmachine.reg<sgpr, 1>, !waveamdmachine.reg<sgpr, 1>
  }, {
// CHECK: ^bb0(%{{.*}}: !waveamdmachine.reg<sgpr, 1>, %{{.*}}: !waveamdmachine.reg<sgpr, 1>, %{{.*}}: !waveamdmachine.reg<scc, 1>):
// CHECK: [[IF:%.*]] = waveamdmachine.uniform_if
// CHECK: } : !waveamdmachine.reg<scc, 1> -> !waveamdmachine.reg<sgpr, 1>
// CHECK: waveamdmachine.candidate_yield [[IF]],
  ^bb0(%a: !waveamdmachine.reg<sgpr, 1>, %b: !waveamdmachine.reg<sgpr, 1>, %cond: !waveamdmachine.reg<scc, 1>):
    %pair:2 = waveamdmachine.uniform_if %cond {
      %sum, %flag = waveamdmachine.s_add_i32 %a, %a : (!waveamdmachine.reg<sgpr, 1>, !waveamdmachine.reg<sgpr, 1>) -> (!waveamdmachine.reg<sgpr, 1>, !waveamdmachine.reg<scc, 1>)
      waveamdmachine.yield %sum, %sum : !waveamdmachine.reg<sgpr, 1>, !waveamdmachine.reg<sgpr, 1>
    } otherwise {
      %sum, %flag = waveamdmachine.s_add_i32 %b, %b : (!waveamdmachine.reg<sgpr, 1>, !waveamdmachine.reg<sgpr, 1>) -> (!waveamdmachine.reg<sgpr, 1>, !waveamdmachine.reg<scc, 1>)
      waveamdmachine.yield %sum, %sum : !waveamdmachine.reg<sgpr, 1>, !waveamdmachine.reg<sgpr, 1>
    } : !waveamdmachine.reg<scc, 1> -> !waveamdmachine.reg<sgpr, 1>, !waveamdmachine.reg<sgpr, 1>
    waveamdmachine.candidate_yield %pair#0, %pair#1 : !waveamdmachine.reg<sgpr, 1>, !waveamdmachine.reg<sgpr, 1>
  }
  return %r0#0, %r1#0 : !waveamdmachine.reg<sgpr, 1>, !waveamdmachine.reg<sgpr, 1>
}
}
