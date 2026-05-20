// RUN: wave-opt --waveamd-reg-alloc %s | FileCheck %s

module attributes {wavemachine.target = "amdgcn-amd-amdhsa--gfx1100"} {

// tuple_to_elements pins each result at `tuple_phys + i`. With no
// kernel reservation the tuple's 8-aligned block lands at v0..v7,
// so element[i] lands at v[i] verbatim.
//
// CHECK-LABEL: func.func @tuple_to_elements_slot_aliases
// CHECK: %[[T:.+]] = wavemachine.v_mov_b32_tuple {{.*}} : (!wavemachine.imm) -> !wavemachine.reg<vgpr, 8, 0>
// CHECK: %{{.+}}:8 = wavemachine.tuple_to_elements %[[T]]
// CHECK-SAME: -> (!wavemachine.reg<vgpr, 1, 0>, !wavemachine.reg<vgpr, 1, 1>, !wavemachine.reg<vgpr, 1, 2>, !wavemachine.reg<vgpr, 1, 3>, !wavemachine.reg<vgpr, 1, 4>, !wavemachine.reg<vgpr, 1, 5>, !wavemachine.reg<vgpr, 1, 6>, !wavemachine.reg<vgpr, 1, 7>)
func.func @tuple_to_elements_slot_aliases() {
  %zero = wavemachine.imm 0 : !wavemachine.imm
  %t = wavemachine.v_mov_b32_tuple %zero {registers = 8 : i64}
      : (!wavemachine.imm) -> !wavemachine.reg<vgpr, 8>
  %e:8 = wavemachine.tuple_to_elements %t
      : (!wavemachine.reg<vgpr, 8>) -> (!wavemachine.reg<vgpr, 1>,
                                        !wavemachine.reg<vgpr, 1>,
                                        !wavemachine.reg<vgpr, 1>,
                                        !wavemachine.reg<vgpr, 1>,
                                        !wavemachine.reg<vgpr, 1>,
                                        !wavemachine.reg<vgpr, 1>,
                                        !wavemachine.reg<vgpr, 1>,
                                        !wavemachine.reg<vgpr, 1>)
  return
}

// tuple_from_elements pins each operand at `tuple_phys + i` and the
// tuple result at `tuple_phys + 0`. With no kernel reservation the
// width-8 block lands at v0..v7.
//
// CHECK-LABEL: func.func @tuple_from_elements_slot_aliases
// CHECK: %[[A:.+]] = wavemachine.v_mov_b32_tuple {{.*}} -> !wavemachine.reg<vgpr, 1, 0>
// CHECK: %[[B:.+]] = wavemachine.v_mov_b32_tuple {{.*}} -> !wavemachine.reg<vgpr, 1, 1>
// CHECK: %[[C:.+]] = wavemachine.v_mov_b32_tuple {{.*}} -> !wavemachine.reg<vgpr, 1, 2>
// CHECK: %[[D:.+]] = wavemachine.v_mov_b32_tuple {{.*}} -> !wavemachine.reg<vgpr, 1, 3>
// CHECK: %[[E:.+]] = wavemachine.v_mov_b32_tuple {{.*}} -> !wavemachine.reg<vgpr, 1, 4>
// CHECK: %[[F:.+]] = wavemachine.v_mov_b32_tuple {{.*}} -> !wavemachine.reg<vgpr, 1, 5>
// CHECK: %[[G:.+]] = wavemachine.v_mov_b32_tuple {{.*}} -> !wavemachine.reg<vgpr, 1, 6>
// CHECK: %[[H:.+]] = wavemachine.v_mov_b32_tuple {{.*}} -> !wavemachine.reg<vgpr, 1, 7>
// CHECK: %{{.+}} = wavemachine.tuple_from_elements %[[A]], %[[B]], %[[C]], %[[D]], %[[E]], %[[F]], %[[G]], %[[H]]
// CHECK-SAME: -> !wavemachine.reg<vgpr, 8, 0>
func.func @tuple_from_elements_slot_aliases() {
  %zero = wavemachine.imm 0 : !wavemachine.imm
  %a = wavemachine.v_mov_b32_tuple %zero {registers = 1 : i64} : (!wavemachine.imm) -> !wavemachine.reg<vgpr, 1>
  %b = wavemachine.v_mov_b32_tuple %zero {registers = 1 : i64} : (!wavemachine.imm) -> !wavemachine.reg<vgpr, 1>
  %c = wavemachine.v_mov_b32_tuple %zero {registers = 1 : i64} : (!wavemachine.imm) -> !wavemachine.reg<vgpr, 1>
  %d = wavemachine.v_mov_b32_tuple %zero {registers = 1 : i64} : (!wavemachine.imm) -> !wavemachine.reg<vgpr, 1>
  %e = wavemachine.v_mov_b32_tuple %zero {registers = 1 : i64} : (!wavemachine.imm) -> !wavemachine.reg<vgpr, 1>
  %f = wavemachine.v_mov_b32_tuple %zero {registers = 1 : i64} : (!wavemachine.imm) -> !wavemachine.reg<vgpr, 1>
  %g = wavemachine.v_mov_b32_tuple %zero {registers = 1 : i64} : (!wavemachine.imm) -> !wavemachine.reg<vgpr, 1>
  %h = wavemachine.v_mov_b32_tuple %zero {registers = 1 : i64} : (!wavemachine.imm) -> !wavemachine.reg<vgpr, 1>
  %t = wavemachine.tuple_from_elements %a, %b, %c, %d, %e, %f, %g, %h
      : (!wavemachine.reg<vgpr, 1>, !wavemachine.reg<vgpr, 1>,
         !wavemachine.reg<vgpr, 1>, !wavemachine.reg<vgpr, 1>,
         !wavemachine.reg<vgpr, 1>, !wavemachine.reg<vgpr, 1>,
         !wavemachine.reg<vgpr, 1>, !wavemachine.reg<vgpr, 1>)
      -> !wavemachine.reg<vgpr, 8>
  return
}

// Round-trip: split, reassemble, both passes should reuse the same
// physical block. The intermediate elements alias slots [0..7]
// of the same v0..v7 block held by both tuples.
//
// CHECK-LABEL: func.func @tuple_round_trip_slot_aliases
// CHECK: %[[T0:.+]] = wavemachine.v_mov_b32_tuple {{.*}} -> !wavemachine.reg<vgpr, 8, 0>
// CHECK: %[[E:.+]]:8 = wavemachine.tuple_to_elements %[[T0]]
// CHECK-SAME: -> (!wavemachine.reg<vgpr, 1, 0>, !wavemachine.reg<vgpr, 1, 1>, !wavemachine.reg<vgpr, 1, 2>, !wavemachine.reg<vgpr, 1, 3>, !wavemachine.reg<vgpr, 1, 4>, !wavemachine.reg<vgpr, 1, 5>, !wavemachine.reg<vgpr, 1, 6>, !wavemachine.reg<vgpr, 1, 7>)
// CHECK: %[[T1:.+]] = wavemachine.tuple_from_elements %[[E]]#0, %[[E]]#1, %[[E]]#2, %[[E]]#3, %[[E]]#4, %[[E]]#5, %[[E]]#6, %[[E]]#7
// CHECK-SAME: -> !wavemachine.reg<vgpr, 8, 0>
func.func @tuple_round_trip_slot_aliases() {
  %zero = wavemachine.imm 0 : !wavemachine.imm
  %t0 = wavemachine.v_mov_b32_tuple %zero {registers = 8 : i64}
      : (!wavemachine.imm) -> !wavemachine.reg<vgpr, 8>
  %e:8 = wavemachine.tuple_to_elements %t0
      : (!wavemachine.reg<vgpr, 8>) -> (!wavemachine.reg<vgpr, 1>,
                                        !wavemachine.reg<vgpr, 1>,
                                        !wavemachine.reg<vgpr, 1>,
                                        !wavemachine.reg<vgpr, 1>,
                                        !wavemachine.reg<vgpr, 1>,
                                        !wavemachine.reg<vgpr, 1>,
                                        !wavemachine.reg<vgpr, 1>,
                                        !wavemachine.reg<vgpr, 1>)
  %t1 = wavemachine.tuple_from_elements
      %e#0, %e#1, %e#2, %e#3, %e#4, %e#5, %e#6, %e#7
      : (!wavemachine.reg<vgpr, 1>, !wavemachine.reg<vgpr, 1>,
         !wavemachine.reg<vgpr, 1>, !wavemachine.reg<vgpr, 1>,
         !wavemachine.reg<vgpr, 1>, !wavemachine.reg<vgpr, 1>,
         !wavemachine.reg<vgpr, 1>, !wavemachine.reg<vgpr, 1>)
      -> !wavemachine.reg<vgpr, 8>
  return
}

}
