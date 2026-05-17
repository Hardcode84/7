// RUN: wave-opt --waveamd-insert-ticket-waits -split-input-file %s | FileCheck %s

module attributes {wavemachine.target = "amdgcn-amd-amdhsa--gfx1100"} {

// CHECK-LABEL: func.func @lgkm_nonzero_distance
// CHECK: wavemachine.s_load_b32
// CHECK: wavemachine.s_load_b32
// CHECK: wavemachine.imm 64535
// CHECK-NEXT: wavemachine.s_waitcnt
// CHECK-NEXT: wavemachine.v_add_u32
func.func @lgkm_nonzero_distance(%x: !wavemachine.reg<vgpr, 1>) {
  %zero = wavemachine.imm 0 : !wavemachine.imm
  %a = wavemachine.s_load_b32 %zero, "s[0:1]" : (!wavemachine.imm) -> !wavemachine.reg<sgpr, 1>
  %b = wavemachine.s_load_b32 %zero, "s[0:1]" : (!wavemachine.imm) -> !wavemachine.reg<sgpr, 1>
  %sum = wavemachine.v_add_u32 %x, %a : (!wavemachine.reg<vgpr, 1>, !wavemachine.reg<sgpr, 1>) -> !wavemachine.reg<vgpr, 1>
  return
}

}

// -----

module attributes {wavemachine.target = "amdgcn-amd-amdhsa--gfx1100"} {

// CHECK-LABEL: func.func @store_uses_vscnt
// CHECK: wavemachine.global_store_b32
// CHECK: wavemachine.imm 0
// CHECK-NEXT: wavemachine.s_waitcnt_vscnt
// CHECK-NEXT: wavemachine.s_endpgm
func.func @store_uses_vscnt(%offset: !wavemachine.reg<vgpr, 1>, %value: !wavemachine.reg<vgpr, 1>, %base: !wavemachine.reg<sgpr, 2>) {
  wavemachine.global_store_b32 %offset, %value, %base : (!wavemachine.reg<vgpr, 1>, !wavemachine.reg<vgpr, 1>, !wavemachine.reg<sgpr, 2>) -> ()
  wavemachine.s_endpgm
  return
}

}

// -----

