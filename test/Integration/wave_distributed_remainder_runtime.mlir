// SPDX-FileCopyrightText: 2026 wave-mlir contributors
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
// REQUIRES: host-supports-amdgpu-wave, host-has-hip-runtime
// RUN: sed -e 's/gfx1100/%chip/g' -e 's/, 32>/, %wave_width>/g' -e 's/array<i32: 32, 1, 1>/array<i32: %wave_width, 1, 1>/g' %S/wave_distributed_remainder_codegen.mlir | wave-translate --wave-to-amdgpu-asm - -o %t.s
// RUN: llvm-mc --triple=amdgcn-amd-amdhsa --mcpu=%chip --filetype=obj %t.s -o %t.o
// RUN: ld.lld --shared %t.o -o %t.hsaco
// RUN: env LD_LIBRARY_PATH=%rocm_lib %python %S/Inputs/distributed_remainder_runner.py --hip-lib=%hip_runtime_lib --wave-size=%wave_width %t.hsaco | FileCheck %s

// CHECK: distributed: 8 address cases passed
// CHECK-NEXT: inexact: 8 address cases passed
// CHECK-NEXT: multiple: 8 address cases passed
