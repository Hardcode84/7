// RUN: wave-translate --wave-to-amdgpu-asm %s | FileCheck %s --check-prefix=ASM
// RUN: wave-translate --wave-to-amdgpu-asm %s \
// RUN:   | llvm-mc -triple=amdgcn-amd-amdhsa -mcpu=gfx950 -filetype=obj -o /dev/null

// ASM-LABEL: redistribute_with_live_unresolved_lds:
// ASM: ds_write_b16
// ASM: ds_write_b64
// ASM-COUNT-11: s_barrier
// ASM: ds_read_b64
// ASM: ds_read_u16
// ASM: .amdhsa_group_segment_fixed_size 162720

module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx950"} {
func.func @redistribute_with_live_unresolved_lds(
    %src0: !wave.ptr<#wave.global, bf16>,
    %src1: !wave.ptr<#wave.global, bf16>,
    %dst: !wave.ptr<#wave.global, bf16>)
    attributes {wave.kernel,
                wave.workgroup_size = array<i32: 256, 1, 1>,
                wave.waves_per_workgroup = 4 : i64} {
  %lane = wave.lane_id : !wave.simd<i32, 64>
  %fixed = wave.alloc() {align = 16 : i64, bytesize = 138144 : i64}
      : !wave.ptr<#wave.shared, bf16>
  %src_ptr0 = wave.ptr_add %src0, %lane
      : !wave.ptr<#wave.global, bf16>, !wave.simd<i32, 64>
      -> !wave.simd<!wave.ptr<#wave.global, bf16>, 64>
  %src_ptr1 = wave.ptr_add %src1, %lane
      : !wave.ptr<#wave.global, bf16>, !wave.simd<i32, 64>
      -> !wave.simd<!wave.ptr<#wave.global, bf16>, 64>
  %source0, %loaded0 = wave.load %src_ptr0
      : (!wave.simd<!wave.ptr<#wave.global, bf16>, 64>)
      -> (!wave.simd<vector<128xbf16>, 64>, !wave.mem.token)
  %source1, %loaded1 = wave.load %src_ptr1
      : (!wave.simd<!wave.ptr<#wave.global, bf16>, 64>)
      -> (!wave.simd<vector<128xbf16>, 64>, !wave.mem.token)
  %fixed_value = wave.extract %source0[0]
      : !wave.simd<vector<128xbf16>, 64> -> !wave.simd<bf16, 64>
  %fixed_ptr = wave.ptr_add %fixed, %lane
      : !wave.ptr<#wave.shared, bf16>, !wave.simd<i32, 64>
      -> !wave.simd<!wave.ptr<#wave.shared, bf16>, 64>
  %fixed_stored = wave.store %fixed_value -> %fixed_ptr after %loaded0
      : (!wave.simd<bf16, 64>, !wave.simd<!wave.ptr<#wave.shared, bf16>, 64>,
         !wave.mem.token) -> !wave.mem.token
  %moved0 = wave.redistribute %source0,
      <blocks = 1, items = 256,
       source_block = "block",
       source_item = "64*xor(2*Mod(floor(1/8*slot), 2), Mod(floor(1/2*Mod(item, 64)), 2)) + xor(8*Mod(floor(1/128*item), 2), xor(4*Mod(floor(1/64*item), 2), xor(2*Mod(floor(1/32*Mod(item, 64)), 2), xor(Mod(floor(1/16*Mod(item, 64)), 2), xor(16*Mod(floor(1/4*slot), 2), 32*Mod(Mod(item, 64), 2))))))",
       source_slot = "xor(8*Mod(floor(1/8*Mod(item, 64)), 2), xor(4*Mod(floor(1/4*Mod(item, 64)), 2), xor(64*Mod(floor(1/64*slot), 2), xor(32*Mod(floor(1/32*slot), 2), xor(16*Mod(floor(1/16*slot), 2), xor(2*Mod(floor(1/2*slot), 2), Mod(slot, 2)))))))">
      : !wave.simd<vector<128xbf16>, 64>
     -> !wave.simd<vector<128xbf16>, 64>
  %moved1 = wave.redistribute %source1,
      <blocks = 1, items = 256,
       source_block = "block",
       source_item = "64*xor(2*Mod(floor(1/8*slot), 2), Mod(floor(1/2*Mod(item, 64)), 2)) + xor(8*Mod(floor(1/128*item), 2), xor(4*Mod(floor(1/64*item), 2), xor(2*Mod(floor(1/32*Mod(item, 64)), 2), xor(Mod(floor(1/16*Mod(item, 64)), 2), xor(16*Mod(floor(1/4*slot), 2), 32*Mod(Mod(item, 64), 2))))))",
       source_slot = "xor(8*Mod(floor(1/8*Mod(item, 64)), 2), xor(4*Mod(floor(1/4*Mod(item, 64)), 2), xor(64*Mod(floor(1/64*slot), 2), xor(32*Mod(floor(1/32*slot), 2), xor(16*Mod(floor(1/16*slot), 2), xor(2*Mod(floor(1/2*slot), 2), Mod(slot, 2)))))))">
      : !wave.simd<vector<128xbf16>, 64>
     -> !wave.simd<vector<128xbf16>, 64>
  %fixed_loaded, %fixed_ready = wave.load %fixed_ptr after %fixed_stored
      : (!wave.simd<!wave.ptr<#wave.shared, bf16>, 64>, !wave.mem.token)
      -> (!wave.simd<bf16, 64>, !wave.mem.token)
  %value0 = wave.extract %moved0[0]
      : !wave.simd<vector<128xbf16>, 64> -> !wave.simd<bf16, 64>
  %value1 = wave.extract %moved1[0]
      : !wave.simd<vector<128xbf16>, 64> -> !wave.simd<bf16, 64>
  %ptr = wave.ptr_add %dst, %lane
      : !wave.ptr<#wave.global, bf16>, !wave.simd<i32, 64>
      -> !wave.simd<!wave.ptr<#wave.global, bf16>, 64>
  %ready = wave.join %loaded1, %fixed_ready
      : !wave.mem.token, !wave.mem.token -> !wave.mem.token
  %token0 = wave.store %value0 -> %ptr after %ready
      : (!wave.simd<bf16, 64>, !wave.simd<!wave.ptr<#wave.global, bf16>, 64>,
         !wave.mem.token) -> !wave.mem.token
  %token1 = wave.store %value1 -> %ptr after %token0
      : (!wave.simd<bf16, 64>, !wave.simd<!wave.ptr<#wave.global, bf16>, 64>,
         !wave.mem.token) -> !wave.mem.token
  %done = wave.store %fixed_loaded -> %ptr after %token1
      : (!wave.simd<bf16, 64>, !wave.simd<!wave.ptr<#wave.global, bf16>, 64>,
         !wave.mem.token) -> !wave.mem.token
  return
}
}
