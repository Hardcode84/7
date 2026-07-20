// RUN: wave-sim-report --waves-per-simd=1 --timeline %s | FileCheck %s

module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx950"} {
  func.func @multi_wave_lds_pair_issue(
      %address: !waveamdmachine.reg<vgpr, 1>) {
    %root = waveamdmachine.token : !waveamdmachine.mem.token
    %value, %token = waveamdmachine.ds_load_b128 %address after %root
        : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.mem.token)
          -> (!waveamdmachine.reg<vgpr, 4>, !waveamdmachine.mem.token)
    return
  }
}

// CHECK-LABEL: func: multi_wave_lds_pair_issue
// CHECK: resident_waves: 4
// CHECK: issued_ops: 4
// CHECK-DAG: issue cycle=0 wave=0 simd=0
// CHECK-DAG: issue cycle=0 wave=2 simd=2
// CHECK-DAG: issue cycle=4 wave=1 simd=1
// CHECK-DAG: issue cycle=4 wave=3 simd=3
