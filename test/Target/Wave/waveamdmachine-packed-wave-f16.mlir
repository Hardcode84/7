// RUN: wave-opt --waveamd-to-machine %s | FileCheck %s --check-prefix=SELECT
// RUN: wave-opt --waveamd-to-machine %s | wave-opt | FileCheck %s --check-prefix=SELECT

module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx1100"} {

// SELECT-LABEL: func.func @packed_wave_math
// SELECT: [[SRC:%.*]] = waveamdmachine.arg {index = 3 : i64, pointer = false} : !waveamdmachine.reg<vgpr, 2>
// SELECT: [[SPLIT:%.*]]:2 = waveamdmachine.tuple_to_elements [[SRC]]
// SELECT: [[CVT:%.*]] = waveamdmachine.v_cvt_pk_rtz_f16_f32 [[SPLIT]]#0, [[SPLIT]]#1
// SELECT: [[ADD:%.*]] = waveamdmachine.v_pk_add_f16 [[CVT]],
// SELECT: [[MUL:%.*]] = waveamdmachine.v_pk_mul_f16 [[ADD]],
// SELECT: waveamdmachine.v_pk_fma_f16 [[MUL]], [[ADD]],
func.func @packed_wave_math(%a: !wave.simd<vector<2xf16>, 32>,
                            %b: !wave.simd<vector<2xf16>, 32>,
                            %c: !wave.simd<vector<2xf16>, 32>,
                            %src: !wave.simd<vector<2xf32>, 32>) {
  %down = wave.cast fpconvert %src policy {rounding = #wave.cast_rounding<rtz>}
      : !wave.simd<vector<2xf32>, 32> -> !wave.simd<vector<2xf16>, 32>
  %add = wave.fadd %down, %a
      : !wave.simd<vector<2xf16>, 32>, !wave.simd<vector<2xf16>, 32>
      -> !wave.simd<vector<2xf16>, 32>
  %mul = wave.fmul %add, %b
      : !wave.simd<vector<2xf16>, 32>, !wave.simd<vector<2xf16>, 32>
      -> !wave.simd<vector<2xf16>, 32>
  %fma = wave.fma %mul, %add, %c
      : !wave.simd<vector<2xf16>, 32>, !wave.simd<vector<2xf16>, 32>,
        !wave.simd<vector<2xf16>, 32> -> !wave.simd<vector<2xf16>, 32>
  return
}

}
