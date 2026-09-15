// REQUIRES: host-supports-amdgpu-wave, host-has-hip-runtime
// RUN: sed 's/, 32>/, %wave_width>/g; s/array<i32: 32,/array<i32: %wave_width,/' %S/wave_materialization_preserve_effects.mlir | wave-opt --wave-set-target-attr=chip=%chip -o %t.mlir
// RUN: wave-translate %t.mlir --wave-to-amdgpu-asm -o %t.s
// RUN: llvm-mc --triple=amdgcn-amd-amdhsa --mcpu=%chip --filetype=obj %t.s -o %t.o
// RUN: ld.lld --shared %t.o -o %t.hsaco
// RUN: env LD_LIBRARY_PATH=%rocm_lib %python %S/Inputs/materialization_effects_runner.py --hip-lib=%hip_runtime_lib --wave-width=%wave_width %t.hsaco | FileCheck %s
// CHECK: Materialization prerequisites: 256 outputs passed
