// REQUIRES: host-supports-amdgpu-gfx950, wave-python-bindings, host-has-hip-runtime, host-has-hipcc
//
// RUN: %python %S/../../tools/wave-matmul-calibrate/wave-matmul-calibrate.py --chip=%chip --build-dir=%wave_obj_root --kernel-profile=gfx950-f16-256x256-16wave --m=1024 --n=512 --k=512 --cta-swizzle-xcds=1 --cta-group-m=1 --variants=scheduled --iters=2 --warmup=1 --repeats=1 \
// RUN:   | FileCheck %s --check-prefix=F16
// RUN: %python %S/../../tools/wave-matmul-calibrate/wave-matmul-calibrate.py --chip=%chip --build-dir=%wave_obj_root --kernel-profile=gfx950-mxfp4-256x256-8wave --m=1024 --n=512 --k=768 --cta-swizzle-xcds=1 --cta-group-m=1 --variants=scheduled --iters=2 --warmup=1 --repeats=1 \
// RUN:   | FileCheck %s --check-prefix=MXFP4
//
// F16: input_mode=random
// F16: output_check: passed mode=strict
// F16: variant: scheduled
// F16: hw_output_check: passed
// MXFP4: input_mode=random
// MXFP4: output_check: passed mode=strict
// MXFP4: variant: scheduled
// MXFP4: hw_output_check: passed
