// RUN: wave-opt --waveamd-insert-ticket-waits -split-input-file %s | FileCheck %s

module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx1100"} {

// CHECK-LABEL: func.func @lgkm_nonzero_distance
// CHECK: waveamdmachine.s_load_b32
// CHECK: waveamdmachine.s_load_b32
// CHECK: waveamdmachine.imm 64535
// CHECK-NEXT: waveamdmachine.s_waitcnt
// CHECK-NEXT: waveamdmachine.v_add_u32
func.func @lgkm_nonzero_distance(%x: !waveamdmachine.reg<vgpr, 1>) {
  %zero = waveamdmachine.imm 0 : !waveamdmachine.imm
  %a = waveamdmachine.s_load_b32 %zero, "s[0:1]" : (!waveamdmachine.imm) -> !waveamdmachine.reg<sgpr, 1>
  %b = waveamdmachine.s_load_b32 %zero, "s[0:1]" : (!waveamdmachine.imm) -> !waveamdmachine.reg<sgpr, 1>
  %sum = waveamdmachine.v_add_u32 %x, %a : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<sgpr, 1>) -> !waveamdmachine.reg<vgpr, 1>
  return
}

}

// -----

module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx1100"} {

// CHECK-LABEL: func.func @store_uses_vscnt
// CHECK: waveamdmachine.global_store_b32
// CHECK: waveamdmachine.imm 0
// CHECK-NEXT: waveamdmachine.s_waitcnt_vscnt
// CHECK-NEXT: waveamdmachine.s_endpgm
func.func @store_uses_vscnt(%offset: !waveamdmachine.reg<vgpr, 1>, %value: !waveamdmachine.reg<vgpr, 1>, %base: !waveamdmachine.reg<sgpr, 2>) {
  waveamdmachine.global_store_b32 %offset, %value, %base : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<sgpr, 2>) -> ()
  waveamdmachine.s_endpgm
  return
}

}

// -----

module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx1100"} {

// CHECK-LABEL: func.func @existing_wait_satisfies_use
// CHECK: waveamdmachine.s_waitcnt
// CHECK-NOT: waveamdmachine.s_waitcnt
// CHECK: waveamdmachine.v_add_u32
func.func @existing_wait_satisfies_use(%x: !waveamdmachine.reg<vgpr, 1>) {
  %zero = waveamdmachine.imm 0 : !waveamdmachine.imm
  %a = waveamdmachine.s_load_b32 %zero, "s[0:1]" : (!waveamdmachine.imm) -> !waveamdmachine.reg<sgpr, 1>
  %wait = waveamdmachine.imm 64519 : !waveamdmachine.imm
  waveamdmachine.s_waitcnt %wait : (!waveamdmachine.imm) -> ()
  %sum = waveamdmachine.v_add_u32 %x, %a : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<sgpr, 1>) -> !waveamdmachine.reg<vgpr, 1>
  return
}

}

// -----

// Software-pipelined LDS staging exposes memory overlap when two
// tuple-loads are issued before either of their LDS stores: the
// first store only needs the *first* load drained, so the second
// tuple's 8 hardware issues are allowed to remain in flight. This
// pins down the resulting `s_waitcnt vmcnt(8)` (imm 9207) for the
// first store and the trailing `vmcnt(0)` (imm 1015) for the second.
// Without this scheduling the pass would emit two conservative
// `vmcnt(0)` waits and serialize the two global tuples.
module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx1100"} {

// CHECK-LABEL: func.func @overlap_two_tuple_loads
// CHECK: waveamdmachine.global_load_tuple_b32
// CHECK-NEXT: waveamdmachine.global_load_tuple_b32
// CHECK-NEXT: waveamdmachine.imm 9207
// CHECK-NEXT: waveamdmachine.s_waitcnt
// CHECK-NEXT: waveamdmachine.ds_store_tuple_b32
// CHECK-NEXT: waveamdmachine.imm 1015
// CHECK-NEXT: waveamdmachine.s_waitcnt
// CHECK-NEXT: waveamdmachine.ds_store_tuple_b32
func.func @overlap_two_tuple_loads(%a_off: !waveamdmachine.reg<vgpr, 1>,
                                   %a_base: !waveamdmachine.reg<sgpr, 2>,
                                   %b_off: !waveamdmachine.reg<vgpr, 1>,
                                   %b_base: !waveamdmachine.reg<sgpr, 2>,
                                   %lds_a: !waveamdmachine.reg<vgpr, 1>,
                                   %lds_b: !waveamdmachine.reg<vgpr, 1>) {
  %a_regs, %a_tok = waveamdmachine.global_load_tuple_b32 %a_off, %a_base : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<sgpr, 2>) -> (!waveamdmachine.reg<vgpr, 8>, !waveamdmachine.mem.token)
  %b_regs, %b_tok = waveamdmachine.global_load_tuple_b32 %b_off, %b_base : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<sgpr, 2>) -> (!waveamdmachine.reg<vgpr, 8>, !waveamdmachine.mem.token)
  %a_st = waveamdmachine.ds_store_tuple_b32 %lds_a, %a_regs after %a_tok : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 8>, !waveamdmachine.mem.token) -> !waveamdmachine.mem.token
  %b_st = waveamdmachine.ds_store_tuple_b32 %lds_b, %b_regs after %b_tok : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 8>, !waveamdmachine.mem.token) -> !waveamdmachine.mem.token
  return
}

}

