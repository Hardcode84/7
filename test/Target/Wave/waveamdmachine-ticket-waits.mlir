// RUN: wave-opt --waveamd-insert-ticket-waits -split-input-file %s | FileCheck %s
// RUN: wave-opt --waveamd-insert-ticket-waits -split-input-file %s | wave-opt -split-input-file | FileCheck %s

module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx1100"} {

// CHECK-LABEL: func.func @ds_swizzle_is_lgkm_issuer
// CHECK: waveamdmachine.ds_swizzle_b32
// CHECK-NEXT: waveamdmachine.ds_swizzle_b32
// CHECK-NEXT: waveamdmachine.s_waitcnt lgkmcnt(1)
// CHECK-NEXT: waveamdmachine.v_add_u32
func.func @ds_swizzle_is_lgkm_issuer(%x: !waveamdmachine.reg<vgpr, 1>) {
  %a = waveamdmachine.ds_swizzle_b32 %x offset 31
      : (!waveamdmachine.reg<vgpr, 1>) -> !waveamdmachine.reg<vgpr, 1>
  %b = waveamdmachine.ds_swizzle_b32 %x offset 31
      : (!waveamdmachine.reg<vgpr, 1>) -> !waveamdmachine.reg<vgpr, 1>
  %sum = waveamdmachine.v_add_u32 %x, %a
      : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>) -> !waveamdmachine.reg<vgpr, 1>
  return
}

// CHECK-LABEL: func.func @ds_permute_is_lgkm_issuer
// CHECK: waveamdmachine.ds_permute_b32
// CHECK-NEXT: waveamdmachine.ds_permute_b32
// CHECK-NEXT: waveamdmachine.s_waitcnt lgkmcnt(1)
// CHECK-NEXT: waveamdmachine.v_add_u32
func.func @ds_permute_is_lgkm_issuer(%x: !waveamdmachine.reg<vgpr, 1>,
                                     %y: !waveamdmachine.reg<vgpr, 1>) {
  %a = waveamdmachine.ds_permute_b32 %x, %y offset 4
      : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>) -> !waveamdmachine.reg<vgpr, 1>
  %b = waveamdmachine.ds_permute_b32 %x, %y offset 4
      : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>) -> !waveamdmachine.reg<vgpr, 1>
  %sum = waveamdmachine.v_add_u32 %x, %a
      : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>) -> !waveamdmachine.reg<vgpr, 1>
  return
}

// CHECK-LABEL: func.func @ds_bpermute_is_lgkm_issuer
// CHECK: waveamdmachine.ds_bpermute_b32
// CHECK-NEXT: waveamdmachine.ds_bpermute_b32
// CHECK-NEXT: waveamdmachine.s_waitcnt lgkmcnt(1)
// CHECK-NEXT: waveamdmachine.v_add_u32
func.func @ds_bpermute_is_lgkm_issuer(%x: !waveamdmachine.reg<vgpr, 1>,
                                      %y: !waveamdmachine.reg<vgpr, 1>) {
  %a = waveamdmachine.ds_bpermute_b32 %x, %y offset 8
      : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>) -> !waveamdmachine.reg<vgpr, 1>
  %b = waveamdmachine.ds_bpermute_b32 %x, %y offset 8
      : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>) -> !waveamdmachine.reg<vgpr, 1>
  %sum = waveamdmachine.v_add_u32 %x, %a
      : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>) -> !waveamdmachine.reg<vgpr, 1>
  return
}

// CHECK-LABEL: func.func @lds_nonzero_distance
// CHECK: waveamdmachine.ds_load_b32
// CHECK: waveamdmachine.ds_load_b32
// CHECK: waveamdmachine.s_waitcnt lgkmcnt(1)
// CHECK-NEXT: waveamdmachine.v_add_u32
func.func @lds_nonzero_distance(%x: !waveamdmachine.reg<vgpr, 1>) {
  %a = waveamdmachine.ds_load_b32 %x : (!waveamdmachine.reg<vgpr, 1>) -> !waveamdmachine.reg<vgpr, 1>
  %b = waveamdmachine.ds_load_b32 %x : (!waveamdmachine.reg<vgpr, 1>) -> !waveamdmachine.reg<vgpr, 1>
  %sum = waveamdmachine.v_add_u32 %x, %a : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>) -> !waveamdmachine.reg<vgpr, 1>
  return
}

