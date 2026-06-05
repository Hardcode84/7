// RUN: wave-opt --waveamd-reg-alloc -split-input-file %s | FileCheck %s
// RUN: wave-opt --waveamd-reg-alloc -split-input-file %s | wave-opt -split-input-file | FileCheck %s

module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx1100"} {

// Only element 0 stays live after the split; slots 1..3 are reusable.
//
// CHECK-LABEL: func.func @dead_tuple_slots_reused
// CHECK: %[[T:.+]] = waveamdmachine.v_mov_b32_tuple {{.*}} -> !waveamdmachine.reg<vgpr, 4, 0>
// CHECK: %[[PRE:.+]] = waveamdmachine.v_mov_b32_tuple {{.*}} -> !waveamdmachine.reg<vgpr, 1, 4>
// CHECK: %[[E:.+]]:4 = waveamdmachine.tuple_to_elements %[[T]]
// CHECK-SAME: -> (!waveamdmachine.reg<vgpr, 1, 0>, !waveamdmachine.reg<vgpr, 1, 1>, !waveamdmachine.reg<vgpr, 1, 2>, !waveamdmachine.reg<vgpr, 1, 3>)
// CHECK: %[[A:.+]] = waveamdmachine.v_mov_b32_tuple {{.*}} -> !waveamdmachine.reg<vgpr, 1, 1>
// CHECK: waveamdmachine.v_mov_b32_tuple %[[E]]#0
// CHECK: waveamdmachine.v_mov_b32_tuple %[[A]]
// CHECK: waveamdmachine.v_mov_b32_tuple %[[PRE]]
func.func @dead_tuple_slots_reused() {
  %zero = waveamdmachine.imm 0 : !waveamdmachine.imm
  %t = waveamdmachine.v_mov_b32_tuple %zero {registers = 4 : i64}
      : (!waveamdmachine.imm) -> !waveamdmachine.reg<vgpr, 4>
  %pre = waveamdmachine.v_mov_b32_tuple %zero {registers = 1 : i64}
      : (!waveamdmachine.imm) -> !waveamdmachine.reg<vgpr, 1>
  %e:4 = waveamdmachine.tuple_to_elements %t
      : (!waveamdmachine.reg<vgpr, 4>) -> (!waveamdmachine.reg<vgpr, 1>,
                                        !waveamdmachine.reg<vgpr, 1>,
                                        !waveamdmachine.reg<vgpr, 1>,
                                        !waveamdmachine.reg<vgpr, 1>)
  %a = waveamdmachine.v_mov_b32_tuple %zero {registers = 1 : i64}
      : (!waveamdmachine.imm) -> !waveamdmachine.reg<vgpr, 1>
  %u = waveamdmachine.v_mov_b32_tuple %e#0 {registers = 1 : i64}
      : (!waveamdmachine.reg<vgpr, 1>) -> !waveamdmachine.reg<vgpr, 1>
  %ua = waveamdmachine.v_mov_b32_tuple %a {registers = 1 : i64}
      : (!waveamdmachine.reg<vgpr, 1>) -> !waveamdmachine.reg<vgpr, 1>
  %upre = waveamdmachine.v_mov_b32_tuple %pre {registers = 1 : i64}
      : (!waveamdmachine.reg<vgpr, 1>) -> !waveamdmachine.reg<vgpr, 1>
  return
}

}

// -----

module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx1100"} {

// Whole-tuple consumers keep the full tuple range live.
//
// CHECK-LABEL: func.func @whole_tuple_user_keeps_slots_live
// CHECK: %[[T:.+]] = waveamdmachine.v_mov_b32_tuple {{.*}} -> !waveamdmachine.reg<vgpr, 4, 0>
// CHECK: %[[E:.+]]:4 = waveamdmachine.tuple_to_elements %[[T]]
// CHECK-SAME: -> (!waveamdmachine.reg<vgpr, 1, 0>, !waveamdmachine.reg<vgpr, 1, 1>, !waveamdmachine.reg<vgpr, 1, 2>, !waveamdmachine.reg<vgpr, 1, 3>)
// CHECK: %[[A:.+]] = waveamdmachine.v_mov_b32_tuple {{.*}} -> !waveamdmachine.reg<vgpr, 1, 4>
// CHECK: waveamdmachine.v_mov_b32_tuple %[[T]]
// CHECK: waveamdmachine.v_mov_b32_tuple %[[A]]
func.func @whole_tuple_user_keeps_slots_live() {
  %zero = waveamdmachine.imm 0 : !waveamdmachine.imm
  %t = waveamdmachine.v_mov_b32_tuple %zero {registers = 4 : i64}
      : (!waveamdmachine.imm) -> !waveamdmachine.reg<vgpr, 4>
  %e:4 = waveamdmachine.tuple_to_elements %t
      : (!waveamdmachine.reg<vgpr, 4>) -> (!waveamdmachine.reg<vgpr, 1>,
                                        !waveamdmachine.reg<vgpr, 1>,
                                        !waveamdmachine.reg<vgpr, 1>,
                                        !waveamdmachine.reg<vgpr, 1>)
  %a = waveamdmachine.v_mov_b32_tuple %zero {registers = 1 : i64}
      : (!waveamdmachine.imm) -> !waveamdmachine.reg<vgpr, 1>
  %u = waveamdmachine.v_mov_b32_tuple %t {registers = 4 : i64}
      : (!waveamdmachine.reg<vgpr, 4>) -> !waveamdmachine.reg<vgpr, 4>
  %ua = waveamdmachine.v_mov_b32_tuple %a {registers = 1 : i64}
      : (!waveamdmachine.reg<vgpr, 1>) -> !waveamdmachine.reg<vgpr, 1>
  return
}

}

