// RUN: wave-opt --waveamd-reg-alloc --waveamd-insert-hazard-waits %s | FileCheck %s

module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx1100"} {

// Regalloc preparation splits duplicate VGPR loop inits with a
// `v_mov_b32_tuple`. Hazard insertion must run after that split so
// the new VALU copy gets the LGKM-wait mitigation.
// CHECK-LABEL: func.func @regalloc_inserted_valu_copy_after_wait
// CHECK: waveamdmachine.s_waitcnt
// CHECK-NEXT: waveamdmachine.imm 1
// CHECK-NEXT: waveamdmachine.s_delay_alu
// CHECK-NEXT: waveamdmachine.v_mov_b32_tuple
// CHECK-NEXT: waveamdmachine.uniform_loop
func.func @regalloc_inserted_valu_copy_after_wait() attributes {wave.kernel} {
  %zero = waveamdmachine.imm 0 : !waveamdmachine.imm
  %one = waveamdmachine.imm 1 : !waveamdmachine.imm
  %four = waveamdmachine.imm 4 : !waveamdmachine.imm
  %init = waveamdmachine.v_mov_b32_tuple %zero {registers = 1 : i64}
      : (!waveamdmachine.imm) -> !waveamdmachine.reg<vgpr, 1>
  %iv = waveamdmachine.s_mov_b32_value %zero
      : (!waveamdmachine.imm) -> !waveamdmachine.reg<sgpr, 1>
  %ec = waveamdmachine.s_cmp_lt_i32 %zero, %four
      : (!waveamdmachine.imm, !waveamdmachine.imm)
        -> !waveamdmachine.reg<scc, 1>
  waveamdmachine.s_waitcnt lgkmcnt(0)
  %results:3 = waveamdmachine.uniform_loop if %ec : !waveamdmachine.reg<scc, 1>
      carries(%iv, %init, %init :
              !waveamdmachine.reg<sgpr, 1>,
              !waveamdmachine.reg<vgpr, 1>,
              !waveamdmachine.reg<vgpr, 1>) {
  ^bb0(%cur_iv: !waveamdmachine.reg<sgpr, 1>,
       %a: !waveamdmachine.reg<vgpr, 1>,
       %b: !waveamdmachine.reg<vgpr, 1>):
    %niv, %scc = waveamdmachine.s_add_i32 %cur_iv, %one
        : (!waveamdmachine.reg<sgpr, 1>, !waveamdmachine.imm)
          -> (!waveamdmachine.reg<sgpr, 1>, !waveamdmachine.reg<scc, 1>)
    %bc = waveamdmachine.s_cmp_lt_i32 %niv, %four
        : (!waveamdmachine.reg<sgpr, 1>, !waveamdmachine.imm)
          -> !waveamdmachine.reg<scc, 1>
    waveamdmachine.continue_if %bc : !waveamdmachine.reg<scc, 1>
        carries(%niv, %a, %b :
                !waveamdmachine.reg<sgpr, 1>,
                !waveamdmachine.reg<vgpr, 1>,
                !waveamdmachine.reg<vgpr, 1>)
  } -> !waveamdmachine.reg<sgpr, 1>,
       !waveamdmachine.reg<vgpr, 1>,
       !waveamdmachine.reg<vgpr, 1>
  return
}

}
