// REQUIRES: host-supports-amdgpu-gfx950, wave-python-bindings, host-has-hip-runtime, host-has-hipcc
//
// RUN: %python %S/../../tools/wave-matmul-calibrate/wave-matmul-calibrate.py --chip=%chip --example=tensilelite-subtile --m=256 --n=256 --k=256 --bm=2 --bn=2 --wave-m-tiles=8 --wave-n-tiles=8 --wave-k-tiles=2 --target-waves=1 --input-type=mxfp4 --output-type=f16 --matrix-intrinsic=mfma_gfx950 --scale-input=tensilelite --variants=baseline --iters=2 --warmup=1 --repeats=1 --sim-trip-count=0 \
// RUN:   | FileCheck %s
//
// CHECK: example=tensilelite-subtile scale_input=tensilelite
// CHECK: scale_layout=tensilelite
// CHECK: variant: baseline
// CHECK: hw_output_check: passed
