// RUN: wave-opt --waveamd-decompose-mem-tuples %s | FileCheck %s

module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx1100"} {

// Width-4 tuple load decomposes to ONE `global_load_b128`. The
// gather is now a single-element `tuple_from_elements`; downstream
// canonicalisation can drop it once tuple_to_elements/from_elements
// no-op folding lands.
//
// CHECK-LABEL: func.func @global_load_tuple_decompose
// CHECK: %[[V:.+]], %[[TOK:.+]] = waveamdmachine.global_load_b128
// CHECK-NOT: waveamdmachine.global_load_b32
// CHECK: %{{.+}} = waveamdmachine.tuple_from_elements %[[V]]
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
// CHECK: waveamdmachine.buffer_load_b128
// CHECK-NOT: waveamdmachine.buffer_load_b32
// CHECK: waveamdmachine.tuple_from_elements
// CHECK: waveamdmachine.token_join
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
// CHECK: waveamdmachine.ds_load_b128
// CHECK-NOT: waveamdmachine.ds_load_b32
// CHECK: waveamdmachine.tuple_from_elements
// CHECK: waveamdmachine.token_join
func.func @ds_load_tuple_decompose(%addr: !waveamdmachine.reg<vgpr, 1>)
    -> (!waveamdmachine.reg<vgpr, 4>, !waveamdmachine.mem.token) {
  %t, %tok = waveamdmachine.ds_load_tuple_b32 %addr
      : (!waveamdmachine.reg<vgpr, 1>)
        -> (!waveamdmachine.reg<vgpr, 4>, !waveamdmachine.mem.token)
  return %t, %tok : !waveamdmachine.reg<vgpr, 4>, !waveamdmachine.mem.token
}

// Width-4 stores collapse to one fused op each.
//
// CHECK-LABEL: func.func @global_store_tuple_decompose
// CHECK: %[[E:.+]] = waveamdmachine.tuple_to_elements
// CHECK: %[[T:.+]] = waveamdmachine.global_store_b128 %{{.*}}, %[[E]],
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
// CHECK: waveamdmachine.tuple_to_elements
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
// CHECK: waveamdmachine.tuple_to_elements
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

}
