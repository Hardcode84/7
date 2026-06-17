// RUN: wave-opt --waveamd-reg-alloc -split-input-file %s | FileCheck %s
// RUN: wave-opt --waveamd-reg-alloc -split-input-file %s | wave-opt -split-input-file | FileCheck %s

module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx1100"} {

// Mixed fixed/unfixed round-trip: copying one element breaks tuple
// aliasing. Copy the sibling too.
//
// CHECK-LABEL: func.func @mixed_fixed_round_trip_copies_all_elements
// CHECK: %[[SRC:.+]] = waveamdmachine.v_mov_b32_tuple {{.*}} -> !waveamdmachine.reg<vgpr, 2, [[#SRC_BASE:]]>
// CHECK: %[[E:.+]]:2 = waveamdmachine.tuple_to_elements %[[SRC]]
// CHECK-SAME: -> (!waveamdmachine.reg<vgpr, 1, 0>
// CHECK-SAME: !waveamdmachine.reg<vgpr, 1, [[#SRC_BASE+1]]>)
// CHECK: %[[C0:.+]] = waveamdmachine.v_mov_b32_tuple %[[E]]#0 {registers = 1 : i64} : (!waveamdmachine.reg<vgpr, 1, 0>) -> !waveamdmachine.reg<vgpr, 1, [[#DST_BASE:]]>
// CHECK: %[[C1:.+]] = waveamdmachine.v_mov_b32_tuple %[[E]]#1 {registers = 1 : i64} : (!waveamdmachine.reg<vgpr, 1, [[#SRC_BASE+1]]>) -> !waveamdmachine.reg<vgpr, 1, [[#DST_BASE+1]]>
// CHECK: %{{.+}} = waveamdmachine.tuple_from_elements %[[C0]], %[[C1]]
// CHECK-SAME: -> !waveamdmachine.reg<vgpr, 2, [[#DST_BASE]]>
func.func @mixed_fixed_round_trip_copies_all_elements() {
  %zero = waveamdmachine.imm 0 : !waveamdmachine.imm
  %src = waveamdmachine.v_mov_b32_tuple %zero {registers = 2 : i64}
      : (!waveamdmachine.imm) -> !waveamdmachine.reg<vgpr, 2>
  %e:2 = waveamdmachine.tuple_to_elements %src
      : (!waveamdmachine.reg<vgpr, 2>) -> (!waveamdmachine.reg<vgpr, 1, 0>,
                                           !waveamdmachine.reg<vgpr, 1>)
  %dst = waveamdmachine.tuple_from_elements %e#0, %e#1
      : (!waveamdmachine.reg<vgpr, 1, 0>, !waveamdmachine.reg<vgpr, 1>)
        -> !waveamdmachine.reg<vgpr, 2>
  return
}

}

// -----

module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx1100"} {

// Fixed element entering a fresh tuple needs a rename; tuple result
// must not inherit the pinned physical register.
//
// CHECK-LABEL: func.func @fixed_element_into_unfixed_tuple_copies
// CHECK: %[[FIXED:.+]] = waveamdmachine.uninit : !waveamdmachine.reg<vgpr, 1, 0>
// CHECK: %[[FREE:.+]] = waveamdmachine.v_mov_b32_tuple {{.*}} -> !waveamdmachine.reg<vgpr, 1, [[#FREE_SLOT:]]>
// CHECK: %[[COPY:.+]] = waveamdmachine.v_mov_b32_tuple %[[FIXED]] {registers = 1 : i64} : (!waveamdmachine.reg<vgpr, 1, 0>) -> !waveamdmachine.reg<vgpr, 1, [[#FREE_SLOT-1]]>
// CHECK: %{{.+}} = waveamdmachine.tuple_from_elements %[[COPY]], %[[FREE]]
// CHECK-SAME: -> !waveamdmachine.reg<vgpr, 2, [[#FREE_SLOT-1]]>
func.func @fixed_element_into_unfixed_tuple_copies() {
  %zero = waveamdmachine.imm 0 : !waveamdmachine.imm
  %fixed = waveamdmachine.uninit : !waveamdmachine.reg<vgpr, 1, 0>
  %free = waveamdmachine.v_mov_b32_tuple %zero {registers = 1 : i64}
      : (!waveamdmachine.imm) -> !waveamdmachine.reg<vgpr, 1>
  %tuple = waveamdmachine.tuple_from_elements %fixed, %free
      : (!waveamdmachine.reg<vgpr, 1, 0>, !waveamdmachine.reg<vgpr, 1>)
        -> !waveamdmachine.reg<vgpr, 2>
  return
}

}

