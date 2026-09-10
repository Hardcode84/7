// SPDX-FileCopyrightText: 2026 wave-mlir contributors
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception

// REQUIRES: wave-python-bindings
// RUN: %PYTHON %S/../../build_tools/measure_regalloc_stage_timing.py --build-dir %wave_obj_root --perf-golden-test %S/test_gfx950_tensilelite_mxfp4_256x256_8wave.py --runs 1 --warmups 0 --output-dir %t.baseline | FileCheck %s
// RUN: %PYTHON %S/../../build_tools/measure_regalloc_stage_timing.py --build-dir %wave_obj_root --perf-golden-test %S/test_gfx950_f16_256x256_4wave.py --runs 1 --warmups 0 --output-dir %t.scheduled | FileCheck %s

// CHECK: asm=matched
// CHECK: stage,current_runs,current_median,current_min,current_max
// CHECK: regalloc_linear_scan,
