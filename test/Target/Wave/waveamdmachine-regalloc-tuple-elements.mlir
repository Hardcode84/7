// RUN: wave-opt --waveamd-reg-alloc %s | FileCheck %s
// RUN: wave-opt --waveamd-reg-alloc %s | wave-opt | FileCheck %s

module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx1100"} {

// tuple_to_elements pins each result at `tuple_phys + i`.
//
// CHECK-LABEL: func.func @tuple_to_elements_slot_aliases
// CHECK: %[[T:.+]] = waveamdmachine.v_mov_b32_tuple {{.*}} : (!waveamdmachine.imm) -> !waveamdmachine.reg<vgpr, 8, [[#TOE_BASE:]]>
// CHECK: %{{.+}}:8 = waveamdmachine.tuple_to_elements %[[T]]
// CHECK-SAME: -> (!waveamdmachine.reg<vgpr, 1, [[#TOE_BASE]]>
// CHECK-SAME: !waveamdmachine.reg<vgpr, 1, [[#TOE_BASE+1]]>
// CHECK-SAME: !waveamdmachine.reg<vgpr, 1, [[#TOE_BASE+2]]>
// CHECK-SAME: !waveamdmachine.reg<vgpr, 1, [[#TOE_BASE+3]]>
// CHECK-SAME: !waveamdmachine.reg<vgpr, 1, [[#TOE_BASE+4]]>
// CHECK-SAME: !waveamdmachine.reg<vgpr, 1, [[#TOE_BASE+5]]>
// CHECK-SAME: !waveamdmachine.reg<vgpr, 1, [[#TOE_BASE+6]]>
// CHECK-SAME: !waveamdmachine.reg<vgpr, 1, [[#TOE_BASE+7]]>)
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

// tuple_from_elements pins each operand at `tuple_phys + i`.
//
// CHECK-LABEL: func.func @tuple_from_elements_slot_aliases
// CHECK: %[[A:.+]] = waveamdmachine.v_mov_b32_tuple {{.*}} -> !waveamdmachine.reg<vgpr, 1, [[#TFE_BASE:]]>
// CHECK: %[[B:.+]] = waveamdmachine.v_mov_b32_tuple {{.*}} -> !waveamdmachine.reg<vgpr, 1, [[#TFE_BASE+1]]>
// CHECK: %[[C:.+]] = waveamdmachine.v_mov_b32_tuple {{.*}} -> !waveamdmachine.reg<vgpr, 1, [[#TFE_BASE+2]]>
// CHECK: %[[D:.+]] = waveamdmachine.v_mov_b32_tuple {{.*}} -> !waveamdmachine.reg<vgpr, 1, [[#TFE_BASE+3]]>
// CHECK: %[[E:.+]] = waveamdmachine.v_mov_b32_tuple {{.*}} -> !waveamdmachine.reg<vgpr, 1, [[#TFE_BASE+4]]>
// CHECK: %[[F:.+]] = waveamdmachine.v_mov_b32_tuple {{.*}} -> !waveamdmachine.reg<vgpr, 1, [[#TFE_BASE+5]]>
// CHECK: %[[G:.+]] = waveamdmachine.v_mov_b32_tuple {{.*}} -> !waveamdmachine.reg<vgpr, 1, [[#TFE_BASE+6]]>
// CHECK: %[[H:.+]] = waveamdmachine.v_mov_b32_tuple {{.*}} -> !waveamdmachine.reg<vgpr, 1, [[#TFE_BASE+7]]>
// CHECK: %{{.+}} = waveamdmachine.tuple_from_elements %[[A]], %[[B]], %[[C]], %[[D]], %[[E]], %[[F]], %[[G]], %[[H]]
// CHECK-SAME: -> !waveamdmachine.reg<vgpr, 8, [[#TFE_BASE]]>
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

// Pinned tuple result cannot anchor a virtual coalesced interval; its
// operands still have normal uses at the gather.
//
// CHECK-LABEL: func.func @pinned_tuple_from_elements_keeps_operands_live
// CHECK: %[[A:.+]] = waveamdmachine.v_mov_b32_tuple {{.*}} -> !waveamdmachine.reg<vgpr, 1, [[#PIN_BASE:]]>
// CHECK: %[[B:.+]] = waveamdmachine.v_mov_b32_tuple {{.*}} -> !waveamdmachine.reg<vgpr, 1, [[#PIN_BASE+1]]>
// CHECK: %{{.+}} = waveamdmachine.tuple_from_elements %[[A]], %[[B]]
// CHECK-SAME: -> !waveamdmachine.reg<vgpr, 2, [[#PIN_BASE]]>
func.func @pinned_tuple_from_elements_keeps_operands_live() {
  %zero = waveamdmachine.imm 0 : !waveamdmachine.imm
  %a = waveamdmachine.v_mov_b32_tuple %zero {registers = 1 : i64}
      : (!waveamdmachine.imm) -> !waveamdmachine.reg<vgpr, 1>
  %b = waveamdmachine.v_mov_b32_tuple %zero {registers = 1 : i64}
      : (!waveamdmachine.imm) -> !waveamdmachine.reg<vgpr, 1>
  %t = waveamdmachine.tuple_from_elements %a, %b
      : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>)
      -> !waveamdmachine.reg<vgpr, 2, 0>
  return
}

// Round-trip: split, reassemble, both passes should reuse the same
// physical block. Intermediate elements alias slots 0..7 of that block.
//
// CHECK-LABEL: func.func @tuple_round_trip_slot_aliases
// CHECK: %[[T0:.+]] = waveamdmachine.v_mov_b32_tuple {{.*}} -> !waveamdmachine.reg<vgpr, 8, [[#RT_BASE:]]>
// CHECK: %[[E:.+]]:8 = waveamdmachine.tuple_to_elements %[[T0]]
// CHECK-SAME: -> (!waveamdmachine.reg<vgpr, 1, [[#RT_BASE]]>
// CHECK-SAME: !waveamdmachine.reg<vgpr, 1, [[#RT_BASE+1]]>
// CHECK-SAME: !waveamdmachine.reg<vgpr, 1, [[#RT_BASE+2]]>
// CHECK-SAME: !waveamdmachine.reg<vgpr, 1, [[#RT_BASE+3]]>
// CHECK-SAME: !waveamdmachine.reg<vgpr, 1, [[#RT_BASE+4]]>
// CHECK-SAME: !waveamdmachine.reg<vgpr, 1, [[#RT_BASE+5]]>
// CHECK-SAME: !waveamdmachine.reg<vgpr, 1, [[#RT_BASE+6]]>
// CHECK-SAME: !waveamdmachine.reg<vgpr, 1, [[#RT_BASE+7]]>)
// CHECK: %[[T1:.+]] = waveamdmachine.tuple_from_elements %[[E]]#0, %[[E]]#1, %[[E]]#2, %[[E]]#3, %[[E]]#4, %[[E]]#5, %[[E]]#6, %[[E]]#7
// CHECK-SAME: -> !waveamdmachine.reg<vgpr, 8, [[#RT_BASE]]>
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
