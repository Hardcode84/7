// RUN: wave-opt --waveamd-insert-ticket-waits -split-input-file %s | FileCheck %s

// Both arms of a `cf.cond_br` issue exactly one extra `s_load_b32`
// before forwarding the original scalar to the merge block. The merge
// arm sees `%a` at the same position (1) on every path, so the join
// agrees on `lgkmcnt(1)`. Encoded as `imm 64535` for gfx1100.
module attributes {wavemachine.target = "amdgcn-amd-amdhsa--gfx1100"} {

// CHECK-LABEL: func.func @cfg_join_nonzero
// CHECK: wavemachine.s_load_b32
// CHECK: cf.cond_br
// CHECK: wavemachine.s_load_b32
// CHECK: cf.br
// CHECK: wavemachine.s_load_b32
// CHECK: cf.br
// CHECK: ^bb{{[0-9]+}}(%{{[0-9]+}}: !wavemachine.reg<sgpr, 1>)
// CHECK-NEXT: wavemachine.imm 64535
// CHECK-NEXT: wavemachine.s_waitcnt
// CHECK-NEXT: wavemachine.v_add_u32
func.func @cfg_join_nonzero(%cond: i1, %x: !wavemachine.reg<vgpr, 1>) {
  %zero = wavemachine.imm 0 : !wavemachine.imm
  %a = wavemachine.s_load_b32 %zero, "s[0:1]" : (!wavemachine.imm) -> !wavemachine.reg<sgpr, 1>
  cf.cond_br %cond, ^then, ^else
^then:
  %b = wavemachine.s_load_b32 %zero, "s[0:1]" : (!wavemachine.imm) -> !wavemachine.reg<sgpr, 1>
  cf.br ^merge(%a : !wavemachine.reg<sgpr, 1>)
^else:
  %c = wavemachine.s_load_b32 %zero, "s[0:1]" : (!wavemachine.imm) -> !wavemachine.reg<sgpr, 1>
  cf.br ^merge(%a : !wavemachine.reg<sgpr, 1>)
^merge(%m: !wavemachine.reg<sgpr, 1>):
  %sum = wavemachine.v_add_u32 %x, %m : (!wavemachine.reg<vgpr, 1>, !wavemachine.reg<sgpr, 1>) -> !wavemachine.reg<vgpr, 1>
  return
}

}

// -----

// Same shape but ONLY the `then` arm issues an extra load: at the merge
// the join sees `%a` at position 1 (through `then`) and position 0
// (through `else`). The static-correct wait is `lgkmcnt(MIN(1, 0)) = 0`
// = `imm 64519`. A `lgkmcnt(1)` here would be unsafe on the `else`
// path because the hardware lgkmcnt is already 1 (just `%a`), so the
// wait would return without `%a` ever draining.
module attributes {wavemachine.target = "amdgcn-amd-amdhsa--gfx1100"} {

// CHECK-LABEL: func.func @cfg_join_uneven_min
// CHECK: wavemachine.s_load_b32
// CHECK: cf.cond_br
// CHECK: wavemachine.s_load_b32
// CHECK: cf.br
// CHECK: cf.br
// CHECK: ^bb{{[0-9]+}}(%{{[0-9]+}}: !wavemachine.reg<sgpr, 1>)
// CHECK-NEXT: wavemachine.imm 64519
// CHECK-NEXT: wavemachine.s_waitcnt
// CHECK-NEXT: wavemachine.v_add_u32
func.func @cfg_join_uneven_min(%cond: i1, %x: !wavemachine.reg<vgpr, 1>) {
  %zero = wavemachine.imm 0 : !wavemachine.imm
  %a = wavemachine.s_load_b32 %zero, "s[0:1]" : (!wavemachine.imm) -> !wavemachine.reg<sgpr, 1>
  cf.cond_br %cond, ^then, ^else
^then:
  %b = wavemachine.s_load_b32 %zero, "s[0:1]" : (!wavemachine.imm) -> !wavemachine.reg<sgpr, 1>
  cf.br ^merge(%a : !wavemachine.reg<sgpr, 1>)
^else:
  cf.br ^merge(%a : !wavemachine.reg<sgpr, 1>)
^merge(%m: !wavemachine.reg<sgpr, 1>):
  %sum = wavemachine.v_add_u32 %x, %m : (!wavemachine.reg<vgpr, 1>, !wavemachine.reg<sgpr, 1>) -> !wavemachine.reg<vgpr, 1>
  return
}

}

// -----