// -----

module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx1100"} {

// Two `tuple_from_elements` ops share %a at slot 0. Without the
// sharing pre-pass the coalescer would merge t1's interval into t2's
// via %a, pulling t1's %b/%c/%d into t2 at slots 1/2/3 and silently
// clobbering t2's %e/%f/%g. The pre-pass materializes a `v_mov`
// rename for every shared element so the two intervals stay disjoint.
//
// CHECK-LABEL: func.func @shared_operand_gets_copy
// CHECK: %[[A:.+]] = waveamdmachine.v_mov_b32_tuple {{.*}} -> !waveamdmachine.reg<vgpr, 1, [[#SH_T1_BASE:]]>
// CHECK: %[[B:.+]] = waveamdmachine.v_mov_b32_tuple {{.*}} -> !waveamdmachine.reg<vgpr, 1, [[#SH_T1_BASE+1]]>
// CHECK: %[[C:.+]] = waveamdmachine.v_mov_b32_tuple {{.*}} -> !waveamdmachine.reg<vgpr, 1, [[#SH_T1_BASE+2]]>
// CHECK: %[[D:.+]] = waveamdmachine.v_mov_b32_tuple {{.*}} -> !waveamdmachine.reg<vgpr, 1, [[#SH_T1_BASE+3]]>
// CHECK: %[[E:.+]] = waveamdmachine.v_mov_b32_tuple {{.*}} -> !waveamdmachine.reg<vgpr, 1, [[#SH_E_SLOT:]]>
// CHECK: %[[F:.+]] = waveamdmachine.v_mov_b32_tuple {{.*}} -> !waveamdmachine.reg<vgpr, 1, [[#SH_E_SLOT+1]]>
// CHECK: %[[G:.+]] = waveamdmachine.v_mov_b32_tuple {{.*}} -> !waveamdmachine.reg<vgpr, 1, [[#SH_E_SLOT+2]]>
// CHECK: %[[T1:.+]] = waveamdmachine.tuple_from_elements %[[A]], %[[B]], %[[C]], %[[D]]
// CHECK-SAME: -> !waveamdmachine.reg<vgpr, 4, [[#SH_T1_BASE]]>
// CHECK: %[[ACPY:.+]] = waveamdmachine.v_mov_b32_tuple {{.*}} {registers = 1 : i64} : (!waveamdmachine.imm) -> !waveamdmachine.reg<vgpr, 1, [[#SH_E_SLOT-1]]>
// CHECK: %{{.+}} = waveamdmachine.tuple_from_elements %[[ACPY]], %[[E]], %[[F]], %[[G]]
// CHECK-SAME: -> !waveamdmachine.reg<vgpr, 4, [[#SH_E_SLOT-1]]>
func.func @shared_operand_gets_copy() {
  %zero = waveamdmachine.imm 0 : !waveamdmachine.imm
  %a = waveamdmachine.v_mov_b32_tuple %zero {registers = 1 : i64} : (!waveamdmachine.imm) -> !waveamdmachine.reg<vgpr, 1>
  %b = waveamdmachine.v_mov_b32_tuple %zero {registers = 1 : i64} : (!waveamdmachine.imm) -> !waveamdmachine.reg<vgpr, 1>
  %c = waveamdmachine.v_mov_b32_tuple %zero {registers = 1 : i64} : (!waveamdmachine.imm) -> !waveamdmachine.reg<vgpr, 1>
  %d = waveamdmachine.v_mov_b32_tuple %zero {registers = 1 : i64} : (!waveamdmachine.imm) -> !waveamdmachine.reg<vgpr, 1>
  %e = waveamdmachine.v_mov_b32_tuple %zero {registers = 1 : i64} : (!waveamdmachine.imm) -> !waveamdmachine.reg<vgpr, 1>
  %f = waveamdmachine.v_mov_b32_tuple %zero {registers = 1 : i64} : (!waveamdmachine.imm) -> !waveamdmachine.reg<vgpr, 1>
  %g = waveamdmachine.v_mov_b32_tuple %zero {registers = 1 : i64} : (!waveamdmachine.imm) -> !waveamdmachine.reg<vgpr, 1>
  %t1 = waveamdmachine.tuple_from_elements %a, %b, %c, %d
      : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>,
         !waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>)
        -> !waveamdmachine.reg<vgpr, 4>
  %t2 = waveamdmachine.tuple_from_elements %a, %e, %f, %g
      : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>,
         !waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>)
        -> !waveamdmachine.reg<vgpr, 4>
  return
}

}

