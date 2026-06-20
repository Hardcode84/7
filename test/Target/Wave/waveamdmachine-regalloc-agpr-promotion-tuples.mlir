// RUN: wave-opt --waveamd-reg-alloc='vgpr-limit=1 agpr-limit=32' --waveamd-resource-info %s | FileCheck %s

module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx950"} {

// CHECK-LABEL: func.func @tuple_alias_agpr_promotion
// CHECK-SAME: waveamdmachine.agpr_count = 2 : i64
// CHECK-NOT: waveamdmachine.v_accvgpr
// CHECK: waveamdmachine.s_endpgm
func.func @tuple_alias_agpr_promotion() attributes {wave.kernel} {
  %tuple = waveamdmachine.uninit : !waveamdmachine.reg<vgpr, 2>
  %parts:2 = waveamdmachine.tuple_to_elements %tuple
      : (!waveamdmachine.reg<vgpr, 2>)
        -> (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>)
  %again = waveamdmachine.tuple_from_elements %parts#0, %parts#1
      : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>)
        -> !waveamdmachine.reg<vgpr, 2>
  waveamdmachine.s_endpgm
  return
}

// CHECK-LABEL: func.func @fold_existing_write_bridge
// CHECK-SAME: waveamdmachine.agpr_count = 12 : i64
// CHECK-NOT: waveamdmachine.v_accvgpr_write_b32_tuple
// CHECK: %[[SRC:.*]] = waveamdmachine.uninit : !waveamdmachine.reg<agpr, 4,
// CHECK: waveamdmachine.mfma_f32_16x16x32_f16 {{.*}}, {{.*}}, %[[SRC]]
// CHECK: waveamdmachine.s_endpgm
func.func @fold_existing_write_bridge() attributes {wave.kernel} {
  %src = waveamdmachine.uninit : !waveamdmachine.reg<vgpr, 4>
  %a = waveamdmachine.uninit : !waveamdmachine.reg<agpr, 4>
  %b = waveamdmachine.uninit : !waveamdmachine.reg<agpr, 4>
  %ag = waveamdmachine.v_accvgpr_write_b32_tuple %src
      : (!waveamdmachine.reg<vgpr, 4>) -> !waveamdmachine.reg<agpr, 4>
  %mfma = waveamdmachine.mfma_f32_16x16x32_f16 %a, %b, %ag
      : (!waveamdmachine.reg<agpr, 4>, !waveamdmachine.reg<agpr, 4>,
         !waveamdmachine.reg<agpr, 4>) -> !waveamdmachine.reg<agpr, 4>
  waveamdmachine.s_endpgm
  return
}

// CHECK-LABEL: func.func @fold_fixed_write_bridge
// CHECK-SAME: waveamdmachine.agpr_count = 20 : i64
// CHECK-NOT: waveamdmachine.v_accvgpr_write_b32_tuple
// CHECK: %[[SRC:.*]] = waveamdmachine.uninit : !waveamdmachine.reg<agpr, 4, 16>
// CHECK: waveamdmachine.mfma_f32_16x16x32_f16 {{.*}}, {{.*}}, %[[SRC]]
// CHECK: waveamdmachine.s_endpgm
func.func @fold_fixed_write_bridge() attributes {wave.kernel} {
  %src = waveamdmachine.uninit : !waveamdmachine.reg<vgpr, 4>
  %a = waveamdmachine.uninit : !waveamdmachine.reg<agpr, 4>
  %b = waveamdmachine.uninit : !waveamdmachine.reg<agpr, 4>
  %ag = waveamdmachine.v_accvgpr_write_b32_tuple %src
      : (!waveamdmachine.reg<vgpr, 4>) -> !waveamdmachine.reg<agpr, 4, 16>
  %mfma = waveamdmachine.mfma_f32_16x16x32_f16 %a, %b, %ag
      : (!waveamdmachine.reg<agpr, 4>, !waveamdmachine.reg<agpr, 4>,
         !waveamdmachine.reg<agpr, 4, 16>) -> !waveamdmachine.reg<agpr, 4>
  waveamdmachine.s_endpgm
  return
}

// CHECK-LABEL: func.func @mfma_zero_literal_acc_no_bridge
// CHECK-NOT: waveamdmachine.v_accvgpr
// CHECK: %[[ZERO:.*]] = waveamdmachine.imm 0
// CHECK: waveamdmachine.mfma_f32_16x16x32_f16 {{.*}}, {{.*}}, %[[ZERO]]
// CHECK-SAME: !waveamdmachine.imm) -> !waveamdmachine.reg<agpr, 4,
// CHECK: waveamdmachine.s_endpgm
func.func @mfma_zero_literal_acc_no_bridge() attributes {wave.kernel} {
  %zero = waveamdmachine.imm 0 : !waveamdmachine.imm
  %a = waveamdmachine.uninit : !waveamdmachine.reg<agpr, 4>
  %b = waveamdmachine.uninit : !waveamdmachine.reg<agpr, 4>
  %mfma = waveamdmachine.mfma_f32_16x16x32_f16 %a, %b, %zero
      : (!waveamdmachine.reg<agpr, 4>, !waveamdmachine.reg<agpr, 4>,
         !waveamdmachine.imm) -> !waveamdmachine.reg<agpr, 4>
  waveamdmachine.s_endpgm
  return
}

}
