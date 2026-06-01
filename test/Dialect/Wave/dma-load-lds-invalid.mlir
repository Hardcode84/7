// RUN: wave-opt --split-input-file --verify-diagnostics %s

module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx950"} {
func.func @bad_size(%in: !wave.ptr<#wave.global, i32>)
    attributes {wave.kernel, wave.lds_size = 128 : i64} {
  %lane = wave.lane_id : !wave.simd<i32, 32>
  %src = wave.ptr_add %in, %lane
      : !wave.ptr<#wave.global, i32>, !wave.simd<i32, 32>
      -> !wave.simd<!wave.ptr<#wave.global, i32>, 32>
  %lds = wave.lds_base : !wave.ptr<#wave.shared, i32>
  %tok0 = wave.token : !wave.mem.token
  // expected-error @below {{currently supports only bytes = 4 or 16}}
  %tok = waveamd.dma_load_lds %src -> %lds after %tok0 {bytes = 8 : i64}
      : (!wave.simd<!wave.ptr<#wave.global, i32>, 32>,
         !wave.ptr<#wave.shared, i32>, !wave.mem.token) -> !wave.mem.token
  return
}
}

// -----

module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx950"} {
func.func @bad_dest(%in: !wave.ptr<#wave.global, i32>)
    attributes {wave.kernel, wave.lds_size = 128 : i64} {
  %lane = wave.lane_id : !wave.simd<i32, 32>
  %src = wave.ptr_add %in, %lane
      : !wave.ptr<#wave.global, i32>, !wave.simd<i32, 32>
      -> !wave.simd<!wave.ptr<#wave.global, i32>, 32>
  %tok0 = wave.token : !wave.mem.token
  // expected-error @below {{destination pointer must be shared}}
  %tok = waveamd.dma_load_lds %src -> %in after %tok0 {bytes = 4 : i64}
      : (!wave.simd<!wave.ptr<#wave.global, i32>, 32>,
         !wave.ptr<#wave.global, i32>, !wave.mem.token) -> !wave.mem.token
  return
}
}

// -----

func.func @dma_load_lds_source_not_simd(%bad: i32,
                                        %lds: !wave.ptr<#wave.shared, i32>,
                                        %t: !wave.mem.token) {
  // expected-error @below {{source must be a SIMD wave pointer}}
  %tok = waveamd.dma_load_lds %bad -> %lds after %t {bytes = 4 : i64}
      : (i32, !wave.ptr<#wave.shared, i32>, !wave.mem.token) -> !wave.mem.token
  return
}

// -----

func.func @dma_load_lds_source_simd_non_ptr(%bad: !wave.simd<i32, 32>,
                                             %lds: !wave.ptr<#wave.shared, i32>,
                                             %t: !wave.mem.token) {
  // expected-error @below {{source SIMD element type must be a wave pointer}}
  %tok = waveamd.dma_load_lds %bad -> %lds after %t {bytes = 4 : i64}
      : (!wave.simd<i32, 32>, !wave.ptr<#wave.shared, i32>, !wave.mem.token) -> !wave.mem.token
  return
}

// -----

func.func @dma_load_lds_source_shared(%bad: !wave.simd<!wave.ptr<#wave.shared, i32>, 32>,
                                       %lds: !wave.ptr<#wave.shared, i32>,
                                       %t: !wave.mem.token) {
  // expected-error @below {{source pointer must be global or waveamd buffer}}
  %tok = waveamd.dma_load_lds %bad -> %lds after %t {bytes = 4 : i64}
      : (!wave.simd<!wave.ptr<#wave.shared, i32>, 32>,
         !wave.ptr<#wave.shared, i32>, !wave.mem.token) -> !wave.mem.token
  return
}

// -----

func.func @dma_load_lds_dest_element_type(%src: !wave.simd<!wave.ptr<#wave.global, i32>, 32>,
                                           %lds: !wave.ptr<#wave.shared, i64>,
                                           %t: !wave.mem.token) {
  // expected-error @below {{destination pointer element type must be i32}}
  %tok = waveamd.dma_load_lds %src -> %lds after %t {bytes = 4 : i64}
      : (!wave.simd<!wave.ptr<#wave.global, i32>, 32>,
         !wave.ptr<#wave.shared, i64>, !wave.mem.token) -> !wave.mem.token
  return
}

// -----

func.func @make_buffer_base_not_global(%p: !wave.ptr<#wave.shared, i32>, %r: i32) {
  // expected-error @below {{base must be a global wave pointer}}
  %b = waveamd.make_buffer %p, %r : !wave.ptr<#wave.shared, i32>, i32 -> !wave.ptr<#waveamd.buffer, i32>
  return
}

// -----

func.func @make_buffer_result_not_buffer(%p: !wave.ptr<#wave.global, i32>, %r: i32) {
  // expected-error @below {{result must be a waveamd buffer pointer}}
  %b = waveamd.make_buffer %p, %r : !wave.ptr<#wave.global, i32>, i32 -> !wave.ptr<#wave.global, i32>
  return
}

// -----

func.func @make_buffer_element_mismatch(%p: !wave.ptr<#wave.global, i32>, %r: i32) {
  // expected-error @below {{base and result element types must match}}
  %b = waveamd.make_buffer %p, %r : !wave.ptr<#wave.global, i32>, i32 -> !wave.ptr<#waveamd.buffer, i64>
  return
}

// -----

func.func @make_buffer_range_not_i32(%p: !wave.ptr<#wave.global, i32>, %r: i64) {
  // expected-error @below {{range must be i32 bytes}}
  %b = waveamd.make_buffer %p, %r : !wave.ptr<#wave.global, i32>, i64 -> !wave.ptr<#waveamd.buffer, i32>
  return
}

// -----

func.func @fragment_fill_unsupported_wave(%s: i32) {
  // expected-error @below {{fragment wave size must be 32 or 64}}
  %f = waveamd.fragment_fill %s : i32 -> !waveamd.fragment<0, f16, 16, 16, 16, 2>
  return
}

// -----

func.func @fragment_fill_bad_role(%s: i32) {
  // expected-error @below {{fragment role must be 0 (A), 1 (B), or 2 (acc)}}
  %f = waveamd.fragment_fill %s : i32 -> !waveamd.fragment<3, f16, 16, 16, 32, 8>
  return
}

// -----

func.func @fragment_fill_bad_ab_layout(%s: i32) {
  // expected-error @below {{A/B fragments must be i8 fragments with 4 registers or f16 fragments with 2 or 8 registers}}
  %f = waveamd.fragment_fill %s : i32 -> !waveamd.fragment<0, f16, 16, 16, 32, 6>
  return
}

// -----

func.func @fragment_fill_bad_acc_layout(%s: i32) {
  // expected-error @below {{accumulator fragments must be 32-bit fragments with 4 or 8 registers}}
  %f = waveamd.fragment_fill %s : i32 -> !waveamd.fragment<2, f16, 16, 16, 32, 4>
  return
}

// -----

func.func @mma_result_type_mismatch(%a: !waveamd.fragment<0, f16, 16, 16, 32, 8>,
                                     %b: !waveamd.fragment<1, f16, 16, 16, 32, 8>,
                                     %acc: !waveamd.fragment<2, f32, 16, 16, 32, 8>) {
  // expected-error @below {{result type must match accumulator type}}
  %r = waveamd.mma "wmma.f32.16x16x16.f16" %a, %b, %acc
      : !waveamd.fragment<0, f16, 16, 16, 32, 8>,
        !waveamd.fragment<1, f16, 16, 16, 32, 8>,
        !waveamd.fragment<2, f32, 16, 16, 32, 8>
      -> !waveamd.fragment<2, f32, 16, 16, 32, 4>
  return
}
