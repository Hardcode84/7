// RUN: wave-opt --split-input-file --verify-diagnostics %s

module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx950"} {
func.func @bad_size(%in: !wave.ptr<i32, #wave.global>)
    attributes {wave.kernel, wave.lds_size = 128 : i64} {
  %lane = wave.lane_id : !wave.simd<i32, 32>
  %src = wave.ptr_add %in, %lane
      : !wave.ptr<i32, #wave.global>, !wave.simd<i32, 32>
      -> !wave.simd<!wave.ptr<i32, #wave.global>, 32>
  %lds = wave.lds_base : !wave.ptr<i32, #wave.shared>
  %tok0 = wave.token : !wave.mem.token
  // expected-error @below {{currently supports only bytes = 4 or 16}}
  %tok = waveamd.dma_load_lds %src -> %lds after %tok0 {bytes = 8 : i64}
      : (!wave.simd<!wave.ptr<i32, #wave.global>, 32>,
         !wave.ptr<i32, #wave.shared>, !wave.mem.token) -> !wave.mem.token
  return
}
}

// -----

module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx950"} {
func.func @bad_dest(%in: !wave.ptr<i32, #wave.global>)
    attributes {wave.kernel, wave.lds_size = 128 : i64} {
  %lane = wave.lane_id : !wave.simd<i32, 32>
  %src = wave.ptr_add %in, %lane
      : !wave.ptr<i32, #wave.global>, !wave.simd<i32, 32>
      -> !wave.simd<!wave.ptr<i32, #wave.global>, 32>
  %tok0 = wave.token : !wave.mem.token
  // expected-error @below {{destination pointer must be shared}}
  %tok = waveamd.dma_load_lds %src -> %in after %tok0 {bytes = 4 : i64}
      : (!wave.simd<!wave.ptr<i32, #wave.global>, 32>,
         !wave.ptr<i32, #wave.global>, !wave.mem.token) -> !wave.mem.token
  return
}
}
