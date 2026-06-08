// RUN: wave-opt --waveamd-insert-ticket-waits -split-input-file %s | FileCheck %s
// RUN: wave-opt --waveamd-insert-ticket-waits -split-input-file %s | wave-opt -split-input-file | FileCheck %s

module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx1100"} {

// CHECK-LABEL: func.func @exec_if_token_result
// CHECK: waveamdmachine.exec_if
// CHECK: waveamdmachine.global_store_b32
// CHECK: otherwise
// CHECK: waveamdmachine.global_store_b32
// CHECK: waveamdmachine.s_waitcnt_vscnt vscnt(0)
// CHECK-NEXT: waveamdmachine.wait
func.func @exec_if_token_result(%cond: !waveamdmachine.reg<sgpr, 1>,
                                %off: !waveamdmachine.reg<vgpr, 1>,
                                %val: !waveamdmachine.reg<vgpr, 1>,
                                %base: !waveamdmachine.reg<sgpr, 2>) {
  %tok = waveamdmachine.exec_if %cond {
    %then = waveamdmachine.global_store_b32 %off, %val, %base
        : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>,
           !waveamdmachine.reg<sgpr, 2>) -> !waveamdmachine.mem.token
    waveamdmachine.yield %then : !waveamdmachine.mem.token
  } otherwise {
    %else = waveamdmachine.global_store_b32 %off, %val, %base
        : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>,
           !waveamdmachine.reg<sgpr, 2>) -> !waveamdmachine.mem.token
    waveamdmachine.yield %else : !waveamdmachine.mem.token
  } : !waveamdmachine.reg<sgpr, 1> -> !waveamdmachine.mem.token
  waveamdmachine.wait %tok : (!waveamdmachine.mem.token) -> ()
  return
}

// CHECK-LABEL: func.func @exec_if_branch_min_vscnt
// CHECK: waveamdmachine.global_store_b32
// CHECK: waveamdmachine.exec_if
// CHECK: waveamdmachine.global_store_b32
// CHECK: otherwise
// CHECK: waveamdmachine.s_waitcnt_vscnt vscnt(0)
// CHECK-NEXT: waveamdmachine.wait
func.func @exec_if_branch_min_vscnt(%cond: !waveamdmachine.reg<sgpr, 1>,
                                    %off: !waveamdmachine.reg<vgpr, 1>,
                                    %val: !waveamdmachine.reg<vgpr, 1>,
                                    %base: !waveamdmachine.reg<sgpr, 2>) {
  %old = waveamdmachine.global_store_b32 %off, %val, %base
      : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>,
         !waveamdmachine.reg<sgpr, 2>) -> !waveamdmachine.mem.token
  waveamdmachine.exec_if %cond {
    waveamdmachine.global_store_b32 %off, %val, %base
        : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>,
           !waveamdmachine.reg<sgpr, 2>) -> ()
    waveamdmachine.yield
  } otherwise {
    waveamdmachine.yield
  } : !waveamdmachine.reg<sgpr, 1>
  waveamdmachine.wait %old : (!waveamdmachine.mem.token) -> ()
  return
}

}

// -----

// Both arms of a `cf.cond_br` issue exactly one extra `ds_load_b32`
// before forwarding the original LDS value to the merge block. The merge
// arm sees `%a` at the same position (1) on every path, so the join
// agrees on `lgkmcnt(1)`.
module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx1100"} {

// CHECK-LABEL: func.func @cfg_join_nonzero
// CHECK: waveamdmachine.ds_load_b32
// CHECK: cf.cond_br
// CHECK: waveamdmachine.ds_load_b32
// CHECK: cf.br
// CHECK: waveamdmachine.ds_load_b32
// CHECK: cf.br
// CHECK: ^bb{{[0-9]+}}(%{{[0-9]+}}: !waveamdmachine.reg<vgpr, 1>)
// CHECK-NEXT: waveamdmachine.s_waitcnt lgkmcnt(1)
// CHECK-NEXT: waveamdmachine.v_add_u32
func.func @cfg_join_nonzero(%cond: i1, %x: !waveamdmachine.reg<vgpr, 1>) {
  %a = waveamdmachine.ds_load_b32 %x : (!waveamdmachine.reg<vgpr, 1>) -> !waveamdmachine.reg<vgpr, 1>
  cf.cond_br %cond, ^then, ^else
^then:
  %b = waveamdmachine.ds_load_b32 %x : (!waveamdmachine.reg<vgpr, 1>) -> !waveamdmachine.reg<vgpr, 1>
  cf.br ^merge(%a : !waveamdmachine.reg<vgpr, 1>)
^else:
  %c = waveamdmachine.ds_load_b32 %x : (!waveamdmachine.reg<vgpr, 1>) -> !waveamdmachine.reg<vgpr, 1>
  cf.br ^merge(%a : !waveamdmachine.reg<vgpr, 1>)
^merge(%m: !waveamdmachine.reg<vgpr, 1>):
  %sum = waveamdmachine.v_add_u32 %x, %m : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>) -> !waveamdmachine.reg<vgpr, 1>
  return
}

}

