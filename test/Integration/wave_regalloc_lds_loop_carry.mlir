// RUN: wave-opt --waveamd-reg-alloc='vgpr-limit=8 agpr-limit=0' --waveamd-resource-info %s | FileCheck %s
// RUN: wave-opt --waveamd-reg-alloc='vgpr-limit=8 agpr-limit=0' \
// RUN:   --waveamd-decompose-mem-tuples --waveamd-insert-ticket-waits \
// RUN:   --waveamd-insert-hazard-waits --waveamd-resource-info %s \
// RUN:   | wave-translate --wave-to-amdgpu-asm - \
// RUN:   | llvm-mc -triple=amdgcn-amd-amdhsa -mcpu=gfx90a -filetype=obj -o /dev/null

module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx90a"} {

// CHECK-LABEL: func.func @regalloc_lds_spill_loop_carry_wide
// CHECK-SAME: waveamdmachine.lds_spill_bytes = 1024 : i64
// CHECK-NOT: scratch_
// CHECK: %[[SPLIT:.+]]:4 = waveamdmachine.tuple_to_elements
// CHECK: %[[STORE0:.+]] = waveamdmachine.ds_store_b32 {{.*}}, %[[SPLIT]]#0
// CHECK: %[[STORE1:.+]] = waveamdmachine.ds_store_b32 {{.*}}, %[[SPLIT]]#1 offset 256
// CHECK: %[[STORE2:.+]] = waveamdmachine.ds_store_b32 {{.*}}, %[[SPLIT]]#2 offset 512
// CHECK: %[[STORE3:.+]] = waveamdmachine.ds_store_b32 {{.*}}, %[[SPLIT]]#3 offset 768
// CHECK: %[[JOIN:.+]] = waveamdmachine.token_join %[[STORE0]], %[[STORE1]], %[[STORE2]], %[[STORE3]]
// CHECK: %[[LOOP:.+]] = waveamdmachine.uniform_loop {{.*}} carries(%[[JOIN]] : !waveamdmachine.mem.token)
// CHECK: ^bb0(%[[TOKEN_ARG:.+]]: !waveamdmachine.mem.token):
// CHECK: waveamdmachine.continue_if {{.*}} carries(%[[TOKEN_ARG]] : !waveamdmachine.mem.token)
// CHECK: waveamdmachine.ds_load_b32 {{.*}} after %[[LOOP]]
// CHECK: waveamdmachine.tuple_from_elements
// CHECK-NOT: scratch_
// CHECK: waveamdmachine.s_endpgm
func.func @regalloc_lds_spill_loop_carry_wide()
    attributes {wave.kernel, wave.workgroup_size = array<i32: 64, 1, 1>,
                waveamdmachine.target_waves = 4 : i64} {
  %zero = waveamdmachine.imm 0 : !waveamdmachine.imm
  %one = waveamdmachine.imm 1 : !waveamdmachine.imm
  %base = waveamdmachine.uninit : !waveamdmachine.reg<sgpr, 2>
  %off = waveamdmachine.v_workitem_id_x : !waveamdmachine.reg<vgpr, 1, 0>
  %cond = waveamdmachine.s_cmp_lt_i32 %zero, %one
      : (!waveamdmachine.imm, !waveamdmachine.imm)
        -> !waveamdmachine.reg<scc, 1>
  %acc = waveamdmachine.v_mov_b32_tuple %zero {registers = 4 : i64}
      : (!waveamdmachine.imm) -> !waveamdmachine.reg<vgpr, 4>
  %loop = waveamdmachine.uniform_loop if %cond : !waveamdmachine.reg<scc, 1>
      carries(%acc : !waveamdmachine.reg<vgpr, 4>) {
  ^bb0(%carry: !waveamdmachine.reg<vgpr, 4>):
    %tmp = waveamdmachine.v_mov_b32_tuple %zero {registers = 4 : i64}
        : (!waveamdmachine.imm) -> !waveamdmachine.reg<vgpr, 4>
    %parts:4 = waveamdmachine.tuple_to_elements %tmp
        : (!waveamdmachine.reg<vgpr, 4>)
        -> (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>,
            !waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>)
    waveamdmachine.continue_if %cond : !waveamdmachine.reg<scc, 1>
        carries(%carry : !waveamdmachine.reg<vgpr, 4>)
  } -> !waveamdmachine.reg<vgpr, 4>
  %result_parts:4 = waveamdmachine.tuple_to_elements %loop
      : (!waveamdmachine.reg<vgpr, 4>)
      -> (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>,
          !waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>)
  %token = waveamdmachine.global_store_b32 %off, %result_parts#0, %base
      : (!waveamdmachine.reg<vgpr, 1, 0>, !waveamdmachine.reg<vgpr, 1>,
         !waveamdmachine.reg<sgpr, 2>) -> !waveamdmachine.mem.token
  waveamdmachine.s_endpgm
  return
}

}
