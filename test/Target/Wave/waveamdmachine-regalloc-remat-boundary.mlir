// RUN: wave-opt --waveamd-reg-alloc='mark-overflow=true' \
// RUN:   --waveamd-resource-info %s | FileCheck %s

module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx90a"} {

// CHECK-LABEL: func.func @combined_pressure_remat_reuses_live_intermediate
// CHECK-SAME: waveamdmachine.regalloc_overflowed = 1 : i64
// CHECK: [[ZERO:%.*]] = waveamdmachine.imm 0
// CHECK: [[ONE:%.*]] = waveamdmachine.imm 1
// CHECK: [[SEVEN:%.*]] = waveamdmachine.imm 7
// CHECK: [[LANE:%.*]] = waveamdmachine.v_mov_b32_tuple [[ZERO]]
// CHECK: [[MUL:%.*]] = waveamdmachine.v_mul_lo_u32 [[LANE]], [[SEVEN]]
// CHECK-NOT: waveamdmachine.v_mul_lo_u32
// CHECK: [[ADDR:%.*]] = waveamdmachine.v_lshlrev_b32 [[MUL]], [[ONE]]
// CHECK: waveamdmachine.v_add_u32 {{.*}}, [[ADDR]]
// CHECK: waveamdmachine.v_mul_lo_u32
// CHECK: waveamdmachine.v_readfirstlane_b32
func.func @combined_pressure_remat_reuses_live_intermediate()
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
  %first = waveamdmachine.v_readfirstlane_b32 %mul
      : (!waveamdmachine.reg<vgpr, 1>) -> !waveamdmachine.reg<sgpr, 1>
  %parts:2 = waveamdmachine.tuple_to_elements %ag
      : (!waveamdmachine.reg<agpr, 120>)
      -> (!waveamdmachine.reg<agpr, 60>, !waveamdmachine.reg<agpr, 60>)
  waveamdmachine.s_endpgm
  return
}

