// RUN: wave-opt --split-input-file --waveamd-narrow-wide-int %s | FileCheck %s

module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx1100"} {

// CHECK-LABEL: func.func @scalar_tuple
// CHECK-SAME: ([[BASE:%[^:]+]]: !waveamdmachine.reg<sgpr, 2>, [[OFF:%[^:]+]]: !waveamdmachine.reg<sgpr, 1>)
// CHECK-NOT: waveamdmachine.tuple_from_elements
// CHECK: [[SUM:%.*]], %{{.*}} = waveamdmachine.s_add_u64_u32 [[BASE]], [[OFF]]
// CHECK-NOT: waveamdmachine.s_add_u64{{[[:space:]]}}
func.func @scalar_tuple(%base: !waveamdmachine.reg<sgpr, 2>,
                        %off: !waveamdmachine.reg<sgpr, 1>)
    -> !waveamdmachine.reg<sgpr, 2> {
  %zero = waveamdmachine.imm 0 : !waveamdmachine.imm
  %hi = waveamdmachine.s_mov_b32_value %zero
      : (!waveamdmachine.imm) -> !waveamdmachine.reg<sgpr, 1>
  %wide = waveamdmachine.tuple_from_elements %off, %hi
      : (!waveamdmachine.reg<sgpr, 1>, !waveamdmachine.reg<sgpr, 1>)
        -> !waveamdmachine.reg<sgpr, 2>
  %sum, %scc = waveamdmachine.s_add_u64 %base, %wide
      : (!waveamdmachine.reg<sgpr, 2>, !waveamdmachine.reg<sgpr, 2>)
        -> (!waveamdmachine.reg<sgpr, 2>, !waveamdmachine.reg<scc, 1>)
  return %sum : !waveamdmachine.reg<sgpr, 2>
}

// CHECK-LABEL: func.func @scalar_imm
// CHECK-SAME: ([[BASE:%[^:]+]]: !waveamdmachine.reg<sgpr, 2>)
// CHECK: [[OFF:%.*]] = waveamdmachine.imm 1024
// CHECK: [[SUM:%.*]], %{{.*}} = waveamdmachine.s_add_u64_u32 [[BASE]], [[OFF]]
// CHECK-NOT: waveamdmachine.s_add_u64{{[[:space:]]}}
func.func @scalar_imm(%base: !waveamdmachine.reg<sgpr, 2>)
    -> !waveamdmachine.reg<sgpr, 2> {
  %off = waveamdmachine.s_mov_b64_imm 1024 : !waveamdmachine.reg<sgpr, 2>
  %sum, %scc = waveamdmachine.s_add_u64 %base, %off
      : (!waveamdmachine.reg<sgpr, 2>, !waveamdmachine.reg<sgpr, 2>)
        -> (!waveamdmachine.reg<sgpr, 2>, !waveamdmachine.reg<scc, 1>)
  return %sum : !waveamdmachine.reg<sgpr, 2>
}

// CHECK-LABEL: func.func @scalar_nonzero_high
// CHECK: waveamdmachine.tuple_from_elements
// CHECK: waveamdmachine.s_add_u64{{[[:space:]]}}
// CHECK-NOT: waveamdmachine.s_add_u64_u32
func.func @scalar_nonzero_high(%base: !waveamdmachine.reg<sgpr, 2>,
                               %lo: !waveamdmachine.reg<sgpr, 1>,
                               %hi: !waveamdmachine.reg<sgpr, 1>)
    -> !waveamdmachine.reg<sgpr, 2> {
  %wide = waveamdmachine.tuple_from_elements %lo, %hi
      : (!waveamdmachine.reg<sgpr, 1>, !waveamdmachine.reg<sgpr, 1>)
        -> !waveamdmachine.reg<sgpr, 2>
  %sum, %scc = waveamdmachine.s_add_u64 %base, %wide
      : (!waveamdmachine.reg<sgpr, 2>, !waveamdmachine.reg<sgpr, 2>)
        -> (!waveamdmachine.reg<sgpr, 2>, !waveamdmachine.reg<scc, 1>)
  return %sum : !waveamdmachine.reg<sgpr, 2>
}

}

// -----

module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx1100"} {

