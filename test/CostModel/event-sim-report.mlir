// RUN: wave-sim-report %s | FileCheck %s --check-prefix=ONE
// RUN: wave-sim-report --timeline %s | FileCheck %s --check-prefix=TRACE
// RUN: wave-sim-report --func=smem_wait --timeline %s | FileCheck %s --check-prefix=WAIT
// RUN: wave-sim-report --func=smem_wait --timeline --smem-counter-latency=7 %s | FileCheck %s --check-prefix=COUNTER
// RUN: wave-sim-report --func=smem_wait --op-latencies %s | FileCheck %s --check-prefix=LAT
// RUN: wave-sim-report --func=two_dep_salu --calibration-file=%S/Inputs/calibration-with-overrides.json %s | FileCheck %s --check-prefix=CALIB
// RUN: wave-sim-report --func=two_dep_salu --op-latencies --calibration-file=%S/Inputs/calibration-with-overrides.json %s | FileCheck %s --check-prefix=CALLAT
// RUN: wave-sim-report --func=smem_value_ready --timeline --smem-value-latency=7 %s | FileCheck %s --check-prefix=VALUE
// RUN: wave-sim-report --func=mem_token_issue_ready --timeline %s | FileCheck %s --check-prefix=TOKEN
// RUN: wave-sim-report --func=lds_wait --timeline --lds-counter-latency=7 %s | FileCheck %s --check-prefix=LDSCOUNTER
// RUN: wave-sim-report --func=lds_b16_latency --op-latencies --lds-counter-latency=7 --lds-value-latency=11 --smem-counter-latency=97 --smem-value-latency=101 %s | FileCheck %s --check-prefix=LDSB16LAT
// RUN: wave-sim-report --func=trip_loop --trip-count=3 %s | FileCheck %s --check-prefix=TRIP
// RUN: wave-sim-report --func=trip_loop --trip-count=10000 %s | FileCheck %s --check-prefix=TRIPBIG
// RUN: wave-sim-report --func=wmma_latency --op-latencies %s | FileCheck %s --check-prefix=WMMA
// RUN: wave-sim-report --func=mfma_32x32_latency --op-latencies %s | FileCheck %s --check-prefix=MFMA32
// RUN: wave-sim-report --func=two_independent_valu --wave-size=64 --timeline %s | FileCheck %s --check-prefix=W64
// RUN: wave-sim-report --func=vmem_value_ready --timeline %s | FileCheck %s --check-prefix=VMEMVALUE
// RUN: wave-sim-report --func=uniform_if_report %s | FileCheck %s --check-prefix=UIF
// RUN: wave-sim-report --func=cma_matrix_cap --arch=gfx950 --timeline %s | FileCheck %s --check-prefix=CMA
// RUN: wave-sim-report --func=lds_dma_issue_spacing --arch=gfx950 --timeline %s | FileCheck %s --check-prefix=LDSDMA
// RUN: wave-sim-report --func=issue_token_drops_completion --arch=gfx950 --timeline --vmem-counter-latency=20 %s | FileCheck %s --check-prefix=ISSUETOKEN
// RUN: wave-sim-report --func=token_join_carries_completion --arch=gfx950 --timeline --vmem-counter-latency=20 %s | FileCheck %s --check-prefix=TOKENJOIN
// RUN: wave-sim-report --func=two_dep_salu --waves-per-simd=2 --timeline %s | FileCheck %s --check-prefix=MULTI
// RUN: wave-sim-report --func=lds_dma_issue_spacing --arch=gfx950 --waves-per-simd=2 --timeline %s | FileCheck %s --check-prefix=MULTIDMA
// RUN: wave-sim-report --func=dma_delay_interleave --arch=gfx950 --waves-per-simd=2 --timeline %s | FileCheck %s --check-prefix=DMAMULTI
// RUN: not wave-sim-report --func=trip_loop --waves-per-simd=1 %s 2>&1 | FileCheck %s --check-prefix=MULTIERR
// RUN: not wave-sim-report --func=barrier_report --waves-per-simd=1 %s 2>&1 | FileCheck %s --check-prefix=MULTIBARRIER

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
    waveamdmachine.s_waitcnt lgkmcnt(0)
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

  func.func @issue_token_drops_completion(
      %off: !waveamdmachine.reg<vgpr, 1>,
      %base: !waveamdmachine.reg<sgpr, 2>) {
    %loaded, %loaded_token = waveamdmachine.global_load_b32 %off, %base
        : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<sgpr, 2>)
          -> (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.mem.token)
    %issued = waveamdmachine.issue_token %loaded_token
        : (!waveamdmachine.mem.token) -> !waveamdmachine.mem.token
    waveamdmachine.s_barrier %issued : (!waveamdmachine.mem.token) -> ()
    return
  }

  func.func @token_join_carries_completion(
      %off: !waveamdmachine.reg<vgpr, 1>,
      %base: !waveamdmachine.reg<sgpr, 2>) {
    %loaded, %loaded_token = waveamdmachine.global_load_b32 %off, %base
        : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<sgpr, 2>)
          -> (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.mem.token)
    %joined = waveamdmachine.token_join %loaded_token
        : (!waveamdmachine.mem.token) -> !waveamdmachine.mem.token
    waveamdmachine.s_barrier %joined : (!waveamdmachine.mem.token) -> ()
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
    waveamdmachine.s_waitcnt lgkmcnt(0)
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

  func.func @mfma_32x32_latency(%a: !waveamdmachine.reg<vgpr, 4>,
                                %b: !waveamdmachine.reg<vgpr, 4>,
                                %acc: !waveamdmachine.reg<vgpr, 16>) {
    %result = waveamdmachine.mfma_f32_32x32x16_f16 %a, %b, %acc
        : (!waveamdmachine.reg<vgpr, 4>, !waveamdmachine.reg<vgpr, 4>,
           !waveamdmachine.reg<vgpr, 16>) -> !waveamdmachine.reg<vgpr, 16>
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

  func.func @uniform_if_report(%cond: !waveamdmachine.reg<scc, 1>,
                               %init: !waveamdmachine.reg<sgpr, 1>) {
    %step = waveamdmachine.imm 1 : !waveamdmachine.imm
    waveamdmachine.uniform_if %cond {
      %a:2 = waveamdmachine.s_add_i32 %init, %step :
          (!waveamdmachine.reg<sgpr, 1>, !waveamdmachine.imm) ->
          (!waveamdmachine.reg<sgpr, 1>, !waveamdmachine.reg<scc, 1>)
      waveamdmachine.yield
    } otherwise {
      %b:2 = waveamdmachine.s_add_i32 %init, %step :
          (!waveamdmachine.reg<sgpr, 1>, !waveamdmachine.imm) ->
          (!waveamdmachine.reg<sgpr, 1>, !waveamdmachine.reg<scc, 1>)
      %c:2 = waveamdmachine.s_add_i32 %b#0, %step :
          (!waveamdmachine.reg<sgpr, 1>, !waveamdmachine.imm) ->
          (!waveamdmachine.reg<sgpr, 1>, !waveamdmachine.reg<scc, 1>)
      waveamdmachine.yield
    } : !waveamdmachine.reg<scc, 1>
    return
  }

  func.func @cma_matrix_cap(%a: !waveamdmachine.reg<vgpr, 4>,
                            %b: !waveamdmachine.reg<vgpr, 4>,
                            %acc: !waveamdmachine.reg<vgpr, 4>) {
    %result = waveamdmachine.mfma_f32_16x16x32_f16 %a, %b, %acc
        : (!waveamdmachine.reg<vgpr, 4>, !waveamdmachine.reg<vgpr, 4>,
           !waveamdmachine.reg<vgpr, 4>) -> !waveamdmachine.reg<vgpr, 4>
    return
  }

  func.func @lds_dma_issue_spacing(%off: !waveamdmachine.reg<vgpr, 1>,
                                   %base: !waveamdmachine.reg<sgpr, 2>,
                                   %m0: !waveamdmachine.m0) {
    %root = waveamdmachine.token : !waveamdmachine.mem.token
    %tok0 = waveamdmachine.global_load_lds_b128 %off, %base, %m0 after %root
        : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<sgpr, 2>,
           !waveamdmachine.m0, !waveamdmachine.mem.token)
          -> !waveamdmachine.mem.token
    %tok1 = waveamdmachine.global_load_lds_b128 %off, %base, %m0 after %root
        : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<sgpr, 2>,
           !waveamdmachine.m0, !waveamdmachine.mem.token)
          -> !waveamdmachine.mem.token
    return
  }

  func.func @dma_delay_interleave(
      %m0: !waveamdmachine.m0,
      %value: !waveamdmachine.reg<sgpr, 1>) {
    %dep = waveamdmachine.token : !waveamdmachine.mem.token
    %step = waveamdmachine.imm 1 : !waveamdmachine.imm
    %delayed = waveamdmachine.dma_issue_delay %dep, %m0
        {cycles = 17 : i64}
        : (!waveamdmachine.mem.token, !waveamdmachine.m0)
          -> !waveamdmachine.m0
    %sum:2 = waveamdmachine.s_add_i32 %value, %step :
        (!waveamdmachine.reg<sgpr, 1>, !waveamdmachine.imm) ->
        (!waveamdmachine.reg<sgpr, 1>, !waveamdmachine.reg<scc, 1>)
    return
  }

  func.func @barrier_report() {
    waveamdmachine.s_barrier : () -> ()
    return
  }
}

