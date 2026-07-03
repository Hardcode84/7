// RUN: wave-opt --waveamd-buffer-rsrc-to-tuples --waveamd-hoist-tuples %s \
// RUN:   | wave-translate --wave-to-amdgpu-asm - \
// RUN:   | FileCheck %s --check-prefix=ASM
// RUN: wave-opt --waveamd-buffer-rsrc-to-tuples --waveamd-hoist-tuples %s \
// RUN:   | wave-translate --wave-to-amdgpu-asm - \
// RUN:   | llvm-mc -triple=amdgcn-amd-amdhsa -mcpu=gfx1100 -filetype=obj -o /dev/null

module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx1100"} {

// ASM-LABEL: buffer_rsrc_hoist_codegen:
// ASM: s_mov_b32 s54, 0x80
// ASM: s_mov_b32 s55, 0x31016000
// ASM: .Lbuffer_rsrc_hoist_codegen.loop_head_0:
// ASM-NOT: s_mov_b32 s54
// ASM-NOT: s_mov_b32 s55
// ASM: s_add_u32 {{s[0-9]+}}, s44, s48
// ASM-NEXT: s_addc_u32 {{s[0-9]+}}, s45, 0
// ASM-NOT: s_mov_b32 s54
// ASM-NOT: s_mov_b32 s55
// ASM: buffer_load_b32 v1, v0, s[52:55], 0 offen
func.func @buffer_rsrc_hoist_codegen() attributes {wave.kernel} {
  %range = waveamdmachine.imm 128 : !waveamdmachine.imm
  %zero = waveamdmachine.imm 0 : !waveamdmachine.imm
  %step = waveamdmachine.imm 4 : !waveamdmachine.imm
  %limit = waveamdmachine.imm 16 : !waveamdmachine.imm
  %base = waveamdmachine.uninit : !waveamdmachine.reg<sgpr, 2, 44>
  %vaddr = waveamdmachine.uninit : !waveamdmachine.reg<vgpr, 1, 0>
  %off0 = waveamdmachine.s_mov_b32_value %zero
      : (!waveamdmachine.imm) -> !waveamdmachine.reg<sgpr, 1, 48>
  %tok0 = waveamdmachine.token : !waveamdmachine.mem.token
  %loop:2 = waveamdmachine.uniform_loop
      carries(%off0, %tok0 :
              !waveamdmachine.reg<sgpr, 1, 48>,
              !waveamdmachine.mem.token) {
  ^bb0(%off: !waveamdmachine.reg<sgpr, 1, 48>,
       %dep: !waveamdmachine.mem.token):
    %cur_base, %base_scc = waveamdmachine.s_add_u64_u32 %base, %off
        : (!waveamdmachine.reg<sgpr, 2, 44>,
           !waveamdmachine.reg<sgpr, 1, 48>)
          -> (!waveamdmachine.reg<sgpr, 2>,
              !waveamdmachine.reg<scc, 1>)
    %desc = waveamdmachine.make_buffer_rsrc %cur_base, %range
        : (!waveamdmachine.reg<sgpr, 2>, !waveamdmachine.imm)
          -> !waveamdmachine.reg<sgpr, 4, 52>
    %value, %tok1 = waveamdmachine.buffer_load_b32 %vaddr, %desc, %zero after %dep
        : (!waveamdmachine.reg<vgpr, 1, 0>,
           !waveamdmachine.reg<sgpr, 4, 52>, !waveamdmachine.imm,
           !waveamdmachine.mem.token)
          -> (!waveamdmachine.reg<vgpr, 1, 1>,
              !waveamdmachine.mem.token)
    %tok2 = waveamdmachine.buffer_store_b32 %vaddr, %value, %desc, %zero after %tok1
        : (!waveamdmachine.reg<vgpr, 1, 0>,
           !waveamdmachine.reg<vgpr, 1, 1>,
           !waveamdmachine.reg<sgpr, 4, 52>, !waveamdmachine.imm,
           !waveamdmachine.mem.token) -> !waveamdmachine.mem.token
    %next, %next_scc = waveamdmachine.s_add_i32 %off, %step
        : (!waveamdmachine.reg<sgpr, 1, 48>, !waveamdmachine.imm)
          -> (!waveamdmachine.reg<sgpr, 1, 48>,
              !waveamdmachine.reg<scc, 1>)
    %cond = waveamdmachine.s_cmp_lt_i32 %next, %limit
        : (!waveamdmachine.reg<sgpr, 1, 48>, !waveamdmachine.imm)
          -> !waveamdmachine.reg<scc, 1>
    waveamdmachine.continue_if %cond : !waveamdmachine.reg<scc, 1>
        carries(%next, %tok2 :
                !waveamdmachine.reg<sgpr, 1, 48>,
                !waveamdmachine.mem.token)
  } -> !waveamdmachine.reg<sgpr, 1, 48>, !waveamdmachine.mem.token
  waveamdmachine.s_endpgm
  return
}

}
