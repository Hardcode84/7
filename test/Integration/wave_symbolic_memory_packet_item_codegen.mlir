// RUN: wave-translate --wave-to-amdgpu-asm %s | FileCheck %s
// RUN: wave-translate --wave-to-amdgpu-asm %s \
// RUN:   | llvm-mc -triple=amdgcn-amd-amdhsa -mcpu=gfx950 -filetype=obj -o /dev/null
// RUN: wave-opt --wave-generate-index-exprs --wave-lower-symbolic-memory %s \
// RUN:   | FileCheck %s --check-prefix=LOWER

// CHECK-LABEL: symbolic_memory_packet_item_codegen:
// CHECK-COUNT-2: buffer_load_dword
// CHECK: buffer_store_dwordx2
// CHECK: s_endpgm

// CHECK-LABEL: symbolic_memory_simd_bases_codegen:
// CHECK: buffer_load_dword [[FIRST:v[0-9]+]],
// CHECK: buffer_load_dword [[SECOND:v[0-9]+]],
// CHECK: s_waitcnt vmcnt(0)
// CHECK: buffer_store_dword [[FIRST]],
// CHECK: buffer_store_dword [[SECOND]],
// CHECK: s_endpgm

// LOWER-LABEL: func.func @symbolic_memory_simd_bases_codegen(
// LOWER: [[ITEM_RAW:%.*]] = wave.workitem_id 0
// LOWER: [[ITEM:%.*]] = wave.assume [[ITEM_RAW]] as "x"
// LOWER: [[IN0:%.*]] = wave.ptr_add %arg0, [[ITEM]]
// LOWER-SAME: -> !wave.simd<!wave.ptr<#wave.global, i32>, 64>
// LOWER: [[IN1:%.*]] = wave.ptr_add %arg1, [[ITEM]]
// LOWER-SAME: -> !wave.simd<!wave.ptr<#wave.global, i32>, 64>
// LOWER: [[DEP:%.*]] = wave.token
// LOWER: [[PTR0:%.*]] = wave.ptr_cast [[IN0]]
// LOWER: [[VALUE0:%.*]], [[TOKEN0:%.*]] = wave.load [[PTR0]] after [[DEP]]
// LOWER: [[PTR1:%.*]] = wave.ptr_cast [[IN1]]
// LOWER: [[VALUE1:%.*]], [[TOKEN1:%.*]] = wave.load [[PTR1]] after [[DEP]]
// LOWER: [[READ:%.*]] = wave.join [[TOKEN0]], [[TOKEN1]]
// LOWER: [[STORE0:%.*]] = wave.store {{%.*}} -> {{%.*}} after [[READ]]
// LOWER: [[STORE1:%.*]] = wave.store {{%.*}} -> {{%.*}} after [[READ]]
// LOWER: wave.join [[STORE0]], [[STORE1]]

module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx950"} {
func.func @symbolic_memory_packet_item_codegen(
    %src0: !wave.ptr<#wave.global, i32>,
    %src1: !wave.ptr<#wave.global, i32>,
    %dst: !wave.ptr<#wave.global, i32>)
    attributes {wave.kernel,
                wave.workgroup_size = array<i32: 64, 1, 1>,
                wave.waves_per_workgroup = 1 : i64} {
  %item = wave.workitem_id 0 : !wave.simd<i32, 64>
  %bounded_item = wave.assume %item as "x"
      [#wave.pred<"x >= 0">, #wave.pred<"x <= 63">]
      : !wave.simd<i32, 64>
  %value, %read = wave.gather %src0, %src1 mapping
      <base = <"slot">, bit_offset = <"32 * item">>
      bindings ["item"](%bounded_item)
      : (!wave.ptr<#wave.global, i32>, !wave.ptr<#wave.global, i32>,
         !wave.simd<i32, 64>)
      -> (!wave.simd<vector<2xi32>, 64>, !wave.mem.token)
  %two = wave.constant 2 : i32 -> !wave.simd<i32, 64>
  %offset = wave.binary muli %bounded_item, %two overflow<nsw>
      : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
  %out = wave.ptr_add %dst, %offset
      : !wave.ptr<#wave.global, i32>, !wave.simd<i32, 64>
      -> !wave.simd<!wave.ptr<#wave.global, i32>, 64>
  %written = wave.store %value -> %out after %read
      : (!wave.simd<vector<2xi32>, 64>,
         !wave.simd<!wave.ptr<#wave.global, i32>, 64>, !wave.mem.token)
      -> !wave.mem.token
  return
}

func.func @symbolic_memory_simd_bases_codegen(
    %src0: !wave.ptr<#wave.global, i32>,
    %src1: !wave.ptr<#wave.global, i32>,
    %dst0: !wave.ptr<#wave.global, i32>,
    %dst1: !wave.ptr<#wave.global, i32>)
    attributes {wave.kernel,
                wave.workgroup_size = array<i32: 64, 1, 1>,
                wave.waves_per_workgroup = 1 : i64} {
  %item = wave.workitem_id 0 : !wave.simd<i32, 64>
  %bounded_item = wave.assume %item as "x"
      [#wave.pred<"x >= 0">, #wave.pred<"x <= 63">]
      : !wave.simd<i32, 64>
  %in0 = wave.ptr_add %src0, %bounded_item
      : !wave.ptr<#wave.global, i32>, !wave.simd<i32, 64>
      -> !wave.simd<!wave.ptr<#wave.global, i32>, 64>
  %in1 = wave.ptr_add %src1, %bounded_item
      : !wave.ptr<#wave.global, i32>, !wave.simd<i32, 64>
      -> !wave.simd<!wave.ptr<#wave.global, i32>, 64>
  %dependency = wave.token : !wave.mem.token
  %value, %read = wave.gather %in0, %in1 mapping
      <base = <"slot">, bit_offset = <"0">>
      bindings []() after %dependency
      : (!wave.simd<!wave.ptr<#wave.global, i32>, 64>,
         !wave.simd<!wave.ptr<#wave.global, i32>, 64>, !wave.mem.token)
      -> (!wave.simd<vector<2xi32>, 64>, !wave.mem.token)
  %out0 = wave.ptr_add %dst0, %bounded_item
      : !wave.ptr<#wave.global, i32>, !wave.simd<i32, 64>
      -> !wave.simd<!wave.ptr<#wave.global, i32>, 64>
  %out1 = wave.ptr_add %dst1, %bounded_item
      : !wave.ptr<#wave.global, i32>, !wave.simd<i32, 64>
      -> !wave.simd<!wave.ptr<#wave.global, i32>, 64>
  %written = wave.scatter %value to %out0, %out1 mapping
      <base = <"slot">, bit_offset = <"0">>
      bindings []() after %read
      : (!wave.simd<vector<2xi32>, 64>,
         !wave.simd<!wave.ptr<#wave.global, i32>, 64>,
         !wave.simd<!wave.ptr<#wave.global, i32>, 64>, !wave.mem.token)
      -> !wave.mem.token
  return
}
}
