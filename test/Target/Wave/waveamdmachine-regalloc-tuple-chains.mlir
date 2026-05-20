// RUN: wave-opt --waveamd-reg-alloc -split-input-file %s | FileCheck %s
// RUN: wave-opt --waveamd-reg-alloc -split-input-file %s | wave-opt -split-input-file | FileCheck %s

module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx1100"} {

// Intermediate from_elements that mixes a to_elements result with
// fresh operands. Without the drag-in guard the coalescer would
// merge the source tuple into the new from_elements via %e#0,
// pulling %e#1..%e#3 into slots 1..3 where they would collide
// with %x/%y/%z. The fix copies %e#0 first so the new tuple lives
// in a disjoint block.
//
// CHECK-LABEL: func.func @intermediate_conflict_copies
// CHECK: %[[A:.+]] = waveamdmachine.v_mov_b32_tuple {{.*}} -> !waveamdmachine.reg<vgpr, 4, 0>
// CHECK: %[[E:.+]]:4 = waveamdmachine.tuple_to_elements %[[A]]
// CHECK-SAME: -> (!waveamdmachine.reg<vgpr, 1, 0>, !waveamdmachine.reg<vgpr, 1, 1>, !waveamdmachine.reg<vgpr, 1, 2>, !waveamdmachine.reg<vgpr, 1, 3>)
// CHECK: %[[X:.+]] = waveamdmachine.v_mov_b32_tuple {{.*}} -> !waveamdmachine.reg<vgpr, 1, 5>
// CHECK: %[[Y:.+]] = waveamdmachine.v_mov_b32_tuple {{.*}} -> !waveamdmachine.reg<vgpr, 1, 6>
// CHECK: %[[Z:.+]] = waveamdmachine.v_mov_b32_tuple {{.*}} -> !waveamdmachine.reg<vgpr, 1, 7>
// CHECK: %[[E0CPY:.+]] = waveamdmachine.v_mov_b32_tuple %[[E]]#0 {registers = 1 : i64} : (!waveamdmachine.reg<vgpr, 1, 0>) -> !waveamdmachine.reg<vgpr, 1, 4>
// CHECK: %{{.+}} = waveamdmachine.tuple_from_elements %[[E0CPY]], %[[X]], %[[Y]], %[[Z]]
// CHECK-SAME: -> !waveamdmachine.reg<vgpr, 4, 4>
// CHECK: %{{.+}} = waveamdmachine.v_mov_b32_tuple %[[E]]#1 {{.*}} : (!waveamdmachine.reg<vgpr, 1, 1>)
func.func @intermediate_conflict_copies() {
  %zero = waveamdmachine.imm 0 : !waveamdmachine.imm
  %a = waveamdmachine.v_mov_b32_tuple %zero {registers = 4 : i64} : (!waveamdmachine.imm) -> !waveamdmachine.reg<vgpr, 4>
  %e:4 = waveamdmachine.tuple_to_elements %a
      : (!waveamdmachine.reg<vgpr, 4>) -> (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>)
  %x = waveamdmachine.v_mov_b32_tuple %zero {registers = 1 : i64} : (!waveamdmachine.imm) -> !waveamdmachine.reg<vgpr, 1>
  %y = waveamdmachine.v_mov_b32_tuple %zero {registers = 1 : i64} : (!waveamdmachine.imm) -> !waveamdmachine.reg<vgpr, 1>
  %z = waveamdmachine.v_mov_b32_tuple %zero {registers = 1 : i64} : (!waveamdmachine.imm) -> !waveamdmachine.reg<vgpr, 1>
  %b = waveamdmachine.tuple_from_elements %e#0, %x, %y, %z
      : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>) -> !waveamdmachine.reg<vgpr, 4>
  // Keep %e#1 live so the bug, if it returns, manifests as
  // %e#1 aliasing %x at the same physical slot.
  %sink = waveamdmachine.v_mov_b32_tuple %e#1 {registers = 1 : i64} : (!waveamdmachine.reg<vgpr, 1>) -> !waveamdmachine.reg<vgpr, 1>
  return
}

}

// -----

module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx1100"} {

