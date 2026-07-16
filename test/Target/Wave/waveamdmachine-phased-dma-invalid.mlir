// RUN: wave-opt --waveamd-to-machine -split-input-file -verify-diagnostics %s

module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx950"} {
func.func @first_dma_delayed(%in: !wave.ptr<#wave.global, i32>)
    attributes {wave.kernel, wave.lds_size = 2048 : i64,
                wave.workgroup_size = array<i32: 64, 1, 1>} {
  %wi_raw = wave.workitem_id 0 : !wave.simd<i32, 64>
  %wi = wave.assume %wi_raw as "w"
      [#wave.pred<"w >= 0">, #wave.pred<"w <= 63">]
      : !wave.simd<i32, 64>
  %src = wave.ptr_add %in, %wi
      : !wave.ptr<#wave.global, i32>, !wave.simd<i32, 64>
      -> !wave.simd<!wave.ptr<#wave.global, i32>, 64>
  %lds = wave.shared_memory_base : !wave.ptr<#wave.shared, i32>
  %root = wave.token : !wave.mem.token
  // expected-error @below {{issue delay requires a preceding DMA}}
  %dma = waveamd.dma_load_lds %src -> %lds after %root
      {bytes = 16 : i64, issue_delay_cycles = 17 : i64}
      : (!wave.simd<!wave.ptr<#wave.global, i32>, 64>,
         !wave.ptr<#wave.shared, i32>, !wave.mem.token) -> !wave.mem.token
  return
}
}

// -----

module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx950"} {
func.func @misaligned_skip_threshold(%in: !wave.ptr<#wave.global, i32>)
    attributes {wave.kernel, wave.lds_size = 2048 : i64,
                wave.workgroup_size = array<i32: 128, 1, 1>} {
  // expected-error @below {{DMA issue skip threshold must be wave-aligned}}
  %wi_raw = wave.workitem_id 0 : !wave.simd<i32, 64>
  %wi = wave.assume %wi_raw as "w"
      [#wave.pred<"w >= 0">, #wave.pred<"w <= 127">]
      : !wave.simd<i32, 64>
  %src = wave.ptr_add %in, %wi
      : !wave.ptr<#wave.global, i32>, !wave.simd<i32, 64>
      -> !wave.simd<!wave.ptr<#wave.global, i32>, 64>
  %lds = wave.shared_memory_base : !wave.ptr<#wave.shared, i32>
  %root = wave.token : !wave.mem.token
  %first = waveamd.dma_load_lds %src -> %lds after %root {bytes = 16 : i64}
      : (!wave.simd<!wave.ptr<#wave.global, i32>, 64>,
         !wave.ptr<#wave.shared, i32>, !wave.mem.token) -> !wave.mem.token
  %second = waveamd.dma_load_lds %src -> %lds after %root
      {bytes = 16 : i64, issue_delay_cycles = 17 : i64,
       issue_delay_skip_thread_threshold = 96 : i64}
      : (!wave.simd<!wave.ptr<#wave.global, i32>, 64>,
         !wave.ptr<#wave.shared, i32>, !wave.mem.token) -> !wave.mem.token
  return
}
}

// -----

module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx950"} {
func.func @inconsistent_skip_thresholds(%in: !wave.ptr<#wave.global, i32>)
    attributes {wave.kernel, wave.lds_size = 2048 : i64,
                wave.workgroup_size = array<i32: 128, 1, 1>} {
  %wi_raw = wave.workitem_id 0 : !wave.simd<i32, 64>
  %wi = wave.assume %wi_raw as "w"
      [#wave.pred<"w >= 0">, #wave.pred<"w <= 127">]
      : !wave.simd<i32, 64>
  %src = wave.ptr_add %in, %wi
      : !wave.ptr<#wave.global, i32>, !wave.simd<i32, 64>
      -> !wave.simd<!wave.ptr<#wave.global, i32>, 64>
  %lds = wave.shared_memory_base : !wave.ptr<#wave.shared, i32>
  %root = wave.token : !wave.mem.token
  %first = waveamd.dma_load_lds %src -> %lds after %root {bytes = 16 : i64}
      : (!wave.simd<!wave.ptr<#wave.global, i32>, 64>,
         !wave.ptr<#wave.shared, i32>, !wave.mem.token) -> !wave.mem.token
  %second = waveamd.dma_load_lds %src -> %lds after %root
      {bytes = 16 : i64, issue_delay_cycles = 17 : i64,
       issue_delay_skip_thread_threshold = 64 : i64}
      : (!wave.simd<!wave.ptr<#wave.global, i32>, 64>,
         !wave.ptr<#wave.shared, i32>, !wave.mem.token) -> !wave.mem.token
  // expected-error @below {{all DMA issue delays must use one skip threshold}}
  %third = waveamd.dma_load_lds %src -> %lds after %root
      {bytes = 16 : i64, issue_delay_cycles = 17 : i64,
       issue_delay_skip_thread_threshold = 128 : i64}
      : (!wave.simd<!wave.ptr<#wave.global, i32>, 64>,
         !wave.ptr<#wave.shared, i32>, !wave.mem.token) -> !wave.mem.token
  return
}
}
