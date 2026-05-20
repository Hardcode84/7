// RUN: wave-opt --waveamd-decompose-mem-tuples %s | FileCheck %s

module attributes {wavemachine.target = "amdgcn-amd-amdhsa--gfx1100"} {

// Width-4 tuple load decomposes to ONE `global_load_b128`. The
// gather is now a single-element `tuple_from_elements`; downstream
// canonicalisation can drop it once tuple_to_elements/from_elements
// no-op folding lands.
//
// CHECK-LABEL: func.func @global_load_tuple_decompose
// CHECK: %[[V:.+]], %[[TOK:.+]] = wavemachine.global_load_b128
// CHECK-NOT: wavemachine.global_load_b32
// CHECK: %{{.+}} = wavemachine.tuple_from_elements %[[V]]
// CHECK: %{{.+}} = wavemachine.token_join %[[TOK]]
// CHECK-NOT: wavemachine.global_load_tuple_b32
func.func @global_load_tuple_decompose(%off: !wavemachine.reg<vgpr, 1>,
                                        %base: !wavemachine.reg<sgpr, 2>)
    -> (!wavemachine.reg<vgpr, 4>, !wavemachine.mem.token) {
  %t, %tok = wavemachine.global_load_tuple_b32 %off, %base
      : (!wavemachine.reg<vgpr, 1>, !wavemachine.reg<sgpr, 2>)
        -> (!wavemachine.reg<vgpr, 4>, !wavemachine.mem.token)
  return %t, %tok : !wavemachine.reg<vgpr, 4>, !wavemachine.mem.token
}

// Width-4 buffer load -> single b128.
//
// CHECK-LABEL: func.func @buffer_load_tuple_decompose
// CHECK: wavemachine.buffer_load_b128
// CHECK-NOT: wavemachine.buffer_load_b32
// CHECK: wavemachine.tuple_from_elements
// CHECK: wavemachine.token_join
func.func @buffer_load_tuple_decompose(%off: !wavemachine.reg<vgpr, 1>,
                                        %desc: !wavemachine.reg<sgpr, 4>,
                                        %so: !wavemachine.imm)
    -> (!wavemachine.reg<vgpr, 4>, !wavemachine.mem.token) {
  %t, %tok = wavemachine.buffer_load_tuple_b32 %off, %desc, %so
      : (!wavemachine.reg<vgpr, 1>, !wavemachine.reg<sgpr, 4>, !wavemachine.imm)
        -> (!wavemachine.reg<vgpr, 4>, !wavemachine.mem.token)
  return %t, %tok : !wavemachine.reg<vgpr, 4>, !wavemachine.mem.token
}

// Width-4 DS load -> single b128.
//
// CHECK-LABEL: func.func @ds_load_tuple_decompose
// CHECK: wavemachine.ds_load_b128
// CHECK-NOT: wavemachine.ds_load_b32
// CHECK: wavemachine.tuple_from_elements
// CHECK: wavemachine.token_join
func.func @ds_load_tuple_decompose(%addr: !wavemachine.reg<vgpr, 1>)
    -> (!wavemachine.reg<vgpr, 4>, !wavemachine.mem.token) {
  %t, %tok = wavemachine.ds_load_tuple_b32 %addr
      : (!wavemachine.reg<vgpr, 1>)
        -> (!wavemachine.reg<vgpr, 4>, !wavemachine.mem.token)
  return %t, %tok : !wavemachine.reg<vgpr, 4>, !wavemachine.mem.token
}

// Width-4 stores collapse to one fused op each.
//
// CHECK-LABEL: func.func @global_store_tuple_decompose
// CHECK: %[[E:.+]] = wavemachine.tuple_to_elements
// CHECK: %[[T:.+]] = wavemachine.global_store_b128 %{{.*}}, %[[E]],
// CHECK-NOT: wavemachine.global_store_b32
// CHECK: wavemachine.token_join %[[T]]
func.func @global_store_tuple_decompose(%off: !wavemachine.reg<vgpr, 1>,
                                         %val: !wavemachine.reg<vgpr, 4>,
                                         %base: !wavemachine.reg<sgpr, 2>)
    -> !wavemachine.mem.token {
  %tok = wavemachine.global_store_tuple_b32 %off, %val, %base
      : (!wavemachine.reg<vgpr, 1>, !wavemachine.reg<vgpr, 4>, !wavemachine.reg<sgpr, 2>)
        -> !wavemachine.mem.token
  return %tok : !wavemachine.mem.token
}

// CHECK-LABEL: func.func @buffer_store_tuple_decompose
// CHECK: wavemachine.tuple_to_elements
// CHECK: wavemachine.buffer_store_b128
// CHECK-NOT: wavemachine.buffer_store_b32
// CHECK: wavemachine.token_join
func.func @buffer_store_tuple_decompose(%off: !wavemachine.reg<vgpr, 1>,
                                         %val: !wavemachine.reg<vgpr, 4>,
                                         %desc: !wavemachine.reg<sgpr, 4>,
                                         %so: !wavemachine.imm)
    -> !wavemachine.mem.token {
  %tok = wavemachine.buffer_store_tuple_b32 %off, %val, %desc, %so
      : (!wavemachine.reg<vgpr, 1>, !wavemachine.reg<vgpr, 4>, !wavemachine.reg<sgpr, 4>, !wavemachine.imm)
        -> !wavemachine.mem.token
  return %tok : !wavemachine.mem.token
}

// CHECK-LABEL: func.func @ds_store_tuple_decompose
// CHECK: wavemachine.tuple_to_elements
// CHECK: wavemachine.ds_store_b128
// CHECK-NOT: wavemachine.ds_store_b32
// CHECK: wavemachine.token_join
func.func @ds_store_tuple_decompose(%addr: !wavemachine.reg<vgpr, 1>,
                                     %val: !wavemachine.reg<vgpr, 4>)
    -> !wavemachine.mem.token {
  %tok = wavemachine.ds_store_tuple_b32 %addr, %val
      : (!wavemachine.reg<vgpr, 1>, !wavemachine.reg<vgpr, 4>)
        -> !wavemachine.mem.token
  return %tok : !wavemachine.mem.token
}

// Width-8 tuple -> two `b128` ops at offsets 0 and 16. The gather
// has two mixed-width pieces (both width 4 here).
//
// CHECK-LABEL: func.func @global_load_width8_decompose
// CHECK: %[[V0:.+]], %[[T0:.+]] = wavemachine.global_load_b128 %{{.*}}, %{{.*}}{{ *:}}
// CHECK: %[[V1:.+]], %[[T1:.+]] = wavemachine.global_load_b128 %{{.*}}, %{{.*}} offset 16
// CHECK: %{{.+}} = wavemachine.tuple_from_elements %[[V0]], %[[V1]]
// CHECK-SAME: -> !wavemachine.reg<vgpr, 8>
// CHECK: wavemachine.token_join %[[T0]], %[[T1]]
func.func @global_load_width8_decompose(%off: !wavemachine.reg<vgpr, 1>,
                                         %base: !wavemachine.reg<sgpr, 2>)
    -> (!wavemachine.reg<vgpr, 8>, !wavemachine.mem.token) {
  %t, %tok = wavemachine.global_load_tuple_b32 %off, %base
      : (!wavemachine.reg<vgpr, 1>, !wavemachine.reg<sgpr, 2>)
        -> (!wavemachine.reg<vgpr, 8>, !wavemachine.mem.token)
  return %t, %tok : !wavemachine.reg<vgpr, 8>, !wavemachine.mem.token
}

// Width-5 exercises the mixed-width plan: greedy widest-first picks
// b128 (covers 4 dwords) then b32 (covers the remaining 1) at
// offset 16.
//
// CHECK-LABEL: func.func @global_load_width5_decompose
// CHECK: %[[V0:.+]], %[[T0:.+]] = wavemachine.global_load_b128 %{{.*}}, %{{.*}}{{ *:}}
// CHECK: %[[V1:.+]], %[[T1:.+]] = wavemachine.global_load_b32 %{{.*}}, %{{.*}} offset 16
// CHECK: %{{.+}} = wavemachine.tuple_from_elements %[[V0]], %[[V1]]
// CHECK-SAME: : (!wavemachine.reg<vgpr, 4>, !wavemachine.reg<vgpr, 1>) -> !wavemachine.reg<vgpr, 5>
// CHECK: wavemachine.token_join %[[T0]], %[[T1]]
func.func @global_load_width5_decompose(%off: !wavemachine.reg<vgpr, 1>,
                                         %base: !wavemachine.reg<sgpr, 2>)
    -> (!wavemachine.reg<vgpr, 5>, !wavemachine.mem.token) {
  %t, %tok = wavemachine.global_load_tuple_b32 %off, %base
      : (!wavemachine.reg<vgpr, 1>, !wavemachine.reg<sgpr, 2>)
        -> (!wavemachine.reg<vgpr, 5>, !wavemachine.mem.token)
  return %t, %tok : !wavemachine.reg<vgpr, 5>, !wavemachine.mem.token
}

// Width-7 -> b128 (4) + b96 (3) at offset 16.
//
// CHECK-LABEL: func.func @global_load_width7_decompose
// CHECK: %[[V0:.+]], %[[T0:.+]] = wavemachine.global_load_b128 %{{.*}}, %{{.*}}{{ *:}}
// CHECK: %[[V1:.+]], %[[T1:.+]] = wavemachine.global_load_b96 %{{.*}}, %{{.*}} offset 16
// CHECK: %{{.+}} = wavemachine.tuple_from_elements %[[V0]], %[[V1]]
// CHECK-SAME: : (!wavemachine.reg<vgpr, 4>, !wavemachine.reg<vgpr, 3>) -> !wavemachine.reg<vgpr, 7>
func.func @global_load_width7_decompose(%off: !wavemachine.reg<vgpr, 1>,
                                         %base: !wavemachine.reg<sgpr, 2>)
    -> (!wavemachine.reg<vgpr, 7>, !wavemachine.mem.token) {
  %t, %tok = wavemachine.global_load_tuple_b32 %off, %base
      : (!wavemachine.reg<vgpr, 1>, !wavemachine.reg<sgpr, 2>)
        -> (!wavemachine.reg<vgpr, 7>, !wavemachine.mem.token)
  return %t, %tok : !wavemachine.reg<vgpr, 7>, !wavemachine.mem.token
}

// Symmetric store side: width-8 -> two b128 stores at 0 and 16.
//
// CHECK-LABEL: func.func @global_store_width8_decompose
// CHECK: %[[E:.+]]:2 = wavemachine.tuple_to_elements
// CHECK-SAME: -> (!wavemachine.reg<vgpr, 4>, !wavemachine.reg<vgpr, 4>)
// CHECK: %[[T0:.+]] = wavemachine.global_store_b128 %{{.*}}, %[[E]]#0, %{{.*}}{{ *:}}
// CHECK: %[[T1:.+]] = wavemachine.global_store_b128 %{{.*}}, %[[E]]#1, %{{.*}} offset 16
// CHECK: wavemachine.token_join %[[T0]], %[[T1]]
func.func @global_store_width8_decompose(%off: !wavemachine.reg<vgpr, 1>,
                                          %val: !wavemachine.reg<vgpr, 8>,
                                          %base: !wavemachine.reg<sgpr, 2>)
    -> !wavemachine.mem.token {
  %tok = wavemachine.global_store_tuple_b32 %off, %val, %base
      : (!wavemachine.reg<vgpr, 1>, !wavemachine.reg<vgpr, 8>, !wavemachine.reg<sgpr, 2>)
        -> !wavemachine.mem.token
  return %tok : !wavemachine.mem.token
}

}
