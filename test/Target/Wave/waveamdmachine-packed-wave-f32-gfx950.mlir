// RUN: wave-opt --waveamd-to-machine %s | FileCheck %s --check-prefix=SELECT
// RUN: wave-opt --waveamd-to-machine %s | wave-opt | FileCheck %s --check-prefix=SELECT
// RUN: wave-opt --waveamd-to-machine --waveamd-mfma-packed-peephole %s | FileCheck %s --check-prefix=ERRATUM

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

// SELECT-LABEL: func.func @packed_wave_f32_sub_v2
// SELECT: waveamdmachine.v_pk_add_f32 {{.*}}neg_hi = 2 : i64, neg_lo = 2 : i64
func.func @packed_wave_f32_sub_v2(%a: !wave.simd<vector<2xf32>, 64>,
                                  %b: !wave.simd<vector<2xf32>, 64>) {
  %sub = wave.fsub %a, %b
      : !wave.simd<vector<2xf32>, 64>, !wave.simd<vector<2xf32>, 64>
      -> !wave.simd<vector<2xf32>, 64>
  return
}

// SELECT-LABEL: func.func @packed_wave_f32_sub_v4
// SELECT-COUNT-2: waveamdmachine.v_pk_add_f32 {{.*}}neg_hi = 2 : i64, neg_lo = 2 : i64
func.func @packed_wave_f32_sub_v4(%a: !wave.simd<vector<4xf32>, 64>,
                                  %b: !wave.simd<vector<4xf32>, 64>) {
  %sub = wave.fsub %a, %b
      : !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64>
      -> !wave.simd<vector<4xf32>, 64>
  return
}

// ERRATUM-LABEL: func.func @mfma_scalarizes_packed_f32
// ERRATUM-NOT: waveamdmachine.v_pk_{{(add|mul|fma)}}_f32
// ERRATUM: waveamdmachine.mfma_f32_16x16x32_f16
// ERRATUM-COUNT-8: waveamdmachine.v_add_f32
// ERRATUM-COUNT-4: waveamdmachine.v_mul_f32
// ERRATUM-COUNT-4: waveamdmachine.v_fma_f32
// ERRATUM-NOT: waveamdmachine.v_pk_{{(add|mul|fma)}}_f32
// ERRATUM: return
func.func @mfma_scalarizes_packed_f32(
    %x: !wave.simd<vector<4xf32>, 64>,
    %y: !wave.simd<vector<4xf32>, 64>,
    %z: !wave.simd<vector<4xf32>, 64>) {
  %zero = arith.constant 0 : i32
  %a = waveamd.fragment_fill %zero
      : i32 -> !waveamd.fragment<0, f16, 16, 16, 64, 4>
  %b = waveamd.fragment_fill %zero
      : i32 -> !waveamd.fragment<1, f16, 16, 16, 64, 4>
  %acc = waveamd.fragment_fill %zero
      : i32 -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
  %mma = waveamd.mma "mfma.f32.16x16x32.f16" %a, %b, %acc
      : !waveamd.fragment<0, f16, 16, 16, 64, 4>,
        !waveamd.fragment<1, f16, 16, 16, 64, 4>,
        !waveamd.fragment<2, f32, 16, 16, 64, 4>
     -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
  %add = wave.fadd %x, %y
      : !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64>
      -> !wave.simd<vector<4xf32>, 64>
  %sub = wave.fsub %add, %z
      : !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64>
      -> !wave.simd<vector<4xf32>, 64>
  %mul = wave.fmul %sub, %y
      : !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64>
      -> !wave.simd<vector<4xf32>, 64>
  %fma = wave.fma %mul, %add, %z
      : !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64>,
        !wave.simd<vector<4xf32>, 64> -> !wave.simd<vector<4xf32>, 64>
  return
}

}
