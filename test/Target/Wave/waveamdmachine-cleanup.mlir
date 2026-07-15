// RUN: wave-opt --split-input-file --waveamd-machine-cleanup --cse %s | FileCheck %s

module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx950"} {

// CHECK-LABEL: func.func @reuse_uniform_workitem_shift(
// CHECK-SAME: [[LANE:%[^:]+]]: !waveamdmachine.reg<vgpr, 1>
// CHECK-DAG: [[S6:%.*]] = waveamdmachine.imm 6
// CHECK-DAG: [[S14:%.*]] = waveamdmachine.imm 14
// CHECK: [[WI:%.*]] = waveamdmachine.v_workitem_id_x
// CHECK: [[FIRST:%.*]] = waveamdmachine.v_readfirstlane_b32 [[WI]]
// CHECK: [[WAVE:%.*]], %{{.*}} = waveamdmachine.s_lshr_b32 [[FIRST]], [[S6]]
// CHECK: [[VEC:%.*]] = waveamdmachine.v_lshrrev_b32 [[WI]], [[S6]]
// CHECK: [[ADDR:%.*]] = waveamdmachine.v_lshl_add_u32 [[WAVE]], [[S14]], [[LANE]]
// CHECK: return [[ADDR]], [[VEC]]
func.func @reuse_uniform_workitem_shift(%lane: !waveamdmachine.reg<vgpr, 1>)
    -> (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>)
    attributes {wave.workgroup_size = array<i32: 64, 1, 1>} {
  %s6 = waveamdmachine.imm 6 : !waveamdmachine.imm
  %s14 = waveamdmachine.imm 14 : !waveamdmachine.imm
  %wi = waveamdmachine.v_workitem_id_x : !waveamdmachine.reg<vgpr, 1, 0>
  %first = waveamdmachine.v_readfirstlane_b32 %wi
      : (!waveamdmachine.reg<vgpr, 1, 0>) -> !waveamdmachine.reg<sgpr, 1>
  %wave, %scc = waveamdmachine.s_lshr_b32 %first, %s6
      : (!waveamdmachine.reg<sgpr, 1>, !waveamdmachine.imm)
        -> (!waveamdmachine.reg<sgpr, 1>, !waveamdmachine.reg<scc, 1>)
  %wide = waveamdmachine.v_lshrrev_b32 %wi, %s6
      : (!waveamdmachine.reg<vgpr, 1, 0>, !waveamdmachine.imm)
        -> !waveamdmachine.reg<vgpr, 1>
  %addr = waveamdmachine.v_lshl_add_u32 %wide, %s14, %lane
      : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.imm,
         !waveamdmachine.reg<vgpr, 1>) -> !waveamdmachine.reg<vgpr, 1>
  return %addr, %wide
      : !waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>
}

// CHECK-LABEL: func.func @keep_lane_varying_workitem_shift(
// CHECK-SAME: [[LANE:%[^:]+]]: !waveamdmachine.reg<vgpr, 1>
// CHECK-DAG: [[S5:%.*]] = waveamdmachine.imm 5
// CHECK-DAG: [[S14:%.*]] = waveamdmachine.imm 14
// CHECK: [[WI:%.*]] = waveamdmachine.v_workitem_id_x
// CHECK: [[WIDE:%.*]] = waveamdmachine.v_lshrrev_b32 [[WI]], [[S5]]
// CHECK: [[ADDR:%.*]] = waveamdmachine.v_lshl_add_u32 [[WIDE]], [[S14]], [[LANE]]
// CHECK: return [[ADDR]]
func.func @keep_lane_varying_workitem_shift(%lane: !waveamdmachine.reg<vgpr, 1>)
    -> !waveamdmachine.reg<vgpr, 1>
    attributes {wave.workgroup_size = array<i32: 64, 1, 1>} {
  %s5 = waveamdmachine.imm 5 : !waveamdmachine.imm
  %s14 = waveamdmachine.imm 14 : !waveamdmachine.imm
  %wi = waveamdmachine.v_workitem_id_x : !waveamdmachine.reg<vgpr, 1, 0>
  %first = waveamdmachine.v_readfirstlane_b32 %wi
      : (!waveamdmachine.reg<vgpr, 1, 0>) -> !waveamdmachine.reg<sgpr, 1>
  %wave, %scc = waveamdmachine.s_lshr_b32 %first, %s5
      : (!waveamdmachine.reg<sgpr, 1>, !waveamdmachine.imm)
        -> (!waveamdmachine.reg<sgpr, 1>, !waveamdmachine.reg<scc, 1>)
  %wide = waveamdmachine.v_lshrrev_b32 %wi, %s5
      : (!waveamdmachine.reg<vgpr, 1, 0>, !waveamdmachine.imm)
        -> !waveamdmachine.reg<vgpr, 1>
  %addr = waveamdmachine.v_lshl_add_u32 %wide, %s14, %lane
      : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.imm,
         !waveamdmachine.reg<vgpr, 1>) -> !waveamdmachine.reg<vgpr, 1>
  return %addr : !waveamdmachine.reg<vgpr, 1>
}

// CHECK-LABEL: func.func @keep_non_x_linear_workitem_shift(
// CHECK-SAME: [[LANE:%[^:]+]]: !waveamdmachine.reg<vgpr, 1>
// CHECK-DAG: [[S6:%.*]] = waveamdmachine.imm 6
// CHECK-DAG: [[S14:%.*]] = waveamdmachine.imm 14
// CHECK: [[WI:%.*]] = waveamdmachine.v_workitem_id_x
// CHECK: [[WIDE:%.*]] = waveamdmachine.v_lshrrev_b32 [[WI]], [[S6]]
// CHECK: [[ADDR:%.*]] = waveamdmachine.v_lshl_add_u32 [[WIDE]], [[S14]], [[LANE]]
// CHECK: return [[ADDR]]
func.func @keep_non_x_linear_workitem_shift(%lane: !waveamdmachine.reg<vgpr, 1>)
    -> !waveamdmachine.reg<vgpr, 1>
    attributes {wave.workgroup_size = array<i32: 16, 4, 1>} {
  %s6 = waveamdmachine.imm 6 : !waveamdmachine.imm
  %s14 = waveamdmachine.imm 14 : !waveamdmachine.imm
  %wi = waveamdmachine.v_workitem_id_x : !waveamdmachine.reg<vgpr, 1, 0>
  %first = waveamdmachine.v_readfirstlane_b32 %wi
      : (!waveamdmachine.reg<vgpr, 1, 0>) -> !waveamdmachine.reg<sgpr, 1>
  %wave, %scc = waveamdmachine.s_lshr_b32 %first, %s6
      : (!waveamdmachine.reg<sgpr, 1>, !waveamdmachine.imm)
        -> (!waveamdmachine.reg<sgpr, 1>, !waveamdmachine.reg<scc, 1>)
  %wide = waveamdmachine.v_lshrrev_b32 %wi, %s6
      : (!waveamdmachine.reg<vgpr, 1, 0>, !waveamdmachine.imm)
        -> !waveamdmachine.reg<vgpr, 1>
  %addr = waveamdmachine.v_lshl_add_u32 %wide, %s14, %lane
      : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.imm,
         !waveamdmachine.reg<vgpr, 1>) -> !waveamdmachine.reg<vgpr, 1>
  return %addr : !waveamdmachine.reg<vgpr, 1>
}

