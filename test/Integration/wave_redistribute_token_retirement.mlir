// RUN: split-file %s %t
// RUN: wave-translate --wave-to-amdgpu-asm %t/covered.mlir \
// RUN:   | FileCheck %s --check-prefix=COVERED
// RUN: not wave-translate --wave-to-amdgpu-asm %t/unrelated.mlir 2>&1 \
// RUN:   | FileCheck %s --check-prefix=UNRELATED
// RUN: wave-translate --wave-to-amdgpu-asm %t/conditional.mlir \
// RUN:   | FileCheck %s --check-prefix=CONDITIONAL

// COVERED-LABEL: covered:
// COVERED: .amdhsa_group_segment_fixed_size 65536
// UNRELATED: error: 'wave.redistribute' op remaining target LDS capacity 0 bytes cannot hold one 64-element scratch plane
// CONDITIONAL-LABEL: conditional:
// CONDITIONAL: .amdhsa_group_segment_fixed_size 64

//--- covered.mlir

module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx1100"} {
func.func @covered(%dst: !wave.ptr<#wave.global, i8>)
    attributes {wave.kernel,
                wave.workgroup_size = array<i32: 64, 1, 1>,
                wave.waves_per_workgroup = 2 : i64} {
  %item = wave.workitem_id 0 : !wave.simd<i32, 32>
  %one = wave.constant 1 : i8 -> !wave.simd<i8, 32>
  %allocation = wave.alloc() {align = 16 : i64, bytesize = 65536 : i64}
      : !wave.ptr<#wave.shared, i8>
  %allocation_ptr = wave.ptr_add %allocation, %item
      : !wave.ptr<#wave.shared, i8>, !wave.simd<i32, 32>
      -> !wave.simd<!wave.ptr<#wave.shared, i8>, 32>
  %stored = wave.store %one -> %allocation_ptr
      : (!wave.simd<i8, 32>, !wave.simd<!wave.ptr<#wave.shared, i8>, 32>)
      -> !wave.mem.token
  %loaded, %loaded_token = wave.load %allocation_ptr after %stored
      : (!wave.simd<!wave.ptr<#wave.shared, i8>, 32>, !wave.mem.token)
      -> (!wave.simd<i8, 32>, !wave.mem.token)
  %ready = wave.barrier %loaded_token : (!wave.mem.token) -> !wave.mem.token
  %source = wave.pack %one
      : !wave.simd<i8, 32> -> !wave.simd<vector<1xi8>, 32>
  %moved = wave.redistribute %source,
      <blocks = 1, items = 64, source_block = "block",
       source_item = "xor(item, 32)", source_slot = "slot">
      : !wave.simd<vector<1xi8>, 32> -> !wave.simd<vector<1xi8>, 32>
  %out = wave.extract %moved[0]
      : !wave.simd<vector<1xi8>, 32> -> !wave.simd<i8, 32>
  %dst_ptr = wave.ptr_add %dst, %item
      : !wave.ptr<#wave.global, i8>, !wave.simd<i32, 32>
      -> !wave.simd<!wave.ptr<#wave.global, i8>, 32>
  %moved_done = wave.store %out -> %dst_ptr after %ready
      : (!wave.simd<i8, 32>, !wave.simd<!wave.ptr<#wave.global, i8>, 32>,
         !wave.mem.token) -> !wave.mem.token
  %done = wave.store %loaded -> %dst_ptr after %moved_done
      : (!wave.simd<i8, 32>, !wave.simd<!wave.ptr<#wave.global, i8>, 32>,
         !wave.mem.token) -> !wave.mem.token
  return
}
}

//--- conditional.mlir

module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx1100"} {
func.func @conditional(%dst: !wave.ptr<#wave.global, i8>, %condition: i1)
    attributes {wave.kernel,
                wave.workgroup_size = array<i32: 64, 1, 1>,
                wave.waves_per_workgroup = 2 : i64} {
  %item = wave.workitem_id 0 : !wave.simd<i32, 32>
  %one = wave.constant 1 : i8 -> !wave.simd<i8, 32>
  %initial = wave.token : !wave.mem.token
  %allocation = wave.alloc() {align = 16 : i64, bytesize = 65536 : i64}
      : !wave.ptr<#wave.shared, i8>
  %allocation_ptr = wave.ptr_add %allocation, %item
      : !wave.ptr<#wave.shared, i8>, !wave.simd<i32, 32>
      -> !wave.simd<!wave.ptr<#wave.shared, i8>, 32>
  %done = scf.if %condition -> (!wave.mem.token) {
    %stored = wave.store %one -> %allocation_ptr after %initial
        : (!wave.simd<i8, 32>, !wave.simd<!wave.ptr<#wave.shared, i8>, 32>,
           !wave.mem.token) -> !wave.mem.token
    scf.yield %stored : !wave.mem.token
  } else {
    scf.yield %initial : !wave.mem.token
  }
  %released = wave.alloc_release %allocation after %done
      : (!wave.ptr<#wave.shared, i8>, !wave.mem.token) -> !wave.mem.token
  %ready = wave.barrier %released : (!wave.mem.token) -> !wave.mem.token
  %source = wave.pack %one
      : !wave.simd<i8, 32> -> !wave.simd<vector<1xi8>, 32>
  %moved = wave.redistribute %source,
      <blocks = 1, items = 64, source_block = "block",
       source_item = "xor(item, 32)", source_slot = "slot">
      : !wave.simd<vector<1xi8>, 32> -> !wave.simd<vector<1xi8>, 32>
  %out = wave.extract %moved[0]
      : !wave.simd<vector<1xi8>, 32> -> !wave.simd<i8, 32>
  %dst_ptr = wave.ptr_add %dst, %item
      : !wave.ptr<#wave.global, i8>, !wave.simd<i32, 32>
      -> !wave.simd<!wave.ptr<#wave.global, i8>, 32>
  %stored = wave.store %out -> %dst_ptr after %ready
      : (!wave.simd<i8, 32>, !wave.simd<!wave.ptr<#wave.global, i8>, 32>,
         !wave.mem.token) -> !wave.mem.token
  return
}
}

//--- unrelated.mlir

module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx1100"} {
func.func @unrelated(%dst: !wave.ptr<#wave.global, i8>)
    attributes {wave.kernel,
                wave.workgroup_size = array<i32: 64, 1, 1>,
                wave.waves_per_workgroup = 2 : i64} {
  %item = wave.workitem_id 0 : !wave.simd<i32, 32>
  %one = wave.constant 1 : i8 -> !wave.simd<i8, 32>
  %allocation = wave.alloc() {align = 16 : i64, bytesize = 65536 : i64}
      : !wave.ptr<#wave.shared, i8>
  %allocation_ptr = wave.ptr_add %allocation, %item
      : !wave.ptr<#wave.shared, i8>, !wave.simd<i32, 32>
      -> !wave.simd<!wave.ptr<#wave.shared, i8>, 32>
  %stored = wave.store %one -> %allocation_ptr
      : (!wave.simd<i8, 32>, !wave.simd<!wave.ptr<#wave.shared, i8>, 32>)
      -> !wave.mem.token
  %loaded, %loaded_token = wave.load %allocation_ptr after %stored
      : (!wave.simd<!wave.ptr<#wave.shared, i8>, 32>, !wave.mem.token)
      -> (!wave.simd<i8, 32>, !wave.mem.token)
  %root = wave.token : !wave.mem.token
  %ready = wave.barrier %root : (!wave.mem.token) -> !wave.mem.token
  %source = wave.pack %one
      : !wave.simd<i8, 32> -> !wave.simd<vector<1xi8>, 32>
  %moved = wave.redistribute %source,
      <blocks = 1, items = 64, source_block = "block",
       source_item = "xor(item, 32)", source_slot = "slot">
      : !wave.simd<vector<1xi8>, 32> -> !wave.simd<vector<1xi8>, 32>
  %out = wave.extract %moved[0]
      : !wave.simd<vector<1xi8>, 32> -> !wave.simd<i8, 32>
  %dst_ptr = wave.ptr_add %dst, %item
      : !wave.ptr<#wave.global, i8>, !wave.simd<i32, 32>
      -> !wave.simd<!wave.ptr<#wave.global, i8>, 32>
  %moved_done = wave.store %out -> %dst_ptr after %ready
      : (!wave.simd<i8, 32>, !wave.simd<!wave.ptr<#wave.global, i8>, 32>,
         !wave.mem.token) -> !wave.mem.token
  %done = wave.store %loaded -> %dst_ptr after %moved_done
      : (!wave.simd<i8, 32>, !wave.simd<!wave.ptr<#wave.global, i8>, 32>,
         !wave.mem.token) -> !wave.mem.token
  return
}
}
