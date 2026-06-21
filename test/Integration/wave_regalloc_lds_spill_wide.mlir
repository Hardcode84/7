// RUN: wave-opt --waveamd-reg-alloc='vgpr-limit=4 agpr-limit=0' --waveamd-resource-info %s | FileCheck %s
// RUN: wave-opt --waveamd-reg-alloc='vgpr-limit=4 agpr-limit=0' \
// RUN:   --waveamd-decompose-mem-tuples --waveamd-insert-ticket-waits \
// RUN:   --waveamd-insert-hazard-waits --waveamd-resource-info %s \
// RUN:   | wave-translate --wave-to-amdgpu-asm - \
// RUN:   | llvm-mc -triple=amdgcn-amd-amdhsa -mcpu=gfx90a -filetype=obj -o /dev/null

module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx90a"} {

// CHECK-LABEL: func.func @regalloc_lds_spill_wide_tuple
// CHECK-SAME: waveamdmachine.lds_spill_bytes = 1024 : i64
// CHECK-NOT: scratch_
// CHECK: %[[SPLIT:.+]]:2 = waveamdmachine.tuple_to_elements
// CHECK: %[[STORE0:.+]] = waveamdmachine.ds_store_b32 {{.*}}, %[[SPLIT]]#0
// CHECK: %[[STORE1:.+]] = waveamdmachine.ds_store_b32 {{.*}}, %[[SPLIT]]#1 offset 256
// CHECK: %[[JOIN:.+]] = waveamdmachine.token_join %[[STORE0]], %[[STORE1]]
// CHECK: %[[LOAD0:.+]], %[[TOKEN0:.+]] = waveamdmachine.ds_load_b32 {{.*}} after %[[JOIN]]
// CHECK: %[[LOAD1:.+]], %[[TOKEN1:.+]] = waveamdmachine.ds_load_b32 {{.*}} after %[[JOIN]] offset 256
// CHECK: waveamdmachine.tuple_from_elements %[[LOAD0]], %[[LOAD1]]
// CHECK-NOT: scratch_
// CHECK: waveamdmachine.s_endpgm
func.func @regalloc_lds_spill_wide_tuple()
    attributes {wave.kernel, wave.workgroup_size = array<i32: 64, 1, 1>,
                waveamdmachine.target_waves = 4 : i64} {
  %zero = waveamdmachine.imm 0 : !waveamdmachine.imm
  %base = waveamdmachine.uninit : !waveamdmachine.reg<sgpr, 2>
  %off = waveamdmachine.v_workitem_id_x : !waveamdmachine.reg<vgpr, 1, 0>
  %wide0 = waveamdmachine.v_mov_b32_tuple %zero {registers = 2 : i64}
      : (!waveamdmachine.imm) -> !waveamdmachine.reg<vgpr, 2>
  %wide1 = waveamdmachine.v_mov_b32_tuple %zero {registers = 2 : i64}
      : (!waveamdmachine.imm) -> !waveamdmachine.reg<vgpr, 2>
  %token0 = waveamdmachine.global_store_tuple_b32 %off, %wide0, %base
      : (!waveamdmachine.reg<vgpr, 1, 0>, !waveamdmachine.reg<vgpr, 2>,
         !waveamdmachine.reg<sgpr, 2>) -> !waveamdmachine.mem.token
  %token1 = waveamdmachine.global_store_tuple_b32 %off, %wide1, %base after %token0
      : (!waveamdmachine.reg<vgpr, 1, 0>, !waveamdmachine.reg<vgpr, 2>,
         !waveamdmachine.reg<sgpr, 2>, !waveamdmachine.mem.token)
        -> !waveamdmachine.mem.token
  waveamdmachine.s_endpgm
  return
}

}
