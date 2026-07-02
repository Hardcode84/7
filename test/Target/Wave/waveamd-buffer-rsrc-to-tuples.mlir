// RUN: wave-opt --waveamd-buffer-rsrc-to-tuples %s | FileCheck %s

module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx1100"} {

// CHECK-LABEL: func.func @make_buffer_rsrc_to_tuple(
// CHECK-SAME:    %[[BASE:[^:]+]]: !waveamdmachine.reg<sgpr, 2>
// CHECK: %[[RANGE_IMM:.*]] = waveamdmachine.imm 128
// CHECK: %[[RANGE:.*]] = waveamdmachine.s_mov_b32_tuple %[[RANGE_IMM]]
// CHECK: %[[FLAGS_IMM:.*]] = waveamdmachine.imm 822173696
// CHECK: %[[FLAGS:.*]] = waveamdmachine.s_mov_b32_tuple %[[FLAGS_IMM]]
// CHECK: %[[DESC:.*]] = waveamdmachine.tuple_from_elements %[[BASE]], %[[RANGE]], %[[FLAGS]]
// CHECK: waveamdmachine.buffer_load_b32 {{.*}}, %[[DESC]]
// CHECK-NOT: waveamdmachine.make_buffer_rsrc
func.func @make_buffer_rsrc_to_tuple(%base: !waveamdmachine.reg<sgpr, 2>,
                                     %off: !waveamdmachine.reg<vgpr, 1>)
    attributes {wave.kernel} {
  %range = waveamdmachine.imm 128 : !waveamdmachine.imm
  %zero = waveamdmachine.imm 0 : !waveamdmachine.imm
  %desc = waveamdmachine.make_buffer_rsrc %base, %range
      : (!waveamdmachine.reg<sgpr, 2>, !waveamdmachine.imm)
        -> !waveamdmachine.reg<sgpr, 4>
  %value, %tok = waveamdmachine.buffer_load_b32 %off, %desc, %zero
      : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<sgpr, 4>,
         !waveamdmachine.imm)
        -> (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.mem.token)
  return
}

// CHECK-LABEL: func.func @update_buffer_rsrc_base_to_update_tuple(
// CHECK-SAME:    %[[DESC:[^:]+]]: !waveamdmachine.reg<sgpr, 4>
// CHECK-SAME:    %[[BASE:[^:]+]]: !waveamdmachine.reg<sgpr, 2>
// CHECK: %[[UPDATED:.*]] = waveamdmachine.update_tuple %[[DESC]], %[[BASE]] {offsets = [0]}
// CHECK: waveamdmachine.buffer_store_b32 {{.*}}, %[[UPDATED]]
// CHECK-NOT: waveamdmachine.update_buffer_rsrc_base
func.func @update_buffer_rsrc_base_to_update_tuple(
    %desc0: !waveamdmachine.reg<sgpr, 4>,
    %base: !waveamdmachine.reg<sgpr, 2>,
    %off: !waveamdmachine.reg<vgpr, 1>) attributes {wave.kernel} {
  %zero = waveamdmachine.imm 0 : !waveamdmachine.imm
  %desc1 = waveamdmachine.update_buffer_rsrc_base %desc0, %base
      : (!waveamdmachine.reg<sgpr, 4>, !waveamdmachine.reg<sgpr, 2>)
        -> !waveamdmachine.reg<sgpr, 4>
  %tok = waveamdmachine.buffer_store_b32 %off, %off, %desc1, %zero
      : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>,
         !waveamdmachine.reg<sgpr, 4>, !waveamdmachine.imm)
        -> !waveamdmachine.mem.token
  return
}

}
