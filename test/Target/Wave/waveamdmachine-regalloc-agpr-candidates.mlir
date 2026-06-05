// RUN: wave-opt --waveamd-reg-alloc='mark-overflow=true rank-agpr-candidates=true vgpr-limit=16' -split-input-file %s | FileCheck %s

// CHECK-LABEL: func.func @rank_mfma_accumulator_before_generic
// CHECK-SAME: waveamdmachine.regalloc_agpr_candidates = [
// CHECK-SAME: {agpr_dwords = 4 : i64, bridge_count = 1 : i64
// CHECK-SAME: relief_dwords = 4 : i64}
// CHECK-SAME: {agpr_dwords = 4 : i64, bridge_count = 2 : i64
// CHECK-SAME: waveamdmachine.regalloc_pressure_class = "VGPR"

module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx950"} {

func.func @rank_mfma_accumulator_before_generic() {
  %zero = waveamdmachine.imm 0 : !waveamdmachine.imm
  %a = waveamdmachine.uninit : !waveamdmachine.reg<vgpr, 4>
  %b = waveamdmachine.uninit : !waveamdmachine.reg<vgpr, 4>
  %acc = waveamdmachine.uninit : !waveamdmachine.reg<vgpr, 4>
  %mfma = waveamdmachine.mfma_f32_16x16x32_f16 %a, %b, %acc
      : (!waveamdmachine.reg<vgpr, 4>, !waveamdmachine.reg<vgpr, 4>,
         !waveamdmachine.reg<vgpr, 4>) -> !waveamdmachine.reg<vgpr, 4>
  %generic0 = waveamdmachine.v_mov_b32_tuple %zero {registers = 4 : i64}
      : (!waveamdmachine.imm) -> !waveamdmachine.reg<vgpr, 4>
  %generic1 = waveamdmachine.v_mov_b32_tuple %zero {registers = 4 : i64}
      : (!waveamdmachine.imm) -> !waveamdmachine.reg<vgpr, 4>
  %generic2 = waveamdmachine.v_mov_b32_tuple %zero {registers = 4 : i64}
      : (!waveamdmachine.imm) -> !waveamdmachine.reg<vgpr, 4>
  %generic3 = waveamdmachine.v_mov_b32_tuple %zero {registers = 4 : i64}
      : (!waveamdmachine.imm) -> !waveamdmachine.reg<vgpr, 4>
  %use_mfma = waveamdmachine.v_mov_b32_tuple %mfma {registers = 4 : i64}
      : (!waveamdmachine.reg<vgpr, 4>) -> !waveamdmachine.reg<vgpr, 4>
  %use_generic0 = waveamdmachine.v_mov_b32_tuple %generic0 {registers = 4 : i64}
      : (!waveamdmachine.reg<vgpr, 4>) -> !waveamdmachine.reg<vgpr, 4>
  %use_generic1 = waveamdmachine.v_mov_b32_tuple %generic1 {registers = 4 : i64}
      : (!waveamdmachine.reg<vgpr, 4>) -> !waveamdmachine.reg<vgpr, 4>
  %use_generic2 = waveamdmachine.v_mov_b32_tuple %generic2 {registers = 4 : i64}
      : (!waveamdmachine.reg<vgpr, 4>) -> !waveamdmachine.reg<vgpr, 4>
  %use_generic3 = waveamdmachine.v_mov_b32_tuple %generic3 {registers = 4 : i64}
      : (!waveamdmachine.reg<vgpr, 4>) -> !waveamdmachine.reg<vgpr, 4>
  return
}

}

// -----

// RUN: wave-opt --waveamd-reg-alloc='mark-overflow=true rank-agpr-candidates=true' -split-input-file %s | FileCheck %s --check-prefix=DEFAULT

// DEFAULT-LABEL: func.func @default_text_vgpr_cap
// DEFAULT-SAME: waveamdmachine.regalloc_agpr_candidates = [
// DEFAULT-SAME: {agpr_dwords = 4 : i64, bridge_count = 1 : i64
// DEFAULT-SAME: waveamdmachine.regalloc_pressure_limit = 256 : i64
// DEFAULT-SAME: waveamdmachine.regalloc_pressure_request = {{.*}}width = 252 : i64}

module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx950"} {

func.func @default_text_vgpr_cap() {
  %zero = waveamdmachine.imm 0 : !waveamdmachine.imm
  %a = waveamdmachine.uninit : !waveamdmachine.reg<vgpr, 4>
  %b = waveamdmachine.uninit : !waveamdmachine.reg<vgpr, 4>
  %acc = waveamdmachine.uninit : !waveamdmachine.reg<vgpr, 4>
  %mfma = waveamdmachine.mfma_f32_16x16x32_f16 %a, %b, %acc
      : (!waveamdmachine.reg<vgpr, 4>, !waveamdmachine.reg<vgpr, 4>,
         !waveamdmachine.reg<vgpr, 4>) -> !waveamdmachine.reg<vgpr, 4>
  %generic = waveamdmachine.v_mov_b32_tuple %zero {registers = 252 : i64}
      : (!waveamdmachine.imm) -> !waveamdmachine.reg<vgpr, 252>
  %request = waveamdmachine.v_mov_b32_tuple %zero {registers = 4 : i64}
      : (!waveamdmachine.imm) -> !waveamdmachine.reg<vgpr, 4>
  %use_mfma = waveamdmachine.v_mov_b32_tuple %mfma {registers = 4 : i64}
      : (!waveamdmachine.reg<vgpr, 4>) -> !waveamdmachine.reg<vgpr, 4>
  %use_generic = waveamdmachine.v_mov_b32_tuple %generic {registers = 252 : i64}
      : (!waveamdmachine.reg<vgpr, 252>) -> !waveamdmachine.reg<vgpr, 252>
  return
}

}

