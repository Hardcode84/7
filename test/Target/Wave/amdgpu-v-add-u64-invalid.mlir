// RUN: wave-translate --wave-to-amdgpu-asm --verify-diagnostics %s

module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx803"} {

func.func @bad_add64(%x: !waveamdmachine.reg<vgpr, 2, 0>,
                     %y: !waveamdmachine.reg<vgpr, 2, 2>,
                     %data: !waveamdmachine.reg<vgpr, 1, 6>) {
  // expected-error @below {{v_add_u64 unsupported on this target}}
  %sum, %vcc = waveamdmachine.v_add_u64 %x, %y
      : (!waveamdmachine.reg<vgpr, 2, 0>, !waveamdmachine.reg<vgpr, 2, 2>)
        -> (!waveamdmachine.reg<vgpr, 2, 4>, !waveamdmachine.reg<vcc, 1>)
  %token = waveamdmachine.global_store_b32_addr64 %sum, %data
      : (!waveamdmachine.reg<vgpr, 2, 4>, !waveamdmachine.reg<vgpr, 1, 6>)
        -> !waveamdmachine.mem.token
  return
}

}
