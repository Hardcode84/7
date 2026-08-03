// RUN: wave-opt --wave-lower-redistribute --wave-resolve-allocs %s | FileCheck %s
// RUN: wave-translate --wave-to-amdgpu-asm %s \
// RUN:   | FileCheck %s --check-prefix=ASM
// RUN: wave-translate --wave-to-amdgpu-asm %s \
// RUN:   | llvm-mc -triple=amdgcn-amd-amdhsa -mcpu=gfx1100 \
// RUN:     -filetype=obj -o /dev/null

// CHECK-LABEL: func.func @redistribute_loop_private_lifetime
// CHECK: [[INPUT0:%.*]], [[READ0:%.*]] = wave.load
// CHECK: [[INPUT1:%.*]], [[READ1:%.*]] = wave.load
// CHECK: [[INIT0:%.*]] = wave.token
// CHECK-NEXT: [[INIT1:%.*]] = wave.token
// CHECK: [[LOOP:%.*]]:6 = scf.for
// CHECK-SAME: iter_args([[VALUE0:%.*]] = [[INPUT0]], [[VALUE1:%.*]] = [[INPUT1]],
// CHECK-SAME: [[CARRY0:%.*]] = [[READ0]], [[CARRY1:%.*]] = [[READ1]],
// CHECK-SAME: [[PRIVATE0:%.*]] = [[INIT0]], [[PRIVATE1:%.*]] = [[INIT1]])
// CHECK: [[STORE0:%.*]] = wave.store {{.*}} after [[PRIVATE0]]
// CHECK: [[DONE0:%.*]] = wave.join
// CHECK: [[ENTRY1:%.*]] = wave.join [[DONE0]], [[PRIVATE1]]
// CHECK: [[STORE1:%.*]] = wave.store {{.*}} after [[ENTRY1]]
// CHECK: [[DONE1:%.*]] = wave.join
// CHECK: [[SAFE0:%.*]] = wave.barrier [[DONE0]]
// CHECK-NEXT: [[SAFE1:%.*]] = wave.barrier [[DONE1]]
// CHECK: scf.yield {{.*}}, {{.*}}, [[CARRY0]], [[CARRY1]], [[SAFE0]], [[SAFE1]]
// CHECK: [[OUTPUT_READY:%.*]] = wave.join [[LOOP]]#2, [[LOOP]]#3
// CHECK: wave.store {{.*}} after [[OUTPUT_READY]]
// CHECK-NOT: wave.alloc
// CHECK-NOT: wave.alloc_release

// ASM-LABEL: redistribute_loop_private_lifetime:
// ASM-COUNT-2: buffer_load_b32
// ASM: [[LOOP:.Lredistribute_loop_private_lifetime.loop_head_[0-9]+]]:
// ASM-NOT: s_barrier
// ASM: s_waitcnt vmcnt(1)
// ASM: ds_store_b32
// ASM-COUNT-4: s_barrier
// ASM-NOT: s_barrier
// ASM: s_cbranch_scc1 [[LOOP]]
// ASM: buffer_store_b32
// ASM: s_endpgm

module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx1100"} {
func.func @redistribute_loop_private_lifetime(
    %source0: !wave.ptr<#wave.global, i32>,
    %source1: !wave.ptr<#wave.global, i32>,
    %destination: !wave.ptr<#wave.global, i32>)
    attributes {wave.kernel, wave.lds_size = 0 : i64,
                wave.workgroup_size = array<i32: 64, 1, 1>} {
  %c0 = arith.constant 0 : index
  %c1 = arith.constant 1 : index
  %c2 = arith.constant 2 : index
  %item = wave.workitem_id 0 : !wave.simd<i32, 32>
  %source_ptr0 = wave.ptr_add %source0, %item
      : !wave.ptr<#wave.global, i32>, !wave.simd<i32, 32>
      -> !wave.simd<!wave.ptr<#wave.global, i32>, 32>
  %input0, %read0 = wave.load %source_ptr0
      : (!wave.simd<!wave.ptr<#wave.global, i32>, 32>)
      -> (!wave.simd<i32, 32>, !wave.mem.token)
  %source_ptr1 = wave.ptr_add %source1, %item
      : !wave.ptr<#wave.global, i32>, !wave.simd<i32, 32>
      -> !wave.simd<!wave.ptr<#wave.global, i32>, 32>
  %input1, %read1 = wave.load %source_ptr1
      : (!wave.simd<!wave.ptr<#wave.global, i32>, 32>)
      -> (!wave.simd<i32, 32>, !wave.mem.token)
  %loop:4 = scf.for %i = %c0 to %c2 step %c1
      iter_args(%value0 = %input0, %value1 = %input1,
                %carry0 = %read0, %carry1 = %read1)
      -> (!wave.simd<i32, 32>, !wave.simd<i32, 32>,
          !wave.mem.token, !wave.mem.token) {
    %packed0 = wave.pack %value0
        : !wave.simd<i32, 32> -> !wave.simd<vector<1xi32>, 32>
    %result0 = wave.redistribute %packed0,
        <blocks = 1, items = 64, source_block = "block",
         source_item = "xor(item, 32)", source_slot = "slot">
        : !wave.simd<vector<1xi32>, 32>
        -> !wave.simd<vector<1xi32>, 32>
    %packed1 = wave.pack %value1
        : !wave.simd<i32, 32> -> !wave.simd<vector<1xi32>, 32>
    %result1 = wave.redistribute %packed1,
        <blocks = 1, items = 64, source_block = "block",
         source_item = "xor(item, 32)", source_slot = "slot">
        : !wave.simd<vector<1xi32>, 32>
        -> !wave.simd<vector<1xi32>, 32>
    %moved0 = wave.extract %result0[0]
        : !wave.simd<vector<1xi32>, 32> -> !wave.simd<i32, 32>
    %moved1 = wave.extract %result1[0]
        : !wave.simd<vector<1xi32>, 32> -> !wave.simd<i32, 32>
    %next0 = wave.binary addi %value0, %moved1
        : !wave.simd<i32, 32>, !wave.simd<i32, 32>
        -> !wave.simd<i32, 32>
    %next1 = wave.binary addi %value1, %moved0
        : !wave.simd<i32, 32>, !wave.simd<i32, 32>
        -> !wave.simd<i32, 32>
    scf.yield %next0, %next1, %carry0, %carry1
        : !wave.simd<i32, 32>, !wave.simd<i32, 32>,
          !wave.mem.token, !wave.mem.token
  }
  %sum = wave.binary addi %loop#0, %loop#1
      : !wave.simd<i32, 32>, !wave.simd<i32, 32>
      -> !wave.simd<i32, 32>
  %output = wave.ptr_add %destination, %item
      : !wave.ptr<#wave.global, i32>, !wave.simd<i32, 32>
      -> !wave.simd<!wave.ptr<#wave.global, i32>, 32>
  %ready = wave.join %loop#2, %loop#3
      : !wave.mem.token, !wave.mem.token -> !wave.mem.token
  %stored = wave.store %sum -> %output after %ready
      : (!wave.simd<i32, 32>, !wave.simd<!wave.ptr<#wave.global, i32>, 32>,
         !wave.mem.token) -> !wave.mem.token
  return
}
}