// ONE: func: two_dep_salu
// ONE: arch: gfx1100
// ONE: total_cycles: 4
// ONE: issued_ops: 2
// ONE: completed: 4

// TRACE: issue cycle=0 fu=SALU op=waveamdmachine.s_add_i32
// TRACE: issue cycle=2 fu=SALU op=waveamdmachine.s_add_i32

// WAIT: func: smem_wait
// WAIT: total_cycles: 22
// WAIT: issued_ops: 2
// WAIT: issue cycle=0 fu=LGKM op=waveamdmachine.s_load_b32
// WAIT: issue cycle=20 fu=SALU op=waveamdmachine.s_add_i32
// WAIT: counter_drained cycle=20 fu=LGKM counter=lgkm op=waveamdmachine.s_load_b32
// WAIT: counter_drained cycle=20 op=waveamdmachine.s_waitcnt

// COUNTER: issue cycle=0 fu=LGKM op=waveamdmachine.s_load_b32
// COUNTER: issue cycle=7 fu=SALU op=waveamdmachine.s_add_i32
// COUNTER-DAG: counter_drained cycle=7 fu=LGKM counter=lgkm op=waveamdmachine.s_load_b32
// COUNTER-DAG: counter_drained cycle=7 op=waveamdmachine.s_waitcnt

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
// VALUE: issue cycle=0 fu=LGKM op=waveamdmachine.s_load_b32
// VALUE: issue cycle=7 fu=SALU op=waveamdmachine.s_add_i32
// VALUE: value_ready cycle=7 fu=LGKM op=waveamdmachine.s_load_b32

