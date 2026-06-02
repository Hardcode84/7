// RUN: wave-sim-report --waves=1 %s | FileCheck %s --check-prefix=ONE
// RUN: wave-sim-report --waves=2 %s | FileCheck %s --check-prefix=TWO
// RUN: wave-sim-report --waves=2 --timeline %s | FileCheck %s --check-prefix=TRACE
// RUN: wave-sim-report --func=smem_wait --timeline %s | FileCheck %s --check-prefix=WAIT
// RUN: wave-sim-report --func=smem_wait --timeline --smem-counter-latency=7 %s | FileCheck %s --check-prefix=COUNTER
// RUN: wave-sim-report --func=smem_wait --op-latencies %s | FileCheck %s --check-prefix=LAT
// RUN: wave-sim-report --func=two_dep_salu --calibration-file=%S/Inputs/calibration-with-overrides.json %s | FileCheck %s --check-prefix=CALIB
// RUN: wave-sim-report --func=two_dep_salu --op-latencies --calibration-file=%S/Inputs/calibration-with-overrides.json %s | FileCheck %s --check-prefix=CALLAT
// RUN: wave-sim-report --func=smem_value_ready --timeline --smem-value-latency=7 %s | FileCheck %s --check-prefix=VALUE
// RUN: wave-sim-report --func=mem_token_issue_ready --timeline %s | FileCheck %s --check-prefix=TOKEN
// RUN: wave-sim-report --func=lds_wait --timeline --lds-counter-latency=7 %s | FileCheck %s --check-prefix=LDSCOUNTER
// RUN: wave-sim-report --func=lds_b16_latency --op-latencies --lds-counter-latency=7 --lds-value-latency=11 --smem-counter-latency=97 --smem-value-latency=101 %s | FileCheck %s --check-prefix=LDSB16LAT
// RUN: wave-sim-report --func=smem_partial_wait --timeline %s | FileCheck %s --check-prefix=WAITPART
// RUN: wave-sim-report --func=trip_loop --trip-count=3 %s | FileCheck %s --check-prefix=TRIP
// RUN: wave-sim-report --func=trip_loop --trip-count=10000 %s | FileCheck %s --check-prefix=TRIPBIG
// RUN: wave-sim-report --func=wmma_latency --op-latencies %s | FileCheck %s --check-prefix=WMMA
// RUN: wave-sim-report --func=two_independent_valu --wave-size=64 --timeline %s | FileCheck %s --check-prefix=W64
// RUN: wave-sim-report --func=one_salu --waves=8 --simds=8 %s | FileCheck %s --check-prefix=CUCAP
// RUN: wave-sim-report --func=tuple_cu_cap --waves=6 --simds=6 --timeline %s | FileCheck %s --check-prefix=TUPLECU
// RUN: wave-sim-report --func=vmem_value_ready --timeline %s | FileCheck %s --check-prefix=VMEMVALUE

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

  func.func @smem_value_ready() {
    %zero = waveamdmachine.imm 0 : !waveamdmachine.imm
    %step = waveamdmachine.imm 1 : !waveamdmachine.imm
    %load = waveamdmachine.s_load_b32 %zero, "s[0:1]" :
        (!waveamdmachine.imm) -> !waveamdmachine.reg<sgpr, 1>
    %sum:2 = waveamdmachine.s_add_i32 %load, %step :
        (!waveamdmachine.reg<sgpr, 1>, !waveamdmachine.imm) ->
        (!waveamdmachine.reg<sgpr, 1>, !waveamdmachine.reg<scc, 1>)
    return
  }

  func.func @mem_token_issue_ready(%off: !waveamdmachine.reg<vgpr, 1>,
                                   %base: !waveamdmachine.reg<sgpr, 2>,
                                   %value: !waveamdmachine.reg<vgpr, 1>) {
    %tok0 = waveamdmachine.token : !waveamdmachine.mem.token
    %load, %tok1 = waveamdmachine.global_load_b32 %off, %base after %tok0
        : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<sgpr, 2>, !waveamdmachine.mem.token)
          -> (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.mem.token)
    %store = waveamdmachine.global_store_b32 %off, %value, %base after %tok1
        : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>,
           !waveamdmachine.reg<sgpr, 2>, !waveamdmachine.mem.token)
          -> !waveamdmachine.mem.token
    return
  }

  func.func @vmem_value_ready(%off: !waveamdmachine.reg<vgpr, 1>,
                              %base: !waveamdmachine.reg<sgpr, 2>,
                              %value: !waveamdmachine.reg<vgpr, 1>) {
    %tok0 = waveamdmachine.token : !waveamdmachine.mem.token
    %load, %tok1 = waveamdmachine.global_load_b32 %off, %base after %tok0
        : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<sgpr, 2>, !waveamdmachine.mem.token)
          -> (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.mem.token)
    %sum = waveamdmachine.v_add_u32 %load, %value
        : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>)
          -> !waveamdmachine.reg<vgpr, 1>
    return
  }

  func.func @lds_wait(%addr: !waveamdmachine.reg<vgpr, 1>,
                      %value: !waveamdmachine.reg<vgpr, 1>) {
    %zero = waveamdmachine.imm 0 : !waveamdmachine.imm
    %store = waveamdmachine.ds_store_b32 %addr, %value
        : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>)
          -> !waveamdmachine.mem.token
    waveamdmachine.s_waitcnt %zero : (!waveamdmachine.imm) -> ()
    return
  }

  func.func @lds_b16_latency(%addr: !waveamdmachine.reg<vgpr, 1>) {
    %load, %tok = waveamdmachine.ds_load_b16 %addr
        : (!waveamdmachine.reg<vgpr, 1>)
          -> (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.mem.token)
    %store = waveamdmachine.ds_store_b16 %addr, %load after %tok
        : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>,
           !waveamdmachine.mem.token) -> !waveamdmachine.mem.token
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

  func.func @wmma_latency(%a: !waveamdmachine.reg<vgpr, 8>,
                          %b: !waveamdmachine.reg<vgpr, 8>,
                          %acc: !waveamdmachine.reg<vgpr, 8>) {
    %result = waveamdmachine.wmma_f32_16x16x16_f16 %a, %b, %acc
        : (!waveamdmachine.reg<vgpr, 8>, !waveamdmachine.reg<vgpr, 8>,
           !waveamdmachine.reg<vgpr, 8>) -> !waveamdmachine.reg<vgpr, 8>
    return
  }

  func.func @two_independent_valu(%a: !waveamdmachine.reg<vgpr, 1>,
                                  %b: !waveamdmachine.reg<vgpr, 1>,
                                  %c: !waveamdmachine.reg<vgpr, 1>,
                                  %d: !waveamdmachine.reg<vgpr, 1>) {
    %lhs = waveamdmachine.v_add_u32 %a, %b
        : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>)
          -> !waveamdmachine.reg<vgpr, 1>
    %rhs = waveamdmachine.v_add_u32 %c, %d
        : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>)
          -> !waveamdmachine.reg<vgpr, 1>
    return
  }

  func.func @one_salu() {
    %one = waveamdmachine.imm 1 : !waveamdmachine.imm
    %r = waveamdmachine.s_mov_b32_value %one :
        (!waveamdmachine.imm) -> !waveamdmachine.reg<sgpr, 1>
    return
  }

  func.func @tuple_cu_cap(%off: !waveamdmachine.reg<vgpr, 1>,
                          %base: !waveamdmachine.reg<sgpr, 2>) {
    %load, %tok = waveamdmachine.global_load_tuple_b32 %off, %base
        : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<sgpr, 2>)
          -> (!waveamdmachine.reg<vgpr, 16>, !waveamdmachine.mem.token)
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
// LAT: op_index=2 op=waveamdmachine.s_load_b32 class=WriteSMEM fu=LGKM latency=20 counter_latency=20 value_latency=20 issues=1
// LAT: op_index=3 op=waveamdmachine.s_waitcnt class=NoInst fu=None latency=0 issues=1 waitcnt=1
// LAT: op_index=4 op=waveamdmachine.s_add_i32 class=WriteSALU fu=SALU latency=2 issues=1