// CHECK-LABEL: func.func @lds_byte_loads_are_lgkm_issuers
// CHECK: waveamdmachine.ds_load_u8
// CHECK-NEXT: waveamdmachine.ds_load_i8
// CHECK-NEXT: waveamdmachine.s_waitcnt lgkmcnt(1)
// CHECK-NEXT: waveamdmachine.v_add_u32
func.func @lds_byte_loads_are_lgkm_issuers(%x: !waveamdmachine.reg<vgpr, 1>) {
  %a = waveamdmachine.ds_load_u8 %x : (!waveamdmachine.reg<vgpr, 1>) -> !waveamdmachine.reg<vgpr, 1>
  %b = waveamdmachine.ds_load_i8 %x : (!waveamdmachine.reg<vgpr, 1>) -> !waveamdmachine.reg<vgpr, 1>
  %sum = waveamdmachine.v_add_u32 %x, %a : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>) -> !waveamdmachine.reg<vgpr, 1>
  return
}

}

// -----

module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx1100"} {

// CHECK-LABEL: func.func @mixed_lgkm_events_clamp_zero
// CHECK: waveamdmachine.ds_load_b32
// CHECK: waveamdmachine.s_load_b32
// CHECK: waveamdmachine.s_waitcnt lgkmcnt(0)
// CHECK-NEXT: waveamdmachine.v_add_u32
func.func @mixed_lgkm_events_clamp_zero(%x: !waveamdmachine.reg<vgpr, 1>) {
  %zero = waveamdmachine.imm 0 : !waveamdmachine.imm
  %lds = waveamdmachine.ds_load_b32 %x : (!waveamdmachine.reg<vgpr, 1>) -> !waveamdmachine.reg<vgpr, 1>
  %smem = waveamdmachine.s_load_b32 %zero, "s[0:1]" : (!waveamdmachine.imm) -> !waveamdmachine.reg<sgpr, 1>
  %sum = waveamdmachine.v_add_u32 %x, %lds : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>) -> !waveamdmachine.reg<vgpr, 1>
  return
}

// CHECK-LABEL: func.func @bit_count_consumes_smem
// CHECK: waveamdmachine.s_load_b32
// CHECK-NEXT: waveamdmachine.s_waitcnt lgkmcnt(0)
// CHECK-NEXT: waveamdmachine.s_flbit_i32_b32
// CHECK-NEXT: waveamdmachine.v_ffbl_b32
func.func @bit_count_consumes_smem() {
  %zero = waveamdmachine.imm 0 : !waveamdmachine.imm
  %loaded = waveamdmachine.s_load_b32 %zero, "s[0:1]"
      : (!waveamdmachine.imm) -> !waveamdmachine.reg<sgpr, 1>
  %s = waveamdmachine.s_flbit_i32_b32 %loaded
      : (!waveamdmachine.reg<sgpr, 1>) -> !waveamdmachine.reg<sgpr, 1>
  %v = waveamdmachine.v_ffbl_b32 %loaded
      : (!waveamdmachine.reg<sgpr, 1>) -> !waveamdmachine.reg<vgpr, 1>
  return
}

}

// -----

module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx950"} {

// CHECK-LABEL: func.func @gfx950_ds_byte_and_transpose_are_lgkm_issuers
// CHECK: waveamdmachine.ds_store_b8
// CHECK: waveamdmachine.s_waitcnt lgkmcnt(0)
// CHECK-NEXT: waveamdmachine.wait
// CHECK: waveamdmachine.ds_read_tr_b64_b4
// CHECK-NEXT: waveamdmachine.ds_read_tr_b64_b8
// CHECK: waveamdmachine.s_waitcnt lgkmcnt(1)
// CHECK-NEXT: waveamdmachine.v_add_u32
func.func @gfx950_ds_byte_and_transpose_are_lgkm_issuers(%x: !waveamdmachine.reg<vgpr, 1>) {
  %store = waveamdmachine.ds_store_b8 %x, %x
      : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>)
        -> !waveamdmachine.mem.token
  waveamdmachine.wait %store : (!waveamdmachine.mem.token) -> ()
  %b4, %tok4 = waveamdmachine.ds_read_tr_b64_b4 %x
      : (!waveamdmachine.reg<vgpr, 1>)
        -> (!waveamdmachine.reg<vgpr, 2>, !waveamdmachine.mem.token)
  %b8, %tok8 = waveamdmachine.ds_read_tr_b64_b8 %x
      : (!waveamdmachine.reg<vgpr, 1>)
        -> (!waveamdmachine.reg<vgpr, 2>, !waveamdmachine.mem.token)
  %lo, %hi = waveamdmachine.tuple_to_elements %b4
      : (!waveamdmachine.reg<vgpr, 2>)
        -> (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>)
  %sum = waveamdmachine.v_add_u32 %x, %lo
      : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>)
        -> !waveamdmachine.reg<vgpr, 1>
  return
}

}

