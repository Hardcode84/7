// RUN: wave-opt --waveamd-pack-vgpr-zero-moves -split-input-file %s | FileCheck %s --check-prefix=PACK
// RUN: wave-opt --waveamd-pack-vgpr-zero-moves -split-input-file %s | wave-opt -split-input-file | FileCheck %s --check-prefix=PACK
// RUN: wave-opt --waveamd-pack-vgpr-zero-moves --waveamd-insert-ticket-waits --waveamd-insert-hazard-waits -split-input-file %s | FileCheck %s --check-prefix=WAITS

module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx950"} {

// PACK-LABEL: func.func @even_zero_tuple
// PACK: %[[PAIR0:.+]] = waveamdmachine.v_mov_b64_tuple
// PACK-SAME: -> !waveamdmachine.reg<vgpr, 2, 48>
// PACK: %[[PAIR1:.+]] = waveamdmachine.v_mov_b64_tuple
// PACK-SAME: -> !waveamdmachine.reg<vgpr, 2, 50>
// PACK: waveamdmachine.tuple_from_elements %[[PAIR0]], %[[PAIR1]]
// PACK-SAME: -> !waveamdmachine.reg<vgpr, 4, 48>
func.func @even_zero_tuple() {
  %zero = waveamdmachine.imm 0 : !waveamdmachine.imm
  %wide = waveamdmachine.v_mov_b32_tuple %zero {registers = 4 : i64}
      : (!waveamdmachine.imm) -> !waveamdmachine.reg<vgpr, 4, 48>
  return
}

// PACK-LABEL: func.func @odd_zero_tuple
// PACK: %[[HEAD:.+]] = waveamdmachine.v_mov_b32_tuple
// PACK-SAME: -> !waveamdmachine.reg<vgpr, 1, 49>
// PACK: %[[PAIR:.+]] = waveamdmachine.v_mov_b64_tuple
// PACK-SAME: -> !waveamdmachine.reg<vgpr, 2, 50>
// PACK: %[[TAIL:.+]] = waveamdmachine.v_mov_b32_tuple
// PACK-SAME: -> !waveamdmachine.reg<vgpr, 1, 52>
// PACK: waveamdmachine.tuple_from_elements %[[HEAD]], %[[PAIR]], %[[TAIL]]
// PACK-SAME: -> !waveamdmachine.reg<vgpr, 4, 49>
func.func @odd_zero_tuple() {
  %zero = waveamdmachine.imm 0 : !waveamdmachine.imm
  %wide = waveamdmachine.v_mov_b32_tuple %zero {registers = 4 : i64}
      : (!waveamdmachine.imm) -> !waveamdmachine.reg<vgpr, 4, 49>
  return
}

// PACK-LABEL: func.func @scalar_zero_tuple_elements(
// PACK: %[[PAIR0:.+]] = waveamdmachine.v_mov_b64_tuple
// PACK-SAME: -> !waveamdmachine.reg<vgpr, 2, 16>
// PACK: %[[PAIR1:.+]] = waveamdmachine.v_mov_b64_tuple
// PACK-SAME: -> !waveamdmachine.reg<vgpr, 2, 18>
// PACK: waveamdmachine.tuple_from_elements %[[PAIR0]], %[[PAIR1]]
// PACK-SAME: -> !waveamdmachine.reg<vgpr, 4, 16>
func.func @scalar_zero_tuple_elements() {
  %zero = waveamdmachine.imm 0 : !waveamdmachine.imm
  %a = waveamdmachine.v_mov_b32_tuple %zero
      : (!waveamdmachine.imm) -> !waveamdmachine.reg<vgpr, 1, 16>
  %b = waveamdmachine.v_mov_b32_tuple %zero
      : (!waveamdmachine.imm) -> !waveamdmachine.reg<vgpr, 1, 17>
  %c = waveamdmachine.v_mov_b32_tuple %zero
      : (!waveamdmachine.imm) -> !waveamdmachine.reg<vgpr, 1, 18>
  %d = waveamdmachine.v_mov_b32_tuple %zero
      : (!waveamdmachine.imm) -> !waveamdmachine.reg<vgpr, 1, 19>
  %wide = waveamdmachine.tuple_from_elements %a, %b, %c, %d
      : (!waveamdmachine.reg<vgpr, 1, 16>,
         !waveamdmachine.reg<vgpr, 1, 17>,
         !waveamdmachine.reg<vgpr, 1, 18>,
         !waveamdmachine.reg<vgpr, 1, 19>)
      -> !waveamdmachine.reg<vgpr, 4, 16>
  return
}

