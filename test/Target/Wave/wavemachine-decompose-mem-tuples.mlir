// RUN: wave-opt --waveamd-decompose-mem-tuples %s | FileCheck %s

module attributes {wavemachine.target = "amdgcn-amd-amdhsa--gfx1100"} {

// Tuple global load -> N scalar loads + tuple_from_elements +
// token_join. The original op is replaced by the gather; downstream
// uses of the tuple value and the memory token go through the
// gather and join respectively.
//
// CHECK-LABEL: func.func @global_load_tuple_decompose
// CHECK: %[[L0:.+]], %[[T0:.+]] = wavemachine.global_load_b32 %{{.*}}, %{{.*}}{{ *:}}
// CHECK: %[[L1:.+]], %[[T1:.+]] = wavemachine.global_load_b32 %{{.*}}, %{{.*}} offset 4
// CHECK: %[[L2:.+]], %[[T2:.+]] = wavemachine.global_load_b32 %{{.*}}, %{{.*}} offset 8
// CHECK: %[[L3:.+]], %[[T3:.+]] = wavemachine.global_load_b32 %{{.*}}, %{{.*}} offset 12
// CHECK: %[[TUPLE:.+]] = wavemachine.tuple_from_elements %[[L0]], %[[L1]], %[[L2]], %[[L3]]
// CHECK: %[[JOIN:.+]] = wavemachine.token_join %[[T0]], %[[T1]], %[[T2]], %[[T3]]
// CHECK-NOT: wavemachine.global_load_tuple_b32
func.func @global_load_tuple_decompose(%off: !wavemachine.reg<vgpr, 1>,
                                        %base: !wavemachine.reg<sgpr, 2>)
    -> (!wavemachine.reg<vgpr, 4>, !wavemachine.mem.token) {
  %t, %tok = wavemachine.global_load_tuple_b32 %off, %base
      : (!wavemachine.reg<vgpr, 1>, !wavemachine.reg<sgpr, 2>)
        -> (!wavemachine.reg<vgpr, 4>, !wavemachine.mem.token)
  return %t, %tok : !wavemachine.reg<vgpr, 4>, !wavemachine.mem.token
}

// Tuple buffer load: same pattern, threaded through MUBUF OFFEN.
//
// CHECK-LABEL: func.func @buffer_load_tuple_decompose
// CHECK-COUNT-4: wavemachine.buffer_load_b32
// CHECK: wavemachine.tuple_from_elements
// CHECK: wavemachine.token_join
// CHECK-NOT: wavemachine.buffer_load_tuple_b32
func.func @buffer_load_tuple_decompose(%off: !wavemachine.reg<vgpr, 1>,
                                        %desc: !wavemachine.reg<sgpr, 4>,
                                        %so: !wavemachine.imm)
    -> (!wavemachine.reg<vgpr, 4>, !wavemachine.mem.token) {
  %t, %tok = wavemachine.buffer_load_tuple_b32 %off, %desc, %so
      : (!wavemachine.reg<vgpr, 1>, !wavemachine.reg<sgpr, 4>, !wavemachine.imm)
        -> (!wavemachine.reg<vgpr, 4>, !wavemachine.mem.token)
  return %t, %tok : !wavemachine.reg<vgpr, 4>, !wavemachine.mem.token
}

// Tuple DS load: same pattern, single-address shared memory.
//
// CHECK-LABEL: func.func @ds_load_tuple_decompose
// CHECK-COUNT-4: wavemachine.ds_load_b32
// CHECK: wavemachine.tuple_from_elements
// CHECK: wavemachine.token_join
// CHECK-NOT: wavemachine.ds_load_tuple_b32
func.func @ds_load_tuple_decompose(%addr: !wavemachine.reg<vgpr, 1>)
    -> (!wavemachine.reg<vgpr, 4>, !wavemachine.mem.token) {
  %t, %tok = wavemachine.ds_load_tuple_b32 %addr
      : (!wavemachine.reg<vgpr, 1>)
        -> (!wavemachine.reg<vgpr, 4>, !wavemachine.mem.token)
  return %t, %tok : !wavemachine.reg<vgpr, 4>, !wavemachine.mem.token
}

// Tuple global store -> tuple_to_elements + N scalar stores +
// token_join.
//
// CHECK-LABEL: func.func @global_store_tuple_decompose
// CHECK: %[[E:.+]]:4 = wavemachine.tuple_to_elements
// CHECK: %[[T0:.+]] = wavemachine.global_store_b32 %{{.*}}, %[[E]]#0, %{{.*}}{{ *:}}
// CHECK: %[[T1:.+]] = wavemachine.global_store_b32 %{{.*}}, %[[E]]#1, %{{.*}} offset 4
// CHECK: %[[T2:.+]] = wavemachine.global_store_b32 %{{.*}}, %[[E]]#2, %{{.*}} offset 8
// CHECK: %[[T3:.+]] = wavemachine.global_store_b32 %{{.*}}, %[[E]]#3, %{{.*}} offset 12
// CHECK: wavemachine.token_join %[[T0]], %[[T1]], %[[T2]], %[[T3]]
// CHECK-NOT: wavemachine.global_store_tuple_b32
func.func @global_store_tuple_decompose(%off: !wavemachine.reg<vgpr, 1>,
                                         %val: !wavemachine.reg<vgpr, 4>,
                                         %base: !wavemachine.reg<sgpr, 2>)
    -> !wavemachine.mem.token {
  %tok = wavemachine.global_store_tuple_b32 %off, %val, %base
      : (!wavemachine.reg<vgpr, 1>, !wavemachine.reg<vgpr, 4>, !wavemachine.reg<sgpr, 2>)
        -> !wavemachine.mem.token
  return %tok : !wavemachine.mem.token
}

// Tuple buffer store: same.
//
// CHECK-LABEL: func.func @buffer_store_tuple_decompose
// CHECK: wavemachine.tuple_to_elements
// CHECK-COUNT-4: wavemachine.buffer_store_b32
// CHECK: wavemachine.token_join
// CHECK-NOT: wavemachine.buffer_store_tuple_b32
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

// Tuple DS store: same.
//
// CHECK-LABEL: func.func @ds_store_tuple_decompose
// CHECK: wavemachine.tuple_to_elements
// CHECK-COUNT-4: wavemachine.ds_store_b32
// CHECK: wavemachine.token_join
// CHECK-NOT: wavemachine.ds_store_tuple_b32
func.func @ds_store_tuple_decompose(%addr: !wavemachine.reg<vgpr, 1>,
                                     %val: !wavemachine.reg<vgpr, 4>)
    -> !wavemachine.mem.token {
  %tok = wavemachine.ds_store_tuple_b32 %addr, %val
      : (!wavemachine.reg<vgpr, 1>, !wavemachine.reg<vgpr, 4>)
        -> !wavemachine.mem.token
  return %tok : !wavemachine.mem.token
}

}
