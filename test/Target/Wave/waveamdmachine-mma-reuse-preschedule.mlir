// RUN: wave-opt --split-input-file %s --waveamd-mma-reuse-preschedule | FileCheck %s

module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx950"} {
  // CHECK-LABEL: func.func @mfma_reuse_order
  // CHECK: [[R0:%.*]] = waveamdmachine.mfma_f32_16x16x32_f16 [[A0:%[^,]+]], [[B0:%[^,]+]], [[ACC0:%[^[:space:]]+]]
  // CHECK-NEXT: [[R2:%.*]] = waveamdmachine.mfma_f32_16x16x32_f16 [[A0]], [[B2:%[^,]+]], [[ACC2:%[^[:space:]]+]]
  // CHECK-NEXT: [[R1:%.*]] = waveamdmachine.mfma_f32_16x16x32_f16 [[A1:%[^,]+]], [[B1:%[^,]+]], [[ACC1:%[^[:space:]]+]]
  func.func @mfma_reuse_order(
      %a0: !waveamdmachine.reg<vgpr, 4>,
      %a1: !waveamdmachine.reg<vgpr, 4>,
      %b0: !waveamdmachine.reg<vgpr, 4>,
      %b1: !waveamdmachine.reg<vgpr, 4>,
      %b2: !waveamdmachine.reg<vgpr, 4>,
      %acc0: !waveamdmachine.reg<vgpr, 4>,
      %acc1: !waveamdmachine.reg<vgpr, 4>,
      %acc2: !waveamdmachine.reg<vgpr, 4>) {
    %r0 = waveamdmachine.mfma_f32_16x16x32_f16 %a0, %b0, %acc0
        : (!waveamdmachine.reg<vgpr, 4>, !waveamdmachine.reg<vgpr, 4>,
           !waveamdmachine.reg<vgpr, 4>) -> !waveamdmachine.reg<vgpr, 4>
    %r1 = waveamdmachine.mfma_f32_16x16x32_f16 %a1, %b1, %acc1
        : (!waveamdmachine.reg<vgpr, 4>, !waveamdmachine.reg<vgpr, 4>,
           !waveamdmachine.reg<vgpr, 4>) -> !waveamdmachine.reg<vgpr, 4>
    %r2 = waveamdmachine.mfma_f32_16x16x32_f16 %a0, %b2, %acc2
        : (!waveamdmachine.reg<vgpr, 4>, !waveamdmachine.reg<vgpr, 4>,
           !waveamdmachine.reg<vgpr, 4>) -> !waveamdmachine.reg<vgpr, 4>
    return
  }

  // CHECK-LABEL: func.func @scaled_mfma_reuse_order
  // CHECK: [[S0:%.*]] = waveamdmachine.mfma_scale_f32_16x16x128_f4_f4 [[SA0:%[^,]+]], [[SB0:%[^,]+]], [[SACC0:%[^,]+]], [[SCALE0:%[^,]+]], [[SCALE1:%[^[:space:]]+]]
  // CHECK-NEXT: [[S2:%.*]] = waveamdmachine.mfma_scale_f32_16x16x128_f4_f4 [[SA0]], [[SB2:%[^,]+]], [[SACC2:%[^,]+]], [[SCALE0]], [[SCALE3:%[^[:space:]]+]]
  // CHECK-NEXT: [[S1:%.*]] = waveamdmachine.mfma_scale_f32_16x16x128_f4_f4 [[SA1:%[^,]+]], [[SB1:%[^,]+]], [[SACC1:%[^,]+]], [[SCALE2:%[^,]+]], [[SCALE3]]
  func.func @scaled_mfma_reuse_order(
      %a0: !waveamdmachine.reg<vgpr, 4>,
      %a1: !waveamdmachine.reg<vgpr, 4>,
      %b0: !waveamdmachine.reg<vgpr, 4>,
      %b1: !waveamdmachine.reg<vgpr, 4>,
      %b2: !waveamdmachine.reg<vgpr, 4>,
      %acc0: !waveamdmachine.reg<vgpr, 4>,
      %acc1: !waveamdmachine.reg<vgpr, 4>,
      %acc2: !waveamdmachine.reg<vgpr, 4>,
      %scale0: !waveamdmachine.reg<vgpr, 1>,
      %scale1: !waveamdmachine.reg<vgpr, 1>,
      %scale2: !waveamdmachine.reg<vgpr, 1>,
      %scale3: !waveamdmachine.reg<vgpr, 1>) {
    %r0 = waveamdmachine.mfma_scale_f32_16x16x128_f4_f4
        %a0, %b0, %acc0, %scale0, %scale1
        : (!waveamdmachine.reg<vgpr, 4>, !waveamdmachine.reg<vgpr, 4>,
           !waveamdmachine.reg<vgpr, 4>, !waveamdmachine.reg<vgpr, 1>,
           !waveamdmachine.reg<vgpr, 1>) -> !waveamdmachine.reg<vgpr, 4>
    %r1 = waveamdmachine.mfma_scale_f32_16x16x128_f4_f4
        %a1, %b1, %acc1, %scale2, %scale3
        : (!waveamdmachine.reg<vgpr, 4>, !waveamdmachine.reg<vgpr, 4>,
           !waveamdmachine.reg<vgpr, 4>, !waveamdmachine.reg<vgpr, 1>,
           !waveamdmachine.reg<vgpr, 1>) -> !waveamdmachine.reg<vgpr, 4>
    %r2 = waveamdmachine.mfma_scale_f32_16x16x128_f4_f4
        %a0, %b2, %acc2, %scale0, %scale3
        : (!waveamdmachine.reg<vgpr, 4>, !waveamdmachine.reg<vgpr, 4>,
           !waveamdmachine.reg<vgpr, 4>, !waveamdmachine.reg<vgpr, 1>,
           !waveamdmachine.reg<vgpr, 1>) -> !waveamdmachine.reg<vgpr, 4>
    return
  }

  // CHECK-LABEL: func.func @dominance_ready_order
  // CHECK: [[D0:%.*]] = waveamdmachine.mfma_f32_16x16x32_f16 [[DA0:%[^,]+]], [[DB0:%[^,]+]], [[DACC0:%[^[:space:]]+]]
  // CHECK-NEXT: [[D1:%.*]] = waveamdmachine.mfma_f32_16x16x32_f16 [[DA0]], [[DB1:%[^,]+]], [[DACC1:%[^[:space:]]+]]
  // CHECK-NEXT: [[D2:%.*]] = waveamdmachine.mfma_f32_16x16x32_f16 [[DA2:%[^,]+]], [[DB2:%[^,]+]], [[DACC2:%[^[:space:]]+]]
  // CHECK-NEXT: [[D3:%.*]] = waveamdmachine.mfma_f32_16x16x32_f16 [[DA0]], [[DB0]], [[D2]]
  func.func @dominance_ready_order(
      %a0: !waveamdmachine.reg<vgpr, 4>,
      %a2: !waveamdmachine.reg<vgpr, 4>,
      %b0: !waveamdmachine.reg<vgpr, 4>,
      %b1: !waveamdmachine.reg<vgpr, 4>,
      %b2: !waveamdmachine.reg<vgpr, 4>,
      %acc0: !waveamdmachine.reg<vgpr, 4>,
      %acc1: !waveamdmachine.reg<vgpr, 4>,
      %acc2: !waveamdmachine.reg<vgpr, 4>) {
    %r0 = waveamdmachine.mfma_f32_16x16x32_f16 %a0, %b0, %acc0
        : (!waveamdmachine.reg<vgpr, 4>, !waveamdmachine.reg<vgpr, 4>,
           !waveamdmachine.reg<vgpr, 4>) -> !waveamdmachine.reg<vgpr, 4>
    %r1 = waveamdmachine.mfma_f32_16x16x32_f16 %a0, %b1, %acc1
        : (!waveamdmachine.reg<vgpr, 4>, !waveamdmachine.reg<vgpr, 4>,
           !waveamdmachine.reg<vgpr, 4>) -> !waveamdmachine.reg<vgpr, 4>
    %r2 = waveamdmachine.mfma_f32_16x16x32_f16 %a2, %b2, %acc2
        : (!waveamdmachine.reg<vgpr, 4>, !waveamdmachine.reg<vgpr, 4>,
           !waveamdmachine.reg<vgpr, 4>) -> !waveamdmachine.reg<vgpr, 4>
    %r3 = waveamdmachine.mfma_f32_16x16x32_f16 %a0, %b0, %r2
        : (!waveamdmachine.reg<vgpr, 4>, !waveamdmachine.reg<vgpr, 4>,
           !waveamdmachine.reg<vgpr, 4>) -> !waveamdmachine.reg<vgpr, 4>
    return
  }
}

