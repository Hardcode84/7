// RUN: wave-sim-report --waves-per-simd=2 --timeline %s | FileCheck %s

module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx1100"} {
  func.func @multi_wave_model(%init: !waveamdmachine.reg<sgpr, 1>) {
    %step = waveamdmachine.imm 1 : !waveamdmachine.imm
    %a:2 = waveamdmachine.s_add_i32 %init, %step :
        (!waveamdmachine.reg<sgpr, 1>, !waveamdmachine.imm) ->
        (!waveamdmachine.reg<sgpr, 1>, !waveamdmachine.reg<scc, 1>)
    %b:2 = waveamdmachine.s_add_i32 %a#0, %step :
        (!waveamdmachine.reg<sgpr, 1>, !waveamdmachine.imm) ->
        (!waveamdmachine.reg<sgpr, 1>, !waveamdmachine.reg<scc, 1>)
    return
  }
}

// CHECK: waves_per_simd: 2
// CHECK: resident_waves: 4
// CHECK: total_cycles: 5
// CHECK: issued_ops: 8
// CHECK-DAG: issue cycle=0 wave=0 simd=0 fu=SALU
// CHECK-DAG: issue cycle=0 wave=2 simd=1 fu=SALU
// CHECK-DAG: issue cycle=1 wave=1 simd=0 fu=SALU
// CHECK-DAG: issue cycle=1 wave=3 simd=1 fu=SALU
