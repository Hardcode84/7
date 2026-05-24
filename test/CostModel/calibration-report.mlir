// RUN: wave-calibrate-report %S/Inputs/calibration-with-overrides.json | FileCheck %s
// RUN: not wave-calibrate-report %S/Inputs/calibration-bad-class.json 2>&1 | FileCheck %s --check-prefix=ERR

// CHECK: arch:           gfx1100
// CHECK: device_name:    test-device
// CHECK: WriteSALU                   2           4    +100.0%
// CHECK: WriteVMEM                 320          80      -75.0%
// CHECK: coverage: 2 / 24 SchedClasses

// ERR: failed to load calibration: unknown SchedClass name: NotAClass
