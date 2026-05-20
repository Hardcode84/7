// RUN: wave-opt --waveamd-reg-alloc %s | FileCheck %s
// RUN: wave-opt --waveamd-reg-alloc %s | wave-opt | FileCheck %s

module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx1100"} {

// tuple_to_elements pins each result at `tuple_phys + i`. With no
// kernel reservation the tuple's 8-aligned block lands at v0..v7,
// so element[i] lands at v[i] verbatim.
//
// CHECK-LABEL: func.func @tuple_to_elements_slot_aliases
// CHECK: %[[T:.+]] = waveamdmachine.v_mov_b32_tuple {{.*}} : (!waveamdmachine.imm) -> !waveamdmachine.reg<vgpr, 8, 0>
// CHECK: %{{.+}}:8 = waveamdmachine.tuple_to_elements %[[T]]
// CHECK-SAME: -> (!waveamdmachine.reg<vgpr, 1, 0>, !waveamdmachine.reg<vgpr, 1, 1>, !waveamdmachine.reg<vgpr, 1, 2>, !waveamdmachine.reg<vgpr, 1, 3>, !waveamdmachine.reg<vgpr, 1, 4>, !waveamdmachine.reg<vgpr, 1, 5>, !waveamdmachine.reg<vgpr, 1, 6>, !waveamdmachine.reg<vgpr, 1, 7>)
func.func @tuple_to_elements_slot_aliases() {
  %zero = waveamdmachine.imm 0 : !waveamdmachine.imm
  %t = waveamdmachine.v_mov_b32_tuple %zero {registers = 8 : i64}
      : (!waveamdmachine.imm) -> !waveamdmachine.reg<vgpr, 8>
  %e:8 = waveamdmachine.tuple_to_elements %t
      : (!waveamdmachine.reg<vgpr, 8>) -> (!waveamdmachine.reg<vgpr, 1>,
                                        !waveamdmachine.reg<vgpr, 1>,
                                        !waveamdmachine.reg<vgpr, 1>,
                                        !waveamdmachine.reg<vgpr, 1>,
                                        !waveamdmachine.reg<vgpr, 1>,
                                        !waveamdmachine.reg<vgpr, 1>,
                                        !waveamdmachine.reg<vgpr, 1>,
                                        !waveamdmachine.reg<vgpr, 1>)
  return
}

// tuple_from_elements pins each operand at `tuple_phys + i` and the
// tuple result at `tuple_phys + 0`. With no kernel reservation the
// width-8 block lands at v0..v7.
//
// CHECK-LABEL: func.func @tuple_from_elements_slot_aliases
// CHECK: %[[A:.+]] = waveamdmachine.v_mov_b32_tuple {{.*}} -> !waveamdmachine.reg<vgpr, 1, 0>
// CHECK: %[[B:.+]] = waveamdmachine.v_mov_b32_tuple {{.*}} -> !waveamdmachine.reg<vgpr, 1, 1>
// CHECK: %[[C:.+]] = waveamdmachine.v_mov_b32_tuple {{.*}} -> !waveamdmachine.reg<vgpr, 1, 2>
// CHECK: %[[D:.+]] = waveamdmachine.v_mov_b32_tuple {{.*}} -> !waveamdmachine.reg<vgpr, 1, 3>
// CHECK: %[[E:.+]] = waveamdmachine.v_mov_b32_tuple {{.*}} -> !waveamdmachine.reg<vgpr, 1, 4>
// CHECK: %[[F:.+]] = waveamdmachine.v_mov_b32_tuple {{.*}} -> !waveamdmachine.reg<vgpr, 1, 5>
// CHECK: %[[G:.+]] = waveamdmachine.v_mov_b32_tuple {{.*}} -> !waveamdmachine.reg<vgpr, 1, 6>
// CHECK: %[[H:.+]] = waveamdmachine.v_mov_b32_tuple {{.*}} -> !waveamdmachine.reg<vgpr, 1, 7>
// CHECK: %{{.+}} = waveamdmachine.tuple_from_elements %[[A]], %[[B]], %[[C]], %[[D]], %[[E]], %[[F]], %[[G]], %[[H]]
// CHECK-SAME: -> !waveamdmachine.reg<vgpr, 8, 0>
func.func @tuple_from_elements_slot_aliases() {
  %zero = waveamdmachine.imm 0 : !waveamdmachine.imm
  %a = waveamdmachine.v_mov_b32_tuple %zero {registers = 1 : i64} : (!waveamdmachine.imm) -> !waveamdmachine.reg<vgpr, 1>
  %b = waveamdmachine.v_mov_b32_tuple %zero {registers = 1 : i64} : (!waveamdmachine.imm) -> !waveamdmachine.reg<vgpr, 1>
  %c = waveamdmachine.v_mov_b32_tuple %zero {registers = 1 : i64} : (!waveamdmachine.imm) -> !waveamdmachine.reg<vgpr, 1>
  %d = waveamdmachine.v_mov_b32_tuple %zero {registers = 1 : i64} : (!waveamdmachine.imm) -> !waveamdmachine.reg<vgpr, 1>
  %e = waveamdmachine.v_mov_b32_tuple %zero {registers = 1 : i64} : (!waveamdmachine.imm) -> !waveamdmachine.reg<vgpr, 1>
  %f = waveamdmachine.v_mov_b32_tuple %zero {registers = 1 : i64} : (!waveamdmachine.imm) -> !waveamdmachine.reg<vgpr, 1>
  %g = waveamdmachine.v_mov_b32_tuple %zero {registers = 1 : i64} : (!waveamdmachine.imm) -> !waveamdmachine.reg<vgpr, 1>
  %h = waveamdmachine.v_mov_b32_tuple %zero {registers = 1 : i64} : (!waveamdmachine.imm) -> !waveamdmachine.reg<vgpr, 1>
  %t = waveamdmachine.tuple_from_elements %a, %b, %c, %d, %e, %f, %g, %h
      : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>,
         !waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>,
         !waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>,
         !waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>)
      -> !waveamdmachine.reg<vgpr, 8>
  return
}

