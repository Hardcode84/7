// RUN: wave-opt --waveamd-reg-alloc --waveamd-resource-info %s | FileCheck %s
// RUN: wave-opt --waveamd-reg-alloc='mark-overflow=true' --waveamd-resource-info %s | FileCheck %s --check-prefix=MARK

module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx90a"} {

// CHECK-LABEL: func.func @combined_pressure_remats_neutral_agpr_promotion
// CHECK-SAME: waveamdmachine.regalloc_assignments
// CHECK-SAME: waveamdmachine.vgpr_count = 8 : i64
// CHECK-NOT: waveamdmachine.regalloc_overflowed
// CHECK-NOT: waveamdmachine.v_accvgpr_write_b32_tuple
// CHECK: waveamdmachine.s_endpgm
// MARK-LABEL: func.func @combined_pressure_remats_neutral_agpr_promotion
// MARK-SAME: waveamdmachine.regalloc_assignments
// MARK-SAME: waveamdmachine.vgpr_count = 8 : i64
// MARK-NOT: waveamdmachine.regalloc_overflowed = 1 : i64
// MARK-NOT: waveamdmachine.v_accvgpr_write_b32_tuple
// MARK: waveamdmachine.s_endpgm
func.func @combined_pressure_remats_neutral_agpr_promotion()
    attributes {waveamdmachine.target_waves = 4 : i64} {
  %zero = waveamdmachine.imm 0 : !waveamdmachine.imm
  %ag = waveamdmachine.uninit : !waveamdmachine.reg<agpr, 120>
  %spill = waveamdmachine.uninit : !waveamdmachine.reg<vgpr, 1>
  %v0 = waveamdmachine.v_mov_b32_tuple %zero {registers = 1 : i64}
      : (!waveamdmachine.imm) -> !waveamdmachine.reg<vgpr, 1>
  %v1 = waveamdmachine.v_mov_b32_tuple %zero {registers = 1 : i64}
      : (!waveamdmachine.imm) -> !waveamdmachine.reg<vgpr, 1>
  %v2 = waveamdmachine.v_mov_b32_tuple %zero {registers = 1 : i64}
      : (!waveamdmachine.imm) -> !waveamdmachine.reg<vgpr, 1>
  %v3 = waveamdmachine.v_mov_b32_tuple %zero {registers = 1 : i64}
      : (!waveamdmachine.imm) -> !waveamdmachine.reg<vgpr, 1>
  %v4 = waveamdmachine.v_mov_b32_tuple %zero {registers = 1 : i64}
      : (!waveamdmachine.imm) -> !waveamdmachine.reg<vgpr, 1>
  %v5 = waveamdmachine.v_mov_b32_tuple %zero {registers = 1 : i64}
      : (!waveamdmachine.imm) -> !waveamdmachine.reg<vgpr, 1>
  %v6 = waveamdmachine.v_mov_b32_tuple %zero {registers = 1 : i64}
      : (!waveamdmachine.imm) -> !waveamdmachine.reg<vgpr, 1>
  %use = waveamdmachine.v_add_u32 %spill, %v0
      : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>)
        -> !waveamdmachine.reg<vgpr, 1>
  %sum0 = waveamdmachine.v_add_u32 %v1, %v2
      : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>)
        -> !waveamdmachine.reg<vgpr, 1>
  %sum1 = waveamdmachine.v_add_u32 %v3, %v4
      : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>)
        -> !waveamdmachine.reg<vgpr, 1>
  %sum2 = waveamdmachine.v_add_u32 %v5, %v6
      : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>)
        -> !waveamdmachine.reg<vgpr, 1>
  %sum3 = waveamdmachine.v_add_u32 %sum0, %sum1
      : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>)
        -> !waveamdmachine.reg<vgpr, 1>
  %sum4 = waveamdmachine.v_add_u32 %sum2, %use
      : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>)
        -> !waveamdmachine.reg<vgpr, 1>
  %sum5 = waveamdmachine.v_add_u32 %sum3, %sum4
      : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>)
        -> !waveamdmachine.reg<vgpr, 1>
  %parts:2 = waveamdmachine.tuple_to_elements %ag
      : (!waveamdmachine.reg<agpr, 120>)
      -> (!waveamdmachine.reg<agpr, 60>, !waveamdmachine.reg<agpr, 60>)
  waveamdmachine.s_endpgm
  return
}

