// SPDX-FileCopyrightText: 2026 wave-mlir contributors
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
// REQUIRES: host-supports-amdgpu-wave, host-has-hip-runtime
// RUN: sed -e 's/gfx950/%chip/g' -e 's/, 64>/, %wave_width>/g' %S/wave_arith_select_codegen.mlir | wave-translate --wave-to-amdgpu-asm - -o %t.s
// RUN: llvm-mc --triple=amdgcn-amd-amdhsa --mcpu=%chip --filetype=obj %t.s -o %t.o
// RUN: ld.lld --shared %t.o -o %t.hsaco
// RUN: env LD_LIBRARY_PATH=%rocm_lib %python %S/Inputs/arith_select_runner.py --hip-lib=%hip_runtime_lib --wave-size=%wave_width %t.hsaco | FileCheck %s
// CHECK: typed-pointer select: 3 cases passed
