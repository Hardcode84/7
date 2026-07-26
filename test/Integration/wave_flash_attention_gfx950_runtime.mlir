// REQUIRES: host-supports-amdgpu-gfx950, wave-python-bindings, host-has-hip-runtime, host-has-hipcc
//
// RUN: %python %S/../../tools/wave-fa-calibrate/wave-fa-gfx950.py \
// RUN:   --build-dir=%wave_obj_root --batch=1 --heads=1 --sequence=256 \
// RUN:   --xcds=1 --waves=4 --seed=23 --iters=1 --warmup=1 --repeats=1 \
// RUN:   --rocm-lib=%rocm_lib \
// RUN:   --check --skip-rebuild | FileCheck %s --check-prefix=CHECK-4W
// RUN: %python %S/../../tools/wave-fa-calibrate/wave-fa-gfx950.py \
// RUN:   --build-dir=%wave_obj_root --batch=1 --heads=1 --sequence=256 \
// RUN:   --xcds=1 --waves=8 --seed=23 --iters=1 --warmup=1 --repeats=1 \
// RUN:   --rocm-lib=%rocm_lib \
// RUN:   --check --skip-rebuild | FileCheck %s --check-prefix=CHECK-8W
//
// CHECK-4W: shape: B=1 H=1 N=256 D=128
// CHECK-4W: grid: 1,1,1 block: 256,1,1
// CHECK-4W: output_check: passed
//
// CHECK-8W: shape: B=1 H=1 N=256 D=128
// CHECK-8W: grid: 1,1,1 block: 512,1,1
// CHECK-8W: output_check: passed