// -----

module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx1100"} {

// Same SSA value repeated at multiple slots of one
// `tuple_from_elements` (broadcast pattern). Every slot past the
// first needs its own register, so the pre-pass materializes a copy
// per slot.
//
// CHECK-LABEL: func.func @broadcast_same_value_per_slot
// CHECK: %[[A:.+]] = waveamdmachine.v_mov_b32_tuple {{.*}} -> !waveamdmachine.reg<vgpr, 1, [[#BCAST_BASE:]]>
// CHECK: %[[A1:.+]] = waveamdmachine.v_mov_b32_tuple {{.*}} -> !waveamdmachine.reg<vgpr, 1, [[#BCAST_BASE+1]]>
// CHECK: %[[A2:.+]] = waveamdmachine.v_mov_b32_tuple {{.*}} -> !waveamdmachine.reg<vgpr, 1, [[#BCAST_BASE+2]]>
// CHECK: %[[A3:.+]] = waveamdmachine.v_mov_b32_tuple {{.*}} -> !waveamdmachine.reg<vgpr, 1, [[#BCAST_BASE+3]]>
// CHECK: %{{.+}} = waveamdmachine.tuple_from_elements %[[A]], %[[A1]], %[[A2]], %[[A3]]
// CHECK-SAME: -> !waveamdmachine.reg<vgpr, 4, [[#BCAST_BASE]]>
func.func @broadcast_same_value_per_slot() {
  %zero = waveamdmachine.imm 0 : !waveamdmachine.imm
  %a = waveamdmachine.v_mov_b32_tuple %zero {registers = 1 : i64} : (!waveamdmachine.imm) -> !waveamdmachine.reg<vgpr, 1>
  %t = waveamdmachine.tuple_from_elements %a, %a, %a, %a
      : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>,
         !waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>)
        -> !waveamdmachine.reg<vgpr, 4>
  return
}

}

// -----

module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx1100"} {

// Round-trip: `tuple_to_elements` followed by `tuple_from_elements`
// reusing the same elements at the same slots. Slot indices align,
// so the pre-pass leaves the elements untouched and the two tuples
// share the same physical block.
//
// CHECK-LABEL: func.func @round_trip_no_copies
// CHECK: %[[A:.+]] = waveamdmachine.v_mov_b32_tuple {{.*}} -> !waveamdmachine.reg<vgpr, 4, [[#SH_RT_BASE:]]>
// CHECK: %[[E:.+]]:4 = waveamdmachine.tuple_to_elements %[[A]]
// CHECK-SAME: -> (!waveamdmachine.reg<vgpr, 1, [[#SH_RT_BASE]]>
// CHECK-SAME: !waveamdmachine.reg<vgpr, 1, [[#SH_RT_BASE+1]]>
// CHECK-SAME: !waveamdmachine.reg<vgpr, 1, [[#SH_RT_BASE+2]]>
// CHECK-SAME: !waveamdmachine.reg<vgpr, 1, [[#SH_RT_BASE+3]]>)
// CHECK-NOT: waveamdmachine.v_mov_b32_tuple %[[E]]
// CHECK: %{{.+}} = waveamdmachine.tuple_from_elements %[[E]]#0, %[[E]]#1, %[[E]]#2, %[[E]]#3
// CHECK-SAME: -> !waveamdmachine.reg<vgpr, 4, [[#SH_RT_BASE]]>
func.func @round_trip_no_copies() {
  %zero = waveamdmachine.imm 0 : !waveamdmachine.imm
  %a = waveamdmachine.v_mov_b32_tuple %zero {registers = 4 : i64} : (!waveamdmachine.imm) -> !waveamdmachine.reg<vgpr, 4>
  %e:4 = waveamdmachine.tuple_to_elements %a
      : (!waveamdmachine.reg<vgpr, 4>) -> (!waveamdmachine.reg<vgpr, 1>,
                                        !waveamdmachine.reg<vgpr, 1>,
                                        !waveamdmachine.reg<vgpr, 1>,
                                        !waveamdmachine.reg<vgpr, 1>)
  %b = waveamdmachine.tuple_from_elements %e#0, %e#1, %e#2, %e#3
      : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>,
         !waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>)
        -> !waveamdmachine.reg<vgpr, 4>
  return
}

}

