// REQUIRES: host-supports-amdgpu-wave, wave-python-bindings, host-has-hip-runtime, host-has-hipcc
//
// RUN: %python %S/../../tools/wave-matmul-calibrate/wave-matmul-calibrate.py --chip=%chip --build-dir=%wave_obj_root --m=32 --n=32 --k=32 --bm=1 --bn=2 --input-type=f16 --variants=baseline --iters=2 --warmup=1 --repeats=1 --sim-trip-count=0 --rand-int \
// RUN:   | FileCheck %s --check-prefix=F16
// RUN: %python %S/../../tools/wave-matmul-calibrate/wave-matmul-calibrate.py --chip=%chip --build-dir=%wave_obj_root --m=32 --n=32 --k=32 --bm=1 --bn=2 --input-type=bf16 --variants=baseline --iters=2 --warmup=1 --repeats=1 --sim-trip-count=0 --rand-int \
// RUN:   | FileCheck %s --check-prefix=BF16
//
// F16: input_type=f16
// F16-SAME: input_mode=rand-int
// F16: hw_output_check: passed
// BF16: input_type=bf16
// BF16-SAME: input_mode=rand-int
// BF16: hw_output_check: passed
