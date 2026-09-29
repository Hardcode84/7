// RUN: wave-opt --split-input-file --waveamd-mfma-packed-peephole --verify-diagnostics %s

module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx950"} {
func.func @reject_clamp(
    %a: !waveamdmachine.reg<vgpr, 4>,
    %b: !waveamdmachine.reg<vgpr, 4>,
    %acc: !waveamdmachine.reg<vgpr, 4>,
    %lhs: !waveamdmachine.reg<vgpr, 2>,
    %rhs: !waveamdmachine.reg<vgpr, 2>) {
  %mfma = waveamdmachine.mfma_f32_16x16x32_f16 %a, %b, %acc
      : (!waveamdmachine.reg<vgpr, 4>, !waveamdmachine.reg<vgpr, 4>,
         !waveamdmachine.reg<vgpr, 4>) -> !waveamdmachine.reg<vgpr, 4>
  // expected-error @below {{gfx950 MFMA functions do not support clamped packed F32 operations}}
  %packed = waveamdmachine.v_pk_mul_f32 %lhs, %rhs {clamp = true}
      : (!waveamdmachine.reg<vgpr, 2>, !waveamdmachine.reg<vgpr, 2>)
        -> !waveamdmachine.reg<vgpr, 2>
  return
}
}

// -----

module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx950"} {
func.func @reject_fixed_result_clobber(
    %a: !waveamdmachine.reg<vgpr, 4>,
    %b: !waveamdmachine.reg<vgpr, 4>,
    %acc: !waveamdmachine.reg<vgpr, 4>,
    %lhs: !waveamdmachine.reg<vgpr, 2, 12>,
    %rhs: !waveamdmachine.reg<vgpr, 2, 14>) {
  %mfma = waveamdmachine.mfma_f32_16x16x32_f16 %a, %b, %acc
      : (!waveamdmachine.reg<vgpr, 4>, !waveamdmachine.reg<vgpr, 4>,
         !waveamdmachine.reg<vgpr, 4>) -> !waveamdmachine.reg<vgpr, 4>
  // expected-error @below {{gfx950 MFMA functions cannot scalarize a packed F32 operation with an overlapping fixed result}}
  %packed = waveamdmachine.v_pk_add_f32 %lhs, %rhs {op_sel_hi = 0 : i64}
      : (!waveamdmachine.reg<vgpr, 2, 12>,
         !waveamdmachine.reg<vgpr, 2, 14>)
        -> !waveamdmachine.reg<vgpr, 2, 12>
  return
}
}
