// RUN: not wave-opt --waveamd-reg-alloc='sgpr-limit=2 vgpr-limit=1 agpr-limit=8' %s 2>&1 | FileCheck %s --implicit-check-not='unsupported promotion SGPR -> AGPR'

module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx950"} {

// CHECK: waveamd-reg-alloc ran out of VGPR registers
// CHECK: memory spill reject detail
// CHECK: waveamdmachine.v_mov_b32_tuple
// CHECK: waveamdmachine.v_accvgpr_write_b32_tuple
// CHECK: waveamdmachine.v_accvgpr_read_b32_tuple
// CHECK: waveamdmachine.v_readfirstlane_b32
func.func @sgpr_chain_promotion_probe() {
  %one = waveamdmachine.imm 1 : !waveamdmachine.imm
  %a = waveamdmachine.s_mov_b32_value %one
      : (!waveamdmachine.imm) -> !waveamdmachine.reg<sgpr, 1>
  %b = waveamdmachine.s_mov_b32_value %one
      : (!waveamdmachine.imm) -> !waveamdmachine.reg<sgpr, 1>
  %c = waveamdmachine.s_mov_b32_value %one
      : (!waveamdmachine.imm) -> !waveamdmachine.reg<sgpr, 1>
  waveamdmachine.exec_if %a {
    waveamdmachine.yield
  } : !waveamdmachine.reg<sgpr, 1>
  waveamdmachine.exec_if %b {
    waveamdmachine.yield
  } : !waveamdmachine.reg<sgpr, 1>
  waveamdmachine.exec_if %c {
    waveamdmachine.yield
  } : !waveamdmachine.reg<sgpr, 1>
  return
}

}
