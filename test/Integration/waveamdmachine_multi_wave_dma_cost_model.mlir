// RUN: wave-sim-report --waves-per-simd=1 --timeline %s | FileCheck %s --check-prefix=ONE
// RUN: wave-sim-report --waves-per-simd=2 --timeline %s | FileCheck %s --check-prefix=TWO

module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx950"} {
  func.func @multi_wave_dma_pair_issue(
      %off: !waveamdmachine.reg<vgpr, 1>,
      %base: !waveamdmachine.reg<sgpr, 2>,
      %m0: !waveamdmachine.m0) {
    %root = waveamdmachine.token : !waveamdmachine.mem.token
    %first = waveamdmachine.global_load_lds_b128
        %off, %base, %m0 after %root
        : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<sgpr, 2>,
           !waveamdmachine.m0, !waveamdmachine.mem.token)
          -> !waveamdmachine.mem.token
    %second = waveamdmachine.global_load_lds_b128
        %off, %base, %m0 after %root
        : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<sgpr, 2>,
           !waveamdmachine.m0, !waveamdmachine.mem.token)
          -> !waveamdmachine.mem.token
    return
  }
}

// ONE-LABEL: func: multi_wave_dma_pair_issue
// ONE: waves_per_simd: 1
// ONE: resident_waves: 4
// ONE: total_cycles: 92
// ONE: issued_ops: 8
// ONE-DAG: wave_0_completed: 84
// ONE-DAG: wave_1_completed: 92
// ONE-DAG: wave_2_completed: 84
// ONE-DAG: wave_3_completed: 92
// ONE-DAG: issue cycle=0 wave=0 simd=0
// ONE-DAG: issue cycle=0 wave=2 simd=2
// ONE-DAG: issue cycle=4 wave=0 simd=0
// ONE-DAG: issue cycle=4 wave=2 simd=2
// ONE-DAG: issue cycle=8 wave=1 simd=1
// ONE-DAG: issue cycle=8 wave=3 simd=3
// ONE-DAG: issue cycle=12 wave=1 simd=1
// ONE-DAG: issue cycle=12 wave=3 simd=3

// TWO-LABEL: func: multi_wave_dma_pair_issue
// TWO: waves_per_simd: 2
// TWO: resident_waves: 8
// TWO: total_cycles: 108
// TWO: issued_ops: 16
// TWO-DAG: issue cycle=0 wave=0 simd=0
// TWO-DAG: issue cycle=0 wave=4 simd=2
// TWO-DAG: issue cycle=4 wave=1 simd=0
// TWO-DAG: issue cycle=4 wave=5 simd=2
// TWO-DAG: issue cycle=16 wave=2 simd=1
// TWO-DAG: issue cycle=16 wave=6 simd=3
// TWO-DAG: issue cycle=28 wave=3 simd=1
// TWO-DAG: issue cycle=28 wave=7 simd=3
