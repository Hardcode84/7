// RUN: wave-opt --waveamd-reg-alloc='mark-overflow=true sgpr-limit=2 vgpr-limit=1 agpr-limit=8' %s >/dev/null

module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx950"} {

func.func @compile_sgpr_chain_promotion_pressure() {
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
