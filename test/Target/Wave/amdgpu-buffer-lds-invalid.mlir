// RUN: wave-translate --wave-to-amdgpu-asm --verify-diagnostics --split-input-file %s

module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx950"} {

func.func @bad_buffer_load_literal_soffset(%in: !wave.ptr<#wave.global, i32>)
    attributes {wave.kernel} {
  %base = waveamdmachine.arg {index = 0 : i64, pointer = true}
      : !waveamdmachine.reg<sgpr, 2>
  %range = waveamdmachine.imm 4096 : !waveamdmachine.imm
  %range_sgpr = waveamdmachine.s_mov_b32_tuple %range
      : (!waveamdmachine.imm) -> !waveamdmachine.reg<sgpr, 1>
  %flags_imm = waveamdmachine.imm 822173696 : !waveamdmachine.imm
  %flags = waveamdmachine.s_mov_b32_tuple %flags_imm
      : (!waveamdmachine.imm) -> !waveamdmachine.reg<sgpr, 1>
  %desc = waveamdmachine.tuple_from_elements %base, %range_sgpr, %flags
      : (!waveamdmachine.reg<sgpr, 2>, !waveamdmachine.reg<sgpr, 1>,
         !waveamdmachine.reg<sgpr, 1>) -> !waveamdmachine.reg<sgpr, 4>
  %off = waveamdmachine.v_mbcnt_lo : !waveamdmachine.reg<vgpr, 1>
  %soffset = waveamdmachine.imm 2048 : !waveamdmachine.imm
  // expected-error @below {{buffer nonzero literal soffset must be SGPR}}
  %v, %tok = waveamdmachine.buffer_load_b32 %off, %desc, %soffset
      : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<sgpr, 4>,
         !waveamdmachine.imm)
      -> (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.mem.token)
  %zero = waveamdmachine.imm 0 : !waveamdmachine.imm
  %s_zero = waveamdmachine.s_mov_b32_value %zero
      : (!waveamdmachine.imm) -> !waveamdmachine.reg<sgpr, 1>
  %st = waveamdmachine.buffer_store_b32 %off, %v, %desc, %s_zero after %tok
      : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>,
         !waveamdmachine.reg<sgpr, 4>, !waveamdmachine.reg<sgpr, 1>,
         !waveamdmachine.mem.token)
      -> !waveamdmachine.mem.token
  waveamdmachine.s_endpgm
  return
}

}

// -----

module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx950"} {

func.func @bad_buffer_load_b8_literal_soffset(%in: !wave.ptr<#wave.global, i32>)
    attributes {wave.kernel} {
  %base = waveamdmachine.arg {index = 0 : i64, pointer = true}
      : !waveamdmachine.reg<sgpr, 2>
  %range = waveamdmachine.imm 4096 : !waveamdmachine.imm
  %range_sgpr = waveamdmachine.s_mov_b32_tuple %range
      : (!waveamdmachine.imm) -> !waveamdmachine.reg<sgpr, 1>
  %flags_imm = waveamdmachine.imm 822173696 : !waveamdmachine.imm
  %flags = waveamdmachine.s_mov_b32_tuple %flags_imm
      : (!waveamdmachine.imm) -> !waveamdmachine.reg<sgpr, 1>
  %desc = waveamdmachine.tuple_from_elements %base, %range_sgpr, %flags
      : (!waveamdmachine.reg<sgpr, 2>, !waveamdmachine.reg<sgpr, 1>,
         !waveamdmachine.reg<sgpr, 1>) -> !waveamdmachine.reg<sgpr, 4>
  %off = waveamdmachine.v_mbcnt_lo : !waveamdmachine.reg<vgpr, 1>
  %soffset = waveamdmachine.imm 2048 : !waveamdmachine.imm
  // expected-error @below {{buffer nonzero literal soffset must be SGPR}}
  %v, %tok = waveamdmachine.buffer_load_u8 %off, %desc, %soffset
      : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<sgpr, 4>,
         !waveamdmachine.imm)
      -> (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.mem.token)
  %zero = waveamdmachine.imm 0 : !waveamdmachine.imm
  %s_zero = waveamdmachine.s_mov_b32_value %zero
      : (!waveamdmachine.imm) -> !waveamdmachine.reg<sgpr, 1>
  %st = waveamdmachine.buffer_store_b8 %off, %v, %desc, %s_zero after %tok
      : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>,
         !waveamdmachine.reg<sgpr, 4>, !waveamdmachine.reg<sgpr, 1>,
         !waveamdmachine.mem.token)
      -> !waveamdmachine.mem.token
  waveamdmachine.s_endpgm
  return
}

}

// -----

module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx950"} {

