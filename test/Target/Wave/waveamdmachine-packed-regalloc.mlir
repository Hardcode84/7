// RUN: wave-opt --waveamd-reg-alloc %s | FileCheck %s
// RUN: wave-opt --waveamd-reg-alloc %s | wave-opt | FileCheck %s

module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx1100"} {

// CHECK-LABEL: func.func @packed_regalloc
// CHECK: [[PK:%.*]] = waveamdmachine.v_cvt_pk_rtz_f16_f32
// CHECK-SAME: -> !waveamdmachine.reg<vgpr, 1, {{[0-9]+}}>
// CHECK: [[ADD:%.*]] = waveamdmachine.v_pk_add_f16 [[PK]],
// CHECK-SAME: -> !waveamdmachine.reg<vgpr, 1, {{[0-9]+}}>
// CHECK: [[MUL:%.*]] = waveamdmachine.v_pk_mul_f16 [[ADD]], [[PK]]
// CHECK-SAME: -> !waveamdmachine.reg<vgpr, 1, {{[0-9]+}}>
// CHECK: waveamdmachine.v_pk_fma_f16 [[MUL]], [[ADD]],
// CHECK-SAME: -> !waveamdmachine.reg<vgpr, 1, {{[0-9]+}}>
func.func @packed_regalloc(%a: !waveamdmachine.reg<vgpr, 1>,
                           %b: !waveamdmachine.reg<vgpr, 1>,
                           %c: !waveamdmachine.reg<vgpr, 1>,
                           %d: !waveamdmachine.reg<vgpr, 1>) {
  %pk = waveamdmachine.v_cvt_pk_rtz_f16_f32 %a, %b
      : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>)
        -> !waveamdmachine.reg<vgpr, 1>
  %add = waveamdmachine.v_pk_add_f16 %pk, %c
      : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>)
        -> !waveamdmachine.reg<vgpr, 1>
  %mul = waveamdmachine.v_pk_mul_f16 %add, %pk
      : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>)
        -> !waveamdmachine.reg<vgpr, 1>
  %fma = waveamdmachine.v_pk_fma_f16 %mul, %add, %d
      : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>,
         !waveamdmachine.reg<vgpr, 1>) -> !waveamdmachine.reg<vgpr, 1>
  return
}

}