// -----

module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx1100"} {

// CHECK-LABEL: func.func @existing_nonzero_smem_wait_not_sufficient
// CHECK: waveamdmachine.s_load_b32
// CHECK: waveamdmachine.s_load_b32
// CHECK: waveamdmachine.s_waitcnt lgkmcnt(1)
// CHECK-NEXT: waveamdmachine.s_waitcnt lgkmcnt(0)
// CHECK-NEXT: waveamdmachine.v_add_u32
func.func @existing_nonzero_smem_wait_not_sufficient(%x: !waveamdmachine.reg<vgpr, 1>) {
  %zero = waveamdmachine.imm 0 : !waveamdmachine.imm
  %a = waveamdmachine.s_load_b32 %zero, "s[0:1]" : (!waveamdmachine.imm) -> !waveamdmachine.reg<sgpr, 1>
  %b = waveamdmachine.s_load_b32 %zero, "s[0:1]" : (!waveamdmachine.imm) -> !waveamdmachine.reg<sgpr, 1>
  waveamdmachine.s_waitcnt lgkmcnt(1)
  %sum = waveamdmachine.v_add_u32 %x, %a : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<sgpr, 1>) -> !waveamdmachine.reg<vgpr, 1>
  return
}

}

// -----

module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx1100"} {

// CHECK-LABEL: func.func @store_uses_vscnt
// CHECK: waveamdmachine.global_store_b32
// CHECK: waveamdmachine.s_waitcnt_vscnt vscnt(0)
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
  waveamdmachine.s_waitcnt lgkmcnt(0)
  %sum = waveamdmachine.v_add_u32 %x, %a : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<sgpr, 1>) -> !waveamdmachine.reg<vgpr, 1>
  return
}

}

// -----

// Post-decompose width-8 tuple shape: two b128 chunks per logical
// tuple. First LDS store waits at `vmcnt(2)` and leaves the second
// tuple's two chunks in flight.
module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx1100"} {