// PACK-LABEL: func.func @virtual_scalar_zero_tuple_elements
// PACK: %[[PAIR0:.+]] = waveamdmachine.v_mov_b64_tuple
// PACK-SAME: -> !waveamdmachine.reg<vgpr, 2>
// PACK: %[[PAIR1:.+]] = waveamdmachine.v_mov_b64_tuple
// PACK-SAME: -> !waveamdmachine.reg<vgpr, 2>
// PACK: waveamdmachine.tuple_from_elements %[[PAIR0]], %[[PAIR1]]
// PACK-SAME: -> !waveamdmachine.reg<vgpr, 4>
func.func @virtual_scalar_zero_tuple_elements() {
  %zero = waveamdmachine.imm 0 : !waveamdmachine.imm
  %a = waveamdmachine.v_mov_b32_tuple %zero
      : (!waveamdmachine.imm) -> !waveamdmachine.reg<vgpr, 1>
  %b = waveamdmachine.v_mov_b32_tuple %zero
      : (!waveamdmachine.imm) -> !waveamdmachine.reg<vgpr, 1>
  %c = waveamdmachine.v_mov_b32_tuple %zero
      : (!waveamdmachine.imm) -> !waveamdmachine.reg<vgpr, 1>
  %d = waveamdmachine.v_mov_b32_tuple %zero
      : (!waveamdmachine.imm) -> !waveamdmachine.reg<vgpr, 1>
  %wide = waveamdmachine.tuple_from_elements %a, %b, %c, %d
      : (!waveamdmachine.reg<vgpr, 1>,
         !waveamdmachine.reg<vgpr, 1>,
         !waveamdmachine.reg<vgpr, 1>,
         !waveamdmachine.reg<vgpr, 1>)
      -> !waveamdmachine.reg<vgpr, 4>
  return
}

// PACK-LABEL: func.func @distinct_scalar_zero_tuple_elements
// PACK: %[[PAIR:.+]] = waveamdmachine.v_mov_b64_tuple
// PACK-SAME: -> !waveamdmachine.reg<vgpr, 2, 24>
// PACK: waveamdmachine.tuple_from_elements %[[PAIR]]
// PACK-SAME: -> !waveamdmachine.reg<vgpr, 2, 24>
func.func @distinct_scalar_zero_tuple_elements() {
  %zero0 = waveamdmachine.imm 0 : !waveamdmachine.imm
  %zero1 = waveamdmachine.imm 0 : !waveamdmachine.imm
  %a = waveamdmachine.v_mov_b32_tuple %zero0
      : (!waveamdmachine.imm) -> !waveamdmachine.reg<vgpr, 1, 24>
  %b = waveamdmachine.v_mov_b32_tuple %zero1
      : (!waveamdmachine.imm) -> !waveamdmachine.reg<vgpr, 1, 25>
  %wide = waveamdmachine.tuple_from_elements %a, %b
      : (!waveamdmachine.reg<vgpr, 1, 24>,
         !waveamdmachine.reg<vgpr, 1, 25>)
      -> !waveamdmachine.reg<vgpr, 2, 24>
  return
}

