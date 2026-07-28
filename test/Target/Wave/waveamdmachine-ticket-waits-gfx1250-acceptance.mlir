// RUN: wave-opt --waveamd-insert-ticket-waits %s | FileCheck %s
// RUN: wave-opt --waveamd-insert-ticket-waits %s | wave-opt --waveamd-insert-ticket-waits | FileCheck %s

module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx1250"} {

// CHECK-LABEL: func.func @independent_load_wait
// CHECK: [[LOAD:%.*]] = waveamdmachine.global_load_b32
// CHECK-NEXT: waveamdmachine.s_waitcnt_split loadcnt(0)
// CHECK-NEXT: waveamdmachine.v_add_u32 [[LOAD]]
func.func @independent_load_wait(
    %off: !waveamdmachine.reg<vgpr, 1, 0>,
    %base: !waveamdmachine.reg<sgpr, 2, 0>,
    %rhs: !waveamdmachine.reg<vgpr, 1, 1>) {
  %load = waveamdmachine.global_load_b32 %off, %base
      : (!waveamdmachine.reg<vgpr, 1, 0>,
         !waveamdmachine.reg<sgpr, 2, 0>)
        -> !waveamdmachine.reg<vgpr, 1, 2>
  %sum = waveamdmachine.v_add_u32 %load, %rhs
      : (!waveamdmachine.reg<vgpr, 1, 2>,
         !waveamdmachine.reg<vgpr, 1, 1>)
        -> !waveamdmachine.reg<vgpr, 1, 3>
  return
}

// CHECK-LABEL: func.func @vmem_to_smem_drains_x
// CHECK: waveamdmachine.global_load_b32
// CHECK-NEXT: waveamdmachine.s_load_b32
// CHECK-NOT: waveamdmachine.s_waitcnt_split
// CHECK-NEXT: waveamdmachine.v_add_u32
func.func @vmem_to_smem_drains_x(
    %off: !waveamdmachine.reg<vgpr, 1, 0>,
    %base: !waveamdmachine.reg<sgpr, 2, 4>,
    %lhs: !waveamdmachine.reg<vgpr, 1, 1>,
    %rhs: !waveamdmachine.reg<vgpr, 1, 2>) {
  %zero = waveamdmachine.imm 0 : !waveamdmachine.imm
  %vmem = waveamdmachine.global_load_b32 %off, %base
      : (!waveamdmachine.reg<vgpr, 1, 0>,
         !waveamdmachine.reg<sgpr, 2, 4>)
        -> !waveamdmachine.reg<vgpr, 1, 5>
  %smem = waveamdmachine.s_load_b32 %zero, "s[8:9]"
      : (!waveamdmachine.imm) -> !waveamdmachine.reg<sgpr, 1, 10>
  %clobber = waveamdmachine.v_add_u32 %lhs, %rhs
      : (!waveamdmachine.reg<vgpr, 1, 1>,
         !waveamdmachine.reg<vgpr, 1, 2>)
        -> !waveamdmachine.reg<vgpr, 1, 0>
  return
}

// CHECK-LABEL: func.func @load_x_loop_backedge
// CHECK: scf.for
// CHECK: [[NEXT:%.*]] = waveamdmachine.global_load_b32
// CHECK-NEXT: waveamdmachine.s_waitcnt_split loadcnt(1)
// CHECK-NEXT: waveamdmachine.v_add_u32
// CHECK-NEXT: waveamdmachine.s_waitcnt_split xcnt(0)
// CHECK-NEXT: waveamdmachine.v_add_u32
// CHECK: scf.yield [[NEXT]]
func.func @load_x_loop_backedge(
    %initial_off: !waveamdmachine.reg<vgpr, 1, 0>,
    %loop_off: !waveamdmachine.reg<vgpr, 1, 1>,
    %base: !waveamdmachine.reg<sgpr, 2, 0>,
    %lhs: !waveamdmachine.reg<vgpr, 1, 2>,
    %rhs: !waveamdmachine.reg<vgpr, 1, 3>) {
  %initial = waveamdmachine.global_load_b32 %initial_off, %base
      : (!waveamdmachine.reg<vgpr, 1, 0>,
         !waveamdmachine.reg<sgpr, 2, 0>)
        -> !waveamdmachine.reg<vgpr, 1>
  %c0 = arith.constant 0 : index
  %c4 = arith.constant 4 : index
  %c1 = arith.constant 1 : index
  %result = scf.for %i = %c0 to %c4 step %c1
      iter_args(%current = %initial)
      -> (!waveamdmachine.reg<vgpr, 1>) {
    %next = waveamdmachine.global_load_b32 %loop_off, %base
        : (!waveamdmachine.reg<vgpr, 1, 1>,
           !waveamdmachine.reg<sgpr, 2, 0>)
          -> !waveamdmachine.reg<vgpr, 1>
    %sum = waveamdmachine.v_add_u32 %current, %lhs
        : (!waveamdmachine.reg<vgpr, 1>,
           !waveamdmachine.reg<vgpr, 1, 2>)
          -> !waveamdmachine.reg<vgpr, 1, 12>
    %clobber = waveamdmachine.v_add_u32 %lhs, %rhs
        : (!waveamdmachine.reg<vgpr, 1, 2>,
           !waveamdmachine.reg<vgpr, 1, 3>)
          -> !waveamdmachine.reg<vgpr, 1, 1>
    scf.yield %next : !waveamdmachine.reg<vgpr, 1>
  }
  return
}

}