// CHECK-LABEL: func.func @overlap_two_chunked_loads
// CHECK: waveamdmachine.global_load_b128
// CHECK-NEXT: waveamdmachine.global_load_b128
// CHECK-NEXT: waveamdmachine.global_load_b128
// CHECK-NEXT: waveamdmachine.global_load_b128
// CHECK-NEXT: waveamdmachine.token_join
// CHECK-NEXT: waveamdmachine.token_join
// CHECK-NEXT: waveamdmachine.s_waitcnt vmcnt(2)
// CHECK-NEXT: waveamdmachine.ds_store_b128
// CHECK-NEXT: waveamdmachine.ds_store_b128
// CHECK-NEXT: waveamdmachine.s_waitcnt vmcnt(0)
// CHECK-NEXT: waveamdmachine.ds_store_b128
// CHECK-NEXT: waveamdmachine.ds_store_b128
func.func @overlap_two_chunked_loads(%a_off: !waveamdmachine.reg<vgpr, 1>,
                                     %a_base: !waveamdmachine.reg<sgpr, 2>,
                                     %b_off: !waveamdmachine.reg<vgpr, 1>,
                                     %b_base: !waveamdmachine.reg<sgpr, 2>,
                                     %lds_a: !waveamdmachine.reg<vgpr, 1>,
                                     %lds_b: !waveamdmachine.reg<vgpr, 1>) {
  %a0, %a_t0 = waveamdmachine.global_load_b128 %a_off, %a_base
      : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<sgpr, 2>)
        -> (!waveamdmachine.reg<vgpr, 4>, !waveamdmachine.mem.token)
  %a1, %a_t1 = waveamdmachine.global_load_b128 %a_off, %a_base offset 16
      : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<sgpr, 2>)
        -> (!waveamdmachine.reg<vgpr, 4>, !waveamdmachine.mem.token)
  %b0, %b_t0 = waveamdmachine.global_load_b128 %b_off, %b_base
      : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<sgpr, 2>)
        -> (!waveamdmachine.reg<vgpr, 4>, !waveamdmachine.mem.token)
  %b1, %b_t1 = waveamdmachine.global_load_b128 %b_off, %b_base offset 16
      : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<sgpr, 2>)
        -> (!waveamdmachine.reg<vgpr, 4>, !waveamdmachine.mem.token)
  %a_tok = waveamdmachine.token_join %a_t0, %a_t1
      : (!waveamdmachine.mem.token, !waveamdmachine.mem.token)
        -> !waveamdmachine.mem.token
  %b_tok = waveamdmachine.token_join %b_t0, %b_t1
      : (!waveamdmachine.mem.token, !waveamdmachine.mem.token)
        -> !waveamdmachine.mem.token
  %a_s0 = waveamdmachine.ds_store_b128 %lds_a, %a0 after %a_tok
      : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 4>,
         !waveamdmachine.mem.token) -> !waveamdmachine.mem.token
  %a_s1 = waveamdmachine.ds_store_b128 %lds_a, %a1 after %a_tok offset 16
      : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 4>,
         !waveamdmachine.mem.token) -> !waveamdmachine.mem.token
  %b_s0 = waveamdmachine.ds_store_b128 %lds_b, %b0 after %b_tok
      : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 4>,
         !waveamdmachine.mem.token) -> !waveamdmachine.mem.token
  %b_s1 = waveamdmachine.ds_store_b128 %lds_b, %b1 after %b_tok offset 16
      : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 4>,
         !waveamdmachine.mem.token) -> !waveamdmachine.mem.token
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
// CHECK: waveamdmachine.s_waitcnt lgkmcnt(0)
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
// one `lgkmcnt(0)` wait for the whole block.
// CHECK: waveamdmachine.s_load_b32
// CHECK: waveamdmachine.s_waitcnt lgkmcnt(0)
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
// CHECK: waveamdmachine.s_waitcnt_vscnt vscnt(0)
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

// -----

module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx950"} {

