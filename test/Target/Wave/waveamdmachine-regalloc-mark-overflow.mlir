// RUN: wave-opt --waveamd-reg-alloc='mark-overflow=true vgpr-limit=2' %s | FileCheck %s
// RUN: wave-opt --waveamd-reg-alloc='mark-overflow=true vgpr-limit=2' --waveamd-resource-info %s | FileCheck %s --check-prefix=SKIP
// RUN: not wave-opt --waveamd-reg-alloc='mark-overflow=true vgpr-limit=2' --waveamd-insert-hazard-waits %s 2>&1 | FileCheck %s --check-prefix=HAZARD
// RUN: not wave-opt --waveamd-reg-alloc='vgpr-limit=2' %s 2>&1 | FileCheck %s --check-prefix=HARD

// Soft-fail: instead of dying, the regalloc pass annotates the func
// with `waveamdmachine.regalloc_overflowed` and stamps the module
// with a count summary. Tune's score sequence can then prune the
// trial via `get_int_attr` + `match.param.cmpi`.

// CHECK: module
// CHECK-SAME: waveamdmachine.regalloc_overflowed_count = 1 : i64
// CHECK-LABEL: func.func @too_many_vgprs
// CHECK-SAME: waveamdmachine.regalloc_overflowed = 1 : i64
// CHECK-SAME: waveamdmachine.regalloc_pressure_class = "VGPR"
// CHECK-SAME: waveamdmachine.regalloc_pressure_limit = 2 : i64
// CHECK-SAME: waveamdmachine.regalloc_pressure_live_dwords = 2 : i64
// CHECK-SAME: waveamdmachine.regalloc_pressure_overlaps = [{end = 4 : i64, result_indices = array<i64: 0>, slot_offsets = array<i64: 0>, start = 1 : i64, value_positions = array<i64: 1>, width = 1 : i64}, {end = 5 : i64, result_indices = array<i64: 0>, slot_offsets = array<i64: 0>, start = 2 : i64, value_positions = array<i64: 2>, width = 1 : i64}]
// CHECK-SAME: waveamdmachine.regalloc_pressure_position = 3 : i64
// CHECK-SAME: waveamdmachine.regalloc_pressure_request = {end = 6 : i64, result_indices = array<i64: 0>, slot_offsets = array<i64: 0>, start = 3 : i64, value_positions = array<i64: 3>, width = 1 : i64}
// CHECK-SAME: waveamdmachine.regalloc_pressure_required_relief = 1 : i64
// CHECK-SAME: waveamdmachine.regalloc_pressure_reserved = 0 : i64

// SKIP-LABEL: func.func @too_many_vgprs
// SKIP-SAME: waveamdmachine.regalloc_overflowed = 1 : i64
// SKIP-NOT: waveamdmachine.vgpr_count

// HAZARD: waveamd-insert-hazard-waits cannot consume overflowed register allocation

// HARD: WaveAMDMachine register allocator ran out of VGPR registers at position 3
// HARD-SAME: required_relief=1
// HARD-SAME: request={start=3, end=6, width=1, values=[3.0+0]}
// HARD-SAME: overlaps=[{start=1, end=4, width=1, values=[1.0+0]}, {start=2, end=5, width=1, values=[2.0+0]}]

module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx1100"} {

func.func @too_many_vgprs() {
  %zero = waveamdmachine.imm 0 : !waveamdmachine.imm
  %v0 = waveamdmachine.v_mov_b32_tuple %zero {registers = 1 : i64}
      : (!waveamdmachine.imm) -> !waveamdmachine.reg<vgpr, 1>
  %v1 = waveamdmachine.v_mov_b32_tuple %zero {registers = 1 : i64}
      : (!waveamdmachine.imm) -> !waveamdmachine.reg<vgpr, 1>
  %v2 = waveamdmachine.v_mov_b32_tuple %zero {registers = 1 : i64}
      : (!waveamdmachine.imm) -> !waveamdmachine.reg<vgpr, 1>
  %use0 = waveamdmachine.v_mov_b32_tuple %v0 {registers = 1 : i64}
      : (!waveamdmachine.reg<vgpr, 1>) -> !waveamdmachine.reg<vgpr, 1>
  %use1 = waveamdmachine.v_mov_b32_tuple %v1 {registers = 1 : i64}
      : (!waveamdmachine.reg<vgpr, 1>) -> !waveamdmachine.reg<vgpr, 1>
  %use2 = waveamdmachine.v_mov_b32_tuple %v2 {registers = 1 : i64}
      : (!waveamdmachine.reg<vgpr, 1>) -> !waveamdmachine.reg<vgpr, 1>
  return
}

}
