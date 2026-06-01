// REQUIRES: host-supports-amdgpu, wave-python-bindings
//
// RUN: %python %S/../../examples/wave/flash_attention.py --chip=%chip \
// RUN:   --block-m=16 --block-n=16 --seq-n=16 --head-dim=32 --seed=11 --compare-cpu \
// RUN:   | FileCheck %s
// RUN: %python %S/../../examples/wave/flash_attention.py --chip=%chip \
// RUN:   --block-m=16 --block-n=16 --seq-n=32 --head-dim=32 --seed=11 --compare-cpu \
// RUN:   | FileCheck %s
// RUN: %python %S/../../tools/wave-fa-calibrate/wave-fa-calibrate.py --chip=%chip \
// RUN:   --block-m=16 --block-n=16 --seq-n=16 --head-dim=32 --seed=11 \
// RUN:   --variants=scheduled --skip-hw | FileCheck %s --check-prefix=SCHEDULED
// RUN: %python %S/../../tools/wave-fa-calibrate/wave-fa-calibrate.py --chip=%chip \
// RUN:   --block-m=16 --block-n=16 --seq-n=32 --head-dim=32 --seed=11 \
// RUN:   --variants=scheduled --skip-hw | FileCheck %s --check-prefix=SCHEDULED
// RUN: not %python %S/../../examples/wave/flash_attention.py --chip=gfx950 \
// RUN:   --matrix-intrinsic=mfma_gfx950 --block-m=8 --block-n=8 --seq-n=8 --head-dim=32 \
// RUN:   2>&1 | FileCheck %s --check-prefix=MFMA-PARTIAL
//
// CHECK: CPU comparison passed
// SCHEDULED: variant: scheduled
// MFMA-PARTIAL: --block-n must be 16 for gfx950 MFMA
