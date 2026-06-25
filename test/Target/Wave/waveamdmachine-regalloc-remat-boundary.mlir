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

// CHECK-LABEL: func.func @combined_pressure_remat_tuple_keeps_template_operands
// CHECK-SAME: waveamdmachine.regalloc_assignments
// CHECK: [[RT_ZERO:%.*]] = waveamdmachine.imm 0
// CHECK: waveamdmachine.uninit
// CHECK: [[RT_V0:%.*]] = waveamdmachine.v_mov_b32_tuple [[RT_ZERO]]
// CHECK-NEXT: [[RT_V1:%.*]] = waveamdmachine.v_mov_b32_tuple [[RT_ZERO]]
// CHECK-NEXT: waveamdmachine.v_add_u32 [[RT_V0]], [[RT_V1]]
// CHECK-NEXT: [[RT_LO:%.*]] = waveamdmachine.v_mov_b32_tuple [[RT_ZERO]]
// CHECK-NEXT: [[RT_HI:%.*]] = waveamdmachine.v_mov_b32_tuple [[RT_ZERO]]
// CHECK-NEXT: [[RT_TUPLE:%.*]] = waveamdmachine.tuple_from_elements [[RT_LO]], [[RT_HI]]
// CHECK-NEXT: waveamdmachine.v_accvgpr_write_b32_tuple [[RT_TUPLE]]
func.func @combined_pressure_remat_tuple_keeps_template_operands()
    attributes {waveamdmachine.target_waves = 4 : i64} {
  %zero = waveamdmachine.imm 0 : !waveamdmachine.imm
  %ag = waveamdmachine.uninit : !waveamdmachine.reg<agpr, 112>
  %lo = waveamdmachine.v_mov_b32_tuple %zero {registers = 4 : i64}
      : (!waveamdmachine.imm) -> !waveamdmachine.reg<vgpr, 4>
  %hi = waveamdmachine.v_mov_b32_tuple %zero {registers = 4 : i64}
      : (!waveamdmachine.imm) -> !waveamdmachine.reg<vgpr, 4>
  %tuple = waveamdmachine.tuple_from_elements %lo, %hi
      : (!waveamdmachine.reg<vgpr, 4>, !waveamdmachine.reg<vgpr, 4>)
        -> !waveamdmachine.reg<vgpr, 8>
  %v0 = waveamdmachine.v_mov_b32_tuple %zero {registers = 1 : i64}
      : (!waveamdmachine.imm) -> !waveamdmachine.reg<vgpr, 1>
  %v1 = waveamdmachine.v_mov_b32_tuple %zero {registers = 1 : i64}
      : (!waveamdmachine.imm) -> !waveamdmachine.reg<vgpr, 1>
  %u0 = waveamdmachine.v_add_u32 %v0, %v1
      : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>)
        -> !waveamdmachine.reg<vgpr, 1>
  %acc = waveamdmachine.v_accvgpr_write_b32_tuple %tuple
      : (!waveamdmachine.reg<vgpr, 8>) -> !waveamdmachine.reg<agpr, 8>
  %read = waveamdmachine.v_accvgpr_read_b32_tuple %acc
      : (!waveamdmachine.reg<agpr, 8>) -> !waveamdmachine.reg<vgpr, 8>
  %parts:2 = waveamdmachine.tuple_to_elements %ag
      : (!waveamdmachine.reg<agpr, 112>)
      -> (!waveamdmachine.reg<agpr, 56>, !waveamdmachine.reg<agpr, 56>)
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

