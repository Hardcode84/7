// REQUIRES: host-supports-amdgpu
//
// RUN: %python %S/../../examples/wave/flash_attention.py --chip=%chip \
// RUN:   --block-m=4 --block-n=8 --head-dim=8 --seed=11 --compare-cpu \
// RUN:   | FileCheck %s
//
// CHECK: CPU comparison passed