module attributes {wavemachine.target = "amdgcn-amd-amdhsa--gfx1100"} {

// CHECK-LABEL: func.func @existing_wait_satisfies_use
// CHECK: wavemachine.s_waitcnt
// CHECK-NOT: wavemachine.s_waitcnt
// CHECK: wavemachine.v_add_u32
func.func @existing_wait_satisfies_use(%x: !wavemachine.reg<vgpr, 1>) {
  %zero = wavemachine.imm 0 : !wavemachine.imm
  %a = wavemachine.s_load_b32 %zero, "s[0:1]" : (!wavemachine.imm) -> !wavemachine.reg<sgpr, 1>
  %wait = wavemachine.imm 64519 : !wavemachine.imm
  wavemachine.s_waitcnt %wait : (!wavemachine.imm) -> ()
  %sum = wavemachine.v_add_u32 %x, %a : (!wavemachine.reg<vgpr, 1>, !wavemachine.reg<sgpr, 1>) -> !wavemachine.reg<vgpr, 1>
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
module attributes {wavemachine.target = "amdgcn-amd-amdhsa--gfx1100"} {

// CHECK-LABEL: func.func @overlap_two_tuple_loads
// CHECK: wavemachine.global_load_tuple_b32
// CHECK-NEXT: wavemachine.global_load_tuple_b32
// CHECK-NEXT: wavemachine.imm 9207
// CHECK-NEXT: wavemachine.s_waitcnt
// CHECK-NEXT: wavemachine.ds_store_tuple_b32
// CHECK-NEXT: wavemachine.imm 1015
// CHECK-NEXT: wavemachine.s_waitcnt
// CHECK-NEXT: wavemachine.ds_store_tuple_b32
func.func @overlap_two_tuple_loads(%a_off: !wavemachine.reg<vgpr, 1>,
                                   %a_base: !wavemachine.reg<sgpr, 2>,
                                   %b_off: !wavemachine.reg<vgpr, 1>,
                                   %b_base: !wavemachine.reg<sgpr, 2>,
                                   %lds_a: !wavemachine.reg<vgpr, 1>,
                                   %lds_b: !wavemachine.reg<vgpr, 1>) {
  %a_regs, %a_tok = wavemachine.global_load_tuple_b32 %a_off, %a_base : (!wavemachine.reg<vgpr, 1>, !wavemachine.reg<sgpr, 2>) -> (!wavemachine.reg<vgpr, 8>, !wavemachine.mem.token)
  %b_regs, %b_tok = wavemachine.global_load_tuple_b32 %b_off, %b_base : (!wavemachine.reg<vgpr, 1>, !wavemachine.reg<sgpr, 2>) -> (!wavemachine.reg<vgpr, 8>, !wavemachine.mem.token)
  %a_st = wavemachine.ds_store_tuple_b32 %lds_a, %a_regs after %a_tok : (!wavemachine.reg<vgpr, 1>, !wavemachine.reg<vgpr, 8>, !wavemachine.mem.token) -> !wavemachine.mem.token
  %b_st = wavemachine.ds_store_tuple_b32 %lds_b, %b_regs after %b_tok : (!wavemachine.reg<vgpr, 1>, !wavemachine.reg<vgpr, 8>, !wavemachine.mem.token) -> !wavemachine.mem.token
  return
}

}

// -----

// Two consumers of the same `s_load_b32` both demand `lgkmcnt(0)`,
// but the second is redundant because the pass already emitted the
// drain for the first and no new LGKM issue happened in between.
// The post-emission cleanup must collapse the run.
module attributes {wavemachine.target = "amdgcn-amd-amdhsa--gfx1100"} {

// CHECK-LABEL: func.func @consecutive_consumers_dedupe_lgkm
// CHECK: wavemachine.s_load_b32
// CHECK: wavemachine.imm 64519
// CHECK-NEXT: wavemachine.s_waitcnt
// CHECK-NEXT: wavemachine.v_add_u32
// CHECK-NOT: wavemachine.s_waitcnt
// CHECK: wavemachine.v_add_u32
// CHECK-NOT: wavemachine.s_waitcnt
// CHECK: return
func.func @consecutive_consumers_dedupe_lgkm(%x: !wavemachine.reg<vgpr, 1>) {
  %zero = wavemachine.imm 0 : !wavemachine.imm
  %a = wavemachine.s_load_b32 %zero, "s[0:1]" : (!wavemachine.imm) -> !wavemachine.reg<sgpr, 1>
  %c = wavemachine.v_add_u32 %x, %a : (!wavemachine.reg<vgpr, 1>, !wavemachine.reg<sgpr, 1>) -> !wavemachine.reg<vgpr, 1>
  %d = wavemachine.v_add_u32 %c, %a : (!wavemachine.reg<vgpr, 1>, !wavemachine.reg<sgpr, 1>) -> !wavemachine.reg<vgpr, 1>
  return
}

}

// -----

// `s_waitcnt lgkmcnt(N)` (looser) is redundant when a tighter
// `lgkmcnt(0)` for the same outstanding queue is already in flight.
// In the WMMA matmul this manifests as `lgkmcnt(32)`/`lgkmcnt(34)`
// directly behind a `lgkmcnt(0)`; both must drop.
module attributes {wavemachine.target = "amdgcn-amd-amdhsa--gfx1100"} {

// CHECK-LABEL: func.func @tight_then_loose_collapses
// The first `s_load_b32` -> `v_add_u32` pair forces a `lgkmcnt(0)`
// drain. The chained `v_xor` keeps the consumer live and the trailing
// `v_add_u32` reuses the already-drained scalar load: the cleanup
// must drop the second `s_waitcnt` and the IR holds a single
// `imm 64519 + s_waitcnt` for the whole block.
// CHECK: wavemachine.s_load_b32
// CHECK: wavemachine.imm 64519
// CHECK-NEXT: wavemachine.s_waitcnt
// CHECK-NEXT: wavemachine.v_add_u32
// CHECK-NEXT: wavemachine.v_xor_b32
// CHECK-NOT: wavemachine.s_waitcnt
// CHECK: wavemachine.v_add_u32
// CHECK-NOT: wavemachine.s_waitcnt
// CHECK: return
func.func @tight_then_loose_collapses(%x: !wavemachine.reg<vgpr, 1>) {
  %zero = wavemachine.imm 0 : !wavemachine.imm
  %a = wavemachine.s_load_b32 %zero, "s[0:1]" : (!wavemachine.imm) -> !wavemachine.reg<sgpr, 1>
  %c = wavemachine.v_add_u32 %x, %a : (!wavemachine.reg<vgpr, 1>, !wavemachine.reg<sgpr, 1>) -> !wavemachine.reg<vgpr, 1>
  %d = wavemachine.v_xor_b32 %c, %a : (!wavemachine.reg<vgpr, 1>, !wavemachine.reg<sgpr, 1>) -> !wavemachine.reg<vgpr, 1>
  %e = wavemachine.v_add_u32 %d, %a : (!wavemachine.reg<vgpr, 1>, !wavemachine.reg<sgpr, 1>) -> !wavemachine.reg<vgpr, 1>
  return
}

}

// -----

// Two consumers of the same `global_store_b32` both demand a
// `vscnt(0)` drain (e.g., two `s_endpgm`-style flushes). The
// post-emission cleanup must keep only the first.
module attributes {wavemachine.target = "amdgcn-amd-amdhsa--gfx1100"} {

// CHECK-LABEL: func.func @vscnt_dedupe
// CHECK: wavemachine.global_store_b32
// CHECK: wavemachine.imm 0
// CHECK-NEXT: wavemachine.s_waitcnt_vscnt
// CHECK-NEXT: wavemachine.s_endpgm
// CHECK-NOT: wavemachine.s_waitcnt_vscnt
// CHECK: wavemachine.s_endpgm
func.func @vscnt_dedupe(%off: !wavemachine.reg<vgpr, 1>, %val: !wavemachine.reg<vgpr, 1>, %base: !wavemachine.reg<sgpr, 2>) {
  wavemachine.global_store_b32 %off, %val, %base : (!wavemachine.reg<vgpr, 1>, !wavemachine.reg<vgpr, 1>, !wavemachine.reg<sgpr, 2>) -> ()
  wavemachine.s_endpgm
  wavemachine.s_endpgm
  return
}

}