// CHECK-LABEL: func.func @combined_pressure_loop_weight_prefers_outer_use
// CHECK-SAME: waveamdmachine.regalloc_assignments
// CHECK: [[ZERO:%.*]] = waveamdmachine.imm 0
// CHECK: [[ONE:%.*]] = waveamdmachine.imm 1
// CHECK: [[SEVEN:%.*]] = waveamdmachine.imm 7
// CHECK: [[A0:%.*]] = waveamdmachine.v_mov_b32_tuple [[ZERO]]
// CHECK: [[A1:%.*]] = waveamdmachine.v_mul_lo_u32 [[A0]], [[SEVEN]]
// CHECK: [[A2:%.*]] = waveamdmachine.v_lshlrev_b32 [[A1]], [[ONE]]
// CHECK: waveamdmachine.uniform_loop
// CHECK: waveamdmachine.uniform_loop
// CHECK-NOT: waveamdmachine.v_mul_lo_u32
// CHECK: waveamdmachine.continue_if
// CHECK: waveamdmachine.continue_if
// CHECK: [[B0:%.*]] = waveamdmachine.v_mov_b32_tuple [[ZERO]]
// CHECK: [[B1:%.*]] = waveamdmachine.v_mul_lo_u32 [[B0]], [[SEVEN]]
// CHECK: [[B2:%.*]] = waveamdmachine.v_lshlrev_b32 [[B1]], [[ONE]]
// CHECK: [[B3:%.*]] = waveamdmachine.v_lshlrev_b32 [[B2]], [[ONE]]
// CHECK: [[B4:%.*]] = waveamdmachine.v_lshlrev_b32 [[B3]], [[ONE]]
// CHECK: [[B5:%.*]] = waveamdmachine.v_lshlrev_b32 [[B4]], [[ONE]]
// CHECK: waveamdmachine.v_readfirstlane_b32 [[B5]]
func.func @combined_pressure_loop_weight_prefers_outer_use()
    attributes {waveamdmachine.target_waves = 4 : i64} {
  %zero = waveamdmachine.imm 0 : !waveamdmachine.imm
  %one = waveamdmachine.imm 1 : !waveamdmachine.imm
  %seven = waveamdmachine.imm 7 : !waveamdmachine.imm
  %ag = waveamdmachine.uninit : !waveamdmachine.reg<agpr, 120>
  %a0 = waveamdmachine.v_mov_b32_tuple %zero {registers = 1 : i64}
      : (!waveamdmachine.imm) -> !waveamdmachine.reg<vgpr, 1>
  %a1 = waveamdmachine.v_mul_lo_u32 %a0, %seven
      : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.imm)
        -> !waveamdmachine.reg<vgpr, 1>
  %a2 = waveamdmachine.v_lshlrev_b32 %a1, %one
      : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.imm)
        -> !waveamdmachine.reg<vgpr, 1>
  %b0 = waveamdmachine.v_mov_b32_tuple %zero {registers = 1 : i64}
      : (!waveamdmachine.imm) -> !waveamdmachine.reg<vgpr, 1>
  %b1 = waveamdmachine.v_mul_lo_u32 %b0, %seven
      : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.imm)
        -> !waveamdmachine.reg<vgpr, 1>
  %b2 = waveamdmachine.v_lshlrev_b32 %b1, %one
      : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.imm)
        -> !waveamdmachine.reg<vgpr, 1>
  %b3 = waveamdmachine.v_lshlrev_b32 %b2, %one
      : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.imm)
        -> !waveamdmachine.reg<vgpr, 1>
  %b4 = waveamdmachine.v_lshlrev_b32 %b3, %one
      : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.imm)
        -> !waveamdmachine.reg<vgpr, 1>
  %b5 = waveamdmachine.v_lshlrev_b32 %b4, %one
      : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.imm)
        -> !waveamdmachine.reg<vgpr, 1>
  %ec = waveamdmachine.s_cmp_lt_i32 %zero, %one
      : (!waveamdmachine.imm, !waveamdmachine.imm) -> !waveamdmachine.reg<scc, 1>
  waveamdmachine.uniform_loop if %ec : !waveamdmachine.reg<scc, 1> {
    waveamdmachine.uniform_loop if %ec : !waveamdmachine.reg<scc, 1> {
      %v0 = waveamdmachine.uninit : !waveamdmachine.reg<vgpr, 1>
      %v1 = waveamdmachine.uninit : !waveamdmachine.reg<vgpr, 1>
      %v2 = waveamdmachine.uninit : !waveamdmachine.reg<vgpr, 1>
      %v3 = waveamdmachine.uninit : !waveamdmachine.reg<vgpr, 1>
      %v4 = waveamdmachine.uninit : !waveamdmachine.reg<vgpr, 1>
      %v5 = waveamdmachine.uninit : !waveamdmachine.reg<vgpr, 1>
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
      %u4 = waveamdmachine.v_add_u32 %u2, %u3
          : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>)
            -> !waveamdmachine.reg<vgpr, 1>
      %u5 = waveamdmachine.v_add_u32 %u4, %a2
          : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>)
            -> !waveamdmachine.reg<vgpr, 1>
      waveamdmachine.continue_if %ec : !waveamdmachine.reg<scc, 1>
    }
    waveamdmachine.continue_if %ec : !waveamdmachine.reg<scc, 1>
  }
  %use_b = waveamdmachine.v_readfirstlane_b32 %b5
      : (!waveamdmachine.reg<vgpr, 1>) -> !waveamdmachine.reg<sgpr, 1>
  %parts:2 = waveamdmachine.tuple_to_elements %ag
      : (!waveamdmachine.reg<agpr, 120>)
      -> (!waveamdmachine.reg<agpr, 60>, !waveamdmachine.reg<agpr, 60>)
  waveamdmachine.s_endpgm
  return
}

}
