// RUN: wave-opt --waveamd-to-machine %s \
// RUN:   | wave-translate --wave-to-amdgpu-asm - \
// RUN:   | FileCheck %s --check-prefix=ASM
// RUN: wave-opt --waveamd-to-machine %s \
// RUN:   | wave-translate --wave-to-amdgpu-asm - \
// RUN:   | llvm-mc -triple=amdgcn-amd-amdhsa -mcpu=gfx1100 -mattr=+wavefrontsize64 -filetype=obj -o /dev/null

module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx1100",
                   waveamdmachine.wavefront_size = 64 : i64} {

// ASM-LABEL: mask_vote_gfx11_wave64_codegen:
// ASM: s_cmp_eq_u64
// ASM: s_cmp_lg_u64
// ASM: global_store_b32
// ASM: .amdhsa_kernel mask_vote_gfx11_wave64_codegen
// ASM-NOT: .amdhsa_wavefront_size32
// ASM: .wavefront_size: 64
func.func @mask_vote_gfx11_wave64_codegen(
    %out: !wave.ptr<#wave.global, i32>) attributes {wave.kernel} {
  %lane = wave.lane_id : !wave.simd<i32, 64>
  %c32 = arith.constant 32 : i32
  %v32 = wave.splat %c32 : i32 -> !wave.simd<i32, 64>
  %mask = wave.cmpi ult %lane, %v32
      : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.mask<64>
  %all = wave.mask_all %mask : !wave.mask<64>
  %any = wave.mask_any %mask : !wave.mask<64>
  %zero = arith.constant 0 : i32
  %one = arith.constant 1 : i32
  %all_i32 = wave.select %all, %one, %zero : i32
  %any_i32 = wave.select %any, %one, %zero : i32
  %sum = wave.binary addi %all_i32, %any_i32 : i32, i32 -> i32
  %value = wave.splat %sum : i32 -> !wave.simd<i32, 64>
  %token = wave.store %value -> %out
      : (!wave.simd<i32, 64>, !wave.ptr<#wave.global, i32>)
      -> !wave.mem.token
  return
}

}