// Long chain of perfect identity round-trips: every from_elements
// is a fully-matching gather of the preceding to_elements. All
// values alias one physical block; no copies.
//
// CHECK-LABEL: func.func @long_round_trip_chain_no_copies
// CHECK: %[[T1:.+]] = waveamdmachine.tuple_from_elements
// CHECK-SAME: -> !waveamdmachine.reg<vgpr, 4, 0>
// CHECK: %[[E:.+]]:4 = waveamdmachine.tuple_to_elements %[[T1]]
// CHECK-SAME: -> (!waveamdmachine.reg<vgpr, 1, 0>, !waveamdmachine.reg<vgpr, 1, 1>, !waveamdmachine.reg<vgpr, 1, 2>, !waveamdmachine.reg<vgpr, 1, 3>)
// CHECK-NOT: waveamdmachine.v_mov_b32_tuple %[[E]]
// CHECK: %[[T2:.+]] = waveamdmachine.tuple_from_elements %[[E]]#0, %[[E]]#1, %[[E]]#2, %[[E]]#3
// CHECK-SAME: -> !waveamdmachine.reg<vgpr, 4, 0>
// CHECK: %[[F:.+]]:4 = waveamdmachine.tuple_to_elements %[[T2]]
// CHECK-SAME: -> (!waveamdmachine.reg<vgpr, 1, 0>, !waveamdmachine.reg<vgpr, 1, 1>, !waveamdmachine.reg<vgpr, 1, 2>, !waveamdmachine.reg<vgpr, 1, 3>)
// CHECK-NOT: waveamdmachine.v_mov_b32_tuple %[[F]]
// CHECK: %{{.+}} = waveamdmachine.tuple_from_elements %[[F]]#0, %[[F]]#1, %[[F]]#2, %[[F]]#3
// CHECK-SAME: -> !waveamdmachine.reg<vgpr, 4, 0>
func.func @long_round_trip_chain_no_copies() {
  %zero = waveamdmachine.imm 0 : !waveamdmachine.imm
  %a = waveamdmachine.v_mov_b32_tuple %zero {registers = 1 : i64} : (!waveamdmachine.imm) -> !waveamdmachine.reg<vgpr, 1>
  %b = waveamdmachine.v_mov_b32_tuple %zero {registers = 1 : i64} : (!waveamdmachine.imm) -> !waveamdmachine.reg<vgpr, 1>
  %c = waveamdmachine.v_mov_b32_tuple %zero {registers = 1 : i64} : (!waveamdmachine.imm) -> !waveamdmachine.reg<vgpr, 1>
  %d = waveamdmachine.v_mov_b32_tuple %zero {registers = 1 : i64} : (!waveamdmachine.imm) -> !waveamdmachine.reg<vgpr, 1>
  %t1 = waveamdmachine.tuple_from_elements %a, %b, %c, %d
      : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>) -> !waveamdmachine.reg<vgpr, 4>
  %e:4 = waveamdmachine.tuple_to_elements %t1
      : (!waveamdmachine.reg<vgpr, 4>) -> (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>)
  %t2 = waveamdmachine.tuple_from_elements %e#0, %e#1, %e#2, %e#3
      : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>) -> !waveamdmachine.reg<vgpr, 4>
  %f:4 = waveamdmachine.tuple_to_elements %t2
      : (!waveamdmachine.reg<vgpr, 4>) -> (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>)
  %t3 = waveamdmachine.tuple_from_elements %f#0, %f#1, %f#2, %f#3
      : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>) -> !waveamdmachine.reg<vgpr, 4>
  return
}

}

// -----

module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx1100"} {

// Partial modify: from_elements consumes all to_elements results
// at matching slots EXCEPT one position which is a fresh value
// (the modified slot). Without copies the drag-in would pin the
// original e#2 at slot 2 of the new tuple, conflicting with the
// modified value. The fix copies every to-elements operand so
// the new tuple gets its own block.
//
// CHECK-LABEL: func.func @partial_modify_copies_all_source_operands
// CHECK: %[[A:.+]] = waveamdmachine.v_mov_b32_tuple {{.*}} -> !waveamdmachine.reg<vgpr, 4, 0>
// CHECK: %[[E:.+]]:4 = waveamdmachine.tuple_to_elements %[[A]]
// CHECK-COUNT-3: waveamdmachine.v_mov_b32_tuple %[[E]]#{{[0-9]+}} {registers = 1 : i64}
// CHECK: %{{.+}} = waveamdmachine.tuple_from_elements
// CHECK-SAME: -> !waveamdmachine.reg<vgpr, 4, 4>
func.func @partial_modify_copies_all_source_operands() {
  %zero = waveamdmachine.imm 0 : !waveamdmachine.imm
  %a = waveamdmachine.v_mov_b32_tuple %zero {registers = 4 : i64} : (!waveamdmachine.imm) -> !waveamdmachine.reg<vgpr, 4>
  %e:4 = waveamdmachine.tuple_to_elements %a
      : (!waveamdmachine.reg<vgpr, 4>) -> (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>)
  %modified = waveamdmachine.v_mov_b32_tuple %zero {registers = 1 : i64} : (!waveamdmachine.imm) -> !waveamdmachine.reg<vgpr, 1>
  %t = waveamdmachine.tuple_from_elements %e#0, %e#1, %modified, %e#3
      : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>) -> !waveamdmachine.reg<vgpr, 4>
  return
}

}

// -----

module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx1100"} {

