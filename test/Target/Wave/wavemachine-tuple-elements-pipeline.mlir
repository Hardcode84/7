// RUN: wave-opt --waveamd-insert-ticket-waits -split-input-file %s | FileCheck %s --check-prefix=WAIT
// RUN: wave-opt --waveamd-reg-alloc -split-input-file %s | FileCheck %s --check-prefix=REGALLOC

// Lit coverage for the post-decompose IR shape: N scalar loads +
// `tuple_from_elements` (data) + `token_join` (token); tuple
// consumer via the gather. Asserts (a) the waitcnt scoreboard
// propagates per-counter token state through the gather without
// draining at the rename point, and (b) the regalloc pins each
// scalar load result at the tuple's `phys + slot`.

module attributes {wavemachine.target = "amdgcn-amd-amdhsa--gfx1100"} {

// Whole-tuple consumer reads the gather result: waitcnt drains all
// four pending vmem issues right before the consumer fires. The
// gather itself is a token-only join and must not emit its own
// s_waitcnt (otherwise consumers would never get to run in parallel
// with later ALU ops).
//
// WAIT-LABEL: func.func @decomposed_load_gather_waitcnt
// WAIT: wavemachine.global_load_b32
// WAIT: wavemachine.global_load_b32
// WAIT: wavemachine.global_load_b32
// WAIT: wavemachine.global_load_b32
// WAIT-NOT: s_waitcnt
// WAIT: wavemachine.tuple_from_elements
// WAIT: wavemachine.imm 1015
// WAIT-NEXT: wavemachine.s_waitcnt
// WAIT-NEXT: wavemachine.v_mov_b32_tuple
func.func @decomposed_load_gather_waitcnt(%off: !wavemachine.reg<vgpr, 1>,
                                           %base: !wavemachine.reg<sgpr, 2>) {
  %v0, %t0 = wavemachine.global_load_b32 %off, %base : (!wavemachine.reg<vgpr, 1>, !wavemachine.reg<sgpr, 2>) -> (!wavemachine.reg<vgpr, 1>, !wavemachine.mem.token)
  %v1, %t1 = wavemachine.global_load_b32 %off, %base offset 4 : (!wavemachine.reg<vgpr, 1>, !wavemachine.reg<sgpr, 2>) -> (!wavemachine.reg<vgpr, 1>, !wavemachine.mem.token)
  %v2, %t2 = wavemachine.global_load_b32 %off, %base offset 8 : (!wavemachine.reg<vgpr, 1>, !wavemachine.reg<sgpr, 2>) -> (!wavemachine.reg<vgpr, 1>, !wavemachine.mem.token)
  %v3, %t3 = wavemachine.global_load_b32 %off, %base offset 12 : (!wavemachine.reg<vgpr, 1>, !wavemachine.reg<sgpr, 2>) -> (!wavemachine.reg<vgpr, 1>, !wavemachine.mem.token)
  %tuple = wavemachine.tuple_from_elements %v0, %v1, %v2, %v3
      : (!wavemachine.reg<vgpr, 1>, !wavemachine.reg<vgpr, 1>, !wavemachine.reg<vgpr, 1>, !wavemachine.reg<vgpr, 1>)
        -> !wavemachine.reg<vgpr, 4>
  %sink = wavemachine.v_mov_b32_tuple %tuple {registers = 4 : i64}
      : (!wavemachine.reg<vgpr, 4>) -> !wavemachine.reg<vgpr, 4>
  return
}

// Same shape, regalloc-side: the four scalar loads' VGPR1 results
// land at the gather tuple's base + slot. Width-4 alignment puts
// the block at v0..v3, so each scalar lands at v[i] verbatim.
//
// REGALLOC-LABEL: func.func @decomposed_load_gather_regalloc
// REGALLOC: %[[V0:.+]], %{{.+}} = wavemachine.global_load_b32 {{.*}} -> (!wavemachine.reg<vgpr, 1, 0>, !wavemachine.mem.token)
// REGALLOC: %[[V1:.+]], %{{.+}} = wavemachine.global_load_b32 {{.*}} -> (!wavemachine.reg<vgpr, 1, 1>, !wavemachine.mem.token)
// REGALLOC: %[[V2:.+]], %{{.+}} = wavemachine.global_load_b32 {{.*}} -> (!wavemachine.reg<vgpr, 1, 2>, !wavemachine.mem.token)
// REGALLOC: %[[V3:.+]], %{{.+}} = wavemachine.global_load_b32 {{.*}} -> (!wavemachine.reg<vgpr, 1, 3>, !wavemachine.mem.token)
// REGALLOC: %[[TUPLE:.+]] = wavemachine.tuple_from_elements %[[V0]], %[[V1]], %[[V2]], %[[V3]]
// REGALLOC-SAME: -> !wavemachine.reg<vgpr, 4, 0>
func.func @decomposed_load_gather_regalloc(%off: !wavemachine.reg<vgpr, 1>,
                                            %base: !wavemachine.reg<sgpr, 2>) {
  %v0, %t0 = wavemachine.global_load_b32 %off, %base : (!wavemachine.reg<vgpr, 1>, !wavemachine.reg<sgpr, 2>) -> (!wavemachine.reg<vgpr, 1>, !wavemachine.mem.token)
  %v1, %t1 = wavemachine.global_load_b32 %off, %base offset 4 : (!wavemachine.reg<vgpr, 1>, !wavemachine.reg<sgpr, 2>) -> (!wavemachine.reg<vgpr, 1>, !wavemachine.mem.token)
  %v2, %t2 = wavemachine.global_load_b32 %off, %base offset 8 : (!wavemachine.reg<vgpr, 1>, !wavemachine.reg<sgpr, 2>) -> (!wavemachine.reg<vgpr, 1>, !wavemachine.mem.token)
  %v3, %t3 = wavemachine.global_load_b32 %off, %base offset 12 : (!wavemachine.reg<vgpr, 1>, !wavemachine.reg<sgpr, 2>) -> (!wavemachine.reg<vgpr, 1>, !wavemachine.mem.token)
  %tuple = wavemachine.tuple_from_elements %v0, %v1, %v2, %v3
      : (!wavemachine.reg<vgpr, 1>, !wavemachine.reg<vgpr, 1>, !wavemachine.reg<vgpr, 1>, !wavemachine.reg<vgpr, 1>)
        -> !wavemachine.reg<vgpr, 4>
  %sink = wavemachine.v_mov_b32_tuple %tuple {registers = 4 : i64}
      : (!wavemachine.reg<vgpr, 4>) -> !wavemachine.reg<vgpr, 4>
  return
}

}

