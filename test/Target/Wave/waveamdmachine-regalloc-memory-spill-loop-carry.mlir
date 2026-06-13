// RUN: not wave-opt --waveamd-reg-alloc='vgpr-limit=8 agpr-limit=0' %s 2>&1 | FileCheck %s --check-prefix=ERR
// RUN: wave-opt --waveamd-reg-alloc='mark-overflow=true vgpr-limit=8 agpr-limit=0' %s | FileCheck %s --check-prefix=SOFT

module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx1100"} {

// ERR: error: waveamd-reg-alloc ran out of VGPR registers
// ERR-SAME: memory spill cannot materialize loop-carried values
// ERR: waveamdmachine.regalloc_debug_memory_spill_reject = "loop_carry"
//
// SOFT-LABEL: func.func @scratch_spill_rejects_loop_carry
// SOFT-SAME: waveamdmachine.regalloc_debug_memory_spill_reject = "loop_carry"
// SOFT-NOT: scratch_load_b32
// SOFT: waveamdmachine.uniform_loop
func.func @scratch_spill_rejects_loop_carry()
    attributes {wave.kernel, waveamdmachine.target_waves = 4 : i64} {
  %zero = waveamdmachine.imm 0 : !waveamdmachine.imm
  %four = waveamdmachine.imm 4 : !waveamdmachine.imm
  %cond = waveamdmachine.s_cmp_lt_i32 %zero, %four
      : (!waveamdmachine.imm, !waveamdmachine.imm) -> !waveamdmachine.reg<scc, 1>
  %acc = waveamdmachine.v_mov_b32_tuple %zero {registers = 8 : i64}
      : (!waveamdmachine.imm) -> !waveamdmachine.reg<vgpr, 8>
  %loop = waveamdmachine.uniform_loop if %cond : !waveamdmachine.reg<scc, 1>
      carries(%acc : !waveamdmachine.reg<vgpr, 8>) {
  ^bb0(%carry: !waveamdmachine.reg<vgpr, 8>):
    waveamdmachine.continue_if %cond : !waveamdmachine.reg<scc, 1>
        carries(%carry : !waveamdmachine.reg<vgpr, 8>)
  } -> !waveamdmachine.reg<vgpr, 8>
  %parts:8 = waveamdmachine.tuple_to_elements %loop
      : (!waveamdmachine.reg<vgpr, 8>)
      -> (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>,
          !waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>,
          !waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>,
          !waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>)
  waveamdmachine.s_endpgm
  return
}

}