// CHECK-LABEL: func.func @loop_init_recursive_remat
// CHECK-SAME: waveamdmachine.regalloc_assignments
// CHECK: [[LIR_ZERO:%.*]] = waveamdmachine.imm 0
// CHECK: [[LIR_ONE:%.*]] = waveamdmachine.imm 1
// CHECK: [[LIR_SEVEN:%.*]] = waveamdmachine.imm 7
// CHECK: [[LIR_GAP0:%.*]] = waveamdmachine.uninit
// CHECK: [[LIR_GAP1:%.*]] = waveamdmachine.uninit
// CHECK: [[LIR_GAP:%.*]] = waveamdmachine.v_add_u32 [[LIR_GAP0]], [[LIR_GAP1]]
// CHECK-NEXT: [[LIR_LANE:%.*]] = waveamdmachine.v_mov_b32_tuple [[LIR_ZERO]]
// CHECK-NEXT: [[LIR_MUL:%.*]] = waveamdmachine.v_mul_lo_u32 [[LIR_LANE]], [[LIR_SEVEN]]
// CHECK-NEXT: [[LIR_ADDR:%.*]] = waveamdmachine.v_lshlrev_b32 [[LIR_MUL]], [[LIR_ONE]]
// CHECK-NEXT: waveamdmachine.uniform_loop {{.*}} carries([[LIR_ADDR]]
func.func @loop_init_recursive_remat()
    attributes {wave.kernel, waveamdmachine.target_waves = 4 : i64} {
  %zero = waveamdmachine.imm 0 : !waveamdmachine.imm
  %one = waveamdmachine.imm 1 : !waveamdmachine.imm
  %seven = waveamdmachine.imm 7 : !waveamdmachine.imm
  %cond = waveamdmachine.s_cmp_lt_i32 %zero, %one
      : (!waveamdmachine.imm, !waveamdmachine.imm)
        -> !waveamdmachine.reg<scc, 1>
  %lane = waveamdmachine.v_mov_b32_tuple %zero {registers = 1 : i64}
      : (!waveamdmachine.imm) -> !waveamdmachine.reg<vgpr, 1>
  %mul = waveamdmachine.v_mul_lo_u32 %lane, %seven
      : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.imm)
        -> !waveamdmachine.reg<vgpr, 1>
  %addr = waveamdmachine.v_lshlrev_b32 %mul, %one
      : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.imm)
        -> !waveamdmachine.reg<vgpr, 1>
  %addr_pre = waveamdmachine.v_readfirstlane_b32 %addr
      : (!waveamdmachine.reg<vgpr, 1>) -> !waveamdmachine.reg<sgpr, 1>
  %gap0 = waveamdmachine.uninit : !waveamdmachine.reg<vgpr, 1>
  %gap1 = waveamdmachine.uninit : !waveamdmachine.reg<vgpr, 1>
  %gap2 = waveamdmachine.v_add_u32 %gap0, %gap1
      : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>)
        -> !waveamdmachine.reg<vgpr, 1>
  %loop = waveamdmachine.uniform_loop if %cond : !waveamdmachine.reg<scc, 1>
      carries(%addr : !waveamdmachine.reg<vgpr, 1>) {
  ^bb0(%carry: !waveamdmachine.reg<vgpr, 1>):
    %next = waveamdmachine.v_add_u32 %carry, %gap2
        : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>)
          -> !waveamdmachine.reg<vgpr, 1>
    waveamdmachine.continue_if %cond : !waveamdmachine.reg<scc, 1>
        carries(%next : !waveamdmachine.reg<vgpr, 1>)
  } -> !waveamdmachine.reg<vgpr, 1>
  %use = waveamdmachine.v_readfirstlane_b32 %loop
      : (!waveamdmachine.reg<vgpr, 1>) -> !waveamdmachine.reg<sgpr, 1>
  waveamdmachine.s_endpgm
  return
}