// from_elements -> to_elements chain: the second from_elements is
// a perfect round-trip of t1 (a from_elements result), so no copies
// are needed and t2 aliases t1's block.
//
// CHECK-LABEL: func.func @from_then_to_then_from_no_copies
// CHECK: %[[T1:.+]] = waveamdmachine.tuple_from_elements
// CHECK-SAME: -> !waveamdmachine.reg<vgpr, 4, 0>
// CHECK: %[[E:.+]]:4 = waveamdmachine.tuple_to_elements %[[T1]]
// CHECK-NOT: waveamdmachine.v_mov_b32_tuple %[[E]]
// CHECK: %{{.+}} = waveamdmachine.tuple_from_elements %[[E]]#0, %[[E]]#1, %[[E]]#2, %[[E]]#3
// CHECK-SAME: -> !waveamdmachine.reg<vgpr, 4, 0>
func.func @from_then_to_then_from_no_copies() {
  %zero = waveamdmachine.imm 0 : !waveamdmachine.imm
  %a = waveamdmachine.v_mov_b32_tuple %zero {registers = 1 : i64} : (!waveamdmachine.imm) -> !waveamdmachine.reg<vgpr, 1>
  %b = waveamdmachine.v_mov_b32_tuple %zero {registers = 1 : i64} : (!waveamdmachine.imm) -> !waveamdmachine.reg<vgpr, 1>
  %c = waveamdmachine.v_mov_b32_tuple %zero {registers = 1 : i64} : (!waveamdmachine.imm) -> !waveamdmachine.reg<vgpr, 1>
  %d = waveamdmachine.v_mov_b32_tuple %zero {registers = 1 : i64} : (!waveamdmachine.imm) -> !waveamdmachine.reg<vgpr, 1>
  %t1 = waveamdmachine.tuple_from_elements %a, %b, %c, %d
      : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>) -> !waveamdmachine.reg<vgpr, 4>
  %e:4 = waveamdmachine.tuple_to_elements %t1
      : (!waveamdmachine.reg<vgpr, 4>) -> (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>)
  %t2 = waveamdmachine.tuple_from_elements %e#0, %e#1, %e#2, %e#3
      : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>) -> !waveamdmachine.reg<vgpr, 4>
  return
}

}

// -----

module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx1100"} {

// Subtuple drag-in: a width-2 sub-tuple anchored at offset 0 of an
// 8-wide source is combined with fresh ops in a new width-8 tuple.
// Without the guard the merge would pin the rest of the source's
// 8-dword interval into the new tuple. The fix copies the sub-tuple.
//
// CHECK-LABEL: func.func @subtuple_intermediate_conflict_copies
// CHECK: %[[A:.+]] = waveamdmachine.v_mov_b32_tuple {{.*}} -> !waveamdmachine.reg<vgpr, 8, 0>
// CHECK: %[[E:.+]]:2 = waveamdmachine.tuple_to_elements %[[A]]
// CHECK-SAME: -> (!waveamdmachine.reg<vgpr, 4, 0>, !waveamdmachine.reg<vgpr, 4, 4>)
// CHECK: %[[F:.+]] = waveamdmachine.v_mov_b32_tuple {{.*}} -> !waveamdmachine.reg<vgpr, 4, {{[0-9]+}}>
// CHECK: %[[E0CPY:.+]] = waveamdmachine.v_mov_b32_tuple %[[E]]#0 {registers = 4 : i64} : (!waveamdmachine.reg<vgpr, 4, 0>) -> !waveamdmachine.reg<vgpr, 4, 8>
// CHECK: %{{.+}} = waveamdmachine.tuple_from_elements %[[E0CPY]], %[[F]]
// CHECK-SAME: -> !waveamdmachine.reg<vgpr, 8, 8>
func.func @subtuple_intermediate_conflict_copies() {
  %zero = waveamdmachine.imm 0 : !waveamdmachine.imm
  %a = waveamdmachine.v_mov_b32_tuple %zero {registers = 8 : i64} : (!waveamdmachine.imm) -> !waveamdmachine.reg<vgpr, 8>
  %e:2 = waveamdmachine.tuple_to_elements %a
      : (!waveamdmachine.reg<vgpr, 8>) -> (!waveamdmachine.reg<vgpr, 4>, !waveamdmachine.reg<vgpr, 4>)
  %f = waveamdmachine.v_mov_b32_tuple %zero {registers = 4 : i64} : (!waveamdmachine.imm) -> !waveamdmachine.reg<vgpr, 4>
  %t = waveamdmachine.tuple_from_elements %e#0, %f
      : (!waveamdmachine.reg<vgpr, 4>, !waveamdmachine.reg<vgpr, 4>) -> !waveamdmachine.reg<vgpr, 8>
  // Force %e#1 to live past the from_elements so an aliasing bug
  // is observable.
  %sink = waveamdmachine.v_mov_b32_tuple %e#1 {registers = 4 : i64} : (!waveamdmachine.reg<vgpr, 4>) -> !waveamdmachine.reg<vgpr, 4>
  return
}

}
