// RUN: wave-opt --waveamd-to-machine %s | FileCheck %s --check-prefix=SELECT
// RUN: wave-translate --wave-to-amdgpu-asm %s | FileCheck %s --check-prefix=ASM
// RUN: wave-translate --wave-to-amdgpu-asm %s | llvm-mc -triple=amdgcn-amd-amdhsa -mcpu=gfx1100 -filetype=obj -o /dev/null

module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx1100"} {

// SELECT-LABEL: func.func @select_cache_modifiers
// SELECT: [[LOAD:%.*]], [[TOK:%.*]] = waveamdmachine.global_load_b32 {{.*}} {cache = #waveamd.load_cache<cg>}
// SELECT: waveamdmachine.global_store_b32 {{.*}} after [[TOK]] {cache = #waveamd.store_cache<cs>}
func.func @select_cache_modifiers(%in: !wave.ptr<#wave.global, i32>,
                                  %out: !wave.ptr<#wave.global, i32>)
    attributes {wave.kernel} {
  %lane = wave.lane_id : !wave.simd<i32, 32>
  %ip = wave.ptr_add %in, %lane
      : !wave.ptr<#wave.global, i32>, !wave.simd<i32, 32>
      -> !wave.simd<!wave.ptr<#wave.global, i32>, 32>
  %op = wave.ptr_add %out, %lane
      : !wave.ptr<#wave.global, i32>, !wave.simd<i32, 32>
      -> !wave.simd<!wave.ptr<#wave.global, i32>, 32>
  %value, %tok = wave.load %ip {cache = #waveamd.load_cache<cg>}
      : (!wave.simd<!wave.ptr<#wave.global, i32>, 32>)
      -> (!wave.simd<i32, 32>, !wave.mem.token)
  %st = wave.store %value -> %op after %tok {cache = #waveamd.store_cache<cs>}
      : (!wave.simd<i32, 32>, !wave.simd<!wave.ptr<#wave.global, i32>, 32>,
         !wave.mem.token)
      -> !wave.mem.token
  return
}

// ASM-LABEL: cache_modifiers_asm:
// ASM: global_load_b32{{.*}}glc{{.*}}slc
// ASM: global_store_b32{{.*}}glc{{.*}}slc
// ASM: buffer_load_b32{{.*}}glc
// ASM: buffer_store_b32{{.*}}slc
// ASM: s_endpgm
func.func @cache_modifiers_asm() attributes {wave.kernel} {
  %off = waveamdmachine.uninit : !waveamdmachine.reg<vgpr, 1, 0>
  %base = waveamdmachine.uninit : !waveamdmachine.reg<sgpr, 2, 0>
  %desc = waveamdmachine.uninit : !waveamdmachine.reg<sgpr, 4, 4>
  %zero = waveamdmachine.imm 0 : !waveamdmachine.imm
  %stored = waveamdmachine.uninit : !waveamdmachine.reg<vgpr, 1, 3>
  %value, %load_tok = waveamdmachine.global_load_b32 %off, %base
      {cache = #waveamd.load_cache<cs>}
      : (!waveamdmachine.reg<vgpr, 1, 0>, !waveamdmachine.reg<sgpr, 2, 0>)
      -> (!waveamdmachine.reg<vgpr, 1, 2>, !waveamdmachine.mem.token)
  %store_tok = waveamdmachine.global_store_b32 %off, %stored, %base after %load_tok
      {cache = #waveamd.store_cache<cs>}
      : (!waveamdmachine.reg<vgpr, 1, 0>, !waveamdmachine.reg<vgpr, 1, 3>,
         !waveamdmachine.reg<sgpr, 2, 0>, !waveamdmachine.mem.token)
      -> !waveamdmachine.mem.token
  %buf, %buf_tok = waveamdmachine.buffer_load_b32 %off, %desc, %zero after %store_tok
      {cache = #waveamd.load_cache<cg>}
      : (!waveamdmachine.reg<vgpr, 1, 0>, !waveamdmachine.reg<sgpr, 4, 4>,
         !waveamdmachine.imm, !waveamdmachine.mem.token)
      -> (!waveamdmachine.reg<vgpr, 1, 4>, !waveamdmachine.mem.token)
  %buf_store_tok = waveamdmachine.buffer_store_b32 %off, %buf, %desc, %zero after %buf_tok
      {cache = #waveamd.store_cache<wt>}
      : (!waveamdmachine.reg<vgpr, 1, 0>, !waveamdmachine.reg<vgpr, 1, 4>,
         !waveamdmachine.reg<sgpr, 4, 4>, !waveamdmachine.imm,
         !waveamdmachine.mem.token)
      -> !waveamdmachine.mem.token
  waveamdmachine.s_endpgm
  return
}

}