// CHECK-LABEL: func.func @fold_vcc_cndmask(
// CHECK-SAME: [[A:%[^:]+]]: !waveamdmachine.reg<vgpr, 1>
// CHECK-SAME: [[B:%[^:]+]]: !waveamdmachine.reg<vgpr, 1>
// CHECK-SAME: [[FALSE:%[^:]+]]: !waveamdmachine.reg<vgpr, 1>
// CHECK-SAME: [[TRUE:%[^:]+]]: !waveamdmachine.reg<vgpr, 1>
// CHECK: %{{.*}}, [[VCC:%.*]] = waveamdmachine.v_cmp_lt_u32_vcc [[A]], [[B]]
// CHECK-NEXT: [[SEL:%.*]] = waveamdmachine.v_cndmask_b32_vcc [[FALSE]], [[TRUE]], [[VCC]]
// CHECK-NEXT: return [[SEL]]
func.func @fold_vcc_cndmask(%a: !waveamdmachine.reg<vgpr, 1>,
                            %b: !waveamdmachine.reg<vgpr, 1>,
                            %false: !waveamdmachine.reg<vgpr, 1>,
                            %true: !waveamdmachine.reg<vgpr, 1>)
    -> !waveamdmachine.reg<vgpr, 1> {
  %mask, %vcc = waveamdmachine.v_cmp_lt_u32_vcc %a, %b
      : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>)
        -> (!waveamdmachine.reg<sgpr, 2>, !waveamdmachine.reg<vcc, 1>)
  %sel = waveamdmachine.v_cndmask_b32_tuple %false, %true, %mask
      : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>,
         !waveamdmachine.reg<sgpr, 2>) -> !waveamdmachine.reg<vgpr, 1>
  return %sel : !waveamdmachine.reg<vgpr, 1>
}

// CHECK-LABEL: func.func @fold_vcc_cndmask_immediates(
// CHECK-DAG: [[FALSE:%.*]] = waveamdmachine.imm 0
// CHECK-DAG: [[TRUE_IMM:%.*]] = waveamdmachine.imm 1
// CHECK: %{{.*}}, [[VCC:%.*]] = waveamdmachine.v_cmp_lt_u32_vcc
// CHECK-NEXT: [[TRUE:%.*]] = waveamdmachine.v_mov_b32_tuple [[TRUE_IMM]]
// CHECK-NEXT: [[SEL:%.*]] = waveamdmachine.v_cndmask_b32_vcc [[FALSE]], [[TRUE]], [[VCC]]
// CHECK-NEXT: return [[SEL]]
func.func @fold_vcc_cndmask_immediates(%a: !waveamdmachine.reg<vgpr, 1>,
                                       %b: !waveamdmachine.reg<vgpr, 1>)
    -> !waveamdmachine.reg<vgpr, 1> {
  %false = waveamdmachine.imm 0 : !waveamdmachine.imm
  %true = waveamdmachine.imm 1 : !waveamdmachine.imm
  %mask, %vcc = waveamdmachine.v_cmp_lt_u32_vcc %a, %b
      : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>)
        -> (!waveamdmachine.reg<sgpr, 2>, !waveamdmachine.reg<vcc, 1>)
  %sel = waveamdmachine.v_cndmask_b32_tuple %false, %true, %mask
      : (!waveamdmachine.imm, !waveamdmachine.imm,
         !waveamdmachine.reg<sgpr, 2>) -> !waveamdmachine.reg<vgpr, 1>
  return %sel : !waveamdmachine.reg<vgpr, 1>
}

}

// -----

module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx950"} {

// CHECK-LABEL: func.func @keep_intervening_vcc_writer(
// CHECK: [[MASK:%.*]], %{{.*}} = waveamdmachine.v_cmp_lt_u32_vcc
// CHECK-NEXT: [[SUM:%.*]], %{{.*}} = waveamdmachine.v_add_u32_vcc
// CHECK-NEXT: [[SEL:%.*]] = waveamdmachine.v_cndmask_b32_tuple {{.*}}, {{.*}}, [[MASK]]
// CHECK-NEXT: return [[SEL]], [[SUM]]
func.func @keep_intervening_vcc_writer(%a: !waveamdmachine.reg<vgpr, 1>,
                                       %b: !waveamdmachine.reg<vgpr, 1>,
                                       %false: !waveamdmachine.reg<vgpr, 1>,
                                       %true: !waveamdmachine.reg<vgpr, 1>)
    -> (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>) {
  %mask, %vcc0 = waveamdmachine.v_cmp_lt_u32_vcc %a, %b
      : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>)
        -> (!waveamdmachine.reg<sgpr, 2>, !waveamdmachine.reg<vcc, 1>)
  %sum, %vcc1 = waveamdmachine.v_add_u32_vcc %a, %b
      : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>)
        -> (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vcc, 1>)
  %sel = waveamdmachine.v_cndmask_b32_tuple %false, %true, %mask
      : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>,
         !waveamdmachine.reg<sgpr, 2>) -> !waveamdmachine.reg<vgpr, 1>
  return %sel, %sum : !waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>
}

}

// -----

module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx950"} {

// CHECK-LABEL: func.func @keep_nested_vcc_writer(
// CHECK: [[MASK:%.*]], %{{.*}} = waveamdmachine.v_cmp_lt_u32_vcc
// CHECK: waveamdmachine.uniform_if
// CHECK: waveamdmachine.v_add_u32_vcc
// CHECK: [[SEL:%.*]] = waveamdmachine.v_cndmask_b32_tuple {{.*}}, {{.*}}, [[MASK]]
// CHECK-NEXT: return [[SEL]],
func.func @keep_nested_vcc_writer(
    %cond: !waveamdmachine.reg<scc, 1>,
    %a: !waveamdmachine.reg<vgpr, 1>,
    %b: !waveamdmachine.reg<vgpr, 1>,
    %false: !waveamdmachine.reg<vgpr, 1>,
    %true: !waveamdmachine.reg<vgpr, 1>)
    -> (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>) {
  %mask, %vcc0 = waveamdmachine.v_cmp_lt_u32_vcc %a, %b
      : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>)
        -> (!waveamdmachine.reg<sgpr, 2>, !waveamdmachine.reg<vcc, 1>)
  %nested = waveamdmachine.uniform_if %cond {
    %sum, %vcc1 = waveamdmachine.v_add_u32_vcc %a, %b
        : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>)
          -> (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vcc, 1>)
    waveamdmachine.yield %sum : !waveamdmachine.reg<vgpr, 1>
  } otherwise {
    waveamdmachine.yield %a : !waveamdmachine.reg<vgpr, 1>
  } : !waveamdmachine.reg<scc, 1> -> !waveamdmachine.reg<vgpr, 1>
  %sel = waveamdmachine.v_cndmask_b32_tuple %false, %true, %mask
      : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>,
         !waveamdmachine.reg<sgpr, 2>) -> !waveamdmachine.reg<vgpr, 1>
  return %sel, %nested
      : !waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>
}

}

