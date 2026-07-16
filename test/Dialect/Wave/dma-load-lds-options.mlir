// RUN: wave-opt %s | FileCheck %s

module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx950"} {

// CHECK-LABEL: func.func @dma_load_lds_options(
// CHECK: waveamd.dma_load_lds
// CHECK-SAME: issue_delay_cycles = 46 : i64
// CHECK-SAME: issue_delay_overlap_cycles = 33 : i64
// CHECK-SAME: issue_delay_skip_thread_threshold = 256 : i64
func.func @dma_load_lds_options(
    %src: !wave.simd<!wave.ptr<#wave.global, i32>, 64>,
    %lds: !wave.ptr<#wave.shared, i32>,
    %dep: !wave.mem.token) {
  %token = waveamd.dma_load_lds %src -> %lds after %dep
      {bytes = 16 : i64, issue_delay_cycles = 46 : i64,
       issue_delay_overlap_cycles = 33 : i64,
       issue_delay_skip_thread_threshold = 256 : i64}
      : (!wave.simd<!wave.ptr<#wave.global, i32>, 64>,
         !wave.ptr<#wave.shared, i32>, !wave.mem.token) -> !wave.mem.token
  return
}

}
