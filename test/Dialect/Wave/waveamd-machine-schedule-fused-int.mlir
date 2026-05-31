// RUN: wave-opt %s --waveamd-machine-schedule-report='print-classes=1 print-score=1' 2>&1 | FileCheck %s --check-prefix=CLASS
// RUN: wave-opt %s --waveamd-machine-schedule-report='score-func=mad_chain print-score=1' 2>&1 | FileCheck %s --check-prefix=BASE
// RUN: wave-opt %s --waveamd-form-fused-int --waveamd-machine-schedule-report='score-func=mad_chain print-score=1 print-classes=1' 2>&1 | FileCheck %s --check-prefix=FUSED

module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx1100"} {
func.func @fused_integer_classes(%a: !waveamdmachine.reg<vgpr, 1>,
                                 %b: !waveamdmachine.reg<vgpr, 1>,
                                 %c: !waveamdmachine.reg<vgpr, 1>)
    -> !waveamdmachine.reg<vgpr, 1> {
  %one = waveamdmachine.imm 1 : !waveamdmachine.imm
  %add3 = waveamdmachine.v_add3_u32 %a, %b, %c
      : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>,
         !waveamdmachine.reg<vgpr, 1>) -> !waveamdmachine.reg<vgpr, 1>
  %madi24 = waveamdmachine.v_mad_i32_i24 %add3, %b, %a
      : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>,
         !waveamdmachine.reg<vgpr, 1>) -> !waveamdmachine.reg<vgpr, 1>
  %madu24 = waveamdmachine.v_mad_u32_u24 %madi24, %one, %c
      : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.imm,
         !waveamdmachine.reg<vgpr, 1>) -> !waveamdmachine.reg<vgpr, 1>
  %lshadd = waveamdmachine.v_lshl_add_u32 %madu24, %one, %a
      : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.imm,
         !waveamdmachine.reg<vgpr, 1>) -> !waveamdmachine.reg<vgpr, 1>
  %addlsh = waveamdmachine.v_add_lshl_u32 %lshadd, %b, %one
      : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>,
         !waveamdmachine.imm) -> !waveamdmachine.reg<vgpr, 1>
  %andor = waveamdmachine.v_and_or_b32 %addlsh, %b, %c
      : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>,
         !waveamdmachine.reg<vgpr, 1>) -> !waveamdmachine.reg<vgpr, 1>
  %or3 = waveamdmachine.v_or3_b32 %andor, %a, %c
      : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>,
         !waveamdmachine.reg<vgpr, 1>) -> !waveamdmachine.reg<vgpr, 1>
  %xad = waveamdmachine.v_xad_u32 %or3, %b, %a
      : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>,
         !waveamdmachine.reg<vgpr, 1>) -> !waveamdmachine.reg<vgpr, 1>
  return %xad : !waveamdmachine.reg<vgpr, 1>
}

func.func @mad_chain(%a: !waveamdmachine.reg<vgpr, 1>,
                     %b: !waveamdmachine.reg<vgpr, 1>,
                     %c: !waveamdmachine.reg<vgpr, 1>)
    -> !waveamdmachine.reg<vgpr, 1> {
  %mask = waveamdmachine.imm 16777215 : !waveamdmachine.imm
  %am = waveamdmachine.v_and_b32 %a, %mask
      : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.imm)
          -> !waveamdmachine.reg<vgpr, 1>
  %bm = waveamdmachine.v_and_b32 %b, %mask
      : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.imm)
          -> !waveamdmachine.reg<vgpr, 1>
  %mul = waveamdmachine.v_mul_lo_u32 %am, %bm
      : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>)
          -> !waveamdmachine.reg<vgpr, 1>
  %out = waveamdmachine.v_add_u32 %mul, %c
      : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>)
          -> !waveamdmachine.reg<vgpr, 1>
  return %out : !waveamdmachine.reg<vgpr, 1>
}
}

// CLASS: waveamd-machine-schedule-report op func=fused_integer_classes region=0 index=1 name=waveamdmachine.v_add3_u32 class=Write32Bit fu=VALU latency=5
// CLASS: waveamd-machine-schedule-report op func=fused_integer_classes region=0 index=2 name=waveamdmachine.v_mad_i32_i24 class=Write32Bit fu=VALU latency=5
// CLASS: waveamd-machine-schedule-report op func=fused_integer_classes region=0 index=3 name=waveamdmachine.v_mad_u32_u24 class=Write32Bit fu=VALU latency=5
// CLASS: waveamd-machine-schedule-report op func=fused_integer_classes region=0 index=4 name=waveamdmachine.v_lshl_add_u32 class=Write32Bit fu=VALU latency=5
// CLASS: waveamd-machine-schedule-report op func=fused_integer_classes region=0 index=5 name=waveamdmachine.v_add_lshl_u32 class=Write32Bit fu=VALU latency=5
// CLASS: waveamd-machine-schedule-report op func=fused_integer_classes region=0 index=6 name=waveamdmachine.v_and_or_b32 class=Write32Bit fu=VALU latency=5
// CLASS: waveamd-machine-schedule-report op func=fused_integer_classes region=0 index=7 name=waveamdmachine.v_or3_b32 class=Write32Bit fu=VALU latency=5
// CLASS: waveamd-machine-schedule-report op func=fused_integer_classes region=0 index=8 name=waveamdmachine.v_xad_u32 class=Write32Bit fu=VALU latency=5
// CLASS: waveamd-machine-schedule-report score func=fused_integer_classes region=0 order=original cycles=40 issued_ops=8

// BASE: waveamd-machine-schedule-report score func=mad_chain region=0 order=original cycles=16 issued_ops=4

// FUSED: waveamd-machine-schedule-report op func=mad_chain region=0 index=3 name=waveamdmachine.v_mad_u32_u24 class=Write32Bit fu=VALU latency=5
// FUSED: waveamd-machine-schedule-report score func=mad_chain region=0 order=original cycles=11 issued_ops=3
