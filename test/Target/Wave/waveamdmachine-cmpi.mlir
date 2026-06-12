// RUN: wave-opt --waveamd-to-machine --verify-diagnostics --split-input-file %s | FileCheck %s

module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx1100"} {

// CHECK-LABEL: func.func @signed_cmpi_gfx1100
// CHECK: waveamdmachine.v_cmp_lt_i32
// CHECK: waveamdmachine.v_cmp_le_i32
// CHECK: waveamdmachine.v_cmp_gt_i32
// CHECK: waveamdmachine.v_cmp_ge_i32
func.func @signed_cmpi_gfx1100(%limit: i32) {
  %lane = wave.lane_id : !wave.simd<i32, 32>
  %vlimit = wave.splat %limit : i32 -> !wave.simd<i32, 32>
  %slt = wave.cmpi slt %lane, %vlimit
      : !wave.simd<i32, 32>, !wave.simd<i32, 32> -> !wave.mask<32>
  %sle = wave.cmpi sle %lane, %vlimit
      : !wave.simd<i32, 32>, !wave.simd<i32, 32> -> !wave.mask<32>
  %sgt = wave.cmpi sgt %lane, %vlimit
      : !wave.simd<i32, 32>, !wave.simd<i32, 32> -> !wave.mask<32>
  %sge = wave.cmpi sge %lane, %vlimit
      : !wave.simd<i32, 32>, !wave.simd<i32, 32> -> !wave.mask<32>
  return
}

}

// -----

module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx803"} {

// CHECK-LABEL: func.func @signed_cmpi_gfx803
// CHECK: waveamdmachine.v_cmp_lt_i32_vcc
// CHECK: waveamdmachine.v_cmp_le_i32_vcc
// CHECK: waveamdmachine.v_cmp_gt_i32_vcc
// CHECK: waveamdmachine.v_cmp_ge_i32_vcc
func.func @signed_cmpi_gfx803(%limit: i32) {
  %lane = wave.lane_id : !wave.simd<i32, 64>
  %vlimit = wave.splat %limit : i32 -> !wave.simd<i32, 64>
  %slt = wave.cmpi slt %lane, %vlimit
      : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.mask<64>
  %sle = wave.cmpi sle %lane, %vlimit
      : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.mask<64>
  %sgt = wave.cmpi sgt %lane, %vlimit
      : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.mask<64>
  %sge = wave.cmpi sge %lane, %vlimit
      : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.mask<64>
  return
}

}
