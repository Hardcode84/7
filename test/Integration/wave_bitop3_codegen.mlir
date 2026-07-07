// RUN: wave-opt --waveamd-to-machine --waveamd-form-fused-int %s \
// RUN:   | wave-translate --wave-to-amdgpu-asm - \
// RUN:   | FileCheck %s --check-prefix=ASM
// RUN: wave-opt --waveamd-to-machine --waveamd-form-fused-int %s \
// RUN:   | wave-translate --wave-to-amdgpu-asm - \
// RUN:   | llvm-mc -triple=amdgcn-amd-amdhsa -mcpu=gfx950 -filetype=obj -o /dev/null

module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx950"} {

// ASM-LABEL: bitop3_codegen:
// ASM-NOT: v_and_b32
// ASM-NOT: v_or_b32
// ASM-NOT: v_xor_b32
// ASM: v_bitop3_b32 {{.*}} bitop3:0x9a
// ASM: global_store_dword
func.func @bitop3_codegen(%out: !wave.ptr<#wave.global, i32>)
    attributes {wave.kernel} {
  %lane = wave.lane_id : !wave.simd<i32, 64>
  %c1 = arith.constant 1 : i32
  %c3 = arith.constant 3 : i32
  %v1 = wave.splat %c1 : i32 -> !wave.simd<i32, 64>
  %v3 = wave.splat %c3 : i32 -> !wave.simd<i32, 64>
  %a = wave.binary addi %lane, %v1
      : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
  %b = wave.binary xori %lane, %v3
      : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
  %and = wave.binary andi %a, %b
      : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
  %or = wave.binary ori %lane, %a
      : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
  %bits = wave.binary xori %and, %or
      : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
  %ptrs = wave.ptr_add %out, %lane
      : !wave.ptr<#wave.global, i32>, !wave.simd<i32, 64>
      -> !wave.simd<!wave.ptr<#wave.global, i32>, 64>
  %tok = wave.store %bits -> %ptrs
      : (!wave.simd<i32, 64>, !wave.simd<!wave.ptr<#wave.global, i32>, 64>)
      -> !wave.mem.token
  return
}

}