// -----

module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx950"} {

// CHECK-LABEL: func.func @hoist_exec_if_local_addr(
// CHECK-SAME: [[COND:%[^:]+]]: !waveamdmachine.reg<sgpr, 1>
// CHECK-SAME: [[X:%[^:]+]]: !waveamdmachine.reg<vgpr, 1>
// CHECK: [[SHIFT:%.*]] = waveamdmachine.imm 12
// CHECK-NEXT: [[ADDR:%.*]] = waveamdmachine.v_lshlrev_b32 [[SHIFT]], [[X]]
// CHECK-NEXT: waveamdmachine.exec_if [[COND]] {
// CHECK-NOT: waveamdmachine.v_lshlrev_b32
// CHECK: waveamdmachine.ds_load_b32 [[ADDR]]
// CHECK: waveamdmachine.ds_load_b32 [[ADDR]]
// CHECK: } : !waveamdmachine.reg<sgpr, 1>
func.func @hoist_exec_if_local_addr(%cond: !waveamdmachine.reg<sgpr, 1>,
                                    %x: !waveamdmachine.reg<vgpr, 1>) {
  waveamdmachine.exec_if %cond {
    %shift = waveamdmachine.imm 12 : !waveamdmachine.imm
    %addr0 = waveamdmachine.v_lshlrev_b32 %shift, %x
        : (!waveamdmachine.imm, !waveamdmachine.reg<vgpr, 1>)
        -> !waveamdmachine.reg<vgpr, 1>
    %addr1 = waveamdmachine.v_lshlrev_b32 %shift, %x
        : (!waveamdmachine.imm, !waveamdmachine.reg<vgpr, 1>)
        -> !waveamdmachine.reg<vgpr, 1>
    %load0 = waveamdmachine.ds_load_b32 %addr0
        : (!waveamdmachine.reg<vgpr, 1>) -> !waveamdmachine.reg<vgpr, 1>
    %load1 = waveamdmachine.ds_load_b32 %addr1
        : (!waveamdmachine.reg<vgpr, 1>) -> !waveamdmachine.reg<vgpr, 1>
    waveamdmachine.yield
  } : !waveamdmachine.reg<sgpr, 1>
  return
}

}

// -----

module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx950"} {

// CHECK-LABEL: func.func @keep_packed_f32_mul_add_separate(
// CHECK: [[MUL:%.*]] = waveamdmachine.v_pk_mul_f32
// CHECK: waveamdmachine.v_pk_add_f32 [[MUL]],
// CHECK-NOT: waveamdmachine.v_pk_fma_f32
// CHECK: return
func.func @keep_packed_f32_mul_add_separate(%a: !waveamdmachine.reg<vgpr, 2>,
                                            %b: !waveamdmachine.reg<vgpr, 2>,
                                            %c: !waveamdmachine.reg<vgpr, 2>)
    -> !waveamdmachine.reg<vgpr, 2> {
  %mul = waveamdmachine.v_pk_mul_f32 %a, %b
      : (!waveamdmachine.reg<vgpr, 2>, !waveamdmachine.reg<vgpr, 2>)
        -> !waveamdmachine.reg<vgpr, 2>
  %add = waveamdmachine.v_pk_add_f32 %mul, %c
      : (!waveamdmachine.reg<vgpr, 2>, !waveamdmachine.reg<vgpr, 2>)
        -> !waveamdmachine.reg<vgpr, 2>
  return %add : !waveamdmachine.reg<vgpr, 2>
}

}

// -----

module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx950:sramecc-"} {

// CHECK-LABEL: func.func @d16_byte_pack_preserves_low_sramecc_off(
// CHECK: [[LOW0:%.*]], %{{.*}} = waveamdmachine.buffer_load_u8_d16
// CHECK: [[LOW1:%.*]], %{{.*}} = waveamdmachine.buffer_load_u8_d16
// CHECK-NOT: waveamdmachine.v_mov_b32_tuple
// CHECK: [[PAIR0:%.*]], %{{.*}} = waveamdmachine.buffer_load_u8_d16_hi {{.*}}, [[LOW0]],
// CHECK: [[PAIR1:%.*]], %{{.*}} = waveamdmachine.buffer_load_u8_d16_hi {{.*}}, [[LOW1]],
// CHECK: [[SHIFTED:%.*]] = waveamdmachine.v_lshlrev_b32 [[PAIR1]]
// CHECK: waveamdmachine.v_or_b32 [[PAIR0]], [[SHIFTED]]
func.func @d16_byte_pack_preserves_low_sramecc_off(
    %off0: !waveamdmachine.reg<vgpr, 1>,
    %off1: !waveamdmachine.reg<vgpr, 1>,
    %off2: !waveamdmachine.reg<vgpr, 1>,
    %off3: !waveamdmachine.reg<vgpr, 1>,
    %desc: !waveamdmachine.reg<sgpr, 4>) -> !waveamdmachine.reg<vgpr, 1> {
  %soff = waveamdmachine.imm 0 : !waveamdmachine.imm
  %mask = waveamdmachine.imm 255 : !waveamdmachine.imm
  %s8 = waveamdmachine.imm 8 : !waveamdmachine.imm
  %s16 = waveamdmachine.imm 16 : !waveamdmachine.imm
  %s24 = waveamdmachine.imm 24 : !waveamdmachine.imm
  %b0, %t0 = waveamdmachine.buffer_load_u8 %off0, %desc, %soff
      : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<sgpr, 4>,
         !waveamdmachine.imm)
      -> (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.mem.token)
  %b1, %t1 = waveamdmachine.buffer_load_u8 %off1, %desc, %soff
      : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<sgpr, 4>,
         !waveamdmachine.imm)
      -> (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.mem.token)
  %b2, %t2 = waveamdmachine.buffer_load_u8 %off2, %desc, %soff
      : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<sgpr, 4>,
         !waveamdmachine.imm)
      -> (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.mem.token)
  %b3, %t3 = waveamdmachine.buffer_load_u8 %off3, %desc, %soff
      : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<sgpr, 4>,
         !waveamdmachine.imm)
      -> (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.mem.token)
  %m0 = waveamdmachine.v_and_b32 %b0, %mask
      : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.imm)
      -> !waveamdmachine.reg<vgpr, 1>
  %m1 = waveamdmachine.v_and_b32 %b1, %mask
      : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.imm)
      -> !waveamdmachine.reg<vgpr, 1>
  %m2 = waveamdmachine.v_and_b32 %b2, %mask
      : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.imm)
      -> !waveamdmachine.reg<vgpr, 1>
  %m3 = waveamdmachine.v_and_b32 %b3, %mask
      : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.imm)
      -> !waveamdmachine.reg<vgpr, 1>
  %sh1 = waveamdmachine.v_lshlrev_b32 %m1, %s8
      : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.imm)
      -> !waveamdmachine.reg<vgpr, 1>
  %sh2 = waveamdmachine.v_lshlrev_b32 %m2, %s16
      : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.imm)
      -> !waveamdmachine.reg<vgpr, 1>
  %sh3 = waveamdmachine.v_lshlrev_b32 %m3, %s24
      : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.imm)
      -> !waveamdmachine.reg<vgpr, 1>
  %or0 = waveamdmachine.v_or_b32 %m0, %sh1
      : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>)
      -> !waveamdmachine.reg<vgpr, 1>
  %or1 = waveamdmachine.v_or_b32 %or0, %sh2
      : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>)
      -> !waveamdmachine.reg<vgpr, 1>
  %or2 = waveamdmachine.v_or_b32 %or1, %sh3
      : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>)
      -> !waveamdmachine.reg<vgpr, 1>
  return %or2 : !waveamdmachine.reg<vgpr, 1>
}

}

