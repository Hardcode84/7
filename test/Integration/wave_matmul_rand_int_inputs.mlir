// REQUIRES: host-has-hipcc, host-has-hip-runtime
//
// RUN: %hipcc -std=c++17 -O0 %S/Inputs/wave_matmul_rand_int_test.cpp -Wl,-rpath,%compiler_rocm_lib -o %t
// RUN: %t | FileCheck %s --check-prefix=VALID
// RUN: not %t mutual-exclusion 2>&1 | FileCheck %s --check-prefix=MUTEX
// RUN: not %t mxfp4 2>&1 | FileCheck %s --check-prefix=MXFP4
// RUN: not %t hpl-mxfp4 2>&1 | FileCheck %s --check-prefix=MXFP4
// RUN: not %t streamk-workers 2>&1 | FileCheck %s --check-prefix=WORKERS
// RUN: not %t streamk-layout 2>&1 | FileCheck %s --check-prefix=LAYOUT
// RUN: not %t streamk-work-overflow 2>&1 | FileCheck %s --check-prefix=WORK
// RUN: not %t streamk-buffer-overflow 2>&1 | FileCheck %s --check-prefix=BUFFER
// RUN: not %t workspace-overflow 2>&1 | FileCheck %s --check-prefix=WORKSPACE
// RUN: not %t integer-overflow 2>&1 | FileCheck %s --check-prefix=INTEGER
//
// VALID: rand_int_f16: ok
// VALID: rand_int_bf16: ok
// VALID: hpl_f16: ok
// VALID: hpl_bf16: ok
// VALID: rand_int_f16_cpu_reference: ok
// VALID: rand_int_bf16_cpu_reference: ok
// VALID: hpl_f16_cpu_reference: ok
// VALID: hpl_bf16_cpu_reference: ok
// VALID: fragment_output_coordinates: ok
// VALID: output_layouts: ok
// VALID: streamk_kernel_abi: ok
// MUTEX: --all-ones, --rand-int, and --hpl are mutually exclusive
// MXFP4: --rand-int/--hpl support f16/bf16 inputs only
// WORKERS: Stream-K worker count must fit the work
// LAYOUT: Stream-K ABI requires column-major output
// WORK: Stream-K work index exceeds i32
// BUFFER: Stream-K A buffer range overflow
// WORKSPACE: Stream-K workspace size overflow
// INTEGER: bad integer arg