// -----

// Store side: tuple_to_elements + N scalar stores. Each scalar
// store's per-slot element should alias the tuple's `phys + i`.
//
// REGALLOC-LABEL: func.func @decomposed_store_split_regalloc
// REGALLOC: %[[T:.+]] = wavemachine.v_mov_b32_tuple {{.*}} -> !wavemachine.reg<vgpr, 4, 0>
// REGALLOC: %[[E:.+]]:4 = wavemachine.tuple_to_elements %[[T]]
// REGALLOC-SAME: -> (!wavemachine.reg<vgpr, 1, 0>, !wavemachine.reg<vgpr, 1, 1>, !wavemachine.reg<vgpr, 1, 2>, !wavemachine.reg<vgpr, 1, 3>)
// REGALLOC: wavemachine.global_store_b32 %{{.*}}, %[[E]]#0,
// REGALLOC: wavemachine.global_store_b32 %{{.*}}, %[[E]]#1, %{{.*}} offset 4
// REGALLOC: wavemachine.global_store_b32 %{{.*}}, %[[E]]#2, %{{.*}} offset 8
// REGALLOC: wavemachine.global_store_b32 %{{.*}}, %[[E]]#3, %{{.*}} offset 12
module attributes {wavemachine.target = "amdgcn-amd-amdhsa--gfx1100"} {
func.func @decomposed_store_split_regalloc(%off: !wavemachine.reg<vgpr, 1>,
                                            %base: !wavemachine.reg<sgpr, 2>) {
  %zero = wavemachine.imm 0 : !wavemachine.imm
  %tuple = wavemachine.v_mov_b32_tuple %zero {registers = 4 : i64}
      : (!wavemachine.imm) -> !wavemachine.reg<vgpr, 4>
  %e:4 = wavemachine.tuple_to_elements %tuple
      : (!wavemachine.reg<vgpr, 4>) -> (!wavemachine.reg<vgpr, 1>,
                                        !wavemachine.reg<vgpr, 1>,
                                        !wavemachine.reg<vgpr, 1>,
                                        !wavemachine.reg<vgpr, 1>)
  %s0 = wavemachine.global_store_b32 %off, %e#0, %base : (!wavemachine.reg<vgpr, 1>, !wavemachine.reg<vgpr, 1>, !wavemachine.reg<sgpr, 2>) -> !wavemachine.mem.token
  %s1 = wavemachine.global_store_b32 %off, %e#1, %base offset 4 : (!wavemachine.reg<vgpr, 1>, !wavemachine.reg<vgpr, 1>, !wavemachine.reg<sgpr, 2>) -> !wavemachine.mem.token
  %s2 = wavemachine.global_store_b32 %off, %e#2, %base offset 8 : (!wavemachine.reg<vgpr, 1>, !wavemachine.reg<vgpr, 1>, !wavemachine.reg<sgpr, 2>) -> !wavemachine.mem.token
  %s3 = wavemachine.global_store_b32 %off, %e#3, %base offset 12 : (!wavemachine.reg<vgpr, 1>, !wavemachine.reg<vgpr, 1>, !wavemachine.reg<sgpr, 2>) -> !wavemachine.mem.token
  return
}
}