module attributes {wavemachine.target = "amdgcn-amd-amdhsa--gfx1100"} {

// CHECK-LABEL: func.func @block_arg_ticket
// CHECK: wavemachine.s_load_b32
// CHECK: cf.br
// CHECK: ^bb{{[0-9]+}}(%{{[0-9]+}}: !wavemachine.reg<sgpr, 1>)
// CHECK-NEXT: wavemachine.imm 64519
// CHECK-NEXT: wavemachine.s_waitcnt
// CHECK-NEXT: wavemachine.v_add_u32
func.func @block_arg_ticket(%x: !wavemachine.reg<vgpr, 1>) {
  %zero = wavemachine.imm 0 : !wavemachine.imm
  %a = wavemachine.s_load_b32 %zero, "s[0:1]" : (!wavemachine.imm) -> !wavemachine.reg<sgpr, 1>
  cf.br ^merge(%a : !wavemachine.reg<sgpr, 1>)
^merge(%m: !wavemachine.reg<sgpr, 1>):
  %sum = wavemachine.v_add_u32 %x, %m : (!wavemachine.reg<vgpr, 1>, !wavemachine.reg<sgpr, 1>) -> !wavemachine.reg<vgpr, 1>
  return
}

}

// -----

// Both arms of the `scf.if` issue one extra `s_load_b32` before
// yielding the outer `%a`. The region-branch join sees `%a` (and the
// yielded `%r`) at position 1 from every arm, so the wait below the
// `scf.if` is `lgkmcnt(1)` = `imm 64535`.
module attributes {wavemachine.target = "amdgcn-amd-amdhsa--gfx1100"} {

// CHECK-LABEL: func.func @structured_if_nonzero
// CHECK: scf.if
// CHECK: wavemachine.s_load_b32
// CHECK: wavemachine.s_load_b32
// CHECK: wavemachine.imm 64535
// CHECK-NEXT: wavemachine.s_waitcnt
// CHECK-NEXT: wavemachine.v_add_u32
func.func @structured_if_nonzero(%cond: i1, %x: !wavemachine.reg<vgpr, 1>) {
  %zero = wavemachine.imm 0 : !wavemachine.imm
  %a = wavemachine.s_load_b32 %zero, "s[0:1]" : (!wavemachine.imm) -> !wavemachine.reg<sgpr, 1>
  %r = scf.if %cond -> (!wavemachine.reg<sgpr, 1>) {
    %b = wavemachine.s_load_b32 %zero, "s[0:1]" : (!wavemachine.imm) -> !wavemachine.reg<sgpr, 1>
    scf.yield %a : !wavemachine.reg<sgpr, 1>
  } else {
    %c = wavemachine.s_load_b32 %zero, "s[0:1]" : (!wavemachine.imm) -> !wavemachine.reg<sgpr, 1>
    scf.yield %a : !wavemachine.reg<sgpr, 1>
  }
  %sum = wavemachine.v_add_u32 %x, %r : (!wavemachine.reg<vgpr, 1>, !wavemachine.reg<sgpr, 1>) -> !wavemachine.reg<vgpr, 1>
  return
}

}

// -----

// Only the `then` arm of the `scf.if` issues an extra load. The
// region-branch join sees `%a` at position 1 (through `then`) and 0
// (through `else`); MIN = 0 → `lgkmcnt(0)` = `imm 64519`. `lgkmcnt(1)`
// would be unsafe on the `else` path (lgkmcnt is already 1 there).
module attributes {wavemachine.target = "amdgcn-amd-amdhsa--gfx1100"} {

// CHECK-LABEL: func.func @structured_if_uneven_min
// CHECK: scf.if
// CHECK: wavemachine.s_load_b32
// CHECK: wavemachine.imm 64519
// CHECK-NEXT: wavemachine.s_waitcnt
// CHECK-NEXT: wavemachine.v_add_u32
func.func @structured_if_uneven_min(%cond: i1, %x: !wavemachine.reg<vgpr, 1>) {
  %zero = wavemachine.imm 0 : !wavemachine.imm
  %a = wavemachine.s_load_b32 %zero, "s[0:1]" : (!wavemachine.imm) -> !wavemachine.reg<sgpr, 1>
  %r = scf.if %cond -> (!wavemachine.reg<sgpr, 1>) {
    %b = wavemachine.s_load_b32 %zero, "s[0:1]" : (!wavemachine.imm) -> !wavemachine.reg<sgpr, 1>
    scf.yield %a : !wavemachine.reg<sgpr, 1>
  } else {
    scf.yield %a : !wavemachine.reg<sgpr, 1>
  }
  %sum = wavemachine.v_add_u32 %x, %r : (!wavemachine.reg<vgpr, 1>, !wavemachine.reg<sgpr, 1>) -> !wavemachine.reg<vgpr, 1>
  return
}

}

// -----