// PACK-LABEL: func.func @scalar_reg_tuple_elements(
// PACK: %[[SRC0:.+]]:4 = waveamdmachine.tuple_to_elements
// PACK: %[[SRC1:.+]]:4 = waveamdmachine.tuple_to_elements
// PACK: %[[PAIR0:.+]] = waveamdmachine.v_mov_b64_from_elements %[[SRC0]]#2, %[[SRC0]]#3
// PACK-SAME: -> !waveamdmachine.reg<vgpr, 2, 0>
// PACK: %[[PAIR1:.+]] = waveamdmachine.v_mov_b64_from_elements %[[SRC1]]#2, %[[SRC1]]#3
// PACK-SAME: -> !waveamdmachine.reg<vgpr, 2, 2>
// PACK: waveamdmachine.tuple_from_elements %[[PAIR0]], %[[PAIR1]]
// PACK-SAME: -> !waveamdmachine.reg<vgpr, 4, 0>
func.func @scalar_reg_tuple_elements(
    %src0: !waveamdmachine.reg<vgpr, 4, 100>,
    %src1: !waveamdmachine.reg<vgpr, 4, 104>) {
  %parts0:4 = waveamdmachine.tuple_to_elements %src0
      : (!waveamdmachine.reg<vgpr, 4, 100>) ->
        (!waveamdmachine.reg<vgpr, 1, 100>,
         !waveamdmachine.reg<vgpr, 1, 101>,
         !waveamdmachine.reg<vgpr, 1, 102>,
         !waveamdmachine.reg<vgpr, 1, 103>)
  %parts1:4 = waveamdmachine.tuple_to_elements %src1
      : (!waveamdmachine.reg<vgpr, 4, 104>) ->
        (!waveamdmachine.reg<vgpr, 1, 104>,
         !waveamdmachine.reg<vgpr, 1, 105>,
         !waveamdmachine.reg<vgpr, 1, 106>,
         !waveamdmachine.reg<vgpr, 1, 107>)
  %a = waveamdmachine.v_mov_b32_tuple %parts0#2
      : (!waveamdmachine.reg<vgpr, 1, 102>) -> !waveamdmachine.reg<vgpr, 1, 0>
  %b = waveamdmachine.v_mov_b32_tuple %parts0#3
      : (!waveamdmachine.reg<vgpr, 1, 103>) -> !waveamdmachine.reg<vgpr, 1, 1>
  %c = waveamdmachine.v_mov_b32_tuple %parts1#2
      : (!waveamdmachine.reg<vgpr, 1, 106>) -> !waveamdmachine.reg<vgpr, 1, 2>
  %d = waveamdmachine.v_mov_b32_tuple %parts1#3
      : (!waveamdmachine.reg<vgpr, 1, 107>) -> !waveamdmachine.reg<vgpr, 1, 3>
  %wide = waveamdmachine.tuple_from_elements %a, %b, %c, %d
      : (!waveamdmachine.reg<vgpr, 1, 0>,
         !waveamdmachine.reg<vgpr, 1, 1>,
         !waveamdmachine.reg<vgpr, 1, 2>,
         !waveamdmachine.reg<vgpr, 1, 3>)
      -> !waveamdmachine.reg<vgpr, 4, 0>
  return
}

// PACK-LABEL: func.func @copy_tuple_materializes_before_pack(
// PACK: %[[SRC:.+]]:4 = waveamdmachine.tuple_to_elements
// PACK: %[[PAIR:.+]] = waveamdmachine.v_mov_b64_from_elements %[[SRC]]#0, %[[SRC]]#1
// PACK-SAME: -> !waveamdmachine.reg<vgpr, 2, 0>
// PACK: waveamdmachine.tuple_from_elements %[[PAIR]]
// PACK-SAME: -> !waveamdmachine.reg<vgpr, 2, 0>
// PACK-NOT: waveamdmachine.copy_tuple
func.func @copy_tuple_materializes_before_pack(
    %src: !waveamdmachine.reg<vgpr, 4, 100>) {
  %parts:4 = waveamdmachine.tuple_to_elements %src
      : (!waveamdmachine.reg<vgpr, 4, 100>) ->
        (!waveamdmachine.reg<vgpr, 1, 100>,
         !waveamdmachine.reg<vgpr, 1, 101>,
         !waveamdmachine.reg<vgpr, 1, 102>,
         !waveamdmachine.reg<vgpr, 1, 103>)
  %a = waveamdmachine.copy_tuple %parts#0
      : (!waveamdmachine.reg<vgpr, 1, 100>) -> !waveamdmachine.reg<vgpr, 1, 0>
  %b = waveamdmachine.copy_tuple %parts#1
      : (!waveamdmachine.reg<vgpr, 1, 101>) -> !waveamdmachine.reg<vgpr, 1, 1>
  %wide = waveamdmachine.tuple_from_elements %a, %b
      : (!waveamdmachine.reg<vgpr, 1, 0>,
         !waveamdmachine.reg<vgpr, 1, 1>)
      -> !waveamdmachine.reg<vgpr, 2, 0>
  return
}

