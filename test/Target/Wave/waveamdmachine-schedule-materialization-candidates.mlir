// RUN: wave-opt %s --waveamd-machine-schedule='apply-schedule' -o %t.parallel 2> %t.parallel.log
// RUN: FileCheck %s < %t.parallel
// RUN: wave-opt %s --mlir-disable-threading --waveamd-machine-schedule='apply-schedule' -o %t.serial 2> %t.serial.log
// RUN: diff %t.parallel %t.serial
// RUN: diff %t.parallel.log %t.serial.log
// RUN: wave-opt %s --waveamd-machine-schedule | FileCheck %s --check-prefix=NOOP
// NOOP: cycles = 999 : i64
// CHECK-LABEL: func.func @scores
// CHECK: waveamdmachine.materialization_candidates
// CHECK: waveamdmachine.candidate_yield {{.*}}cycles = 4 : i64
// CHECK: waveamdmachine.candidate_yield {{.*}}cycles = 2 : i64
// CHECK: waveamdmachine.candidate_yield {{.*}}cycles = 0 : i64
module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx1100"} {
func.func @scores(%x: !waveamdmachine.reg<sgpr, 1>) -> !waveamdmachine.reg<sgpr, 1> {
  %r = waveamdmachine.materialization_candidates %x : !waveamdmachine.reg<sgpr, 1> -> !waveamdmachine.reg<sgpr, 1> {
  ^bb0(%arg: !waveamdmachine.reg<sgpr, 1>):
    %a = waveamdmachine.s_mov_b32_value %arg : (!waveamdmachine.reg<sgpr, 1>) -> !waveamdmachine.reg<sgpr, 1>
    %b = waveamdmachine.s_mov_b32_value %a : (!waveamdmachine.reg<sgpr, 1>) -> !waveamdmachine.reg<sgpr, 1>
    waveamdmachine.candidate_yield %b : !waveamdmachine.reg<sgpr, 1> {cycles = 999 : i64}
  }, {
  ^bb0(%arg: !waveamdmachine.reg<sgpr, 1>):
    %a = waveamdmachine.s_mov_b32_value %arg : (!waveamdmachine.reg<sgpr, 1>) -> !waveamdmachine.reg<sgpr, 1>
    waveamdmachine.candidate_yield %a : !waveamdmachine.reg<sgpr, 1>
  }, {
  ^bb0(%arg: !waveamdmachine.reg<sgpr, 1>):
    waveamdmachine.candidate_yield %arg : !waveamdmachine.reg<sgpr, 1>
  }
  return %r : !waveamdmachine.reg<sgpr, 1>
}
// CHECK-LABEL: func.func @loop_0
// CHECK: waveamdmachine.uniform_loop
// CHECK: waveamdmachine.candidate_yield {{.*}}cycles = 2 : i64
func.func @loop_0(%condition: !waveamdmachine.reg<scc, 1>, %x: !waveamdmachine.reg<sgpr, 1>) -> !waveamdmachine.reg<sgpr, 1> {
  %r = waveamdmachine.materialization_candidates %condition, %x : !waveamdmachine.reg<scc, 1>, !waveamdmachine.reg<sgpr, 1> -> !waveamdmachine.reg<sgpr, 1> {
  ^bb0(%condition_arg: !waveamdmachine.reg<scc, 1>, %arg: !waveamdmachine.reg<sgpr, 1>):
    %loop = waveamdmachine.uniform_loop if %condition_arg : !waveamdmachine.reg<scc, 1> carries(%arg : !waveamdmachine.reg<sgpr, 1>) {
    ^bb0(%carry: !waveamdmachine.reg<sgpr, 1>):
      %value = waveamdmachine.s_mov_b32_value %carry : (!waveamdmachine.reg<sgpr, 1>) -> !waveamdmachine.reg<sgpr, 1>
      waveamdmachine.continue_if %condition_arg : !waveamdmachine.reg<scc, 1> carries(%value : !waveamdmachine.reg<sgpr, 1>)
    } {waveamdmachine.trip_count = 0 : i64} -> !waveamdmachine.reg<sgpr, 1>
    waveamdmachine.candidate_yield %loop : !waveamdmachine.reg<sgpr, 1>
  }
  return %r : !waveamdmachine.reg<sgpr, 1>
}
// CHECK-LABEL: func.func @loop_1
// CHECK: waveamdmachine.uniform_loop
// CHECK: waveamdmachine.candidate_yield {{.*}}cycles = 2 : i64
func.func @loop_1(%condition: !waveamdmachine.reg<scc, 1>, %x: !waveamdmachine.reg<sgpr, 1>) -> !waveamdmachine.reg<sgpr, 1> {
  %r = waveamdmachine.materialization_candidates %condition, %x : !waveamdmachine.reg<scc, 1>, !waveamdmachine.reg<sgpr, 1> -> !waveamdmachine.reg<sgpr, 1> {
  ^bb0(%condition_arg: !waveamdmachine.reg<scc, 1>, %arg: !waveamdmachine.reg<sgpr, 1>):
    %loop = waveamdmachine.uniform_loop if %condition_arg : !waveamdmachine.reg<scc, 1> carries(%arg : !waveamdmachine.reg<sgpr, 1>) {
    ^bb0(%carry: !waveamdmachine.reg<sgpr, 1>):
      %value = waveamdmachine.s_mov_b32_value %carry : (!waveamdmachine.reg<sgpr, 1>) -> !waveamdmachine.reg<sgpr, 1>
      waveamdmachine.continue_if %condition_arg : !waveamdmachine.reg<scc, 1> carries(%value : !waveamdmachine.reg<sgpr, 1>)
    } {waveamdmachine.trip_count = 1 : i64} -> !waveamdmachine.reg<sgpr, 1>
    waveamdmachine.candidate_yield %loop : !waveamdmachine.reg<sgpr, 1>
  }
  return %r : !waveamdmachine.reg<sgpr, 1>
}
// CHECK-LABEL: func.func @loop_3
// CHECK: waveamdmachine.uniform_loop
// CHECK: waveamdmachine.candidate_yield {{.*}}cycles = 2 : i64
func.func @loop_3(%condition: !waveamdmachine.reg<scc, 1>, %x: !waveamdmachine.reg<sgpr, 1>) -> !waveamdmachine.reg<sgpr, 1> {
  %r = waveamdmachine.materialization_candidates %condition, %x : !waveamdmachine.reg<scc, 1>, !waveamdmachine.reg<sgpr, 1> -> !waveamdmachine.reg<sgpr, 1> {
  ^bb0(%condition_arg: !waveamdmachine.reg<scc, 1>, %arg: !waveamdmachine.reg<sgpr, 1>):
    %loop = waveamdmachine.uniform_loop if %condition_arg : !waveamdmachine.reg<scc, 1> carries(%arg : !waveamdmachine.reg<sgpr, 1>) {
    ^bb0(%carry: !waveamdmachine.reg<sgpr, 1>):
      %value = waveamdmachine.s_mov_b32_value %carry : (!waveamdmachine.reg<sgpr, 1>) -> !waveamdmachine.reg<sgpr, 1>
      waveamdmachine.continue_if %condition_arg : !waveamdmachine.reg<scc, 1> carries(%value : !waveamdmachine.reg<sgpr, 1>)
    } {waveamdmachine.trip_count = 3 : i64} -> !waveamdmachine.reg<sgpr, 1>
    waveamdmachine.candidate_yield %loop : !waveamdmachine.reg<sgpr, 1>
  }
  return %r : !waveamdmachine.reg<sgpr, 1>
}
}

