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

// PACK-LABEL: func.func @nonzero_tuple_stays_b32
// PACK: waveamdmachine.v_mov_b32_tuple
// PACK-NOT: waveamdmachine.v_mov_b64_tuple
func.func @nonzero_tuple_stays_b32() {
  %one = waveamdmachine.imm 1 : !waveamdmachine.imm
  %wide = waveamdmachine.v_mov_b32_tuple %one {registers = 4 : i64}
      : (!waveamdmachine.imm) -> !waveamdmachine.reg<vgpr, 4, 56>
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
// PACK-NOT: waveamdmachine.v_mov_b64_tuple
func.func @unsupported_target_stays_b32() {
  %zero = waveamdmachine.imm 0 : !waveamdmachine.imm
  %wide = waveamdmachine.v_mov_b32_tuple %zero {registers = 4 : i64}
      : (!waveamdmachine.imm) -> !waveamdmachine.reg<vgpr, 4, 8>
  return
}

}