// CHECK-LABEL: func.func @saturated_lgkmcnt_requirement_is_clamped
// CHECK: waveamdmachine.ds_swizzle_b32
// CHECK: waveamdmachine.s_waitcnt lgkmcnt(14)
// CHECK-NEXT: waveamdmachine.v_add_u32
func.func @saturated_lgkmcnt_requirement_is_clamped(
    %x: !waveamdmachine.reg<vgpr, 1>) {
  %a0 = waveamdmachine.ds_swizzle_b32 %x offset 31
      : (!waveamdmachine.reg<vgpr, 1>) -> !waveamdmachine.reg<vgpr, 1>
  %a1 = waveamdmachine.ds_swizzle_b32 %x offset 31
      : (!waveamdmachine.reg<vgpr, 1>) -> !waveamdmachine.reg<vgpr, 1>
  %a2 = waveamdmachine.ds_swizzle_b32 %x offset 31
      : (!waveamdmachine.reg<vgpr, 1>) -> !waveamdmachine.reg<vgpr, 1>
  %a3 = waveamdmachine.ds_swizzle_b32 %x offset 31
      : (!waveamdmachine.reg<vgpr, 1>) -> !waveamdmachine.reg<vgpr, 1>
  %a4 = waveamdmachine.ds_swizzle_b32 %x offset 31
      : (!waveamdmachine.reg<vgpr, 1>) -> !waveamdmachine.reg<vgpr, 1>
  %a5 = waveamdmachine.ds_swizzle_b32 %x offset 31
      : (!waveamdmachine.reg<vgpr, 1>) -> !waveamdmachine.reg<vgpr, 1>
  %a6 = waveamdmachine.ds_swizzle_b32 %x offset 31
      : (!waveamdmachine.reg<vgpr, 1>) -> !waveamdmachine.reg<vgpr, 1>
  %a7 = waveamdmachine.ds_swizzle_b32 %x offset 31
      : (!waveamdmachine.reg<vgpr, 1>) -> !waveamdmachine.reg<vgpr, 1>
  %a8 = waveamdmachine.ds_swizzle_b32 %x offset 31
      : (!waveamdmachine.reg<vgpr, 1>) -> !waveamdmachine.reg<vgpr, 1>
  %a9 = waveamdmachine.ds_swizzle_b32 %x offset 31
      : (!waveamdmachine.reg<vgpr, 1>) -> !waveamdmachine.reg<vgpr, 1>
  %a10 = waveamdmachine.ds_swizzle_b32 %x offset 31
      : (!waveamdmachine.reg<vgpr, 1>) -> !waveamdmachine.reg<vgpr, 1>
  %a11 = waveamdmachine.ds_swizzle_b32 %x offset 31
      : (!waveamdmachine.reg<vgpr, 1>) -> !waveamdmachine.reg<vgpr, 1>
  %a12 = waveamdmachine.ds_swizzle_b32 %x offset 31
      : (!waveamdmachine.reg<vgpr, 1>) -> !waveamdmachine.reg<vgpr, 1>
  %a13 = waveamdmachine.ds_swizzle_b32 %x offset 31
      : (!waveamdmachine.reg<vgpr, 1>) -> !waveamdmachine.reg<vgpr, 1>
  %a14 = waveamdmachine.ds_swizzle_b32 %x offset 31
      : (!waveamdmachine.reg<vgpr, 1>) -> !waveamdmachine.reg<vgpr, 1>
  %a15 = waveamdmachine.ds_swizzle_b32 %x offset 31
      : (!waveamdmachine.reg<vgpr, 1>) -> !waveamdmachine.reg<vgpr, 1>
  %a16 = waveamdmachine.ds_swizzle_b32 %x offset 31
      : (!waveamdmachine.reg<vgpr, 1>) -> !waveamdmachine.reg<vgpr, 1>
  %sum = waveamdmachine.v_add_u32 %x, %a0
      : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>)
        -> !waveamdmachine.reg<vgpr, 1>
  return
}

}

// -----

module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx1100"} {