// TOKEN: func: mem_token_issue_ready
// TOKEN: issue cycle=0 fu=VMEM op=waveamdmachine.global_load_b32
// TOKEN: issue cycle=320 fu=VMEM op=waveamdmachine.global_store_b32

// LDSCOUNTER: func: lds_wait
// LDSCOUNTER: issue cycle=0 fu=LGKM op=waveamdmachine.ds_store_b32
// LDSCOUNTER-DAG: counter_drained cycle=7 fu=LGKM counter=lgkm op=waveamdmachine.ds_store_b32
// LDSCOUNTER-DAG: counter_drained cycle=7 op=waveamdmachine.s_waitcnt

// LDSB16LAT: op_latencies:
// LDSB16LAT: op_index=0 op=waveamdmachine.ds_load_b16 class=WriteLDS fu=LGKM latency=20 counter_latency=7 value_latency=11 issues=1
// LDSB16LAT: op_index=1 op=waveamdmachine.ds_store_b16 class=WriteLDS fu=LGKM latency=20 counter_latency=7 issues=1

// TRIP: func: trip_loop
// TRIP: trip_count_override: 3
// TRIP: total_cycles: 6
// TRIP: issued_ops: 3

// TRIPBIG: trip_count_override: 10000
// TRIPBIG: total_cycles: 20000
// TRIPBIG: issued_ops: 10000

// WMMA: op_latencies:
// WMMA: op=waveamdmachine.wmma_f32_16x16x16_f16 class=Write16PassWMMA fu=VALU latency=64

// MFMA32: op_latencies:
// MFMA32: op=waveamdmachine.mfma_f32_32x32x16_f16 class=Write8PassMAI fu=MFMA_XDL latency=8

// W64: func: two_independent_valu
// W64: wave_size: 64
// W64: total_cycles: 7
// W64: issue cycle=0 fu=VALU op=waveamdmachine.v_add_u32
// W64: issue cycle=2 fu=VALU op=waveamdmachine.v_add_u32