// CALIB: func: two_dep_salu
// CALIB: total_cycles: 8

// CALLAT: op=waveamdmachine.s_add_i32 class=WriteSALU fu=SALU latency=4

// VALUE: func: smem_value_ready
// VALUE: total_cycles: 9
// VALUE: issue cycle=0 wave=0 simd=0 fu=LGKM op=waveamdmachine.s_load_b32
// VALUE: issue cycle=7 wave=0 simd=0 fu=SALU op=waveamdmachine.s_add_i32
// VALUE: value_ready cycle=7 wave=0 simd=0 fu=LGKM op=waveamdmachine.s_load_b32

// TOKEN: func: mem_token_issue_ready
// TOKEN: issue cycle=0 wave=0 simd=0 fu=VMEM op=waveamdmachine.global_load_b32
// TOKEN: issue cycle=1 wave=0 simd=0 fu=VMEM op=waveamdmachine.global_store_b32

// LDSCOUNTER: func: lds_wait
// LDSCOUNTER: issue cycle=0 wave=0 simd=0 fu=LGKM op=waveamdmachine.ds_store_b32
// LDSCOUNTER-DAG: counter_drained cycle=7 wave=0 simd=0 fu=LGKM counter=lgkm op=waveamdmachine.ds_store_b32
// LDSCOUNTER-DAG: counter_drained cycle=7 wave=0 simd=0 op=waveamdmachine.s_waitcnt

