// RUN: wave-sim-report --func=prio_bias --timeline %s | FileCheck %s --check-prefix=PRIO

module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx1100"} {
  func.func @prio_bias() {
    %hi = waveamdmachine.imm 3 : !waveamdmachine.imm
    %one = waveamdmachine.imm 1 : !waveamdmachine.imm
    waveamdmachine.s_setprio %hi : (!waveamdmachine.imm) -> ()
    %s0 = waveamdmachine.s_mov_b32_value %one :
        (!waveamdmachine.imm) -> !waveamdmachine.reg<sgpr, 1>
    %s1:2 = waveamdmachine.s_add_i32 %s0, %one :
        (!waveamdmachine.reg<sgpr, 1>, !waveamdmachine.imm) ->
        (!waveamdmachine.reg<sgpr, 1>, !waveamdmachine.reg<scc, 1>)
    return
  }
}

// PRIO: func: prio_bias
// PRIO: total_cycles: 5
// PRIO: issued_ops: 3
// PRIO: issue cycle=0 fu=SALU op=waveamdmachine.s_setprio
// PRIO: issue cycle=1 fu=SALU op=waveamdmachine.s_mov_b32_value
// PRIO: issue cycle=3 fu=SALU op=waveamdmachine.s_add_i32