// -----

// End-to-end matrix store path (parallel to wavemachine-matrix.mlir
// but using a tuple load consumer instead of an immediate-filled
// tuple). Verifies decomposition produces 8 scalar loads and that
// the gathered tuple feeds a wmma + tuple store correctly through
// the full pipeline.

module attributes {wavemachine.target = "amdgcn-amd-amdhsa--gfx1100"} {

// WAIT-LABEL: func.func @tuple_load_into_wmma_waitcnt
// WAIT-COUNT-8: wavemachine.global_load_b32
// WAIT: wavemachine.tuple_from_elements
// WAIT: wavemachine.imm 1015
// WAIT-NEXT: wavemachine.s_waitcnt
// WAIT-NEXT: wavemachine.wmma_f32_16x16x16_f16
func.func @tuple_load_into_wmma_waitcnt(%off: !wavemachine.reg<vgpr, 1>,
                                         %base: !wavemachine.reg<sgpr, 2>,
                                         %a: !wavemachine.reg<vgpr, 8>,
                                         %b: !wavemachine.reg<vgpr, 8>) {
  %v0, %t0 = wavemachine.global_load_b32 %off, %base : (!wavemachine.reg<vgpr, 1>, !wavemachine.reg<sgpr, 2>) -> (!wavemachine.reg<vgpr, 1>, !wavemachine.mem.token)
  %v1, %t1 = wavemachine.global_load_b32 %off, %base offset 4 : (!wavemachine.reg<vgpr, 1>, !wavemachine.reg<sgpr, 2>) -> (!wavemachine.reg<vgpr, 1>, !wavemachine.mem.token)
  %v2, %t2 = wavemachine.global_load_b32 %off, %base offset 8 : (!wavemachine.reg<vgpr, 1>, !wavemachine.reg<sgpr, 2>) -> (!wavemachine.reg<vgpr, 1>, !wavemachine.mem.token)
  %v3, %t3 = wavemachine.global_load_b32 %off, %base offset 12 : (!wavemachine.reg<vgpr, 1>, !wavemachine.reg<sgpr, 2>) -> (!wavemachine.reg<vgpr, 1>, !wavemachine.mem.token)
  %v4, %t4 = wavemachine.global_load_b32 %off, %base offset 16 : (!wavemachine.reg<vgpr, 1>, !wavemachine.reg<sgpr, 2>) -> (!wavemachine.reg<vgpr, 1>, !wavemachine.mem.token)
  %v5, %t5 = wavemachine.global_load_b32 %off, %base offset 20 : (!wavemachine.reg<vgpr, 1>, !wavemachine.reg<sgpr, 2>) -> (!wavemachine.reg<vgpr, 1>, !wavemachine.mem.token)
  %v6, %t6 = wavemachine.global_load_b32 %off, %base offset 24 : (!wavemachine.reg<vgpr, 1>, !wavemachine.reg<sgpr, 2>) -> (!wavemachine.reg<vgpr, 1>, !wavemachine.mem.token)
  %v7, %t7 = wavemachine.global_load_b32 %off, %base offset 28 : (!wavemachine.reg<vgpr, 1>, !wavemachine.reg<sgpr, 2>) -> (!wavemachine.reg<vgpr, 1>, !wavemachine.mem.token)
  %acc = wavemachine.tuple_from_elements %v0, %v1, %v2, %v3, %v4, %v5, %v6, %v7
      : (!wavemachine.reg<vgpr, 1>, !wavemachine.reg<vgpr, 1>,
         !wavemachine.reg<vgpr, 1>, !wavemachine.reg<vgpr, 1>,
         !wavemachine.reg<vgpr, 1>, !wavemachine.reg<vgpr, 1>,
         !wavemachine.reg<vgpr, 1>, !wavemachine.reg<vgpr, 1>)
        -> !wavemachine.reg<vgpr, 8>
  %r = wavemachine.wmma_f32_16x16x16_f16 %a, %b, %acc
      : (!wavemachine.reg<vgpr, 8>, !wavemachine.reg<vgpr, 8>,
         !wavemachine.reg<vgpr, 8>) -> !wavemachine.reg<vgpr, 8>
  return
}

}
