// RUN: wave-opt --waveamd-insert-ticket-waits -split-input-file %s | FileCheck %s --check-prefix=WAIT
// RUN: wave-opt --waveamd-insert-ticket-waits -split-input-file %s | wave-opt -split-input-file | FileCheck %s --check-prefix=WAIT
// RUN: wave-opt --waveamd-reg-alloc -split-input-file %s | FileCheck %s --check-prefix=REGALLOC
// RUN: wave-opt --waveamd-reg-alloc -split-input-file %s | wave-opt -split-input-file | FileCheck %s --check-prefix=REGALLOC

// Lit coverage for the post-decompose IR shape: N scalar loads +
// `tuple_from_elements` (data) + `token_join` (token); tuple
// consumer via the gather. Asserts (a) the waitcnt scoreboard
// propagates per-counter token state through the gather without
// draining at the rename point, and (b) the regalloc pins each
// scalar load result at the tuple's `phys + slot`.

module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx1100"} {

// Whole-tuple consumer reads the gather result: waitcnt drains all
// four pending vmem issues right before the consumer fires. The
// gather itself is a token-only join and must not emit its own
// s_waitcnt (otherwise consumers would never get to run in parallel
// with later ALU ops).
//
// WAIT-LABEL: func.func @decomposed_load_gather_waitcnt
// WAIT: waveamdmachine.global_load_b32
// WAIT: waveamdmachine.global_load_b32
// WAIT: waveamdmachine.global_load_b32
// WAIT: waveamdmachine.global_load_b32
// WAIT-NOT: s_waitcnt
// WAIT: waveamdmachine.tuple_from_elements
// WAIT: waveamdmachine.imm 1015
// WAIT-NEXT: waveamdmachine.s_waitcnt
// WAIT-NEXT: waveamdmachine.v_mov_b32_tuple
func.func @decomposed_load_gather_waitcnt(%off: !waveamdmachine.reg<vgpr, 1>,
                                           %base: !waveamdmachine.reg<sgpr, 2>) {
  %v0, %t0 = waveamdmachine.global_load_b32 %off, %base : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<sgpr, 2>) -> (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.mem.token)
  %v1, %t1 = waveamdmachine.global_load_b32 %off, %base offset 4 : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<sgpr, 2>) -> (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.mem.token)
  %v2, %t2 = waveamdmachine.global_load_b32 %off, %base offset 8 : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<sgpr, 2>) -> (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.mem.token)
  %v3, %t3 = waveamdmachine.global_load_b32 %off, %base offset 12 : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<sgpr, 2>) -> (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.mem.token)
  %tuple = waveamdmachine.tuple_from_elements %v0, %v1, %v2, %v3
      : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>)
        -> !waveamdmachine.reg<vgpr, 4>
  %sink = waveamdmachine.v_mov_b32_tuple %tuple {registers = 4 : i64}
      : (!waveamdmachine.reg<vgpr, 4>) -> !waveamdmachine.reg<vgpr, 4>
  return
}

// Same shape, regalloc-side: the four scalar loads' VGPR1 results
// land at the gather tuple's base + slot. Width-4 alignment puts
// the block at v0..v3, so each scalar lands at v[i] verbatim.
//
// REGALLOC-LABEL: func.func @decomposed_load_gather_regalloc
// REGALLOC: %[[V0:.+]], %{{.+}} = waveamdmachine.global_load_b32 {{.*}} -> (!waveamdmachine.reg<vgpr, 1, 0>, !waveamdmachine.mem.token)
// REGALLOC: %[[V1:.+]], %{{.+}} = waveamdmachine.global_load_b32 {{.*}} -> (!waveamdmachine.reg<vgpr, 1, 1>, !waveamdmachine.mem.token)
// REGALLOC: %[[V2:.+]], %{{.+}} = waveamdmachine.global_load_b32 {{.*}} -> (!waveamdmachine.reg<vgpr, 1, 2>, !waveamdmachine.mem.token)
// REGALLOC: %[[V3:.+]], %{{.+}} = waveamdmachine.global_load_b32 {{.*}} -> (!waveamdmachine.reg<vgpr, 1, 3>, !waveamdmachine.mem.token)
// REGALLOC: %[[TUPLE:.+]] = waveamdmachine.tuple_from_elements %[[V0]], %[[V1]], %[[V2]], %[[V3]]
// REGALLOC-SAME: -> !waveamdmachine.reg<vgpr, 4, 0>
func.func @decomposed_load_gather_regalloc(%off: !waveamdmachine.reg<vgpr, 1>,
                                            %base: !waveamdmachine.reg<sgpr, 2>) {
  %v0, %t0 = waveamdmachine.global_load_b32 %off, %base : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<sgpr, 2>) -> (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.mem.token)
  %v1, %t1 = waveamdmachine.global_load_b32 %off, %base offset 4 : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<sgpr, 2>) -> (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.mem.token)
  %v2, %t2 = waveamdmachine.global_load_b32 %off, %base offset 8 : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<sgpr, 2>) -> (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.mem.token)
  %v3, %t3 = waveamdmachine.global_load_b32 %off, %base offset 12 : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<sgpr, 2>) -> (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.mem.token)
  %tuple = waveamdmachine.tuple_from_elements %v0, %v1, %v2, %v3
      : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>)
        -> !waveamdmachine.reg<vgpr, 4>
  %sink = waveamdmachine.v_mov_b32_tuple %tuple {registers = 4 : i64}
      : (!waveamdmachine.reg<vgpr, 4>) -> !waveamdmachine.reg<vgpr, 4>
  return
}

}

// -----

