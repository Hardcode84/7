// RUN: rm -f %t.yaml
// RUN: wave-opt --waveamd-reg-alloc='mark-overflow=true vgpr-limit=2' \
// RUN:   --remarks-filter=waveamdmachine-regalloc --remark-policy=all --remark-format=yaml \
// RUN:   --remarks-output-file=%t.yaml %s | FileCheck %s
// RUN: FileCheck %s --input-file=%t.yaml --check-prefix=REMARK
// RUN: wave-opt --waveamd-reg-alloc='mark-overflow=true vgpr-limit=2' --waveamd-resource-info %s | FileCheck %s --check-prefix=SKIP
// RUN: not wave-opt --waveamd-reg-alloc='mark-overflow=true vgpr-limit=2' --waveamd-insert-hazard-waits %s 2>&1 | FileCheck %s --check-prefix=HAZARD
// RUN: not wave-opt --waveamd-reg-alloc='vgpr-limit=2' %s 2>&1 | FileCheck %s --check-prefix=HARD

// Soft-fail keeps only pruning state in IR. Pressure detail is a remark.

// CHECK: module
// CHECK-SAME: waveamdmachine.regalloc_overflowed_count = 1 : i64
// CHECK-LABEL: func.func @too_many_vgprs
// CHECK-SAME: waveamdmachine.regalloc_overflowed = 1 : i64
// CHECK-NOT: waveamdmachine.regalloc_pressure_

// REMARK: Name:            regalloc-interval
// REMARK: Function:        too_many_vgprs
// REMARK-DAG: class:           VGPR
// REMARK-DAG: storage_class:   VGPR
// REMARK-DAG: width:           '1'
// REMARK: Name:            regalloc-summary
// REMARK: Function:        too_many_vgprs
// REMARK-DAG: flat_ops:        '8'
// REMARK-DAG: peak_vgpr:       '4'
// REMARK-DAG: scalar_intervals: '6'
// REMARK-DAG: tracked_values:  '6'
// REMARK: Name:            regalloc-pressure-failure
// REMARK: Function:        too_many_vgprs
// REMARK: class:           VGPR
// REMARK: limit:           '2'
// REMARK: live_dwords:     '2'
// REMARK: position:        '3'
// REMARK: required_relief: '1'
// REMARK: request:         '{start=3, end=6, width=1, values=[3.0+0]}'
// REMARK: overlaps:        '[{start=1, end=4, width=1, values=[1.0+0]}, {start=2, end=5, width=1, values=[2.0+0]}]'

// SKIP-LABEL: func.func @too_many_vgprs
// SKIP-SAME: waveamdmachine.regalloc_overflowed = 1 : i64
// SKIP-NOT: waveamdmachine.vgpr_count

// HAZARD: waveamd-insert-hazard-waits cannot consume overflowed register allocation

// HARD: waveamd-reg-alloc ran out of VGPR registers at position 3
// HARD-SAME: required_relief=1
// HARD-SAME: request={start=3, end=6, width=1, values=[3.0+0]}
// HARD-SAME: overlaps=[{start=1, end=4, width=1, values=[1.0+0]}, {start=2, end=5, width=1, values=[2.0+0]}]

module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx1100"} {

func.func @too_many_vgprs() {
  %zero = waveamdmachine.imm 0 : !waveamdmachine.imm
  %v0 = waveamdmachine.v_mov_b32_tuple %zero {registers = 1 : i64}
      : (!waveamdmachine.imm) -> !waveamdmachine.reg<vgpr, 1>
  %v1 = waveamdmachine.v_mov_b32_tuple %zero {registers = 1 : i64}
      : (!waveamdmachine.imm) -> !waveamdmachine.reg<vgpr, 1>
  %v2 = waveamdmachine.v_mov_b32_tuple %zero {registers = 1 : i64}
      : (!waveamdmachine.imm) -> !waveamdmachine.reg<vgpr, 1>
  %use0 = waveamdmachine.v_mov_b32_tuple %v0 {registers = 1 : i64}
      : (!waveamdmachine.reg<vgpr, 1>) -> !waveamdmachine.reg<vgpr, 1>
  %use1 = waveamdmachine.v_mov_b32_tuple %v1 {registers = 1 : i64}
      : (!waveamdmachine.reg<vgpr, 1>) -> !waveamdmachine.reg<vgpr, 1>
  %use2 = waveamdmachine.v_mov_b32_tuple %v2 {registers = 1 : i64}
      : (!waveamdmachine.reg<vgpr, 1>) -> !waveamdmachine.reg<vgpr, 1>
  return
}

}
