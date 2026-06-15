// RUN: wave-sim-report --func=exec_if_region --timeline %s | FileCheck %s

module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx1100"} {
  func.func @exec_if_region(%cond: !waveamdmachine.reg<sgpr, 1>,
                            %a: !waveamdmachine.reg<vgpr, 1>,
                            %b: !waveamdmachine.reg<vgpr, 1>) {
    %r = waveamdmachine.exec_if %cond {
      %then = waveamdmachine.v_add_u32 %a, %b
          : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>)
          -> !waveamdmachine.reg<vgpr, 1>
      waveamdmachine.yield %then : !waveamdmachine.reg<vgpr, 1>
    } otherwise {
      %else = waveamdmachine.v_add_u32 %b, %a
          : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>)
          -> !waveamdmachine.reg<vgpr, 1>
      waveamdmachine.yield %else : !waveamdmachine.reg<vgpr, 1>
    } : !waveamdmachine.reg<sgpr, 1> -> !waveamdmachine.reg<vgpr, 1>
    %use = waveamdmachine.v_add_u32 %r, %a
        : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>)
        -> !waveamdmachine.reg<vgpr, 1>
    return
  }
}

// CHECK: func: exec_if_region
// CHECK: issued_ops: 8
// CHECK: issue cycle=0 wave=0 simd=0 fu=SALU op=waveamdmachine.exec_if
// CHECK: issue cycle=1 wave=0 simd=0 fu=BRANCH op=waveamdmachine.exec_if
// CHECK: issue cycle=2 wave=0 simd=0 fu=VALU op=waveamdmachine.v_add_u32
// CHECK: value_ready cycle=7 wave=0 simd=0 op=waveamdmachine.yield
// CHECK: issue cycle=8 wave=0 simd=0 fu=BRANCH op=waveamdmachine.exec_if
// CHECK: issue cycle=9 wave=0 simd=0 fu=VALU op=waveamdmachine.v_add_u32
// CHECK: issue cycle=14 wave=0 simd=0 fu=SALU op=waveamdmachine.exec_if
// CHECK: value_ready cycle=14 wave=0 simd=0 op=waveamdmachine.yield
// CHECK: issue cycle=15 wave=0 simd=0 fu=VALU op=waveamdmachine.v_add_u32