// -----

module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx950"} {

// CHECK-LABEL: func.func @d16_byte_pack_nested_shifted_half(
// CHECK: [[LOW0:%.*]], %{{.*}} = waveamdmachine.buffer_load_u8_d16
// CHECK: [[LOW1:%.*]], %{{.*}} = waveamdmachine.buffer_load_u8_d16
// CHECK: [[ZERO0:%.*]] = waveamdmachine.v_mov_b32_tuple
// CHECK: [[HI0:%.*]], %{{.*}} = waveamdmachine.buffer_load_u8_d16_hi {{.*}}, [[ZERO0]],
// CHECK: [[HI1:%.*]], %{{.*}} = waveamdmachine.buffer_load_u8_d16_hi {{.*}}, [[ZERO0]],
// CHECK: [[PAIR1:%.*]] = waveamdmachine.v_or_b32 [[LOW1]], [[HI1]]
// CHECK: [[SHIFTED:%.*]] = waveamdmachine.v_lshlrev_b32 [[PAIR1]]
// CHECK: waveamdmachine.v_or3_b32 [[LOW0]], [[HI0]], [[SHIFTED]]
func.func @d16_byte_pack_nested_shifted_half(
    %off0: !waveamdmachine.reg<vgpr, 1>,
    %off1: !waveamdmachine.reg<vgpr, 1>,
    %off2: !waveamdmachine.reg<vgpr, 1>,
    %off3: !waveamdmachine.reg<vgpr, 1>,
    %desc: !waveamdmachine.reg<sgpr, 4>) -> !waveamdmachine.reg<vgpr, 1> {
  %soff = waveamdmachine.imm 0 : !waveamdmachine.imm
  %mask = waveamdmachine.imm 255 : !waveamdmachine.imm
  %s8 = waveamdmachine.imm 8 : !waveamdmachine.imm
  %s16 = waveamdmachine.imm 16 : !waveamdmachine.imm
  %b0, %t0 = waveamdmachine.buffer_load_u8 %off0, %desc, %soff
      : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<sgpr, 4>,
         !waveamdmachine.imm)
      -> (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.mem.token)
  %b1, %t1 = waveamdmachine.buffer_load_u8 %off1, %desc, %soff
      : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<sgpr, 4>,
         !waveamdmachine.imm)
      -> (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.mem.token)
  %b2, %t2 = waveamdmachine.buffer_load_u8 %off2, %desc, %soff
      : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<sgpr, 4>,
         !waveamdmachine.imm)
      -> (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.mem.token)
  %b3, %t3 = waveamdmachine.buffer_load_u8 %off3, %desc, %soff
      : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<sgpr, 4>,
         !waveamdmachine.imm)
      -> (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.mem.token)
  %m0 = waveamdmachine.v_and_b32 %b0, %mask
      : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.imm)
      -> !waveamdmachine.reg<vgpr, 1>
  %m1 = waveamdmachine.v_and_b32 %b1, %mask
      : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.imm)
      -> !waveamdmachine.reg<vgpr, 1>
  %m2 = waveamdmachine.v_and_b32 %b2, %mask
      : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.imm)
      -> !waveamdmachine.reg<vgpr, 1>
  %m3 = waveamdmachine.v_and_b32 %b3, %mask
      : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.imm)
      -> !waveamdmachine.reg<vgpr, 1>
  %sh2 = waveamdmachine.v_lshlrev_b32 %m2, %s16
      : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.imm)
      -> !waveamdmachine.reg<vgpr, 1>
  %sh3 = waveamdmachine.v_lshlrev_b32 %m3, %s16
      : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.imm)
      -> !waveamdmachine.reg<vgpr, 1>
  %even = waveamdmachine.v_or_b32 %m0, %sh2
      : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>)
      -> !waveamdmachine.reg<vgpr, 1>
  %odd = waveamdmachine.v_or_b32 %m1, %sh3
      : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>)
      -> !waveamdmachine.reg<vgpr, 1>
  %shifted = waveamdmachine.v_lshlrev_b32 %odd, %s8
      : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.imm)
      -> !waveamdmachine.reg<vgpr, 1>
  %word = waveamdmachine.v_or_b32 %even, %shifted
      : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>)
      -> !waveamdmachine.reg<vgpr, 1>
  return %word : !waveamdmachine.reg<vgpr, 1>
}

}

// -----

module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx950:sramecc-"} {

