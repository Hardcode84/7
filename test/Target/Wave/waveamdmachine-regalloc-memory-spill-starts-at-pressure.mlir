// RUN: not wave-opt --waveamd-reg-alloc='vgpr-limit=8 agpr-limit=0' %s 2>&1 | FileCheck %s

module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx1100"} {

// CHECK: error: waveamd-reg-alloc ran out of VGPR registers
// CHECK-SAME: memory spill reject detail:
// CHECK-SAME: no_use=1
// CHECK-NOT: starts_at_pressure
// CHECK-NOT: memory spill cannot materialize loop-carried values
// CHECK: note: see current operation
func.func @wide_request_at_pressure_no_use() attributes {wave.kernel} {
  %zero = waveamdmachine.imm 0 : !waveamdmachine.imm
  %wide = waveamdmachine.v_mov_b32_tuple %zero {registers = 9 : i64}
      : (!waveamdmachine.imm) -> !waveamdmachine.reg<vgpr, 9>
  waveamdmachine.s_endpgm
  return
}

}
