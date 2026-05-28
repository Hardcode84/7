// REQUIRES: host-supports-amdgpu
//
// RUN: %python %S/../../examples/wave/flash_attention.py --chip=%chip \
// RUN:   --block-m=16 --block-n=16 --seq-n=16 --head-dim=32 --seed=11 --compare-cpu \
// RUN:   | FileCheck %s
// RUN: %python %S/../../tools/wave-fa-calibrate/wave-fa-calibrate.py --chip=%chip \
// RUN:   --block-m=16 --block-n=16 --seq-n=16 --head-dim=32 --seed=11 \
// RUN:   --variants=scheduled --skip-hw | FileCheck %s --check-prefix=SCHEDULED
//
// CHECK: CPU comparison passed
// SCHEDULED: variant: scheduled