// CHECK-LABEL: func.func @d16_loop_carried_existing_pack_sources(
// CHECK: [[LOOP:%.*]]:4 = waveamdmachine.uniform_loop
// CHECK-NOT: waveamdmachine.v_and_b32
// CHECK: [[SHIFTED:%.*]] = waveamdmachine.v_lshlrev_b32 [[LOOP]]#3
// CHECK: [[WORD:%.*]] = waveamdmachine.v_or_b32 [[LOOP]]#2, [[SHIFTED]]
// CHECK: return [[WORD]]
func.func @d16_loop_carried_existing_pack_sources(
    %cond: !waveamdmachine.reg<scc, 1>,
    %off0: !waveamdmachine.reg<vgpr, 1>,
    %off1: !waveamdmachine.reg<vgpr, 1>,
    %off2: !waveamdmachine.reg<vgpr, 1>,
    %off3: !waveamdmachine.reg<vgpr, 1>,
    %desc: !waveamdmachine.reg<sgpr, 4>) -> !waveamdmachine.reg<vgpr, 1> {
  %soff = waveamdmachine.imm 0 : !waveamdmachine.imm
  %mask = waveamdmachine.imm 255 : !waveamdmachine.imm
  %s8 = waveamdmachine.imm 8 : !waveamdmachine.imm
  %s16 = waveamdmachine.imm 16 : !waveamdmachine.imm
  %s24 = waveamdmachine.imm 24 : !waveamdmachine.imm
  %lo0_init, %t0 = waveamdmachine.buffer_load_u8_d16 %off0, %desc, %soff
      : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<sgpr, 4>,
         !waveamdmachine.imm)
      -> (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.mem.token)
  %lo1_init, %t1 = waveamdmachine.buffer_load_u8_d16 %off1, %desc, %soff
      : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<sgpr, 4>,
         !waveamdmachine.imm)
      -> (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.mem.token)
  %hi0_init, %t2 = waveamdmachine.buffer_load_u8_d16_hi
      %off2, %lo0_init, %desc, %soff
      : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>,
         !waveamdmachine.reg<sgpr, 4>, !waveamdmachine.imm)
      -> (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.mem.token)
  %hi1_init, %t3 = waveamdmachine.buffer_load_u8_d16_hi
      %off3, %lo1_init, %desc, %soff
      : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>,
         !waveamdmachine.reg<sgpr, 4>, !waveamdmachine.imm)
      -> (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.mem.token)
  %loop:4 = waveamdmachine.uniform_loop carries(
      %lo0_init, %lo1_init, %hi0_init, %hi1_init :
      !waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>,
      !waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>) {
  ^bb0(%lo0_arg: !waveamdmachine.reg<vgpr, 1>,
       %lo1_arg: !waveamdmachine.reg<vgpr, 1>,
       %hi0_arg: !waveamdmachine.reg<vgpr, 1>,
       %hi1_arg: !waveamdmachine.reg<vgpr, 1>):
    %lo0_next, %t4 = waveamdmachine.buffer_load_u8_d16 %off0, %desc, %soff
        : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<sgpr, 4>,
           !waveamdmachine.imm)
        -> (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.mem.token)
    %lo1_next, %t5 = waveamdmachine.buffer_load_u8_d16 %off1, %desc, %soff
        : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<sgpr, 4>,
           !waveamdmachine.imm)
        -> (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.mem.token)
    %hi0_next, %t6 = waveamdmachine.buffer_load_u8_d16_hi
        %off2, %lo0_next, %desc, %soff
        : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>,
           !waveamdmachine.reg<sgpr, 4>, !waveamdmachine.imm)
        -> (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.mem.token)
    %hi1_next, %t7 = waveamdmachine.buffer_load_u8_d16_hi
        %off3, %lo1_next, %desc, %soff
        : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>,
           !waveamdmachine.reg<sgpr, 4>, !waveamdmachine.imm)
        -> (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.mem.token)
    waveamdmachine.continue_if %cond : !waveamdmachine.reg<scc, 1>
        carries(%lo0_next, %lo1_next, %hi0_next, %hi1_next :
                !waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>,
                !waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>)
  } -> !waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>,
       !waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>
  %m0 = waveamdmachine.v_and_b32 %loop#0, %mask
      : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.imm)
      -> !waveamdmachine.reg<vgpr, 1>
  %m1 = waveamdmachine.v_and_b32 %loop#1, %mask
      : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.imm)
      -> !waveamdmachine.reg<vgpr, 1>
  %m2 = waveamdmachine.v_and_b32 %loop#2, %mask
      : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.imm)
      -> !waveamdmachine.reg<vgpr, 1>
  %m3 = waveamdmachine.v_and_b32 %loop#3, %mask
      : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.imm)
      -> !waveamdmachine.reg<vgpr, 1>
  %sh1 = waveamdmachine.v_lshlrev_b32 %m1, %s8
      : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.imm)
      -> !waveamdmachine.reg<vgpr, 1>
  %sh2 = waveamdmachine.v_lshlrev_b32 %m2, %s16
      : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.imm)
      -> !waveamdmachine.reg<vgpr, 1>
  %sh3 = waveamdmachine.v_lshlrev_b32 %m3, %s24
      : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.imm)
      -> !waveamdmachine.reg<vgpr, 1>
  %or0 = waveamdmachine.v_or_b32 %m0, %sh1
      : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>)
      -> !waveamdmachine.reg<vgpr, 1>
  %or1 = waveamdmachine.v_or_b32 %or0, %sh2
      : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>)
      -> !waveamdmachine.reg<vgpr, 1>
  %or2 = waveamdmachine.v_or_b32 %or1, %sh3
      : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>)
      -> !waveamdmachine.reg<vgpr, 1>
  return %or2 : !waveamdmachine.reg<vgpr, 1>
}

}

// -----

module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx950"} {

// CHECK-LABEL: func.func @scale_loop_shifted_carry(
// CHECK-SAME: [[COND:%[^:]+]]: !waveamdmachine.reg<scc, 1>
// CHECK-SAME: [[INIT:%[^:]+]]: !waveamdmachine.reg<sgpr, 1>
// CHECK-SAME: [[BASE:%[^:]+]]: !waveamdmachine.reg<sgpr, 1>
// CHECK: [[SHIFT:%.*]] = waveamdmachine.imm 1
// CHECK: [[SCALED_INIT:%.*]], %{{.*}} = waveamdmachine.s_lshl_b32 [[INIT]], [[SHIFT]]
// CHECK: [[STEP:%.*]] = waveamdmachine.imm 256
// CHECK: waveamdmachine.uniform_loop carries([[SCALED_INIT]] : !waveamdmachine.reg<sgpr, 1>)
// CHECK: ^bb0([[CARRY:%.*]]: !waveamdmachine.reg<sgpr, 1>):
// CHECK-NOT: waveamdmachine.s_lshl_b32
// CHECK: waveamdmachine.s_add_i32 [[BASE]], [[CARRY]]
// CHECK: [[MID:%.*]], %{{.*}} = waveamdmachine.s_add_i32 [[CARRY]], [[STEP]]
// CHECK-NOT: waveamdmachine.s_lshl_b32
// CHECK: waveamdmachine.s_add_i32 [[BASE]], [[MID]]
// CHECK: [[NEXT:%.*]], %{{.*}} = waveamdmachine.s_add_i32 [[MID]], [[STEP]]
// CHECK: waveamdmachine.continue_if [[COND]] : !waveamdmachine.reg<scc, 1> carries([[NEXT]] : !waveamdmachine.reg<sgpr, 1>)
func.func @scale_loop_shifted_carry(%cond: !waveamdmachine.reg<scc, 1>,
                                    %init: !waveamdmachine.reg<sgpr, 1>,
                                    %base: !waveamdmachine.reg<sgpr, 1>) {
  %one = waveamdmachine.imm 1 : !waveamdmachine.imm
  %step = waveamdmachine.imm 128 : !waveamdmachine.imm
  %loop = waveamdmachine.uniform_loop carries(%init : !waveamdmachine.reg<sgpr, 1>) {
  ^bb0(%iv: !waveamdmachine.reg<sgpr, 1>):
    %scaled0, %scc0 = waveamdmachine.s_lshl_b32 %iv, %one
        : (!waveamdmachine.reg<sgpr, 1>, !waveamdmachine.imm)
            -> (!waveamdmachine.reg<sgpr, 1>, !waveamdmachine.reg<scc, 1>)
    %addr0, %scc1 = waveamdmachine.s_add_i32 %base, %scaled0
        : (!waveamdmachine.reg<sgpr, 1>, !waveamdmachine.reg<sgpr, 1>)
            -> (!waveamdmachine.reg<sgpr, 1>, !waveamdmachine.reg<scc, 1>)
    waveamdmachine.s_mov_b32 "s80", %addr0
        : (!waveamdmachine.reg<sgpr, 1>) -> ()
    %mid, %scc2 = waveamdmachine.s_add_i32 %iv, %step
        : (!waveamdmachine.reg<sgpr, 1>, !waveamdmachine.imm)
            -> (!waveamdmachine.reg<sgpr, 1>, !waveamdmachine.reg<scc, 1>)
    %scaled1, %scc3 = waveamdmachine.s_lshl_b32 %mid, %one
        : (!waveamdmachine.reg<sgpr, 1>, !waveamdmachine.imm)
            -> (!waveamdmachine.reg<sgpr, 1>, !waveamdmachine.reg<scc, 1>)
    %addr1, %scc4 = waveamdmachine.s_add_i32 %base, %scaled1
        : (!waveamdmachine.reg<sgpr, 1>, !waveamdmachine.reg<sgpr, 1>)
            -> (!waveamdmachine.reg<sgpr, 1>, !waveamdmachine.reg<scc, 1>)
    waveamdmachine.s_mov_b32 "s81", %addr1
        : (!waveamdmachine.reg<sgpr, 1>) -> ()
    %next, %scc5 = waveamdmachine.s_add_i32 %mid, %step
        : (!waveamdmachine.reg<sgpr, 1>, !waveamdmachine.imm)
            -> (!waveamdmachine.reg<sgpr, 1>, !waveamdmachine.reg<scc, 1>)
    waveamdmachine.continue_if %cond : !waveamdmachine.reg<scc, 1>
        carries(%next : !waveamdmachine.reg<sgpr, 1>)
  } -> !waveamdmachine.reg<sgpr, 1>
  return
}

}

