// RUN: wave-opt --waveamd-buffer-rsrc-to-tuples --split-input-file \
// RUN:   --verify-diagnostics %s

module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx1100"} {
func.func @dynamic_i64_range(
    %base: !waveamdmachine.reg<sgpr, 2>,
    %range: !waveamdmachine.reg<sgpr, 2>) {
  // expected-error @below {{dynamic i64 buffer range cannot fit 32-bit target field}}
  %desc = waveamdmachine.make_buffer_rsrc %base, %range
      : (!waveamdmachine.reg<sgpr, 2>,
         !waveamdmachine.reg<sgpr, 2>)
        -> !waveamdmachine.reg<sgpr, 4>
  return
}
}

// -----

module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx1100"} {
func.func @oversized_i64_range(
    %base: !waveamdmachine.reg<sgpr, 2>) {
  %range = waveamdmachine.s_mov_b64_imm 4294967296
      : !waveamdmachine.reg<sgpr, 2>
  // expected-error @below {{buffer range constant must fit unsigned 32-bit target field}}
  %desc = waveamdmachine.make_buffer_rsrc %base, %range
      : (!waveamdmachine.reg<sgpr, 2>,
         !waveamdmachine.reg<sgpr, 2>)
        -> !waveamdmachine.reg<sgpr, 4>
  return
}
}

// -----

module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx1100"} {
func.func @negative_i64_range(
    %base: !waveamdmachine.reg<sgpr, 2>) {
  %range = waveamdmachine.s_mov_b64_imm -1
      : !waveamdmachine.reg<sgpr, 2>
  // expected-error @below {{buffer range constant must fit unsigned 32-bit target field}}
  %desc = waveamdmachine.make_buffer_rsrc %base, %range
      : (!waveamdmachine.reg<sgpr, 2>,
         !waveamdmachine.reg<sgpr, 2>)
        -> !waveamdmachine.reg<sgpr, 4>
  return
}
}

// -----

module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx1100"} {
func.func @max_i64_range(
    %base: !waveamdmachine.reg<sgpr, 2>) {
  %range = waveamdmachine.s_mov_b64_imm 4294967295
      : !waveamdmachine.reg<sgpr, 2>
  %desc = waveamdmachine.make_buffer_rsrc %base, %range
      : (!waveamdmachine.reg<sgpr, 2>,
         !waveamdmachine.reg<sgpr, 2>)
        -> !waveamdmachine.reg<sgpr, 4>
  return
}
}