// -----

module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx1100"} {

// Shuffle: `tuple_to_elements` followed by `tuple_from_elements`
// with shuffled element ordering. Each slot mismatches its anchor,
// so each operand needs a copy and the two tuples land in separate
// physical blocks.
//
// CHECK-LABEL: func.func @shuffle_needs_copies
// CHECK: %[[A:.+]] = waveamdmachine.v_mov_b32_tuple {{.*}} -> !waveamdmachine.reg<vgpr, 4, [[#SHUF_BASE:]]>
// CHECK: %[[E:.+]]:4 = waveamdmachine.tuple_to_elements %[[A]]
// CHECK-SAME: -> (!waveamdmachine.reg<vgpr, 1, [[#SHUF_BASE]]>
// CHECK-SAME: !waveamdmachine.reg<vgpr, 1, [[#SHUF_BASE+1]]>
// CHECK-SAME: !waveamdmachine.reg<vgpr, 1, [[#SHUF_BASE+2]]>
// CHECK-SAME: !waveamdmachine.reg<vgpr, 1, [[#SHUF_BASE+3]]>)
// CHECK: %[[C3:.+]] = waveamdmachine.v_mov_b32_tuple %[[E]]#3 {registers = 1 : i64} : (!waveamdmachine.reg<vgpr, 1, [[#SHUF_BASE+3]]>)
// CHECK: %[[C2:.+]] = waveamdmachine.v_mov_b32_tuple %[[E]]#2 {registers = 1 : i64} : (!waveamdmachine.reg<vgpr, 1, [[#SHUF_BASE+2]]>)
// CHECK: %[[C1:.+]] = waveamdmachine.v_mov_b32_tuple %[[E]]#1 {registers = 1 : i64} : (!waveamdmachine.reg<vgpr, 1, [[#SHUF_BASE+1]]>)
// CHECK: %[[C0:.+]] = waveamdmachine.v_mov_b32_tuple %[[E]]#0 {registers = 1 : i64} : (!waveamdmachine.reg<vgpr, 1, [[#SHUF_BASE]]>)
// CHECK: %{{.+}} = waveamdmachine.tuple_from_elements %[[C3]], %[[C2]], %[[C1]], %[[C0]]
func.func @shuffle_needs_copies() {
  %zero = waveamdmachine.imm 0 : !waveamdmachine.imm
  %a = waveamdmachine.v_mov_b32_tuple %zero {registers = 4 : i64} : (!waveamdmachine.imm) -> !waveamdmachine.reg<vgpr, 4>
  %e:4 = waveamdmachine.tuple_to_elements %a
      : (!waveamdmachine.reg<vgpr, 4>) -> (!waveamdmachine.reg<vgpr, 1>,
                                        !waveamdmachine.reg<vgpr, 1>,
                                        !waveamdmachine.reg<vgpr, 1>,
                                        !waveamdmachine.reg<vgpr, 1>)
  %b = waveamdmachine.tuple_from_elements %e#3, %e#2, %e#1, %e#0
      : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>,
         !waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>)
        -> !waveamdmachine.reg<vgpr, 4>
  return
}

}
