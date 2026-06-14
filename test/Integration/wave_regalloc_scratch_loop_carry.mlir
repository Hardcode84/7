// RUN: wave-opt --waveamd-reg-alloc='vgpr-limit=16 agpr-limit=0' \
// RUN:   --waveamd-decompose-mem-tuples --waveamd-insert-ticket-waits \
// RUN:   --waveamd-insert-hazard-waits --waveamd-resource-info %s \
// RUN:   | wave-translate --wave-to-amdgpu-asm - \
// RUN:   | FileCheck %s --check-prefix=ASM
// RUN: wave-opt --waveamd-reg-alloc='vgpr-limit=16 agpr-limit=0' \
// RUN:   --waveamd-decompose-mem-tuples --waveamd-insert-ticket-waits \
// RUN:   --waveamd-insert-hazard-waits --waveamd-resource-info %s \
// RUN:   | wave-translate --wave-to-amdgpu-asm - \
// RUN:   | llvm-mc -triple=amdgcn-amd-amdhsa -mcpu=gfx1100 -filetype=obj -o /dev/null

module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx1100"} {

// ASM-LABEL: scratch_loop_carry_backend_finish:
// ASM: scratch_store_b32 off, v8, s5
// ASM: scratch_store_b32 off, v15, s5 offset:28
// ASM: scratch_load_b32 v8, off, s5
// ASM: s_waitcnt vmcnt(0)
// ASM: global_store_b32 {{v[0-9]+}}, v8, s[6:7]
// ASM: .amdhsa_private_segment_fixed_size 32
func.func @scratch_loop_carry_backend_finish()
    attributes {wave.kernel, waveamdmachine.target_waves = 4 : i64} {
  %zero = waveamdmachine.imm 0 : !waveamdmachine.imm
  %four = waveamdmachine.imm 4 : !waveamdmachine.imm
  %base = waveamdmachine.uninit : !waveamdmachine.reg<sgpr, 2>
  %off = waveamdmachine.v_workitem_id_x : !waveamdmachine.reg<vgpr, 1, 0>
  %cond = waveamdmachine.s_cmp_lt_i32 %zero, %four
      : (!waveamdmachine.imm, !waveamdmachine.imm)
        -> !waveamdmachine.reg<scc, 1>
  %acc = waveamdmachine.v_mov_b32_tuple %zero {registers = 8 : i64}
      : (!waveamdmachine.imm) -> !waveamdmachine.reg<vgpr, 8>
  %loop = waveamdmachine.uniform_loop if %cond : !waveamdmachine.reg<scc, 1>
      carries(%acc : !waveamdmachine.reg<vgpr, 8>) {
  ^bb0(%carry: !waveamdmachine.reg<vgpr, 8>):
    %tmp = waveamdmachine.v_mov_b32_tuple %zero {registers = 8 : i64}
        : (!waveamdmachine.imm) -> !waveamdmachine.reg<vgpr, 8>
    %parts:8 = waveamdmachine.tuple_to_elements %tmp
        : (!waveamdmachine.reg<vgpr, 8>)
        -> (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>,
            !waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>,
            !waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>,
            !waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>)
    waveamdmachine.continue_if %cond : !waveamdmachine.reg<scc, 1>
        carries(%carry : !waveamdmachine.reg<vgpr, 8>)
  } -> !waveamdmachine.reg<vgpr, 8>
  %result_parts:8 = waveamdmachine.tuple_to_elements %loop
      : (!waveamdmachine.reg<vgpr, 8>)
      -> (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>,
          !waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>,
          !waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>,
          !waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>)
  %token = waveamdmachine.global_store_b32 %off, %result_parts#0, %base
      : (!waveamdmachine.reg<vgpr, 1, 0>, !waveamdmachine.reg<vgpr, 1>,
         !waveamdmachine.reg<sgpr, 2>) -> !waveamdmachine.mem.token
  waveamdmachine.s_endpgm
  return
}

}