// Store side: tuple_to_elements + N scalar stores. Each scalar
// store's per-slot element should alias the tuple's `phys + i`.
//
// REGALLOC-LABEL: func.func @decomposed_store_split_regalloc
// REGALLOC: %[[T:.+]] = waveamdmachine.v_mov_b32_tuple {{.*}} -> !waveamdmachine.reg<vgpr, 4, 0>
// REGALLOC: %[[E:.+]]:4 = waveamdmachine.tuple_to_elements %[[T]]
// REGALLOC-SAME: -> (!waveamdmachine.reg<vgpr, 1, 0>, !waveamdmachine.reg<vgpr, 1, 1>, !waveamdmachine.reg<vgpr, 1, 2>, !waveamdmachine.reg<vgpr, 1, 3>)
// REGALLOC: waveamdmachine.global_store_b32 %{{.*}}, %[[E]]#0,
// REGALLOC: waveamdmachine.global_store_b32 %{{.*}}, %[[E]]#1, %{{.*}} offset 4
// REGALLOC: waveamdmachine.global_store_b32 %{{.*}}, %[[E]]#2, %{{.*}} offset 8
// REGALLOC: waveamdmachine.global_store_b32 %{{.*}}, %[[E]]#3, %{{.*}} offset 12
module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx1100"} {
func.func @decomposed_store_split_regalloc(%off: !waveamdmachine.reg<vgpr, 1>,
                                            %base: !waveamdmachine.reg<sgpr, 2>) {
  %zero = waveamdmachine.imm 0 : !waveamdmachine.imm
  %tuple = waveamdmachine.v_mov_b32_tuple %zero {registers = 4 : i64}
      : (!waveamdmachine.imm) -> !waveamdmachine.reg<vgpr, 4>
  %e:4 = waveamdmachine.tuple_to_elements %tuple
      : (!waveamdmachine.reg<vgpr, 4>) -> (!waveamdmachine.reg<vgpr, 1>,
                                        !waveamdmachine.reg<vgpr, 1>,
                                        !waveamdmachine.reg<vgpr, 1>,
                                        !waveamdmachine.reg<vgpr, 1>)
  %s0 = waveamdmachine.global_store_b32 %off, %e#0, %base : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<sgpr, 2>) -> !waveamdmachine.mem.token
  %s1 = waveamdmachine.global_store_b32 %off, %e#1, %base offset 4 : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<sgpr, 2>) -> !waveamdmachine.mem.token
  %s2 = waveamdmachine.global_store_b32 %off, %e#2, %base offset 8 : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<sgpr, 2>) -> !waveamdmachine.mem.token
  %s3 = waveamdmachine.global_store_b32 %off, %e#3, %base offset 12 : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<sgpr, 2>) -> !waveamdmachine.mem.token
  return
}
}

// -----

// End-to-end matrix store path (parallel to waveamdmachine-matrix.mlir
// but using a tuple load consumer instead of an immediate-filled
// tuple). Verifies decomposition produces 8 scalar loads and that
// the gathered tuple feeds a wmma + tuple store correctly through
// the full pipeline.

module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx1100"} {

// WAIT-LABEL: func.func @tuple_load_into_wmma_waitcnt
// WAIT-COUNT-8: waveamdmachine.global_load_b32
// WAIT: waveamdmachine.tuple_from_elements
// WAIT: waveamdmachine.imm 1015
// WAIT-NEXT: waveamdmachine.s_waitcnt
// WAIT-NEXT: waveamdmachine.wmma_f32_16x16x16_f16
func.func @tuple_load_into_wmma_waitcnt(%off: !waveamdmachine.reg<vgpr, 1>,
                                         %base: !waveamdmachine.reg<sgpr, 2>,
                                         %a: !waveamdmachine.reg<vgpr, 8>,
                                         %b: !waveamdmachine.reg<vgpr, 8>) {
  %v0, %t0 = waveamdmachine.global_load_b32 %off, %base : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<sgpr, 2>) -> (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.mem.token)
  %v1, %t1 = waveamdmachine.global_load_b32 %off, %base offset 4 : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<sgpr, 2>) -> (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.mem.token)
  %v2, %t2 = waveamdmachine.global_load_b32 %off, %base offset 8 : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<sgpr, 2>) -> (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.mem.token)
  %v3, %t3 = waveamdmachine.global_load_b32 %off, %base offset 12 : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<sgpr, 2>) -> (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.mem.token)
  %v4, %t4 = waveamdmachine.global_load_b32 %off, %base offset 16 : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<sgpr, 2>) -> (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.mem.token)
  %v5, %t5 = waveamdmachine.global_load_b32 %off, %base offset 20 : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<sgpr, 2>) -> (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.mem.token)
  %v6, %t6 = waveamdmachine.global_load_b32 %off, %base offset 24 : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<sgpr, 2>) -> (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.mem.token)
  %v7, %t7 = waveamdmachine.global_load_b32 %off, %base offset 28 : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<sgpr, 2>) -> (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.mem.token)
  %acc = waveamdmachine.tuple_from_elements %v0, %v1, %v2, %v3, %v4, %v5, %v6, %v7
      : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>,
         !waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>,
         !waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>,
         !waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>)
        -> !waveamdmachine.reg<vgpr, 8>
  %r = waveamdmachine.wmma_f32_16x16x16_f16 %a, %b, %acc
      : (!waveamdmachine.reg<vgpr, 8>, !waveamdmachine.reg<vgpr, 8>,
         !waveamdmachine.reg<vgpr, 8>) -> !waveamdmachine.reg<vgpr, 8>
  return
}

}
