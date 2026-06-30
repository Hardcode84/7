// RUN: wave-opt --waveamd-to-machine %s | FileCheck %s --check-prefix=SELECT
// RUN: wave-opt --waveamd-to-machine %s | wave-opt | FileCheck %s --check-prefix=SELECT

module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx950"} {

// SELECT-LABEL: func.func @packed_wave_bf16_cast_v4
// SELECT-COUNT-2: waveamdmachine.v_cvt_pk_bf16_f32
func.func @packed_wave_bf16_cast_v4(%src: !wave.simd<vector<4xf32>, 64>) {
  %bf16 = wave.cast fpconvert %src
      : !wave.simd<vector<4xf32>, 64> -> !wave.simd<vector<4xbf16>, 64>
  return
}

// SELECT-LABEL: func.func @packed_wave_bf16_cast_v1
// SELECT: waveamdmachine.v_cvt_pk_bf16_f32
func.func @packed_wave_bf16_cast_v1(%src: !wave.simd<vector<1xf32>, 64>) {
  %bf16 = wave.cast fpconvert %src
      : !wave.simd<vector<1xf32>, 64> -> !wave.simd<vector<1xbf16>, 64>
  return
}

}
