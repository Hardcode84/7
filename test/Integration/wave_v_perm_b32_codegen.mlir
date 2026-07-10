// RUN: wave-opt --waveamd-to-machine --waveamd-form-fused-int %s \
// RUN:   | wave-translate --wave-to-amdgpu-asm - \
// RUN:   | FileCheck %s --check-prefix=ASM
// RUN: wave-opt --waveamd-to-machine --waveamd-form-fused-int %s \
// RUN:   | wave-translate --wave-to-amdgpu-asm - \
// RUN:   | llvm-mc -triple=amdgcn-amd-amdhsa -mcpu=gfx950 -filetype=obj -o /dev/null

module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx950"} {

// ASM-LABEL: halfword_permute:
// ASM-NOT: v_and_b32
// ASM-NOT: v_lshl_add_u32
// ASM-NOT: v_lshrrev_b32
// ASM-NOT: v_or_b32
// ASM: s_mov_b32 [[LOW_SEL:s[0-9]+]], 0x5040100
// ASM: v_perm_b32 {{.*}}, [[LOW_SEL]]
// ASM-NOT: v_and_b32
// ASM-NOT: v_lshl_add_u32
// ASM-NOT: v_lshrrev_b32
// ASM-NOT: v_or_b32
// ASM: s_mov_b32 [[HIGH_SEL:s[0-9]+]], 0x7060302
// ASM-NEXT: v_perm_b32 {{.*}}, [[HIGH_SEL]]
func.func @halfword_permute(
    %src0: !wave.ptr<#wave.global, i32>,
    %src1: !wave.ptr<#wave.global, i32>,
    %dst_lo: !wave.ptr<#wave.global, i32>,
    %dst_hi: !wave.ptr<#wave.global, i32>) attributes {wave.kernel} {
  %lane = wave.lane_id : !wave.simd<i32, 64>
  %src0_ptr = wave.ptr_add %src0, %lane
      : !wave.ptr<#wave.global, i32>, !wave.simd<i32, 64>
      -> !wave.simd<!wave.ptr<#wave.global, i32>, 64>
  %src1_ptr = wave.ptr_add %src1, %lane
      : !wave.ptr<#wave.global, i32>, !wave.simd<i32, 64>
      -> !wave.simd<!wave.ptr<#wave.global, i32>, 64>
  %dst_lo_ptr = wave.ptr_add %dst_lo, %lane
      : !wave.ptr<#wave.global, i32>, !wave.simd<i32, 64>
      -> !wave.simd<!wave.ptr<#wave.global, i32>, 64>
  %dst_hi_ptr = wave.ptr_add %dst_hi, %lane
      : !wave.ptr<#wave.global, i32>, !wave.simd<i32, 64>
      -> !wave.simd<!wave.ptr<#wave.global, i32>, 64>

  %a, %a_token = wave.load %src0_ptr
      : (!wave.simd<!wave.ptr<#wave.global, i32>, 64>)
      -> (!wave.simd<i32, 64>, !wave.mem.token)
  %b, %b_token = wave.load %src1_ptr after %a_token
      : (!wave.simd<!wave.ptr<#wave.global, i32>, 64>, !wave.mem.token)
      -> (!wave.simd<i32, 64>, !wave.mem.token)
  %c16 = arith.constant 16 : i32
  %c_lo = arith.constant 65535 : i32
  %c_hi = arith.constant -65536 : i32
  %v16 = wave.splat %c16 : i32 -> !wave.simd<i32, 64>
  %v_lo = wave.splat %c_lo : i32 -> !wave.simd<i32, 64>
  %v_hi = wave.splat %c_hi : i32 -> !wave.simd<i32, 64>

  %a_lo = wave.binary andi %a, %v_lo
      : !wave.simd<i32, 64>, !wave.simd<i32, 64>
      -> !wave.simd<i32, 64>
  %b_lo_high = wave.binary shli %b, %v16
      : !wave.simd<i32, 64>, !wave.simd<i32, 64>
      -> !wave.simd<i32, 64>
  %packed_lo = wave.binary addi %b_lo_high, %a_lo
      : !wave.simd<i32, 64>, !wave.simd<i32, 64>
      -> !wave.simd<i32, 64>

  %a_high_low = wave.binary shrui %a, %v16
      : !wave.simd<i32, 64>, !wave.simd<i32, 64>
      -> !wave.simd<i32, 64>
  %b_hi = wave.binary andi %b, %v_hi
      : !wave.simd<i32, 64>, !wave.simd<i32, 64>
      -> !wave.simd<i32, 64>
  %packed_hi = wave.binary ori %a_high_low, %b_hi
      : !wave.simd<i32, 64>, !wave.simd<i32, 64>
      -> !wave.simd<i32, 64>

  %lo_token = wave.store %packed_lo -> %dst_lo_ptr after %b_token
      : (!wave.simd<i32, 64>, !wave.simd<!wave.ptr<#wave.global, i32>, 64>,
         !wave.mem.token) -> !wave.mem.token
  %hi_token = wave.store %packed_hi -> %dst_hi_ptr after %lo_token
      : (!wave.simd<i32, 64>, !wave.simd<!wave.ptr<#wave.global, i32>, 64>,
         !wave.mem.token) -> !wave.mem.token
  return
}

}
