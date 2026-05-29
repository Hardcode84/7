// RUN: wave-opt --waveamd-resource-info -split-input-file -verify-diagnostics %s

func.func @unallocated_register() {
  // expected-error @below {{waveamd-resource-info requires allocated register values}}
  %reg = waveamdmachine.v_mbcnt_lo : !waveamdmachine.reg<vgpr, 1>
  return
}

// -----

// expected-error @below {{waveamd-resource-info found interfering VGPR register live ranges}}
func.func @interfering_vgprs() {
  %zero = waveamdmachine.imm 0 : !waveamdmachine.imm
  %a = waveamdmachine.v_mov_b32_tuple %zero {registers = 1 : i64}
      : (!waveamdmachine.imm) -> !waveamdmachine.reg<vgpr, 1, 0>
  %b = waveamdmachine.v_mov_b32_tuple %zero {registers = 1 : i64}
      : (!waveamdmachine.imm) -> !waveamdmachine.reg<vgpr, 1, 0>
  %use_a = waveamdmachine.v_mov_b32_tuple %a {registers = 1 : i64}
      : (!waveamdmachine.reg<vgpr, 1, 0>) -> !waveamdmachine.reg<vgpr, 1, 1>
  %use_b = waveamdmachine.v_mov_b32_tuple %b {registers = 1 : i64}
      : (!waveamdmachine.reg<vgpr, 1, 0>) -> !waveamdmachine.reg<vgpr, 1, 2>
  return
}
