// REQUIRES: host-has-hip-runtime, host-supports-amdgpu-gfx950 || host-supports-amdgpu-gfx1250
// RUN: sed -e 's/WAVE_WIDTH/%wave_width/g' -e 's/gfx950/%chip/g' %S/Inputs/shared_atomic_offset.mlir > %t.mlir
// RUN: wave-translate %t.mlir --wave-to-amdgpu-asm -o %t.s
// RUN: llvm-mc --triple=amdgcn-amd-amdhsa --mcpu=%chip --filetype=obj %t.s -o %t.o
// RUN: ld.lld --shared %t.o -o %t.hsaco
// RUN: env LD_LIBRARY_PATH=%rocm_lib %python %S/Inputs/shared_atomic_offset_runner.py \
// RUN:   --hip-lib=%hip_runtime_lib --width=%wave_width %t.hsaco | FileCheck %s

// CHECK: shared atomic offset: counters, old values, and guards passed
