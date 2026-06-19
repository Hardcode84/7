// RUN: wave-opt --waveamd-to-machine %s | FileCheck %s

// CHECK-LABEL: func.func @gfx1250_rne_cast_uses_packed
// CHECK: waveamdmachine.v_cvt_pk_f16_f32
// CHECK-NOT: waveamdmachine.v_cvt_f16_f32
module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx1250"} {
func.func @gfx1250_rne_cast_uses_packed(%src: !wave.simd<vector<2xf32>, 32>) {
  %rne = wave.cast fpconvert %src
      : !wave.simd<vector<2xf32>, 32> -> !wave.simd<vector<2xf16>, 32>
  return
}
}

// -----

// CHECK-LABEL: func.func @gfx1200_rne_cast_keeps_scalar
// CHECK-NOT: waveamdmachine.v_cvt_pk_f16_f32
// CHECK: waveamdmachine.v_cvt_f16_f32
module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx1200"} {
func.func @gfx1200_rne_cast_keeps_scalar(%src: !wave.simd<vector<2xf32>, 32>) {
  %rne = wave.cast fpconvert %src
      : !wave.simd<vector<2xf32>, 32> -> !wave.simd<vector<2xf16>, 32>
  return
}
}
