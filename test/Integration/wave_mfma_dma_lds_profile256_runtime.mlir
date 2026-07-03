// REQUIRES: host-supports-amdgpu-gfx950, wave-python-bindings
//
// RUN: %python %S/../../examples/wave/wmma_matmul_tiled.py --chip=%chip --kernel-profile=gfx950-f16-256x256-16wave --m=256 --n=256 --k=64 --cta-swizzle-xcds=1 --cta-group-m=1 --compare-cpu --seed=5 \
// RUN:   | FileCheck %s
//
// CHECK: CPU comparison passed
