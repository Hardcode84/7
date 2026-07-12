// RUN: not wave-translate --wave-to-amdgpu-asm %s 2>&1 | FileCheck %s

// CHECK: error: waveamd-resource-info LDS usage 65600 bytes exceeds target-addressable capacity 65536 bytes

module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx1100"} {
func.func @redistribute_lds_overflow(%dst: !wave.ptr<#wave.global, i8>)
    attributes {wave.kernel,
                wave.lds_size = 65536 : i64,
                wave.workgroup_size = array<i32: 64, 1, 1>,
                wave.waves_per_workgroup = 2 : i64} {
  %item = wave.workitem_id 0 : !wave.simd<i32, 32>
  %value = wave.constant 1 : i8 -> !wave.simd<i8, 32>
  %source = wave.pack %value
      : !wave.simd<i8, 32> -> !wave.simd<vector<1xi8>, 32>
  %moved = wave.redistribute %source,
      <items = 64, source_item = "xor(item, 32)", source_slot = "slot">
      : !wave.simd<vector<1xi8>, 32> -> !wave.simd<vector<1xi8>, 32>
  %out = wave.extract %moved[0]
      : !wave.simd<vector<1xi8>, 32> -> !wave.simd<i8, 32>
  %ptr = wave.ptr_add %dst, %item
      : !wave.ptr<#wave.global, i8>, !wave.simd<i32, 32>
      -> !wave.simd<!wave.ptr<#wave.global, i8>, 32>
  %token = wave.store %out -> %ptr
      : (!wave.simd<i8, 32>, !wave.simd<!wave.ptr<#wave.global, i8>, 32>)
      -> !wave.mem.token
  return
}
}