// -----

module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx1100"} {
  // CHECK-LABEL: func.func @wmma_reuse_order
  // CHECK: [[W0:%.*]] = waveamdmachine.wmma_f32_16x16x16_f16 [[WA0:%[^,]+]], [[WB0:%[^,]+]], [[WACC0:%[^[:space:]]+]]
  // CHECK-NEXT: [[W2:%.*]] = waveamdmachine.wmma_f32_16x16x16_f16 [[WA0]], [[WB2:%[^,]+]], [[WACC2:%[^[:space:]]+]]
  // CHECK-NEXT: [[W1:%.*]] = waveamdmachine.wmma_f32_16x16x16_f16 [[WA1:%[^,]+]], [[WB1:%[^,]+]], [[WACC1:%[^[:space:]]+]]
  func.func @wmma_reuse_order(
      %a0: !waveamdmachine.reg<vgpr, 8>,
      %a1: !waveamdmachine.reg<vgpr, 8>,
      %b0: !waveamdmachine.reg<vgpr, 8>,
      %b1: !waveamdmachine.reg<vgpr, 8>,
      %b2: !waveamdmachine.reg<vgpr, 8>,
      %acc0: !waveamdmachine.reg<vgpr, 8>,
      %acc1: !waveamdmachine.reg<vgpr, 8>,
      %acc2: !waveamdmachine.reg<vgpr, 8>) {
    %r0 = waveamdmachine.wmma_f32_16x16x16_f16 %a0, %b0, %acc0
        : (!waveamdmachine.reg<vgpr, 8>, !waveamdmachine.reg<vgpr, 8>,
           !waveamdmachine.reg<vgpr, 8>) -> !waveamdmachine.reg<vgpr, 8>
    %r1 = waveamdmachine.wmma_f32_16x16x16_f16 %a1, %b1, %acc1
        : (!waveamdmachine.reg<vgpr, 8>, !waveamdmachine.reg<vgpr, 8>,
           !waveamdmachine.reg<vgpr, 8>) -> !waveamdmachine.reg<vgpr, 8>
    %r2 = waveamdmachine.wmma_f32_16x16x16_f16 %a0, %b2, %acc2
        : (!waveamdmachine.reg<vgpr, 8>, !waveamdmachine.reg<vgpr, 8>,
           !waveamdmachine.reg<vgpr, 8>) -> !waveamdmachine.reg<vgpr, 8>
    return
  }
}
