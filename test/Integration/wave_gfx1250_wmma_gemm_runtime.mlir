// REQUIRES: host-supports-amdgpu-gfx1250, wave-python-bindings, host-has-hip-runtime
//
// RUN: mkdir -p %t.dir
// RUN: cd %t.dir && %python %S/../../examples/wave/wmma_matmul_tiled.py \
// RUN:   --chip=%chip --m=16 --n=16 --k=32 \
// RUN:   --bm=1 --bn=1 --wave-m-tiles=1 --wave-n-tiles=1 --wave-k-tiles=1 \
// RUN:   --matrix-intrinsic=auto --input-type=f16 \
// RUN:   --random-data --compare-cpu --seed=29 \
// RUN:   | FileCheck %s

// CHECK: CPU comparison passed: tiles=1 max_abs_diff=0.0
