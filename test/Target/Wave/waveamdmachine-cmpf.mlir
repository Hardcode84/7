// RUN: split-file %s %t
// RUN: wave-opt --waveamd-to-machine %t/gfx950.mlir \
// RUN:   | FileCheck %s --check-prefix=GFX950-SELECT
// RUN: wave-opt --waveamd-to-machine %t/gfx950.mlir \
// RUN:   | wave-translate --wave-to-amdgpu-asm - \
// RUN:   | FileCheck %s --check-prefix=GFX950-ASM
// RUN: wave-opt --waveamd-to-machine %t/gfx950.mlir \
// RUN:   | wave-translate --wave-to-amdgpu-asm - \
// RUN:   | llvm-mc -triple=amdgcn-amd-amdhsa -mcpu=gfx950 -filetype=obj -o /dev/null
// RUN: wave-opt --waveamd-to-machine %t/gfx1100.mlir \
// RUN:   | FileCheck %s --check-prefix=GFX1100-SELECT
// RUN: wave-opt --waveamd-to-machine %t/gfx1100.mlir \
// RUN:   | wave-translate --wave-to-amdgpu-asm - \
// RUN:   | FileCheck %s --check-prefix=GFX1100-ASM
// RUN: wave-opt --waveamd-to-machine %t/gfx1100.mlir \
// RUN:   | wave-translate --wave-to-amdgpu-asm - \
// RUN:   | llvm-mc -triple=amdgcn-amd-amdhsa -mcpu=gfx1100 -filetype=obj -o /dev/null

// GFX950-SELECT-LABEL: func.func @ordered_cmpf_gfx950
// GFX950-SELECT: [[EQ_VCC:%.*]] = waveamdmachine.v_cmp_eq_f32_vcc
// GFX950-SELECT-NEXT: waveamdmachine.s_read_vcc_b64 [[EQ_VCC]]
// GFX950-SELECT: waveamdmachine.v_cmp_lt_f32_vcc
// GFX950-SELECT-NEXT: waveamdmachine.s_read_vcc_b64
// GFX950-SELECT: waveamdmachine.v_cmp_le_f32_vcc
// GFX950-SELECT-NEXT: waveamdmachine.s_read_vcc_b64
// GFX950-SELECT: waveamdmachine.v_cmp_gt_f32_vcc
// GFX950-SELECT-NEXT: waveamdmachine.s_read_vcc_b64
// GFX950-SELECT: waveamdmachine.v_cmp_ge_f32_vcc
// GFX950-SELECT-NEXT: waveamdmachine.s_read_vcc_b64
// GFX950-ASM-LABEL: ordered_cmpf_gfx950:
// GFX950-ASM: v_cmp_eq_f32_e64
// GFX950-ASM: v_cmp_lt_f32_e64
// GFX950-ASM: v_cmp_le_f32_e64
// GFX950-ASM: v_cmp_gt_f32_e64
// GFX950-ASM: v_cmp_ge_f32_e64

//--- gfx950.mlir

module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx950"} {
  func.func @ordered_cmpf_gfx950(
      %lhs: !wave.simd<f32, 64>,
      %rhs: !wave.simd<f32, 64>) -> i64 {
    %eq = wave.cmpf oeq %lhs, %rhs
        : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.mask<64>
    %lt = wave.cmpf olt %lhs, %rhs
        : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.mask<64>
    %le = wave.cmpf ole %lhs, %rhs
        : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.mask<64>
    %gt = wave.cmpf ogt %lhs, %rhs
        : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.mask<64>
    %ge = wave.cmpf oge %lhs, %rhs
        : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.mask<64>
    %pick0 = wave.select %eq, %lt, %le
        : !wave.mask<64>, !wave.mask<64>
    %pick1 = wave.select %gt, %ge, %pick0
        : !wave.mask<64>, !wave.mask<64>
    %bits = wave.ballot %pick1 : !wave.mask<64> -> i64
    return %bits : i64
  }
}

// GFX1100-SELECT-LABEL: func.func @ordered_cmpf_gfx1100
// GFX1100-SELECT: waveamdmachine.v_cmp_eq_f32
// GFX1100-SELECT: waveamdmachine.v_cmp_lt_f32
// GFX1100-SELECT: waveamdmachine.v_cmp_le_f32
// GFX1100-SELECT: waveamdmachine.v_cmp_gt_f32
// GFX1100-SELECT: waveamdmachine.v_cmp_ge_f32
// GFX1100-ASM-LABEL: ordered_cmpf_gfx1100:
// GFX1100-ASM: v_cmp_eq_f32_e64
// GFX1100-ASM: v_cmp_lt_f32_e64
// GFX1100-ASM: v_cmp_le_f32_e64
// GFX1100-ASM: v_cmp_gt_f32_e64
// GFX1100-ASM: v_cmp_ge_f32_e64

//--- gfx1100.mlir

module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx1100"} {
  func.func @ordered_cmpf_gfx1100(
      %lhs: !wave.simd<f32, 32>,
      %rhs: !wave.simd<f32, 32>) -> i32 {
    %eq = wave.cmpf oeq %lhs, %rhs
        : !wave.simd<f32, 32>, !wave.simd<f32, 32> -> !wave.mask<32>
    %lt = wave.cmpf olt %lhs, %rhs
        : !wave.simd<f32, 32>, !wave.simd<f32, 32> -> !wave.mask<32>
    %le = wave.cmpf ole %lhs, %rhs
        : !wave.simd<f32, 32>, !wave.simd<f32, 32> -> !wave.mask<32>
    %gt = wave.cmpf ogt %lhs, %rhs
        : !wave.simd<f32, 32>, !wave.simd<f32, 32> -> !wave.mask<32>
    %ge = wave.cmpf oge %lhs, %rhs
        : !wave.simd<f32, 32>, !wave.simd<f32, 32> -> !wave.mask<32>
    %pick0 = wave.select %eq, %lt, %le
        : !wave.mask<32>, !wave.mask<32>
    %pick1 = wave.select %gt, %ge, %pick0
        : !wave.mask<32>, !wave.mask<32>
    %bits = wave.ballot %pick1 : !wave.mask<32> -> i32
    return %bits : i32
  }
}
