// RUN: wave-sim-report --func=packed_classes --op-latencies %s | FileCheck %s

module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx1100"} {
  func.func @packed_classes(%a: !waveamdmachine.reg<vgpr, 1>,
                            %b: !waveamdmachine.reg<vgpr, 1>,
                            %c: !waveamdmachine.reg<vgpr, 1>) {
    %pk = waveamdmachine.v_cvt_pk_rtz_f16_f32 %a, %b
        : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>)
          -> !waveamdmachine.reg<vgpr, 1>
    %add = waveamdmachine.v_pk_add_f16 %pk, %a
        : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>)
          -> !waveamdmachine.reg<vgpr, 1>
    %mul = waveamdmachine.v_pk_mul_f16 %add, %pk
        : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>)
          -> !waveamdmachine.reg<vgpr, 1>
    %fma = waveamdmachine.v_pk_fma_f16 %mul, %add, %c
        : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>,
           !waveamdmachine.reg<vgpr, 1>) -> !waveamdmachine.reg<vgpr, 1>
    return
  }
}

// CHECK: op=waveamdmachine.v_cvt_pk_rtz_f16_f32 class=Write32Bit fu=VALU
// CHECK: op=waveamdmachine.v_pk_add_f16 class=Write32Bit fu=VALU
// CHECK: op=waveamdmachine.v_pk_mul_f16 class=Write32Bit fu=VALU
// CHECK: op=waveamdmachine.v_pk_fma_f16 class=Write32Bit fu=VALU
