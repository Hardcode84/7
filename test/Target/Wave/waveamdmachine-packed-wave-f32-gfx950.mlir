// RUN: wave-opt --waveamd-to-machine %s | FileCheck %s --check-prefix=SELECT
// RUN: wave-opt --waveamd-to-machine %s | wave-opt | FileCheck %s --check-prefix=SELECT

module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx950"} {

// SELECT-LABEL: func.func @packed_wave_f32_math_v4
// SELECT-COUNT-2: waveamdmachine.v_pk_add_f32
// SELECT-COUNT-2: waveamdmachine.v_pk_mul_f32
// SELECT-COUNT-2: waveamdmachine.v_pk_fma_f32
func.func @packed_wave_f32_math_v4(%a: !wave.simd<vector<4xf32>, 64>,
                                   %b: !wave.simd<vector<4xf32>, 64>,
                                   %c: !wave.simd<vector<4xf32>, 64>) {
  %add = wave.fadd %a, %b
      : !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64>
      -> !wave.simd<vector<4xf32>, 64>
  %mul = wave.fmul %add, %b
      : !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64>
      -> !wave.simd<vector<4xf32>, 64>
  %fma = wave.fma %mul, %add, %c
      : !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64>,
        !wave.simd<vector<4xf32>, 64> -> !wave.simd<vector<4xf32>, 64>
  return
}

// SELECT-LABEL: func.func @packed_wave_f32_math_v2
// SELECT: waveamdmachine.v_pk_add_f32
// SELECT: waveamdmachine.v_pk_mul_f32 {{.*}}contract = true
func.func @packed_wave_f32_math_v2(%a: !wave.simd<vector<2xf32>, 64>,
                                   %b: !wave.simd<vector<2xf32>, 64>) {
  %add = wave.fadd %a, %b
      : !wave.simd<vector<2xf32>, 64>, !wave.simd<vector<2xf32>, 64>
      -> !wave.simd<vector<2xf32>, 64>
  %mul = wave.fmul %add, %b fastmath<contract>
      : !wave.simd<vector<2xf32>, 64>, !wave.simd<vector<2xf32>, 64>
      -> !wave.simd<vector<2xf32>, 64>
  return
}

}
