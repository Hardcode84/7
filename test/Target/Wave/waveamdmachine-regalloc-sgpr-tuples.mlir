// RUN: wave-opt --waveamd-reg-alloc -split-input-file %s | FileCheck %s
// RUN: wave-opt --waveamd-reg-alloc -split-input-file %s | wave-opt -split-input-file | FileCheck %s

module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx1100"} {

// SGPR side of `tuple_to_elements` / `tuple_from_elements`: the
// regalloc places each sub-tuple at its cumulative offset within
// the parent SGPR block. Wider SGPR pieces stay together; the
// allocator picks an aligned base for the whole tuple.
//
// CHECK-LABEL: func.func @sgpr_tuple_to_elements
// CHECK: %[[A:.+]] = waveamdmachine.s_mov_b32_tuple {{.*}} -> !waveamdmachine.reg<sgpr, 4, 0>
// CHECK: %{{.+}}:2 = waveamdmachine.tuple_to_elements %[[A]]
// CHECK-SAME: -> (!waveamdmachine.reg<sgpr, 2, 0>, !waveamdmachine.reg<sgpr, 2, 2>)
func.func @sgpr_tuple_to_elements() {
  %zero = waveamdmachine.imm 0 : !waveamdmachine.imm
  %a = waveamdmachine.s_mov_b32_tuple %zero {registers = 4 : i64} : (!waveamdmachine.imm) -> !waveamdmachine.reg<sgpr, 4>
  %e:2 = waveamdmachine.tuple_to_elements %a
      : (!waveamdmachine.reg<sgpr, 4>) -> (!waveamdmachine.reg<sgpr, 2>, !waveamdmachine.reg<sgpr, 2>)
  return
}

// SGPR `tuple_from_elements`: gather two SGPR-pair pieces into a
// width-4 SGPR tuple; both halves land at cumulative offsets 0 / 2.
//
// CHECK-LABEL: func.func @sgpr_tuple_from_elements
// CHECK: %[[LO:.+]] = waveamdmachine.s_mov_b32_tuple {{.*}} -> !waveamdmachine.reg<sgpr, 2, 0>
// CHECK: %[[HI:.+]] = waveamdmachine.s_mov_b32_tuple {{.*}} -> !waveamdmachine.reg<sgpr, 2, 2>
// CHECK: %{{.+}} = waveamdmachine.tuple_from_elements %[[LO]], %[[HI]]
// CHECK-SAME: -> !waveamdmachine.reg<sgpr, 4, 0>
func.func @sgpr_tuple_from_elements() {
  %zero = waveamdmachine.imm 0 : !waveamdmachine.imm
  %lo = waveamdmachine.s_mov_b32_tuple %zero {registers = 2 : i64} : (!waveamdmachine.imm) -> !waveamdmachine.reg<sgpr, 2>
  %hi = waveamdmachine.s_mov_b32_tuple %zero {registers = 2 : i64} : (!waveamdmachine.imm) -> !waveamdmachine.reg<sgpr, 2>
  %t = waveamdmachine.tuple_from_elements %lo, %hi
      : (!waveamdmachine.reg<sgpr, 2>, !waveamdmachine.reg<sgpr, 2>) -> !waveamdmachine.reg<sgpr, 4>
  return
}

// SGPR shuffle: anchor mismatch triggers `s_mov_b32_tuple` copies
// just like the VGPR shuffle case. The new tuple lands in a fresh
// disjoint block.
//
// CHECK-LABEL: func.func @sgpr_shuffle_copies
// CHECK: %[[A:.+]] = waveamdmachine.s_mov_b32_tuple {{.*}} -> !waveamdmachine.reg<sgpr, 4, 0>
// CHECK: %[[E:.+]]:2 = waveamdmachine.tuple_to_elements %[[A]]
// CHECK-SAME: -> (!waveamdmachine.reg<sgpr, 2, 0>, !waveamdmachine.reg<sgpr, 2, 2>)
// CHECK: %[[C1:.+]] = waveamdmachine.s_mov_b32_tuple %[[E]]#1 {registers = 2 : i64} : (!waveamdmachine.reg<sgpr, 2, 2>) -> !waveamdmachine.reg<sgpr, 2, 4>
// CHECK: %[[C0:.+]] = waveamdmachine.s_mov_b32_tuple %[[E]]#0 {registers = 2 : i64} : (!waveamdmachine.reg<sgpr, 2, 0>) -> !waveamdmachine.reg<sgpr, 2, 6>
// CHECK: %{{.+}} = waveamdmachine.tuple_from_elements %[[C1]], %[[C0]]
// CHECK-SAME: -> !waveamdmachine.reg<sgpr, 4, 4>
func.func @sgpr_shuffle_copies() {
  %zero = waveamdmachine.imm 0 : !waveamdmachine.imm
  %a = waveamdmachine.s_mov_b32_tuple %zero {registers = 4 : i64} : (!waveamdmachine.imm) -> !waveamdmachine.reg<sgpr, 4>
  %e:2 = waveamdmachine.tuple_to_elements %a
      : (!waveamdmachine.reg<sgpr, 4>) -> (!waveamdmachine.reg<sgpr, 2>, !waveamdmachine.reg<sgpr, 2>)
  %b = waveamdmachine.tuple_from_elements %e#1, %e#0
      : (!waveamdmachine.reg<sgpr, 2>, !waveamdmachine.reg<sgpr, 2>) -> !waveamdmachine.reg<sgpr, 4>
  return
}

}
