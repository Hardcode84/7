// RUN: wave-opt %s --split-input-file --wave-form-packed-math --waveamd-to-machine | FileCheck %s

module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx1100"} {

// CHECK-LABEL: func.func @formed_cast
// CHECK: waveamdmachine.tuple_from_elements
// CHECK: waveamdmachine.v_cvt_pk_rtz_f16_f32
// CHECK: waveamdmachine.v_and_b32
// CHECK: waveamdmachine.v_lshrrev_b32
func.func @formed_cast(%a: !wave.simd<f32, 32>, %b: !wave.simd<f32, 32>)
    -> f32 {
  %x = wave.cast fpconvert %a policy {rounding = #wave.cast_rounding<rtz>}
      : !wave.simd<f32, 32> -> !wave.simd<f16, 32>
  %y = wave.cast fpconvert %b policy {rounding = #wave.cast_rounding<rtz>}
      : !wave.simd<f32, 32> -> !wave.simd<f16, 32>
  %xf = wave.cast fpconvert %x
      : !wave.simd<f16, 32> -> !wave.simd<f32, 32>
  %yf = wave.cast fpconvert %y
      : !wave.simd<f16, 32> -> !wave.simd<f32, 32>
  %rx = wave.read_first %xf : !wave.simd<f32, 32> -> f32
  %ry = wave.read_first %yf : !wave.simd<f32, 32> -> f32
  return %rx : f32
}

// CHECK-LABEL: func.func @formed_f16_add
// CHECK: waveamdmachine.v_lshlrev_b32
// CHECK: waveamdmachine.v_or_b32
// CHECK: waveamdmachine.v_pk_add_f16
// CHECK: waveamdmachine.v_lshrrev_b32
func.func @formed_f16_add(%a0: !wave.simd<f16, 32>,
                          %a1: !wave.simd<f16, 32>,
                          %b0: !wave.simd<f16, 32>,
                          %b1: !wave.simd<f16, 32>) -> f32 {
  %s0 = wave.fadd %a0, %b0
      : !wave.simd<f16, 32>, !wave.simd<f16, 32> -> !wave.simd<f16, 32>
  %s1 = wave.fadd %a1, %b1
      : !wave.simd<f16, 32>, !wave.simd<f16, 32> -> !wave.simd<f16, 32>
  %f0 = wave.cast fpconvert %s0
      : !wave.simd<f16, 32> -> !wave.simd<f32, 32>
  %f1 = wave.cast fpconvert %s1
      : !wave.simd<f16, 32> -> !wave.simd<f32, 32>
  %r0 = wave.read_first %f0 : !wave.simd<f32, 32> -> f32
  %r1 = wave.read_first %f1 : !wave.simd<f32, 32> -> f32
  return %r0 : f32
}

}

// -----

module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx950"} {

// CHECK-LABEL: func.func @gfx950_rne_cast_pair_reused_by_pack
// CHECK: waveamdmachine.v_cvt_pk_f16_f32
// CHECK-NOT: waveamdmachine.v_cvt_f16_f32
// CHECK-NOT: waveamdmachine.v_lshrrev_b32
// CHECK: return
func.func @gfx950_rne_cast_pair_reused_by_pack(%a: !wave.simd<f32, 64>,
                                               %b: !wave.simd<f32, 64>)
    -> !wave.simd<vector<2xf16>, 64> {
  %x = wave.cast fpconvert %a
      : !wave.simd<f32, 64> -> !wave.simd<f16, 64>
  %y = wave.cast fpconvert %b
      : !wave.simd<f32, 64> -> !wave.simd<f16, 64>
  %packed = wave.pack %x, %y
      : !wave.simd<f16, 64>, !wave.simd<f16, 64>
      -> !wave.simd<vector<2xf16>, 64>
  return %packed : !wave.simd<vector<2xf16>, 64>
}

// CHECK-LABEL: func.func @gfx950_rne_cast_quad_reused_by_pack
// CHECK-COUNT-2: waveamdmachine.v_cvt_pk_f16_f32
// CHECK-NOT: waveamdmachine.v_cvt_f16_f32
// CHECK-NOT: waveamdmachine.v_lshrrev_b32
// CHECK-NOT: waveamdmachine.v_lshlrev_b32
// CHECK-NOT: waveamdmachine.v_or_b32
// CHECK: return
func.func @gfx950_rne_cast_quad_reused_by_pack(
    %a: !wave.simd<f32, 64>, %b: !wave.simd<f32, 64>,
    %c: !wave.simd<f32, 64>, %d: !wave.simd<f32, 64>)
    -> !wave.simd<vector<4xf16>, 64> {
  %x = wave.cast fpconvert %a
      : !wave.simd<f32, 64> -> !wave.simd<f16, 64>
  %y = wave.cast fpconvert %b
      : !wave.simd<f32, 64> -> !wave.simd<f16, 64>
  %z = wave.cast fpconvert %c
      : !wave.simd<f32, 64> -> !wave.simd<f16, 64>
  %w = wave.cast fpconvert %d
      : !wave.simd<f32, 64> -> !wave.simd<f16, 64>
  %packed = wave.pack %x, %y, %z, %w
      : !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64>,
        !wave.simd<f16, 64> -> !wave.simd<vector<4xf16>, 64>
  return %packed : !wave.simd<vector<4xf16>, 64>
}

// CHECK-LABEL: func.func @gfx950_f16_math_forms_rne_cvt
// CHECK-COUNT-2: waveamdmachine.v_cvt_pk_f16_f32
// CHECK: waveamdmachine.v_pk_add_f16
// CHECK: waveamdmachine.v_cvt_f32_f16
// CHECK: return
func.func @gfx950_f16_math_forms_rne_cvt(%a0: !wave.simd<f32, 64>,
                                         %a1: !wave.simd<f32, 64>,
                                         %b0: !wave.simd<f32, 64>,
                                         %b1: !wave.simd<f32, 64>) -> f32 {
  %x0 = wave.cast fpconvert %a0
      : !wave.simd<f32, 64> -> !wave.simd<f16, 64>
  %x1 = wave.cast fpconvert %a1
      : !wave.simd<f32, 64> -> !wave.simd<f16, 64>
  %y0 = wave.cast fpconvert %b0
      : !wave.simd<f32, 64> -> !wave.simd<f16, 64>
  %y1 = wave.cast fpconvert %b1
      : !wave.simd<f32, 64> -> !wave.simd<f16, 64>
  %s0 = wave.fadd %x0, %y0
      : !wave.simd<f16, 64>, !wave.simd<f16, 64> -> !wave.simd<f16, 64>
  %s1 = wave.fadd %x1, %y1
      : !wave.simd<f16, 64>, !wave.simd<f16, 64> -> !wave.simd<f16, 64>
  %f0 = wave.cast fpconvert %s0
      : !wave.simd<f16, 64> -> !wave.simd<f32, 64>
  %f1 = wave.cast fpconvert %s1
      : !wave.simd<f16, 64> -> !wave.simd<f32, 64>
  %r0 = wave.read_first %f0 : !wave.simd<f32, 64> -> f32
  %r1 = wave.read_first %f1 : !wave.simd<f32, 64> -> f32
  return %r0 : f32
}

// CHECK-LABEL: func.func @gfx950_f32_math_forms
// CHECK: waveamdmachine.v_pk_add_f32
// CHECK: waveamdmachine.v_pk_mul_f32
// CHECK: return
func.func @gfx950_f32_math_forms(%a0: !wave.simd<f32, 64>,
                                 %a1: !wave.simd<f32, 64>,
                                 %b0: !wave.simd<f32, 64>,
                                 %b1: !wave.simd<f32, 64>) -> f32 {
  %s0 = wave.fadd %a0, %b0
      : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
  %s1 = wave.fadd %a1, %b1
      : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
  %m0 = wave.fmul %s0, %b0
      : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
  %m1 = wave.fmul %s1, %b1
      : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
  %r0 = wave.read_first %m0 : !wave.simd<f32, 64> -> f32
  %r1 = wave.read_first %m1 : !wave.simd<f32, 64> -> f32
  return %r0 : f32
}

}
