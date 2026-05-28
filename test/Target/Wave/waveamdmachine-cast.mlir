// RUN: wave-opt --split-input-file --waveamd-to-machine --verify-diagnostics %s | FileCheck %s --check-prefix=SELECT

module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx1100"} {

// SELECT-LABEL: func.func @cast_f32_to_f16_wave32
// SELECT: waveamdmachine.v_cvt_f16_f32 {{.*}} : (!waveamdmachine.reg<vgpr, 1>) -> !waveamdmachine.reg<vgpr, 1>
func.func @cast_f32_to_f16_wave32(%x: !wave.simd<f32, 32>) attributes {wave.kernel} {
  %h = wave.cast fpconvert %x policy {rounding = #wave.cast_rounding<rne>} : !wave.simd<f32, 32> -> !wave.simd<f16, 32>
  return
}

// SELECT-LABEL: func.func @cast_f32_to_f16_wave64
// SELECT: waveamdmachine.v_cvt_f16_f32 {{.*}} : (!waveamdmachine.reg<vgpr, 1>) -> !waveamdmachine.reg<vgpr, 1>
func.func @cast_f32_to_f16_wave64(%x: !wave.simd<f32, 64>) attributes {wave.kernel} {
  %h = wave.cast fpconvert %x : !wave.simd<f32, 64> -> !wave.simd<f16, 64>
  return
}

// SELECT-LABEL: func.func @cast_f16_to_f32_wave32
// SELECT: waveamdmachine.v_cvt_f32_f16 {{.*}} : (!waveamdmachine.reg<vgpr, 1>) -> !waveamdmachine.reg<vgpr, 1>
func.func @cast_f16_to_f32_wave32(%x: !wave.simd<f16, 32>) attributes {wave.kernel} {
  %f = wave.cast fpconvert %x : !wave.simd<f16, 32> -> !wave.simd<f32, 32>
  return
}

}

// -----

module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx1100"} {
func.func @cast_f32_to_f16_unsupported_rounding(%x: !wave.simd<f32, 32>) attributes {wave.kernel} {
  // expected-error @+1 {{WaveAMDMachine fpconvert lowering supports only rne rounding}}
  %h = wave.cast fpconvert %x policy {rounding = #wave.cast_rounding<rtz>} : !wave.simd<f32, 32> -> !wave.simd<f16, 32>
  return
}
}
