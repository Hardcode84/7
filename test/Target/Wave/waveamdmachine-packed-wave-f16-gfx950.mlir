// RUN: wave-opt --waveamd-to-machine %s | FileCheck %s --check-prefix=SELECT
// RUN: wave-opt --waveamd-to-machine %s | wave-opt | FileCheck %s --check-prefix=SELECT

module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx950"} {

// SELECT-LABEL: func.func @packed_wave_math_v4
// SELECT-COUNT-2: waveamdmachine.v_cvt_pk_f16_f32
// SELECT-COUNT-2: waveamdmachine.v_cvt_pk_rtz_f16_f32
// SELECT: waveamdmachine.v_cvt_f32_f16_e32
// SELECT: waveamdmachine.v_cvt_f32_f16_sdwa
// SELECT: waveamdmachine.v_cvt_f32_f16_e32
// SELECT: waveamdmachine.v_cvt_f32_f16_sdwa
// SELECT-COUNT-2: waveamdmachine.v_pk_add_f16
// SELECT-COUNT-2: waveamdmachine.v_pk_mul_f16
// SELECT-COUNT-2: waveamdmachine.v_pk_fma_f16
func.func @packed_wave_math_v4(%a: !wave.simd<vector<4xf16>, 64>,
                               %b: !wave.simd<vector<4xf16>, 64>,
                               %c: !wave.simd<vector<4xf16>, 64>,
                               %src: !wave.simd<vector<4xf32>, 64>) {
  %rne = wave.cast fpconvert %src
      : !wave.simd<vector<4xf32>, 64> -> !wave.simd<vector<4xf16>, 64>
  %rtz = wave.cast fpconvert %src policy {rounding = #wave.cast_rounding<rtz>}
      : !wave.simd<vector<4xf32>, 64> -> !wave.simd<vector<4xf16>, 64>
  %up = wave.cast fpconvert %rne
      : !wave.simd<vector<4xf16>, 64> -> !wave.simd<vector<4xf32>, 64>
  %add = wave.fadd %rne, %rtz
      : !wave.simd<vector<4xf16>, 64>, !wave.simd<vector<4xf16>, 64>
      -> !wave.simd<vector<4xf16>, 64>
  %mul = wave.fmul %add, %b
      : !wave.simd<vector<4xf16>, 64>, !wave.simd<vector<4xf16>, 64>
      -> !wave.simd<vector<4xf16>, 64>
  %fma = wave.fma %mul, %add, %c
      : !wave.simd<vector<4xf16>, 64>, !wave.simd<vector<4xf16>, 64>,
        !wave.simd<vector<4xf16>, 64> -> !wave.simd<vector<4xf16>, 64>
  return
}

// SELECT-LABEL: func.func @packed_wave_splat_word_operand
// SELECT: [[U:%.*]] = waveamdmachine.arg {index = 0 : i64, pointer = false} : !waveamdmachine.reg<sgpr, 1>
// SELECT: [[VGPR:%.*]] = waveamdmachine.v_mov_b32_tuple [[U]]
// SELECT: waveamdmachine.v_pk_add_f16 [[VGPR]],
func.func @packed_wave_splat_word_operand(%u: vector<2xf16>,
                                          %a: !wave.simd<vector<2xf16>, 64>) {
  %s = wave.splat %u
      : vector<2xf16> -> !wave.simd<vector<2xf16>, 64>
  %add = wave.fadd %s, %a
      : !wave.simd<vector<2xf16>, 64>, !wave.simd<vector<2xf16>, 64>
      -> !wave.simd<vector<2xf16>, 64>
  return
}

// SELECT-LABEL: func.func @packed_wave_splat_tuple_operand
// SELECT: [[U:%.*]] = waveamdmachine.arg {index = 0 : i64, pointer = false} : !waveamdmachine.reg<sgpr, 2>
// SELECT: waveamdmachine.tuple_to_elements [[U]]
// SELECT-COUNT-2: waveamdmachine.v_mov_b32_tuple
// SELECT-COUNT-2: waveamdmachine.v_pk_add_f16
func.func @packed_wave_splat_tuple_operand(%u: vector<4xf16>,
                                           %a: !wave.simd<vector<4xf16>, 64>) {
  %s = wave.splat %u
      : vector<4xf16> -> !wave.simd<vector<4xf16>, 64>
  %add = wave.fadd %s, %a
      : !wave.simd<vector<4xf16>, 64>, !wave.simd<vector<4xf16>, 64>
      -> !wave.simd<vector<4xf16>, 64>
  return
}

// SELECT-LABEL: func.func @packed_wave_cast_v1
// SELECT: waveamdmachine.v_cvt_pk_f16_f32
// SELECT: waveamdmachine.v_cvt_pk_rtz_f16_f32
// SELECT: waveamdmachine.v_cvt_f32_f16_e32
func.func @packed_wave_cast_v1(%src: !wave.simd<vector<1xf32>, 64>) {
  %rne = wave.cast fpconvert %src
      : !wave.simd<vector<1xf32>, 64> -> !wave.simd<vector<1xf16>, 64>
  %rtz = wave.cast fpconvert %src policy {rounding = #wave.cast_rounding<rtz>}
      : !wave.simd<vector<1xf32>, 64> -> !wave.simd<vector<1xf16>, 64>
  %up = wave.cast fpconvert %rne
      : !wave.simd<vector<1xf16>, 64> -> !wave.simd<vector<1xf32>, 64>
  return
}

}