// CHECK-LABEL: func.func @continuation
// CHECK: [[LOAD:%.*]], {{%.*}} = waveamdmachine.global_load_b32
// CHECK: [[WIN:%.*]] = waveamdmachine.materialization_candidates
// CHECK: waveamdmachine.candidate_yield
// CHECK: waveamdmachine.candidate_yield
// CHECK: [[IND:%.*]] = waveamdmachine.v_add_u32 {{.*}} {test.independent}
// CHECK-NEXT: [[DEP:%.*]] = waveamdmachine.v_add_u32 [[WIN]], {{.*}} {test.dependent}
// CHECK: return [[DEP]], [[IND]]
module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx1100"} {
func.func @continuation(%off: !waveamdmachine.reg<vgpr, 1>, %base: !waveamdmachine.reg<sgpr, 2>, %a: !waveamdmachine.reg<vgpr, 1>, %b: !waveamdmachine.reg<vgpr, 1>) -> (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>) {
  %token = waveamdmachine.token : !waveamdmachine.mem.token
  %zero = waveamdmachine.imm 0 : !waveamdmachine.imm
  %loaded, %ready = waveamdmachine.global_load_b32 %off, %base after %token : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<sgpr, 2>, !waveamdmachine.mem.token) -> (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.mem.token)
  %winner = waveamdmachine.materialization_candidates %loaded, %zero : !waveamdmachine.reg<vgpr, 1>, !waveamdmachine.imm -> !waveamdmachine.reg<vgpr, 1> {
  ^bb0(%value: !waveamdmachine.reg<vgpr, 1>, %z: !waveamdmachine.imm):
    %copy = waveamdmachine.v_add_u32 %value, %z : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.imm) -> !waveamdmachine.reg<vgpr, 1>
    waveamdmachine.candidate_yield %copy : !waveamdmachine.reg<vgpr, 1>
  }, {
  ^bb0(%value: !waveamdmachine.reg<vgpr, 1>, %z: !waveamdmachine.imm):
    waveamdmachine.candidate_yield %value : !waveamdmachine.reg<vgpr, 1>
  }
  %dependent = waveamdmachine.v_add_u32 %winner, %a {test.dependent} : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>) -> !waveamdmachine.reg<vgpr, 1>
  %independent = waveamdmachine.v_add_u32 %a, %b {test.independent} : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>) -> !waveamdmachine.reg<vgpr, 1>
  return %dependent, %independent : !waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>
}
}