// CHECK-LABEL: func.func @vector_tuple_range_high_zero
// CHECK-SAME: ([[BASE:%[^:]+]]: !waveamdmachine.reg<vgpr, 2>, [[LO:%[^:]+]]: !waveamdmachine.reg<vgpr, 1>
// CHECK: [[SUM:%.*]], %{{.*}} = waveamdmachine.v_add_u64_u32 [[BASE]], [[LO]]
// CHECK-NOT: waveamdmachine.v_add_u64{{[[:space:]]}}
func.func @vector_tuple_range_high_zero(%base: !waveamdmachine.reg<vgpr, 2>,
                                        %lo: !waveamdmachine.reg<vgpr, 1>,
                                        %unknown: !waveamdmachine.reg<vgpr, 1>)
    -> !waveamdmachine.reg<vgpr, 2> {
  %zero = waveamdmachine.imm 0 : !waveamdmachine.imm
  %hi = waveamdmachine.v_and_b32 %unknown, %zero
      : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.imm)
        -> !waveamdmachine.reg<vgpr, 1>
  %wide = waveamdmachine.tuple_from_elements %lo, %hi
      : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>)
        -> !waveamdmachine.reg<vgpr, 2>
  %sum, %vcc = waveamdmachine.v_add_u64 %base, %wide
      : (!waveamdmachine.reg<vgpr, 2>, !waveamdmachine.reg<vgpr, 2>)
        -> (!waveamdmachine.reg<vgpr, 2>, !waveamdmachine.reg<vcc, 1>)
  return %sum : !waveamdmachine.reg<vgpr, 2>
}

// CHECK-LABEL: func.func @vector_commuted
// CHECK-SAME: ([[LO:%[^:]+]]: !waveamdmachine.reg<vgpr, 1>, [[BASE:%[^:]+]]: !waveamdmachine.reg<vgpr, 2>)
// CHECK: [[SUM:%.*]], %{{.*}} = waveamdmachine.v_add_u64_u32 [[BASE]], [[LO]]
// CHECK-NOT: waveamdmachine.v_add_u64{{[[:space:]]}}
func.func @vector_commuted(%lo: !waveamdmachine.reg<vgpr, 1>,
                           %base: !waveamdmachine.reg<vgpr, 2>)
    -> !waveamdmachine.reg<vgpr, 2> {
  %zero = waveamdmachine.imm 0 : !waveamdmachine.imm
  %hi = waveamdmachine.v_mov_b32_tuple %zero
      : (!waveamdmachine.imm) -> !waveamdmachine.reg<vgpr, 1>
  %wide = waveamdmachine.tuple_from_elements %lo, %hi
      : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>)
        -> !waveamdmachine.reg<vgpr, 2>
  %sum, %vcc = waveamdmachine.v_add_u64 %wide, %base
      : (!waveamdmachine.reg<vgpr, 2>, !waveamdmachine.reg<vgpr, 2>)
        -> (!waveamdmachine.reg<vgpr, 2>, !waveamdmachine.reg<vcc, 1>)
  return %sum : !waveamdmachine.reg<vgpr, 2>
}

// CHECK-LABEL: func.func @erase_dead_read_high_producer
// CHECK-NOT: waveamdmachine.global_load_b32
// CHECK-NOT: waveamdmachine.v_and_b32
// CHECK: waveamdmachine.v_add_u64_u32
func.func @erase_dead_read_high_producer(%base: !waveamdmachine.reg<vgpr, 2>,
                                         %lo: !waveamdmachine.reg<vgpr, 1>,
                                         %addr: !waveamdmachine.reg<vgpr, 1>,
                                         %global: !waveamdmachine.reg<sgpr, 2>)
    -> !waveamdmachine.reg<vgpr, 2> {
  %zero = waveamdmachine.imm 0 : !waveamdmachine.imm
  %tok0 = waveamdmachine.token : !waveamdmachine.mem.token
  %loaded, %tok1 = waveamdmachine.global_load_b32 %addr, %global after %tok0
      : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<sgpr, 2>,
         !waveamdmachine.mem.token)
        -> (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.mem.token)
  %hi = waveamdmachine.v_and_b32 %loaded, %zero
      : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.imm)
        -> !waveamdmachine.reg<vgpr, 1>
  %wide = waveamdmachine.tuple_from_elements %lo, %hi
      : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>)
        -> !waveamdmachine.reg<vgpr, 2>
  %sum, %vcc = waveamdmachine.v_add_u64 %base, %wide
      : (!waveamdmachine.reg<vgpr, 2>, !waveamdmachine.reg<vgpr, 2>)
        -> (!waveamdmachine.reg<vgpr, 2>, !waveamdmachine.reg<vcc, 1>)
  return %sum : !waveamdmachine.reg<vgpr, 2>
}

}
