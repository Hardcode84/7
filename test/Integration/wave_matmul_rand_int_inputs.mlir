// REQUIRES: host-has-hipcc, host-has-hip-runtime
//
// RUN: %hipcc -std=c++17 -O0 %S/Inputs/wave_matmul_rand_int_test.cpp -Wl,-rpath,%compiler_rocm_lib -o %t
// RUN: %t | FileCheck %s --check-prefix=VALID
// RUN: not %t mutual-exclusion 2>&1 | FileCheck %s --check-prefix=MUTEX
// RUN: not %t mxfp4 2>&1 | FileCheck %s --check-prefix=MXFP4
//
// VALID: rand_int_f16: ok
// VALID: rand_int_bf16: ok
// VALID: rand_int_f16_cpu_reference: ok
// VALID: rand_int_bf16_cpu_reference: ok
// MUTEX: --all-ones and --rand-int are mutually exclusive
// MXFP4: --rand-int supports f16/bf16 inputs only
