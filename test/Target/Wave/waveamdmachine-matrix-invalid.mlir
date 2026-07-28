// RUN: wave-opt -split-input-file -verify-diagnostics %s

func.func @bad_fill_source(%x: i16) {
  // expected-error @below {{source must be an i32 bit pattern}}
  %a = waveamd.fragment_fill %x : i16 -> !waveamd.fragment<0, i8, 16, 16, 32, 4>
  return
}

// -----

func.func @bad_fill_shape(%x: i32) {
  // expected-error @below {{only 16x16 and wave64 32x32 fragments are supported}}
  %a = waveamd.fragment_fill %x : i32 -> !waveamd.fragment<0, i8, 8, 16, 32, 4>
  return
}

// -----

func.func @bad_mma_kind(%x: i32) {
  %a = waveamd.fragment_fill %x : i32 -> !waveamd.fragment<0, i8, 16, 16, 32, 4>
  %b = waveamd.fragment_fill %x : i32 -> !waveamd.fragment<1, i8, 16, 16, 32, 4>
  %acc = waveamd.fragment_fill %x : i32 -> !waveamd.fragment<2, i32, 16, 16, 32, 8>
  // expected-error @below {{unsupported matrix operation kind}}
  %result = waveamd.mma "wmma.f32.8x8x8.f16" %a, %b, %acc : !waveamd.fragment<0, i8, 16, 16, 32, 4>, !waveamd.fragment<1, i8, 16, 16, 32, 4>, !waveamd.fragment<2, i32, 16, 16, 32, 8> -> !waveamd.fragment<2, i32, 16, 16, 32, 8>
  return
}

// -----

func.func @bad_gfx1250_wmma_a_payload(%x: i32) {
  %a = waveamd.fragment_fill %x
      : i32 -> !waveamd.fragment<0, f16, 16, 16, 32, 4>
  %b = waveamd.fragment_fill %x
      : i32 -> !waveamd.fragment<1, f16, 16, 16, 32, 8>
  %acc = waveamd.fragment_fill %x
      : i32 -> !waveamd.fragment<2, f32, 16, 16, 32, 8>
  // expected-error @below {{A operand must be a 16x16 wave32 fragment carrying 16 f16 elements}}
  %result = waveamd.mma "wmma.f32.16x16x32.f16" %a, %b, %acc
      : !waveamd.fragment<0, f16, 16, 16, 32, 4>,
        !waveamd.fragment<1, f16, 16, 16, 32, 8>,
        !waveamd.fragment<2, f32, 16, 16, 32, 8>
     -> !waveamd.fragment<2, f32, 16, 16, 32, 8>
  return
}

// -----

func.func @bad_gfx1250_wmma_acc_payload(%x: i32) {
  %a = waveamd.fragment_fill %x
      : i32 -> !waveamd.fragment<0, bf16, 16, 16, 32, 8>
  %b = waveamd.fragment_fill %x
      : i32 -> !waveamd.fragment<1, bf16, 16, 16, 32, 8>
  %acc = waveamd.fragment_fill %x
      : i32 -> !waveamd.fragment<2, f32, 16, 16, 32, 4>
  // expected-error @below {{accumulator must be a 16x16 wave32 fragment carrying 8 f32 elements}}
  %result = waveamd.mma "wmma.f32.16x16x32.bf16" %a, %b, %acc
      : !waveamd.fragment<0, bf16, 16, 16, 32, 8>,
        !waveamd.fragment<1, bf16, 16, 16, 32, 8>,
        !waveamd.fragment<2, f32, 16, 16, 32, 4>
     -> !waveamd.fragment<2, f32, 16, 16, 32, 4>
  return
}

// -----

func.func @bad_mma_scale_kind(%x: i32) {
  %scale = wave.splat %x : i32 -> !wave.simd<i32, 64>
  %a = waveamd.fragment_fill %x : i32 -> !waveamd.fragment<0, i8, 16, 16, 64, 4>
  %b = waveamd.fragment_fill %x : i32 -> !waveamd.fragment<1, i8, 16, 16, 64, 4>
  %acc = waveamd.fragment_fill %x : i32 -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
  // expected-error @below {{unsupported scaled matrix operation kind}}
  %result = waveamd.mma_scale "mfma.scale.f32.16x16x128.f6.f4" %a, %scale, %b, %scale, %acc : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<i32, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<i32, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
  return
}

