// REQUIRES: host-supports-amdgpu-gfx1250, wave-python-bindings, host-has-hip-runtime
//
// RUN: mkdir -p %t.dir
// RUN: cd %t.dir && %python %S/../../examples/wave/gfx1250_tdm_matmul.py \
// RUN:   --chip=%chip --four-wave --m=128 --n=128 --k=128 \
// RUN:   --random-data --compare-cpu --seed=42 --atol=1e-2 --rtol=1e-2 \
// RUN:   | FileCheck %s

// CHECK: CPU comparison passed: values=16384 max_abs_diff=