// CHECK-LABEL: func.func @duplicate_nonadjacent_loop_init_remat
// CHECK-SAME: waveamdmachine.regalloc_assignments
// CHECK: [[DN_ZERO:%.*]] = waveamdmachine.imm 0
// CHECK: [[DN_ONE:%.*]] = waveamdmachine.imm 1
// CHECK: [[DN_ORIG_LANE:%.*]] = waveamdmachine.v_mov_b32_tuple [[DN_ZERO]]
// CHECK-NEXT: [[DN_ORIG_ADDR:%.*]] = waveamdmachine.v_add_u32 [[DN_ORIG_LANE]], [[DN_ONE]]
// CHECK-NEXT: waveamdmachine.v_readfirstlane_b32 [[DN_ORIG_ADDR]]
// CHECK-NEXT: [[DN_GAP:%.*]] = waveamdmachine.v_mov_b32_tuple [[DN_ZERO]]
// CHECK-NEXT: [[DN_LANE0:%.*]] = waveamdmachine.v_mov_b32_tuple [[DN_ZERO]]
// CHECK-NEXT: [[DN_ADDR0:%.*]] = waveamdmachine.v_add_u32 [[DN_LANE0]], [[DN_ONE]]
// CHECK-NEXT: [[DN_LANE1:%.*]] = waveamdmachine.v_mov_b32_tuple [[DN_ZERO]]
// CHECK-NEXT: [[DN_ADDR1:%.*]] = waveamdmachine.v_add_u32 [[DN_LANE1]], [[DN_ONE]]
// CHECK-NEXT: waveamdmachine.uniform_loop {{.*}} carries([[DN_ADDR0]], [[DN_ADDR1]]
func.func @duplicate_nonadjacent_loop_init_remat()
    attributes {wave.kernel, waveamdmachine.target_waves = 4 : i64} {
  %zero = waveamdmachine.imm 0 : !waveamdmachine.imm
  %one = waveamdmachine.imm 1 : !waveamdmachine.imm
  %cond = waveamdmachine.s_cmp_lt_i32 %zero, %one
      : (!waveamdmachine.imm, !waveamdmachine.imm)
        -> !waveamdmachine.reg<scc, 1>
  %lane = waveamdmachine.v_mov_b32_tuple %zero {registers = 1 : i64}
      : (!waveamdmachine.imm) -> !waveamdmachine.reg<vgpr, 1>
  %addr = waveamdmachine.v_add_u32 %lane, %one
      : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.imm)
        -> !waveamdmachine.reg<vgpr, 1>
  %addr_pre = waveamdmachine.v_readfirstlane_b32 %addr
      : (!waveamdmachine.reg<vgpr, 1>) -> !waveamdmachine.reg<sgpr, 1>
  %gap = waveamdmachine.v_mov_b32_tuple %zero {registers = 1 : i64}
      : (!waveamdmachine.imm) -> !waveamdmachine.reg<vgpr, 1>
  %loop:2 = waveamdmachine.uniform_loop if %cond
      : !waveamdmachine.reg<scc, 1>
      carries(%addr, %addr :
              !waveamdmachine.reg<vgpr, 1>,
              !waveamdmachine.reg<vgpr, 1>) {
  ^bb0(%carry0: !waveamdmachine.reg<vgpr, 1>,
       %carry1: !waveamdmachine.reg<vgpr, 1>):
    %next0 = waveamdmachine.v_add_u32 %carry0, %gap
        : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>)
          -> !waveamdmachine.reg<vgpr, 1>
    waveamdmachine.continue_if %cond : !waveamdmachine.reg<scc, 1>
        carries(%next0, %carry1 :
                !waveamdmachine.reg<vgpr, 1>,
                !waveamdmachine.reg<vgpr, 1>)
  } -> !waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>
  %use0 = waveamdmachine.v_readfirstlane_b32 %loop#0
      : (!waveamdmachine.reg<vgpr, 1>) -> !waveamdmachine.reg<sgpr, 1>
  %use1 = waveamdmachine.v_readfirstlane_b32 %loop#1
      : (!waveamdmachine.reg<vgpr, 1>) -> !waveamdmachine.reg<sgpr, 1>
  waveamdmachine.s_endpgm
  return
}

}
