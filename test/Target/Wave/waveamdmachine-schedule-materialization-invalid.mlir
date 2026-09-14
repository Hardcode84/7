// RUN: wave-opt %s --waveamd-machine-schedule='apply-schedule' --split-input-file --verify-diagnostics

module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx1100"} {
func.func @nested(%x: !waveamdmachine.reg<sgpr, 1>) -> !waveamdmachine.reg<sgpr, 1> {
  %outer = waveamdmachine.materialization_candidates %x : !waveamdmachine.reg<sgpr, 1> -> !waveamdmachine.reg<sgpr, 1> {
  ^bb0(%arg: !waveamdmachine.reg<sgpr, 1>):
    // expected-error @+1 {{nested materialization candidates must be merged before scheduling}}
    %inner = waveamdmachine.materialization_candidates %arg : !waveamdmachine.reg<sgpr, 1> -> !waveamdmachine.reg<sgpr, 1> {
    ^bb0(%value: !waveamdmachine.reg<sgpr, 1>):
      waveamdmachine.candidate_yield %value : !waveamdmachine.reg<sgpr, 1>
    }
    waveamdmachine.candidate_yield %inner : !waveamdmachine.reg<sgpr, 1>
  }
  return %outer : !waveamdmachine.reg<sgpr, 1>
}
}

// -----

module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx1100"} {
func.func @inside_loop(%condition: !waveamdmachine.reg<scc, 1>, %x: !waveamdmachine.reg<sgpr, 1>) -> !waveamdmachine.reg<sgpr, 1> {
  %loop = waveamdmachine.uniform_loop if %condition : !waveamdmachine.reg<scc, 1> carries(%x : !waveamdmachine.reg<sgpr, 1>) {
  ^bb0(%carry: !waveamdmachine.reg<sgpr, 1>):
    // expected-error @+1 {{materialization candidates must enclose their outermost loop}}
    %choice = waveamdmachine.materialization_candidates %carry : !waveamdmachine.reg<sgpr, 1> -> !waveamdmachine.reg<sgpr, 1> {
    ^bb0(%value: !waveamdmachine.reg<sgpr, 1>):
      waveamdmachine.candidate_yield %value : !waveamdmachine.reg<sgpr, 1>
    }
    waveamdmachine.continue_if %condition : !waveamdmachine.reg<scc, 1> carries(%choice : !waveamdmachine.reg<sgpr, 1>)
  } -> !waveamdmachine.reg<sgpr, 1>
  return %loop : !waveamdmachine.reg<sgpr, 1>
}
}
