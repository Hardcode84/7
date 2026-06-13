// RUN: not wave-opt --waveamd-reg-alloc='sgpr-limit=6 vgpr-limit=256 agpr-limit=0' %s 2>&1 | FileCheck %s

module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx1100"} {

// CHECK: error: waveamd-reg-alloc ran out of SGPR registers
// CHECK-NOT: memory spill cannot materialize loop-carried values
// CHECK: note: see current operation
func.func @sgpr_loop_carry_no_memory_spill_diag() attributes {wave.kernel} {
  %zero = waveamdmachine.imm 0 : !waveamdmachine.imm
  %four = waveamdmachine.imm 4 : !waveamdmachine.imm
  %cond = waveamdmachine.s_cmp_lt_i32 %zero, %four
      : (!waveamdmachine.imm, !waveamdmachine.imm) -> !waveamdmachine.reg<scc, 1>
  %acc = waveamdmachine.s_mov_b32_tuple %zero {registers = 2 : i64}
      : (!waveamdmachine.imm) -> !waveamdmachine.reg<sgpr, 2>
  %loop = waveamdmachine.uniform_loop if %cond : !waveamdmachine.reg<scc, 1>
      carries(%acc : !waveamdmachine.reg<sgpr, 2>) {
  ^bb0(%carry: !waveamdmachine.reg<sgpr, 2>):
    waveamdmachine.continue_if %cond : !waveamdmachine.reg<scc, 1>
        carries(%carry : !waveamdmachine.reg<sgpr, 2>)
  } -> !waveamdmachine.reg<sgpr, 2>
  %parts:2 = waveamdmachine.tuple_to_elements %loop
      : (!waveamdmachine.reg<sgpr, 2>)
      -> (!waveamdmachine.reg<sgpr, 1>, !waveamdmachine.reg<sgpr, 1>)
  waveamdmachine.s_endpgm
  return
}

}