// -----

module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx1100"} {

// Width-8 tuple split into mixed-width sub-tuples [4, 2, 2]. Each
// piece lands at its cumulative dword offset within the parent: the
// width-4 sub-tuple at +0, the first width-2 at +4, the second
// width-2 at +6. Tuple itself lands at v0 (width-8 alignment).
//
// CHECK-LABEL: func.func @subtuple_split_offsets
// CHECK: %[[T:.+]] = waveamdmachine.v_mov_b32_tuple {{.*}} -> !waveamdmachine.reg<vgpr, 8, 0>
// CHECK: %{{.+}}:3 = waveamdmachine.tuple_to_elements %[[T]]
// CHECK-SAME: -> (!waveamdmachine.reg<vgpr, 4, 0>, !waveamdmachine.reg<vgpr, 2, 4>, !waveamdmachine.reg<vgpr, 2, 6>)
func.func @subtuple_split_offsets() {
  %zero = waveamdmachine.imm 0 : !waveamdmachine.imm
  %t = waveamdmachine.v_mov_b32_tuple %zero {registers = 8 : i64}
      : (!waveamdmachine.imm) -> !waveamdmachine.reg<vgpr, 8>
  %e:3 = waveamdmachine.tuple_to_elements %t
      : (!waveamdmachine.reg<vgpr, 8>) -> (!waveamdmachine.reg<vgpr, 4>,
                                        !waveamdmachine.reg<vgpr, 2>,
                                        !waveamdmachine.reg<vgpr, 2>)
  return
}

}

// -----

module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx1100"} {

// Reverse direction: width-4, width-2, width-2 fragments gathered
// into a width-8 tuple. Same cumulative offsets pin each piece.
// The block is aligned to 8 so it lands at v0..v7.
//
// CHECK-LABEL: func.func @subtuple_gather_offsets
// CHECK: %[[A:.+]] = waveamdmachine.v_mov_b32_tuple {{.*}} -> !waveamdmachine.reg<vgpr, 4, 0>
// CHECK: %[[B:.+]] = waveamdmachine.v_mov_b32_tuple {{.*}} -> !waveamdmachine.reg<vgpr, 2, 4>
// CHECK: %[[C:.+]] = waveamdmachine.v_mov_b32_tuple {{.*}} -> !waveamdmachine.reg<vgpr, 2, 6>
// CHECK: %{{.+}} = waveamdmachine.tuple_from_elements %[[A]], %[[B]], %[[C]]
// CHECK-SAME: -> !waveamdmachine.reg<vgpr, 8, 0>
func.func @subtuple_gather_offsets() {
  %zero = waveamdmachine.imm 0 : !waveamdmachine.imm
  %a = waveamdmachine.v_mov_b32_tuple %zero {registers = 4 : i64}
      : (!waveamdmachine.imm) -> !waveamdmachine.reg<vgpr, 4>
  %b = waveamdmachine.v_mov_b32_tuple %zero {registers = 2 : i64}
      : (!waveamdmachine.imm) -> !waveamdmachine.reg<vgpr, 2>
  %c = waveamdmachine.v_mov_b32_tuple %zero {registers = 2 : i64}
      : (!waveamdmachine.imm) -> !waveamdmachine.reg<vgpr, 2>
  %t = waveamdmachine.tuple_from_elements %a, %b, %c
      : (!waveamdmachine.reg<vgpr, 4>, !waveamdmachine.reg<vgpr, 2>,
         !waveamdmachine.reg<vgpr, 2>) -> !waveamdmachine.reg<vgpr, 8>
  return
}

}

