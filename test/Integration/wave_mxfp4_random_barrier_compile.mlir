// REQUIRES: wave-python-bindings
//
// RUN: %python %S/../../tools/wave-matmul-calibrate/wave-matmul-calibrate.py \
// RUN:   --chip=gfx950 --build-dir=%wave_obj_root \
// RUN:   --kernel-profile=gfx950-mxfp4-256x256-8wave \
// RUN:   --m=1024 --n=512 --k=1024 \
// RUN:   --variants=scheduled --iters=5 --warmup=1 --repeats=1 --skip-hw \
// RUN:   | FileCheck %s
//
// CHECK: m=1024 n=512 k=1024
// CHECK: input_type=mxfp4 output_type=f16
// CHECK: input_mode=random
// CHECK: variant: scheduled
// CHECK: sim_cycles
