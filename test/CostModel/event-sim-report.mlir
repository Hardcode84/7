// RUN: wave-sim-report --waves=1 %s | FileCheck %s --check-prefix=ONE
// RUN: wave-sim-report --waves=2 %s | FileCheck %s --check-prefix=TWO
// RUN: wave-sim-report --waves=2 --timeline %s | FileCheck %s --check-prefix=TRACE
// RUN: wave-sim-report --func=smem_wait --timeline %s | FileCheck %s --check-prefix=WAIT
// RUN: wave-sim-report --func=smem_wait --timeline --smem-counter-latency=7 %s | FileCheck %s --check-prefix=COUNTER
// RUN: wave-sim-report --func=smem_wait --op-latencies %s | FileCheck %s --check-prefix=LAT
// RUN: wave-sim-report --func=smem_partial_wait --timeline %s | FileCheck %s --check-prefix=WAITPART
// RUN: wave-sim-report --func=trip_loop --trip-count=3 %s | FileCheck %s --check-prefix=TRIP

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

  func.func @trip_loop(%init: !waveamdmachine.reg<sgpr, 1>) {
    %step = waveamdmachine.imm 1 : !waveamdmachine.imm
    %r = waveamdmachine.uniform_loop carries(%init : !waveamdmachine.reg<sgpr, 1>) {
    ^bb0(%iv: !waveamdmachine.reg<sgpr, 1>):
      %next:2 = waveamdmachine.s_add_i32 %iv, %step :
          (!waveamdmachine.reg<sgpr, 1>, !waveamdmachine.imm) ->
          (!waveamdmachine.reg<sgpr, 1>, !waveamdmachine.reg<scc, 1>)
      waveamdmachine.continue_if %next#1 :
          !waveamdmachine.reg<scc, 1>
          carries(%next#0 : !waveamdmachine.reg<sgpr, 1>)
    } -> !waveamdmachine.reg<sgpr, 1>
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

// COUNTER: issue cycle=0 wave=0 simd=0 fu=LGKM op=waveamdmachine.s_load_b32
// COUNTER-DAG: counter_drained cycle=7 wave=0 simd=0 fu=LGKM counter=lgkm op=waveamdmachine.s_load_b32
// COUNTER-DAG: counter_drained cycle=7 wave=0 simd=0 op=waveamdmachine.s_waitcnt
// COUNTER: issue cycle=20 wave=0 simd=0 fu=SALU op=waveamdmachine.s_add_i32

// LAT: op_latencies:
// LAT: op_index=0 op=waveamdmachine.imm class=NoInst fu=None latency=0 issues=1
// LAT: op_index=2 op=waveamdmachine.s_load_b32 class=WriteSMEM fu=LGKM latency=20 counter_latency=20 issues=1
// LAT: op_index=3 op=waveamdmachine.s_waitcnt class=NoInst fu=None latency=0 issues=1 waitcnt=1
// LAT: op_index=4 op=waveamdmachine.s_add_i32 class=WriteSALU fu=SALU latency=2 issues=1

// WAITPART: issue cycle=0 wave=0 simd=0 fu=LGKM op=waveamdmachine.s_load_b32
// WAITPART: issue cycle=1 wave=0 simd=0 fu=LGKM op=waveamdmachine.s_load_b32
// WAITPART: issue cycle=20 wave=0 simd=0 fu=SALU op=waveamdmachine.s_add_i32
// WAITPART: issue cycle=21 wave=0 simd=0 fu=SALU op=waveamdmachine.s_add_i32

// TRIP: func: trip_loop
// TRIP: trip_count_override: 3
// TRIP: total_cycles: 6
// TRIP: issued_ops: 3
