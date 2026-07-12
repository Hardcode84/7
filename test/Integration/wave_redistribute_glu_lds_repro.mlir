// RUN: not wave-translate --wave-to-amdgpu-asm %s 2>&1 | FileCheck %s

// CHECK: error: waveamd-resource-info LDS usage 239808 bytes exceeds target-addressable capacity 163840 bytes

module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx950"} {
func.func @glu_epilogue_redistribute_lds_overflow(
    %src: !wave.ptr<#wave.global, f32>,
    %dst: !wave.ptr<#wave.global, f32>)
    attributes {wave.kernel,
                wave.lds_size = 108736 : i64,
                wave.workgroup_size = array<i32: 512, 1, 1>,
                wave.waves_per_workgroup = 8 : i64} {
  %lane = wave.lane_id : !wave.simd<i32, 64>
  %src_ptr = wave.ptr_add %src, %lane
      : !wave.ptr<#wave.global, f32>, !wave.simd<i32, 64>
      -> !wave.simd<!wave.ptr<#wave.global, f32>, 64>
  %value, %loaded = wave.load %src_ptr
      : (!wave.simd<!wave.ptr<#wave.global, f32>, 64>)
      -> (!wave.simd<vector<64xf32>, 64>, !wave.mem.token)
  %moved = wave.redistribute %value,
      <blocks = 1, items = 512,
       source_block = "block",
       source_item = "64*xor(4*Mod(floor(1/8*slot), 2) + Mod(floor(1/2*Mod(item, 64)), 2), 2*Mod(floor(1/4*Mod(item, 64)), 2)) + xor(8*Mod(floor(1/256*item), 2), xor(4*Mod(floor(1/128*item), 2), xor(2*Mod(floor(1/64*item), 2), xor(16*Mod(floor(1/4*slot), 2) + 32*Mod(Mod(item, 64), 2), floor(1/32*Mod(item, 64))))))",
       source_slot = "xor(8*Mod(floor(1/16*Mod(item, 64)), 2), xor(Mod(slot, 2) + 32*Mod(floor(1/32*slot), 2) + 16*Mod(floor(1/16*slot), 2) + 2*Mod(floor(1/2*slot), 2), 4*Mod(floor(1/8*Mod(item, 64)), 2)))">
      : !wave.simd<vector<64xf32>, 64>
     -> !wave.simd<vector<64xf32>, 64>
  %result = wave.extract %moved[0]
      : !wave.simd<vector<64xf32>, 64> -> !wave.simd<f32, 64>
  %dst_ptr = wave.ptr_add %dst, %lane
      : !wave.ptr<#wave.global, f32>, !wave.simd<i32, 64>
      -> !wave.simd<!wave.ptr<#wave.global, f32>, 64>
  %stored = wave.store %result -> %dst_ptr after %loaded
      : (!wave.simd<f32, 64>, !wave.simd<!wave.ptr<#wave.global, f32>, 64>,
         !wave.mem.token) -> !wave.mem.token
  return
}
}
