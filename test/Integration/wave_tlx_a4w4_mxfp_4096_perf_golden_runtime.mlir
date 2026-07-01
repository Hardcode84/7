// REQUIRES: host-supports-amdgpu-gfx950, wave-python-bindings, host-has-hip-runtime, host-has-hipcc
//
// RUN: %python %S/../../tools/wave-matmul-calibrate/wave-matmul-calibrate.py --chip=%chip --kernel-profile=tlx-a4w4-mxfp-4096x4096x16384-after-bridge-wave --m=256 --n=256 --variants=baseline --iters=2 --warmup=1 --repeats=1 --sim-trip-count=0 --no-check \
// RUN:   | FileCheck %s
//
// CHECK: example=tlx-mxfp-perf-golden scale_input=canonical kernel_abi=tlx-mxfp
// CHECK: kernel: _a4w4_kernel
// CHECK: grid: 1,1,1 block: 256,1,1
// CHECK: hw_output_check: skipped
