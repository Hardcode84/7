// RUN: wave-opt %s --waveamd-machine-schedule-report='print-classes=1 print-score=1' 2>&1 | FileCheck %s

module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx1100"} {

func.func @bit_count_schedule(%v: !waveamdmachine.reg<vgpr, 1>,
                              %s: !waveamdmachine.reg<sgpr, 1>,
                              %p: !waveamdmachine.reg<sgpr, 2>) {
  %vclz = waveamdmachine.v_ffbh_u32 %v
      : (!waveamdmachine.reg<vgpr, 1>) -> !waveamdmachine.reg<vgpr, 1>
  %vctz = waveamdmachine.v_ffbl_b32 %vclz
      : (!waveamdmachine.reg<vgpr, 1>) -> !waveamdmachine.reg<vgpr, 1>
  %sclz = waveamdmachine.s_flbit_i32_b32 %s
      : (!waveamdmachine.reg<sgpr, 1>) -> !waveamdmachine.reg<sgpr, 1>
  %sctz = waveamdmachine.s_ff1_i32_b64 %p
      : (!waveamdmachine.reg<sgpr, 2>) -> !waveamdmachine.reg<sgpr, 1>
  return
}

// CHECK: waveamd-machine-schedule-report op func=bit_count_schedule region=0 index=0 name=waveamdmachine.v_ffbh_u32 class=Write32Bit fu=VALU
// CHECK: waveamd-machine-schedule-report op func=bit_count_schedule region=0 index=1 name=waveamdmachine.v_ffbl_b32 class=Write32Bit fu=VALU
// CHECK: waveamd-machine-schedule-report op func=bit_count_schedule region=0 index=2 name=waveamdmachine.s_flbit_i32_b32 class=WriteSALU fu=SALU
// CHECK: waveamd-machine-schedule-report op func=bit_count_schedule region=0 index=3 name=waveamdmachine.s_ff1_i32_b64 class=WriteSALU fu=SALU
// CHECK: waveamd-machine-schedule-report score func=bit_count_schedule region=0 order=original cycles={{[0-9]+}} issued_ops=4

}