func.func @bad_buffer_store_b8_literal_soffset(%out: !wave.ptr<#wave.global, i32>)
    attributes {wave.kernel} {
  %base = waveamdmachine.arg {index = 0 : i64, pointer = true}
      : !waveamdmachine.reg<sgpr, 2>
  %range = waveamdmachine.imm 4096 : !waveamdmachine.imm
  %range_sgpr = waveamdmachine.s_mov_b32_tuple %range
      : (!waveamdmachine.imm) -> !waveamdmachine.reg<sgpr, 1>
  %flags_imm = waveamdmachine.imm 822173696 : !waveamdmachine.imm
  %flags = waveamdmachine.s_mov_b32_tuple %flags_imm
      : (!waveamdmachine.imm) -> !waveamdmachine.reg<sgpr, 1>
  %desc = waveamdmachine.tuple_from_elements %base, %range_sgpr, %flags
      : (!waveamdmachine.reg<sgpr, 2>, !waveamdmachine.reg<sgpr, 1>,
         !waveamdmachine.reg<sgpr, 1>) -> !waveamdmachine.reg<sgpr, 4>
  %off = waveamdmachine.v_mbcnt_lo : !waveamdmachine.reg<vgpr, 1>
  %soffset = waveamdmachine.imm 2048 : !waveamdmachine.imm
  // expected-error @below {{buffer nonzero literal soffset must be SGPR}}
  %tok = waveamdmachine.buffer_store_b8 %off, %off, %desc, %soffset
      : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>,
         !waveamdmachine.reg<sgpr, 4>, !waveamdmachine.imm)
      -> !waveamdmachine.mem.token
  waveamdmachine.s_endpgm
  return
}

}

// -----

module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx950"} {

func.func @bad_buffer_store_literal_soffset(%out: !wave.ptr<#wave.global, i32>)
    attributes {wave.kernel} {
  %base = waveamdmachine.arg {index = 0 : i64, pointer = true}
      : !waveamdmachine.reg<sgpr, 2>
  %range = waveamdmachine.imm 4096 : !waveamdmachine.imm
  %range_sgpr = waveamdmachine.s_mov_b32_tuple %range
      : (!waveamdmachine.imm) -> !waveamdmachine.reg<sgpr, 1>
  %flags_imm = waveamdmachine.imm 822173696 : !waveamdmachine.imm
  %flags = waveamdmachine.s_mov_b32_tuple %flags_imm
      : (!waveamdmachine.imm) -> !waveamdmachine.reg<sgpr, 1>
  %desc = waveamdmachine.tuple_from_elements %base, %range_sgpr, %flags
      : (!waveamdmachine.reg<sgpr, 2>, !waveamdmachine.reg<sgpr, 1>,
         !waveamdmachine.reg<sgpr, 1>) -> !waveamdmachine.reg<sgpr, 4>
  %off = waveamdmachine.v_mbcnt_lo : !waveamdmachine.reg<vgpr, 1>
  %soffset = waveamdmachine.imm 2048 : !waveamdmachine.imm
  // expected-error @below {{buffer nonzero literal soffset must be SGPR}}
  %tok = waveamdmachine.buffer_store_b32 %off, %off, %desc, %soffset
      : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>,
         !waveamdmachine.reg<sgpr, 4>, !waveamdmachine.imm)
      -> !waveamdmachine.mem.token
  waveamdmachine.s_endpgm
  return
}

}

// -----

module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx950"} {

func.func @bad_buffer_lds_literal_soffset(%in: !wave.ptr<#wave.global, i32>)
    attributes {wave.kernel} {
  %base = waveamdmachine.arg {index = 0 : i64, pointer = true}
      : !waveamdmachine.reg<sgpr, 2>
  %range = waveamdmachine.imm 4096 : !waveamdmachine.imm
  %range_sgpr = waveamdmachine.s_mov_b32_tuple %range
      : (!waveamdmachine.imm) -> !waveamdmachine.reg<sgpr, 1>
  %flags_imm = waveamdmachine.imm 822173696 : !waveamdmachine.imm
  %flags = waveamdmachine.s_mov_b32_tuple %flags_imm
      : (!waveamdmachine.imm) -> !waveamdmachine.reg<sgpr, 1>
  %desc = waveamdmachine.tuple_from_elements %base, %range_sgpr, %flags
      : (!waveamdmachine.reg<sgpr, 2>, !waveamdmachine.reg<sgpr, 1>,
         !waveamdmachine.reg<sgpr, 1>) -> !waveamdmachine.reg<sgpr, 4>
  %off = waveamdmachine.v_mbcnt_lo : !waveamdmachine.reg<vgpr, 1>
  %zero = waveamdmachine.imm 0 : !waveamdmachine.imm
  %m0src = waveamdmachine.s_mov_b32_value %zero
      : (!waveamdmachine.imm) -> !waveamdmachine.reg<sgpr, 1>
  %m0 = waveamdmachine.s_mov_m0 %m0src
      : (!waveamdmachine.reg<sgpr, 1>) -> !waveamdmachine.m0
  %dep = waveamdmachine.token : !waveamdmachine.mem.token
  %soffset = waveamdmachine.imm 2048 : !waveamdmachine.imm
  // expected-error @below {{buffer nonzero literal soffset must be SGPR}}
  %tok = waveamdmachine.buffer_load_lds_b128 %off, %desc, %soffset, %m0 after %dep
      : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<sgpr, 4>,
         !waveamdmachine.imm, !waveamdmachine.m0, !waveamdmachine.mem.token)
      -> !waveamdmachine.mem.token
  waveamdmachine.s_endpgm
  return
}

}