module attributes {wavemachine.target = "amdgcn-amd-amdhsa--gfx1100"} {

// CHECK-LABEL: func.func @structured_for_double_buffer
// CHECK: scf.for
// CHECK: wavemachine.s_load_b32
// CHECK-NEXT: wavemachine.imm 64535
// CHECK-NEXT: wavemachine.s_waitcnt
// CHECK-NEXT: wavemachine.v_add_u32
func.func @structured_for_double_buffer(%x: !wavemachine.reg<vgpr, 1>) {
  %zero = wavemachine.imm 0 : !wavemachine.imm
  %init = wavemachine.s_load_b32 %zero, "s[0:1]" : (!wavemachine.imm) -> !wavemachine.reg<sgpr, 1>
  %c0 = arith.constant 0 : index
  %c4 = arith.constant 4 : index
  %c1 = arith.constant 1 : index
  %res = scf.for %i = %c0 to %c4 step %c1 iter_args(%cur = %init) -> (!wavemachine.reg<sgpr, 1>) {
    %next = wavemachine.s_load_b32 %zero, "s[0:1]" : (!wavemachine.imm) -> !wavemachine.reg<sgpr, 1>
    %sum = wavemachine.v_add_u32 %x, %cur : (!wavemachine.reg<vgpr, 1>, !wavemachine.reg<sgpr, 1>) -> !wavemachine.reg<vgpr, 1>
    scf.yield %next : !wavemachine.reg<sgpr, 1>
  }
  return
}

}

// -----

module attributes {wavemachine.target = "amdgcn-amd-amdhsa--gfx1100"} {

// CHECK-LABEL: func.func @structured_for_triple_buffer
// CHECK: scf.for
// CHECK: wavemachine.s_load_b32
// CHECK-NEXT: wavemachine.imm 64551
// CHECK-NEXT: wavemachine.s_waitcnt
// CHECK-NEXT: wavemachine.v_add_u32
func.func @structured_for_triple_buffer(%x: !wavemachine.reg<vgpr, 1>) {
  %zero = wavemachine.imm 0 : !wavemachine.imm
  %init0 = wavemachine.s_load_b32 %zero, "s[0:1]" : (!wavemachine.imm) -> !wavemachine.reg<sgpr, 1>
  %init1 = wavemachine.s_load_b32 %zero, "s[0:1]" : (!wavemachine.imm) -> !wavemachine.reg<sgpr, 1>
  %c0 = arith.constant 0 : index
  %c4 = arith.constant 4 : index
  %c1 = arith.constant 1 : index
  %r0, %r1 = scf.for %i = %c0 to %c4 step %c1
      iter_args(%cur = %init0, %nextBuf = %init1)
      -> (!wavemachine.reg<sgpr, 1>, !wavemachine.reg<sgpr, 1>) {
    %future0 = wavemachine.s_load_b32 %zero, "s[0:1]" : (!wavemachine.imm) -> !wavemachine.reg<sgpr, 1>
    %sum = wavemachine.v_add_u32 %x, %cur : (!wavemachine.reg<vgpr, 1>, !wavemachine.reg<sgpr, 1>) -> !wavemachine.reg<vgpr, 1>
    scf.yield %nextBuf, %future0 : !wavemachine.reg<sgpr, 1>, !wavemachine.reg<sgpr, 1>
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
module attributes {wavemachine.target = "amdgcn-amd-amdhsa--gfx1100"} {

// CHECK-LABEL: func.func @uniform_loop_two_vmem
// CHECK: wavemachine.uniform_loop
// CHECK:   wavemachine.global_load_b32
// CHECK-NEXT: wavemachine.imm 1015
// CHECK-NEXT: wavemachine.s_waitcnt
// CHECK-NEXT: wavemachine.v_add_u32
// CHECK: wavemachine.global_load_b32
// CHECK-NEXT: wavemachine.imm 1015
// CHECK-NEXT: wavemachine.s_waitcnt
// CHECK-NEXT: wavemachine.v_add_u32
func.func @uniform_loop_two_vmem(%off: !wavemachine.reg<vgpr, 1>, %base: !wavemachine.reg<sgpr, 2>, %ec: !wavemachine.reg<scc, 1>) {
  wavemachine.uniform_loop if %ec : !wavemachine.reg<scc, 1> {
    %a = wavemachine.global_load_b32 %off, %base : (!wavemachine.reg<vgpr, 1>, !wavemachine.reg<sgpr, 2>) -> (!wavemachine.reg<vgpr, 1>)
    %sa = wavemachine.v_add_u32 %a, %a : (!wavemachine.reg<vgpr, 1>, !wavemachine.reg<vgpr, 1>) -> !wavemachine.reg<vgpr, 1>
    %b = wavemachine.global_load_b32 %off, %base : (!wavemachine.reg<vgpr, 1>, !wavemachine.reg<sgpr, 2>) -> (!wavemachine.reg<vgpr, 1>)
    %sb = wavemachine.v_add_u32 %b, %b : (!wavemachine.reg<vgpr, 1>, !wavemachine.reg<vgpr, 1>) -> !wavemachine.reg<vgpr, 1>
    wavemachine.continue_if %ec : !wavemachine.reg<scc, 1>
  }
  return
}

}
