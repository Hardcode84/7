// RUN: wave-translate --wave-to-amdgpu-asm %s | FileCheck %s
// RUN: wave-translate --wave-to-amdgpu-asm %s | llvm-mc -triple=amdgcn-amd-amdhsa -mcpu=gfx1100 -filetype=obj -o /dev/null

// CHECK-LABEL: wave_cast_fpconvert:
func.func @wave_cast_fpconvert(%x: f32) -> f32 {
  %vx = wave.splat %x : f32 -> !wave.simd<f32, 32>
  // CHECK: v_mov_b32_e32 [[VX:v[0-9]+]], [[ARG:s[0-9]+]]
  // CHECK: v_cvt_f16_f32_e64 [[H:v[0-9]+]].l, [[VX]]
  %h = wave.cast fpconvert %vx : !wave.simd<f32, 32> -> !wave.simd<f16, 32>
  // CHECK: v_cvt_f32_f16_e64 [[F:v[0-9]+]], [[H]].l
  %f = wave.cast fpconvert %h : !wave.simd<f16, 32> -> !wave.simd<f32, 32>
  %first = wave.read_first %f : !wave.simd<f32, 32> -> f32
  return %first : f32
}
