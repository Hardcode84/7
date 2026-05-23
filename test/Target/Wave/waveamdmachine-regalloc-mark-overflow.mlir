// RUN: wave-opt --waveamd-reg-alloc='mark-overflow=true vgpr-limit=2' %s | FileCheck %s
// RUN: not wave-opt --waveamd-reg-alloc='vgpr-limit=2' %s 2>&1 | FileCheck %s --check-prefix=HARD

// Soft-fail: instead of dying, the regalloc pass annotates the func
// with `waveamdmachine.regalloc_overflowed` and stamps the module
// with a count summary. Tune's score sequence can then prune the
// trial via `get_int_attr` + `match.param.cmpi`.

// CHECK: module
// CHECK-SAME: waveamdmachine.regalloc_overflowed_count = 1 : i64
// CHECK-LABEL: func.func @too_many_vgprs
// CHECK-SAME: waveamdmachine.regalloc_overflowed = 1 : i64

// HARD: WaveAMDMachine register allocator ran out of registers

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
