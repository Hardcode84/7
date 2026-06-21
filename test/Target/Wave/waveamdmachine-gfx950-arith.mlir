// RUN: wave-opt --waveamd-to-machine %s | FileCheck %s --check-prefix=MACHINE
// RUN: wave-opt --waveamd-to-machine %s | wave-translate --wave-to-amdgpu-asm | FileCheck %s --check-prefix=ASM
// RUN: wave-opt --waveamd-to-machine %s | wave-translate --wave-to-amdgpu-asm | llvm-mc -triple=amdgcn-amd-amdhsa -mcpu=gfx950 -filetype=obj -o /dev/null

module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx950"} {

// MACHINE-LABEL: func.func @wave64_uniform_splat_muli
// MACHINE: waveamdmachine.s_mul_i32
// MACHINE-NOT: waveamdmachine.v_mul_lo_u32
// ASM-LABEL: wave64_uniform_splat_muli:
// ASM: s_mul_i32
// ASM-NOT: v_mul_lo_u32
func.func @wave64_uniform_splat_muli(%x: i32, %y: i32) -> i32 {
  %vx = wave.splat %x : i32 -> !wave.simd<i32, 64>
  %vy = wave.splat %y : i32 -> !wave.simd<i32, 64>
  %prod = wave.binary muli %vx, %vy
      : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
  %first = wave.read_first %prod : !wave.simd<i32, 64> -> i32
  return %first : i32
}

}