// -----

module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx950"} {

// CHECK-LABEL: func.func @keep_shifted_carry_with_result_use(
// CHECK-SAME: [[COND:%[^:]+]]: !waveamdmachine.reg<scc, 1>
// CHECK-SAME: [[INIT:%[^:]+]]: !waveamdmachine.reg<sgpr, 1>
// CHECK: [[LOOP:%.*]] = waveamdmachine.uniform_loop carries([[INIT]] : !waveamdmachine.reg<sgpr, 1>)
// CHECK: ^bb0([[IV:%.*]]: !waveamdmachine.reg<sgpr, 1>):
// CHECK: waveamdmachine.s_lshl_b32 [[IV]],
// CHECK: waveamdmachine.continue_if [[COND]]
// CHECK: waveamdmachine.s_add_i32 [[LOOP]], {{.*}} : (!waveamdmachine.reg<sgpr, 1>, !waveamdmachine.imm)
func.func @keep_shifted_carry_with_result_use(%cond: !waveamdmachine.reg<scc, 1>,
                                              %init: !waveamdmachine.reg<sgpr, 1>,
                                              %base: !waveamdmachine.reg<sgpr, 1>) {
  %one = waveamdmachine.imm 1 : !waveamdmachine.imm
  %step = waveamdmachine.imm 128 : !waveamdmachine.imm
  %loop = waveamdmachine.uniform_loop carries(%init : !waveamdmachine.reg<sgpr, 1>) {
  ^bb0(%iv: !waveamdmachine.reg<sgpr, 1>):
    %scaled, %scc0 = waveamdmachine.s_lshl_b32 %iv, %one
        : (!waveamdmachine.reg<sgpr, 1>, !waveamdmachine.imm)
            -> (!waveamdmachine.reg<sgpr, 1>, !waveamdmachine.reg<scc, 1>)
    %addr, %scc1 = waveamdmachine.s_add_i32 %base, %scaled
        : (!waveamdmachine.reg<sgpr, 1>, !waveamdmachine.reg<sgpr, 1>)
            -> (!waveamdmachine.reg<sgpr, 1>, !waveamdmachine.reg<scc, 1>)
    %next, %scc2 = waveamdmachine.s_add_i32 %iv, %step
        : (!waveamdmachine.reg<sgpr, 1>, !waveamdmachine.imm)
            -> (!waveamdmachine.reg<sgpr, 1>, !waveamdmachine.reg<scc, 1>)
    waveamdmachine.continue_if %cond : !waveamdmachine.reg<scc, 1>
        carries(%next : !waveamdmachine.reg<sgpr, 1>)
  } -> !waveamdmachine.reg<sgpr, 1>
  %use, %scc3 = waveamdmachine.s_add_i32 %loop, %step
      : (!waveamdmachine.reg<sgpr, 1>, !waveamdmachine.imm)
          -> (!waveamdmachine.reg<sgpr, 1>, !waveamdmachine.reg<scc, 1>)
  waveamdmachine.s_mov_b32 "s82", %use
      : (!waveamdmachine.reg<sgpr, 1>) -> ()
  return
}

}

// -----

module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx950"} {

// CHECK-LABEL: func.func @keep_yielded_value(
// CHECK-SAME: [[COND:%[^:]+]]: !waveamdmachine.reg<sgpr, 1>
// CHECK-SAME: [[X:%[^:]+]]: !waveamdmachine.reg<vgpr, 1>
// CHECK: [[SHIFT:%.*]] = waveamdmachine.imm 12
// CHECK-NEXT: [[VALUE:%.*]] = waveamdmachine.exec_if [[COND]] {
// CHECK-NEXT: [[ADDR:%.*]] = waveamdmachine.v_lshlrev_b32 [[SHIFT]], [[X]]
// CHECK-NEXT: waveamdmachine.yield [[ADDR]]
// CHECK: [[SUM:%.*]] = waveamdmachine.v_add_u32 [[VALUE]], [[X]]
// CHECK-NEXT: waveamdmachine.ds_load_b32 [[SUM]]
func.func @keep_yielded_value(%cond: !waveamdmachine.reg<sgpr, 1>,
                              %x: !waveamdmachine.reg<vgpr, 1>) {
  %shift = waveamdmachine.imm 12 : !waveamdmachine.imm
  %value = waveamdmachine.exec_if %cond {
    %addr = waveamdmachine.v_lshlrev_b32 %shift, %x
        : (!waveamdmachine.imm, !waveamdmachine.reg<vgpr, 1>)
        -> !waveamdmachine.reg<vgpr, 1>
    waveamdmachine.yield %addr : !waveamdmachine.reg<vgpr, 1>
  } : !waveamdmachine.reg<sgpr, 1> -> !waveamdmachine.reg<vgpr, 1>
  %sum = waveamdmachine.v_add_u32 %value, %x
      : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>)
      -> !waveamdmachine.reg<vgpr, 1>
  %load = waveamdmachine.ds_load_b32 %sum
      : (!waveamdmachine.reg<vgpr, 1>) -> !waveamdmachine.reg<vgpr, 1>
  return
}

}

// -----

module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx950"} {

