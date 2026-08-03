// REQUIRES: host-has-hipcc, host-has-hip-runtime
//
// RUN: %hipcc -std=c++17 -O0 %S/Inputs/wave_matmul_rand_int_test.cpp -Wl,-rpath,%compiler_rocm_lib -o %t
// RUN: %t | FileCheck %s --check-prefix=VALID
// RUN: not %t mutual-exclusion 2>&1 | FileCheck %s --check-prefix=MUTEX
// RUN: not %t mxfp4 2>&1 | FileCheck %s --check-prefix=MXFP4
// RUN: not %t hpl-mxfp4 2>&1 | FileCheck %s --check-prefix=MXFP4
// RUN: not %t streamk-workers 2>&1 | FileCheck %s --check-prefix=WORKERS
// RUN: not %t streamk-layout 2>&1 | FileCheck %s --check-prefix=LAYOUT
// RUN: not %t aiter-output-layout 2>&1 | FileCheck %s --check-prefix=AITER-LAYOUT
// RUN: not %t aiter-wmma 2>&1 | FileCheck %s --check-prefix=AITER-WMMA
// RUN: not %t aiter-wave-k 2>&1 | FileCheck %s --check-prefix=AITER-WAVE-K
// RUN: not %t aiter-wave-mn 2>&1 | FileCheck %s --check-prefix=AITER-WAVE-MN
// RUN: not %t aiter-b-range-overflow 2>&1 | FileCheck %s --check-prefix=AITER-B-RANGE
// RUN: not %t streamk-work-overflow 2>&1 | FileCheck %s --check-prefix=WORK
// RUN: not %t streamk-buffer-overflow 2>&1 | FileCheck %s --check-prefix=BUFFER
// RUN: not %t workspace-overflow 2>&1 | FileCheck %s --check-prefix=WORKSPACE
// RUN: not %t aiter-scale-padding-overflow 2>&1 | FileCheck %s --check-prefix=AITER-SCALE-OVERFLOW
// RUN: not %t aiter-scale-range-overflow 2>&1 | FileCheck %s --check-prefix=AITER-SCALE-RANGE
// RUN: not %t aiter-scale-block-alias 2>&1 | FileCheck %s --check-prefix=AITER-SCALE-ALIAS
// RUN: not %t launch-k-overflow 2>&1 | FileCheck %s --check-prefix=LAUNCH-K
// RUN: not %t output-elements-overflow 2>&1 | FileCheck %s --check-prefix=OUTPUT-ELEMENTS
// RUN: not %t iters-zero 2>&1 | FileCheck %s --check-prefix=ITERS
// RUN: not %t warmup-negative 2>&1 | FileCheck %s --check-prefix=WARMUP
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
// VALID: input_check: passed mode=random a_codes=16 b_codes=16 a_scale_values=4 b_scale_values=4 reference=canonical upload=aiter-preshuffled
// VALID: output_layout_check: passed kernel=tile-packed final=row-major conversion=device coordinates=bijective elements=131072
// VALID: aiter_runner_contract: ok
// VALID: streamk_kernel_abi: ok
// MUTEX: --all-ones, --rand-int, and --hpl are mutually exclusive
// MXFP4: --rand-int/--hpl support f16/bf16 inputs only
// WORKERS: Stream-K worker count must fit the work
// LAYOUT: Stream-K ABI requires column-major output
// AITER-LAYOUT: aiter final output conversion requires tile-packed kernel output
// AITER-WMMA: aiter input layout requires MFMA accumulators
// AITER-WAVE-K: aiter input layout requires even wave K tiles
// AITER-WAVE-MN: aiter input layout requires even wave M/N tiles
// AITER-B-RANGE: AITER B buffer range exceeds u32
// WORK: Stream-K work index exceeds i32
// BUFFER: Stream-K A buffer range overflow
// WORKSPACE: Stream-K workspace size overflow
// AITER-SCALE-OVERFLOW: AITER scale row padding overflow
// AITER-SCALE-RANGE: AITER scale buffer range exceeds u32
// AITER-SCALE-ALIAS: random AITER A scale blocks were not position-distinct
// LAUNCH-K: K blocking exceeds i32
// OUTPUT-ELEMENTS: output element count exceeds i32
// ITERS: iters must be positive
// WARMUP: warmup must be non-negative
// INTEGER: bad integer arg