// -----

func.func @bad_mma_scale_a_fragment(%x: i32) {
  %scale = wave.splat %x : i32 -> !wave.simd<i32, 64>
  %bad_a = waveamd.fragment_fill %x : i32 -> !waveamd.fragment<1, i8, 16, 16, 64, 4>
  %b = waveamd.fragment_fill %x : i32 -> !waveamd.fragment<1, i8, 16, 16, 64, 4>
  %acc = waveamd.fragment_fill %x : i32 -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
  // expected-error @below {{A operand must be a 16x16 packed-f4 wave64 fragment with 4 registers}}
  %result = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %bad_a, %scale, %b, %scale, %acc : !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<i32, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<i32, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
  return
}

// -----

func.func @bad_mma_scale_b_fragment(%x: i32) {
  %scale = wave.splat %x : i32 -> !wave.simd<i32, 64>
  %a = waveamd.fragment_fill %x : i32 -> !waveamd.fragment<0, i8, 16, 16, 64, 4>
  %bad_b = waveamd.fragment_fill %x : i32 -> !waveamd.fragment<0, i8, 16, 16, 64, 4>
  %acc = waveamd.fragment_fill %x : i32 -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
  // expected-error @below {{B operand must be a 16x16 packed-f4 wave64 fragment with 4 registers}}
  %result = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %a, %scale, %bad_b, %scale, %acc : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<i32, 64>, !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<i32, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
  return
}

// -----

func.func @bad_mma_scale_acc(%x: i32) {
  %scale = wave.splat %x : i32 -> !wave.simd<i32, 64>
  %a = waveamd.fragment_fill %x : i32 -> !waveamd.fragment<0, i8, 16, 16, 64, 4>
  %b = waveamd.fragment_fill %x : i32 -> !waveamd.fragment<1, i8, 16, 16, 64, 4>
  %acc = waveamd.fragment_fill %x : i32 -> !waveamd.fragment<2, i32, 16, 16, 64, 4>
  // expected-error @below {{accumulator must be a 16x16 f32 wave64 fragment with 4 registers}}
  %result = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %a, %scale, %b, %scale, %acc : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<i32, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<i32, 64>, !waveamd.fragment<2, i32, 16, 16, 64, 4> -> !waveamd.fragment<2, i32, 16, 16, 64, 4>
  return
}

// -----

func.func @bad_mma_scale_result(%x: i32) {
  %scale = wave.splat %x : i32 -> !wave.simd<i32, 64>
  %a = waveamd.fragment_fill %x : i32 -> !waveamd.fragment<0, i8, 16, 16, 64, 4>
  %b = waveamd.fragment_fill %x : i32 -> !waveamd.fragment<1, i8, 16, 16, 64, 4>
  %acc = waveamd.fragment_fill %x : i32 -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
  // expected-error @below {{result type must match accumulator type}}
  %result = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %a, %scale, %b, %scale, %acc : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<i32, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<i32, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 2>
  return
}

// -----

func.func @bad_mma_scale_a_scale(%x: i32) {
  %scale = wave.splat %x : i32 -> !wave.simd<i32, 64>
  %bad_scale = wave.splat %x : i32 -> !wave.simd<i32, 32>
  %a = waveamd.fragment_fill %x : i32 -> !waveamd.fragment<0, i8, 16, 16, 64, 4>
  %b = waveamd.fragment_fill %x : i32 -> !waveamd.fragment<1, i8, 16, 16, 64, 4>
  %acc = waveamd.fragment_fill %x : i32 -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
  // expected-error @below {{A scale must be !wave.simd<i32, 64>}}
  %result = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %a, %bad_scale, %b, %scale, %acc : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<i32, 32>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<i32, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
  return
}

// -----

