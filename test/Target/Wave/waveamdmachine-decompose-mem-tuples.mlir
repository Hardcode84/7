// RUN: wave-opt --waveamd-decompose-mem-tuples %s | FileCheck %s
// RUN: wave-opt --waveamd-decompose-mem-tuples %s | wave-opt | FileCheck %s

module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx1100"} {

// Width-4 tuple load decomposes to one `global_load_b128`.
//
// CHECK-LABEL: func.func @global_load_tuple_decompose
// CHECK: %[[V:.+]], %[[TOK:.+]] = waveamdmachine.global_load_b128
// CHECK-NOT: waveamdmachine.global_load_b32
// CHECK-NOT: waveamdmachine.tuple_from_elements
// CHECK: %{{.+}} = waveamdmachine.token_join %[[TOK]]
// CHECK-NOT: waveamdmachine.global_load_tuple_b32
func.func @global_load_tuple_decompose(%off: !waveamdmachine.reg<vgpr, 1>,
                                        %base: !waveamdmachine.reg<sgpr, 2>)
    -> (!waveamdmachine.reg<vgpr, 4>, !waveamdmachine.mem.token) {
  %t, %tok = waveamdmachine.global_load_tuple_b32 %off, %base
      : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<sgpr, 2>)
        -> (!waveamdmachine.reg<vgpr, 4>, !waveamdmachine.mem.token)
  return %t, %tok : !waveamdmachine.reg<vgpr, 4>, !waveamdmachine.mem.token
}

// Width-4 buffer load -> single b128.
//
// CHECK-LABEL: func.func @buffer_load_tuple_decompose
// CHECK: %{{.+}}, %[[TOK:.+]] = waveamdmachine.buffer_load_b128
// CHECK-NOT: waveamdmachine.buffer_load_b32
// CHECK-NOT: waveamdmachine.tuple_from_elements
// CHECK: waveamdmachine.token_join %[[TOK]]
func.func @buffer_load_tuple_decompose(%off: !waveamdmachine.reg<vgpr, 1>,
                                        %desc: !waveamdmachine.reg<sgpr, 4>,
                                        %so: !waveamdmachine.imm)
    -> (!waveamdmachine.reg<vgpr, 4>, !waveamdmachine.mem.token) {
  %t, %tok = waveamdmachine.buffer_load_tuple_b32 %off, %desc, %so
      : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<sgpr, 4>, !waveamdmachine.imm)
        -> (!waveamdmachine.reg<vgpr, 4>, !waveamdmachine.mem.token)
  return %t, %tok : !waveamdmachine.reg<vgpr, 4>, !waveamdmachine.mem.token
}

// Width-4 DS load -> single b128.
//
// CHECK-LABEL: func.func @ds_load_tuple_decompose
// CHECK: %{{.+}}, %[[TOK:.+]] = waveamdmachine.ds_load_b128
// CHECK-NOT: waveamdmachine.ds_load_b32
// CHECK-NOT: waveamdmachine.tuple_from_elements
// CHECK: waveamdmachine.token_join %[[TOK]]
func.func @ds_load_tuple_decompose(%addr: !waveamdmachine.reg<vgpr, 1>)
    -> (!waveamdmachine.reg<vgpr, 4>, !waveamdmachine.mem.token) {
  %t, %tok = waveamdmachine.ds_load_tuple_b32 %addr
      : (!waveamdmachine.reg<vgpr, 1>)
        -> (!waveamdmachine.reg<vgpr, 4>, !waveamdmachine.mem.token)
  return %t, %tok : !waveamdmachine.reg<vgpr, 4>, !waveamdmachine.mem.token
}