// PACK-LABEL: func.func @copy_tuple_forwards_into_agpr_write(
// PACK-SAME: %[[SRC:.*]]: !waveamdmachine.reg<vgpr, 4, 4>
// PACK-NOT: waveamdmachine.v_mov_b32_tuple
// PACK-NOT: waveamdmachine.copy_tuple
// PACK: waveamdmachine.v_accvgpr_write_b32_tuple %[[SRC]]
// PACK-SAME: (!waveamdmachine.reg<vgpr, 4, 4>) -> !waveamdmachine.reg<agpr, 4, 100>
func.func @copy_tuple_forwards_into_agpr_write(
    %src: !waveamdmachine.reg<vgpr, 4, 4>) {
  %copy = waveamdmachine.copy_tuple %src
      : (!waveamdmachine.reg<vgpr, 4, 4>) -> !waveamdmachine.reg<vgpr, 4, 128>
  %acc = waveamdmachine.v_accvgpr_write_b32_tuple %copy
      : (!waveamdmachine.reg<vgpr, 4, 128>) -> !waveamdmachine.reg<agpr, 4, 100>
  return
}

// PACK-LABEL: func.func @copy_tuple_agpr_write_keeps_copy_before_source_clobber(
// PACK-SAME: %[[SRC:.*]]: !waveamdmachine.reg<vgpr, 4, 4>
// PACK: %[[COPY:.+]] = waveamdmachine.v_mov_b32_tuple %[[SRC]]
// PACK-SAME: -> !waveamdmachine.reg<vgpr, 4, 128>
// PACK: waveamdmachine.v_mov_b32_tuple
// PACK-SAME: -> !waveamdmachine.reg<vgpr, 4, 4>
// PACK: waveamdmachine.v_accvgpr_write_b32_tuple %[[COPY]]
func.func @copy_tuple_agpr_write_keeps_copy_before_source_clobber(
    %src: !waveamdmachine.reg<vgpr, 4, 4>,
    %other: !waveamdmachine.reg<vgpr, 4, 16>) {
  %copy = waveamdmachine.copy_tuple %src
      : (!waveamdmachine.reg<vgpr, 4, 4>) -> !waveamdmachine.reg<vgpr, 4, 128>
  %clobber = waveamdmachine.v_mov_b32_tuple %other {registers = 4 : i64}
      : (!waveamdmachine.reg<vgpr, 4, 16>) -> !waveamdmachine.reg<vgpr, 4, 4>
  %acc = waveamdmachine.v_accvgpr_write_b32_tuple %copy
      : (!waveamdmachine.reg<vgpr, 4, 128>) -> !waveamdmachine.reg<agpr, 4, 100>
  return
}

// PACK-LABEL: func.func @odd_source_reg_pair_stays_b32(
// PACK: waveamdmachine.v_mov_b32_tuple
// PACK: waveamdmachine.v_mov_b32_tuple
// PACK-NOT: waveamdmachine.v_mov_b64
func.func @odd_source_reg_pair_stays_b32(
    %src: !waveamdmachine.reg<vgpr, 2, 103>) {
  %parts:2 = waveamdmachine.tuple_to_elements %src
      : (!waveamdmachine.reg<vgpr, 2, 103>) ->
        (!waveamdmachine.reg<vgpr, 1, 103>,
         !waveamdmachine.reg<vgpr, 1, 104>)
  %a = waveamdmachine.v_mov_b32_tuple %parts#0
      : (!waveamdmachine.reg<vgpr, 1, 103>) -> !waveamdmachine.reg<vgpr, 1, 0>
  %b = waveamdmachine.v_mov_b32_tuple %parts#1
      : (!waveamdmachine.reg<vgpr, 1, 104>) -> !waveamdmachine.reg<vgpr, 1, 1>
  %wide = waveamdmachine.tuple_from_elements %a, %b
      : (!waveamdmachine.reg<vgpr, 1, 0>,
         !waveamdmachine.reg<vgpr, 1, 1>)
      -> !waveamdmachine.reg<vgpr, 2, 0>
  return
}

