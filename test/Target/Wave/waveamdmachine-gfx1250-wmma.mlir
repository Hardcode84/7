// RUN: wave-opt --waveamd-to-machine %s | FileCheck %s --check-prefix=SELECT
// RUN: wave-opt --waveamd-to-machine %s | wave-opt | FileCheck %s --check-prefix=SELECT

module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx1250"} {

// SELECT-LABEL: func.func @gfx1250_wmma_f16_pack
// SELECT: waveamdmachine.arg{{.*}}!waveamdmachine.reg<vgpr, 8>
// SELECT: waveamdmachine.arg{{.*}}!waveamdmachine.reg<vgpr, 8>
// SELECT: waveamdmachine.arg{{.*}}!waveamdmachine.reg<vgpr, 8>
// SELECT: [[MMA:%.*]] = waveamdmachine.wmma_f32_16x16x32_f16
// SELECT-SAME: (!waveamdmachine.reg<vgpr, 8>, !waveamdmachine.reg<vgpr, 8>, !waveamdmachine.reg<vgpr, 8>) -> !waveamdmachine.reg<vgpr, 8>
// SELECT: [[PARTS:%.*]]:8 = waveamdmachine.tuple_to_elements [[MMA]]
func.func @gfx1250_wmma_f16_pack(
    %a_raw: !wave.simd<vector<16xf16>, 32>,
    %b_raw: !wave.simd<vector<16xf16>, 32>,
    %acc_raw: !wave.simd<vector<8xf32>, 32>) -> !wave.simd<i32, 32> {
  %a = waveamd.fragment_pack %a_raw
      : !wave.simd<vector<16xf16>, 32>
      -> !waveamd.fragment<0, f16, 16, 16, 32, 8>
  %b = waveamd.fragment_pack %b_raw
      : !wave.simd<vector<16xf16>, 32>
      -> !waveamd.fragment<1, f16, 16, 16, 32, 8>
  %acc = waveamd.fragment_pack %acc_raw
      : !wave.simd<vector<8xf32>, 32>
      -> !waveamd.fragment<2, f32, 16, 16, 32, 8>
  %result = waveamd.mma "wmma.f32.16x16x32.f16" %a, %b, %acc
      : !waveamd.fragment<0, f16, 16, 16, 32, 8>,
        !waveamd.fragment<1, f16, 16, 16, 32, 8>,
        !waveamd.fragment<2, f32, 16, 16, 32, 8>
     -> !waveamd.fragment<2, f32, 16, 16, 32, 8>
  %regs = waveamd.fragment_unpack %result
      : !waveamd.fragment<2, f32, 16, 16, 32, 8>
      -> !wave.simd<vector<8xi32>, 32>
  %last = wave.extract %regs[7]
      : !wave.simd<vector<8xi32>, 32> -> !wave.simd<i32, 32>
  return %last : !wave.simd<i32, 32>
}

// SELECT-LABEL: func.func @gfx1250_wmma_bf16_fill
// SELECT: waveamdmachine.v_mov_b32_tuple
// SELECT-SAME: -> !waveamdmachine.reg<vgpr, 8>
// SELECT: waveamdmachine.v_mov_b32_tuple
// SELECT-SAME: -> !waveamdmachine.reg<vgpr, 8>
// SELECT: [[MMA:%.*]] = waveamdmachine.wmma_f32_16x16x32_bf16
// SELECT-SAME: (!waveamdmachine.reg<vgpr, 8>, !waveamdmachine.reg<vgpr, 8>, !waveamdmachine.imm) -> !waveamdmachine.reg<vgpr, 8>
// SELECT: [[PARTS:%.*]]:8 = waveamdmachine.tuple_to_elements [[MMA]]
func.func @gfx1250_wmma_bf16_fill() -> !wave.simd<i32, 32> {
  %zero = arith.constant 0 : i32
  %a = waveamd.fragment_fill %zero
      : i32 -> !waveamd.fragment<0, bf16, 16, 16, 32, 8>
  %b = waveamd.fragment_fill %zero
      : i32 -> !waveamd.fragment<1, bf16, 16, 16, 32, 8>
  %acc = waveamd.fragment_fill %zero
      : i32 -> !waveamd.fragment<2, f32, 16, 16, 32, 8>
  %result = waveamd.mma "wmma.f32.16x16x32.bf16" %a, %b, %acc
      : !waveamd.fragment<0, bf16, 16, 16, 32, 8>,
        !waveamd.fragment<1, bf16, 16, 16, 32, 8>,
        !waveamd.fragment<2, f32, 16, 16, 32, 8>
     -> !waveamd.fragment<2, f32, 16, 16, 32, 8>
  %regs = waveamd.fragment_unpack %result
      : !waveamd.fragment<2, f32, 16, 16, 32, 8>
      -> !wave.simd<vector<8xi32>, 32>
  %first = wave.extract %regs[0]
      : !wave.simd<vector<8xi32>, 32> -> !wave.simd<i32, 32>
  return %first : !wave.simd<i32, 32>
}

}