// VMEMVALUE: func: vmem_value_ready
// VMEMVALUE: issue cycle=0 fu=VMEM op=waveamdmachine.global_load_b32
// VMEMVALUE: issue cycle=320 fu=VALU op=waveamdmachine.v_add_u32
// VMEMVALUE: value_ready cycle=320 fu=VMEM op=waveamdmachine.global_load_b32

// UIF: func: uniform_if_report
// UIF: total_cycles: 4
// UIF: issued_ops: 2

// CMA: func: cma_matrix_cap
// CMA: total_cycles: 4
// CMA: issued_ops: 1
// CMA: issue cycle=0 fu=MFMA_XDL op=waveamdmachine.mfma_f32_16x16x32_f16

// LDSDMA: func: lds_dma_issue_spacing
// LDSDMA: issue cycle=0 fu=VMEM op=waveamdmachine.global_load_lds_b128
// LDSDMA: issue cycle=4 fu=VMEM op=waveamdmachine.global_load_lds_b128

// ISSUETOKEN: func: issue_token_drops_completion
// ISSUETOKEN: total_cycles: 20
// ISSUETOKEN: issue cycle=0 fu=VMEM op=waveamdmachine.global_load_b32
// ISSUETOKEN: issue cycle=4 fu=BRANCH op=waveamdmachine.s_barrier
// ISSUETOKEN: value_ready cycle=4 op=waveamdmachine.issue_token

// TOKENJOIN: func: token_join_carries_completion
// TOKENJOIN: total_cycles: 24
// TOKENJOIN: issue cycle=0 fu=VMEM op=waveamdmachine.global_load_b32
// TOKENJOIN: issue cycle=20 fu=BRANCH op=waveamdmachine.s_barrier
// TOKENJOIN: value_ready cycle=20 op=waveamdmachine.token_join

// MULTI: func: two_dep_salu
// MULTI: waves_per_simd: 2
// MULTI: resident_waves: 4
// MULTI: total_cycles: 5
// MULTI: issued_ops: 8
// MULTI: wave_0_completed: 4
// MULTI: wave_1_completed: 5
// MULTI-DAG: issue cycle=0 wave=0 simd=0 fu=SALU
// MULTI-DAG: issue cycle=0 wave=2 simd=1 fu=SALU
// MULTI-DAG: issue cycle=1 wave=1 simd=0 fu=SALU
// MULTI-DAG: issue cycle=1 wave=3 simd=1 fu=SALU
// MULTI-DAG: issue cycle=2 wave=0 simd=0 fu=SALU
// MULTI-DAG: issue cycle=3 wave=1 simd=0 fu=SALU

// MULTIDMA: waves_per_simd: 2
// MULTIDMA: resident_waves: 8
// MULTIDMA: issued_ops: 16
// MULTIDMA-DAG: issue cycle=0 wave=0 simd=0 fu=VMEM
// MULTIDMA-DAG: issue cycle=0 wave=4 simd=2 fu=VMEM
// MULTIDMA-DAG: issue cycle=4 wave=1 simd=0 fu=VMEM
// MULTIDMA-DAG: issue cycle=4 wave=5 simd=2 fu=VMEM
// MULTIDMA-DAG: issue cycle=16 wave=2 simd=1 fu=VMEM
// MULTIDMA-DAG: issue cycle=16 wave=6 simd=3 fu=VMEM
// MULTIDMA-DAG: issue cycle=28 wave=3 simd=1 fu=VMEM
// MULTIDMA-DAG: issue cycle=28 wave=7 simd=3 fu=VMEM

// DMAMULTI-DAG: issue cycle=0 wave=0 simd=0 fu=SALU op=waveamdmachine.dma_issue_delay
// DMAMULTI-DAG: issue cycle=4 wave=1 simd=0 fu=SALU op=waveamdmachine.dma_issue_delay
// DMAMULTI-DAG: issue cycle=24 wave=0 simd=0 fu=SALU op=waveamdmachine.s_add_i32
// DMAMULTI-DAG: issue cycle=28 wave=1 simd=0 fu=SALU op=waveamdmachine.s_add_i32

// MULTIERR: error: 'waveamdmachine.uniform_loop' op multi-wave event simulation requires linear machine control flow
// MULTIBARRIER: error: 'waveamdmachine.s_barrier' op multi-wave event simulation does not model wave rendezvous