// PACK-LABEL: func.func @non_adjacent_scalar_zero_tuple_elements(
// PACK: waveamdmachine.v_mov_b32_tuple
// PACK: waveamdmachine.imm 1
// PACK: waveamdmachine.v_mov_b32_tuple
// PACK-NOT: waveamdmachine.v_mov_b64
func.func @non_adjacent_scalar_zero_tuple_elements() {
  %zero = waveamdmachine.imm 0 : !waveamdmachine.imm
  %a = waveamdmachine.v_mov_b32_tuple %zero
      : (!waveamdmachine.imm) -> !waveamdmachine.reg<vgpr, 1, 16>
  %one = waveamdmachine.imm 1 : !waveamdmachine.imm
  %b = waveamdmachine.v_mov_b32_tuple %zero
      : (!waveamdmachine.imm) -> !waveamdmachine.reg<vgpr, 1, 17>
  %wide = waveamdmachine.tuple_from_elements %a, %b
      : (!waveamdmachine.reg<vgpr, 1, 16>,
         !waveamdmachine.reg<vgpr, 1, 17>)
      -> !waveamdmachine.reg<vgpr, 2, 16>
  return
}

// PACK-LABEL: func.func @nonzero_tuple_stays_b32
// PACK: waveamdmachine.v_mov_b32_tuple
// PACK-NOT: waveamdmachine.v_mov_b64
func.func @nonzero_tuple_stays_b32() {
  %one = waveamdmachine.imm 1 : !waveamdmachine.imm
  %wide = waveamdmachine.v_mov_b32_tuple %one {registers = 4 : i64}
      : (!waveamdmachine.imm) -> !waveamdmachine.reg<vgpr, 4, 56>
  return
}

// PACK-LABEL: func.func @dead_scalar_zero_move_before_agpr_write
// PACK-NOT: waveamdmachine.v_mov_b32_tuple
// PACK: waveamdmachine.v_accvgpr_write_b32_tuple
func.func @dead_scalar_zero_move_before_agpr_write() {
  %zero = waveamdmachine.imm 0 : !waveamdmachine.imm
  %dead = waveamdmachine.v_mov_b32_tuple %zero
      : (!waveamdmachine.imm) -> !waveamdmachine.reg<vgpr, 1, 32>
  %agpr = waveamdmachine.v_accvgpr_write_b32_tuple %zero
      : (!waveamdmachine.imm) -> !waveamdmachine.reg<agpr, 1, 0>
  return
}

// PACK-LABEL: func.func @b64_result_feeds_hazards
// PACK: waveamdmachine.v_mov_b64_tuple
// WAITS-LABEL: func.func @b64_result_feeds_hazards
// WAITS: waveamdmachine.v_mov_b64_tuple
// WAITS: waveamdmachine.imm 0
// WAITS-NEXT: waveamdmachine.s_nop
// WAITS-NEXT: waveamdmachine.v_readfirstlane_b32
func.func @b64_result_feeds_hazards() {
  %zero = waveamdmachine.imm 0 : !waveamdmachine.imm
  %wide = waveamdmachine.v_mov_b32_tuple %zero {registers = 2 : i64}
      : (!waveamdmachine.imm) -> !waveamdmachine.reg<vgpr, 2, 60>
  %parts:2 = waveamdmachine.tuple_to_elements %wide
      : (!waveamdmachine.reg<vgpr, 2, 60>) ->
        (!waveamdmachine.reg<vgpr, 1, 60>, !waveamdmachine.reg<vgpr, 1, 61>)
  %first = waveamdmachine.v_readfirstlane_b32 %parts#0
      : (!waveamdmachine.reg<vgpr, 1, 60>) -> !waveamdmachine.reg<sgpr, 1, 20>
  return
}

}

// -----

module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx1100"} {

// PACK-LABEL: func.func @unsupported_target_stays_b32
// PACK: waveamdmachine.v_mov_b32_tuple
// PACK-NOT: waveamdmachine.v_mov_b64
func.func @unsupported_target_stays_b32() {
  %zero = waveamdmachine.imm 0 : !waveamdmachine.imm
  %wide = waveamdmachine.v_mov_b32_tuple %zero {registers = 4 : i64}
      : (!waveamdmachine.imm) -> !waveamdmachine.reg<vgpr, 4, 8>
  return
}

}
