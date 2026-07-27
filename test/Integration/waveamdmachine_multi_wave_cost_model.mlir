// RUN: wave-sim-report --waves-per-simd=2 --timeline %s | FileCheck %s
// RUN: wave-sim-report --func=mfma_packed_coissue --arch=gfx950 \
// RUN:   --waves-per-simd=2 --timeline %s | FileCheck %s --check-prefix=PACKED
// RUN: wave-sim-report --func=mfma_scalar_coissue --arch=gfx950 \
// RUN:   --waves-per-simd=2 --timeline %s | FileCheck %s --check-prefix=SCALAR

module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx1100"} {
  func.func @multi_wave_model(%init: !waveamdmachine.reg<sgpr, 1>) {
    %step = waveamdmachine.imm 1 : !waveamdmachine.imm
    %a:2 = waveamdmachine.s_add_i32 %init, %step :
        (!waveamdmachine.reg<sgpr, 1>, !waveamdmachine.imm) ->
        (!waveamdmachine.reg<sgpr, 1>, !waveamdmachine.reg<scc, 1>)
    %b:2 = waveamdmachine.s_add_i32 %a#0, %step :
        (!waveamdmachine.reg<sgpr, 1>, !waveamdmachine.imm) ->
        (!waveamdmachine.reg<sgpr, 1>, !waveamdmachine.reg<scc, 1>)
    return
  }

  func.func @mfma_packed_coissue(
      %a: !waveamdmachine.reg<vgpr, 4>,
      %b: !waveamdmachine.reg<vgpr, 4>,
      %acc: !waveamdmachine.reg<vgpr, 16>,
      %x: !waveamdmachine.reg<vgpr, 2>,
      %y: !waveamdmachine.reg<vgpr, 2>) {
    %mfma = waveamdmachine.mfma_f32_32x32x16_f16 %a, %b, %acc
        : (!waveamdmachine.reg<vgpr, 4>, !waveamdmachine.reg<vgpr, 4>,
           !waveamdmachine.reg<vgpr, 16>)
          -> !waveamdmachine.reg<vgpr, 16>
    %packed = waveamdmachine.v_pk_add_f32 %x, %y
        : (!waveamdmachine.reg<vgpr, 2>, !waveamdmachine.reg<vgpr, 2>)
          -> !waveamdmachine.reg<vgpr, 2>
    return
  }

  func.func @mfma_scalar_coissue(
      %a: !waveamdmachine.reg<vgpr, 4>,
      %b: !waveamdmachine.reg<vgpr, 4>,
      %acc: !waveamdmachine.reg<vgpr, 16>,
      %x: !waveamdmachine.reg<vgpr, 1>,
      %y: !waveamdmachine.reg<vgpr, 1>) {
    %mfma = waveamdmachine.mfma_f32_32x32x16_f16 %a, %b, %acc
        : (!waveamdmachine.reg<vgpr, 4>, !waveamdmachine.reg<vgpr, 4>,
           !waveamdmachine.reg<vgpr, 16>)
          -> !waveamdmachine.reg<vgpr, 16>
    %scalar = waveamdmachine.v_add_f32 %x, %y
        : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>)
          -> !waveamdmachine.reg<vgpr, 1>
    return
  }
}

// CHECK: waves_per_simd: 2
// CHECK: resident_waves: 4
// CHECK: total_cycles: 5
// CHECK: issued_ops: 8
// CHECK-DAG: issue cycle=0 wave=0 simd=0 fu=SALU
// CHECK-DAG: issue cycle=0 wave=2 simd=1 fu=SALU
// CHECK-DAG: issue cycle=1 wave=1 simd=0 fu=SALU
// CHECK-DAG: issue cycle=1 wave=3 simd=1 fu=SALU

// PACKED: func: mfma_packed_coissue
// PACKED: issue cycle=0 wave=0 simd=0 fu=MFMA_XDL op=waveamdmachine.mfma_f32_32x32x16_f16
// PACKED: issue cycle=8 wave=1 simd=0 fu=MFMA_XDL op=waveamdmachine.mfma_f32_32x32x16_f16
// PACKED: issue cycle=16 wave=0 simd=0 fu=VALU op=waveamdmachine.v_pk_add_f32

// SCALAR: func: mfma_scalar_coissue
// SCALAR: issue cycle=0 wave=0 simd=0 fu=MFMA_XDL op=waveamdmachine.mfma_f32_32x32x16_f16
// SCALAR: issue cycle=4 wave=0 simd=0 fu=VALU op=waveamdmachine.v_add_f32
// SCALAR: issue cycle=8 wave=1 simd=0 fu=MFMA_XDL op=waveamdmachine.mfma_f32_32x32x16_f16
