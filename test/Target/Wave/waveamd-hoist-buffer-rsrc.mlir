// RUN: wave-opt --waveamd-hoist-buffer-rsrc %s | FileCheck %s

module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx1100"} {

// CHECK-LABEL: func.func @hoist_loop_buffer_rsrc(
// CHECK-SAME:    %[[BASE0:[^:]+]]: !waveamdmachine.reg<sgpr, 2>
// CHECK-SAME:    %[[OFF0:[^:]+]]: !waveamdmachine.reg<sgpr, 1>
// CHECK: %[[INIT_BASE:.*]], %{{.*}} = waveamdmachine.s_add_u64_u32 %[[BASE0]], %[[OFF0]]
// CHECK: %[[INIT_DESC:.*]] = waveamdmachine.make_buffer_rsrc %[[INIT_BASE]]
// CHECK: %[[LOOP:.*]]:3 = waveamdmachine.uniform_loop
// CHECK-SAME: carries(%[[OFF0]], {{%.*}}, %[[INIT_DESC]] :
// CHECK: ^bb0(%[[OFF:.*]]: !waveamdmachine.reg<sgpr, 1>, %[[DEP:.*]]: !waveamdmachine.mem.token, %[[DESC_IN:.*]]: !waveamdmachine.reg<sgpr, 4>):
// CHECK: %[[BASE:.*]], %{{.*}} = waveamdmachine.s_add_u64_u32 %[[BASE0]], %[[OFF]]
// CHECK-NEXT: %[[DESC:.*]] = waveamdmachine.update_buffer_rsrc_base %[[DESC_IN]], %[[BASE]]
// CHECK-NEXT: waveamdmachine.buffer_load_lds_b128 {{.*}}, %[[DESC]]
// CHECK: waveamdmachine.continue_if {{.*}} : !waveamdmachine.reg<scc, 1>
// CHECK-SAME: carries({{%.*}}, {{%.*}}, %[[DESC]] :
func.func @hoist_loop_buffer_rsrc(
    %base0: !waveamdmachine.reg<sgpr, 2>,
    %off0: !waveamdmachine.reg<sgpr, 1>,
    %vaddr: !waveamdmachine.reg<vgpr, 1>,
    %m0: !waveamdmachine.m0) attributes {wave.kernel} {
  %tok0 = waveamdmachine.token : !waveamdmachine.mem.token
  %range = waveamdmachine.imm 2147483647 : !waveamdmachine.imm
  %zero = waveamdmachine.imm 0 : !waveamdmachine.imm
  %step = waveamdmachine.imm 16 : !waveamdmachine.imm
  %limit = waveamdmachine.imm 64 : !waveamdmachine.imm
  %loop:2 = waveamdmachine.uniform_loop
      carries(%off0, %tok0 :
              !waveamdmachine.reg<sgpr, 1>,
              !waveamdmachine.mem.token) {
  ^bb0(%off: !waveamdmachine.reg<sgpr, 1>,
       %dep: !waveamdmachine.mem.token):
    %base, %unused = waveamdmachine.s_add_u64_u32 %base0, %off
        : (!waveamdmachine.reg<sgpr, 2>, !waveamdmachine.reg<sgpr, 1>)
          -> (!waveamdmachine.reg<sgpr, 2>, !waveamdmachine.reg<scc, 1>)
    %desc = waveamdmachine.make_buffer_rsrc %base, %range
        : (!waveamdmachine.reg<sgpr, 2>, !waveamdmachine.imm)
          -> !waveamdmachine.reg<sgpr, 4>
    %tok1 = waveamdmachine.buffer_load_lds_b128
        %vaddr, %desc, %zero, %m0 after %dep
        : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<sgpr, 4>,
           !waveamdmachine.imm, !waveamdmachine.m0,
           !waveamdmachine.mem.token) -> !waveamdmachine.mem.token
    %next, %next_scc = waveamdmachine.s_add_i32 %off, %step
        : (!waveamdmachine.reg<sgpr, 1>, !waveamdmachine.imm)
          -> (!waveamdmachine.reg<sgpr, 1>, !waveamdmachine.reg<scc, 1>)
    %cond = waveamdmachine.s_cmp_lt_i32 %next, %limit
        : (!waveamdmachine.reg<sgpr, 1>, !waveamdmachine.imm)
          -> !waveamdmachine.reg<scc, 1>
    waveamdmachine.continue_if %cond : !waveamdmachine.reg<scc, 1>
        carries(%next, %tok1 :
                !waveamdmachine.reg<sgpr, 1>,
                !waveamdmachine.mem.token)
  } -> !waveamdmachine.reg<sgpr, 1>, !waveamdmachine.mem.token
  return
}

// CHECK-LABEL: func.func @skip_loop_variant_range(
// CHECK: waveamdmachine.uniform_loop
// CHECK: waveamdmachine.make_buffer_rsrc
// CHECK-NOT: waveamdmachine.update_buffer_rsrc_base
// CHECK: return
func.func @skip_loop_variant_range(
    %base: !waveamdmachine.reg<sgpr, 2>,
    %range0: !waveamdmachine.reg<sgpr, 1>,
    %vaddr: !waveamdmachine.reg<vgpr, 1>,
    %m0: !waveamdmachine.m0) attributes {wave.kernel} {
  %tok0 = waveamdmachine.token : !waveamdmachine.mem.token
  %zero = waveamdmachine.imm 0 : !waveamdmachine.imm
  %step = waveamdmachine.imm 16 : !waveamdmachine.imm
  %limit = waveamdmachine.imm 128 : !waveamdmachine.imm
  %loop:2 = waveamdmachine.uniform_loop
      carries(%range0, %tok0 :
              !waveamdmachine.reg<sgpr, 1>,
              !waveamdmachine.mem.token) {
  ^bb0(%range: !waveamdmachine.reg<sgpr, 1>,
       %dep: !waveamdmachine.mem.token):
    %desc = waveamdmachine.make_buffer_rsrc %base, %range
        : (!waveamdmachine.reg<sgpr, 2>, !waveamdmachine.reg<sgpr, 1>)
          -> !waveamdmachine.reg<sgpr, 4>
    %tok1 = waveamdmachine.buffer_load_lds_b128
        %vaddr, %desc, %zero, %m0 after %dep
        : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<sgpr, 4>,
           !waveamdmachine.imm, !waveamdmachine.m0,
           !waveamdmachine.mem.token) -> !waveamdmachine.mem.token
    %next, %next_scc = waveamdmachine.s_add_i32 %range, %step
        : (!waveamdmachine.reg<sgpr, 1>, !waveamdmachine.imm)
          -> (!waveamdmachine.reg<sgpr, 1>, !waveamdmachine.reg<scc, 1>)
    %cond = waveamdmachine.s_cmp_lt_i32 %next, %limit
        : (!waveamdmachine.reg<sgpr, 1>, !waveamdmachine.imm)
          -> !waveamdmachine.reg<scc, 1>
    waveamdmachine.continue_if %cond : !waveamdmachine.reg<scc, 1>
        carries(%next, %tok1 :
                !waveamdmachine.reg<sgpr, 1>,
                !waveamdmachine.mem.token)
  } -> !waveamdmachine.reg<sgpr, 1>, !waveamdmachine.mem.token
  return
}

}