func.func @bad_mma_scale_b_scale(%x: i32) {
  %scale = wave.splat %x : i32 -> !wave.simd<i32, 64>
  %bad_scale = wave.splat %x : i32 -> !wave.simd<i32, 32>
  %a = waveamd.fragment_fill %x : i32 -> !waveamd.fragment<0, i8, 16, 16, 64, 4>
  %b = waveamd.fragment_fill %x : i32 -> !waveamd.fragment<1, i8, 16, 16, 64, 4>
  %acc = waveamd.fragment_fill %x : i32 -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
  // expected-error @below {{B scale must be !wave.simd<i32, 64>}}
  %result = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %a, %scale, %b, %bad_scale, %acc : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<i32, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<i32, 32>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
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

func.func @bad_mfma_mixed_wave_sizes(%x: i32) {
  %a = waveamd.fragment_fill %x : i32 -> !waveamd.fragment<0, f16, 16, 16, 32, 2>
  %b = waveamd.fragment_fill %x : i32 -> !waveamd.fragment<1, f16, 16, 16, 64, 2>
  %acc = waveamd.fragment_fill %x : i32 -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
  // expected-error @below {{operand/result fragment wave sizes must match}}
  %result = waveamd.mma "mfma.f32.16x16x16.f16" %a, %b, %acc : !waveamd.fragment<0, f16, 16, 16, 32, 2>, !waveamd.fragment<1, f16, 16, 16, 64, 2>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
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

func.func @fragment_pack_bad_vector_element_type(%v: !wave.simd<vector<8xindex>, 32>) {
  // expected-error @below {{operand vector element type must be int or float}}
  %frag = waveamd.fragment_pack %v : !wave.simd<vector<8xindex>, 32> -> !waveamd.fragment<2, f32, 16, 16, 32, 8>
  return
}

// -----

func.func @fragment_pack_bad_vector_payload(%v: !wave.simd<vector<15xf16>, 32>) {
  // expected-error @below {{operand vector payload bit width (240) must match fragment register payload bit width (256)}}
  %frag = waveamd.fragment_pack %v : !wave.simd<vector<15xf16>, 32> -> !waveamd.fragment<2, f32, 16, 16, 32, 8>
  return
}

// -----

func.func @fragment_pack_bad_vector_element_width(%v: !wave.simd<vector<8xi24>, 32>) {
  // expected-error @below {{operand vector element bit width must be 4, 8, 16, or 32}}
  %frag = waveamd.fragment_pack %v : !wave.simd<vector<8xi24>, 32> -> !waveamd.fragment<2, f32, 16, 16, 32, 6>
  return
}

// -----

func.func @fragment_pack_register_mismatch(%v: !wave.simd<vector<4xi32>, 32>) {
  // expected-error @below {{operand vector payload bit width (128) must match fragment register payload bit width (256)}}
  %frag = waveamd.fragment_pack %v : !wave.simd<vector<4xi32>, 32> -> !waveamd.fragment<2, f32, 16, 16, 32, 8>
  return
}

// -----

func.func @fragment_unpack_bad_width(%f: !waveamd.fragment<2, f32, 16, 16, 32, 8>) {
  // expected-error @below {{result SIMD width must match fragment wave size}}
  %v = waveamd.fragment_unpack %f : !waveamd.fragment<2, f32, 16, 16, 32, 8> -> !wave.simd<vector<8xi32>, 64>
  return
}

// -----

func.func @fragment_unpack_not_vector(%f: !waveamd.fragment<2, f32, 16, 16, 32, 8>) {
  // expected-error @below {{result SIMD element type must be a 1-D vector}}
  %v = waveamd.fragment_unpack %f : !waveamd.fragment<2, f32, 16, 16, 32, 8> -> !wave.simd<i32, 32>
  return
}

// -----

func.func @fragment_unpack_bad_vector_element(%f: !waveamd.fragment<2, f32, 16, 16, 32, 8>) {
  // expected-error @below {{result vector element type must be 32 bits wide}}
  %v = waveamd.fragment_unpack %f : !waveamd.fragment<2, f32, 16, 16, 32, 8> -> !wave.simd<vector<8xi16>, 32>
  return
}

// -----

func.func @fragment_unpack_register_mismatch(%f: !waveamd.fragment<2, f32, 16, 16, 32, 8>) {
  // expected-error @below {{result vector element count (4) must match fragment register count (8)}}
  %v = waveamd.fragment_unpack %f : !waveamd.fragment<2, f32, 16, 16, 32, 8> -> !wave.simd<vector<4xi32>, 32>
  return
}
