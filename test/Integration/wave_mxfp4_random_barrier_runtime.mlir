// REQUIRES: host-supports-amdgpu-gfx950, wave-python-bindings, host-has-hip-runtime, host-has-hipcc
//
// RUN: %python %S/../../tools/wave-matmul-calibrate/wave-matmul-calibrate.py --chip=%chip --kernel-profile=gfx950-mxfp4-256x256-8wave --m=1024 --n=512 --k=1024 --variants=scheduled --iters=5 --warmup=1 --repeats=1 \
// RUN:   | FileCheck %s
//
// CHECK: input_mode=random
// CHECK: variant: scheduled
// CHECK: hw_output_check: passed