// -----

// Same shape but ONLY the `then` arm issues an extra load: at the merge
// the join sees `%a` at position 1 (through `then`) and position 0
// (through `else`). The static-correct wait is `lgkmcnt(MIN(1, 0)) = 0`
// = `lgkmcnt(0)`. A `lgkmcnt(1)` here would be unsafe on the `else`
// path because the hardware lgkmcnt is already 1 (just `%a`), so the
// wait would return without `%a` ever draining.
module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx1100"} {

// CHECK-LABEL: func.func @cfg_join_uneven_min
// CHECK: waveamdmachine.s_load_b32
// CHECK: cf.cond_br
// CHECK: waveamdmachine.s_load_b32
// CHECK: cf.br
// CHECK: cf.br
// CHECK: ^bb{{[0-9]+}}(%{{[0-9]+}}: !waveamdmachine.reg<sgpr, 1>)
// CHECK-NEXT: waveamdmachine.s_waitcnt lgkmcnt(0)
// CHECK-NEXT: waveamdmachine.v_add_u32
func.func @cfg_join_uneven_min(%cond: i1, %x: !waveamdmachine.reg<vgpr, 1>) {
  %zero = waveamdmachine.imm 0 : !waveamdmachine.imm
  %a = waveamdmachine.s_load_b32 %zero, "s[0:1]" : (!waveamdmachine.imm) -> !waveamdmachine.reg<sgpr, 1>
  cf.cond_br %cond, ^then, ^else
^then:
  %b = waveamdmachine.s_load_b32 %zero, "s[0:1]" : (!waveamdmachine.imm) -> !waveamdmachine.reg<sgpr, 1>
  cf.br ^merge(%a : !waveamdmachine.reg<sgpr, 1>)
^else:
  cf.br ^merge(%a : !waveamdmachine.reg<sgpr, 1>)
^merge(%m: !waveamdmachine.reg<sgpr, 1>):
  %sum = waveamdmachine.v_add_u32 %x, %m : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<sgpr, 1>) -> !waveamdmachine.reg<vgpr, 1>
  return
}

}

// -----

module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx1100"} {

// CHECK-LABEL: func.func @block_arg_ticket
// CHECK: waveamdmachine.s_load_b32
// CHECK: cf.br
// CHECK: ^bb{{[0-9]+}}(%{{[0-9]+}}: !waveamdmachine.reg<sgpr, 1>)
// CHECK-NEXT: waveamdmachine.s_waitcnt lgkmcnt(0)
// CHECK-NEXT: waveamdmachine.v_add_u32
func.func @block_arg_ticket(%x: !waveamdmachine.reg<vgpr, 1>) {
  %zero = waveamdmachine.imm 0 : !waveamdmachine.imm
  %a = waveamdmachine.s_load_b32 %zero, "s[0:1]" : (!waveamdmachine.imm) -> !waveamdmachine.reg<sgpr, 1>
  cf.br ^merge(%a : !waveamdmachine.reg<sgpr, 1>)
^merge(%m: !waveamdmachine.reg<sgpr, 1>):
  %sum = waveamdmachine.v_add_u32 %x, %m : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<sgpr, 1>) -> !waveamdmachine.reg<vgpr, 1>
  return
}

}

// -----

// Both arms of the `scf.if` issue one extra `ds_load_b32` before
// yielding the outer `%a`. The region-branch join sees `%a` (and the
// yielded `%r`) at position 1 from every arm, so the wait below the
// `scf.if` is `lgkmcnt(1)`.
module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx1100"} {

// CHECK-LABEL: func.func @structured_if_nonzero
// CHECK: scf.if
// CHECK: waveamdmachine.ds_load_b32
// CHECK: waveamdmachine.ds_load_b32
// CHECK: waveamdmachine.s_waitcnt lgkmcnt(1)
// CHECK-NEXT: waveamdmachine.v_add_u32
func.func @structured_if_nonzero(%cond: i1, %x: !waveamdmachine.reg<vgpr, 1>) {
  %a = waveamdmachine.ds_load_b32 %x : (!waveamdmachine.reg<vgpr, 1>) -> !waveamdmachine.reg<vgpr, 1>
  %r = scf.if %cond -> (!waveamdmachine.reg<vgpr, 1>) {
    %b = waveamdmachine.ds_load_b32 %x : (!waveamdmachine.reg<vgpr, 1>) -> !waveamdmachine.reg<vgpr, 1>
    scf.yield %a : !waveamdmachine.reg<vgpr, 1>
  } else {
    %c = waveamdmachine.ds_load_b32 %x : (!waveamdmachine.reg<vgpr, 1>) -> !waveamdmachine.reg<vgpr, 1>
    scf.yield %a : !waveamdmachine.reg<vgpr, 1>
  }
  %sum = waveamdmachine.v_add_u32 %x, %r : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>) -> !waveamdmachine.reg<vgpr, 1>
  return
}

}

