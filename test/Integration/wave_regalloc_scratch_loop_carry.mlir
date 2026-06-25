// RUN: wave-opt --waveamd-reg-alloc='mark-overflow=true vgpr-limit=16 agpr-limit=0' \
// RUN:   --waveamd-resource-info %s | FileCheck %s

module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx1100"} {

// CHECK-LABEL: func.func @scratch_loop_carry_backend_finish
// CHECK-SAME: waveamdmachine.regalloc_assignments
// CHECK-SAME: waveamdmachine.scratch_spill_bytes = 32 : i64
// CHECK: %[[INIT_STORE:.+]] = waveamdmachine.scratch_store_tuple_b32
// CHECK: %[[LOOP:.+]] = waveamdmachine.uniform_loop {{.*}} carries(%[[INIT_STORE]] : !waveamdmachine.mem.token)
// CHECK: ^bb0(%[[TOKEN:.+]]: !waveamdmachine.mem.token):
// CHECK: waveamdmachine.continue_if {{.*}} carries(%[[TOKEN]] : !waveamdmachine.mem.token)
// CHECK: waveamdmachine.scratch_load_tuple_b32 {{.*}} after %[[LOOP]]
// CHECK: waveamdmachine.global_store_b32
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
