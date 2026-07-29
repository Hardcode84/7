// REQUIRES: host-supports-amdgpu-gfx1250, wave-python-bindings, host-has-hip-runtime
//
// RUN: mkdir -p %t.dir
// RUN: cd %t.dir && %python %S/../../examples/wave/gfx1250_tdm_matmul.py \
// RUN:   --chip=%chip --m=32 --n=32 --k=64 \
// RUN:   --random-data --compare-cpu --seed=41 \
// RUN:   | FileCheck %s

// CHECK: CPU comparison passed: values=1024 max_abs_diff=