// -----

// Only the `then` arm of the `scf.if` issues an extra load. The
// region-branch join sees `%a` at position 1 (through `then`) and 0
// (through `else`); MIN = 0 -> `lgkmcnt(0)`. `lgkmcnt(1)`
// would be unsafe on the `else` path (lgkmcnt is already 1 there).
module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx1100"} {

// CHECK-LABEL: func.func @structured_if_uneven_min
// CHECK: scf.if
// CHECK: waveamdmachine.s_load_b32
// CHECK: waveamdmachine.s_waitcnt lgkmcnt(0)
// CHECK-NEXT: waveamdmachine.v_add_u32
func.func @structured_if_uneven_min(%cond: i1, %x: !waveamdmachine.reg<vgpr, 1>) {
  %zero = waveamdmachine.imm 0 : !waveamdmachine.imm
  %a = waveamdmachine.s_load_b32 %zero, "s[0:1]" : (!waveamdmachine.imm) -> !waveamdmachine.reg<sgpr, 1>
  %r = scf.if %cond -> (!waveamdmachine.reg<sgpr, 1>) {
    %b = waveamdmachine.s_load_b32 %zero, "s[0:1]" : (!waveamdmachine.imm) -> !waveamdmachine.reg<sgpr, 1>
    scf.yield %a : !waveamdmachine.reg<sgpr, 1>
  } else {
    scf.yield %a : !waveamdmachine.reg<sgpr, 1>
  }
  %sum = waveamdmachine.v_add_u32 %x, %r : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<sgpr, 1>) -> !waveamdmachine.reg<vgpr, 1>
  return
}

}

// -----

module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx1100"} {

// CHECK-LABEL: func.func @structured_for_double_buffer
// CHECK: scf.for
// CHECK: waveamdmachine.ds_load_b32
// CHECK-NEXT: waveamdmachine.s_waitcnt lgkmcnt(1)
// CHECK-NEXT: waveamdmachine.v_add_u32
func.func @structured_for_double_buffer(%x: !waveamdmachine.reg<vgpr, 1>) {
  %init = waveamdmachine.ds_load_b32 %x : (!waveamdmachine.reg<vgpr, 1>) -> !waveamdmachine.reg<vgpr, 1>
  %c0 = arith.constant 0 : index
  %c4 = arith.constant 4 : index
  %c1 = arith.constant 1 : index
  %res = scf.for %i = %c0 to %c4 step %c1 iter_args(%cur = %init) -> (!waveamdmachine.reg<vgpr, 1>) {
    %next = waveamdmachine.ds_load_b32 %x : (!waveamdmachine.reg<vgpr, 1>) -> !waveamdmachine.reg<vgpr, 1>
    %sum = waveamdmachine.v_add_u32 %x, %cur : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>) -> !waveamdmachine.reg<vgpr, 1>
    scf.yield %next : !waveamdmachine.reg<vgpr, 1>
  }
  return
}

}

// -----

module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx1100"} {

// CHECK-LABEL: func.func @structured_for_triple_buffer
// CHECK: scf.for
// CHECK: waveamdmachine.ds_load_b32
// CHECK-NEXT: waveamdmachine.s_waitcnt lgkmcnt(2)
// CHECK-NEXT: waveamdmachine.v_add_u32
func.func @structured_for_triple_buffer(%x: !waveamdmachine.reg<vgpr, 1>) {
  %init0 = waveamdmachine.ds_load_b32 %x : (!waveamdmachine.reg<vgpr, 1>) -> !waveamdmachine.reg<vgpr, 1>
  %init1 = waveamdmachine.ds_load_b32 %x : (!waveamdmachine.reg<vgpr, 1>) -> !waveamdmachine.reg<vgpr, 1>
  %c0 = arith.constant 0 : index
  %c4 = arith.constant 4 : index
  %c1 = arith.constant 1 : index
  %r0, %r1 = scf.for %i = %c0 to %c4 step %c1
      iter_args(%cur = %init0, %nextBuf = %init1)
      -> (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>) {
    %future0 = waveamdmachine.ds_load_b32 %x : (!waveamdmachine.reg<vgpr, 1>) -> !waveamdmachine.reg<vgpr, 1>
    %sum = waveamdmachine.v_add_u32 %x, %cur : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>) -> !waveamdmachine.reg<vgpr, 1>
    scf.yield %nextBuf, %future0 : !waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>
  }
  return
}

}

