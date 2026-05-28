// RUN: wave-opt %s --wave-form-packed-math --waveamd-to-machine | FileCheck %s

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