// CHECK-LABEL: func.func @combined_pressure_remats_layout_mul
// CHECK-SAME: waveamdmachine.regalloc_assignments
// CHECK-SAME: waveamdmachine.vgpr_count = 8 : i64
// CHECK-NOT: waveamdmachine.regalloc_overflowed
// CHECK: waveamdmachine.v_mul_lo_u32
// CHECK: waveamdmachine.s_endpgm
// MARK-LABEL: func.func @combined_pressure_remats_layout_mul
// MARK-SAME: waveamdmachine.regalloc_assignments
// MARK-SAME: waveamdmachine.vgpr_count = 8 : i64
// MARK-NOT: waveamdmachine.regalloc_overflowed = 1 : i64
// MARK: waveamdmachine.v_mul_lo_u32
// MARK: waveamdmachine.s_endpgm
func.func @combined_pressure_remats_layout_mul()
    attributes {waveamdmachine.target_waves = 4 : i64} {
  %zero = waveamdmachine.imm 0 : !waveamdmachine.imm
  %one = waveamdmachine.imm 1 : !waveamdmachine.imm
  %seven = waveamdmachine.imm 7 : !waveamdmachine.imm
  %ag = waveamdmachine.uninit : !waveamdmachine.reg<agpr, 120>
  %lane = waveamdmachine.v_mov_b32_tuple %zero {registers = 1 : i64}
      : (!waveamdmachine.imm) -> !waveamdmachine.reg<vgpr, 1>
  %mul = waveamdmachine.v_mul_lo_u32 %lane, %seven
      : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.imm)
        -> !waveamdmachine.reg<vgpr, 1>
  %addr = waveamdmachine.v_lshlrev_b32 %mul, %one
      : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.imm)
        -> !waveamdmachine.reg<vgpr, 1>
  %v0 = waveamdmachine.uninit : !waveamdmachine.reg<vgpr, 1>
  %v1 = waveamdmachine.uninit : !waveamdmachine.reg<vgpr, 1>
  %v2 = waveamdmachine.uninit : !waveamdmachine.reg<vgpr, 1>
  %v3 = waveamdmachine.uninit : !waveamdmachine.reg<vgpr, 1>
  %v4 = waveamdmachine.uninit : !waveamdmachine.reg<vgpr, 1>
  %v5 = waveamdmachine.uninit : !waveamdmachine.reg<vgpr, 1>
  %v6 = waveamdmachine.uninit : !waveamdmachine.reg<vgpr, 1>
  %u0 = waveamdmachine.v_add_u32 %v0, %v1
      : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>)
        -> !waveamdmachine.reg<vgpr, 1>
  %u1 = waveamdmachine.v_add_u32 %v2, %v3
      : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>)
        -> !waveamdmachine.reg<vgpr, 1>
  %u2 = waveamdmachine.v_add_u32 %v4, %v5
      : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>)
        -> !waveamdmachine.reg<vgpr, 1>
  %u3 = waveamdmachine.v_add_u32 %u0, %u1
      : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>)
        -> !waveamdmachine.reg<vgpr, 1>
  %u4 = waveamdmachine.v_add_u32 %u2, %v6
      : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>)
        -> !waveamdmachine.reg<vgpr, 1>
  %u5 = waveamdmachine.v_add_u32 %u3, %u4
      : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>)
        -> !waveamdmachine.reg<vgpr, 1>
  %u6 = waveamdmachine.v_add_u32 %u5, %addr
      : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>)
        -> !waveamdmachine.reg<vgpr, 1>
  %parts:2 = waveamdmachine.tuple_to_elements %ag
      : (!waveamdmachine.reg<agpr, 120>)
      -> (!waveamdmachine.reg<agpr, 60>, !waveamdmachine.reg<agpr, 60>)
  waveamdmachine.s_endpgm
  return
}

// MARK-LABEL: func.func @combined_pressure_allows_aligned_agpr_promotion
// MARK-SAME: waveamdmachine.vgpr_count = 4 : i64
// MARK-NOT: waveamdmachine.regalloc_overflowed
// MARK-NOT: waveamdmachine.v_accvgpr_write_b32_tuple
// MARK: waveamdmachine.s_endpgm
// CHECK-LABEL: func.func @combined_pressure_allows_aligned_agpr_promotion
// CHECK-SAME: waveamdmachine.vgpr_count = 4 : i64
// CHECK-NOT: waveamdmachine.regalloc_overflowed
// CHECK-NOT: waveamdmachine.v_accvgpr_write_b32_tuple
// CHECK: waveamdmachine.s_endpgm
func.func @combined_pressure_allows_aligned_agpr_promotion()
    attributes {waveamdmachine.target_waves = 4 : i64} {
  %zero = waveamdmachine.imm 0 : !waveamdmachine.imm
  %ag = waveamdmachine.uninit : !waveamdmachine.reg<agpr, 121>
  %p = waveamdmachine.uninit : !waveamdmachine.reg<vgpr, 1>
  %v0 = waveamdmachine.v_mov_b32_tuple %zero {registers = 1 : i64}
      : (!waveamdmachine.imm) -> !waveamdmachine.reg<vgpr, 1>
  %v1 = waveamdmachine.v_mov_b32_tuple %zero {registers = 1 : i64}
      : (!waveamdmachine.imm) -> !waveamdmachine.reg<vgpr, 1>
  %v2 = waveamdmachine.v_mov_b32_tuple %zero {registers = 1 : i64}
      : (!waveamdmachine.imm) -> !waveamdmachine.reg<vgpr, 1>
  %v3 = waveamdmachine.v_mov_b32_tuple %zero {registers = 1 : i64}
      : (!waveamdmachine.imm) -> !waveamdmachine.reg<vgpr, 1>
  %use = waveamdmachine.v_add_u32 %p, %v0
      : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>)
        -> !waveamdmachine.reg<vgpr, 1>
  %sum0 = waveamdmachine.v_add_u32 %v1, %v2
      : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>)
        -> !waveamdmachine.reg<vgpr, 1>
  %sum1 = waveamdmachine.v_add_u32 %sum0, %v3
      : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>)
        -> !waveamdmachine.reg<vgpr, 1>
  %sum2 = waveamdmachine.v_add_u32 %use, %sum1
      : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>)
        -> !waveamdmachine.reg<vgpr, 1>
  %parts:2 = waveamdmachine.tuple_to_elements %ag
      : (!waveamdmachine.reg<agpr, 121>)
      -> (!waveamdmachine.reg<agpr, 60>, !waveamdmachine.reg<agpr, 61>)
  waveamdmachine.s_endpgm
  return
}

}