// CHECK-LABEL: func.func @saturated_vmcnt_requirement_is_clamped
// CHECK: waveamdmachine.buffer_load_b32
// CHECK: waveamdmachine.s_waitcnt vmcnt(62)
// CHECK-NEXT: waveamdmachine.v_add_u32
func.func @saturated_vmcnt_requirement_is_clamped(
    %off: !waveamdmachine.reg<vgpr, 1>,
    %desc: !waveamdmachine.reg<sgpr, 4>,
    %zero: !waveamdmachine.reg<sgpr, 1>) {
  %v0, %tok0 = waveamdmachine.buffer_load_b32 %off, %desc, %zero
      : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<sgpr, 4>,
         !waveamdmachine.reg<sgpr, 1>)
        -> (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.mem.token)
  %v1, %tok1 = waveamdmachine.buffer_load_b32 %off, %desc, %zero
      : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<sgpr, 4>,
         !waveamdmachine.reg<sgpr, 1>)
        -> (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.mem.token)
  %v2, %tok2 = waveamdmachine.buffer_load_b32 %off, %desc, %zero
      : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<sgpr, 4>,
         !waveamdmachine.reg<sgpr, 1>)
        -> (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.mem.token)
  %v3, %tok3 = waveamdmachine.buffer_load_b32 %off, %desc, %zero
      : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<sgpr, 4>,
         !waveamdmachine.reg<sgpr, 1>)
        -> (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.mem.token)
  %v4, %tok4 = waveamdmachine.buffer_load_b32 %off, %desc, %zero
      : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<sgpr, 4>,
         !waveamdmachine.reg<sgpr, 1>)
        -> (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.mem.token)
  %v5, %tok5 = waveamdmachine.buffer_load_b32 %off, %desc, %zero
      : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<sgpr, 4>,
         !waveamdmachine.reg<sgpr, 1>)
        -> (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.mem.token)
  %v6, %tok6 = waveamdmachine.buffer_load_b32 %off, %desc, %zero
      : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<sgpr, 4>,
         !waveamdmachine.reg<sgpr, 1>)
        -> (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.mem.token)
  %v7, %tok7 = waveamdmachine.buffer_load_b32 %off, %desc, %zero
      : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<sgpr, 4>,
         !waveamdmachine.reg<sgpr, 1>)
        -> (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.mem.token)
  %v8, %tok8 = waveamdmachine.buffer_load_b32 %off, %desc, %zero
      : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<sgpr, 4>,
         !waveamdmachine.reg<sgpr, 1>)
        -> (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.mem.token)
  %v9, %tok9 = waveamdmachine.buffer_load_b32 %off, %desc, %zero
      : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<sgpr, 4>,
         !waveamdmachine.reg<sgpr, 1>)
        -> (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.mem.token)
  %v10, %tok10 = waveamdmachine.buffer_load_b32 %off, %desc, %zero
      : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<sgpr, 4>,
         !waveamdmachine.reg<sgpr, 1>)
        -> (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.mem.token)
  %v11, %tok11 = waveamdmachine.buffer_load_b32 %off, %desc, %zero
      : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<sgpr, 4>,
         !waveamdmachine.reg<sgpr, 1>)
        -> (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.mem.token)
  %v12, %tok12 = waveamdmachine.buffer_load_b32 %off, %desc, %zero
      : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<sgpr, 4>,
         !waveamdmachine.reg<sgpr, 1>)
        -> (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.mem.token)
  %v13, %tok13 = waveamdmachine.buffer_load_b32 %off, %desc, %zero
      : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<sgpr, 4>,
         !waveamdmachine.reg<sgpr, 1>)
        -> (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.mem.token)
  %v14, %tok14 = waveamdmachine.buffer_load_b32 %off, %desc, %zero
      : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<sgpr, 4>,
         !waveamdmachine.reg<sgpr, 1>)
        -> (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.mem.token)
  %v15, %tok15 = waveamdmachine.buffer_load_b32 %off, %desc, %zero
      : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<sgpr, 4>,
         !waveamdmachine.reg<sgpr, 1>)
        -> (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.mem.token)
  %v16, %tok16 = waveamdmachine.buffer_load_b32 %off, %desc, %zero
      : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<sgpr, 4>,
         !waveamdmachine.reg<sgpr, 1>)
        -> (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.mem.token)
  %v17, %tok17 = waveamdmachine.buffer_load_b32 %off, %desc, %zero
      : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<sgpr, 4>,
         !waveamdmachine.reg<sgpr, 1>)
        -> (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.mem.token)
  %v18, %tok18 = waveamdmachine.buffer_load_b32 %off, %desc, %zero
      : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<sgpr, 4>,
         !waveamdmachine.reg<sgpr, 1>)
        -> (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.mem.token)
  %v19, %tok19 = waveamdmachine.buffer_load_b32 %off, %desc, %zero
      : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<sgpr, 4>,
         !waveamdmachine.reg<sgpr, 1>)
        -> (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.mem.token)
  %v20, %tok20 = waveamdmachine.buffer_load_b32 %off, %desc, %zero
      : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<sgpr, 4>,
         !waveamdmachine.reg<sgpr, 1>)
        -> (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.mem.token)
  %v21, %tok21 = waveamdmachine.buffer_load_b32 %off, %desc, %zero
      : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<sgpr, 4>,
         !waveamdmachine.reg<sgpr, 1>)
        -> (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.mem.token)
  %v22, %tok22 = waveamdmachine.buffer_load_b32 %off, %desc, %zero
      : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<sgpr, 4>,
         !waveamdmachine.reg<sgpr, 1>)
        -> (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.mem.token)
  %v23, %tok23 = waveamdmachine.buffer_load_b32 %off, %desc, %zero
      : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<sgpr, 4>,
         !waveamdmachine.reg<sgpr, 1>)
        -> (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.mem.token)
  %v24, %tok24 = waveamdmachine.buffer_load_b32 %off, %desc, %zero
      : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<sgpr, 4>,
         !waveamdmachine.reg<sgpr, 1>)
        -> (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.mem.token)
  %v25, %tok25 = waveamdmachine.buffer_load_b32 %off, %desc, %zero
      : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<sgpr, 4>,
         !waveamdmachine.reg<sgpr, 1>)
        -> (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.mem.token)
  %v26, %tok26 = waveamdmachine.buffer_load_b32 %off, %desc, %zero
      : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<sgpr, 4>,
         !waveamdmachine.reg<sgpr, 1>)
        -> (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.mem.token)
  %v27, %tok27 = waveamdmachine.buffer_load_b32 %off, %desc, %zero
      : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<sgpr, 4>,
         !waveamdmachine.reg<sgpr, 1>)
        -> (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.mem.token)
  %v28, %tok28 = waveamdmachine.buffer_load_b32 %off, %desc, %zero
      : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<sgpr, 4>,
         !waveamdmachine.reg<sgpr, 1>)
        -> (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.mem.token)
  %v29, %tok29 = waveamdmachine.buffer_load_b32 %off, %desc, %zero
      : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<sgpr, 4>,
         !waveamdmachine.reg<sgpr, 1>)
        -> (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.mem.token)
  %v30, %tok30 = waveamdmachine.buffer_load_b32 %off, %desc, %zero
      : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<sgpr, 4>,
         !waveamdmachine.reg<sgpr, 1>)
        -> (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.mem.token)
  %v31, %tok31 = waveamdmachine.buffer_load_b32 %off, %desc, %zero
      : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<sgpr, 4>,
         !waveamdmachine.reg<sgpr, 1>)
        -> (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.mem.token)
  %v32, %tok32 = waveamdmachine.buffer_load_b32 %off, %desc, %zero
      : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<sgpr, 4>,
         !waveamdmachine.reg<sgpr, 1>)
        -> (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.mem.token)
  %v33, %tok33 = waveamdmachine.buffer_load_b32 %off, %desc, %zero
      : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<sgpr, 4>,
         !waveamdmachine.reg<sgpr, 1>)
        -> (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.mem.token)
  %v34, %tok34 = waveamdmachine.buffer_load_b32 %off, %desc, %zero
      : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<sgpr, 4>,
         !waveamdmachine.reg<sgpr, 1>)
        -> (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.mem.token)
  %v35, %tok35 = waveamdmachine.buffer_load_b32 %off, %desc, %zero
      : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<sgpr, 4>,
         !waveamdmachine.reg<sgpr, 1>)
        -> (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.mem.token)
  %v36, %tok36 = waveamdmachine.buffer_load_b32 %off, %desc, %zero
      : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<sgpr, 4>,
         !waveamdmachine.reg<sgpr, 1>)
        -> (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.mem.token)
  %v37, %tok37 = waveamdmachine.buffer_load_b32 %off, %desc, %zero
      : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<sgpr, 4>,
         !waveamdmachine.reg<sgpr, 1>)
        -> (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.mem.token)
  %v38, %tok38 = waveamdmachine.buffer_load_b32 %off, %desc, %zero
      : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<sgpr, 4>,
         !waveamdmachine.reg<sgpr, 1>)
        -> (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.mem.token)
  %v39, %tok39 = waveamdmachine.buffer_load_b32 %off, %desc, %zero
      : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<sgpr, 4>,
         !waveamdmachine.reg<sgpr, 1>)
        -> (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.mem.token)
  %v40, %tok40 = waveamdmachine.buffer_load_b32 %off, %desc, %zero
      : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<sgpr, 4>,
         !waveamdmachine.reg<sgpr, 1>)
        -> (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.mem.token)
  %v41, %tok41 = waveamdmachine.buffer_load_b32 %off, %desc, %zero
      : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<sgpr, 4>,
         !waveamdmachine.reg<sgpr, 1>)
        -> (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.mem.token)
  %v42, %tok42 = waveamdmachine.buffer_load_b32 %off, %desc, %zero
      : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<sgpr, 4>,
         !waveamdmachine.reg<sgpr, 1>)
        -> (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.mem.token)
  %v43, %tok43 = waveamdmachine.buffer_load_b32 %off, %desc, %zero
      : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<sgpr, 4>,
         !waveamdmachine.reg<sgpr, 1>)
        -> (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.mem.token)
  %v44, %tok44 = waveamdmachine.buffer_load_b32 %off, %desc, %zero
      : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<sgpr, 4>,
         !waveamdmachine.reg<sgpr, 1>)
        -> (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.mem.token)
  %v45, %tok45 = waveamdmachine.buffer_load_b32 %off, %desc, %zero
      : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<sgpr, 4>,
         !waveamdmachine.reg<sgpr, 1>)
        -> (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.mem.token)
  %v46, %tok46 = waveamdmachine.buffer_load_b32 %off, %desc, %zero
      : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<sgpr, 4>,
         !waveamdmachine.reg<sgpr, 1>)
        -> (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.mem.token)
  %v47, %tok47 = waveamdmachine.buffer_load_b32 %off, %desc, %zero
      : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<sgpr, 4>,
         !waveamdmachine.reg<sgpr, 1>)
        -> (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.mem.token)
  %v48, %tok48 = waveamdmachine.buffer_load_b32 %off, %desc, %zero
      : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<sgpr, 4>,
         !waveamdmachine.reg<sgpr, 1>)
        -> (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.mem.token)
  %v49, %tok49 = waveamdmachine.buffer_load_b32 %off, %desc, %zero
      : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<sgpr, 4>,
         !waveamdmachine.reg<sgpr, 1>)
        -> (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.mem.token)
  %v50, %tok50 = waveamdmachine.buffer_load_b32 %off, %desc, %zero
      : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<sgpr, 4>,
         !waveamdmachine.reg<sgpr, 1>)
        -> (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.mem.token)
  %v51, %tok51 = waveamdmachine.buffer_load_b32 %off, %desc, %zero
      : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<sgpr, 4>,
         !waveamdmachine.reg<sgpr, 1>)
        -> (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.mem.token)
  %v52, %tok52 = waveamdmachine.buffer_load_b32 %off, %desc, %zero
      : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<sgpr, 4>,
         !waveamdmachine.reg<sgpr, 1>)
        -> (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.mem.token)
  %v53, %tok53 = waveamdmachine.buffer_load_b32 %off, %desc, %zero
      : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<sgpr, 4>,
         !waveamdmachine.reg<sgpr, 1>)
        -> (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.mem.token)
  %v54, %tok54 = waveamdmachine.buffer_load_b32 %off, %desc, %zero
      : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<sgpr, 4>,
         !waveamdmachine.reg<sgpr, 1>)
        -> (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.mem.token)
  %v55, %tok55 = waveamdmachine.buffer_load_b32 %off, %desc, %zero
      : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<sgpr, 4>,
         !waveamdmachine.reg<sgpr, 1>)
        -> (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.mem.token)
  %v56, %tok56 = waveamdmachine.buffer_load_b32 %off, %desc, %zero
      : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<sgpr, 4>,
         !waveamdmachine.reg<sgpr, 1>)
        -> (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.mem.token)
  %v57, %tok57 = waveamdmachine.buffer_load_b32 %off, %desc, %zero
      : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<sgpr, 4>,
         !waveamdmachine.reg<sgpr, 1>)
        -> (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.mem.token)
  %v58, %tok58 = waveamdmachine.buffer_load_b32 %off, %desc, %zero
      : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<sgpr, 4>,
         !waveamdmachine.reg<sgpr, 1>)
        -> (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.mem.token)
  %v59, %tok59 = waveamdmachine.buffer_load_b32 %off, %desc, %zero
      : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<sgpr, 4>,
         !waveamdmachine.reg<sgpr, 1>)
        -> (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.mem.token)
  %v60, %tok60 = waveamdmachine.buffer_load_b32 %off, %desc, %zero
      : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<sgpr, 4>,
         !waveamdmachine.reg<sgpr, 1>)
        -> (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.mem.token)
  %v61, %tok61 = waveamdmachine.buffer_load_b32 %off, %desc, %zero
      : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<sgpr, 4>,
         !waveamdmachine.reg<sgpr, 1>)
        -> (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.mem.token)
  %v62, %tok62 = waveamdmachine.buffer_load_b32 %off, %desc, %zero
      : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<sgpr, 4>,
         !waveamdmachine.reg<sgpr, 1>)
        -> (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.mem.token)
  %v63, %tok63 = waveamdmachine.buffer_load_b32 %off, %desc, %zero
      : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<sgpr, 4>,
         !waveamdmachine.reg<sgpr, 1>)
        -> (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.mem.token)
  %sum = waveamdmachine.v_add_u32 %v0, %off
      : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>)
        -> !waveamdmachine.reg<vgpr, 1>
  return
}

}