// CHECK-LABEL: func.func @ds_load_tuple_agpr_decompose
// CHECK: %[[V0:.+]], %[[T0:.+]] = waveamdmachine.ds_load_b128 %{{.*}}{{ *:}}
// CHECK-SAME: -> (!waveamdmachine.reg<agpr, 4>, !waveamdmachine.mem.token)
// CHECK: %[[V1:.+]], %[[T1:.+]] = waveamdmachine.ds_load_b128 %{{.*}} offset 16
// CHECK-SAME: -> (!waveamdmachine.reg<agpr, 4>, !waveamdmachine.mem.token)
// CHECK: %{{.+}} = waveamdmachine.tuple_from_elements %[[V0]], %[[V1]]
// CHECK-SAME: -> !waveamdmachine.reg<agpr, 8>
// CHECK: waveamdmachine.token_join %[[T0]], %[[T1]]
func.func @ds_load_tuple_agpr_decompose(%addr: !waveamdmachine.reg<vgpr, 1>)
    -> (!waveamdmachine.reg<agpr, 8>, !waveamdmachine.mem.token) {
  %t, %tok = waveamdmachine.ds_load_tuple_b32 %addr
      : (!waveamdmachine.reg<vgpr, 1>)
        -> (!waveamdmachine.reg<agpr, 8>, !waveamdmachine.mem.token)
  return %t, %tok : !waveamdmachine.reg<agpr, 8>, !waveamdmachine.mem.token
}

// Width-4 stores collapse to one fused op each.
//
// CHECK-LABEL: func.func @global_store_tuple_decompose
// CHECK-NOT: waveamdmachine.tuple_to_elements
// CHECK: %[[T:.+]] = waveamdmachine.global_store_b128
// CHECK-NOT: waveamdmachine.global_store_b32
// CHECK: waveamdmachine.token_join %[[T]]
func.func @global_store_tuple_decompose(%off: !waveamdmachine.reg<vgpr, 1>,
                                         %val: !waveamdmachine.reg<vgpr, 4>,
                                         %base: !waveamdmachine.reg<sgpr, 2>)
    -> !waveamdmachine.mem.token {
  %tok = waveamdmachine.global_store_tuple_b32 %off, %val, %base
      : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 4>, !waveamdmachine.reg<sgpr, 2>)
        -> !waveamdmachine.mem.token
  return %tok : !waveamdmachine.mem.token
}

// CHECK-LABEL: func.func @buffer_store_tuple_decompose
// CHECK-NOT: waveamdmachine.tuple_to_elements
// CHECK: waveamdmachine.buffer_store_b128
// CHECK-NOT: waveamdmachine.buffer_store_b32
// CHECK: waveamdmachine.token_join
func.func @buffer_store_tuple_decompose(%off: !waveamdmachine.reg<vgpr, 1>,
                                         %val: !waveamdmachine.reg<vgpr, 4>,
                                         %desc: !waveamdmachine.reg<sgpr, 4>,
                                         %so: !waveamdmachine.imm)
    -> !waveamdmachine.mem.token {
  %tok = waveamdmachine.buffer_store_tuple_b32 %off, %val, %desc, %so
      : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 4>, !waveamdmachine.reg<sgpr, 4>, !waveamdmachine.imm)
        -> !waveamdmachine.mem.token
  return %tok : !waveamdmachine.mem.token
}

// CHECK-LABEL: func.func @ds_store_tuple_decompose
// CHECK-NOT: waveamdmachine.tuple_to_elements
// CHECK: waveamdmachine.ds_store_b128
// CHECK-NOT: waveamdmachine.ds_store_b32
// CHECK: waveamdmachine.token_join
func.func @ds_store_tuple_decompose(%addr: !waveamdmachine.reg<vgpr, 1>,
                                     %val: !waveamdmachine.reg<vgpr, 4>)
    -> !waveamdmachine.mem.token {
  %tok = waveamdmachine.ds_store_tuple_b32 %addr, %val
      : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 4>)
        -> !waveamdmachine.mem.token
  return %tok : !waveamdmachine.mem.token
}

