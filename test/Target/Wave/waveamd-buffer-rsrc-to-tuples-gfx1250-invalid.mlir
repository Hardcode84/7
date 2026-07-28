// RUN: wave-opt --waveamd-buffer-rsrc-to-tuples --split-input-file \
// RUN:   --verify-diagnostics %s

module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx1250"} {
func.func @base_bit_57() {
  %base = waveamdmachine.s_mov_b64_imm 144115188075855872
      : !waveamdmachine.reg<sgpr, 2>
  %range = waveamdmachine.imm 0 : !waveamdmachine.imm
  // expected-error @below {{buffer base constant must fit unsigned 57-bit field}}
  %desc = waveamdmachine.make_buffer_rsrc %base, %range
      : (!waveamdmachine.reg<sgpr, 2>, !waveamdmachine.imm)
        -> !waveamdmachine.reg<sgpr, 4>
  return
}
}

// -----

module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx1250"} {
func.func @range_bit_45(%base: !waveamdmachine.reg<sgpr, 2>) {
  %range = waveamdmachine.s_mov_b64_imm 35184372088832
      : !waveamdmachine.reg<sgpr, 2>
  // expected-error @below {{buffer range constant must fit unsigned 45-bit field}}
  %desc = waveamdmachine.make_buffer_rsrc %base, %range
      : (!waveamdmachine.reg<sgpr, 2>,
         !waveamdmachine.reg<sgpr, 2>)
        -> !waveamdmachine.reg<sgpr, 4>
  return
}
}

// -----

module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx1250"} {
func.func @negative_range(%base: !waveamdmachine.reg<sgpr, 2>) {
  %range = waveamdmachine.s_mov_b64_imm -1
      : !waveamdmachine.reg<sgpr, 2>
  // expected-error @below {{buffer range constant must fit unsigned 45-bit field}}
  %desc = waveamdmachine.make_buffer_rsrc %base, %range
      : (!waveamdmachine.reg<sgpr, 2>,
         !waveamdmachine.reg<sgpr, 2>)
        -> !waveamdmachine.reg<sgpr, 4>
  return
}
}

// -----

module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx1250"} {
func.func @updated_base_bit_57(
    %desc: !waveamdmachine.reg<sgpr, 4>) {
  %base = waveamdmachine.s_mov_b64_imm 144115188075855872
      : !waveamdmachine.reg<sgpr, 2>
  // expected-error @below {{buffer base constant must fit unsigned 57-bit field}}
  %updated = waveamdmachine.update_buffer_rsrc_base %desc, %base
      : (!waveamdmachine.reg<sgpr, 4>,
         !waveamdmachine.reg<sgpr, 2>)
        -> !waveamdmachine.reg<sgpr, 4>
  return
}
}