// -----

module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx1100"} {

// Round-trip subtuples at matching offsets: no copies, both tuples
// share the same physical block.
//
// CHECK-LABEL: func.func @subtuple_round_trip_no_copies
// CHECK: %[[T:.+]] = waveamdmachine.v_mov_b32_tuple {{.*}} -> !waveamdmachine.reg<vgpr, 8, 0>
// CHECK: %[[E:.+]]:3 = waveamdmachine.tuple_to_elements %[[T]]
// CHECK-SAME: -> (!waveamdmachine.reg<vgpr, 4, 0>, !waveamdmachine.reg<vgpr, 2, 4>, !waveamdmachine.reg<vgpr, 2, 6>)
// CHECK-NOT: waveamdmachine.v_mov_b32_tuple %[[E]]
// CHECK: %{{.+}} = waveamdmachine.tuple_from_elements %[[E]]#0, %[[E]]#1, %[[E]]#2
// CHECK-SAME: -> !waveamdmachine.reg<vgpr, 8, 0>
func.func @subtuple_round_trip_no_copies() {
  %zero = waveamdmachine.imm 0 : !waveamdmachine.imm
  %t = waveamdmachine.v_mov_b32_tuple %zero {registers = 8 : i64}
      : (!waveamdmachine.imm) -> !waveamdmachine.reg<vgpr, 8>
  %e:3 = waveamdmachine.tuple_to_elements %t
      : (!waveamdmachine.reg<vgpr, 8>) -> (!waveamdmachine.reg<vgpr, 4>,
                                        !waveamdmachine.reg<vgpr, 2>,
                                        !waveamdmachine.reg<vgpr, 2>)
  %b = waveamdmachine.tuple_from_elements %e#0, %e#1, %e#2
      : (!waveamdmachine.reg<vgpr, 4>, !waveamdmachine.reg<vgpr, 2>,
         !waveamdmachine.reg<vgpr, 2>) -> !waveamdmachine.reg<vgpr, 8>
  return
}

}

// -----

module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx1100"} {

// Subtuple anchored at offset 4 (a width-4 split from the source
// tuple) is consumed at offset 0 in a fresh tuple. Slot mismatch
// triggers a `v_mov_b32_tuple` rename, which keeps the two physical
// blocks disjoint.
//
// CHECK-LABEL: func.func @subtuple_slot_mismatch_copies
// CHECK: %[[T:.+]] = waveamdmachine.v_mov_b32_tuple {{.*}} -> !waveamdmachine.reg<vgpr, 8, 0>
// CHECK: %[[E:.+]]:2 = waveamdmachine.tuple_to_elements %[[T]]
// CHECK-SAME: -> (!waveamdmachine.reg<vgpr, 4, 0>, !waveamdmachine.reg<vgpr, 4, 4>)
// CHECK: %[[E1CPY:.+]] = waveamdmachine.v_mov_b32_tuple %[[E]]#1 {registers = 4 : i64} : (!waveamdmachine.reg<vgpr, 4, 4>) -> !waveamdmachine.reg<vgpr, 4, 8>
// CHECK: %[[E0CPY:.+]] = waveamdmachine.v_mov_b32_tuple %[[E]]#0 {registers = 4 : i64} : (!waveamdmachine.reg<vgpr, 4, 0>) -> !waveamdmachine.reg<vgpr, 4, 12>
// CHECK: %{{.+}} = waveamdmachine.tuple_from_elements %[[E1CPY]], %[[E0CPY]]
// CHECK-SAME: -> !waveamdmachine.reg<vgpr, 8, 8>
func.func @subtuple_slot_mismatch_copies() {
  %zero = waveamdmachine.imm 0 : !waveamdmachine.imm
  %t = waveamdmachine.v_mov_b32_tuple %zero {registers = 8 : i64}
      : (!waveamdmachine.imm) -> !waveamdmachine.reg<vgpr, 8>
  %e:2 = waveamdmachine.tuple_to_elements %t
      : (!waveamdmachine.reg<vgpr, 8>) -> (!waveamdmachine.reg<vgpr, 4>,
                                        !waveamdmachine.reg<vgpr, 4>)
  %b = waveamdmachine.tuple_from_elements %e#1, %e#0
      : (!waveamdmachine.reg<vgpr, 4>, !waveamdmachine.reg<vgpr, 4>)
        -> !waveamdmachine.reg<vgpr, 8>
  return
}

}
