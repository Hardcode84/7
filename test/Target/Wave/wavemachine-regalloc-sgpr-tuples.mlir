// RUN: wave-opt --waveamd-reg-alloc -split-input-file %s | FileCheck %s

module attributes {wavemachine.target = "amdgcn-amd-amdhsa--gfx1100"} {

// SGPR side of `tuple_to_elements` / `tuple_from_elements`: the
// regalloc places each sub-tuple at its cumulative offset within
// the parent SGPR block. Wider SGPR pieces stay together; the
// allocator picks an aligned base for the whole tuple.
//
// CHECK-LABEL: func.func @sgpr_tuple_to_elements
// CHECK: %[[A:.+]] = wavemachine.s_mov_b32_tuple {{.*}} -> !wavemachine.reg<sgpr, 4, 0>
// CHECK: %{{.+}}:2 = wavemachine.tuple_to_elements %[[A]]
// CHECK-SAME: -> (!wavemachine.reg<sgpr, 2, 0>, !wavemachine.reg<sgpr, 2, 2>)
func.func @sgpr_tuple_to_elements() {
  %zero = wavemachine.imm 0 : !wavemachine.imm
  %a = wavemachine.s_mov_b32_tuple %zero {registers = 4 : i64} : (!wavemachine.imm) -> !wavemachine.reg<sgpr, 4>
  %e:2 = wavemachine.tuple_to_elements %a
      : (!wavemachine.reg<sgpr, 4>) -> (!wavemachine.reg<sgpr, 2>, !wavemachine.reg<sgpr, 2>)
  return
}

// SGPR `tuple_from_elements`: gather two SGPR-pair pieces into a
// width-4 SGPR tuple; both halves land at cumulative offsets 0 / 2.
//
// CHECK-LABEL: func.func @sgpr_tuple_from_elements
// CHECK: %[[LO:.+]] = wavemachine.s_mov_b32_tuple {{.*}} -> !wavemachine.reg<sgpr, 2, 0>
// CHECK: %[[HI:.+]] = wavemachine.s_mov_b32_tuple {{.*}} -> !wavemachine.reg<sgpr, 2, 2>
// CHECK: %{{.+}} = wavemachine.tuple_from_elements %[[LO]], %[[HI]]
// CHECK-SAME: -> !wavemachine.reg<sgpr, 4, 0>
func.func @sgpr_tuple_from_elements() {
  %zero = wavemachine.imm 0 : !wavemachine.imm
  %lo = wavemachine.s_mov_b32_tuple %zero {registers = 2 : i64} : (!wavemachine.imm) -> !wavemachine.reg<sgpr, 2>
  %hi = wavemachine.s_mov_b32_tuple %zero {registers = 2 : i64} : (!wavemachine.imm) -> !wavemachine.reg<sgpr, 2>
  %t = wavemachine.tuple_from_elements %lo, %hi
      : (!wavemachine.reg<sgpr, 2>, !wavemachine.reg<sgpr, 2>) -> !wavemachine.reg<sgpr, 4>
  return
}

// SGPR shuffle: anchor mismatch triggers `s_mov_b32_tuple` copies
// just like the VGPR shuffle case. The new tuple lands in a fresh
// disjoint block.
//
// CHECK-LABEL: func.func @sgpr_shuffle_copies
// CHECK: %[[A:.+]] = wavemachine.s_mov_b32_tuple {{.*}} -> !wavemachine.reg<sgpr, 4, 0>
// CHECK: %[[E:.+]]:2 = wavemachine.tuple_to_elements %[[A]]
// CHECK-SAME: -> (!wavemachine.reg<sgpr, 2, 0>, !wavemachine.reg<sgpr, 2, 2>)
// CHECK: %[[C1:.+]] = wavemachine.s_mov_b32_tuple %[[E]]#1 {registers = 2 : i64} : (!wavemachine.reg<sgpr, 2, 2>) -> !wavemachine.reg<sgpr, 2, 4>
// CHECK: %[[C0:.+]] = wavemachine.s_mov_b32_tuple %[[E]]#0 {registers = 2 : i64} : (!wavemachine.reg<sgpr, 2, 0>) -> !wavemachine.reg<sgpr, 2, 6>
// CHECK: %{{.+}} = wavemachine.tuple_from_elements %[[C1]], %[[C0]]
// CHECK-SAME: -> !wavemachine.reg<sgpr, 4, 4>
func.func @sgpr_shuffle_copies() {
  %zero = wavemachine.imm 0 : !wavemachine.imm
  %a = wavemachine.s_mov_b32_tuple %zero {registers = 4 : i64} : (!wavemachine.imm) -> !wavemachine.reg<sgpr, 4>
  %e:2 = wavemachine.tuple_to_elements %a
      : (!wavemachine.reg<sgpr, 4>) -> (!wavemachine.reg<sgpr, 2>, !wavemachine.reg<sgpr, 2>)
  %b = wavemachine.tuple_from_elements %e#1, %e#0
      : (!wavemachine.reg<sgpr, 2>, !wavemachine.reg<sgpr, 2>) -> !wavemachine.reg<sgpr, 4>
  return
}

}