// CHECK-LABEL: func.func @ds_store_tuple_agpr_decompose
// CHECK: %[[E:.+]]:2 = waveamdmachine.tuple_to_elements
// CHECK-SAME: -> (!waveamdmachine.reg<agpr, 4>, !waveamdmachine.reg<agpr, 4>)
// CHECK: %[[T0:.+]] = waveamdmachine.ds_store_b128 %{{.*}}, %[[E]]#0{{.*}}{{ *:}}
// CHECK-SAME: !waveamdmachine.reg<agpr, 4>
// CHECK: %[[T1:.+]] = waveamdmachine.ds_store_b128 %{{.*}}, %[[E]]#1{{.*}} offset 16
// CHECK-SAME: !waveamdmachine.reg<agpr, 4>
// CHECK: waveamdmachine.token_join %[[T0]], %[[T1]]
func.func @ds_store_tuple_agpr_decompose(%addr: !waveamdmachine.reg<vgpr, 1>,
                                          %val: !waveamdmachine.reg<agpr, 8>)
    -> !waveamdmachine.mem.token {
  %tok = waveamdmachine.ds_store_tuple_b32 %addr, %val
      : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<agpr, 8>)
        -> !waveamdmachine.mem.token
  return %tok : !waveamdmachine.mem.token
}

// Width-8 tuple -> two `b128` ops at offsets 0 and 16. The gather
// has two mixed-width pieces (both width 4 here).
//
// CHECK-LABEL: func.func @global_load_width8_decompose
// CHECK: %[[V0:.+]], %[[T0:.+]] = waveamdmachine.global_load_b128 %{{.*}}, %{{.*}}{{ *:}}
// CHECK: %[[V1:.+]], %[[T1:.+]] = waveamdmachine.global_load_b128 %{{.*}}, %{{.*}} offset 16
// CHECK: %{{.+}} = waveamdmachine.tuple_from_elements %[[V0]], %[[V1]]
// CHECK-SAME: -> !waveamdmachine.reg<vgpr, 8>
// CHECK: waveamdmachine.token_join %[[T0]], %[[T1]]
func.func @global_load_width8_decompose(%off: !waveamdmachine.reg<vgpr, 1>,
                                         %base: !waveamdmachine.reg<sgpr, 2>)
    -> (!waveamdmachine.reg<vgpr, 8>, !waveamdmachine.mem.token) {
  %t, %tok = waveamdmachine.global_load_tuple_b32 %off, %base
      : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<sgpr, 2>)
        -> (!waveamdmachine.reg<vgpr, 8>, !waveamdmachine.mem.token)
  return %t, %tok : !waveamdmachine.reg<vgpr, 8>, !waveamdmachine.mem.token
}

// Width-5 exercises the mixed-width plan: greedy widest-first picks
// b128 (covers 4 dwords) then b32 (covers the remaining 1) at
// offset 16.
//
// CHECK-LABEL: func.func @global_load_width5_decompose
// CHECK: %[[V0:.+]], %[[T0:.+]] = waveamdmachine.global_load_b128 %{{.*}}, %{{.*}}{{ *:}}
// CHECK: %[[V1:.+]], %[[T1:.+]] = waveamdmachine.global_load_b32 %{{.*}}, %{{.*}} offset 16
// CHECK: %{{.+}} = waveamdmachine.tuple_from_elements %[[V0]], %[[V1]]
// CHECK-SAME: : (!waveamdmachine.reg<vgpr, 4>, !waveamdmachine.reg<vgpr, 1>) -> !waveamdmachine.reg<vgpr, 5>
// CHECK: waveamdmachine.token_join %[[T0]], %[[T1]]
func.func @global_load_width5_decompose(%off: !waveamdmachine.reg<vgpr, 1>,
                                         %base: !waveamdmachine.reg<sgpr, 2>)
    -> (!waveamdmachine.reg<vgpr, 5>, !waveamdmachine.mem.token) {
  %t, %tok = waveamdmachine.global_load_tuple_b32 %off, %base
      : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<sgpr, 2>)
        -> (!waveamdmachine.reg<vgpr, 5>, !waveamdmachine.mem.token)
  return %t, %tok : !waveamdmachine.reg<vgpr, 5>, !waveamdmachine.mem.token
}

