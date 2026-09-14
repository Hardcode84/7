// REQUIRES: host-supports-amdgpu-wave, host-has-hip-runtime
// RUN: sed 's/gfx1100/%chip/g' %S/wave_scalar_subtraction_codegen.mlir \
// RUN:   | wave-translate --wave-to-amdgpu-asm - > %t.s
// RUN: llvm-mc --triple=amdgcn-amd-amdhsa --mcpu=%chip --filetype=obj %t.s -o %t.o
// RUN: ld.lld --shared %t.o -o %t.hsaco
// RUN: env LD_LIBRARY_PATH=%rocm_lib %python %S/Inputs/scalar_subtraction_runner.py \
// RUN:   --hip-lib=%hip_runtime_lib --wave-size=%wave_width %t.hsaco | FileCheck %s

// CHECK: scalar subtraction: 49 interference cases passed
