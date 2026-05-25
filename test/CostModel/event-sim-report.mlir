// RUN: wave-sim-report --waves=1 %s | FileCheck %s --check-prefix=ONE
// RUN: wave-sim-report --waves=2 %s | FileCheck %s --check-prefix=TWO
// RUN: wave-sim-report --waves=2 --timeline %s | FileCheck %s --check-prefix=TRACE
// RUN: wave-sim-report --func=smem_wait --timeline %s | FileCheck %s --check-prefix=WAIT
// RUN: wave-sim-report --func=smem_partial_wait --timeline %s | FileCheck %s --check-prefix=WAITPART

module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx1100"} {
  func.func @two_dep_salu(%init: !waveamdmachine.reg<sgpr, 1>) {
    %step = waveamdmachine.imm 1 : !waveamdmachine.imm
    %a:2 = waveamdmachine.s_add_i32 %init, %step :
        (!waveamdmachine.reg<sgpr, 1>, !waveamdmachine.imm) ->
        (!waveamdmachine.reg<sgpr, 1>, !waveamdmachine.reg<scc, 1>)
    %b:2 = waveamdmachine.s_add_i32 %a#0, %step :
        (!waveamdmachine.reg<sgpr, 1>, !waveamdmachine.imm) ->
        (!waveamdmachine.reg<sgpr, 1>, !waveamdmachine.reg<scc, 1>)
    return
  }

  func.func @smem_wait() {
    %zero = waveamdmachine.imm 0 : !waveamdmachine.imm
    %step = waveamdmachine.imm 1 : !waveamdmachine.imm
    %load = waveamdmachine.s_load_b32 %zero, "s[0:1]" :
        (!waveamdmachine.imm) -> !waveamdmachine.reg<sgpr, 1>
    waveamdmachine.s_waitcnt %zero : (!waveamdmachine.imm) -> ()
    %sum:2 = waveamdmachine.s_add_i32 %load, %step :
        (!waveamdmachine.reg<sgpr, 1>, !waveamdmachine.imm) ->
        (!waveamdmachine.reg<sgpr, 1>, !waveamdmachine.reg<scc, 1>)
    return
  }

  func.func @smem_partial_wait() {
    %zero = waveamdmachine.imm 0 : !waveamdmachine.imm
    %four = waveamdmachine.imm 4 : !waveamdmachine.imm
    %step = waveamdmachine.imm 1 : !waveamdmachine.imm
    %lgkm1 = waveamdmachine.imm 64535 : !waveamdmachine.imm
    %lgkm0 = waveamdmachine.imm 64519 : !waveamdmachine.imm
    %a = waveamdmachine.s_load_b32 %zero, "s[0:1]" :
        (!waveamdmachine.imm) -> !waveamdmachine.reg<sgpr, 1>
    %b = waveamdmachine.s_load_b32 %four, "s[0:1]" :
        (!waveamdmachine.imm) -> !waveamdmachine.reg<sgpr, 1>
    waveamdmachine.s_waitcnt %lgkm1 : (!waveamdmachine.imm) -> ()
    %sum_a:2 = waveamdmachine.s_add_i32 %a, %step :
        (!waveamdmachine.reg<sgpr, 1>, !waveamdmachine.imm) ->
        (!waveamdmachine.reg<sgpr, 1>, !waveamdmachine.reg<scc, 1>)
    waveamdmachine.s_waitcnt %lgkm0 : (!waveamdmachine.imm) -> ()
    %sum_b:2 = waveamdmachine.s_add_i32 %b, %step :
        (!waveamdmachine.reg<sgpr, 1>, !waveamdmachine.imm) ->
        (!waveamdmachine.reg<sgpr, 1>, !waveamdmachine.reg<scc, 1>)
    return
  }
}

// ONE: func: two_dep_salu
// ONE: arch: gfx1100
// ONE: waves: 1
// ONE: total_cycles: 4
// ONE: issued_ops: 2
// ONE: wave_0_completed: 4

// TWO: waves: 2
// TWO: total_cycles: 5
// TWO: issued_ops: 4
// TWO: wave_0_completed: 4
// TWO: wave_1_completed: 5

// TRACE: issue cycle=0 wave=0 simd=0 fu=SALU op=waveamdmachine.s_add_i32
// TRACE: issue cycle=1 wave=1 simd=0 fu=SALU op=waveamdmachine.s_add_i32
// TRACE: issue cycle=2 wave=0 simd=0 fu=SALU op=waveamdmachine.s_add_i32
// TRACE: issue cycle=3 wave=1 simd=0 fu=SALU op=waveamdmachine.s_add_i32

// WAIT: func: smem_wait
// WAIT: total_cycles: 22
// WAIT: issued_ops: 2
// WAIT: issue cycle=0 wave=0 simd=0 fu=LGKM op=waveamdmachine.s_load_b32
// WAIT: issue cycle=20 wave=0 simd=0 fu=SALU op=waveamdmachine.s_add_i32
// WAIT: counter_drained cycle=20 wave=0 simd=0 fu=LGKM counter=lgkm op=waveamdmachine.s_load_b32
// WAIT: counter_drained cycle=20 wave=0 simd=0 op=waveamdmachine.s_waitcnt

// WAITPART: issue cycle=0 wave=0 simd=0 fu=LGKM op=waveamdmachine.s_load_b32
// WAITPART: issue cycle=1 wave=0 simd=0 fu=LGKM op=waveamdmachine.s_load_b32
// WAITPART: issue cycle=20 wave=0 simd=0 fu=SALU op=waveamdmachine.s_add_i32
// WAITPART: issue cycle=21 wave=0 simd=0 fu=SALU op=waveamdmachine.s_add_i32