// CHECK-LABEL: func.func @nested_loops
// CHECK: waveamdmachine.uniform_loop
// CHECK: waveamdmachine.uniform_loop
// CHECK: waveamdmachine.candidate_yield {{.*}}cycles = 2 : i64
module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx1100"} {
func.func @nested_loops(%condition: !waveamdmachine.reg<scc, 1>, %x: !waveamdmachine.reg<sgpr, 1>) -> !waveamdmachine.reg<sgpr, 1> {
  %r = waveamdmachine.materialization_candidates %condition, %x : !waveamdmachine.reg<scc, 1>, !waveamdmachine.reg<sgpr, 1> -> !waveamdmachine.reg<sgpr, 1> {
  ^bb0(%condition_arg: !waveamdmachine.reg<scc, 1>, %arg: !waveamdmachine.reg<sgpr, 1>):
    %loop = waveamdmachine.uniform_loop if %condition_arg : !waveamdmachine.reg<scc, 1> carries(%arg : !waveamdmachine.reg<sgpr, 1>) {
    ^bb0(%carry: !waveamdmachine.reg<sgpr, 1>):
      %value = waveamdmachine.uniform_loop if %condition_arg : !waveamdmachine.reg<scc, 1> carries(%carry : !waveamdmachine.reg<sgpr, 1>) {
      ^bb0(%inner: !waveamdmachine.reg<sgpr, 1>):
        %copy = waveamdmachine.s_mov_b32_value %inner : (!waveamdmachine.reg<sgpr, 1>) -> !waveamdmachine.reg<sgpr, 1>
        waveamdmachine.continue_if %condition_arg : !waveamdmachine.reg<scc, 1> carries(%copy : !waveamdmachine.reg<sgpr, 1>)
      } {waveamdmachine.trip_count = 2 : i64} -> !waveamdmachine.reg<sgpr, 1>
      waveamdmachine.continue_if %condition_arg : !waveamdmachine.reg<scc, 1> carries(%value : !waveamdmachine.reg<sgpr, 1>)
    } {waveamdmachine.trip_count = 3 : i64} -> !waveamdmachine.reg<sgpr, 1>
    waveamdmachine.candidate_yield %loop : !waveamdmachine.reg<sgpr, 1>
  }
  return %r : !waveamdmachine.reg<sgpr, 1>
}
}