// Width-7 -> b128 (4) + b96 (3) at offset 16.
//
// CHECK-LABEL: func.func @global_load_width7_decompose
// CHECK: %[[V0:.+]], %[[T0:.+]] = waveamdmachine.global_load_b128 %{{.*}}, %{{.*}}{{ *:}}
// CHECK: %[[V1:.+]], %[[T1:.+]] = waveamdmachine.global_load_b96 %{{.*}}, %{{.*}} offset 16
// CHECK: %{{.+}} = waveamdmachine.tuple_from_elements %[[V0]], %[[V1]]
// CHECK-SAME: : (!waveamdmachine.reg<vgpr, 4>, !waveamdmachine.reg<vgpr, 3>) -> !waveamdmachine.reg<vgpr, 7>
func.func @global_load_width7_decompose(%off: !waveamdmachine.reg<vgpr, 1>,
                                         %base: !waveamdmachine.reg<sgpr, 2>)
    -> (!waveamdmachine.reg<vgpr, 7>, !waveamdmachine.mem.token) {
  %t, %tok = waveamdmachine.global_load_tuple_b32 %off, %base
      : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<sgpr, 2>)
        -> (!waveamdmachine.reg<vgpr, 7>, !waveamdmachine.mem.token)
  return %t, %tok : !waveamdmachine.reg<vgpr, 7>, !waveamdmachine.mem.token
}

// Symmetric store side: width-8 -> two b128 stores at 0 and 16.
//
// CHECK-LABEL: func.func @global_store_width8_decompose
// CHECK: %[[E:.+]]:2 = waveamdmachine.tuple_to_elements
// CHECK-SAME: -> (!waveamdmachine.reg<vgpr, 4>, !waveamdmachine.reg<vgpr, 4>)
// CHECK: %[[T0:.+]] = waveamdmachine.global_store_b128 %{{.*}}, %[[E]]#0, %{{.*}}{{ *:}}
// CHECK: %[[T1:.+]] = waveamdmachine.global_store_b128 %{{.*}}, %[[E]]#1, %{{.*}} offset 16
// CHECK: waveamdmachine.token_join %[[T0]], %[[T1]]
func.func @global_store_width8_decompose(%off: !waveamdmachine.reg<vgpr, 1>,
                                          %val: !waveamdmachine.reg<vgpr, 8>,
                                          %base: !waveamdmachine.reg<sgpr, 2>)
    -> !waveamdmachine.mem.token {
  %tok = waveamdmachine.global_store_tuple_b32 %off, %val, %base
      : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 8>, !waveamdmachine.reg<sgpr, 2>)
        -> !waveamdmachine.mem.token
  return %tok : !waveamdmachine.mem.token
}

// Width-5 store mirrors load chunking: b128 + b32 at offset 16.
//
// CHECK-LABEL: func.func @global_store_width5_decompose
// CHECK: %[[E:.+]]:2 = waveamdmachine.tuple_to_elements
// CHECK-SAME: -> (!waveamdmachine.reg<vgpr, 4>, !waveamdmachine.reg<vgpr, 1>)
// CHECK: %[[T0:.+]] = waveamdmachine.global_store_b128 %{{.*}}, %[[E]]#0, %{{.*}}{{ *:}}
// CHECK: %[[T1:.+]] = waveamdmachine.global_store_b32 %{{.*}}, %[[E]]#1, %{{.*}} offset 16
// CHECK: waveamdmachine.token_join %[[T0]], %[[T1]]
func.func @global_store_width5_decompose(%off: !waveamdmachine.reg<vgpr, 1>,
                                          %val: !waveamdmachine.reg<vgpr, 5>,
                                          %base: !waveamdmachine.reg<sgpr, 2>)
    -> !waveamdmachine.mem.token {
  %tok = waveamdmachine.global_store_tuple_b32 %off, %val, %base
      : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 5>, !waveamdmachine.reg<sgpr, 2>)
        -> !waveamdmachine.mem.token
  return %tok : !waveamdmachine.mem.token
}

