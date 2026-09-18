// RUN: wave-opt --split-input-file --verify-diagnostics %s

func.func @invalid_destination_exec() {
  %zero = waveamdmachine.imm 0 : !waveamdmachine.imm
  // expected-error @below {{destination must name one numbered SGPR (sN)}}
  waveamdmachine.s_mov_b32 "exec", %zero : (!waveamdmachine.imm) -> ()
  return
}

// -----

func.func @invalid_destination_exec_lo() {
  %zero = waveamdmachine.imm 0 : !waveamdmachine.imm
  // expected-error @below {{destination must name one numbered SGPR (sN)}}
  waveamdmachine.s_mov_b32 "exec_lo", %zero : (!waveamdmachine.imm) -> ()
  return
}

// -----

func.func @invalid_destination_exec_hi() {
  %zero = waveamdmachine.imm 0 : !waveamdmachine.imm
  // expected-error @below {{destination must name one numbered SGPR (sN)}}
  waveamdmachine.s_mov_b32 "exec_hi", %zero : (!waveamdmachine.imm) -> ()
  return
}

// -----

func.func @invalid_destination_vcc() {
  %zero = waveamdmachine.imm 0 : !waveamdmachine.imm
  // expected-error @below {{destination must name one numbered SGPR (sN)}}
  waveamdmachine.s_mov_b32 "vcc", %zero : (!waveamdmachine.imm) -> ()
  return
}

// -----

func.func @invalid_destination_vcc_lo() {
  %zero = waveamdmachine.imm 0 : !waveamdmachine.imm
  // expected-error @below {{destination must name one numbered SGPR (sN)}}
  waveamdmachine.s_mov_b32 "vcc_lo", %zero : (!waveamdmachine.imm) -> ()
  return
}

// -----

func.func @invalid_destination_m0() {
  %zero = waveamdmachine.imm 0 : !waveamdmachine.imm
  // expected-error @below {{destination must name one numbered SGPR (sN)}}
  waveamdmachine.s_mov_b32 "m0", %zero : (!waveamdmachine.imm) -> ()
  return
}

// -----

func.func @invalid_destination_scc() {
  %zero = waveamdmachine.imm 0 : !waveamdmachine.imm
  // expected-error @below {{destination must name one numbered SGPR (sN)}}
  waveamdmachine.s_mov_b32 "scc", %zero : (!waveamdmachine.imm) -> ()
  return
}

// -----

func.func @invalid_destination_null() {
  %zero = waveamdmachine.imm 0 : !waveamdmachine.imm
  // expected-error @below {{destination must name one numbered SGPR (sN)}}
  waveamdmachine.s_mov_b32 "null", %zero : (!waveamdmachine.imm) -> ()
  return
}

// -----

func.func @invalid_destination_vgpr() {
  %zero = waveamdmachine.imm 0 : !waveamdmachine.imm
  // expected-error @below {{destination must name one numbered SGPR (sN)}}
  waveamdmachine.s_mov_b32 "v0", %zero : (!waveamdmachine.imm) -> ()
  return
}

// -----

func.func @invalid_destination_tuple() {
  %zero = waveamdmachine.imm 0 : !waveamdmachine.imm
  // expected-error @below {{destination must name one numbered SGPR (sN)}}
  waveamdmachine.s_mov_b32 "s[0:1]", %zero : (!waveamdmachine.imm) -> ()
  return
}

// -----

func.func @invalid_destination_singleton_tuple() {
  %zero = waveamdmachine.imm 0 : !waveamdmachine.imm
  // expected-error @below {{destination must name one numbered SGPR (sN)}}
  waveamdmachine.s_mov_b32 "s[0:0]", %zero : (!waveamdmachine.imm) -> ()
  return
}

// -----

func.func @invalid_destination_negative() {
  %zero = waveamdmachine.imm 0 : !waveamdmachine.imm
  // expected-error @below {{destination must name one numbered SGPR (sN)}}
  waveamdmachine.s_mov_b32 "s-1", %zero : (!waveamdmachine.imm) -> ()
  return
}

// -----

func.func @invalid_destination_trailing_text() {
  %zero = waveamdmachine.imm 0 : !waveamdmachine.imm
  // expected-error @below {{destination must name one numbered SGPR (sN)}}
  waveamdmachine.s_mov_b32 "s0junk", %zero : (!waveamdmachine.imm) -> ()
  return
}

// -----

func.func @invalid_destination_leading_space() {
  %zero = waveamdmachine.imm 0 : !waveamdmachine.imm
  // expected-error @below {{destination must name one numbered SGPR (sN)}}
  waveamdmachine.s_mov_b32 " s0", %zero : (!waveamdmachine.imm) -> ()
  return
}

// -----

func.func @invalid_destination_missing_index() {
  %zero = waveamdmachine.imm 0 : !waveamdmachine.imm
  // expected-error @below {{destination must name one numbered SGPR (sN)}}
  waveamdmachine.s_mov_b32 "s", %zero : (!waveamdmachine.imm) -> ()
  return
}

// -----

func.func @invalid_destination_overflow() {
  %zero = waveamdmachine.imm 0 : !waveamdmachine.imm
  // expected-error @below {{destination must name one numbered SGPR (sN)}}
  waveamdmachine.s_mov_b32 "s4294967296", %zero : (!waveamdmachine.imm) -> ()
  return
}

// -----

func.func @invalid_destination_out_of_range() {
  %zero = waveamdmachine.imm 0 : !waveamdmachine.imm
  // expected-error @below {{destination SGPR index must be less than 106}}
  waveamdmachine.s_mov_b32 "s106", %zero : (!waveamdmachine.imm) -> ()
  return
}

// -----

func.func @invalid_source_vgpr_1(%source: !waveamdmachine.reg<vgpr, 1>) {
  // expected-error @below {{operand #0 must be WaveAMDMachine SGPR or immediate}}
  waveamdmachine.s_mov_b32 "s0", %source : (!waveamdmachine.reg<vgpr, 1>) -> ()
  return
}

// -----

func.func @invalid_source_agpr_1(%source: !waveamdmachine.reg<agpr, 1>) {
  // expected-error @below {{operand #0 must be WaveAMDMachine SGPR or immediate}}
  waveamdmachine.s_mov_b32 "s0", %source : (!waveamdmachine.reg<agpr, 1>) -> ()
  return
}

// -----

func.func @invalid_source_sgpr_2(%source: !waveamdmachine.reg<sgpr, 2>) {
  // expected-error @below {{operand #0 must be WaveAMDMachine SGPR or immediate}}
  waveamdmachine.s_mov_b32 "s0", %source : (!waveamdmachine.reg<sgpr, 2>) -> ()
  return
}

// -----

func.func @invalid_source_vcc_1(%source: !waveamdmachine.reg<vcc, 1>) {
  // expected-error @below {{operand #0 must be WaveAMDMachine SGPR or immediate}}
  waveamdmachine.s_mov_b32 "s0", %source : (!waveamdmachine.reg<vcc, 1>) -> ()
  return
}
