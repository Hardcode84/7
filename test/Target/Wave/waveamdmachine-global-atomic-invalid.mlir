// RUN: wave-opt --split-input-file --waveamd-to-machine --verify-diagnostics %s

module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx950"} {
func.func @invalid_instruction_offset() {
  %offset = waveamdmachine.uninit : !waveamdmachine.reg<vgpr, 1>
  %value = waveamdmachine.uninit : !waveamdmachine.reg<vgpr, 1>
  %base = waveamdmachine.uninit : !waveamdmachine.reg<sgpr, 2>
  // expected-error @below {{instruction offset must fit signed 13-bit field}}
  %old, %token = waveamdmachine.global_atomic_add_acq_rel_u32
      %offset, %value, %base offset 4096
      : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>,
         !waveamdmachine.reg<sgpr, 2>)
        -> (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.mem.token)
  return
}
}

// -----

module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx1100"} {
func.func @unsupported_target(
    %counter: !wave.ptr<#wave.global, i32>, %increment: i32)
    attributes {wave.kernel} {
  %value = wave.splat %increment : i32 -> !wave.simd<i32, 32>
  // expected-error @below {{agent-scoped acquire-release global atomic requires gfx940+}}
  %old, %token = waveamd.global_atomic_add_acq_rel %value to %counter
      : (!wave.ptr<#wave.global, i32>, !wave.simd<i32, 32>)
        -> (!wave.simd<i32, 32>, !wave.mem.token)
  return
}
}