// Scratch has no wide chunk op today: width-4 decomposes to four b32
// memory ops and keeps post-regalloc physical VGPR slots.
//
// CHECK-LABEL: func.func @scratch_load_tuple_decompose
// CHECK: %[[L0:.+]], %[[T0:.+]] = waveamdmachine.scratch_load_b32 %{{.*}}, %{{.*}} offset 20
// CHECK-SAME: -> (!waveamdmachine.reg<vgpr, 1, 8>, !waveamdmachine.mem.token)
// CHECK: %[[L1:.+]], %[[T1:.+]] = waveamdmachine.scratch_load_b32 %{{.*}}, %{{.*}} offset 24
// CHECK-SAME: -> (!waveamdmachine.reg<vgpr, 1, 9>, !waveamdmachine.mem.token)
// CHECK: %[[L2:.+]], %[[T2:.+]] = waveamdmachine.scratch_load_b32 %{{.*}}, %{{.*}} offset 28
// CHECK-SAME: -> (!waveamdmachine.reg<vgpr, 1, 10>, !waveamdmachine.mem.token)
// CHECK: %[[L3:.+]], %[[T3:.+]] = waveamdmachine.scratch_load_b32 %{{.*}}, %{{.*}} offset 32
// CHECK-SAME: -> (!waveamdmachine.reg<vgpr, 1, 11>, !waveamdmachine.mem.token)
// CHECK: %{{.+}} = waveamdmachine.tuple_from_elements %[[L0]], %[[L1]], %[[L2]], %[[L3]]
// CHECK-SAME: -> !waveamdmachine.reg<vgpr, 4, 8>
// CHECK: waveamdmachine.token_join %[[T0]], %[[T1]], %[[T2]], %[[T3]]
// CHECK-NOT: waveamdmachine.scratch_load_tuple_b32
func.func @scratch_load_tuple_decompose(%off: !waveamdmachine.reg<vgpr, 1>,
                                         %saddr: !waveamdmachine.reg<sgpr, 1>,
                                         %dep: !waveamdmachine.mem.token)
    -> (!waveamdmachine.reg<vgpr, 4, 8>, !waveamdmachine.mem.token) {
  %t, %tok = waveamdmachine.scratch_load_tuple_b32 %off, %saddr after %dep
      offset 20
      : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<sgpr, 1>,
         !waveamdmachine.mem.token)
        -> (!waveamdmachine.reg<vgpr, 4, 8>, !waveamdmachine.mem.token)
  return %t, %tok : !waveamdmachine.reg<vgpr, 4, 8>, !waveamdmachine.mem.token
}

// CHECK-LABEL: func.func @scratch_store_tuple_decompose
// CHECK: %[[E:.+]]:4 = waveamdmachine.tuple_to_elements
// CHECK-SAME: -> (!waveamdmachine.reg<vgpr, 1, 12>, !waveamdmachine.reg<vgpr, 1, 13>, !waveamdmachine.reg<vgpr, 1, 14>, !waveamdmachine.reg<vgpr, 1, 15>)
// CHECK: %[[S0:.+]] = waveamdmachine.scratch_store_b32 %{{.*}}, %[[E]]#0, %{{.*}} offset 20
// CHECK: %[[S1:.+]] = waveamdmachine.scratch_store_b32 %{{.*}}, %[[E]]#1, %{{.*}} offset 24
// CHECK: %[[S2:.+]] = waveamdmachine.scratch_store_b32 %{{.*}}, %[[E]]#2, %{{.*}} offset 28
// CHECK: %[[S3:.+]] = waveamdmachine.scratch_store_b32 %{{.*}}, %[[E]]#3, %{{.*}} offset 32
// CHECK: waveamdmachine.token_join %[[S0]], %[[S1]], %[[S2]], %[[S3]]
// CHECK-NOT: waveamdmachine.scratch_store_tuple_b32
func.func @scratch_store_tuple_decompose(%off: !waveamdmachine.reg<vgpr, 1>,
                                          %val: !waveamdmachine.reg<vgpr, 4, 12>,
                                          %saddr: !waveamdmachine.reg<sgpr, 1>,
                                          %dep: !waveamdmachine.mem.token)
    -> !waveamdmachine.mem.token {
  %tok = waveamdmachine.scratch_store_tuple_b32 %off, %val, %saddr after %dep
      offset 20
      : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 4, 12>,
         !waveamdmachine.reg<sgpr, 1>, !waveamdmachine.mem.token)
        -> !waveamdmachine.mem.token
  return %tok : !waveamdmachine.mem.token
}

}