// -----

// Regression for the back-edge inflation bug: two in-iter producers in
// a `uniform_loop` body, where the FIRST consumer must see vmcnt(0)
// rather than vmcnt(1). Without the back-edge counter rewind the
// scoreboard's `lastTicket` would propagate the body-tail's vmem
// ticket (=1) into the start of every iteration; the early consumer of
// `%a` would then compute `threshold = 1 - 0 = 1` and emit vmcnt(1),
// leaving the last dword of `%a` unread.
module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx1100"} {

// CHECK-LABEL: func.func @uniform_loop_two_vmem
// CHECK: waveamdmachine.uniform_loop
// CHECK:   waveamdmachine.global_load_b32
// CHECK-NEXT: waveamdmachine.s_waitcnt vmcnt(0)
// CHECK-NEXT: waveamdmachine.v_add_u32
// CHECK: waveamdmachine.global_load_b32
// CHECK-NEXT: waveamdmachine.s_waitcnt vmcnt(0)
// CHECK-NEXT: waveamdmachine.v_add_u32
func.func @uniform_loop_two_vmem(%off: !waveamdmachine.reg<vgpr, 1>, %base: !waveamdmachine.reg<sgpr, 2>, %ec: !waveamdmachine.reg<scc, 1>) {
  waveamdmachine.uniform_loop if %ec : !waveamdmachine.reg<scc, 1> {
    %a = waveamdmachine.global_load_b32 %off, %base : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<sgpr, 2>) -> (!waveamdmachine.reg<vgpr, 1>)
    %sa = waveamdmachine.v_add_u32 %a, %a : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>) -> !waveamdmachine.reg<vgpr, 1>
    %b = waveamdmachine.global_load_b32 %off, %base : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<sgpr, 2>) -> (!waveamdmachine.reg<vgpr, 1>)
    %sb = waveamdmachine.v_add_u32 %b, %b : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>) -> !waveamdmachine.reg<vgpr, 1>
    waveamdmachine.continue_if %ec : !waveamdmachine.reg<scc, 1>
  }
  return
}

// CHECK-LABEL: func.func @uniform_loop_carried_dma_token_barrier
// CHECK: waveamdmachine.uniform_loop
// CHECK: ^bb0(%[[TOK:.+]]: !waveamdmachine.mem.token):
// CHECK-NEXT: waveamdmachine.s_waitcnt vmcnt(0)
// CHECK-NEXT: waveamdmachine.s_barrier %[[TOK]]
func.func @uniform_loop_carried_dma_token_barrier(
    %off: !waveamdmachine.reg<vgpr, 1>,
    %base: !waveamdmachine.reg<sgpr, 2>,
    %lds_base: !waveamdmachine.reg<sgpr, 1>,
    %ec: !waveamdmachine.reg<scc, 1>) {
  %root = waveamdmachine.token : !waveamdmachine.mem.token
  %m0 = waveamdmachine.s_mov_m0 %lds_base
      : (!waveamdmachine.reg<sgpr, 1>) -> !waveamdmachine.m0
  %init = waveamdmachine.global_load_lds_b128 %off, %base, %m0 after %root
      : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<sgpr, 2>,
         !waveamdmachine.m0, !waveamdmachine.mem.token)
      -> !waveamdmachine.mem.token
  %unused = waveamdmachine.uniform_loop if %ec : !waveamdmachine.reg<scc, 1>
      carries(%init : !waveamdmachine.mem.token) {
  ^bb0(%tok: !waveamdmachine.mem.token):
    %ready = waveamdmachine.s_barrier %tok
        : (!waveamdmachine.mem.token) -> !waveamdmachine.mem.token
    %next_m0 = waveamdmachine.s_mov_m0 %lds_base
        : (!waveamdmachine.reg<sgpr, 1>) -> !waveamdmachine.m0
    %next = waveamdmachine.global_load_lds_b128 %off, %base, %next_m0 after %ready
        : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<sgpr, 2>,
           !waveamdmachine.m0, !waveamdmachine.mem.token)
        -> !waveamdmachine.mem.token
    waveamdmachine.continue_if %ec : !waveamdmachine.reg<scc, 1>
        carries(%next : !waveamdmachine.mem.token)
  } -> !waveamdmachine.mem.token
  return
}

}
