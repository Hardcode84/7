// REQUIRES: host-supports-amdgpu, host-has-hipcc, host-has-hip-runtime
//
// RUN: %hipcc -std=c++17 -O0 %S/Inputs/wave_matmul_rand_int_test.cpp -Wl,-rpath,%compiler_rocm_lib -o %t
// RUN: %t aiter-device-output-conversion | FileCheck %s
//
// CHECK: aiter_device_output_conversion: ok
