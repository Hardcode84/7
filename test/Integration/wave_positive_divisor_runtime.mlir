// REQUIRES: host-supports-amdgpu-wave, host-has-hip-runtime
// RUN: sed -e 's/gfx1100/%chip/g' -e 's/, 32>/, %wave_width>/g' %S/wave_positive_divisor_codegen.mlir \
// RUN:   | wave-translate --wave-to-amdgpu-asm - > %t.s
// RUN: llvm-mc -triple=amdgcn-amd-amdhsa -mcpu=%chip -filetype=obj %t.s -o %t.o
// RUN: ld.lld -shared %t.o -o %t.hsaco
// RUN: env LD_LIBRARY_PATH=%rocm_lib %python %S/Inputs/positive_divisor_runner.py \
// RUN:   --hip-lib=%hip_runtime_lib --wave-size=%wave_width %t.hsaco | FileCheck %s

// CHECK: scalar: 384 signed div/rem pairs passed
// CHECK-NEXT: narrow: 384 signed div/rem pairs passed
// CHECK-NEXT: simd: 384 signed div/rem pairs passed
