// REQUIRES: host-supports-amdgpu-gfx950, wave-python-bindings
//
// RUN: %python %S/../../examples/wave/wmma_matmul_tiled.py --chip=%chip --kernel-profile=gfx950-sw-pipeline --m=128 --n=128 --k=192 --compare-cpu --seed=3 \
// RUN:   | FileCheck %s
//
// CHECK: CPU comparison passed
