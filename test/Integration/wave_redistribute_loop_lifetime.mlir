// RUN: wave-opt --wave-lower-redistribute --wave-resolve-allocs %s | FileCheck %s

// CHECK-LABEL: func.func @redistribute_loop_private_lifetime
// CHECK: [[ROOT:%.*]] = wave.token
// CHECK-NEXT: [[INIT0:%.*]] = wave.token
// CHECK-NEXT: [[INIT1:%.*]] = wave.token
// CHECK: scf.for {{.*}} iter_args([[CARRY:%.*]] = [[ROOT]], [[OTHER:%.*]] = [[ROOT]], [[PRIVATE0:%.*]] = [[INIT0]], [[PRIVATE1:%.*]] = [[INIT1]])
// CHECK: [[READY:%.*]] = wave.barrier [[CARRY]]
// CHECK: [[ENTRY0:%.*]] = wave.join [[READY]], [[PRIVATE0]]
// CHECK: [[STORE0:%.*]] = wave.store {{.*}} after [[ENTRY0]]
// CHECK: [[DONE0:%.*]] = wave.join
// CHECK: [[ENTRY1:%.*]] = wave.join [[DONE0]], [[PRIVATE1]]
// CHECK: [[STORE1:%.*]] = wave.store {{.*}} after [[ENTRY1]]
// CHECK: [[DONE1:%.*]] = wave.join
// CHECK: [[SAFE0:%.*]] = wave.barrier [[DONE0]]
// CHECK-NEXT: [[SAFE1:%.*]] = wave.barrier [[DONE1]]
// CHECK: scf.yield [[READY]], [[OTHER]], [[SAFE0]], [[SAFE1]]
// CHECK-NOT: wave.alloc
// CHECK-NOT: wave.alloc_release
func.func @redistribute_loop_private_lifetime(
    %source0: !wave.simd<vector<1xi32>, 32>,
    %source1: !wave.simd<vector<1xi32>, 32>)
    attributes {wave.kernel, wave.lds_size = 0 : i64,
                wave.workgroup_size = array<i32: 64, 1, 1>} {
  %c0 = arith.constant 0 : index
  %c1 = arith.constant 1 : index
  %c2 = arith.constant 2 : index
  %root = wave.token : !wave.mem.token
  %loop:2 = scf.for %i = %c0 to %c2 step %c1
      iter_args(%carry = %root, %other = %root)
      -> (!wave.mem.token, !wave.mem.token) {
    %ready = wave.barrier %carry : (!wave.mem.token) -> !wave.mem.token
    %result0 = wave.redistribute %source0,
        <blocks = 1, items = 64, source_block = "block",
         source_item = "xor(item, 32)", source_slot = "slot">
        : !wave.simd<vector<1xi32>, 32>
        -> !wave.simd<vector<1xi32>, 32>
    %result1 = wave.redistribute %source1,
        <blocks = 1, items = 64, source_block = "block",
         source_item = "xor(item, 32)", source_slot = "slot">
        : !wave.simd<vector<1xi32>, 32>
        -> !wave.simd<vector<1xi32>, 32>
    scf.yield %ready, %other : !wave.mem.token, !wave.mem.token
  }
  return
}