// CHECK-LABEL: func.func @missing
// CHECK: waveamdmachine.candidate_yield {{.*}}cycles = 0 : i64
// CHECK: waveamdmachine.uniform_loop
// CHECK: waveamdmachine.candidate_yield {{.*}}cycles = 2 : i64
module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx1100"} {
func.func @missing(%condition: !waveamdmachine.reg<scc, 1>, %x: !waveamdmachine.reg<sgpr, 1>) -> !waveamdmachine.reg<sgpr, 1> {
  %r = waveamdmachine.materialization_candidates %condition, %x : !waveamdmachine.reg<scc, 1>, !waveamdmachine.reg<sgpr, 1> -> !waveamdmachine.reg<sgpr, 1> {
  ^bb0(%cond: !waveamdmachine.reg<scc, 1>, %arg: !waveamdmachine.reg<sgpr, 1>):
    waveamdmachine.candidate_yield %arg : !waveamdmachine.reg<sgpr, 1>
  }, {
  ^bb0(%cond: !waveamdmachine.reg<scc, 1>, %arg: !waveamdmachine.reg<sgpr, 1>):
    %loop = waveamdmachine.uniform_loop if %cond : !waveamdmachine.reg<scc, 1> carries(%arg : !waveamdmachine.reg<sgpr, 1>) {
    ^bb0(%carry: !waveamdmachine.reg<sgpr, 1>):
      %value = waveamdmachine.s_mov_b32_value %carry : (!waveamdmachine.reg<sgpr, 1>) -> !waveamdmachine.reg<sgpr, 1>
      waveamdmachine.continue_if %cond : !waveamdmachine.reg<scc, 1> carries(%value : !waveamdmachine.reg<sgpr, 1>)
    }  -> !waveamdmachine.reg<sgpr, 1>
    waveamdmachine.candidate_yield %loop : !waveamdmachine.reg<sgpr, 1>
  }
  return %r : !waveamdmachine.reg<sgpr, 1>
}
}

// CHECK-LABEL: func.func @loop_large
// CHECK: waveamdmachine.candidate_yield {{.*}}cycles = 2 : i64
module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx1100"} {
func.func @loop_large(%condition: !waveamdmachine.reg<scc, 1>, %x: !waveamdmachine.reg<sgpr, 1>) -> !waveamdmachine.reg<sgpr, 1> {
  %r = waveamdmachine.materialization_candidates %condition, %x : !waveamdmachine.reg<scc, 1>, !waveamdmachine.reg<sgpr, 1> -> !waveamdmachine.reg<sgpr, 1> {
  ^bb0(%condition_arg: !waveamdmachine.reg<scc, 1>, %arg: !waveamdmachine.reg<sgpr, 1>):
    %loop = waveamdmachine.uniform_loop if %condition_arg : !waveamdmachine.reg<scc, 1> carries(%arg : !waveamdmachine.reg<sgpr, 1>) {
    ^bb0(%carry: !waveamdmachine.reg<sgpr, 1>):
      %value = waveamdmachine.s_mov_b32_value %carry : (!waveamdmachine.reg<sgpr, 1>) -> !waveamdmachine.reg<sgpr, 1>
      waveamdmachine.continue_if %condition_arg : !waveamdmachine.reg<scc, 1> carries(%value : !waveamdmachine.reg<sgpr, 1>)
    } {waveamdmachine.trip_count = 9223372036854775807 : i64} -> !waveamdmachine.reg<sgpr, 1>
    waveamdmachine.candidate_yield %loop : !waveamdmachine.reg<sgpr, 1>
  }
  return %r : !waveamdmachine.reg<sgpr, 1>
}
}