// Round-trip: split, reassemble, both passes should reuse the same
// physical block. The intermediate elements alias slots [0..7]
// of the same v0..v7 block held by both tuples.
//
// CHECK-LABEL: func.func @tuple_round_trip_slot_aliases
// CHECK: %[[T0:.+]] = waveamdmachine.v_mov_b32_tuple {{.*}} -> !waveamdmachine.reg<vgpr, 8, 0>
// CHECK: %[[E:.+]]:8 = waveamdmachine.tuple_to_elements %[[T0]]
// CHECK-SAME: -> (!waveamdmachine.reg<vgpr, 1, 0>, !waveamdmachine.reg<vgpr, 1, 1>, !waveamdmachine.reg<vgpr, 1, 2>, !waveamdmachine.reg<vgpr, 1, 3>, !waveamdmachine.reg<vgpr, 1, 4>, !waveamdmachine.reg<vgpr, 1, 5>, !waveamdmachine.reg<vgpr, 1, 6>, !waveamdmachine.reg<vgpr, 1, 7>)
// CHECK: %[[T1:.+]] = waveamdmachine.tuple_from_elements %[[E]]#0, %[[E]]#1, %[[E]]#2, %[[E]]#3, %[[E]]#4, %[[E]]#5, %[[E]]#6, %[[E]]#7
// CHECK-SAME: -> !waveamdmachine.reg<vgpr, 8, 0>
func.func @tuple_round_trip_slot_aliases() {
  %zero = waveamdmachine.imm 0 : !waveamdmachine.imm
  %t0 = waveamdmachine.v_mov_b32_tuple %zero {registers = 8 : i64}
      : (!waveamdmachine.imm) -> !waveamdmachine.reg<vgpr, 8>
  %e:8 = waveamdmachine.tuple_to_elements %t0
      : (!waveamdmachine.reg<vgpr, 8>) -> (!waveamdmachine.reg<vgpr, 1>,
                                        !waveamdmachine.reg<vgpr, 1>,
                                        !waveamdmachine.reg<vgpr, 1>,
                                        !waveamdmachine.reg<vgpr, 1>,
                                        !waveamdmachine.reg<vgpr, 1>,
                                        !waveamdmachine.reg<vgpr, 1>,
                                        !waveamdmachine.reg<vgpr, 1>,
                                        !waveamdmachine.reg<vgpr, 1>)
  %t1 = waveamdmachine.tuple_from_elements
      %e#0, %e#1, %e#2, %e#3, %e#4, %e#5, %e#6, %e#7
      : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>,
         !waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>,
         !waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>,
         !waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>)
      -> !waveamdmachine.reg<vgpr, 8>
  return
}

}