// LDSB16LAT: op_latencies:
// LDSB16LAT: op_index=0 op=waveamdmachine.ds_load_b16 class=WriteLDS fu=LGKM latency=20 counter_latency=7 value_latency=11 issues=1
// LDSB16LAT: op_index=1 op=waveamdmachine.ds_store_b16 class=WriteLDS fu=LGKM latency=20 counter_latency=7 issues=1

// WAITPART: issue cycle=0 wave=0 simd=0 fu=LGKM op=waveamdmachine.s_load_b32
// WAITPART: issue cycle=1 wave=0 simd=0 fu=LGKM op=waveamdmachine.s_load_b32
// WAITPART: issue cycle=20 wave=0 simd=0 fu=SALU op=waveamdmachine.s_add_i32
// WAITPART: issue cycle=21 wave=0 simd=0 fu=SALU op=waveamdmachine.s_add_i32

// TRIP: func: trip_loop
// TRIP: trip_count_override: 3
// TRIP: total_cycles: 6
// TRIP: issued_ops: 3

// TRIPBIG: trip_count_override: 10000
// TRIPBIG: total_cycles: 20000
// TRIPBIG: issued_ops: 10000

// WMMA: op_latencies:
// WMMA: op=waveamdmachine.wmma_f32_16x16x16_f16 class=Write16PassWMMA fu=VALU latency=64

// W64: func: two_independent_valu
// W64: wave_size: 64
// W64: total_cycles: 7
// W64: issue cycle=0 wave=0 simd=0 fu=VALU op=waveamdmachine.v_add_u32
// W64: issue cycle=2 wave=0 simd=0 fu=VALU op=waveamdmachine.v_add_u32

// CUCAP: func: one_salu
// CUCAP: waves: 8
// CUCAP: simds: 8
// CUCAP: total_cycles: 3
// CUCAP: issued_ops: 8

// TUPLECU: issue cycle=0 wave=0 simd=0 fu=VMEM op=waveamdmachine.global_load_tuple_b32
// TUPLECU: issue cycle=0 wave=1 simd=1 fu=VMEM op=waveamdmachine.global_load_tuple_b32
// TUPLECU: issue cycle=0 wave=2 simd=2 fu=VMEM op=waveamdmachine.global_load_tuple_b32
// TUPLECU: issue cycle=0 wave=3 simd=3 fu=VMEM op=waveamdmachine.global_load_tuple_b32
// TUPLECU: issue cycle=0 wave=4 simd=4 fu=VMEM op=waveamdmachine.global_load_tuple_b32
// TUPLECU-NOT: issue cycle=1
// TUPLECU-NOT: issue cycle=2
// TUPLECU-NOT: issue cycle=3
// TUPLECU: issue cycle=4 wave=5 simd=5 fu=VMEM op=waveamdmachine.global_load_tuple_b32

// VMEMVALUE: func: vmem_value_ready
// VMEMVALUE: issue cycle=0 wave=0 simd=0 fu=VMEM op=waveamdmachine.global_load_b32
// VMEMVALUE: issue cycle=80 wave=0 simd=0 fu=VALU op=waveamdmachine.v_add_u32
// VMEMVALUE: value_ready cycle=80 wave=0 simd=0 fu=VMEM op=waveamdmachine.global_load_b32
