// RUN: wave-opt %s --waveamd-machine-schedule='apply-schedule' --split-input-file --verify-diagnostics
// -----
module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx1100"} {
func.func @negative(%condition: !waveamdmachine.reg<scc, 1>, %x: !waveamdmachine.reg<sgpr, 1>) -> !waveamdmachine.reg<sgpr, 1> {
  %r = waveamdmachine.materialization_candidates %condition, %x : !waveamdmachine.reg<scc, 1>, !waveamdmachine.reg<sgpr, 1> -> !waveamdmachine.reg<sgpr, 1> {
  ^bb0(%cond: !waveamdmachine.reg<scc, 1>, %arg: !waveamdmachine.reg<sgpr, 1>):
    waveamdmachine.candidate_yield %arg : !waveamdmachine.reg<sgpr, 1>
  }, {
  ^bb0(%cond: !waveamdmachine.reg<scc, 1>, %arg: !waveamdmachine.reg<sgpr, 1>):
    // expected-error @+1 {{candidate scheduling requires an exact nonnegative i64}}
    %loop = waveamdmachine.uniform_loop if %cond : !waveamdmachine.reg<scc, 1> carries(%arg : !waveamdmachine.reg<sgpr, 1>) {
    ^bb0(%carry: !waveamdmachine.reg<sgpr, 1>):
      waveamdmachine.continue_if %cond : !waveamdmachine.reg<scc, 1> carries(%carry : !waveamdmachine.reg<sgpr, 1>)
    } {waveamdmachine.trip_count = -1 : i64} -> !waveamdmachine.reg<sgpr, 1>
    waveamdmachine.candidate_yield %loop : !waveamdmachine.reg<sgpr, 1>
  }
  return %r : !waveamdmachine.reg<sgpr, 1>
}
}

// -----
module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx1100"} {
func.func @zero_post(%condition: !waveamdmachine.reg<scc, 1>, %x: !waveamdmachine.reg<sgpr, 1>) -> !waveamdmachine.reg<sgpr, 1> {
  %r = waveamdmachine.materialization_candidates %condition, %x : !waveamdmachine.reg<scc, 1>, !waveamdmachine.reg<sgpr, 1> -> !waveamdmachine.reg<sgpr, 1> {
  ^bb0(%cond: !waveamdmachine.reg<scc, 1>, %arg: !waveamdmachine.reg<sgpr, 1>):
    waveamdmachine.candidate_yield %arg : !waveamdmachine.reg<sgpr, 1>
  }, {
  ^bb0(%cond: !waveamdmachine.reg<scc, 1>, %arg: !waveamdmachine.reg<sgpr, 1>):
    // expected-error @+1 {{candidate scheduling requires an exact nonnegative i64}}
    %loop = waveamdmachine.uniform_loop  carries(%arg : !waveamdmachine.reg<sgpr, 1>) {
    ^bb0(%carry: !waveamdmachine.reg<sgpr, 1>):
      waveamdmachine.continue_if %cond : !waveamdmachine.reg<scc, 1> carries(%carry : !waveamdmachine.reg<sgpr, 1>)
    } {waveamdmachine.trip_count = 0 : i64} -> !waveamdmachine.reg<sgpr, 1>
    waveamdmachine.candidate_yield %loop : !waveamdmachine.reg<sgpr, 1>
  }
  return %r : !waveamdmachine.reg<sgpr, 1>
}
}

// -----
module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx1100"} {
func.func @wrong_type(%condition: !waveamdmachine.reg<scc, 1>, %x: !waveamdmachine.reg<sgpr, 1>) -> !waveamdmachine.reg<sgpr, 1> {
  %r = waveamdmachine.materialization_candidates %condition, %x : !waveamdmachine.reg<scc, 1>, !waveamdmachine.reg<sgpr, 1> -> !waveamdmachine.reg<sgpr, 1> {
  ^bb0(%cond: !waveamdmachine.reg<scc, 1>, %arg: !waveamdmachine.reg<sgpr, 1>):
    waveamdmachine.candidate_yield %arg : !waveamdmachine.reg<sgpr, 1>
  }, {
  ^bb0(%cond: !waveamdmachine.reg<scc, 1>, %arg: !waveamdmachine.reg<sgpr, 1>):
    // expected-error @+1 {{candidate scheduling requires an exact nonnegative i64}}
    %loop = waveamdmachine.uniform_loop if %cond : !waveamdmachine.reg<scc, 1> carries(%arg : !waveamdmachine.reg<sgpr, 1>) {
    ^bb0(%carry: !waveamdmachine.reg<sgpr, 1>):
      waveamdmachine.continue_if %cond : !waveamdmachine.reg<scc, 1> carries(%carry : !waveamdmachine.reg<sgpr, 1>)
    } {waveamdmachine.trip_count = 2 : i32} -> !waveamdmachine.reg<sgpr, 1>
    waveamdmachine.candidate_yield %loop : !waveamdmachine.reg<sgpr, 1>
  }
  return %r : !waveamdmachine.reg<sgpr, 1>
}
}
