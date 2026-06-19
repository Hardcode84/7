// RUN: wave-opt %s --waveamd-machine-schedule-report='print-classes=1 print-score=1' 2>&1 | FileCheck %s

module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx1100"} {
func.func @packed_schedule(%a: !waveamdmachine.reg<vgpr, 1>,
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

// CHECK: waveamd-machine-schedule-report op func=packed_schedule region=0 index=0 name=waveamdmachine.v_cvt_pk_rtz_f16_f32 class=Write32Bit fu=VALU
// CHECK: waveamd-machine-schedule-report op func=packed_schedule region=0 index=1 name=waveamdmachine.v_pk_add_f16 class=Write32Bit fu=VALU
// CHECK: waveamd-machine-schedule-report op func=packed_schedule region=0 index=2 name=waveamdmachine.v_pk_mul_f16 class=Write32Bit fu=VALU
// CHECK: waveamd-machine-schedule-report op func=packed_schedule region=0 index=3 name=waveamdmachine.v_pk_fma_f16 class=Write32Bit fu=VALU
// CHECK: waveamd-machine-schedule-report score func=packed_schedule region=0 order=original cycles={{[0-9]+}} issued_ops=4 max_vgpr=3 max_sgpr=0

module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx950"} {
func.func @gfx950_packed_cvt_schedule(%a: !waveamdmachine.reg<vgpr, 1>,
                                      %b: !waveamdmachine.reg<vgpr, 1>,
                                      %c: !waveamdmachine.reg<vgpr, 1>) {
  %pk = waveamdmachine.v_cvt_pk_f16_f32 %a, %b
      : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>)
        -> !waveamdmachine.reg<vgpr, 1>
  %add = waveamdmachine.v_pk_add_f16 %pk, %c
      : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>)
        -> !waveamdmachine.reg<vgpr, 1>
  return
}
}

// CHECK: waveamd-machine-schedule-report op func=gfx950_packed_cvt_schedule region=0 index=0 name=waveamdmachine.v_cvt_pk_f16_f32 class=Write32Bit fu=VALU
// CHECK: waveamd-machine-schedule-report op func=gfx950_packed_cvt_schedule region=0 index=1 name=waveamdmachine.v_pk_add_f16 class=Write32Bit fu=VALU
// CHECK: waveamd-machine-schedule-report score func=gfx950_packed_cvt_schedule region=0 order=original cycles={{[0-9]+}} issued_ops=2 max_vgpr=2 max_sgpr=0