// CHECK-LABEL: func.func @hoist_dead_scc_writer(
// CHECK: [[ONE:%.*]] = waveamdmachine.imm 1
// CHECK-NEXT: [[SUM:%.*]], %{{.*}} = waveamdmachine.s_add_i32 [[X:%.*]], [[ONE]]
// CHECK-NEXT: [[VALUE:%.*]] = waveamdmachine.v_mov_b32_tuple [[SUM]]
// CHECK-NEXT: waveamdmachine.exec_if [[COND:%.*]] {
// CHECK-NOT: waveamdmachine.s_add_i32
// CHECK-NOT: waveamdmachine.v_mov_b32_tuple
// CHECK-NEXT: waveamdmachine.ds_store_b32 [[ADDR:%.*]], [[VALUE]]
func.func @hoist_dead_scc_writer(%cond: !waveamdmachine.reg<sgpr, 1>,
                                 %x: !waveamdmachine.reg<sgpr, 1>,
                                 %addr: !waveamdmachine.reg<vgpr, 1>) {
  %one = waveamdmachine.imm 1 : !waveamdmachine.imm
  waveamdmachine.exec_if %cond {
    %sum, %scc = waveamdmachine.s_add_i32 %x, %one
        : (!waveamdmachine.reg<sgpr, 1>, !waveamdmachine.imm)
        -> (!waveamdmachine.reg<sgpr, 1>, !waveamdmachine.reg<scc, 1>)
    %value = waveamdmachine.v_mov_b32_tuple %sum {registers = 1 : i64}
        : (!waveamdmachine.reg<sgpr, 1>) -> !waveamdmachine.reg<vgpr, 1>
    %store = waveamdmachine.ds_store_b32 %addr, %value
        : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>)
        -> !waveamdmachine.mem.token
    waveamdmachine.yield
  } : !waveamdmachine.reg<sgpr, 1>
  return
}

}

// -----

module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx950"} {

// CHECK-LABEL: func.func @keep_live_scc_writer(
// CHECK: [[ONE:%.*]] = waveamdmachine.imm 1
// CHECK-NEXT: waveamdmachine.exec_if [[COND:%.*]] {
// CHECK-NEXT: [[SUM:%.*]], [[SCC:%.*]] = waveamdmachine.s_add_i32 [[X:%.*]], [[ONE]]
// CHECK-NEXT: [[CHOSEN:%.*]] = waveamdmachine.s_cselect_b32 [[SCC]], [[SUM]], [[X]]
// CHECK-NEXT: [[VALUE:%.*]] = waveamdmachine.v_mov_b32_tuple [[CHOSEN]]
// CHECK-NEXT: waveamdmachine.ds_store_b32 [[ADDR:%.*]], [[VALUE]]
func.func @keep_live_scc_writer(%cond: !waveamdmachine.reg<sgpr, 1>,
                                %x: !waveamdmachine.reg<sgpr, 1>,
                                %addr: !waveamdmachine.reg<vgpr, 1>) {
  %one = waveamdmachine.imm 1 : !waveamdmachine.imm
  waveamdmachine.exec_if %cond {
    %sum, %scc = waveamdmachine.s_add_i32 %x, %one
        : (!waveamdmachine.reg<sgpr, 1>, !waveamdmachine.imm)
        -> (!waveamdmachine.reg<sgpr, 1>, !waveamdmachine.reg<scc, 1>)
    %chosen = waveamdmachine.s_cselect_b32 %scc, %sum, %x
        : (!waveamdmachine.reg<scc, 1>, !waveamdmachine.reg<sgpr, 1>,
           !waveamdmachine.reg<sgpr, 1>) -> !waveamdmachine.reg<sgpr, 1>
    %value = waveamdmachine.v_mov_b32_tuple %chosen {registers = 1 : i64}
        : (!waveamdmachine.reg<sgpr, 1>) -> !waveamdmachine.reg<vgpr, 1>
    %store = waveamdmachine.ds_store_b32 %addr, %value
        : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>)
        -> !waveamdmachine.mem.token
    waveamdmachine.yield
  } : !waveamdmachine.reg<sgpr, 1>
  return
}

}

// -----

module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx950"} {

// CHECK-LABEL: func.func @hoist_dead_vcc_writer(
// CHECK: [[SUM:%.*]], %{{.*}} = waveamdmachine.v_add_u32_vcc [[X:%.*]], [[Y:%.*]]
// CHECK-NEXT: waveamdmachine.exec_if [[COND:%.*]] {
// CHECK-NOT: waveamdmachine.v_add_u32_vcc
// CHECK-NEXT: waveamdmachine.ds_store_b32 [[ADDR:%.*]], [[SUM]]
func.func @hoist_dead_vcc_writer(%cond: !waveamdmachine.reg<sgpr, 1>,
                                 %x: !waveamdmachine.reg<vgpr, 1>,
                                 %y: !waveamdmachine.reg<vgpr, 1>,
                                 %addr: !waveamdmachine.reg<vgpr, 1>) {
  waveamdmachine.exec_if %cond {
    %sum, %vcc = waveamdmachine.v_add_u32_vcc %x, %y
        : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>)
        -> (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vcc, 1>)
    %store = waveamdmachine.ds_store_b32 %addr, %sum
        : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>)
        -> !waveamdmachine.mem.token
    waveamdmachine.yield
  } : !waveamdmachine.reg<sgpr, 1>
  return
}

}

// -----

module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx950"} {

// CHECK-LABEL: func.func @keep_live_vcc_writer(
// CHECK-NEXT: waveamdmachine.exec_if [[COND:%.*]] {
// CHECK-NEXT: [[SUM:%.*]], [[VCC:%.*]] = waveamdmachine.v_add_u32_vcc [[X:%.*]], [[Y:%.*]]
// CHECK-NEXT: [[SAVED:%.*]] = waveamdmachine.s_read_vcc_b32 [[VCC]]
// CHECK-NEXT: [[VALUE:%.*]] = waveamdmachine.v_mov_b32_tuple [[SAVED]]
// CHECK-NEXT: waveamdmachine.ds_store_b32 [[ADDR:%.*]], [[VALUE]]
func.func @keep_live_vcc_writer(%cond: !waveamdmachine.reg<sgpr, 1>,
                                %x: !waveamdmachine.reg<vgpr, 1>,
                                %y: !waveamdmachine.reg<vgpr, 1>,
                                %addr: !waveamdmachine.reg<vgpr, 1>) {
  waveamdmachine.exec_if %cond {
    %sum, %vcc = waveamdmachine.v_add_u32_vcc %x, %y
        : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>)
        -> (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vcc, 1>)
    %saved = waveamdmachine.s_read_vcc_b32 %vcc
        : (!waveamdmachine.reg<vcc, 1>) -> !waveamdmachine.reg<sgpr, 1>
    %value = waveamdmachine.v_mov_b32_tuple %saved {registers = 1 : i64}
        : (!waveamdmachine.reg<sgpr, 1>) -> !waveamdmachine.reg<vgpr, 1>
    %store = waveamdmachine.ds_store_b32 %addr, %value
        : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>)
        -> !waveamdmachine.mem.token
    waveamdmachine.yield
  } : !waveamdmachine.reg<sgpr, 1>
  return
}

}

