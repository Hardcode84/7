// RUN: wave-translate --wave-to-amdgpu-asm --verify-diagnostics %s

module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx950"} {

func.func @bad_buffer_lds_literal_soffset(%in: !wave.ptr<#wave.global, i32>) {
  %base = waveamdmachine.arg {index = 0 : i64, pointer = true}
      : !waveamdmachine.reg<sgpr, 2>
  %range = waveamdmachine.imm 4096 : !waveamdmachine.imm
  %desc = waveamdmachine.make_buffer_rsrc %base, %range
      : (!waveamdmachine.reg<sgpr, 2>, !waveamdmachine.imm)
      -> !waveamdmachine.reg<sgpr, 4>
  %off = waveamdmachine.v_mbcnt_lo : !waveamdmachine.reg<vgpr, 1>
  %zero = waveamdmachine.imm 0 : !waveamdmachine.imm
  %m0src = waveamdmachine.s_mov_b32_value %zero
      : (!waveamdmachine.imm) -> !waveamdmachine.reg<sgpr, 1>
  %m0 = waveamdmachine.s_mov_m0 %m0src
      : (!waveamdmachine.reg<sgpr, 1>) -> !waveamdmachine.m0
  %dep = waveamdmachine.token : !waveamdmachine.mem.token
  %soffset = waveamdmachine.imm 2048 : !waveamdmachine.imm
  // expected-error @below {{buffer_load_lds nonzero literal soffset must be SGPR}}
  %tok = waveamdmachine.buffer_load_lds_b128 %off, %desc, %soffset, %m0 after %dep
      : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<sgpr, 4>,
         !waveamdmachine.imm, !waveamdmachine.m0, !waveamdmachine.mem.token)
      -> !waveamdmachine.mem.token
  return
}

}
