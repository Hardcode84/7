// RUN: wave-target-info --schedule-model gfx1250 | FileCheck %s
// RUN: wave-target-info --schedule-model gfx1100 | FileCheck %s --check-prefix=GFX1100
// RUN: not wave-target-info --schedule-model gfx9999 2>&1 | FileCheck %s --check-prefix=OTHER

// OTHER: unsupported AMDGPU processor: gfx9999

// GFX1100: schedule_target: gfx1100
// GFX1100: class: Write16PassWMMA
// GFX1100-NEXT:   supported: true
// GFX1100-NEXT:   source: llvm-mc
// GFX1100-NEXT:   latency: 5
// GFX1100-NEXT:   resource_cycles: 1
// GFX1100-NEXT:   issue_count: 1
// GFX1100-NEXT:   functional_unit: VALU
// GFX1100-NEXT:   opcode: V_WMMA_F32_16X16X16_F16_twoaddr_w32
// GFX1100-NEXT:   opcode: V_WMMA_F32_16X16X16_BF16_twoaddr_w32

// CHECK: schedule_target: gfx1250
// CHECK-NEXT: schedule_issue_width: 1

// CHECK-LABEL: class: WriteSALU
// CHECK-NEXT:   supported: true
// CHECK-NEXT:   source: llvm-mc
// CHECK-NEXT:   latency: 2
// CHECK-NEXT:   resource_cycles: 1
// CHECK-NEXT:   issue_count: 1
// CHECK-NEXT:   functional_unit: SALU
// CHECK-NEXT:   opcode: S_ADD_U32_gfx12
// CHECK:        resource: HWSALU acquire=0 release=1

// CHECK-LABEL: class: Write32Bit
// CHECK:        latency: 5
// CHECK:        functional_unit: VALU
// CHECK:        opcode: V_ADD_F32_e32_gfx12

// CHECK-LABEL: class: WriteDouble
// CHECK:        latency: 37
// CHECK:        functional_unit: VALU

// CHECK-LABEL: class: WriteTrans32
// CHECK:        latency: 8
// CHECK:        functional_unit: TRANS
// CHECK:        resource: HWTransVALU acquire=0 release=1

// CHECK-LABEL: class: Write2PassMAI
// CHECK-NEXT:   supported: false

// CHECK-LABEL: class: WriteXDL2PassWMMA
// CHECK-NEXT:   supported: true
// CHECK-NEXT:   source: llvm-mc
// CHECK-NEXT:   latency: 8
// CHECK-NEXT:   resource_cycles: 8
// CHECK-NEXT:   issue_count: 1
// CHECK-NEXT:   functional_unit: MFMA_XDL
// CHECK-NEXT:   opcode: V_WMMA_F32_16X16X32_F16_w32_twoaddr_gfx1250
// CHECK-NEXT:   opcode: V_WMMA_F32_16X16X32_BF16_w32_twoaddr_gfx1250
// CHECK-NEXT:   resource: HWXDL acquire=0 release=8

// CHECK-LABEL: class: WriteXDL4PassWMMA
// CHECK:        latency: 16
// CHECK:        resource_cycles: 16
// CHECK:        functional_unit: MFMA_XDL
// CHECK:        resource: HWXDL acquire=0 release=16

// CHECK-LABEL: class: Write4PassWMMA
// CHECK:        latency: 16
// CHECK:        resource_cycles: 1
// CHECK:        functional_unit: VALU

// CHECK-LABEL: class: Write16PassWMMA
// CHECK-NEXT:   supported: false

// CHECK-LABEL: class: WriteVMEM
// CHECK:        latency: 320
// CHECK:        functional_unit: VMEM

// CHECK-LABEL: class: WriteSMEM
// CHECK:        latency: 20
// CHECK:        functional_unit: LGKM

// CHECK-LABEL: class: WriteLDS
// CHECK:        latency: 20
// CHECK:        functional_unit: LGKM

// CHECK-LABEL: class: WriteTDM
// CHECK-NEXT:   supported: true
// CHECK-NEXT:   source: llvm-mc
// CHECK-NEXT:   latency: 320
// CHECK-NEXT:   resource_cycles: 1
// CHECK-NEXT:   issue_count: 2
// CHECK-NEXT:   functional_unit: LGKM
// CHECK-NEXT:   opcode: TENSOR_LOAD_TO_LDS_d2
// CHECK-NEXT:   resource: HWLGKM acquire=0 release=1
// CHECK-NEXT:   resource: HWRC acquire=0 release=2
// CHECK-NEXT:   resource: HWVMEM acquire=0 release=1

// CHECK-LABEL: class: WriteBarrier
// CHECK:        latency: 2000
// CHECK:        functional_unit: BRANCH

// CHECK-LABEL: class: WriteExport
// CHECK-NEXT:   supported: false
