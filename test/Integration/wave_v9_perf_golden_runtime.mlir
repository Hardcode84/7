// REQUIRES: host-supports-amdgpu-gfx950, wave-python-bindings, host-has-hip-runtime, host-has-hipcc
//
// RUN: %python %S/../../tools/wave-matmul-calibrate/wave-matmul-calibrate.py --chip=%chip --build-dir=%wave_obj_root --kernel-profile=v9-4096-original-wave --m=256 --n=256 --variants=baseline --iters=2 --warmup=1 --repeats=1 --sim-trip-count=0 --no-check \
// RUN:   | FileCheck %s
// RUN: %python %S/../../tools/wave-matmul-calibrate/wave-matmul-calibrate.py --chip=%chip --build-dir=%wave_obj_root --kernel-profile=v9-4096-transposed-wave --m=256 --n=256 --variants=baseline --iters=2 --warmup=1 --repeats=1 --sim-trip-count=0 --no-check \
// RUN:   | FileCheck %s --check-prefix=TRANSPOSED
//
// CHECK: example=v9-perf-golden scale_input=canonical kernel_abi=v9-golden
// CHECK: kernel: v9_beyond_hotloop
// CHECK: grid: 1,1,1 block: 512,1,1
// CHECK: hw_output_check: skipped

// TRANSPOSED: example=v9-perf-golden scale_input=canonical kernel_abi=v9-golden
// TRANSPOSED: kernel: v9_beyond_hotloop
// TRANSPOSED: grid: 1,1,1 block: 512,1,1
// TRANSPOSED: hw_output_check: skipped
