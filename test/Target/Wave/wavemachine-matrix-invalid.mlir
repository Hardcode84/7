// RUN: wave-opt -split-input-file -verify-diagnostics %s

func.func @bad_fill_source(%x: i16) {
  // expected-error @below {{source must be an i32 bit pattern}}
  %a = waveamd.fragment_fill %x : i16 -> !waveamd.fragment<0, i8, 16, 16, 32, 4>
  return
}

// -----

func.func @bad_fill_shape(%x: i32) {
  // expected-error @below {{only 16x16 fragments are supported for now}}
  %a = waveamd.fragment_fill %x : i32 -> !waveamd.fragment<0, i8, 8, 16, 32, 4>
  return
}

// -----

func.func @bad_mma_kind(%x: i32) {
  %a = waveamd.fragment_fill %x : i32 -> !waveamd.fragment<0, i8, 16, 16, 32, 4>
  %b = waveamd.fragment_fill %x : i32 -> !waveamd.fragment<1, i8, 16, 16, 32, 4>
  %acc = waveamd.fragment_fill %x : i32 -> !waveamd.fragment<2, i32, 16, 16, 32, 8>
  // expected-error @below {{unsupported matrix operation kind}}
  %result = waveamd.mma "wmma.f32.16x16x32.f16" %a, %b, %acc : !waveamd.fragment<0, i8, 16, 16, 32, 4>, !waveamd.fragment<1, i8, 16, 16, 32, 4>, !waveamd.fragment<2, i32, 16, 16, 32, 8> -> !waveamd.fragment<2, i32, 16, 16, 32, 8>
  return
}

// -----

func.func @bad_mma_b_role(%x: i32) {
  %a = waveamd.fragment_fill %x : i32 -> !waveamd.fragment<0, i8, 16, 16, 32, 4>
  %bad_b = waveamd.fragment_fill %x : i32 -> !waveamd.fragment<0, i8, 16, 16, 32, 4>
  %acc = waveamd.fragment_fill %x : i32 -> !waveamd.fragment<2, i32, 16, 16, 32, 8>
  // expected-error @below {{B operand must be a 16x16 i8 wave32 fragment with 4 registers}}
  %result = waveamd.mma "wmma.i32.16x16x16.iu8" %a, %bad_b, %acc : !waveamd.fragment<0, i8, 16, 16, 32, 4>, !waveamd.fragment<0, i8, 16, 16, 32, 4>, !waveamd.fragment<2, i32, 16, 16, 32, 8> -> !waveamd.fragment<2, i32, 16, 16, 32, 8>
  return
}

// -----

func.func @bad_fragment_store_pointer(%out: !wave.ptr<index, #wave.global>, %x: i32) {
  %base = arith.constant 0 : index
  %ptr = wave.ptr_add %out, %base : !wave.ptr<index, #wave.global>, index -> !wave.ptr<index, #wave.global>
  %acc = waveamd.fragment_fill %x : i32 -> !waveamd.fragment<2, i32, 16, 16, 32, 8>
  // expected-error @below {{fragment stores currently require a 32-bit pointer}}
  %store_token = waveamd.fragment_store %acc -> %ptr : (!waveamd.fragment<2, i32, 16, 16, 32, 8>, !wave.ptr<index, #wave.global>) -> !wave.mem.token
  return
}

// -----

func.func @fragment_pack_bad_width(%v: !wave.simd<vector<8xi32>, 64>) {
  // expected-error @below {{operand SIMD width must match fragment wave size}}
  %frag = waveamd.fragment_pack %v : !wave.simd<vector<8xi32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 32, 8>
  return
}

// -----

func.func @fragment_pack_not_vector(%v: !wave.simd<i32, 32>) {
  // expected-error @below {{operand SIMD element type must be a 1-D vector}}
  %frag = waveamd.fragment_pack %v : !wave.simd<i32, 32> -> !waveamd.fragment<2, f32, 16, 16, 32, 8>
  return
}

// -----

func.func @fragment_pack_bad_vector_element(%v: !wave.simd<vector<16xf16>, 32>) {
  // expected-error @below {{operand vector element type must be 32 bits wide}}
  %frag = waveamd.fragment_pack %v : !wave.simd<vector<16xf16>, 32> -> !waveamd.fragment<2, f32, 16, 16, 32, 8>
  return
}

// -----

func.func @fragment_pack_register_mismatch(%v: !wave.simd<vector<4xi32>, 32>) {
  // expected-error @below {{operand vector element count (4) must match fragment register count (8)}}
  %frag = waveamd.fragment_pack %v : !wave.simd<vector<4xi32>, 32> -> !waveamd.fragment<2, f32, 16, 16, 32, 8>
  return
}