// -----

// Two consumers of the same `s_load_b32` both demand `lgkmcnt(0)`,
// but the second is redundant because the pass already emitted the
// drain for the first and no new LGKM issue happened in between.
// The post-emission cleanup must collapse the run.
module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx1100"} {

// CHECK-LABEL: func.func @consecutive_consumers_dedupe_lgkm
// CHECK: waveamdmachine.s_load_b32
// CHECK: waveamdmachine.imm 64519
// CHECK-NEXT: waveamdmachine.s_waitcnt
// CHECK-NEXT: waveamdmachine.v_add_u32
// CHECK-NOT: waveamdmachine.s_waitcnt
// CHECK: waveamdmachine.v_add_u32
// CHECK-NOT: waveamdmachine.s_waitcnt
// CHECK: return
func.func @consecutive_consumers_dedupe_lgkm(%x: !waveamdmachine.reg<vgpr, 1>) {
  %zero = waveamdmachine.imm 0 : !waveamdmachine.imm
  %a = waveamdmachine.s_load_b32 %zero, "s[0:1]" : (!waveamdmachine.imm) -> !waveamdmachine.reg<sgpr, 1>
  %c = waveamdmachine.v_add_u32 %x, %a : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<sgpr, 1>) -> !waveamdmachine.reg<vgpr, 1>
  %d = waveamdmachine.v_add_u32 %c, %a : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<sgpr, 1>) -> !waveamdmachine.reg<vgpr, 1>
  return
}

}

// -----

// `s_waitcnt lgkmcnt(N)` (looser) is redundant when a tighter
// `lgkmcnt(0)` for the same outstanding queue is already in flight.
// In the WMMA matmul this manifests as `lgkmcnt(32)`/`lgkmcnt(34)`
// directly behind a `lgkmcnt(0)`; both must drop.
module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx1100"} {

// CHECK-LABEL: func.func @tight_then_loose_collapses
// The first `s_load_b32` -> `v_add_u32` pair forces a `lgkmcnt(0)`
// drain. The chained `v_xor` keeps the consumer live and the trailing
// `v_add_u32` reuses the already-drained scalar load: the cleanup
// must drop the second `s_waitcnt` and the IR holds a single
// `imm 64519 + s_waitcnt` for the whole block.
// CHECK: waveamdmachine.s_load_b32
// CHECK: waveamdmachine.imm 64519
// CHECK-NEXT: waveamdmachine.s_waitcnt
// CHECK-NEXT: waveamdmachine.v_add_u32
// CHECK-NEXT: waveamdmachine.v_xor_b32
// CHECK-NOT: waveamdmachine.s_waitcnt
// CHECK: waveamdmachine.v_add_u32
// CHECK-NOT: waveamdmachine.s_waitcnt
// CHECK: return
func.func @tight_then_loose_collapses(%x: !waveamdmachine.reg<vgpr, 1>) {
  %zero = waveamdmachine.imm 0 : !waveamdmachine.imm
  %a = waveamdmachine.s_load_b32 %zero, "s[0:1]" : (!waveamdmachine.imm) -> !waveamdmachine.reg<sgpr, 1>
  %c = waveamdmachine.v_add_u32 %x, %a : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<sgpr, 1>) -> !waveamdmachine.reg<vgpr, 1>
  %d = waveamdmachine.v_xor_b32 %c, %a : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<sgpr, 1>) -> !waveamdmachine.reg<vgpr, 1>
  %e = waveamdmachine.v_add_u32 %d, %a : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<sgpr, 1>) -> !waveamdmachine.reg<vgpr, 1>
  return
}

}

// -----

// Two consumers of the same `global_store_b32` both demand a
// `vscnt(0)` drain (e.g., two `s_endpgm`-style flushes). The
// post-emission cleanup must keep only the first.
module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx1100"} {

// CHECK-LABEL: func.func @vscnt_dedupe
// CHECK: waveamdmachine.global_store_b32
// CHECK: waveamdmachine.imm 0
// CHECK-NEXT: waveamdmachine.s_waitcnt_vscnt
// CHECK-NEXT: waveamdmachine.s_endpgm
// CHECK-NOT: waveamdmachine.s_waitcnt_vscnt
// CHECK: waveamdmachine.s_endpgm
func.func @vscnt_dedupe(%off: !waveamdmachine.reg<vgpr, 1>, %val: !waveamdmachine.reg<vgpr, 1>, %base: !waveamdmachine.reg<sgpr, 2>) {
  waveamdmachine.global_store_b32 %off, %val, %base : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<sgpr, 2>) -> ()
  waveamdmachine.s_endpgm
  waveamdmachine.s_endpgm
  return
}

}
