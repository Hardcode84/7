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

// -----

// expected-error @below {{waveamd-resource-info found interfering SGPR register live ranges}}
func.func @interfering_sgprs() {
  %zero = waveamdmachine.imm 0 : !waveamdmachine.imm
  %a = waveamdmachine.s_mov_b32_value %zero
      : (!waveamdmachine.imm) -> !waveamdmachine.reg<sgpr, 1, 0>
  %b = waveamdmachine.s_mov_b32_value %zero
      : (!waveamdmachine.imm) -> !waveamdmachine.reg<sgpr, 1, 0>
  %use_a = waveamdmachine.s_mov_b32_value %a
      : (!waveamdmachine.reg<sgpr, 1, 0>) -> !waveamdmachine.reg<sgpr, 1, 1>
  %use_b = waveamdmachine.s_mov_b32_value %b
      : (!waveamdmachine.reg<sgpr, 1, 0>) -> !waveamdmachine.reg<sgpr, 1, 2>
  return
}

// -----

// expected-error @below {{waveamd-resource-info found interfering AGPR register live ranges}}
func.func @interfering_agprs() {
  %off = waveamdmachine.uninit : !waveamdmachine.reg<vgpr, 1, 1>
  %base = waveamdmachine.uninit : !waveamdmachine.reg<sgpr, 2, 6>
  %a = waveamdmachine.uninit : !waveamdmachine.reg<agpr, 1, 0>
  %b = waveamdmachine.uninit : !waveamdmachine.reg<agpr, 1, 0>
  %read_a = waveamdmachine.v_accvgpr_read_b32_tuple %a
      : (!waveamdmachine.reg<agpr, 1, 0>) -> !waveamdmachine.reg<vgpr, 1, 2>
  %read_b = waveamdmachine.v_accvgpr_read_b32_tuple %b
      : (!waveamdmachine.reg<agpr, 1, 0>) -> !waveamdmachine.reg<vgpr, 1, 3>
  %store_a = waveamdmachine.global_store_b32 %off, %read_a, %base
      : (!waveamdmachine.reg<vgpr, 1, 1>, !waveamdmachine.reg<vgpr, 1, 2>,
         !waveamdmachine.reg<sgpr, 2, 6>) -> !waveamdmachine.mem.token
  %store_b = waveamdmachine.global_store_b32 %off, %read_b, %base after %store_a
      : (!waveamdmachine.reg<vgpr, 1, 1>, !waveamdmachine.reg<vgpr, 1, 3>,
         !waveamdmachine.reg<sgpr, 2, 6>, !waveamdmachine.mem.token) -> !waveamdmachine.mem.token
  return
}