// -----

// CHECK-LABEL: func.func @tuple_renames_do_not_add_bridges
// CHECK-SAME: waveamdmachine.regalloc_agpr_candidates = [
// CHECK-SAME: {agpr_dwords = 8 : i64, bridge_count = 1 : i64
// CHECK-SAME: relief_dwords = 4 : i64}

module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx950"} {

func.func @tuple_renames_do_not_add_bridges() {
  %zero = waveamdmachine.imm 0 : !waveamdmachine.imm
  %lo = waveamdmachine.uninit : !waveamdmachine.reg<vgpr, 4>
  %hi = waveamdmachine.uninit : !waveamdmachine.reg<vgpr, 4>
  %tuple = waveamdmachine.tuple_from_elements %lo, %hi
      : (!waveamdmachine.reg<vgpr, 4>, !waveamdmachine.reg<vgpr, 4>)
      -> !waveamdmachine.reg<vgpr, 8>
  %parts:2 = waveamdmachine.tuple_to_elements %tuple
      : (!waveamdmachine.reg<vgpr, 8>)
      -> (!waveamdmachine.reg<vgpr, 4>, !waveamdmachine.reg<vgpr, 4>)
  %generic = waveamdmachine.v_mov_b32_tuple %zero {registers = 8 : i64}
      : (!waveamdmachine.imm) -> !waveamdmachine.reg<vgpr, 8>
  %request = waveamdmachine.v_mov_b32_tuple %zero {registers = 8 : i64}
      : (!waveamdmachine.imm) -> !waveamdmachine.reg<vgpr, 8>
  %use_part = waveamdmachine.v_mov_b32_tuple %parts#0 {registers = 4 : i64}
      : (!waveamdmachine.reg<vgpr, 4>) -> !waveamdmachine.reg<vgpr, 4>
  %use_generic = waveamdmachine.v_mov_b32_tuple %generic {registers = 8 : i64}
      : (!waveamdmachine.reg<vgpr, 8>) -> !waveamdmachine.reg<vgpr, 8>
  return
}

}

// -----

// RUN: wave-opt --waveamd-reg-alloc='mark-overflow=true rank-agpr-candidates=true vgpr-limit=256' -split-input-file %s | FileCheck %s --check-prefix=PEAK

// PEAK-LABEL: func.func @fit_against_peak_agpr_pressure
// PEAK-SAME: waveamdmachine.regalloc_agpr_candidates = [
// PEAK-SAME: {agpr_dwords = 128 : i64, bridge_count = 2 : i64
// PEAK-SAME: overlap_dwords = 1280 : i64
// PEAK-SAME: relief_dwords = 128 : i64}

module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx950"} {

func.func @fit_against_peak_agpr_pressure() {
  %zero = waveamdmachine.imm 0 : !waveamdmachine.imm
  %candidate = waveamdmachine.v_mov_b32_tuple %zero {registers = 128 : i64}
      : (!waveamdmachine.imm) -> !waveamdmachine.reg<vgpr, 128>
  %src0 = waveamdmachine.v_mov_b32_tuple %zero {registers = 128 : i64}
      : (!waveamdmachine.imm) -> !waveamdmachine.reg<vgpr, 128>
  %agpr0 = waveamdmachine.v_accvgpr_write_b32_tuple %src0
      : (!waveamdmachine.reg<vgpr, 128>) -> !waveamdmachine.reg<agpr, 128>
  %read0 = waveamdmachine.v_accvgpr_read_b32_tuple %agpr0
      : (!waveamdmachine.reg<agpr, 128>) -> !waveamdmachine.reg<vgpr, 128>
  %src1 = waveamdmachine.v_mov_b32_tuple %zero {registers = 128 : i64}
      : (!waveamdmachine.imm) -> !waveamdmachine.reg<vgpr, 128>
  %agpr1 = waveamdmachine.v_accvgpr_write_b32_tuple %src1
      : (!waveamdmachine.reg<vgpr, 128>) -> !waveamdmachine.reg<agpr, 128>
  %read1 = waveamdmachine.v_accvgpr_read_b32_tuple %agpr1
      : (!waveamdmachine.reg<agpr, 128>) -> !waveamdmachine.reg<vgpr, 128>
  %generic = waveamdmachine.v_mov_b32_tuple %zero {registers = 128 : i64}
      : (!waveamdmachine.imm) -> !waveamdmachine.reg<vgpr, 128>
  %request = waveamdmachine.v_mov_b32_tuple %zero {registers = 128 : i64}
      : (!waveamdmachine.imm) -> !waveamdmachine.reg<vgpr, 128>
  %use_candidate = waveamdmachine.v_mov_b32_tuple %candidate {registers = 128 : i64}
      : (!waveamdmachine.reg<vgpr, 128>) -> !waveamdmachine.reg<vgpr, 128>
  %use_generic = waveamdmachine.v_mov_b32_tuple %generic {registers = 128 : i64}
      : (!waveamdmachine.reg<vgpr, 128>) -> !waveamdmachine.reg<vgpr, 128>
  return
}

}