// -----

module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx950"} {

// CHECK-LABEL: func.func @keep_exec_dependent_readfirstlane(
// CHECK-SAME: [[COND:%[^:]+]]: !waveamdmachine.reg<sgpr, 1>
// CHECK-SAME: [[X:%[^:]+]]: !waveamdmachine.reg<vgpr, 1>
// CHECK: waveamdmachine.exec_if [[COND]] {
// CHECK-NEXT: [[FIRST:%.*]] = waveamdmachine.v_readfirstlane_b32 [[X]]
// CHECK-NEXT: [[VALUE:%.*]] = waveamdmachine.v_mov_b32_tuple [[FIRST]]
// CHECK-NEXT: waveamdmachine.ds_store_b32
func.func @keep_exec_dependent_readfirstlane(
    %cond: !waveamdmachine.reg<sgpr, 1>,
    %x: !waveamdmachine.reg<vgpr, 1>,
    %addr: !waveamdmachine.reg<vgpr, 1>) {
  waveamdmachine.exec_if %cond {
    %first = waveamdmachine.v_readfirstlane_b32 %x
        : (!waveamdmachine.reg<vgpr, 1>) -> !waveamdmachine.reg<sgpr, 1>
    %value = waveamdmachine.v_mov_b32_tuple %first {registers = 1 : i64}
        : (!waveamdmachine.reg<sgpr, 1>) -> !waveamdmachine.reg<vgpr, 1>
    %store = waveamdmachine.ds_store_b32 %addr, %value
        : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>)
        -> !waveamdmachine.mem.token
    waveamdmachine.yield
  } : !waveamdmachine.reg<sgpr, 1>
  return
}

}

// -----

module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx950"} {

// CHECK-LABEL: func.func @chain_dma_m0_increment(
// CHECK: [[STEP:%.*]] = waveamdmachine.imm 8192
// CHECK: [[M0:%.*]] = waveamdmachine.s_mov_m0 [[BASE:%.*]]
// CHECK-NEXT: [[T0:%.*]] = waveamdmachine.buffer_load_lds_b128 {{.*}}, [[M0]] after
// CHECK-NEXT: [[NEXT:%.*]], %{{.*}} = waveamdmachine.s_add_m0_i32 [[M0]], [[STEP]]
// CHECK-NEXT: [[T1:%.*]] = waveamdmachine.buffer_load_lds_b128 {{.*}}, [[NEXT]] after [[T0]]
// CHECK-NEXT: return [[T1]]
func.func @chain_dma_m0_increment(
    %base: !waveamdmachine.reg<sgpr, 1>,
    %off0: !waveamdmachine.reg<vgpr, 1>,
    %off1: !waveamdmachine.reg<vgpr, 1>,
    %desc: !waveamdmachine.reg<sgpr, 4>,
    %soff: !waveamdmachine.reg<sgpr, 1>,
    %dep: !waveamdmachine.mem.token) -> !waveamdmachine.mem.token {
  %step = waveamdmachine.imm 8192 : !waveamdmachine.imm
  %m0 = waveamdmachine.s_mov_m0 %base
      : (!waveamdmachine.reg<sgpr, 1>) -> !waveamdmachine.m0
  %t0 = waveamdmachine.buffer_load_lds_b128
      %off0, %desc, %soff, %m0 after %dep
      : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<sgpr, 4>,
         !waveamdmachine.reg<sgpr, 1>, !waveamdmachine.m0,
         !waveamdmachine.mem.token) -> !waveamdmachine.mem.token
  %next, %scc = waveamdmachine.s_add_m0_i32 %base, %step
      : (!waveamdmachine.reg<sgpr, 1>, !waveamdmachine.imm)
        -> (!waveamdmachine.m0, !waveamdmachine.reg<scc, 1>)
  %t1 = waveamdmachine.buffer_load_lds_b128
      %off1, %desc, %soff, %next after %t0
      : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<sgpr, 4>,
         !waveamdmachine.reg<sgpr, 1>, !waveamdmachine.m0,
         !waveamdmachine.mem.token) -> !waveamdmachine.mem.token
  return %t1 : !waveamdmachine.mem.token
}

}

// -----

module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx950"} {

// CHECK-LABEL: func.func @keep_dma_m0_increment_across_region(
// CHECK: {{%.*}} = waveamdmachine.s_mov_m0 [[BASE:%.*]] :
// CHECK: waveamdmachine.exec_if
// CHECK: waveamdmachine.s_add_m0_i32 [[BASE]],
// CHECK: return
func.func @keep_dma_m0_increment_across_region(
    %cond: !waveamdmachine.reg<sgpr, 1>,
    %base: !waveamdmachine.reg<sgpr, 1>,
    %other: !waveamdmachine.reg<sgpr, 1>,
    %off: !waveamdmachine.reg<vgpr, 1>,
    %desc: !waveamdmachine.reg<sgpr, 4>,
    %soff: !waveamdmachine.reg<sgpr, 1>,
    %dep: !waveamdmachine.mem.token) -> !waveamdmachine.mem.token {
  %step = waveamdmachine.imm 8192 : !waveamdmachine.imm
  %m0 = waveamdmachine.s_mov_m0 %base
      : (!waveamdmachine.reg<sgpr, 1>) -> !waveamdmachine.m0
  %t0 = waveamdmachine.buffer_load_lds_b128
      %off, %desc, %soff, %m0 after %dep
      : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<sgpr, 4>,
         !waveamdmachine.reg<sgpr, 1>, !waveamdmachine.m0,
         !waveamdmachine.mem.token) -> !waveamdmachine.mem.token
  waveamdmachine.exec_if %cond {
    %clobber = waveamdmachine.s_mov_m0 %other
        : (!waveamdmachine.reg<sgpr, 1>) -> !waveamdmachine.m0
    %inner = waveamdmachine.buffer_load_lds_b128
        %off, %desc, %soff, %clobber after %t0
        : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<sgpr, 4>,
           !waveamdmachine.reg<sgpr, 1>, !waveamdmachine.m0,
           !waveamdmachine.mem.token) -> !waveamdmachine.mem.token
    waveamdmachine.yield
  } : !waveamdmachine.reg<sgpr, 1>
  %next, %scc = waveamdmachine.s_add_m0_i32 %base, %step
      : (!waveamdmachine.reg<sgpr, 1>, !waveamdmachine.imm)
        -> (!waveamdmachine.m0, !waveamdmachine.reg<scc, 1>)
  %t1 = waveamdmachine.buffer_load_lds_b128
      %off, %desc, %soff, %next after %t0
      : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<sgpr, 4>,
         !waveamdmachine.reg<sgpr, 1>, !waveamdmachine.m0,
         !waveamdmachine.mem.token) -> !waveamdmachine.mem.token
  return %t1 : !waveamdmachine.mem.token
}

}
