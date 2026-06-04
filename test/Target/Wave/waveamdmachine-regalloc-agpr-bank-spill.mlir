// RUN: wave-opt --waveamd-reg-alloc='agpr-bank-spill=true vgpr-limit=16' %s | FileCheck %s

// CHECK-LABEL: func.func @agpr_bank_spill_retries
// CHECK: %[[A:.*]] = waveamdmachine.uninit : !waveamdmachine.reg<vgpr
// CHECK: %[[B:.*]] = waveamdmachine.uninit : !waveamdmachine.reg<vgpr
// CHECK: %[[ACC:.*]] = waveamdmachine.uninit : !waveamdmachine.reg<agpr
// CHECK: %[[MFMA:.*]] = waveamdmachine.mfma_f32_16x16x32_f16 %[[A]], %[[B]], %[[ACC]]
// CHECK-SAME: -> !waveamdmachine.reg<agpr
// CHECK: %[[GENERIC:.*]] = waveamdmachine.v_mov_b32_tuple
// CHECK: %[[SPILLED:.*]] = waveamdmachine.v_accvgpr_write_b32_tuple %[[GENERIC]]
// CHECK: %[[MFMA_READ:.*]] = waveamdmachine.v_accvgpr_read_b32_tuple %[[MFMA]]
// CHECK: waveamdmachine.v_mov_b32_tuple %[[MFMA_READ]]
// CHECK: %[[GENERIC_READ:.*]] = waveamdmachine.v_accvgpr_read_b32_tuple %[[SPILLED]]
// CHECK: waveamdmachine.v_mov_b32_tuple %[[GENERIC_READ]]

module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx950"} {

func.func @agpr_bank_spill_retries() {
  %zero = waveamdmachine.imm 0 : !waveamdmachine.imm
  %a = waveamdmachine.uninit : !waveamdmachine.reg<vgpr, 4>
  %b = waveamdmachine.uninit : !waveamdmachine.reg<vgpr, 4>
  %acc = waveamdmachine.uninit : !waveamdmachine.reg<vgpr, 4>
  %mfma = waveamdmachine.mfma_f32_16x16x32_f16 %a, %b, %acc
      : (!waveamdmachine.reg<vgpr, 4>, !waveamdmachine.reg<vgpr, 4>,
         !waveamdmachine.reg<vgpr, 4>) -> !waveamdmachine.reg<vgpr, 4>
  %generic0 = waveamdmachine.v_mov_b32_tuple %zero {registers = 4 : i64}
      : (!waveamdmachine.imm) -> !waveamdmachine.reg<vgpr, 4>
  %generic1 = waveamdmachine.v_mov_b32_tuple %zero {registers = 4 : i64}
      : (!waveamdmachine.imm) -> !waveamdmachine.reg<vgpr, 4>
  %generic2 = waveamdmachine.v_mov_b32_tuple %zero {registers = 4 : i64}
      : (!waveamdmachine.imm) -> !waveamdmachine.reg<vgpr, 4>
  %generic3 = waveamdmachine.v_mov_b32_tuple %zero {registers = 4 : i64}
      : (!waveamdmachine.imm) -> !waveamdmachine.reg<vgpr, 4>
  %use_mfma = waveamdmachine.v_mov_b32_tuple %mfma {registers = 4 : i64}
      : (!waveamdmachine.reg<vgpr, 4>) -> !waveamdmachine.reg<vgpr, 4>
  %use_generic0 = waveamdmachine.v_mov_b32_tuple %generic0 {registers = 4 : i64}
      : (!waveamdmachine.reg<vgpr, 4>) -> !waveamdmachine.reg<vgpr, 4>
  %use_generic1 = waveamdmachine.v_mov_b32_tuple %generic1 {registers = 4 : i64}
      : (!waveamdmachine.reg<vgpr, 4>) -> !waveamdmachine.reg<vgpr, 4>
  %use_generic2 = waveamdmachine.v_mov_b32_tuple %generic2 {registers = 4 : i64}
      : (!waveamdmachine.reg<vgpr, 4>) -> !waveamdmachine.reg<vgpr, 4>
  %use_generic3 = waveamdmachine.v_mov_b32_tuple %generic3 {registers = 4 : i64}
      : (!waveamdmachine.reg<vgpr, 4>) -> !waveamdmachine.reg<vgpr, 4>
  return
}

}
