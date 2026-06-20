// RUN: wave-opt --waveamd-to-machine --verify-diagnostics %s | FileCheck %s --check-prefix=SELECT
// RUN: wave-translate --wave-to-amdgpu-asm %s | llvm-mc -triple=amdgcn-amd-amdhsa -mcpu=gfx942 -filetype=obj -o /dev/null

module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx942"} {

// SELECT-LABEL: func.func @select_mask64_and_false
// SELECT: waveamdmachine.s_and_b32
// SELECT: waveamdmachine.s_and_b32
// SELECT-NOT: waveamdmachine.s_xor_b32
func.func @select_mask64_and_false(%limit: i32, %other: i32) -> i64 {
  %lane = wave.lane_id : !wave.simd<i32, 64>
  %vlimit = wave.splat %limit : i32 -> !wave.simd<i32, 64>
  %vother = wave.splat %other : i32 -> !wave.simd<i32, 64>
  %m0 = wave.cmpi ult %lane, %vlimit
      : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.mask<64>
  %m1 = wave.cmpi ult %lane, %vother
      : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.mask<64>
  %false = wave.constant false -> !wave.mask<64>
  %r = wave.select %m0, %m1, %false : !wave.mask<64>, !wave.mask<64>
  %bits = wave.ballot %r : !wave.mask<64> -> i64
  return %bits : i64
}

}
